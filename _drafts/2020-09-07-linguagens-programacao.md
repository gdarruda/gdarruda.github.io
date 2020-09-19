---
layout: post
title: "Dando um passo para trás"
comments: true
mathjax: true
description: "Por que aprender linguagens estranhas?"
keywords: "Programação Funcional, Linguagens, Conceitos"
---

Uma discussão comum no mercado de TI é a relevância das graduações –  especialmente as que seguem os currículos tradicionais – em um mercado que evolui rapidamente e se torna mais heterogêneo.

Um dos pontos mais debatidos são os tópicos de estruturas de dados, que talvez seja o conteúdo mais simbólico dos cursos de computação. É um tópico que resume bem a questão central do debate: qual a importância de entender como é implementado, saber se aquele comando `get` do banco de dados faz uma busca em árvore ou tabela hash?

Não acho que haja uma reposta simples, como é comum nessas discussões intermináveis. A utilidade prática depende muito do escopo do trabalho, não é igual para todo programador. Há um certo esnobismo misturado nessa discussão, uma ideia de que programdores "de verdade" precisam entender de estrutura de dados. Para completar, há questão muito pessoal e subjetiva, que é a forma de aprender e trabalhar de cada um.

Apesar de estrutura de dados se algoritmos serem o centro do debate, acredito que existe um outro tópico de computação que mais pessoas concordem na sua relevância, mas é menos foco de interesse. No caso, estou falando dos conceitos de linguagens de programação.

## Linguagens de programação

