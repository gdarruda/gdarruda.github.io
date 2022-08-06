---
layout: post
title: "Data Mesh e os problemas (ainda) em aberto"
comments: true
mathjax: false
---

A expectativa em relação ao uso de dados nas empresas é enorme, quem na área de ados nunca ouvi que [dados são o novo petróleo](https://www.economist.com/leaders/2017/05/06/the-worlds-most-valuable-resource-is-no-longer-oil-but-data)? Talvez, mas no contexto das grandes empresas, usar os dados espalhados pelos departamentos é como extrair petróleo de águas profundas.

Existem inúmeras e variadas dificuldades para grandes empresas extraírem valor dos dados que possuem, mas – dentro das minhas experiências atuando como analista, engenheiro e cientista de dados – a parte da engenharia tem sido o maior problema.

Há diversos relatórios que indicam grandes dificuldades e poucos resultados no uso de dados ([1](https://www.forbes.com/sites/randybean/2020/10/20/the-failure-of-big-data/?sh=2d9b4bdfa218), [2](https://www.mckinsey.com/business-functions/quantumblack/our-insights/ten-red-flags-signaling-your-analytics-program-will-fail), [3](https://venturebeat.com/2019/07/19/why-do-87-of-data-science-projects-never-make-it-into-production/))
. Uma sensação que, após uma década de entusiasmo e expectativa, o resultado geral ficou bem aquém do esperado.

Nesse contexto, surgiu o *Data Mesh*: uma proposta "sociotécnica" para compartilhar, acessar e gerenciar dados em grandes empresas.

É um assunto muito recente, a única literatura disponível sobre o assunto é o livro [Data Mesh da Zhamak Dehghani](https://www.oreilly.com/library/view/data-mesh/9781492092384/). Ele aborda o problema a partir de uma perspectiva teórica, usando uma empresa fictícia que trabalha com streaming de música. Ou seja, é mais uma proposta que um conjunto de práticas consolidado.

É algo novo e que ainda precisa se provar, mas gostei muito da ideia geral. Se a maioria das empresas não consegue utilizar dados, provavelmente é um problema mais organizacional que técnico.

O foco do Data Mesh é a gestão federada de dados, aumentando agilidade e autonomia em estruturas organizacionais complexas. É uma ideia alinhada tendências do mercado de tecnologia, tanto organizacionais como técnicas (*e.g*  microsserviços, metodologias ágeis, design orientado a eventos, cloud e DevOps).

O Mesh aborda os principais gargalos organizacionais, mas enxergo que algumas barreiras técnicas devem continuar atrapalhando a jornada do dado. Minha ideia é discutir esses pontos, onde enxergo dificuldades técnicas para viabilizar uma estratégia de dados. 

Esse post não é uma resenha do livro ou para explicar Data Mesh, 
a autora do livro tem um [post resumo](https://martinfowler.com/articles/data-mesh-principles.html) no blog do Martin Fowler para quem estiver procurando uma introdução ao tema.

## Complexidade das ferramentas como obstáculo a federação

O alvo principoal da gestão federada é lidar com os gargalos gerado por um departamento de dados centralizado, responsável pelos pipelines de dados. Para distribuir as responsabilidades, de construção e manutenção dos pipelines de dados, é necessário distribuir capacidade técnica para a empresa toda.

A autora propõe que a plataforma do Data Mesh pense em facilidade de uso, para que "qualquer" engenheiro de software consiga implementar e manter pipelines de dados.

> Incentivizing and enabling generalist developers with experiences, languages, and APIs that are easy to learn is a starting point to lower the cognitive load of generalist developers. To scale out data-driven develop‐ ment to the larger population of practitioners, data mesh platforms must stay relevant to generalist technologists.

<!-- p 53  -->
Concordo com a proposta, mas discordo do diagnóstico do problema.

Argumenta-se que os engenheiros de dados são necessários, porque usamos muitas tecnologias proprietárias verticalizadas que demandam muito conhecimento especializado.

> Another barrier to the adoption of data platforms today is the level of proprietary specialization that each technology vendor assumes—the jargon and the vendor- specific knowledge. This has led to the creation of scarce specialized roles such as data engineers.

<!-- p 52  -->

Nesse sentido, uma abordagem seria privilegiar tecnologias com filosofia Unix: ferramentas mais simples focadas, mas que sejam interoperáveis e possam ser combinadas para gerar soluções maiores.

> If a data mesh platform wants to realistically scale out sharing data, within and beyond the bounds of an organization, it must wholeheartedly embrace the Unix philosophy and yet adapt it to the unique needs of data management and data sharing. It must design the platform as a set of interoperable services that can be implemented by different vendors with different implementations yet play nicely with the rest of the platform services.

Infelizmente, acho que o problema é basicamente o oposto: os engenheiros de dados se fazem necessário pois é complexo a tomada de decisão quando há tantos componentes para integrar. É até uma [piada da área](https://pixelastic.github.io/pokemonorbigdata/), a quantidade de ferramentas que podem ser utilizadas para trabalhar com dados. 

<!-- As plataformas de Big Data já seguem a filosofia Unix de componentes especializados e interoperáveis, é até uma [piada](https://pixelastic.github.io/pokemonorbigdata/) a diversidade de ferramentas disponíveis. -->

Soluções proprietárias e verticalizadas trazem uma série de outros problemas, mas normalmente são mais simples por oferecer um pacote fechado e demandar menos tomadas de decisão.

Por exemplo, em uma solução "clássica" de banco de dados relacional ou MPP, todos as consultas SQL passam pelo mesmo motor de processamento: a aplicação conectada via JDBC, as procedures do banco de dados, a ferramenta de BI ou alguém diretamente conectado.

Em um ambiente Big Data, é comum você ter um *metastore* para catalogar o dados, mas diversas formas diferentes de consultar e manipular o dado: é possível usar uma engine SQL como Hive para jobs longos; Presto ou Impala para algo mais tempestivo; Spark para integrar código procedural ou mesmo ler diretamente o storage.

Não é óbvio, para alguém menos especializado, como é completamente diferente usar PySpark conectado a um cluster ou uma biblioteca como o Pandas para acessar o arquivo no storage. Em casos similares, já ouvi perguntas como "mas Gabriel, não estou usando Python para ler a base?"

Para piorar, esse tipo de decisão normalmente precisa ser feita na parte do consumo, que teoricamente são os usuários mais distantes da parte técnica. No cenário acima, uma tomada de decisão errada pode gerar custos enormes e não atender o objetivo final. Não é incomum uma decisão combinar ambos os problemas.

Nesse contexto, vejo muitos usuários preferindo soluções mais amigáveis de *low-code* e *no-code* – normalmente proprietárias e menos abertas para interoperabilidade – que podem trazer outra série de desafios como a autora destaca.

> For example, many low-code or no-code platforms promise to work with data, but compromise on testing, versioning, modularity, and other techniques. Over time they become unmaintainable

<!-- p 53  -->

O maior custo para extrair valor dos dados é o conhecimento necessário para utilizá-las, não o preço delas. Peças interoperáveis e especializadas são ótimas na mão de bons engenheiros, mas são pouco amigáveis para quem não domina o funcionamento interno dessas soluções.

Minha preocupação aqui é muito mais com o consumo dos dados disponibilizados do que com o processo de disponibilização em si.

Imagino que os engenheiros de software das aplidações consigam criar pipelines para disponibilizar e catalogar os dados, mesmo sem muita especialização no assunto. A questão é como facilitar para usuário final: a pessoa mais importante, mas com menos conhecimento técnico.

## Garantia de qualidade

Uma questão chave, para gestão federada, é definir bons critérios de qualidade. Com vários times trabalhando de forma independente, é fácil o Data Lake virar um "Data Swamp": bases sem catalogação adequada, com estrutura física mal desenhada e dados inconsistentes.

### Catalogação de dados

Há uma piada sobre existir apenas duas coisas difíceis em computação: invalidação de cache e nomear coisas. Padronizar nomenclatura a nível corporativo, exponencialmente mais complicado.

Algumas empresas tentam definir padrões de nomenclatura para banco de dados, há diversas denominações para esses padrões, no livro são descritos como *polysemes*.

> Polysemes are shared concepts across different domains. They point to the same entity, with domain-specific attributes. Polysemes represent shared core concepts in a business such as “artist,” “listener,” and “song.”

Utilizar esteiras automatizadas para validar esses *polysemes* em um catálogo é bem plausível, mas a minha questão é anterior: como são organizados esses conceitos?

Talvez eu simplesmente desconheça, mas ao meu ver falta teoria para embasar a motivação e utilidade de criar esses vocabulário. Questões de ontologias e taxonomia são muito amplas e complexas, fora do domínio da computação e com séculos de estudo. Mas o que vejo nas empresas, são soluções intuitivas e simplistas para o problema. 

Para piorar, raramente os padrões práticas cobrem todos os dados, um vocabulário que não expressa as necessidades acaba sendo pouco usado.

Como usuário, normalmente o que procuro é simplesmente um "boa" descrição de cada atributo. É quase indiferente, se temos o conceito de CPF como `num_cpf` e `cod_cpf` no outro, conquanto que eu entenda como eles funcionam em cada domínio.

Mas o que é uma "boa" descrição para um atributo? Ela é boa quando atende o usuário, mas infelizmente não dá para validar essa ideia com uma busca em um banco de dados de *polysemes*.

### Modelagem de tabelas

Erros de modelagem geram débitos técnicos enormes, com juros altíssimos.Uma tabela importante implantada gera uma série de problemas:

* impacta tanto desenvolvedores da aplicação e usuários do dados; 
* a correção costuma envolver movimentações complexas de dados e refazer boa partes dos sistemas;
* pode gerar custos extras de armazenamento e processamento.

Nesse contexto, estão os DBAs e ADs que aprovam modelos de dados, funcionando como um "guardrail" para mitigar esses problemas. Mas é um processo não automatizado, que não escala e vira um gargalo para uma operação federada.

Diferente da questão de nomenclatura, a teoria para modelagem de dados é muito desenvolvida e estável. Assim como a questão das ferramentas de Big Data, modelagem de banco é uma questão de conhecimento e boas práticas que os engenheiros de software podem aprender.

Boas práticas como revisão de código e testes de integração podem mitigar esse problema, mas talvez mereça atenção especial porque alguns erros desse tipo atrapalham muito o uso de dados.

### Testes automatizados

Os testes automatizados são muito valorizados como boa prática de desenvolvimento, entretanto é complicado implementar algo útil em pipeline de dados.

Os pipelines normalmente têm pouca lógica de negócio, testes unitários dificilmente garantem muita coisa nesse cenário. Os testes de integração são complexos, porque como estamos falando de movimentação de dados, que normalmente envolvem várias ferramentas complexas de processamento distribuído.

O maior problema, no entanto, é simular as condições dos dados. A volumetria e a distribuição dos dados são aspectos chaves de um pipeline de dados, perdi a conta das vezes que um processo só quebrou em produção porque os testes com dados mockados não refletiam os gargalos.

Um ambiente de homogalação com condições de reproduzir o cenário de produção é caro e complexo de construir. Depende de uma catalogação muito boa para, por exemplo, mascarar os campos de forma padronizada de forma a manter consistência nos relacionamentos entre domínios.

Um exemplo público foi o [caso do TSE](https://www.tse.jus.br/comunicacao/noticias/2020/Novembro/nota-de-esclarecimento-sobre-nuvem-para-contabilizar-votos), certamente era mais infra que o necessário para apuração de votos, mas não coletaram as estatísticas com dados reais e o otimizador se perdeu.

Erros como esses são complexos de evitar, poucos desenvolvedores sabem a importância da coleta de estatísticas e distribuição de dados para um banco relacional desenhar planos de execução.

Mais pessoas generalistas, criando e mantendo pipelines de dados, significa mais problemas como esse com pessoas menos preparadas em lidar com esse tipo de problema.

## Conclusão

Trabalhar com dados é complicado, como repeti durante todo o texto, as ferramentas de Big Data são muito poderosas mas demandam um nível de conhecimento alto. As ferramentas estão evoluindo, mas ainda demandam muito dos usuários.

Esse cenário é problemático para escalar o uso de dados, mas centralizar simplesmente não funciona.

É melhor ter dificuldades e desafios técnico, do que simplesmente não ter dados porque sua área não é importante o suficiente para alocar engenheiros de dados. Isso sem falar da manutenção e evolução, que são sempre um problema quando se lida com projetos e não produtos de dados

Acredito que essa nova perspectiva de operação federada é muito benéfica, mas não será um processo sem dores.