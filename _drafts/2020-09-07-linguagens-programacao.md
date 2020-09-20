---
layout: post
title: "Dando um passo para trás"
comments: true
mathjax: true
description: "Por que aprender linguagens estranhas?"
keywords: "Programação Funcional, Linguagens, Conceitos"
---

Uma discussão comum na área de programação é a relevância das graduações –  especialmente as que seguem os currículos tradicionais – em um mercado que evolui rapidamente e se torna mais heterogêneo.

Um dos pontos mais debatidos são os tópicos de estruturas de dados, que talvez seja o conteúdo mais simbólico dos cursos de computação. É um tópico que resume bem a questão central do debate: qual a importância de entender como é implementado, saber se aquele comando `get` do banco de dados faz uma busca em árvore ou tabela hash?

Não acho que haja uma reposta simples, como é comum nessas discussões intermináveis. A utilidade prática depende muito do escopo do trabalho, não é igual para todo programador. Há um certo esnobismo misturado nessa discussão, uma ideia de que programdores "de verdade" precisam entender de estrutura de dados. Para completar, há uma questão muito pessoal e subjetiva, que é a forma de aprender e trabalhar de cada um.

Apesar de estrutura de dados e algoritmos serem o centro do debate, acredito que existe um outro tópico de computação que mais pessoas concordem na sua relevância, mas é menos foco de interesse. No caso, estou falando dos conceitos de linguagens de programação.

## Linguagens de programação

