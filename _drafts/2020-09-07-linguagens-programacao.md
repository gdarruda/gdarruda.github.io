---
layout: post
title: "Dando um passo para trás"
comments: true
mathjax: true
description: "Por que aprender linguagens estranhas?"
keywords: "Programação Funcional, Linguagens, Conceitos"
---

Uma discussão comum no mercado de TI é a relevância das graduações –  especialmente as que seguem os currículos tradicionais – em um mercado que evolui rapidamente e se torna mais heterogêneo.

Um dos pontos mais debatidos são os tópicos de estruturas de dados, que talvez seja o conteúdo mais simbólico dos cursos de computação. É um tópico que resume bem a questão central do debate: qual a importância de entender como isso é implementado, saber se aquele comando `get` do banco de dados faz uma busca em árvore ou tabela hash?

Não acho que haja uma reposta simples, como é comum nessas discussões intermináveis. A utilidade prática depende muito do escopo do trabalho, não é igual para todo programador. Há um certo esnobismo misturado nessa discussão, uma ideia de que programdores "de verdade" precisam entender de estrutura de dados. Por fim, acho que se mistura com uma questão muito pessoal e subjetiva, que é a forma de aprender e trabalhar de cada um.

Apesar de estrutura de dados ser um grande debate, acho que existe um outro tópico de computação que mais pessoas concordem na sua relevância, mas é menos foco de interesse e debate. No caso, estou falando dos conceitos de linguagens de programação.

## Linguagens de programação

