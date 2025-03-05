---
layout: post
title: "O que é um índice?"
comments: true
mathjax: true
description: "Explicando como funcionam índices em um banco de dados"
---

O meu livro técnico favorito é o [Designing Data-Intensive Applications](https://www.amazon.com.br/Designing-Data-Intensive-Applications-Martin-Kleppmann/dp/1449373321) do Kleppmann. Apesar de ser relativamente antigo, como ele trata mais do aspecto teórico que prático, continua sendo uma ótima leitura para engenheiros de dados e profissionais que precisam lidar com sistemas de larga escala.

Em uma entrevista recente com o autor – quando perguntado sobre dicas para um aspirante a engenheiros de dados – concordei plenamente com [esse conselho](https://youtu.be/P-9FwZxO1zE?si=42wwf1Pan7BG5bM2&t=1529):

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what's going on there. You don't need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that [...] if the the performance goes bad, you have a way of visualizing in your head what's going on. [...]. It's incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Uma das primeiras vezes, que entendi o valor de construir esses modelo mentais, foi quando aprendi sobre índices de banco de dados. Passei a entender melhor o [plano de execução](https://en.wikipedia.org/wiki/Query_plan), quando a criação de um índice fazia sentido e otimizei consultas que outras pessoas não estavam conseguindo.

A solução mais comum para índices são as [árvores B](https://www.youtube.com/shorts/Ah_LMYqd2CE), esse tipo de estrutura é utilizada por diversos tipos de banco de dados: desde o SQLite, passando pelo Oracle Database e até mesmo em soluções distribuídas como o Dynamo DB.

Sendo uma estrutura tão prevalente em soluções de dados, acho importante que todo engenheiro de dados tenha uma noção de como elas funcionam, construir esse modelo mental que Kleppmann comentou. Como eu queria brincar um pouco com Rust, achei que era um bom exercício implementar uma árvore B na linguagem e escrever um pouco sobre.

## O que é uma árvore B?

As árvores B são uma generalização das árvores binárias: ao invés de ter uma chave por nó, são $$ k $$ chaves por nós. Ela foi criada na década de 70 para lidar com dados persistentes, em um época em que a memória era escassa e a forma mais comum de armazenamento durável era o disco rígido. Atualmente temos fartura de memória e armazenamento em SSD, estruturas como [LSM Trees](https://en.wikipedia.org/wiki/Log-structured_merge-tree) foram desenvolvidas pensando nessa nova realidade. 

Em soluções focadas em performance e escalabilidade, como o [Cassandra](https://cassandra.apache.org/_/case-studies.html) por exemplo, faz muito sentido usar estruturas como as LSM Tree. Entretanto, algo que eu aprendi após anos trabalho com "Big Data": soluções com uso intensivo de memória têm performance excepcional, mas podem ficar inutilizáveis em cenários de escassez da mesma.

As ávores B não geram pressão em memória; são flexíveis como uma árvore binária (*e.g.* possibilidade de chaves parcias; suporte a múltiplos operadores  de busca($$ >$$, $$ < $$ e $$= $$); dado pré-ordenado fisicamente e seu desempenho é suficiente para muitos casos de uso. Apesar de ser uma estrutura com mais de 50 anos desenvolvida em um cenário diferente do atual, segue sendo popular em novas soluções de dados.

Não faz muito sentido eu fazer mais uma explicação de como elas funcionam, porque existem infinitos materias sobre o assunto e nos mais diversos formatos: [aulas online](https://www.youtube.com/watch?v=5mC6TmviBPE), [vídeos do Akita](https://www.youtube.com/watch?v=9GdesxWtOgs&t=1218s), [blog posts](https://planetscale.com/blog/btrees-and-database-indexes) e [livros de algoritmos](https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/). É mais importante que o leitor procure esses materiais para entender sobre a estrutura, do que se preocupar em ler o restante do post: eu fiz para meu próprio entretenimento, não como algo útil ou didático necessariamente.

Para fazer a implementação em Rust, revi o assunto no famoso livro [Introduction to Algorithms](https://www.amazon.com/Introduction-Algorithms-3rd-MIT-Press/dp/0262033844) e fiz praticamente uma cópia de do proposto no livro. Implementei apenas a parte de inserção e busca, usando a estrutura para indexar arquivos no formato csv.

## A estrutura da estrutura

Ao implementar uma estrutura de dados, normalmente começo imaginando as sub-estruturas que vou precisar e só depois penso na manipulação. Para essa implementação da árvore B, utilizei três sub-estruturas: `BTree`, `Node` e `Key`.

### BTree

A `BTree` é a estrutura pública, que será utilizada pelas outras aplicações, contendo três campos:

* `root` é o nó raíz por onde serão iniciadas as buscas;
* `order` indica a quantidade de nós máximos que uma árvore pode conter;
* `path` é o diretório em que os dados da árvore serão armazenados.

```rust
pub struct BTree {
    root: Node,
    order: usize,
    path: String,
}
```

### Node

O `Node` é a estrutura mais importante, que armazena e organiza as chaves de forma que as buscas possam ser feita em $$ log(N) $$. É composta pelos seguintes campos:

* `key` é um vetor contendo as chaves ordenadas;
* `children` é um vetor contendo os filhos de cada chave;
* `leaf` indica se o nó é uma folha, informação importante para tratar casos especiais de inclusão;
* `filename` é o nome do arquivo em que esse nó é armazenado.

```rust
pub struct Node {
    pub keys: Vec<Key>,
    pub children: Vec<String>,
    pub leaf: bool,
    pub filename: String,
}
```

### Key

A estrutura `Key` é a mais simples, contendo apenas dois campos:

* `value` é o valor da chave propriamente dito, optei por deixar como `String` por simplicidade de implementação. Em uma solução produtiva, seria interessante ter algo mais flexível como um vetor de Bytes ou utilizando genéricos.

* `position` é uma tupla com a posição da chave dentro do arquivo csv, o primeiro campo é o *offset* no arquivo e a segunda é a quantidade de bytes para ser lido a partir do *offset*.

```rust
pub struct Key {
    pub value: String,
    pub position: (u64, u64),
}
```

## Criando a árvore

A busca em árvore costuma ser algo simples, a complexidade é maior para criação e manutenção. Optei por fazer apenas a inserção, que é o mínimo necessário para criar uma árvore funcional.

A inclusão na árvore é feito pela função `insert`, associada ao objeto `Btree`. A lógica de inclusão é feita pelo objeto `Node`, mas antes existe um desvio para o cenário em que o nó raiz está cheio.

```rust

pub fn is_full(&self, order: usize) -> bool {
    self.keys.len() == 2 * order - 1
}

pub fn insert(&mut self, key: Key) {
    if self.root.is_full(self.order) {
        let mut new_root = Node::empty(self.order, false, &self.path);
        new_root.children.push(self.root.clone().filename);
        new_root.split(0, self.order, &self.path);
        self.root = new_root;
    }

    self.root.insert(key, self.order, &self.path);
    self.save();
}
```

Se o nó da raiz estiver cheio, um nó vazio é criado e a raiz vira filho desse novo nó. Após tratar esse caso específico, a inserção do registro é feito pela função `insert` na estrutura `Node`:

```rust

fn find_position(&self, key: &Key) -> usize {
    let mut idx = 0;

    for (i, iter_key) in self.keys.iter().enumerate() {
        idx = i;
        if iter_key.value > key.value {
            break;
        }
    }

    if idx + 1 == self.keys.len() {
        if key.value > self.keys[idx].value {
            idx += 1;
        }
    }

    idx
}

pub fn insert(&mut self, key: Key, order: usize, path: &str) {
    if self.leaf {
        self.add_key(self.find_position(&key), key.clone());
    } else {
        let mut idx = self.find_position(&key);

        if Node::load(&self.children[idx]).is_full(order) {
            self.split(idx, order, path);
            idx = self.find_position(&key);
        }

        Node::load(&self.children[idx]).insert(key, order, path);
    }
}
```

A função `add_key` assume que o nó tem espaço e não precisa ser separado em múltiplos. Se for um nó folha, essa função é chamada diretamente na posição definida por `find_position`. Caso contrário, o nó filho em que a chave será inserida é procurada pela mesma função `find_position`, esse nó filho é separado em dois caso esteja cheio.

Para separar um nó, a chave central do nó é usada como referência. No caso abaixo, a chave `S` vai para o nó superior, os filhos à esquerda permanecem no nó original e os filhos à direita são movidos para um novo nó.

<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 497 186" width="700" height="200"><!-- svg-source:excalidraw --><metadata></metadata><defs><style class="style-fonts">
      @font-face { font-family: Excalifont; src: url(data:font/woff2;base64,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); }</style></defs><rect x="0" y="0" width="497" height="186" fill="#ffffff"></rect><g stroke-linecap="round" transform="translate(32 10) rotate(0 59 28)"><path d="M14 0 C37.71 2.5, 65.62 -1, 104 0 M14 0 C36.28 0.01, 57.91 -1.12, 104 0 M104 0 C111.88 -0.93, 116.77 5.42, 118 14 M104 0 C111.51 1.63, 119.43 2.75, 118 14 M118 14 C119.83 21.63, 118.69 27.26, 118 42 M118 14 C117.52 20.85, 118.26 27.52, 118 42 M118 42 C119.97 50.14, 112.35 56.53, 104 56 M118 42 C115.94 49.43, 115.26 56.06, 104 56 M104 56 C78.39 56.98, 50.96 57.12, 14 56 M104 56 C69.99 56.33, 37.38 56.07, 14 56 M14 56 C5.97 56.06, 0.57 50.2, 0 42 M14 56 C5.24 56.83, 0.37 52.71, 0 42 M0 42 C1.26 34.95, -0.69 25.88, 0 14 M0 42 C0.71 35.7, 0.26 27.23, 0 14 M0 14 C-1.94 6.28, 6.54 -0.5, 14 0 M0 14 C-1.27 3.51, 4.94 0.75, 14 0" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(48.3799934387207 25.5) rotate(0 42.6200065612793 12.5)"><text x="42.6200065612793" y="17.619999999999997" font-family="Excalifont, Xiaolai, Segoe UI Emoji" font-size="20px" fill="#1e1e1e" text-anchor="middle" style="white-space: pre;" direction="ltr" dominant-baseline="alphabetic">... N W ...</text></g><g stroke-linecap="round" transform="translate(315 10) rotate(0 70.5 28)"><path d="M14 0 C44.89 -1.08, 73.51 -1.61, 127 0 M14 0 C51.76 0.79, 89.89 1.46, 127 0 M127 0 C137.95 0.48, 139.27 5.91, 141 14 M127 0 C134.13 1.15, 141.22 3.96, 141 14 M141 14 C139.83 21.63, 141.82 28.4, 141 42 M141 14 C141.12 21.88, 141.51 29.27, 141 42 M141 42 C140.74 50.7, 134.61 57.33, 127 56 M141 42 C140.62 51.42, 135.05 55.14, 127 56 M127 56 C98.01 55.54, 66.69 56.81, 14 56 M127 56 C84.63 56.67, 43 55.48, 14 56 M14 56 C4.76 57.72, -1.15 50.12, 0 42 M14 56 C6.9 56.7, -0.81 53.26, 0 42 M0 42 C2.07 34.48, 2.08 30.33, 0 14 M0 42 C0.62 35.84, -0.93 29.15, 0 14 M0 14 C1.82 6.4, 3.23 1.7, 14 0 M0 14 C1.48 4.86, 6.93 1.58, 14 0" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(332.6599922180176 25.5) rotate(0 52.84000778198242 12.5)"><text x="52.84000778198242" y="17.619999999999997" font-family="Excalifont, Xiaolai, Segoe UI Emoji" font-size="20px" fill="#1e1e1e" text-anchor="middle" style="white-space: pre;" direction="ltr" dominant-baseline="alphabetic">... N S W ...</text></g><g stroke-linecap="round" transform="translate(10 115) rotate(0 88 30.5)"><path d="M15.25 0 C63.61 0.87, 108.9 -0.12, 160.75 0 M15.25 0 C67.31 1.03, 118.04 1.01, 160.75 0 M160.75 0 C171.72 -1.97, 175.47 6.26, 176 15.25 M160.75 0 C173.07 0.79, 173.92 3.6, 176 15.25 M176 15.25 C175.9 21.92, 177.4 31.4, 176 45.75 M176 15.25 C176.23 21.26, 176.13 27.3, 176 45.75 M176 45.75 C177.03 56.13, 172.77 62.68, 160.75 61 M176 45.75 C174.81 55.51, 169.78 62.86, 160.75 61 M160.75 61 C124.76 63.89, 89.63 60.86, 15.25 61 M160.75 61 C111.63 60.03, 62.24 60.23, 15.25 61 M15.25 61 C5.79 62.36, 1.82 56.24, 0 45.75 M15.25 61 C5.57 62.4, -1.44 55.65, 0 45.75 M0 45.75 C-0.48 40.02, 0.99 30.68, 0 15.25 M0 45.75 C-0.4 36.35, 0.86 26.65, 0 15.25 M0 15.25 C-1.24 6.65, 6.42 1.48, 15.25 0 M0 15.25 C1.89 6.99, 5.78 1.08, 15.25 0" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(23.970001220703125 133) rotate(0 74.02999877929688 12.5)"><text x="74.02999877929688" y="17.619999999999997" font-family="Excalifont, Xiaolai, Segoe UI Emoji" font-size="20px" fill="#1e1e1e" text-anchor="middle" style="white-space: pre;" direction="ltr" dominant-baseline="alphabetic">P Q R S T U V</text></g><g stroke-linecap="round" transform="translate(286 108) rotate(0 38 30.5)"><path d="M15.25 0 C26.64 2.2, 35.43 -0.02, 60.75 0 M15.25 0 C30.3 -0.13, 42.88 0.26, 60.75 0 M60.75 0 C69 1, 76.19 4.47, 76 15.25 M60.75 0 C69.41 0.58, 74.64 3.66, 76 15.25 M76 15.25 C75.25 24.8, 74.65 37.37, 76 45.75 M76 15.25 C76.08 26.17, 75.34 38.4, 76 45.75 M76 45.75 C75.67 56, 69.8 60.25, 60.75 61 M76 45.75 C75.12 55.4, 71.54 61.69, 60.75 61 M60.75 61 C50.34 59.51, 37.13 61.08, 15.25 61 M60.75 61 C44.6 61.57, 27.79 60.11, 15.25 61 M15.25 61 C7.03 61.61, -0.71 57.59, 0 45.75 M15.25 61 C3.41 58.89, 1.41 58.01, 0 45.75 M0 45.75 C-1.6 38.1, -2.2 32.12, 0 15.25 M0 45.75 C1.21 36.27, -0.42 25.91, 0 15.25 M0 15.25 C1.29 5.26, 7.05 1.37, 15.25 0 M0 15.25 C-0.32 4.89, 6.12 -1.99, 15.25 0" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(293.9799995422363 126) rotate(0 30.020000457763672 12.5)"><text x="30.020000457763672" y="17.619999999999997" font-family="Excalifont, Xiaolai, Segoe UI Emoji" font-size="20px" fill="#1e1e1e" text-anchor="middle" style="white-space: pre;" direction="ltr" dominant-baseline="alphabetic">P Q R</text></g><g stroke-linecap="round" transform="translate(411 108) rotate(0 38 30.5)"><path d="M15.25 0 C30.58 -0.44, 42.98 -0.48, 60.75 0 M15.25 0 C28.82 0.57, 43.7 -1.23, 60.75 0 M60.75 0 C69.23 -1.26, 76.14 3.51, 76 15.25 M60.75 0 C69.89 -0.38, 78.21 5.3, 76 15.25 M76 15.25 C75.76 25.53, 76.06 39.74, 76 45.75 M76 15.25 C76.33 22.8, 76.3 28.4, 76 45.75 M76 45.75 C74.41 56.98, 69.17 59.9, 60.75 61 M76 45.75 C76.25 53.85, 71.95 58.71, 60.75 61 M60.75 61 C48.01 61.61, 36.42 60.88, 15.25 61 M60.75 61 C46.36 61.21, 30.23 60.2, 15.25 61 M15.25 61 C4.93 60.31, 1.83 54.29, 0 45.75 M15.25 61 C7.08 62.25, 0.98 54.7, 0 45.75 M0 45.75 C1.28 36.51, 0.78 27.2, 0 15.25 M0 45.75 C-0.6 34.34, -0.01 22.33, 0 15.25 M0 15.25 C-0.3 5.28, 5.82 0.5, 15.25 0 M0 15.25 C2.17 4.25, 5.13 -0.43, 15.25 0" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(419.2100009918213 126) rotate(0 29.78999900817871 12.5)"><text x="29.78999900817871" y="17.619999999999997" font-family="Excalifont, Xiaolai, Segoe UI Emoji" font-size="20px" fill="#1e1e1e" text-anchor="middle" style="white-space: pre;" direction="ltr" dominant-baseline="alphabetic">T U V</text></g><g stroke-linecap="round"><g transform="translate(92 67.5) rotate(0 1.1889074526092145 23.25)"><path d="M0.01 -0.16 C0.46 7.53, 2.21 38.44, 2.55 46.29 M-0.65 -0.71 C-0.25 7.04, 1.84 39.08, 2.21 46.89" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(92 67.5) rotate(0 1.1889074526092145 23.25)"><path d="M-6.99 25.5 C-4.69 31.77, -2.22 36.86, 2.21 46.89 M-6.99 25.5 C-3.59 33.31, -0.19 42.31, 2.21 46.89" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(92 67.5) rotate(0 1.1889074526092145 23.25)"><path d="M8.9 24.59 C6.79 31.11, 4.84 36.45, 2.21 46.89 M8.9 24.59 C6.18 32.8, 3.46 42.16, 2.21 46.89" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g></g><mask></mask><g stroke-linecap="round"><g transform="translate(365.55828232856084 67.5) rotate(0 -20.412556225982314 18.25)"><path d="M0.49 -0.32 C-6.25 5.74, -34.05 30.36, -40.95 36.57 M0.08 0.71 C-6.7 6.85, -34.56 31.41, -41.44 37.31" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(365.55828232856084 67.5) rotate(0 -20.412556225982314 18.25)"><path d="M-29.35 15.43 C-32.41 19.82, -34.21 24.53, -41.44 37.31 M-29.35 15.43 C-34.3 24.09, -38.95 32.36, -41.44 37.31" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(365.55828232856084 67.5) rotate(0 -20.412556225982314 18.25)"><path d="M-18.11 28.32 C-23.53 30.07, -27.68 32.1, -41.44 37.31 M-18.11 28.32 C-27.39 32.08, -36.32 35.44, -41.44 37.31" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g></g><mask></mask><g stroke-linecap="round"><g transform="translate(172 70.5) rotate(0 54 0.5)"><path d="M0.5 -0.7 C18.4 -0.45, 90.05 1.52, 107.93 1.83 M-0.69 1.54 C16.99 1.44, 89.01 -0.03, 106.94 0.14" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(172 70.5) rotate(0 54 0.5)"><path d="M83.51 8.86 C90.41 5.63, 101.05 2.35, 106.94 0.14 M83.51 8.86 C90.87 5.98, 98.76 2.81, 106.94 0.14" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(172 70.5) rotate(0 54 0.5)"><path d="M83.38 -8.24 C90.37 -5.56, 101.05 -2.94, 106.94 0.14 M83.38 -8.24 C90.93 -5.78, 98.86 -3.61, 106.94 0.14" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g></g><mask></mask><g stroke-linecap="round"><g transform="translate(403 68.5) rotate(0 22.5 18.5)"><path d="M-0.55 -0.3 C6.96 5.99, 37.52 31.12, 45.09 37.36 M0.17 0.74 C7.61 6.9, 37.32 30.4, 44.7 36.58" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(403 68.5) rotate(0 22.5 18.5)"><path d="M21.07 28.42 C27.82 31.22, 36.34 33.36, 44.7 36.58 M21.07 28.42 C28.79 30.7, 36.46 34.16, 44.7 36.58" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g><g transform="translate(403 68.5) rotate(0 22.5 18.5)"><path d="M31.84 15.14 C35.21 22, 40.39 28.26, 44.7 36.58 M31.84 15.14 C36.06 21.71, 40.22 29.51, 44.7 36.58" stroke="#1e1e1e" stroke-width="2" fill="none"></path></g></g><mask></mask>
</svg>


A função `split` faz esse processo de rotação das chaves, que é realizado antes da inclusão em um nó cheio:

```rust
pub fn split(&mut self, pivot: usize, order: usize, path: &str) {
    let left = &mut Node::load(&self.children[pivot]);
    let key = left.keys[order - 1].clone();

    let right = Node {
        keys: left.keys[order..left.keys.len()].to_owned(),
        children: match left.leaf {
            true => Vec::with_capacity(2 * order),
            false => left.children[order..left.children.len()].to_owned(),
        },
        leaf: left.leaf,
        filename: Node::filename(path),
    };

    right.save();

    left.keys.resize(order - 1, Key::create("", (0, 0)));

    if !left.leaf {
        left.children.resize(order, String::from(""));
    }

    left.save();

    self.keys.insert(pivot, key);
    self.children.insert(pivot + 1, right.filename);

    self.save()
}
```

Em várias momentos, as estruturas são persistidas e lidas do armazenamento, usando as funções `save`e `load` respectivamente. Essas funções serializam e desserializam o objeto `Node` no formato json, usando a biblioteca [serde_json](https://docs.rs/serde_json/latest/serde_json/).

```rust
pub fn save(&self) {
    let mut file = File::create(&self.filename).unwrap();
    file.write_all(serde_json::to_string(self).unwrap().as_bytes())
        .unwrap();
}

pub fn load(filename: &str) -> Node {
    serde_json::from_slice(&fs::read(filename).unwrap()).unwrap()
}
```
Cada nó é salvo em um arquivo com nome aleatório, gerado pela função `filename`: 

```rust
fn filename(path: &str) -> String {
    format!("{}/{}.json", path, Uuid::new_v4().to_string())
}
```

O formato json não é o ideal em termos de performance, mas é legível por humanos e prático para ser utilizado em um código para estudos. Abaixo, um exemplo de nó salvo em disco, gerado pelos testes unitários:

```json
{
    "keys": [
        {
            "value": "9b35db6e-49d9-4d91-b5f6-973b8a9111f4",
            "position": [
                0,
                0
            ]
        },
        {
            "value": "d47fbd93-cb1a-4e01-82b2-4325aa8cb1a3",
            "position": [
                0,
                0
            ]
        }
    ],
    "children": [
        "btree_test_search/d1740cf9-8fa9-471d-9ba6-99ff1462f5c6.json",
        "btree_test_search/9ba9bd01-6b3e-4441-a70b-253c86424cd3.json",
        "btree_test_search/7248b1e6-88f6-4f8e-a07b-0952347adc47.json"
    ],
    "leaf": false,
    "filename": "btree_test_search/1c3df73f-f321-4b3a-a545-9917ad2ecb4e.json"
}
```

## Buscando na árvore

A busca é feito de forma recursiva, como é comum em estruturas de árvore. A função pública `search` da `Btree` tem apenas o parâmetro `value` com o valor da chave a ser procurado, a função `search_tree` é a que de fato realiza a busca recursiva.

```rust
fn search_tree(node: &Node, value: String) -> Option<Key> {
    for (i, key) in node.keys.iter().enumerate() {
        if key.value == value {
            return Some(key.clone());
        } else if key.value > value {
            if node.leaf {
                return None;
            } else {
                return BTree::search_tree(&Node::load(&node.children[i]), value);
            }
        }
    }

    if node.leaf {
        None
    } else {
        BTree::search_tree(&Node::load(&node.children[node.keys.len()]), value)
    }
}

pub fn search(&self, value: &str) -> Option<Key> {
    BTree::search_tree(&self.root, value.to_string())
}
```

Com a busca e a inserção criadas, já temos o mínimo para fazer o indexador.

## Indexando os CSVs

Os [arquivos CSVs](https://en.wikipedia.org/wiki/Comma-separated_values) são muito utilizados para lidar com dados tabulares. A organização física desses arquivos é parecida com de uma tabela em um banco relacional, sendo orientado a linhas e com marcadores utilizados para indetificar início e fim dos campos e registros.

A função `index_file` recebe um arquivo e uma árvore, itera linha-a-linha no arquivo e armazena três informações na árvore: o valor da chave, a posição da linha no arquivo e a quantidade de bytes por linha.

```rust
pub fn index_file(file: &File, tree: &mut BTree) {
    let mut reader = BufReader::new(file);

    let mut buf = String::new();
    let mut offset: u64 = 0;

    loop {
        buf.clear();

        let size: u64 = reader
            .read_line(&mut buf)
            .expect("reading from cursor shouldn't fail")
            .try_into()
            .unwrap();

        if size == 0 {
            break;
        }

        let key_value = match get_key(0, &buf) {
            None => {
                offset += size;
                continue;
            }
            Some(value) => value,
        };

        tree.insert(Key::create(key_value, (offset, size)));
        offset += size;
    }
}
```

Para recuperar as informações do arquivo, a função recebe o arquivo e uma tupla contendo a posição da linha e seu tamanho.

```rust
pub fn read_line(file: &mut File, position: (u64, u64)) -> Result<String, Box<dyn error::Error>> {
    let (start, offset) = position;
    file.seek(SeekFrom::Start(start))?;

    let mut read_buf = vec![0; offset.try_into().unwrap()];
    file.read_exact(&mut read_buf)?;

    match String::from_utf8(read_buf) {
        Err(e) => Err(Box::new(e)),
        Ok(line) => Ok(line),
    }
}
```

## E a performance?

Para testar o indexador, gerei um arquivo CSVs com 10.000.000 de registros e aproximadamente 500MB de tamanho. Abaixo, o script para indexar esse arquivo usando nós de ordem 1.000:

```rust
fn main() -> std::io::Result<()> {

    let filename = "/home/gdarruda/Projects/sandbox/clients.csv";
    let mut file = File::open(filename)?;
    let mut tree = index::btree::BTree::create(1000, "/home/gdarruda/btree_files");
    csv::index_file(&file, &mut tree);

    Ok(())
}
```

Para indexar esse arquivo,foi necessário 3:17 horas, mas não passou de 3MB de consumo total de memória. Um tempo alto de processamento, poderíamos pensar em várias formas de otimização – melhorar serialização; não forçar escrita em disco para cada inlcusão; otimizar os tamanhos dos nós; usar cache – mas esse não é o ponto do exercício proposto.

Olhando para o desempenho da busca – considerando o pior caso, que é procurar e não encontrar um registro – procurando por 1.000 chaves aleatórias não existentes, o tempo médio de busca foi de 474µs com desvio de 26µs.

```rust
fn main() -> std::io::Result<()> {

    let filename = "/home/gdarruda/Projects/sandbox/clients.csv";
    let mut file = File::open(filename)?;
    let tree = index::btree::BTree::load("/home/gdarruda/btree_files");

    for uuid in (0..1000).map(|_| Uuid::new_v4().to_string()) {

        let now = SystemTime::now();

        match tree.search(&uuid) {
            None => {},
            Some(key) => {
                match csv::read_line(&mut file, key.position) {
                    Err(e) => {println!("Error: {}", e)},
                    Ok(line) => {println!("Found line: {}", line)}
                }
            }
        };

        match now.elapsed() {
            Ok(elapsed) => {
                println!("{}", elapsed.as_micros());
            }
            Err(e) => {
                println!("Error: {e:?}");
            }
        }

    }

    Ok(())
}
```

Pode-se pensar em otimizações para essa parte da busca também, mas essa implementação simplória já demonstra a utilidade de uma estrutura como essa para grandes base de dados: boa performance de busca, baixíssimo consumo de memória.

## Por que fazer isso?

Não sou a favor que os programadores fiquem recriando banco de dados e frameworks, porque apesar de ser uma ótima forma de aprender profundamente sobre um tema , provavelmente não é a forma mais eficiente. De qualquer forma, acho fundamental ter uma noção intuitiva de como as coisas funcionam e não focar apenas nas APIs.

Mais importante que entender os detalhes da [minha implementação](https://github.com/gdarruda/csv_indexer), eu gostaria que os programadores conseguissem responder perguntas sobre índices basedos em árvore:

* Se vou ler 50% da tabela, um índice me ajuda? E se for 75%? E se for 5%?
* Índices fazem sentido para armazenamento colunar, como um arquivo parquet por exemplo?
* Quais as vantagens e desvantagens de colocar múltiplas colunas em um único índice?
* Em uma coluna com poucos valores distintos, faz mais sentido usar ela como partição ou criar um índice? Por quê?

Obviamente, todas essas perguntas têm vários "depende" em uma situação real, mas é possível ter uma noção das respostas pelo conhecimento teórico. São perguntas que realmente aparecem no dia-a-dia, escolher a melhor solução de armazenamento costumar ser uma [porta de sentido único](https://www.reddit.com/r/coolguides/comments/18t1a92/a_cool_guide_to_jeff_bezoss_decisionmaking_model/).

Quando eu comecei a carreira, o padrão era usar bancos relacionais, no máximo a discussão era qual deles escolher. Hoje em dia, pode-se recorrer a uma miríade de soluções especializadas para cada caso de uso: desde armazenar dados como arquivos em storage, passando por bancos relacionais e diversos tipos de bancos NoSQL especializados (*e.g.* grafos, chave-valor, documento, MPP).

As soluções especializadas podem ser mais escaláveis e nem sempre usar [Postgres para tudo](https://github.com/Olshansk/postgres_for_everything) é a melhor opção, mas ferramentas especializadas podem ser inutilizáveis quando adaptadas para cenários [fora de seu caso de uso](https://broot.ca/kafka-at-the-low-end.html). Aprender sobre todas as soluções de todos provedores de cloud é inviável, focar em conhecer [os conceitos das ferramentas](https://www.youtube.com/watch?v=yvBR71D0nAQ&t=412s) é melhor que ler infinitos artigos no Medium comparando as soluções em termos de "prós e contras".

