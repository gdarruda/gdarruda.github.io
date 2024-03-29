---
layout: post
title: "Dando um passo para trás"
comments: true
mathjax: true
description: "Por que aprender linguagens estranhas?"
keywords: "Programação Funcional, Linguagens, Conceitos"
---

Uma discussão comum na área de programação é a relevância das graduações –  especialmente as que seguem os currículos tradicionais – em um mercado que evolui rapidamente e se torna mais heterogêneo.

Um dos pontos mais debatidos são os tópicos de estruturas de dados, que talvez seja o conteúdo mais simbólico dos cursos de computação. É um assunto que resume bem a questão central do debate: qual a importância de entender como é implementado, saber se aquele comando `get` do banco de dados faz uma busca em árvore ou tabela hash?

Não acho que haja uma reposta simples, como é a regra nessas discussões intermináveis. A utilidade prática depende muito do escopo do trabalho, não é igual para todo programador. Há até um certo esnobismo misturado nessa discussão, uma ideia de que programdores "de verdade" precisam entender de estrutura de dados. Para completar, entra também uma questão muito pessoal e subjetiva, que é a forma de aprender e trabalhar de cada um.

Apesar de estrutura de dados e algoritmos serem o centro do debate, existe um outro tópico de computação que acho mais relevante, mas que ao mesmo tempo é menos foco de interesse. No caso, estou falando dos conceitos de linguagens de programação.

## Linguagens de programação