É normal nas graduações ter alguma matéria chamanda "linguagens de programação" ou algo do gênero, que aborda as ideias por trás delas, como os diferentes paradigmas e tipos de sintaxe. Não cheguei a cursar durante a graduação, acredito que era optativa, mas achei esse [ótimo curso](https://www.coursera.org/learn/programming-languages?) que é basicamente esse tipo de conteúdo em formato de MOOC.

O curso aborda três linguagens: SML, Racket e Ruby. Exceto no caso do Ruby, não são linguagens populares no mercado. O professor sabe disso, mas são escolhas muito bem justificadas para explicar o conteúdo do curso, já que o ponto é abordar o design de linguagens e não simplesmente aprender a utilizá-las.

Essa abordagem reflexiva é justamente o que torna o curso bom, veja alguns pontos interessantes debatidos durante o curso:

* Qual a diferença entre "tipagem" estática e dinâmica? 
* Qual a relação entre tipos e classes?
* Qual o ponto da imutabilidade?
* Como abordar um problema pela perspectiva funcional e orientada à objetos?

Discutir essas questões não é necessário para programar, entram no mesmo tipo de discussão em relação a estrutura de dados. Entretanto, argumento que lidar com esses conceitos são problemas comuns a todos os programadores, mais presentes no dia-a-dia que tópicos de estrutura de dados inclusive.

Sempre foi importante conhecer um pouco sobre isso, mas pelas últimas tendências de mercado, responder a esses tipos de questão se tornou muito mais relevante.

No trabalho anterior, lidei muito com Spark em diversos casos de uso: processos de ETL, análise exploratória e implantação de modelos. Acredito que seja interessante o caso do Spark, porque os diferentes casos de uso trazem respostas diferentes para a pergunta que eu sempre ouvia no começo de todo projeto: a gente vai usar qual linguagem?

O [Apache Spark](https://spark.apache.org/) é uma solução para trabalhar com manipulação de dados massivos em paralelo. Ele é desenvolvido em [Scala](https://scala-lang.org/), mas tem APIs para diversas outras como Python, Java e R por exemplo. Por isso, é uma questão comum definir qual linguagem a ser utilizada em um projeto com Spark.

## Quanto importa a linguagem?

O primeiro ponto na escolha de uma linguagem, seja para o Spark ou para qualquer projeto, é a viabilidade técnica. O que envolve vários aspectos, mas pode ser resumida a uma pergunta: dá para resolver esse problema usando essa linguagem?

Em geral, esse tipo de decisão era menos frequente, já que essa decisão noralmente envolve muito mais coisas que apenas a linguagem de programação.  Quando se fala Java, via de regra não se está falando sobre a linguagem em si, mas de tudo que está ao entorno dela: JDK, servidor de aplicação, bibliotecas, frameworks, etc. Um pacote de coisas, que a linguagem faz parte.

Hoje há mais flexibilidade – é possível e razoável usar diversas linguagens dentro de plataformas como JDK e .NET por exemplo – mantendo interoperabilidade (em algum nível) com todo o ecossistema existente. No caso do Spark, ter dois projetos usando linguagens diferentes no mesmo ambiente não costuma ser um grande problema, já que é uma solução desenhada com essa flexibilidade em mente.

Como não era muito comum escolher linguagens, nem sempre é claro onde "começa" e "termina" a linguagem para alguns desenvolvedores. Parece bobo, mas talvez a primeira motivação para aprender sobre linguagens, é justamente entender do que se trata uma.

A dificuldade em compreender o escopo da linguagem dentro da solução, faz com que as pessoas interpretem mal a importância delas em um contexto multi-linguagem. Em geral, sendo possível resolver o problema, não é algo tão crucial para solução Spark a linguagem já que é algo desenhado para suportar múltiplas linguagens.

### Qualquer uma então?

Pela início do meu argumento, parece que para usar Spark não importa a linguagem utilizada. Em algum nível sim, mas por que não se usa Scala sempre que possível?

Imagine um processo novo de ETL dentro de um ambiente Hadoop, em que a maioria das tecnologias é baseada na JDK. Usando Scala, é garantido que o acesso a API do Spark será o mais amplo e com a melhor performance, se for necessário alguma integração com ferramentas do ambiente (*e.g.* HDFS, YARN, ZooKeeper) não deve ser um problema pela interoperabilidade de Scala com Java. 

Nesse cenário, Scala deveria ser uma decisão *no-brainer* do ponto de vista técnico. Mas o elefante na sala é justamente usar Scala, uma linguagem [díficil de aprender](https://www.quora.com/Why-is-Scala-so-hard-to-learn) por ser muito complexa em sua proposta multi-paradigma e com muitos recursos. 

Entendo o medo de Scala, não é injustificado, mas só eu acho curioso que não existe o mesmo medo com Spark? Saber usar Spark não é sobre conhecer as APIs, mas entender o que está acontecendo embaixo do capô para não cair em problemas de shuffle e falta de memória. Processamento distribuído é um dos tópicos mais complexos de computação, certamente mais complexo que aprender Scala.

Dominando o Spark, não importa tanto a linguagem, são claro os casos em que Pyhton não é uma boa escolha por exemplo. Mas fugir de Scala, vai atrapalhar justamente essa caminhada de dominar o Spark, talvez ser até um barreira. Em outras palavras, é mais díficil saber Spark se não souber Scala.

Sabendo os conceitos de linguagem, Scala deixa de ser um bicho papão e se torna apenas mais uma linguagem. Um problema a menos, na díficil jornada de usar Spark.

## Linguagem são conceitos aplicados

Uma linguagem é um "catado" de recursos, e o Scala é uma que procura implementar muitos recursos. O *slogan* da linguagem é combinar recursos de orientação a objetos e programação, já que o criador considera que são conceitos ortogonais.

Pode-se dizer que foi uma proposta de sucesso, não chega a ser uma linguagem popular, mas há projetos relevantes em Scala como Akka e o próprio Spark. Linguagens populares de mercado adotaram alguns conceitos funcionais, como é o caso de Java e C#, corroborando que é possível fazer essa mistura de paradigmas.

O problema é que essa mistura torna Scala uma linguagem mais complexa, porque se multiplicam as possibilidades. Optar por implementar polimorfismo usando classes ou funções de alta ordem, são abordagens bem diferentes para um mesmo problema. Por outro lado, a vantagem de uma linguagem complexa é justamente as possibilidades e a flexibilidade.

Sabendo os conceitos de linguagens de programação, é mais fácil navegar nessas possibilidades e aproveitá-las da melhor forma. O curso não aborda Scala, mas debate conceitos chaves dela a partir de outras linguagens. 

Das linguagens abordadas no curso, talvez SML seja a que mais lembra Scala em ideias como inferência de tipo, pattern-matching, options e currying. Questões mais gerais de linguagens funcionais como recursão, funções de alta-ordem e closures – presentes em Scala e qualquer outra linguagem funcional – também são apresentadas no curso.

Além de SML e Racket para explicar programação funcional, orientação a objetos também é discutida usando Ruby. No final do curso, um mesmo problema é abordado usando SML e Ruby, para exemplificar a diferença dos paradigmas. Um ponto muito interessante para quem usa Scala, que abraça as duas abordagens. Mas qual é a melhor para o seu problema?

Em resumo, se eu tivesse feito o curso antes de aprender Scala, eu teria muito mais facilidade em evoluir nela e feito código de melhor qualidade. Por outro lado, é verdade que eu me virei, entendendo muito dessas ideias de forma superficial e por analogias. Por exemplo, interpretar o `map` como um `loop` que retorna sempre o resultado da última linha.

Mas além de simplesmente facilitar o aprendizado de Scala, entender esses conceitos ajudam a entender melhor os porquês do Spark, afinal a linguagem não foi escolhida por acaso para desenvolver o projeto.

## Formalismos são chatos, mas cruciais

Apesar de se falar muito em programação funcional, não é muito simples definir exatamente do que se trata, explicar diferença entre imperativo e funcional.

Esses paradigmas se originaram de teorias diferentes de computação. O imperativo é baseado na máquina de Turing, com base na qual os computadores reais são feitos, enquanto o funcional é baseado em [lambda calculus](https://www.youtube.com/watch?v=eis11j_iGMs). São teorias diferentes, mas [equivalentes entre si](https://www.youtube.com/watch?v=eis11j_iGMs). Ou seja, o que pode ser resolvido em máquina de Turing pode ser resolvido em lambda calculus.

O paradigma imperativa faz mais sentido, em termos de otimização de baixo nível, já que é uma abstração mais próxima do computador real que utilizamos. Transformar um laço em código de máquina eficiente é mais fácil que transformar uma função recursiva.

Por outro lado, em um cenário de paralelismo, as chatices dos conceitos funcionais facilitam identificar o que pode ou não ser paralelizado. A partir das restrições de uma operação de `map`, é possível entender o porquê dele pode ser paralelizado, encadeado e ter a execução postergada. São ideias chaves para o Spark funcionar, que vieram "de graça" da teoria de lambda calculus e linguagens funcionais.

Um exemplo mais extremo e muito bem sucedido dessa estratégia, de aproveitar restrições e formalidades para uma melhor solução, é o SQL. A linguagem é focada em operações de conjuntos, que a torna simples de usar e se adapta muito bem a problemas de dados, basta ver a popularidade dela entre usuários.

Não se pensa muito nisso mas o escopo limitado do SQL e a fundação teórica em conjuntos, permitem que os otimizadores de SQL façam coisas mágicas. Uma consulta SQL pode ser reescrita pelo otimizador, garantindo o mesmo resultado com maior eficiência. A partir de estatísticas descritivas, tanto do banco de dados em si como da performance do ambiente, uma mesma consulta pode optar por estratégia completamente distintas de busca/junção ao executar uma consulta.

É interessante pensar nisso, porque as ideias de programação funcional são instrumentais para o sucesso das soluções de dados, especialmente as que ficam no guarda-chuva da Big Data. O Scala faz muito sentido, ao mesmo tempo que foca na abordagem funcional, se integra muito bem com a realidade corporativa em que a orientação a objetos e Java são muito consolidados.

## Por que não Scala?

Ao mesmo tempo que o Scala faz muito sentido para desenvolver o Spark, utiliza-lo da melhor forma possível, talvez haja mais motivos para não utiliza-lo.

Atuando como cientista, prefiro Python e não Scala para usar com Spark. Para análises exploratórias e experimentos, Python tem todo o ecossistema de ciência de dados a disposição e Spark SQL resolve a maioria dos problemas. Sendo uma linguagem de tipos dinâmicos, é mais prática para experimentação que Scala por exemplo.

Por outro lado, se eu precisar colocar um modelo em produção, que integre com sistemas críticos provavelmente optaria por Scala. Para produção, prefiro linguagens com tipos estatísticos, um pouco menos de praticidade que se paga ao meu ver. Depende do tipo de modelo, já que o ecossistemas de Python para ciência de dados é muito mais rico, talvez o modelo ideal para o problema não tenha uma solução em Scala ou Java.

As escolhas geralmente ficam em Python ou Scala, mas existem outros cenários que outras linguagens fazem sentido. 

## Próximo passo para trás

O curso, apesar de discutir muitos conceitos, não se propõe a entrar muito em coisas como teoria das categorias ou lambda calculus. Termos como functors, monoides e mônadas não aparecem no curso e continuam não significando nada para mim. Meu próximo passo, para trás no caso, seria aprender um poucos dessas ideias a partir de um linguagem mais formal como Haskell. 

Ao mexer com desenvolvimento, acredito que essa seja um fluxo comum: primeiro se aprende a usar as ferramentas e resolver os problemas, depois se aprende os conceitos por trás. É o caminho inverso da academia, o que talvez seja o motivo de tanto discussão sobre o currículo delas. Até costumo dizer que, provavelmente, as pessoas achariam mais útil uma se fizessem o curso depois de alguns anos de trabalho.

Dar esse passo para trás, entender melhor o que está por trás das coisas, não é algo muito incentivado. Talvez, realmente não faça sentido para todos, mas acho que entender facilita o aprendizado. Mais importante, melhora a tomada de decisão, porque os motivos são mais claros por trás das tecnologias (*e.g* linguagens, frameworks, banco de dados, bibliotecas).

Por fim, acho gratificante simplesmente entender mais algumas coisas.