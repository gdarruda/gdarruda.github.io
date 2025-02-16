---
layout: post
title: "Criando índices (em Rust)"
comments: true
mathjax: true
description: "Explicando como funcionam índices em um banco de dados"
---

O meu livro técnico favorito é [Designing Data-Intensive Applications](https://www.amazon.com.br/Designing-Data-Intensive-Applications-Martin-Kleppmann/dp/1449373321) do Martin Kleppmann. Apesar de ser relativamente antigo, ele trata mais do aspecto teórico que práticos, então segue muito útil e atualizado para engenheiros de dados e qualquer profissional que trabalhe com sistemas de larga escala.

Em uma entrevista recente, discutindo o que ele sugere para um aspirante a engenheiros de dados, eu concordei plenamente com [esse conselho](https://youtu.be/P-9FwZxO1zE?si=42wwf1Pan7BG5bM2&t=1529):

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what's going on there. You don't need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that [...] if the the performance goes bad, you have a way of visualizing in your head what's going on. [...]. It's incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Uma das primeiras vezes que entendi o valor de ter esse modelo mental, foi quando aprendi que os índices do banco de dados são uma árvore B. Consegui lidar muito melhor com problemas de performance das consultas, conseguir entender um plano de execução e otimizar consultas complexas.

As árvores B foram [criadas em 1970](https://en.wikipedia.org/wiki/B-tree) e são utilizadas por diversas soluções: desde o SQLite, passando pelo Oracle Database e até mesmo em soluções distribuídas como o Dynamo DB. Sendo uma solução tão perene, acho importante que todo engenheiro de dados tenha uma noção de como elas funcionam.

Queria brincar um pouco com Rust, achei que era um bom exercício implementar uma árvore B para indexar arquivos csv.

## O que é uma árvore B?

As árvores B sãp uma generalização das árvores binárias: ao invés de ter uma chave por nó, são $$ k $$ nós por chave. Ela foi criada para lidar com dados persistentes, em um cenário que a memória era escassa e o armzanemamentos era em disco rígido.

Hoje temos muito mais memória e o armazenamento em SSDs virou o padrão, estruturas como [LSM Trees](https://en.wikipedia.org/wiki/Log-structured_merge-tree) foram desenvolvidas para essa nova realidade. Faz sentido para soluções totalmente focadas em performance e escalabilidade como o [Cassandra](https://cassandra.apache.org/_/case-studies.html), mas algo que eu aprendi após anos trabalho com Big Data: soluções com uso intenstivo de memória são excepcionais em performance, mas podem incorrer em muitos problemas na falta dela.

As ávores B não geram pressão em memória, são flexíveis como uma árvore binária (*e.g.* uso de chaves parcias, buscas por $$ >$$ ,  $$ < $$ e $$= $$ e ordenação física) e seu desempenho atende muitos casos de uso. Apesar de ter mais de 50 anos, segue sendo utilizado em novas soluções de dados.

Sinto que não faz muito sentido eu fazer mais uma explicação de como elas funcionam, porque existem infinitos materias sobre o assunto e nos mais diversos formatos: aulas online, vídeo do Akita, blog posts de empresas e livros de algoritmos.

Acho mais importante que o leitor procure esses materiais para entender sobre a estrutura, do que se preocupar em ler o restante do post: eu fiz para meu próprio entretenimento, não como algo útil ou didático necessariamente.

Para fazer a minha implementação, revi o assunto no famoso livro [Introduction to Algorithms](https://www.amazon.com/Introduction-Algorithms-3rd-MIT-Press/dp/0262033844) e copiei a implementação exatamente como está proposto nele. Como queria apenas brincar, eu implementei apenas a parte de inserção e busca, indexando arquivos no formato csv.