É normal nas graduações ter algum curso chamando "linguagens de programação" ou algo do gênero, que aborda as ideias por trás delas, como os diferentes paradigmas e tipos de sintaxe por exemplo. Não cheguei a cursar durante a graduação, acredito que era optativa, mas achei esse [ótimo curso](https://www.coursera.org/learn/programming-languages?) que é basicamente esse tipo de conteúdo em formato de MOOC.

O curso aborda três linguagens: SML, Racket e Ruby. Exceto no caso do Ruby, não são linguagens populares no mercado. O instrutor sabe disso, mas são escolhas muito bem justificadas para explicar o conteúdo do curso, já que o ponto é abordar o design de linguagens e não simplesmente aprender a utilizá-las.

Essa abordagem reflexiva é justamente o que torna o curso bom, veja alguns pontos interessantes debatidos durante o curso:

* Qual a diferença entre "tipagem" estática e dinâmica? 
* Qual a relação entre tipos e classes?
* Qual o ponto da imutabilidade?
* Como abordar um problema pela perspectiva funcional e orientada à objetos?

Nenhuma dessas questões são necessárias para programar, entra no mesmo tipo de discussão em relação a estrutura de dados. Entretanto, argumento que lidar com esses conceitos são problemas comuns a todos os programadores, mais presentes no dia-a-dia dos programadores que estrutura de dados.

Acredito que sempre foi importante esses tópicos, mas pelas últimas tendências de mercado, responder as questões que coloquei acima se tornaram muito mais relevantes.

No trabalho anterior, lidei muito com Spark em diversos casos de uso: processos de ETL, análise exploratória e implantação de modelos. Acredito que seja interessante falar dele aqui, porque esses diferentes casos trazem respostas diferentes para a pergunta que eu sempre ouvia no começo de todo projeto: a gente vai usar qual linguagem?

O [Apache Spark](https://spark.apache.org/) é uma solução para trabalhar com manipulação de dados massivos em paralelo. Ele é desenvolvido em [Scala](https://scala-lang.org/), mas tem APIs para serem usadas para diversas outras como Python, Java e R por exemplo. Por isso, é uma questão comum definir qual linguagem para um novo projeto basedo em Spark.

<!-- Se há suporte para várias, é porque faz sentido a depender do caso de uso. E, sendo honesto, sentia que a maioria não estava preparada para responder essa pergunta e decisões caras (e erradas) foram tomadas por causa disso. -->

## Quanto importa a linguagem?

O primeiro ponto na escolha de uma linguagem, para qualquer projeto, é a viabilidade técnica. O que envolve vários aspectos, mas pode ser resumida a uma pergunta: dá para resolver esse problema usando essa linguagem?

Em geral, a decisão vinha da plataforma. Quando se fala Java, via de regra não se está falando sobre a linguagem em si, mas de tudo que está ao entorno dela: JDK, servidor de aplicação, bibliotecas, frameworks, etc. Um pacote de coisas, contendo da linguagem até as ferramentas.

Hoje, é possível e razoável usar diversas linguagens dentro de plataformas, como JDK e .NET por exemplo, mantendo interoperabilidade (em algum nível) com todo o ecossistema existente. Como não era um cenário muito comum, para alguns desenvolvedores, nem sempre é claro onde "começa" e "termina" a linguagem.

Parece bobo, mas talvez a primeira motivação para aprender sobre linguagens, é justamente entender do que se trata uma. A dificuldade em compreender o escopo da  linguagem, faz com que as pessoas superestimem a importância delas em um contexto multi-linguagem, como é o caso do Spark.

A linguagem é só uma pequena parte da solução Spark, algumas vezes crítica, mas que via de regra é muito menos importante que outras questões como organização dos dados e tipo de processamento por exemplo.

### Qualquer uma então?

Pela início do meu argumento, parece que para usar Spark não importa a linguagem utilizada. Em algum nível sim, mas por que não se usa Scala sempre que possível?

Imagine um processo novo de ETL dentro de um ambiente Hadoop, em que todas as integrações podem ser feitas com Java. Usando Scala é garantido que o acesso a API do Spark será o mais amplo e com a melhor performance, se for necessário alguma integração com ferramentas do ambiente (*e.g.* HDFS, YARN, ZooKeeper) não deve ser um problema pela interoperabilidade de Scala com Java. 

Nesse cenário, usar Scala deveria ser uma decisão *no-brainer* do ponto de vista técnico. Mas o elefante na sala é justamente usar Scala, uma linguagem [díficil de aprender](https://www.quora.com/Why-is-Scala-so-hard-to-learn) por ser muito complexa em sua proposta multi-paradigma e com muitos recursos. 

Entendo o medo de Scala, não é injustificado, mas só eu acho curioso que não existe o mesmo medo com Spark? Saber usar Spark não é sobre conhecer as APIs, mas entender o que está acontecendo embaixo do capô para não cair em problemas de shuffle e falta de memória. 

Dominando o Spark em seu funcionamento, não importa tanto a linguagem, são claro os em que Pyhton não é uma boa escolha por exemplo. Só que fugir de Scala, vai atrapalhar justamente essa caminhada de entender o funcionamento do Spark, talvez ser até um barreira. Além disso, é naturalmente mais idiomático programar uma solução em Spark usando a linguagem nativa, melhorando a solução dessa perspectiva subjetiva.

Sabendo os conceitos de linguagem, Scala deixa de ser um bicho papão e se torna apenas mais uma linguagem. Um problema ao menos, na díficil jornada de aprender a trabalhar com Spark.

## Linguagem são conceitos aplicados

Uma linguagem é um "catado" de recursos, e o Scala é uma que procura implementar muitos recursos. O *slogan* da linguagem é combinar recursos de orientação a objetos e programação, já que o criador considera que são conceitos ortogonais.

A separaçõ entre os pardigmas existem mais por questões históricas que técnicas. A dicotomia existe mais entre imperativo e funcional, não tanto entre orientação a objetos e funcional. Tanto é verdade, que Scala mistura os dois paradigmas e, pode-se dizer, que é bem sucedida. Outras linguagens, "predominantemente" orientada a objetos, também estão integrando características funcionais.

O problema é que a mistura torna a linguagem mais complexas porque se multiplicam as possibilidades. Optar por implementar polimorfismo usando classes ou funções de alta ordem, são abordagens bem diferente para um mesmo problema. Por outro lado, a vantagem de uma linguagem complexa é justamente as possibilidades e a flexibilidade.

O curso não aborda Scala, mas debate vários conceitos chaves a partir de outras linguagens. Scala é influenciada por SML em ideias como inferência de tipo, pattern-matching, options, currying e tailrec. E, claro, questões mais "universais" de linguagens funcionais também são apresentados como recursão, funções de alta-ordem e closures. 

O paradigma orientado a objetos também é abordado no curso usando Ruby, ao final discute-se um mesmo problema a partir da perspectiva de SML e Ruby. Um tópico importante, já que quaisquer problemas podem ser resolvidos a partir de ambas as perspectivas, especialmente em Scala que abraça as duas visões. Mas qual paridgma lida melhor com esse tipo de problema?

Em resumo, se eu tivesse feito o curso antes de aprender Spark e Scala, eu teria muito mais facilidade em evoluir nela e feito código de melhor qualidade. Por outro lado, é verdade que eu me virei, entendendo muito dessas ideias de forma superficial e por analogias. Por exemplo, entender o `map` como um `loop` que retorna sempre o resultado da última linha.

Novamente, não é necessário saber essas coisas para desenvolver uma solução Spark. Mas além de agilizar o aprendizado e melhorar a qualidade do código, esses conceitos me deram uma ideia mais clara das soluções e decisões do Spark.

## Formalismos ajudam

