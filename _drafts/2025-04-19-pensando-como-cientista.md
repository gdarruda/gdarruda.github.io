---
layout: post
title: "Aprendendo como cientistas de dados"
comments: true
mathjax: true
description: "Discussão sobre como tratar problema"
---

Eu tenho o cargo de cientista de dados há vários anos, mas trabalhei muito pouco com desenvolvimento de modelos e análises descritivas durante esse período. Gostos dessas atividades, mas sou medíocre nessa parte, várias colegas que conseguem fazer esse tipo de trabalho tão bem ou melhor que eu. 

Por outro lado, tenho bastante experiência como desenvolvedor, então foco meus esforços em colocar os modelos desenvolvidos por outros cientistas para rodar. Nessa posição, trabalho muito em conjunto com os cientistas de dados, mas atuando como um programador. 

Qualquer desenvolvedor, que precisou colocar em produção um modelo implementado em um arquivo chamado *Untitled (7) Copy.ipynb*, sabe que alguns cientistas precisam aprender muito sobre as práticas de programação.  Ao mesmo tempo que alguns cientistas tem muito que aprender sobre programação, eles têm coisas a ensinar para os programadores, especialmente na parte de aprendizado.

Mesmo que o seu trabalho não tenha nada a ver com dados, como programador faz sentido inspirar no modo de pensar dos cientistas de dados.

# Saber (somente) a API, não é saber