É normal nas graduações ter alguma matéria chamanda "linguagens de programação" ou algo do gênero, que aborda as ideias por trás delas, como os diferentes paradigmas e tipos de sintaxe. Não cheguei a cursar durante a graduação, acredito que era optativa, mas achei esse [ótimo curso](https://www.coursera.org/learn/programming-languages?) que é basicamente esse tipo de conteúdo em formato de MOOC.

O curso aborda três linguagens: SML, Racket e Ruby. Exceto no caso do Ruby, não são linguagens populares no mercado. O instrutor sabe disso, mas são escolhas muito bem justificadas para explicar o conteúdo do curso, já que o ponto é abordar o design de linguagens e não simplesmente aprender a utilizá-las.

Essa abordagem reflexiva é justamente o que torna o curso bom, veja alguns pontos interessantes debatidos durante o curso:

* Qual a diferença entre "tipagem" estática e dinâmica? 
* Qual a relação entre tipos e classes?
* Qual o ponto da imutabilidade?
* Como abordar um problema pela perspectiva funcional e orientada à objetos?

Nenhuma dessas questões são necessárias para programar, entram no mesmo tipo de discussão em relação a estrutura de dados. Entretanto, argumento que lidar com esses conceitos são problemas comuns a todos os programadores, mais presentes no dia-a-dia que tópicos de estrutura de dados.

Acredito que sempre foi importante conhecer um pouco sobre isso, mas pelas últimas tendências de mercado, responder as questões que coloquei acima se tornaram muito mais relevantes.

No trabalho anterior, por exemplo, lidei muito com Spark em diversos casos de uso: processos de ETL, análise exploratória e implantação de modelos. Acredito que seja interessante falar dele, porque esses diferentes casos trazem respostas diferentes para a pergunta que eu sempre ouvia no começo de todo projeto: a gente vai usar qual linguagem?

O [Apache Spark](https://spark.apache.org/) é uma solução para trabalhar com manipulação de dados massivos em paralelo. Ele é desenvolvido em [Scala](https://scala-lang.org/), mas tem APIs para serem usadas para diversas outras como Python, Java e R por exemplo. Por isso, é uma questão comum definir qual linguagem a ser utilizada em um projeto com Spark.

<!-- Se há suporte para várias, é porque faz sentido a depender do caso de uso. E, sendo honesto, sentia que a maioria não estava preparada para responder essa pergunta e decisões caras (e erradas) foram tomadas por causa disso. -->

## Quanto importa a linguagem?

O primeiro ponto na escolha de uma linguagem, seja para o Spark ou para qualquer projeto, é a viabilidade técnica. O que envolve vários aspectos, mas pode ser resumida a uma pergunta: dá para resolver esse problema usando essa linguagem?

Em geral, esse tipo de decisão era menos frequente, já que essa decisão noralmente envolve muito mais coisas que apenas a linguagem de programação.  Quando se fala Java, via de regra não se está falando sobre a linguagem em si, mas de tudo que está ao entorno dela: JDK, servidor de aplicação, bibliotecas, frameworks, etc. Um pacote de coisas, que a lingaguem em si é apenas uma parte.

Hoje, é possível e razoável usar diversas linguagens dentro de plataformas, como JDK e .NET por exemplo, mantendo interoperabilidade (em algum nível) com todo o ecossistema existente. No caso do Spark, ter dois projetos usando linguagens diferentes no mesmo ambiente não costuma ser um grande problema, já que é uma solução desenhada com essa flexibilidade em mente.

Como não era um cenário muito comum, para alguns desenvolvedores, nem sempre é claro onde "começa" e "termina" a linguagem. Parece bobo, mas talvez a primeira motivação para aprender sobre linguagens, é justamente entender do que se trata uma.

A dificuldade em compreender o escopo da  linguagem, faz com que as pessoas interpretem mal a importância delas em um contexto multi-linguagem, como é o caso do Spark em que a linguagem pode ser pouco relevante. Algumas vezes é crítico, mas via de regra é muito menos importante que outras questões como organização dos dados por exemplo.

### Qualquer uma então?

Pela início do meu argumento, parece que para usar Spark não importa a linguagem utilizada. Em algum nível sim, mas por que não se usa Scala sempre que possível?

Imagine um processo novo de ETL dentro de um ambiente Hadoop, em que a maioria das tecnologias é baseada na JDK. Usando Scala, é garantido que o acesso a API do Spark será o mais amplo e com a melhor performance, se for necessário alguma integração com ferramentas do ambiente (*e.g.* HDFS, YARN, ZooKeeper) não deve ser um problema pela interoperabilidade de Scala com Java. 

Nesse cenário, Scala deveria ser uma decisão *no-brainer* do ponto de vista técnico. Mas o elefante na sala é justamente usar Scala, uma linguagem [díficil de aprender](https://www.quora.com/Why-is-Scala-so-hard-to-learn) por ser muito complexa em sua proposta multi-paradigma e com muitos recursos. 

Entendo o medo de Scala, não é injustificado, mas só eu acho curioso que não existe o mesmo medo com Spark? Saber usar Spark não é sobre conhecer as APIs, mas entender o que está acontecendo embaixo do capô para não cair em problemas de shuffle e falta de memória. Processamento distribuído é umas dos tópicos mais complexos de computação.

Dominando o Spark, não importa tanto a linguagem, são claro os casos em que Pyhton não é uma boa escolha por exemplo. Mas fugir de Scala, vai atrapalhar justamente essa caminhada de dominar o Spark, talvez ser até um barreira. Em outras palavras, é mais díficil saber Spark se não souber Scala.

Sabendo os conceitos de linguagem, Scala deixa de ser um bicho papão e se torna apenas mais uma linguagem. Um problema a menos, na díficil jornada de usar Spark.

## Linguagem são conceitos aplicados

Uma linguagem é um "catado" de recursos, e o Scala é uma que procura implementar muitos recursos. O *slogan* da linguagem é combinar recursos de orientação a objetos e programação, já que o criador considera que são conceitos ortogonais.

Pode-se dizer que foi uma proposta de sucesso, não chega a ser uma linguagem popular, mas há projetos populares em Scala como Akka e o próprio Spark. Linguagens populares de mercado adotaram alguns conceitos funcionais, como é o caso de Java e C#, corroborando que é possível fazer essa mistura de paradigmas.

O problema é que essa mistura torna Scala uma linguagem mais complexa, porque se multiplicam as possibilidades. Optar por implementar polimorfismo usando classes ou funções de alta ordem, são abordagens bem diferente para um mesmo problema. Por outro lado, a vantagem de uma linguagem complexa é justamente as possibilidades e a flexibilidade.

Sabendo os conceitos, é mais fácil navegar nessas possibilidades e aproveitá-las da melhor forma. O curso não aborda Scala, mas debate vários conceitos chaves dela a partir de outras linguagens. 

Das linguagens abordadas no curso, talvez SML seja a que mais lembra Scala em ideias como inferência de tipo, pattern-matching, options e currying. Questões mais gerais, presentes em qualquer linguagem funcional, também são apresentados como recursão, funções de alta-ordem e closures. 

Além de SML e Racket para explicar programação funcional, orientação a objetos também é discutido com Ruby. No final do curso, um mesmo problema é abordado usando SML e Ruby, para exemplificar a diferença de abordagem entre os paradigmas. Um ponto muito interessante para quem lida com Scala, que suporta as duas abordagens. Mas qual é a melhor para o seu problema?

Em resumo, se eu tivesse feito o curso antes de aprender Scala, eu teria muito mais facilidade em evoluir nela e feito código de melhor qualidade. Por outro lado, é verdade que eu me virei, entendendo muito dessas ideias de forma superficial e por analogias. Por exemplo, interpretar o `map` como um `loop` que retorna sempre o resultado da última linha.

Mas além de simplesmente facilitar o uso de Scala, entender esses conceitos ajudam a entender os porquês do Spark, afinal a linguagem não foi escolhida por acaso para desenvolver o projeto.

## Formalismos são chatos, mas enriquecem

Uma questão curiosa, é que apesar de muita discussõ não é muito simples explicar as diferenças entre as abordagens funcionais e imperativas, a não ser voltando ainda mais e indo para teoria da computação.

Esses paradigmas se originaram de conceitos diferentes de computação. O imperativo é baseado na máquina de Turing, com base na qual os computadores reais são feitos, enquanto o funcional é baseado em [lambda calculus](https://www.youtube.com/watch?v=eis11j_iGMs). São teorias de computação diferentes, mas [equivalentes entre si](https://www.youtube.com/watch?v=eis11j_iGMs). Ou seja, o que pode ser resolvido em máquina de Turing pode ser resolvido em lambda calculus.

Eu sei muito pouco sobre teoria da computação, mas um entendimento superficial, já ilumina questões de programação funcional que parecem simplesmente arbitrárias como imutabilidade e ausência de laços. Em geral, são ideias explicadas sem um contexto, simplesmente que recursão é o "jeito funcional" de resolver as coisas.

Há muita discussão atualmente sobre os méritos de programação funcional, mas vou abordar apenas a questão de performance. O paradigma imperativa faz mais sentido, em termos de otimização, já que é uma abstração mais próxima do computador. Transformar um laço em código de máquina é muito mais fácil que uma função recursiva.

Por outro lado, em um cenário de paralelismo, as chatices dos conceitos funcionais facilitam separa o que pode ou não ser paralelizado. Sabendo conceitualmente o que é uma operação de `map`, é claro o porquê dele pode ser paralelizado, encadeado e executado apenas ao final. São ideias chaves para o Spark funcionar, que vieram "de graça" da teoria de lambda calculus e linguagens funcionais.

Um exemplo mais extremo e bem sucedido dessa estratégia, de aproveitar restrições e formalidades para uma melhor solução, é o SQL. A linguagem SQL é focada em operações de conjunto, que é simples de usar e se adapta muito bem a problemas de dados, basta ver quão popular ela é mesmo entre pessoas que não se consideram programadoras.

Não se pensa muito nisso mas, o escopo limitado do SQL e a fundação teórica em conjuntos, permitem que os otimizadores de consultas façam coisas mágicas. Uma consulta SQL pode ser reescrita pelo otimizador, garantindo o mesmo resultado com maior eficiência. A partir de estatísticas descritivas, tanto do dado como do banco de dados, uma mesma consulta pode optar por estratégia completamente distintas de busca/junção para resolver o problema.

Acho interessante refletir nessas ideias, tornam mais clara as ideias das decisões. 
