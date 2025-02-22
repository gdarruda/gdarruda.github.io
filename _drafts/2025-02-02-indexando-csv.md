---
layout: post
title: "Criando índices (em Rust)"
comments: true
mathjax: true
description: "Explicando como funcionam índices em um banco de dados"
---

O meu livro técnico favorito é [Designing Data-Intensive Applications](https://www.amazon.com.br/Designing-Data-Intensive-Applications-Martin-Kleppmann/dp/1449373321) do Martin Kleppmann. Apesar de ser relativamente antigo, ele trata mais do aspecto teórico que prático, continua sendo uma ótima leitura para engenheiros de dados e profissionais que precisam lidar com sistemas de larga escala.

Em uma entrevista recente com o autor – quando perguntado sobre dicas para um aspirante a engenheiros de dados – concordei plenamente com [esse conselho](https://youtu.be/P-9FwZxO1zE?si=42wwf1Pan7BG5bM2&t=1529):

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what's going on there. You don't need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that [...] if the the performance goes bad, you have a way of visualizing in your head what's going on. [...]. It's incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Uma das primeiras vezes, que entendi o valor de construir esses modelo mentais, foi quando aprendi como funcionam os índices em um banco de dados. Passei a lidar muito melhor com problemas de performance em consultas, aprendi a ler um plano de execução e consegui otimizar consultas que outras pessoas não conseguiam.

A solução mais comum para índices são as [árvores B](https://www.youtube.com/shorts/Ah_LMYqd2CE), esse tipo de estrutura é utilizada por diversos tipos de banco de dados: desde o SQLite, passando pelo Oracle Database e até mesmo em soluções distribuídas como o Dynamo DB.

Sendo uma estrutura tão prevalente em soluções de dados, acho importante que todo engenheiro de dados tenha uma noção de como elas funcionam. Como eu queria brincar um pouco com Rust, achei que era um bom exercício implementar uma árvore B na linguagem e escrever um pouco sobre.

## O que é uma árvore B?

As árvores B são uma generalização das árvores binárias: ao invés de ter uma chave por nó, são $$ k $$ chaves por nós. Ela foi criada na década de 70 para lidar com dados persistentes, em um cenário que a memória era escassa e a forma mais comum de armazenamento durável era o disco rígido.

Atualmente temos fartura de memória e o armazenamento em SSD é muito mais rápido, estruturas como [LSM Trees](https://en.wikipedia.org/wiki/Log-structured_merge-tree) foram desenvolvidas para essa nova realidade. Faz sentido para soluções totalmente focadas em performance e escalabilidade como o [Cassandra](https://cassandra.apache.org/_/case-studies.html), mas algo que eu aprendi após anos trabalho com Big Data: soluções com uso intenstivo de memória são excepcionais em performance, mas podem incorrer em muitos problemas na falta dela.

As ávores B não geram pressão em memória, são flexíveis como uma árvore binária (*e.g.* uso de chaves parcias, buscas por $$ >$$ ,  $$ < $$ e $$= $$ e ordenação física) e seu desempenho é suficiente para muitos casos de uso. Apesar de ser uma estrutura com mais de 50 anos, segue sendo utilizado em novas soluções de dados.

Não faz muito sentido eu fazer mais uma explicação de como elas funcionam, porque existem infinitos materias sobre o assunto e nos mais diversos formatos: [aulas online](https://www.youtube.com/watch?v=5mC6TmviBPE), [vídeos do Akita](https://www.youtube.com/watch?v=9GdesxWtOgs&t=1218s), [blog posts](https://planetscale.com/blog/btrees-and-database-indexes) e [livros de algoritmos](https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/).

É mais importante que o leitor procure esses materiais para entender sobre a estrutura, do que se preocupar em ler o restante do post: eu fiz para meu próprio entretenimento, não como algo útil ou didático necessariamente.

Para fazer a minha implementação, revi o assunto no famoso livro [Introduction to Algorithms](https://www.amazon.com/Introduction-Algorithms-3rd-MIT-Press/dp/0262033844) e copiei a implementação exatamente como está proposto nele. Como queria apenas brincar, eu implementei apenas a parte de inserção e busca, indexando arquivos no formato csv.

## A estrutura da estrutura

Para implementar estrutura de dados, normalmente começo imaginando a sub-estruturas que vou precisar e só depois passo para a manipulação. Para criação da árvore B, eu utilizei três estruturas: `BTree`, `Node` e `Key`.

### BTree

A `BTree` é a estrutura que será a interface pública que será utilizada pelos demais processos, contendo três campos:

* `root` contendo o nó raíz por onde serão iniciadas as buscas;
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

O `Node` é a estrutura mais importante, estrutura que armazena e organiza as chaves de forma que as buscas possam ser feita em $$ log(N) $$. É composta pelos seguintes campos:

* `key` é um vetor contendo as chaves do nó ordenadas;
* `children` é um vetor contendo os filhos de cada chave;
* `leaf` indica se é um nó folha, informação importante para tratar casos especiais de inclusão;
* `filename` é o diretório completo em que esse nó é armazenado.

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

* `value` é o valor da chave propriamente dito, optei por deixar como `String` por simplicidade, ao invés de usar genéricos ou um tipo mais agnóstico como um vetor de bytes.

* `position` é uma tupla com a posição da chave dentro do arquivo csv, o primeiro campo é o *offset* no arquivo e a segunda é a quantidade de bytes do conteúdo.

```rust
pub struct Key {
    pub value: String,
    pub position: (u64, u64),
}
```