É normal nas graduações existir uma matéria chamanda "linguagens de programação" ou algo do gênero, que aborda as ideias por trás delas, como os diferentes paradigmas e tipos de sintaxe. Não cheguei a cursar durante minha graduação, acredito que era optativa, mas achei esse [ótimo curso](https://www.coursera.org/learn/programming-languages?) que é basicamente esse tipo de conteúdo em formato de MOOC.

O curso aborda três linguagens: SML, Racket e Ruby. Exceto no caso do Ruby, não são linguagens populares no mercado. O instrutor sabe disso, mas são escolhas muito bem justificadas para explicar o conteúdo do curso, já que o ponto é abordar o design de linguagens e não simplesmente aprender a utilizá-las.

Essa abordagem é justamente o que torna o curso bom, veja alguns pontos interessantes debatidos durante o curso:

* Qual a diferença entre "tipagem" estática e dinâmica? 
* Qual a relação entre tipos e classes?
* Qual o ponto da imutabilidade?
* Como abordar um problema pela perspectiva funcional e orientada à objetos?

Discutir essas questões não é necessário para programar nessas linguagens, entram no mesmo tipo de discussão em relação a estrutura de dados. Entretanto, argumento que lidar com esses conceitos são problemas comuns a todos os programadores, mais presentes no dia-a-dia que tópicos de estrutura de dados inclusive.

Sempre foi importante conhecer um pouco sobre isso, mas pelas últimas tendências de mercado, responder a esses tipos de questão se tornou muito mais relevante.

No trabalho anterior, lidei muito com Spark em diversos casos de uso: processos de ETL, análise exploratória e implantação de modelos. Acredito que seja interessante o caso do Spark, porque os diferentes casos de uso trazem respostas diferentes para a pergunta que eu sempre ouvia no começo de todo projeto: a gente vai usar qual linguagem?

Para quem desconhece, o [Apache Spark](https://spark.apache.org/) é uma solução para trabalhar com manipulação de dados massivos em paralelo. Ele é desenvolvido em [Scala](https://scala-lang.org/), mas tem APIs para diversas outras como Python, Java e R por exemplo. Por isso, é uma questão comum definir qual linguagem a ser utilizada em um projeto com Spark.

## Quanto importa a linguagem?

O primeiro ponto na escolha de uma linguagem, para qualquer projeto, é a viabilidade técnica. O que envolve vários aspectos, mas pode ser resumida a uma pergunta: dá para resolver esse problema usando essa linguagem?

Em geral, esse tipo de decisão era menos frequente, já que normalmente envolve muito mais coisas que apenas a linguagem de programação.  Quando se fala de programar em Java, via de regra, não se está falando somente da linguagem, mas de tudo que está ao entorno dela: JDK, servidor de aplicação, bibliotecas, frameworks, etc.

Hoje há mais flexibilidade em relação à linguagem – é possível e razoável usar diversas linguagens dentro de plataformas como JDK e .NET por exemplo – mantendo interoperabilidade (em algum nível) com todo o ecossistema existente. No caso do Spark, ter dois projetos usando linguagens diferentes no mesmo ambiente não costuma ser um grande problema, já que é uma solução desenhada com essa flexibilidade em mente.

Como não era muito comum escolher linguagens, nem sempre é claro onde "começa" e "termina" a linguagem para alguns desenvolvedores. Parece bobo, mas talvez a primeira motivação para aprender sobre linguagens, é justamente entender do que se trata uma.

A dificuldade em compreender o escopo da linguagem dentro da solução, faz com que as pessoas interpretem mal a importância delas em um contexto multi-linguagem. No caso do Spark, sinto que muitas vezes superestimam a importância. Em geral, se a linguagem tem acesso às APIs Spark necessárias para o projeto, ele funcionará bem em Java, Python ou Scala.

### Qualquer uma então?

Pela início do meu argumento, parece que para usar Spark não importa a linguagem utilizada. Em algum nível, é isso mesmo, mas por que não usar Scala sempre que possível?

Imagine um processo novo de ETL dentro de um ambiente Hadoop, em que a maioria das tecnologias é baseada na JDK. Usando Scala, é garantido que o acesso a API do Spark será o mais amplo e com a melhor performance. Se for necessário alguma integração com ferramentas do ambiente (*e.g.* HDFS, YARN, ZooKeeper), não deve ser um problema pela interoperabilidade de Scala com Java. 

Nesse cenário, Scala deveria ser uma decisão *no-brainer* do ponto de vista técnico. Mas o elefante na sala é justamente usar Scala, uma linguagem pouca popular e com fama de ser [díficil de aprender](https://www.quora.com/Why-is-Scala-so-hard-to-learn).

Entendo o medo de Scala, não é injustificado, mas só eu acho curioso que não existe o mesmo medo com Spark? Saber usar Spark não é sobre conhecer as APIs, mas entender o que está acontecendo embaixo do capô para não cair em problemas de shuffle e falta de memória. Processamento distribuído é um dos tópicos mais complexos de computação, certamente mais complexo que aprender Scala.

Dominando o Spark, não importa tanto a linguagem, fica fácil identificar os casos em que é razoável usar Python ou não por exemplo. Mas fugir de Scala, vai atrapalhar justamente essa caminhada de dominar o Spark, talvez ser até um barreira. Afinal, o código fonte do Spark está em Scala.

Em outras palavras, é mais díficil saber Spark se não souber Scala.

Sabendo os conceitos de linguagens de programação, Scala deixa de ser um bicho papão e se torna apenas mais uma linguagem. Um problema a menos, na díficil jornada de usar Spark.

## Linguagem são conceitos aplicados

Uma linguagem é um "catado" de recursos, e Scala é uma que procura implementar muitos deles. O *slogan* da linguagem é combinar recursos de orientação a objetos e funcional, o criador considera que são conceitos ortogonais e podem ser integrados.

Pode-se dizer que foi uma proposta de sucesso, não chega a ser uma linguagem popular, mas há projetos relevantes em Scala como Akka e o próprio Spark. Linguagens muito populares no mercado adotaram alguns conceitos funcionais, como é o caso de Java e C#, corroborando que é possível fazer essa mistura de paradigmas.

O problema é que essa mistura torna Scala uma linguagem complexa, porque se multiplicam as possibilidades. Implementar polimorfismo usando classes ou funções de alta ordem, são abordagens bem diferentes para um mesmo problema que a linguagem possibilita. Por outro lado, essas possibilidades e a flexibilidade são justamente as vantagens de Scala.

Sabendo os conceitos de linguagens de programação, é mais fácil navegar nessas possibilidades e aproveitá-las da melhor forma. O curso não aborda Scala, mas debate conceitos chaves dela a partir de outras linguagens. 

Das linguagens abordadas, talvez SML seja a que mais lembra Scala em ideias como inferência de tipo, pattern-matching, options e currying. Questões mais gerais como recursão, funções de alta ordem e closures – presentes em Scala e qualquer outra linguagem funcional – também são apresentadas no curso.

Além de SML e Racket para explicar programação funcional, orientação a objetos também é discutida usando Ruby. No final do curso, um mesmo problema é abordado usando SML e Ruby, para exemplificar a diferença dos paradigmas. Um ponto muito interessante para quem usa Scala, que abraça as duas abordagens: como decidir qual é a melhor para o seu problema?

Se eu tivesse feito o curso, antes de aprender Scala, seria muito mais fácil evoluir nela e os códigos teriam maior qualidade. Por outro lado, é verdade que eu me virei, entendendo muito dessas ideias de forma superficial e por analogias. Por exemplo, interpretar o `map` como um `loop` que retorna sempre o resultado da última linha.

Mas além de simplesmente facilitar o aprendizado de Scala, entender esses conceitos ajudam a compreender melhor os porquês do Spark, afinal a linguagem não foi escolhida por acaso para desenvolver o projeto.

## Formalismos são chatos, mas úteis

Apesar de se falar muito em programação funcional, não é muito simples definir o que é. Os paradigmas imperativo e funcionais se originaram de diferentes teorias de computação, mas que na prática se misturam nas linguagens de programação.

O paradigma imperativo é baseado na máquina de Turing, com base na qual os computadores reais são feitos, enquanto o funcional é baseado em [lambda calculus](https://www.youtube.com/watch?v=eis11j_iGMs). São teorias diferentes, mas [equivalentes entre si](https://www.youtube.com/watch?v=eis11j_iGMs): o que pode ser resolvido em máquina de Turing pode ser resolvido em lambda calculus.

Em termos de otimização de código, o paradigma imperativo faz mais sentido, já que é uma abstração mais próxima do computador real que utilizamos. Transformar um laço em código de máquina eficiente é mais fácil, por exemplo, que transformar uma função recursiva.

Por outro lado, ao lidar com paralelismo, alguns conceitos de linguagens funcionais facilitam o trabalho. A partir da definição de `map`, é possível entender o porquê dele poder ser paralelizado, encadeado e ter a execução postergada. São ideias chaves para o Spark funcionar, que vieram "de graça" da teoria de lambda calculus e linguagens funcionais.

Um exemplo dessa ideia, de aproveitar conceitos da linguagem para uma melhor solução prática, é o SQL. A linguagem é focada em operações de conjuntos, que a torna simples de usar e se adapta muito bem a problemas de dados.

Não se pensa muito nisso, mas o escopo limitado do SQL e a fundação teórica em conjuntos, permitem que os otimizadores de consultas façam coisas mágicas. A partir de estatísticas descritivas, tanto do banco de dados em si como da performance do ambiente, uma mesma consulta SQL pode optar por estratégias completamente distintas de busca/junção para chegar ao resultado de forma mais eficiente.

É interessante pensar nisso, porque as ideias de programação funcional são instrumentais para o sucesso das soluções de dados, especialmente as que ficam sob o guarda-chuva da Big Data. O Scala faz muito sentido nesse contexto, pois ao mesmo tempo que foca na abordagem funcional, se integra muito bem com a realidade de sistemas corporativos em que a orientação a objetos e Java são muito consolidados.

## Por que não Scala?

Ao mesmo tempo que o Scala faz muito sentido como principal linguagem do Spark, para usá-lo nem sempre é o caso. Talvez, até haja mais casos em que Scala não é a melhor linguagem para se usar Spark.

Para um cientista de dados, normalmente Python é uma melhor opção. Pensando em análises exploratórias e experimentos, Python possui todo um ecossistema de ciência de dados a disposição e [Spark SQL](https://spark.apache.org/sql/) atende muito da manipulação pesada de dados. Fora essas questões práticas, sendo uma linguagem dinâmica, é ideal por design para desenvolver esse trabalho de experimentação.

Por outro lado, se eu precisar colocar um modelo em produção, que integre com sistemas críticos, provavelmente optaria por Scala. Pessoalmente, eu prefiro linguagens com tipos estáticos para esses casos, já que me fornecem garantias maiores. Ter acesso às bibliotecas Java e a API completa do Spark são diferenciais interessantes também. Se a decisão final é por um modelo disponível na [MLlib](https://spark.apache.org/docs/latest/ml-guide.html), Scala me parece uma melhor opção.

Essa decisão sobre a linguagem para o projeto depende de vários fatores, entendendo mais profundamente as diferenças entre elas, é mais fácil mensurar os *trade-offs* dessa escolha. Quando eu falo que Scala é "melhor" para usar Spark, o que isso significa exatamente? 

Não são apenas decisões técnicas, há muitos pontos subjetivos e dependentes do contexto (*e.g* projeto, conhecimento do time, tempo) que só os envolvidos conseguem avaliar.

## Próximo passo para trás

O curso, apesar de discutir muitos conceitos, não se propõe a entrar muito em tópicos como teoria das categorias ou lambda calculus. Coisas como functors, monoides e mônadas não aparecem no curso e continuam não significando nada para mim. Meu próximo passo, para trás no caso, seria aprender um poucos dessas ideias a partir de um linguagem mais formal como Haskell. 

Ao mexer com desenvolvimento, acredito que seja comum essa ideia primeiro aprender a usar as ferramentas e resolver os problemas, para depois entender os conceitos por trás. É o caminho inverso da academia, o que talvez seja o motivo de tanto discussão sobre o currículo das graduações. Até costumo dizer que, provavelmente, as pessoas achariam mais útil uma se fizessem o curso depois de alguns anos de trabalho.

Dar esse passo para trás, entender melhor o que está por trás das coisas, não é algo muito incentivado [pelo mercado](/2020/08/02/adequando-se-mercado.html). Talvez, realmente não faça sentido para todos, mas acho que esse caminho facilita o aprendizado futuro. Mais importante, melhora a tomada de decisão, porque os motivos são mais claros por trás das tecnologias (*e.g* linguagens, frameworks, banco de dados, bibliotecas).

Além de tudo, simplesmente acho gratificante entender algumas coisas.