Um dos meus pontos fracos como cientista de dados, é não ter muita profundidade teórica. Por exemplo, eu tenho a intuição de como um [SVM](https://en.wikipedia.org/wiki/Support_vector_machine) funciona, mas não saberia implementar a otimização e nem entendo as partes mais sofisticadas como o [kernel trick](https://en.wikipedia.org/wiki/Kernel_method#Mathematics:_the_kernel_trick). Apesar de ser um modelo complexo de entender, é muito simples utilizá-lo no [scikit-learn](https://scikit-learn.org/stable/modules/svm.html):

```python
from sklearn import svm
X = [[0, 0], [1, 1]]
y = [0, 1]
clf = svm.SVC()
clf.fit(X, y)
```

Não posso dizer que sei usar o SVM por conseguir treinar um modelo usando uma biblioteca. Já como programador, é normal saber usar bibliotevas e abstrair completamente a implemantação, conquanto que tenha o comportamento esperado. Devido a esse novo jeito de programar, O [MIT trocou Scheme por Python](https://www.wisdomandwonder.com/link/2110/why-mit-switched-from-scheme-to-python) em seu curso introdutório:

> In 1980, good programmers spent a lot of time thinking, and then produced spare code that they thought should work. Code ran close to the metal, even Scheme — it was understandable all the way down. [...] But programming now isn’t so much like that, said Sussman. Nowadays you muck around with incomprehensible or nonexistent man pages for software you don’t know who wrote. You have to do basic science on your libraries to see how they work, trying out different inputs and seeing how the code reacts. This is a fundamentally different job, and it needed a different course.

Essa estratégia tende a funcionar bem no caso médio, mas algumas vezes é necessário ter um pouco mais de entendimento para tratar de casos específicos. Quanto é necessário olhar por trás da abstração, programadores que não sabem nada da implementação ficam completamente perdidos. Eu comentei nesse [post](/2023/03/04/engenharia-dados.html), como esse problema é recorrente na parte de engenharia de dados. 

Os tutoriais são super amigáveis e tudo funciona bem no começo, mas as coisas podem se complicar muito rapidamente. Eu brinco que a curva de aprendizado de Apache Spark é suave, vai progredindo bem no começo, até o momento em que se encontra erros em Scala e problemas de serialização.

<figure>
  <img src="/assets/images/cientista-programadores/grafico-spark.svg" style="display: block;margin-left:auto;margin-right: auto;">
</figure>

Não estou sugerindo que se tenha conhecimento profundo sobre todas as ferramentas e frameworks, é simplesmente impossível e os ganhos seguem a [lei dos rendimentos decrescentes](https://pt.wikipedia.org/wiki/Lei_dos_rendimentos_decrescentes). Minha sugestão é seguir o conselho do Martin Kleppman, autor do livro "Design Data Intensive Applications", se preocupar em ter uma noção de como as coisas estão funcionando por trás das abstrações:

> Learn just enough abot the internals of the tools you are using, so that you have a reasonable mental model of what’s going on there. You don’t need to be able to, like, modify of the Kafka yourself, but I think having just enough of an idea of the internals that […] if the the performance goes bad, you have a way of visualizing in your head what’s going on. […]. It’s incredibly valuable to just have a bit of a mental model and not just treat it as a black box.

Para isso, eu gosto de assistir apresentações [como essa](https://www.youtube.com/watch?v=dmL0N3qfSc8), normalmente descritas como *deep dive* ou *internals* sobre as ferramentas. Infelizmente, é um pouco difícil achar conteúdo que esteja nesse meio do caminho entre teoria pura e apenas a aplicação prática.

Esse tipo de conhecimento, além de ser mais perene, facilita transitar entre diferentes implementações do mesmo conceito, especialmente para decisões de arquitetura. Por exemplo, basta ler a documentação do [DuckDB](https://duckdb.org/why_duckdb) para ter uma noção de como ele pode te ajudar a substituir rotinas Spark, mas dificilmente te ajudará com rotinas transacionais.

Esse último ponto emenda com outro tópico que eu queria discutir, que é repensar o valor que damos ao conhecimento especializado em ferramentas. Ao mesmo tempo que é relevante para a velocidade no dia-a-dia, acaba virando um limitador artifical para nossa atuação.

# Ferramentas importam, mas não tanto

Quando se aprende a programar, é normal o discurso de que o importante é aprender lógica, a linguagem é uma questão secundária. Mas isso é verdade até os primeiros meses, depois escolher a "sua" linguagem vira algo extremamente importante na vida do programador.

O mercado é avesso a migração de linguagens, é muito difícil manter o salário ao migrar de "stack" tecnológica. Mesmo com 15 anos de experiência, seria muito complicado eu migrar como senior para uma linguagem que eu não tenha experiência prévia, especialmente algo com vasta ofertas de profissionais experientes como C# ou PHP por exemplo.

Os cientistas de dados têm especialidades também – pessoas que trabalham mais com dados não-estruturados, outras focadas em métodos estatísticos, ou especialistas em otimização – mas sinto que as barreiras são menores para migrar entre especialidades. É mais importante que você tenha mostrado capacidade de ter se aprofundado em algo, do que ter experiência prévia em um domínio específico.

Meu mestrado é completamente irrelevante hoje como pesquisa, mas ainda é importante como experiência. Não importa tanto o assunto da sua pesquisa, mas a premissa de que você conseguiu se aprofundar em um tópico relacionado, então pode fazer o mesmo em outo domínio. Aprender uma segunda linguagem é bem mais fácil, se você já tem anos de experiência com outras.

Apesar do mercado não incentivar, tento aproveitar as oportunidades que tenho para trabalhar com outras linguagens e tecnologias. É normal não ter a mesma velocidade no começo, mas concordo com essa [sugestão do Norvig](https://www.norvig.com/21-days.html), que é importante aprender várias linguagens com propostas diferentes:

> Learn at least a half dozen programming languages. Include one language that emphasizes class abstractions (like Java or C++), one that emphasizes functional abstraction (like Lisp or ML or Haskell), one that supports syntactic abstraction (like Lisp), one that supports declarative specifications (like Prolog or C++ templates), and one that emphasizes parallelism (like Clojure or Go).

Recentemente, eu precisei desenvolver uma aplicação C#, mas nunca tinha mexido em nada do ecossistema .NET. Após algumas semanas, eu já estava conseguindo ser produtivo, existem mais similaridades que diferenças entre linguagens como Java e C#. A infinidade de recursos que existem hoje para aprendizado – IDEs/LSPs, IAs, documentação, Stack Overflow – facilitam muito para alguém experiente.

Se o projeto é uma aplicação web padrão, é algo que pode ser feito com a maioria das linguagens populares, pouco importa qual se está utilizando. Um contra-argumento plausível – mas via de regra mal compreendedido e utilizado – é que uma linguagem mais "rápida" pode ser mais "escalável". São argumentos usados sem rigor algum, normalmente citando anedotas e benchmarks para cenários específicos.

# Seja criterioso com métricas

Uma coisa que cientistas de dados são muito cobrados, é saber interpretar métricas para comparar diferentes modelos. Podemos debater dois tipos de erros diferentes em relação ao uso de métricas, sua relevância e representatividade.

A relevância de uma métrica é dada pelo problema ser tratado. Por exemplo, a importância de um falso negativo é muito diferente no cenário jurídico e médico: condenar alguém erronemanente é um erro bem grave, diagnosticar COVID em alguém gripado provavelmente nem tanto. No contexto de programação, é comum não entender a relevância quando se compara a performance.

O relatório das [linguagens mais sustentáveis](https://greenlab.di.uminho.pt/wp-content/uploads/2017/10/sleFinal.pdf) apareceu várias vezes no meu LinkedIn, destacando a ineficiência do Python: consome 70x mais energia que C. É um resultado válido pelos experimentos feitos, mas ele não é relevante para o cenário de uso da linguagem, apesar de realmente ser ótimo para chamar atenção em uma rede social.

Os testes foram feitos com tarefas chamadas "CPU bound" como cálculo de autovalor e manipulação de árvores binárias, que não costuma ser o caso de uso do Python. Para computação científica, a regra é usar bibliotecas implementadas em outras linguagens [como o numpy](/2021/01/12/para-se-preocupar-ame-numpy.html). Para aplicações web, normalmente é um [cenário "IO Bound"](http://localhost:4000/2023/04/16/grpc-rest.html), no qual maior parte do tempo é gasta com rede e armazenamento ao invés de processamento.
