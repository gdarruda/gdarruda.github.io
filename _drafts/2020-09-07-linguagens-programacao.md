---
layout: post
title: "Dando um passo para trás"
comments: true
mathjax: true
description: "Por que aprender linguagens estranhas?"
keywords: "Programação Funcional, Linguagens, Conceitos"
---

Uma discussão comum no mercado de TI é a relevância das graduações –  especialmente as que seguem os currículos tradicionais – em um mercado que evolui rapidamente e se torna mais heterogêneo.

Um dos pontos mais debatidos são os tópicos de estruturas de dados, que talvez seja o conteúdo mais simbólico dos cursos de computação. De certa forma, é um tópico que resume bem a questão central do debate: qual a importância de saber como isso é implementado, se aquele comando `get` do banco de dados faz uma busca em árvore ou tabela hash?

Não acho que haja uma reposta simples, como é comum nessas discussões intermináveis. A utilidade prática depende muito do escopo do trabalho, não é igual para todo programador. Há um certo esnobismo misturado nessa discussão, uma ideia de que programdores "de verdade" precisam entender de estrutura de dados. Por fim, acho que tem uma questão muito pessoal e subjetiva, que é a forma de aprender e trabalhar de cada um.

Apesar de estrutura de dados ser um grande debate, acho que existe um outro tópico de computação que mais pessoas concordem na sua relevância, mas é menos foco de interesse e debate. No caso, estou falando dos conceitos de linguagens de programação.

## Linguagens de programação

É normal nas graduações ter algum curso chamando "linguagens de programação" ou algo do gênero, que aborda as ideias por trás das linguagens, como diferentes paradigmas e sintaxes  por exemplo. Não cheguei a cursar durante a graduação, acredito que era optativa, mas achei esse [ótimo curso](https://www.coursera.org/learn/programming-languages?) que é basicamente esse conteúdo em formato de MOOC.

O curso aborda três linguagens: SML, Racket e Ruby. Exceto no caso do Ruby, não são linguagens muito populares no mercado. O instrutor sabe disso, mas são escolhas muito bem justificadas para explicar o conteúdo do curso, já que o ponto é refletir sobre o design de linguagens e não simplesmente aprender a utilizá-las.

A abordagem reflfexiva é que torna o curso bom, alguns pontos interessantes que são discutidas:

* Qual a diferença entre "tipagem" estática e dinâmica? 
* Qual a relação entre tipos e classes?
* Qual o ponto da imutabilidade?
* Conceitos de programação funcional (*e.g.* clousure, memoization, pattern matching)
* Como abordar um problema pela abordagem funcional e orientada à objetos?

Nenhuma dessas questões são necessárias para programas, entram no mesmo tipo de debate sobre os tópicos de estrutura de dados. Só que são problemas comuns a todos os programadores, que influenciam o código feito no dia-a-dia e importantes tomadas de decisão.

Em algum nível, acredito que sempre foi importante esses tópicos, mas pelas últimas tendências de mercado, responder as questões que coloquei acima se tornaram muito mais relevantes.

No trabalho anterior, lidei com Spark em diversos casos de uso: processos de ETL, análise exploratória e implantação de modelos. Acredito que seja interessante falar dele aqui, porque esses diferentes casos trazem respostas diferentes para a pergunta que eu sempre ouvia no começo de todo projeto: a gente vai usar qual linguagem?

Para contextualizar, o [Apache Spark](https://spark.apache.org/) é uma solução para trabalhar com manipulação de dados massivos em paralelo. Ele é desenvolvido em [Scala](https://scala-lang.org/), mas tem APIs para serem usadas para diversas outras como Python, Java e R por exemplo. Por isso, é uma questão recorrente definir qual linguagem para um novo projeto basedo em Spark.

Se há suporte para várias, é porque faz sentido a depender do caso de uso. E, sendo honesto, sentia que a maioria não estava preparada para responder essa pergunta e decisões caras (e erradas) foram tomadas por causa disso.

## Quanto importa a linguagem?

O primeiro ponto na escolha de uma linguagem, para qualquer problema, é a viabilidade técnica. O que envolve várias coisas, mas pode ser resumida a uma pergunta: dá para resolver esse problema usando essa linguagem?

Em geral, a decisão vinha da plataforma. Quando se fala de um programador Java, não se espera que ele simplesmente conheça a linguagem em si, mas de tudo que está ao entorno dela: JDK, servidor de aplicação, bibliotecas, frameworks, etc.

Hoje, é possível e razoável usar diversas linguagens dentro de plataformas, como JDK e .NET por exemplo, mantendo interoperabilidade (em algum nível) com todo o ecossistema existente. Antes não era muito comum, então para alguns desenvolvedores, nem sempre é claro onde "começa" e "termina" a linguagem. Não era uma questão comum escolher linguagens, era algo que vinha decidido antes da pessoa ser contratada.

Parece bobo, mas talvez a primeira motivação para aprender sobre linguagens, é justamente entender do que se trata uma. A dificuldade em compreender o escopo da  linguagem, faz com que as pessoas superestimem a importância delas em um contexto multi-linguagem, como é o caso do Spark.

Estamos falando de um solução de programação distribuída, um dos tópicos mais complexos de computação. Entender os conceitos de shuffle, ler um DAG de execução e estruturar a solução serão problemas muito maiores que a linguagem utilizada. Se você chamará a API do Spark usando Python ou Scala, é o de menos, mas é uma questão superstimada pela falta de separação desses conceitos.

### Qualquer uma então?

Pela início do meu argumento, parece que para usar Spark não importa a linguagem utilizada. Em algum nível sim, mas por que não usar Scala sempre que possível?

Iniciando pelo argumento técnico, imagine um processo de ETL dentro de um ambiente Hadoop, em que todas as integrações podem ser feitas com Java. Usando Scala é garantido que o acesso a API do Spark será o mais amplo e com a melhor performance, se for necessário alguma integração com ferramentas do ambiente (*e.g.* HDFS, YARN, ZooKeeper) não deve ser um problema pela interoperabilidade de Scala com Java. 

Nesse cenário, usar Scala deveria ser um decisão *no-brainer* do ponto de vista técnico. O elefante na sala é justamente usar Scala, uma linguagem conhecida como [díficil de aprender](https://www.quora.com/Why-is-Scala-so-hard-to-learn) por ser muito complexa em sua proposta multi-paradigma e com muitos recursos. 

Entendo o medo de Scala, não é injustificado, mas só eu acho curioso que não existe o mesmo medo com Spark? Saber usar Spark não é sobre conhecer as APIs, mas entender o que está acontecendo embaixo do capô para não cair em problemas de shuffle e falta de memória. 

Dominando o Spark, de fato não importa com que linguagem se está chamando. Só que fugir de Scala vai atrapalhar essa caminhada de entendimento, talvez ser até um barreira. Por fim, usando a linugagem nativa é mais fácil fazer código de qualidade e idiomático.

## Formalismos ajudam a aprender

Uma linguagem é um catado de recursos, no caso do Scala é uma que tenta pegar vários deles. 