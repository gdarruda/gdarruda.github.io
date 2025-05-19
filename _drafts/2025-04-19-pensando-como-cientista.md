---
layout: post
title: "Aprendendo com cientistas de dados"
comments: true
mathjax: true
description: "Discussão sobre como tratar problema"
---

Eu tenho o cargo de cientista de dados há vários anos, mas durante esse período, trabalhei muito pouco com desenvolvimento de modelos e análises descritivas. Gostos dessas atividades, mas sou medíocre nelas, várias colegas que conseguem fazer esse tipo de trabalho tão bem ou melhor que eu. Por outro lado, tenho bastante experiência como desenvolvedor, então foco meus esforços em colocar os modelos desenvolvidos por outros cientistas para rodar.

Nessa posição, trabalho muito em conjunto com os cientistas de dados, mas atuando como um programador. Qualquer desenvolvedor, que precisou colocar em produção um modelo implementado em um arquivo chamado *Untitled (7) Copy.ipynb*, sabe que alguns cientistas precisam aprender muito sobre as práticas de programação.  Ao mesmo tempo que alguns precisam aprender mais sobre programação, trabalhar com cientistas me ensinou a ver os desafios de programação com outros olhos.

<!-- Mesmo que não tenha nada a ver com dados, como programador me inspiro na forma de pensar dos cientistas de dados, especialmente para a parte de aprendizado. -->

# Saber (somente) a API, não é saber

