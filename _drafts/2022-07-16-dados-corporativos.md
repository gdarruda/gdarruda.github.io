---
layout: post
title: "Data Mesh e os problemas (ainda) em aberto"
comments: true
mathjax: false
---

A expectativa em relação ao uso de dados nas empresas é enorme, quem trabalha na área e nunca ouviu que [dados são o novo petróleo](https://www.economist.com/leaders/2017/05/06/the-worlds-most-valuable-resource-is-no-longer-oil-but-data)? Talvez seja, mas nas grandes empresas, usar os dados espalhados pelos departamentos é como extrair petróleo de águas profundas.

Existem inúmeras e variadas dificuldades para empresas extraírem valor dos dados, mas – dentro das minhas experiências atuando como analista, engenheiro e cientista de dados – a parte da engenharia costumar ser o maior problema.

Há diversos relatórios ([1](https://www.forbes.com/sites/randybean/2020/10/20/the-failure-of-big-data/?=sh=2d9b4bdfa218), [2](https://www.mckinsey.com/business-functions/quantumblack/our-insights/ten-red-flags-signaling-your-analytics-program-will-fail), [3](https://venturebeat.com/2019/07/19/why-do-87-of-data-science-projects-never-make-it-into-production/)), que indicam grandes dificuldades e poucos resultados no uso de dados. Uma sensação que, após uma década de entusiasmo e expectativa, o resultado geral ficou bem aquém do esperado.

Nesse contexto, surgiu o Data Mesh: uma proposta "sociotécnica" para compartilhar, acessar e gerenciar dados em grandes empresas.

É um assunto muito recente, a única literatura disponível sobre o assunto é o livro [Data Mesh: Delivering Data-Driven Value at Scale](https://www.oreilly.com/library/view/data-mesh/9781492092384/) da Zhamak Dehghani. Esse livro aborda o problema a partir de uma perspectiva teórica, usando uma empresa fictícia que trabalha com streaming de música. Ou seja, é mais uma proposta que um conjunto de práticas consolidado.

Mesmo sendo algo novo e que ainda precisa se provar, gostei muito da proposta. Se todas as grandes empresas têm dificuldades em extrair valor dos dados, os problemas devem ser mais fundamentais, a nível de organização e não apenas uma questão técnica.

O foco do Data Mesh é a gestão federada dos dados, aumentando agilidade e autonomia de cada domínio em estruturas organizacionais complexas. É uma ideia alinhada com tendências do mercado de tecnologia (*e.g* microsserviços, metodologias ágeis, design orientado a eventos, cloud e DevOps), aplicada à questão dos dados.

O Data Mesh aborda gargalos organizacionais, mas enxergo que algumas barreiras técnicas devem se manter e dificultar o processo. Pretendo discutir esses pontos, onde enxergo dificuldades técnicas para viabilizar uma estratégia de dados federada.

Esse post não é uma resenha do livro ou uma introdução ao Data Mesh, 
a autora do livro tem um [post resumo](https://martinfowler.com/articles/data-mesh-principles.html) no blog do Martin Fowler para quem estiver procurando algo nesse sentido.

## Complexidade das ferramentas como obstáculo a federação

O alvo principal da gestão federada é lidar com os gargalos gerados por um departamento de dados centralizado, responsável pelos pipelines de dados de toda a empresa. Antes de distribuir as responsabilidades, é necessário distribuir capacidade técnica.

A autora propõe que a plataforma do Data Mesh considere a facilidade de uso das ferramentas na sua construção, para que "qualquer" engenheiro de software consiga implementar e manter pipelines de dados.

> Incentivizing and enabling generalist developers with experiences, languages, and APIs that are easy to learn is a starting point to lower the cognitive load of generalist developers. To scale out data-driven develop‐ ment to the larger population of practitioners, data mesh platforms must stay relevant to generalist technologists.

Concordo com a proposta, mas discordo do diagnóstico do problema.

Argumenta-se que, os engenheiros de dados são necessários hoje, porque usamos muitas tecnologias proprietárias e que demandam conhecimentos específicos da plataforma.

> Another barrier to the adoption of data platforms today is the level of proprietary specialization that each technology vendor assumes—the jargon and the vendor- specific knowledge. This has led to the creation of scarce specialized roles such as data engineers.

Por conta desse cenário, uma melhor abordagem seria privilegiar tecnologias com filosofia Unix: ferramentas mais simples e especializadas, mas que sejam interoperáveis e possam ser combinadas para gerar soluções completas.

> If a data mesh platform wants to realistically scale out sharing data, within and beyond the bounds of an organization, it must wholeheartedly embrace the Unix philosophy and yet adapt it to the unique needs of data management and data sharing. It must design the platform as a set of interoperable services that can be implemented by different vendors with different implementations yet play nicely with the rest of the platform services.

Infelizmente, acho que o problema é basicamente o oposto: os engenheiros de dados, se fazem necessário hoje, pois há muitas peças que precisam ser combinadas. É até uma [piada da área](https://pixelastic.github.io/pokemonorbigdata/), a quantidade de ferramentas que podem ser utilizadas para trabalhar com dados. 

Soluções proprietárias e verticalizadas trazem uma série problemas, mas normalmente são mais simples de utilizar, ao oferecer um pacote fechado e demandar menos tomadas de decisão técnica pelo usuário.

Por exemplo, em uma solução "clássica" de banco de dados relacional/MPP, todos as consultas SQL passam pelo mesmo motor de processamento: a aplicação conectada via JDBC, as procedures do banco de dados, a ferramenta de BI ou alguém diretamente conectado.

Em um ambiente Big Data, é comum você ter um *metastore* para catalogar o dados, mas diversas formas diferentes de consultar e manipular o dado: é possível usar uma engine SQL (como Hive) para jobs longos; Presto ou Impala para algo mais tempestivo; Spark para integrar código procedural ou mesmo ler diretamente o storage.

Não é óbvio, para alguém menos especializado, como é completamente diferente usar [PySpark](https://spark.apache.org/docs/latest/api/python/index.html) conectado a um cluster ou uma biblioteca como o [Pandas](https://pandas.pydata.org) para acessar o arquivo no storage. São estratégias completamente diferentes, mas que para um leigo é díficil entender as implicações de cada uma delas.

No cenário acima, uma tomada de decisão arquitetural errada pode incorrer em custos enormes ou não atender o objetivo final. Não é incomum, uma decisão combinar ambos os problemas.

Um agravante é que esse tipo de decisão normalmente precisa ser feita na parte do consumo, que teoricamente são os usuários mais distantes da parte técnica.

Por essas dificuldades, vejo uma tendência de usuários menos técnicos preferindo soluções mais amigáveis, como alternativas *low-code*/*no-code*.

Apesar de mais simples de usar, essas ferramentas normalmente são proprietárias e pouco interoperáveis, recaindo no problema que queríamos evitar. A própria autora destaca que essas ferramentas podem trazer outras séries de desafios novos.

> For example, many low-code or no-code platforms promise to work with data, but compromise on testing, versioning, modularity, and other techniques. Over time they become unmaintainable

O maior custo para extrair valor dos dados é o conhecimento necessário para utilizá-las e mantê-las, não somente o preço de mercado delas. Peças interoperáveis e especializadas são ótimas na mão de bons engenheiros, mas são pouco amigáveis para quem não domina o funcionamento interno dessas soluções.

Minha preocupação aqui é muito mais com etapa de consumo dos dados, não no processo de disponibilização que normalmente é a etapa mais associada à engenharia de dados.

Imagino que, para os engenheiros de software generalistas, criar pipelines para disponibilizar e catalogar os dados não seja um grande problema com um plataforma bem desenhada. São pessoas com conhecimento técnico e que devem se preocupar apenas com uma pequena parte da manipulação dos dados.

A questão é como facilitar para usuário final: a pessoa mais importante, mas com menos conhecimento técnico para trabalhar com essas ferramentas.

## Garantia de qualidade

Uma questão chave, para gestão federada funcionar, é definir bons critérios de qualidade que sejam escaláveis. Com vários times trabalhando de forma independente, é fácil o Data Lake virar um "Data Swamp": bases sem catalogação adequada, com estrutura física mal desenhada e inconsistências.

### Catalogação de dados

Há uma brincadeira sobre existir apenas duas coisas difíceis em computação: invalidação de cache e nomear coisas. Padronizar nomes dentro de toda empresa, me parece simplesmente impossível.

Algumas empresas definem padrões de nomenclatura para banco de dados a nível corporativo. No livro, esse padrão de nomenclatura é descritos como *polyseme*.

> Polysemes are shared concepts across different domains. They point to the same entity, with domain-specific attributes. Polysemes represent shared core concepts in a business such as “artist,” “listener,” and “song.”

Utilizar esteiras automatizadas, para validar os *polysemes* na criação e manutenção do *metastore* e serviços, é algo bem plausível de implementar. Entretanto, a minha questão é anterior: como são criados e organizados esses conceitos?

Na minha opinião, falta uma boa teoria para embasar a motivação e utilidade de criar esse tipo de vocabulário. Questões de ontologias e taxonomia são muito amplas e complexas, fora do domínio da computação e com séculos de estudo. 
 
Mas o que vejo nas empresas são soluções intuitivas e simplistas para o problema. Para piorar, raramente a empresa toda segue a padronização, porque normalmente surgem dificuldades em implementar em todos os domínios.

Talvez seja azar meu, mas nunca encontrei uma implementação satisfatória dessa ideia funcionando em uma grande empresa.

Como usuário, normalmente o que procuro é simplesmente um "boa" descrição de cada atributo e não padronização de nomenclatura. É quase indiferente, se temos o conceito de CPF descrito como `num_cpf` em um domínio e `cod_cpf` no outro, conquanto que eu entenda como eles funcionam em cada domínio.

Mas o que é uma "boa" descrição para um atributo? Ela é boa quando atende os usuários, mas infelizmente não dá para validar isso de forma automatizada. Normalmente, isso é validado no momento da modelagem de dados, mas aqui entramos em um problema de escalabilidade.

### Modelagem de dados

Erros de modelagem geram débitos técnicos enormes, com juros altíssimos,  pois rapidamente o problema se tornar inviável de resolver. Uma tabela importante mal modelada gera uma série de problemas:

* impacta desenvolvedores da aplicação e usuários do dados; 
* a correção costuma envolver movimentações complexas de dados e refazer boa partes dos sistemas;
* pode gerar custos extras de armazenamento e processamento.

Nesse contexto, estão os DBAs e ADs que aprovam modelos de dados, funcionando como um "guardrail" para mitigar esses problemas. Mas é um processo não automatizável, algumas vezes belicoso entre as áreas e que normalmente vira um gargalo para uma operação federada.

Diferente da questão de nomenclatura, a teoria para modelagem de dados é muito desenvolvida e estável. Mas, assim como a questão das ferramentas de Big Data, o desafio é escalar esse conhecimento para a empresa sem depender de poucas pessoas especializadas.

Boas práticas, como revisão de código e testes de integração podem mitigar esse problema, mas eles ainda podem ser muito altos, para a empresa abdicar de uma validação centralizada.

### Testes automatizados

Os testes sempre tem limitações em qualquer tipo software, raramente é uma garantia de que tudo funcionará em produção. Para pipelines de dados, é especialmente caro e complexo, garantir que os testes reflitam o cenário de produção com fidelidade.

Testes automatizados são muito valorizados como boa prática de desenvolvimento, times se orgulham de falar que possuem X% de cobertura em seus projetos. Mas como aplicar testes automatizados em pipelines de dados?

Os testes unitários, que ficam na base da pirâmide e deveriam ser a maioria, costumam ser poucos efetivos em pipelines de dados. Normalmente, há pouca lógica de negócio nos pipelines e muitas vezes estão implementados na forma de consultas SQL.

Os testes de integração são mais úteis em pipelines de dados, mas são difíceis de implementar. Boa parte das ferramentas de Big Data são modulares, então é necessário "subir" várias peças para reproduzir um pipeline localmente. 

Outro agravante é a característica distribuída das ferramentas de dados, um ambiente criado na workstation acaba sendo muito diferente do cenário real. Questões de redes e memória partilhada são muito importantes de testar, mas impossível de reproduzir localmente com fidelidade.

Ambientes em nuvem ajudam muito nessa dificuldade, entretanto um problema que persiste é simular a natureza original do dado: além das questões de infra –  volumetria e distribuição dos dados - são aspectos chaves para testar um pipeline de dados.

Perdi a conta, das vezes que um processo quebrou em produção, porque os dados mockados não refletiam os gargalos do ambiente produtivo. Ou mesmo o inverso, problemas que só existem em desenvolvimento por que as chaves não batem.

Um ambiente de homologação, com condições de reproduzir o cenário de dados da  produção, é caro e complexo de construir. Depende de uma catalogação muito boa para, por exemplo, mascarar os campos de forma que mantenha consistência nos relacionamentos. Sem contar os custos de operação, para criar um ambiente com a mesma escala da produção, apenas para testes.

Um exemplo dessas dificuldades foi o [caso da apuração de votos das últimas eleições](https://www.tse.jus.br/comunicacao/noticias/2020/Novembro/nota-de-esclarecimento-sobre-nuvem-para-contabilizar-votos). A infra era mais que suficiente para a apuração de votos, mas houve um erro na configuração do ambiente.

Não fizeram a coleta de estatísticas do banco de dados no momento correto, que é algo imprescindível para otimizadores baseados em custo funcionarem corretamente. Poucos desenvolvedores sabem a importância da coleta de estatísticas sobre a distribuição dos dados, para se atentar a esse cenário de um ambiente recém-criado.

Erros como esses são difíceis de lidar, provavelmente fizeram um teste de volumetria em um ambiente de homologação que não era representativo o suficiente.

Mais profissionais generalistas, criando e mantendo pipelines de dados, significa mais problemas como esse com pessoas menos preparadas em lidar.

## Conclusão

Trabalhar com dados é complicado, como repeti durante todo o texto. As ferramentas de Big Data são muito poderosas, mas (ainda) demandam um nível de conhecimento alto.

Nesse contexto, é difícil escalar o operação de dados em uma grande empresa, mas centralizar o processos simplesmente não é solução. Os domínios precisam de autonomia para evoluir, o Data Mesh tenta garantir essa autonomia sem perder a coesão.

No final, é melhor ter dificuldades e desafios técnicos, do que simplesmente não ter dados, porque sua área não tem orçamento para priorizar um projeto de engenharia de dados. Isso sem falar da manutenção e evolução dos pipelines, que são sempre um problema quando se lida com projetos e não produtos de dados.

Ainda há muitos desafios técnicos para o uso de dados, que atrapalham hoje e devem continuar nos atormentando, mesmo em operações federadas. Data Mesh é importante, mas não é panaceia para todos os problemas.
