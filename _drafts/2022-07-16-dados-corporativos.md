---
layout: post
title: "Data Mesh e os problemas (ainda) em aberto"
comments: true
mathjax: false
---

A expectativa em relação ao uso de dados nas empresas é enorme, quem trabalha na área nunca ouviu que [dados são o novo petróleo](https://www.economist.com/leaders/2017/05/06/the-worlds-most-valuable-resource-is-no-longer-oil-but-data)? Talvez seja, mas no contexto das grandes empresas, usar os dados espalhados pelos departamentos é como extrair petróleo de águas profundas.

Existem inúmeras e variadas dificuldades para grandes empresas extraírem valor dos dados, mas – dentro das minhas experiências atuando como analista, engenheiro e cientista de dados – a parte da engenharia tem sido o maior problema.

Há diversos relatórios que indicam grandes dificuldades e poucos resultados no uso de dados ([1](https://www.forbes.com/sites/randybean/2020/10/20/the-failure-of-big-data/?sh=2d9b4bdfa218), [2](https://www.mckinsey.com/business-functions/quantumblack/our-insights/ten-red-flags-signaling-your-analytics-program-will-fail), [3](https://venturebeat.com/2019/07/19/why-do-87-of-data-science-projects-never-make-it-into-production/))
. Uma sensação que, após uma década de entusiasmo e expectativa, o resultado geral ficou bem aquém do esperado.

Nesse contexto, surgiu o Data Mesh: uma proposta "sociotécnica" para compartilhar, acessar e gerenciar dados em grandes empresas.

É um assunto muito recente, a única literatura disponível sobre o assunto é o livro [Data Mesh: Delivering Data-Driven Value at Scale](https://www.oreilly.com/library/view/data-mesh/9781492092384/) da Zhamak Dehghani. O livro aborda o problema a partir de uma perspectiva teórica, usando uma empresa fictícia que trabalha com streaming de música. Ou seja, é mais uma proposta que um conjunto de práticas consolidado.

É algo novo e que ainda precisa se provar, mas gostei muito da ideia geral. Se a maioria das empresas não consegue utilizar dados, precisamos pensar menos na parte e mais em como estamos desenhando a estratégia.

O foco do Data Mesh é a gestão federada dos dados, aumentando agilidade e autonomia de cada domínio em estruturas organizacionais complexas. É uma ideia alinhada tendências do mercado de tecnologia (*e.g* microsserviços, metodologias ágeis, design orientado a eventos, cloud e DevOps).

O Data Mesh aborda os principais gargalos organizacionais, mas enxergo que ainda temos barreiras técnicas que devem dificultar o processo. Minha ideia é discutir esses pontos, onde ainda enxergo dificuldades técnicas para viabilizar uma estratégia de dados federada.

Esse post não é uma resenha do livro ou para explicar Data Mesh, 
a autora do livro tem um [post resumo](https://martinfowler.com/articles/data-mesh-principles.html) no blog do Martin Fowler para quem estiver procurando uma introdução ao tema.

## Complexidade das ferramentas como obstáculo a federação

O alvo principoal da gestão federada é lidar com os gargalos gerado por um departamento de dados centralizado, responsável pelos pipelines de dados. Para distribuir as responsabilidades, de construção e manutenção dos pipelines de dados, também é necessário distribuir capacidade técnica para a empresa toda.

A autora propõe que a plataforma do Data Mesh pense em facilidade de uso, para que "qualquer" engenheiro de software consiga implementar e manter pipelines de dados.

> Incentivizing and enabling generalist developers with experiences, languages, and APIs that are easy to learn is a starting point to lower the cognitive load of generalist developers. To scale out data-driven develop‐ ment to the larger population of practitioners, data mesh platforms must stay relevant to generalist technologists.

Concordo com a proposta, mas discordo do diagnóstico do problema.

Argumenta-se que, os engenheiros de dados são necessários, porque usamos muitas tecnologias proprietárias e verticalizadas que demandam conhecimentos específicos da plataforma.

> Another barrier to the adoption of data platforms today is the level of proprietary specialization that each technology vendor assumes—the jargon and the vendor- specific knowledge. This has led to the creation of scarce specialized roles such as data engineers.

<!-- p 52  -->

Por causa desse problema, uma melhor abordagem seria privilegiar tecnologias com filosofia Unix: ferramentas mais simples e especializadas, mas que sejam interoperáveis e possam ser combinadas para gerar soluções maiores.

> If a data mesh platform wants to realistically scale out sharing data, within and beyond the bounds of an organization, it must wholeheartedly embrace the Unix philosophy and yet adapt it to the unique needs of data management and data sharing. It must design the platform as a set of interoperable services that can be implemented by different vendors with different implementations yet play nicely with the rest of the platform services.

Infelizmente, acho que o problema é basicamente o oposto: os engenheiros de dados se fazem necessário pois é complexo a tomada de decisão quando há tantos componentes para integrar. É até uma [piada da área](https://pixelastic.github.io/pokemonorbigdata/), a quantidade de ferramentas que podem ser utilizadas para trabalhar com dados. 

<!-- As plataformas de Big Data já seguem a filosofia Unix de componentes especializados e interoperáveis, é até uma [piada](https://pixelastic.github.io/pokemonorbigdata/) a diversidade de ferramentas disponíveis. -->

Soluções proprietárias e verticalizadas trazem uma série de outros problemas, mas normalmente são mais simples por oferecer um pacote fechado e demandar menos tomadas de decisão.

Por exemplo, em uma solução "clássica" de banco de dados relacional ou MPP, todos as consultas SQL passam pelo mesmo motor de processamento: a aplicação conectada via JDBC, as procedures do banco de dados, a ferramenta de BI ou alguém diretamente conectado.

Em um ambiente Big Data, é comum você ter um *metastore* para catalogar o dados, mas diversas formas diferentes de consultar e manipular o dado: é possível usar uma engine SQL como Hive para jobs longos; Presto ou Impala para algo mais tempestivo; Spark para integrar código procedural ou mesmo ler diretamente o storage.

Não é óbvio, para alguém menos especializado, como é completamente diferente usar PySpark conectado a um cluster ou uma biblioteca como o Pandas para acessar o arquivo no storage. Em casos similares, já ouvi perguntas como "mas Gabriel, não estou usando Python para ler a base?"

Um agravante, é que esse tipo de decisão normalmente precisa ser feita na parte do consumo, que teoricamente são os usuários mais distantes da parte técnica.

No cenário acima, uma tomada de decisão errada sobre a ferramenta pode incorrer em custos enormes ou não atender o objetivo final. Não é incomum uma decisão combinar ambos os problemas.

Por essas dificuldas, vejo uma tendência de usuários menos técnicos preferindo soluções mais amigáveis para usuários menos técnicos, como soluções *low-code* e *no-code* ou mesmo planilhas e afins.

Apesar de mais simples de usar, essas ferramentas normalmente são proprietários e pouco interoperáveis, recaindo no problema que queríamos evitar. Além disso, a própria autora destaca que essas ferramentas podem trazer outras séries de desafios novos.

> For example, many low-code or no-code platforms promise to work with data, but compromise on testing, versioning, modularity, and other techniques. Over time they become unmaintainable

<!-- p 53  -->

O maior custo para extrair valor dos dados é o conhecimento necessário para utilizá-las, não o preço de mercado delas. Peças interoperáveis e especializadas são ótimas na mão de bons engenheiros, mas são pouco amigáveis para quem não domina o funcionamento interno dessas soluções.

Minha preocupação aqui é muito mais com o consumo dos dados disponibilizados do que com o processo de disponibilização em si.

Imagino que para os engenheiros de software, criar pipelines para disponibilizar e catalogar os dados não seja um grande problema, mesmo sem muita especialização no assunto. A questão é como facilitar para usuário final: a pessoa mais importante, mas com menos conhecimento técnico.

## Garantia de qualidade

Uma questão chave, para gestão federada funcionar, é definir bons critérios de qualidade que sejam escaláveis. Com vários times trabalhando de forma independente, é fácil o Data Lake virar um Data Swamp: bases sem catalogação adequada, com estrutura física mal desenhada e inconsistências.

### Catalogação de dados

Há uma piada sobre existir apenas duas coisas difíceis em computação: invalidação de cache e nomear coisas. Padronizar nomenclatura a nível corporativo, exponencialmente mais complicado.

Algumas empresas tentam definir padrões de nomenclatura para banco de dados, há diversas denominações para esses padrões. No livro, esse padrão de nomenclatura são descritos como *polysemes*.

> Polysemes are shared concepts across different domains. They point to the same entity, with domain-specific attributes. Polysemes represent shared core concepts in a business such as “artist,” “listener,” and “song.”

Utilizar esteiras automatizadas, para validar os *polysemes* na criação e manutenção de tabelas e serviços, é algo bem plausível de implementar. Entretanto, mas a minha questão é anterior: como são organizados esses conceitos?

 Na minha opinião, falta teoria para embasar a motivação e utilidade de criar esses vocabulário. Questões de ontologias e taxonomia são muito amplas e complexas, fora do domínio da computação e com séculos de estudo. 
 
 Talvez seja ignorância da minha parte, mas o que vejo nas empresas são soluções intuitivas e simplistas para o problema. Para piorar, raramente a empresa toda usa esse dicionário, porque normalmente surgem dificuldades em implementar em todos os domínios.

Como usuário, normalmente o que procuro é simplesmente um "boa" descrição de cada atributo e não padronização de nomenclatura. É quase indiferente, se temos o conceito de CPF descrito como `num_cpf` em um domínio e `cod_cpf` no outro, conquanto que eu entenda como eles funcionam em cada domínio.

Mas o que é uma "boa" descrição para um atributo? Ela é boa quando atende o usuário, mas infelizmente não dá para validar isso de forma automatizada.

Normalmente, isso é validado no momento da modelagem de dados, mas aqui entramos em um problema de escalabilidade.

### Modelagem de tabelas

Erros de modelagem geram débitos técnicos enormes, com juros altíssimos,  pois rapidamente o problema se tornar inviável de resolver. Uma tabela importante mal modelada gera uma série de problemas:

* impacta desenvolvedores da aplicação e usuários do dados; 
* a correção costuma envolver movimentações complexas de dados e refazer boa partes dos sistemas;
* pode gerar custos extras de armazenamento e processamento.

Nesse contexto, estão os DBAs e ADs que aprovam modelos de dados, funcionando como um "guardrail" para mitigar esses problemas. Mas é um processo não automatizado, que não escala e vira um gargalo para uma operação federada.

Diferente da questão de nomenclatura, a teoria para modelagem de dados é muito desenvolvida e estável. Assim como a questão das ferramentas de Big Data, o maior desafio é capacitar as pessoas para não cometerem erros de modelagem.

Boas práticas, como revisão de código e testes de integração podem mitigar esse problema, mas o conceito de testes tem seus desafios próprios quando aplicados ao domínio de dados.

### Testes automatizados

Os testes automatizados são muito valorizados como boa prática, empresas se orgulham de falar que possuem X% de cobertura de testes, entretanto o cenário no contexto de pipelines de dados é bem complicado.

Os testes unitários que ficam na base da pirâmide e deveriam ser a maioria, normalmente são complexos de implementar em pipeline de dados. Os códigos normalmente tem pouca lógica de negócio, além de muito dessa lógica estar em consultas SQL.

Os testes de integração são mais relevantes, mas normalmente são especialmente complexos. Como já foi discutido, boa parte das ferramentas de Big Data são modulares, então normalmente é necessário várias peças para reproduzir um pipeline. Outro agravante é a característica distribuída dessas ferramentas, um ambiente local na workstation acaba sendo muito diferente do cenário real.

Ambientes em nuvem facilitam lidar com essas dificuldade, entretanto um grande problema é simular os dados em si. A volumetria e a distribuição dos dados são aspectos chaves de um pipeline de dados, perdi a conta das vezes que um processo quebrou em produção porque os dados mockados não refletiam os gargalos dom ambiente produtivo.

Um ambiente de homogalação, com condições de reproduzir o cenário de dados da  produção, é caro e complexo de construir. Depende de uma catalogação muito boa para, por exemplo, mascarar os campos de forma padronizada de forma a manter consistência nos relacionamentos entre domínios. Além do custo, de manter um ambiente com a mesma escala que a produção apenas para testes.

Um exemplo público foi o [caso do TSE](https://www.tse.jus.br/comunicacao/noticias/2020/Novembro/nota-de-esclarecimento-sobre-nuvem-para-contabilizar-votos), certamente a infra era mais que suficiente para a apuração de votos, mas houve um erro na configuração do ambiente. Não fizeram a coleta de estatísticas do banco de dados, que é algo imprescindível para otimizadores baseados em custo funcionarem corretamente.

Erros como esses são complexos de evitar, provavelmente fizeram um teste de volumetria com um ambiente diferente. Poucos desenvolvedores sabem a importância da coleta de estatísticas e distribuição de dados, para se atentar a esse cenário de um banco de dados "novo".

Mais profissionais generalistas, criando e mantendo pipelines de dados, significa mais problemas como esse com pessoas menos preparadas em lidar com eles.

## Conclusão

Trabalhar com dados é complicado, como repeti durante todo o texto, as ferramentas de Big Data são muito poderosas mas demandam um nível de conhecimento alto. As ferramentas estão evoluindo nesse aspecto, mas ainda demandam muito conhecimento dos usuários.

Nesse contexto, é complicado escalar o uso dos dados, mas centralizar o processos simplesmente não funciona em grandes empresas. Os domínios precisam de autonomia para evoluir, o Data Mesh tenta garantir autonomia sem perder a coesão.

É melhor ter dificuldades e desafios técnicos, do que simplesmente não ter dados porque sua área não é importante o suficiente para pedir um projeto de engenharia de dados. Isso sem falar da manutenção e evolução, que são sempre um problema quando se lida com projetos e não produtos de dados.
