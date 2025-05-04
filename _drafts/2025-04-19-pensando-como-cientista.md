---
layout: post
title: "Pensando como cientistas de dados"
comments: true
mathjax: true
description: "Discussão sobre como tratar problema"
---

Eu tenho o cargo de cientista de dados há anos, mas trabalhei muito pouco com desenvolvimento de modelos e análises descritivas. Gostos dessas atividades, mas sou medíocre nessa parte, conheço várias pessoas que conseguem fazer esse tipo de trabalho tão bem ou melhor que eu. 

Por outro lado, tenho bastante experiência como desenvolvedor, então foco meus esforços em colocar os modelos desenvolvidos por outros cientistas para rodar. Nessa posição, trabalho muito em conjunto com os cientistas de dados, mas atuando como um programador. 

Qualquer desenvolvedor, que precisou colocar em produção um modelo implementado em um arquivo chamado *Untitled (7) Copy.ipynb*, sabe que alguns cientistas precisam aprender muito sobre as práticas de programação. Ao mesmo tempo que ensino tópicos de programação para os cientistas, gosto de pensar como um cientista de dados.

Mesmo que o seu trabalho não tenha nada a ver com dados, como programador faz sentido inspirar no modo de pensar dos cientistas de dados. A ideia desse post é discutir essa perspectiva, especialmente do ponto de vista do aprendizado.

# Saber (somente) a API, não é saber

Um dos meus pontos fracos como cientista de dados, é não ter muita profundidade teórica. Por exemplo, eu tenho a intuição de como um [SVM](https://en.wikipedia.org/wiki/Support_vector_machine) funciona, mas não saberia implementar a otimização e nem entendo as partes mais sofisticadas como o [kernel trick](https://en.wikipedia.org/wiki/Kernel_method#Mathematics:_the_kernel_trick). Apesar de ser um modelo complexo de entender, é muito simples utilizá-lo no [scikit-learn](https://scikit-learn.org/stable/modules/svm.html):

```python
from sklearn import svm
X = [[0, 0], [1, 1]]
y = [0, 1]
clf = svm.SVC()
clf.fit(X, y)
```

Não posso dizer que sei usar o SVM por conseguir treinar um modelo a partir de uma biblioteca. Já como programador, é normal saber apenas como funcionas as APIs e abstrair completamente a implemantação, o importante é funcionar. O [MIT trocou Scheme por Python](https://www.wisdomandwonder.com/link/2110/why-mit-switched-from-scheme-to-python) em seu curso introdutório, para refletir esse contexto:

> In 1980, good programmers spent a lot of time thinking, and then produced spare code that they thought should work. Code ran close to the metal, even Scheme — it was understandable all the way down. [...] But programming now isn’t so much like that, said Sussman. Nowadays you muck around with incomprehensible or nonexistent man pages for software you don’t know who wrote. You have to do basic science on your libraries to see how they work, trying out different inputs and seeing how the code reacts. This is a fundamentally different job, and it needed a different course.

É uma estratégia que funciona muito bem, mas existe uma armadilha. Para deixar a API fácil de usar, a implementação por trás da abstração é cada vez mais sofisticada. E, quando essa abstração falha, muitos programadores ficam completamente perdidos por não ter a mínima ideia do que está acontecendo.

Nesse [post](/2023/03/04/engenharia-dados.html) sobre as dores de engenharia de dados, destaquei como esse é um cenário recorrente ao trabalhar com grandes volumes de dados. Os tutoriais são super amigáveis e prometem ótimos resultados, mas na prática o buraco é mais fundo. Eu brinco que essa é a curva de aprendizado do Spark, as coisas vão progredindo bem até o momento em que se encontra pilhas de erros enormes em Scala por problemas de memória:

<figure>
  <img src="/assets/images/cientista-programadores/grafico-spark.svg" style="display: block;margin-left:auto;margin-right: auto;">
</figure>

Não estou sugerindo que se tenha conhecimento profundo sobre todas as ferramentas e frameworks, é simplesmente impossível e os ganhos práticos são cada vez menores a partir de determinado ponto. Minha sugestão é seguir o conselho do Martin Kleppman, autor do livro "Design Data Intensive Applications":

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what’s going on there. You don’t need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that […] if the the performance goes bad, you have a way of visualizing in your head what’s going on. […]. It’s incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Para isso, eu gosto de assistir apresentações [como essa](https://www.youtube.com/watch?v=dmL0N3qfSc8), normalmente descritas como *deep dive* ou *internals* sobre as ferramentas. Infelizmente, é um pouco difícil achar conteúdo que esteja nesse meio do caminho, que não seja uma aula sobre como implementar [Paxos](https://en.wikipedia.org/wiki/Paxos_(computer_science)) ou um material de marketing superficial para vender o produto.

Uma vantagem de focar mais nesse tipo de conhecimento, é que fica mais fácil transitar entre diferentes implementações do mesmo conceito. É importante para uma decisão de arquitetura, saber se o novo banco da moda faz sentido para o cenário em que se está trabalhando. Por exemplo, basta ler a documentação do [DuckDB](https://duckdb.org/why_duckdb) para ter uma noção de como ele pode te ajudar a substituir rotinas Spark, mas dificilmente te ajudará com rotinas transacionais.

Esse ponto, emenda com outro tópico que eu queria discutir, que é repensar o valor que damos ao conhecimento prático como programadores. Ao mesmo tempo que é relevante, acaba virando um limitador artifical para nossa atuação.

# Ferramentas importam, mas não tanto assim

Quando se aprende a programar, é normal o discurso de que o importante é aprender lógica, a linguagem não é importante. Mas isso é verdade até os primeiros meses, depois escolher o seu foco vira algo extremamente importante.

O mercado não incentiva a troca entre linguagens, é muito difícil manter o salário ao migrar de "stack" tecnológica. Mesmo com 15 anos de experiência, seria muito complicado eu migrar como senior para uma linguagem que eu não tenha experiência prévia, especialmente se for consolidada e com grande oferta de profissionais experientes.

Os cientistas de dados têm especialidades também – pessoas que trabalham mais com dados não-estruturados, outras focadas em métodos estatísticos, ou especialistas em otimização – mas sinto que as barreiras são menores para migrar entre áreas. É mais importante que você tenha mostrado capacidade de ter se aprofundado em algo, do que ter experiência prévia em um domínio específico.