Um dos meus pontos fracos como cientista de dados, é não ter muita profundidade teórica. Por exemplo, eu tenho a intuição de como um [SVM](https://en.wikipedia.org/wiki/Support_vector_machine) funciona, mas não saberia implementar a otimização e nem entendo as partes mais sofisticadas como o [kernel trick](https://en.wikipedia.org/wiki/Kernel_method#Mathematics:_the_kernel_trick). Apesar de ser um modelo complexo de entender, é muito simples utilizá-lo no [scikit-learn](https://scikit-learn.org/stable/modules/svm.html):

```python
from sklearn import svm
X = [[0, 0], [1, 1]]
y = [0, 1]
clf = svm.SVC()
clf.fit(X, y)
```

Não posso dizer que sei usar o SVM por conseguir treinar um modelo usando uma biblioteca. Já como programador, é padrão saber usar bibliotecas e abstrair completamente a implemantação, conquanto que tenha o comportamento esperado. Devido a esse novo jeito de programar, o [MIT trocou Scheme por Python](https://www.wisdomandwonder.com/link/2110/why-mit-switched-from-scheme-to-python) em seu curso introdutório:

> In 1980, good programmers spent a lot of time thinking, and then produced spare code that they thought should work. Code ran close to the metal, even Scheme — it was understandable all the way down. [...] But programming now isn’t so much like that, said Sussman. Nowadays you muck around with incomprehensible or nonexistent man pages for software you don’t know who wrote. You have to do basic science on your libraries to see how they work, trying out different inputs and seeing how the code reacts. This is a fundamentally different job, and it needed a different course.

Essa estratégia tende a funcionar bem, mas algumas vezes se faz necessário entender a implementação para fazer um *troubleshoot* ou resolver problemas de desempenho. Eu discuti nesse [post](/2023/03/04/engenharia-dados.html), como esse problema é recorrente na parte de engenharia de dados. 

Os tutoriais são super amigáveis e tudo funciona bem no começo, mas as coisas podem se complicar muito rapidamente. Eu brinco que a curva de aprendizado de Apache Spark é suave, vai progredindo bem no começo, até que fica intransponível quando é necessário resolver problemas de serialização e ler pilhas de erro em Scala.

<figure>
  <img src="/assets/images/cientista-programadores/grafico-spark.svg" style="display: block;margin-left:auto;margin-right: auto;">
</figure>

Não estou sugerindo que se tenha conhecimento profundo sobre todas as ferramentas e frameworks, é simplesmente impossível e os ganhos práticos seguem a [lei dos rendimentos decrescentes](https://pt.wikipedia.org/wiki/Lei_dos_rendimentos_decrescentes). Minha sugestão é seguir o conselho do Martin Kleppman, autor do livro "Design Data Intensive Applications", se preocupar em ter uma noção de como as coisas estão funcionando por trás das abstrações:

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what’s going on there. You don’t need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that […] if the the performance goes bad, you have a way of visualizing in your head what’s going on. […]. It’s incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Para isso, eu gosto de assistir apresentações [como essa](https://www.youtube.com/watch?v=dmL0N3qfSc8), normalmente descritas como *deep dive* ou *internals*. Infelizmente, é um pouco difícil achar conteúdo que esteja nesse meio do caminho entre teoria pura e apenas a aplicação prática.

Esse tipo de conhecimento, além de ser mais perene, facilita transitar entre diferentes implementações do mesmo conceito. Por exemplo, basta ler a documentação do [DuckDB](https://duckdb.org/why_duckdb) para ter uma noção de como ele pode te ajudar a substituir rotinas Spark, mas dificilmente será útil em processos transacionais.

Esse último ponto emenda com outro tópico que eu queria discutir, que é repensar o valor que damos ao conhecimento especializado em ferramentas. É relevante para ter velocidade no desenvolvimento e facilidade em lidar com os problemas, mas pode acabar virando uma limitação artificial.

# Ferramentas importam, mas não tanto

Quando se aprende a programar, é normal o discurso de que o importante é aprender lógica, a linguagem é uma questão secundária. Mas isso é verdade até os primeiros meses, depois escolher a "sua" linguagem vira algo extremamente importante na carreira do programador.

O mercado é avesso a migração de linguagens, é muito difícil migrar de "stack" tecnológica. Mesmo com 15 anos de experiência, seria difícil eu migrar como senior para uma linguagem que eu não tenha experiência prévia, especialmente se tiver uma vasta oferta de profissionais experientes como C# ou PHP por exemplo.

Os cientistas de dados têm especialidades também – pessoas que trabalham mais com dados não-estruturados, outras focadas em métodos estatísticos, ou especialistas em otimização – mas sinto que as barreiras são menores para migrar entre especialidades. É mais importante que você tenha mostrado capacidade de se aprofundadar em algo, do que ter experiência prévia em um domínio específico.

Meu mestrado é completamente irrelevante hoje como pesquisa, mas ainda é importante como experiência. Não importa tanto o assunto da sua pesquisa, mas a premissa de que você conseguiu se aprofundar em um tópico relacionado, então pode fazer o mesmo em outo domínio. Afinal, é uma área em que as inovações acadêmicas chegam muito rapidamente ao mercado.

Apesar do mercado não incentivar, tento aproveitar as oportunidades que tenho para trabalhar com outras linguagens e tecnologias. É normal não ter a mesma velocidade no começo, mas concordo com essa [sugestão do Norvig](https://www.norvig.com/21-days.html), que é importante aprender várias linguagens com propostas diferentes:

> Learn at least a half dozen programming languages. Include one language that emphasizes class abstractions (like Java or C++), one that emphasizes functional abstraction (like Lisp or ML or Haskell), one that supports syntactic abstraction (like Lisp), one that supports declarative specifications (like Prolog or C++ templates), and one that emphasizes parallelism (like Clojure or Go).

Recentemente, eu precisei desenvolver uma aplicação C#, mas nunca tinha mexido em nada do ecossistema .NET. Após algumas semanas, eu já estava conseguindo ser produtivo, existem mais similaridades que diferenças entre linguagens como Java e C#. A infinidade de recursos que existem hoje para aprendizado – IDEs/LSPs, IAs, documentação, Stack Overflow – facilitam muito essa migração para alguém com experiência prévia em outra linguagem.

Eu tenho minhas preferências, mas se o projeto é uma aplicação web tradicional, a linguagem dificilmente é um problema. Normalmente, são outras decisões de arquitetura que viram um problema, como um banco de dados inadequado ou separação de serviços. 

Um argumento plausível em que a linguagem importa – mas via de regra mal compreendedido e utilizado – são problemas de escalabilidade com uma linguagem lenta. São argumentos usados sem rigor algum, com base em anedotas e benchmarks para cenários específicos, que normalmente mistura os conceitos de velocidade e escalabilidade.

# Seja criterioso com métricas

Um conhecimento muito cobrado dos cientistas de dados, é o domínio sobre métricas de avaliação. Saber escolher a mais adequada para o problema, como interpretá-las e suas limitações. O mesmo deveria ser cobrado de programadores e arquitetos, quando usam a *performance* como argumento de suas escolhas.

O erro mais comum que eu vejo ser cometido, é não entender a relevância da métrica. Por exemplo, a importância de um falso negativo é diferente para cada problema: condenar alguém erronemanente é um erro bem grave, diagnosticar COVID em alguém gripado. No ápice da pandemia, 
a importância de um falso positivo de COVID era muito maior.

O relatório das [linguagens mais sustentáveis](https://greenlab.di.uminho.pt/wp-content/uploads/2017/10/sleFinal.pdf) apareceu várias vezes no meu LinkedIn, destacando a ineficiência do Python: é tão lenta, que consome 70x mais energia para fazer o mesmo trabalho que C. É um resultado válido pelos experimentos feitos, mas que não é relevante para o cenário de uso da linguagem.

Os testes foram feitos com tarefas chamadas *CPU bound*, como cálculo de autovalor e manipulação de árvores binárias. Para computação científica, a "regra" é usar bibliotecas [como o numpy](/2021/01/12/para-se-preocupar-ame-numpy.html), implementadas em outras linguagens mais rápidas. Para desenvolvimento de aplicações web, normalmente estamos falando de um cenário *IO Bound*, com muito mais tempo gasto com rede e armazenamento.

Mesmo quando uma métrica é relevante, ela pode ser muito limitada para representar todas as nuances do problema. Por exemplo, eu fiz essa [comparação de performance entre gRPC e REST](/2023/04/16/grpc-rest.html), utilizando diferentes linguagens de programação. Pelo primeiro experimento, usando o tempo médio de resposta do primeiro teste, poderia dizer que Python com gRPC é a melhor alternativa.

A média é uma métrica muito sensível a outliers, o que a torna muito capciosa para comparar resultados que envolvem comunicação por rede. Fazendo um teste com requisições sequenciais, grPC com Go foi uma solução com boa mediana, mas muita variância também:

<figure>
  <img src="/assets/images/grpc-rest/boxplot_outliers.svg"/>
</figure>

Esse comportamento é normal, porque os protocolos de rede são otimizados para aumentar *throughput* em detrimento a estabilidade. Mudando o cenário do experimento, para requisições concorrentes, os resultados de Go com gRPC são melhores que Pyhton com gRPC:

<figure>
  <img src="/assets/images/grpc-rest/histogram_batch.svg"/>
</figure>

Esses resultados são muito mais relevantes para avaliar aplicação web, comparado ao teste de consumo de energia. Entretanto, são resultados frágeis que devem ser avaliados com cuidado:

* os testes foram feitos em uma rede Wi-Fi, é um cenário completamente diferente de uma comunicação entre servidores em um datacenter;

* se eu tivesse caido na tentação de representar os resultados em métricas como a média – eu poderia concluir que Python com gRPC é a solução mais rápida – o que seria uma conclusão válida e rasa ao mesmo tempo.

Eu deliberadamente não coloquei as métricas no post, porque é natural que as pessoas simplesmente comparem os números e ignore as nuances. Números sempre trazem uma maior credibilidade, mas nem sempre são relevantes ou bons para representar a realidade.


