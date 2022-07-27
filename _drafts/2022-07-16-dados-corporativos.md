---
layout: post
title: "Data Mesh e os problemas (ainda) em aberto"
comments: true
mathjax: false
---

A expectativa em relação ao uso de dados nas empresas é enorme, quem na área de ados nunca ouvi que [dados são o novo petróleo](https://www.economist.com/leaders/2017/05/06/the-worlds-most-valuable-resource-is-no-longer-oil-but-data)? Talvez seja, mas dentro das grandes empresas, usar os dados espalhados pela empresa é como extrair petróleo de águas profundas.

Existem inúmeras e variadas dificuldades para grandes empresas extraírem valor dos dados que possuem mas – dentro das minhas experiências atuando como analista, engenheiro e cientista de dados – engenharia de dados tem sido o maior problema.

Há diversos relatórios que indicam grandes dificuldades e poucos resultados nas estratégias de dados ([1](https://www.forbes.com/sites/randybean/2020/10/20/the-failure-of-big-data/?sh=2d9b4bdfa218), [2](https://www.mckinsey.com/business-functions/quantumblack/our-insights/ten-red-flags-signaling-your-analytics-program-will-fail), [3](https://venturebeat.com/2019/07/19/why-do-87-of-data-science-projects-never-make-it-into-production/))
, uma sensação de que após uma década de entusiasmo e expectativa, o resultado geral ficou bem aquém do esperado.

É válido considerar que existe algo fundamentalmente quebrado na forma que tentamos usar dados. Nesse contexto, surgiu o *Data Mesh*: uma proposta "sociotécnica" para compartilhar, acessar e gerenciar dados em grandes empresas.

É um assunto muito recente, a única literatura disponível sobre o assunto é o livro [Data Mesh da Zhamak Dehghani](https://www.oreilly.com/library/view/data-mesh/9781492092384/). O livro aborda o problema a partir de uma perspectiva teórica, usando uma empresa fictícia que trabalha com streaming de música.

Em resumo, é algo novo e que ainda precisa se provar, mas gostei muito da proposta geral. Afinal, não é como se o modelo atual esteja funcionando como esperado.

O foco do Data Mesh é a gestão federada de dados, aumentando agilidade e autonomia em estruturas organizacionais complexas. Está em linha com outras tendências do mercado de tecnologia, tanto organizacionais como técnicas (*e.g*  microsserviços, metodologias ágeis, design orientado a eventos, tecnologias de cloud e DevOps).

Acredito que os problemas organizacionais são realmente o maior vilão atual, muito mais do que as questões de tecnologia. Por outro, entendo que algumas questões técnicas continuarão trazendo dores de cabeça para a implementação desse modelo.

Minha ideia é discutir esses pontos, onde enxergo dificuldades técnicas para viabilizar uma estratégia de Data Mesh. Esse post não é uma resenha do livro ou para explicar Data Mesh, 
a autora do livro tem um [post resumo](https://martinfowler.com/articles/data-mesh-principles.html) no blog do Martin Fowler para quem estiver procurando uma introdução ao tema.

## Complexidade das ferramentas como obstáculo a federação

O problema principal que a gestão federada propõe resolver são os gargalos que existem, quando existe uma única grande área responsável por criar e manter os pipelines de dados. Para resolver essa questão, além de distribuir as responsabilidades em relação aos dados, é necessário distribuir capacidade técnica.

A autora propõe que a plataforma do Data Mesh pense em facilidade de uso, para que "qualquer" engenheiro de software consiga implementar e manter pipelines de dados.

> Incentivizing and enabling generalist developers with experiences, languages, and APIs that are easy to learn is a starting point to lower the cognitive load of generalist developers. To scale out data-driven develop‐ ment to the larger population of practitioners, data mesh platforms must stay relevant to generalist technologists.

<!-- p 53  -->
Concordo com a proposta, mas discordo do diagnóstico da situação atual. O argumento é que engenheiros de dados são necessários porque usamos muitas tecnologias especializadas.

> Another barrier to the adoption of data platforms today is the level of proprietary specialization that each technology vendor assumes—the jargon and the vendor- specific knowledge. This has led to the creation of scarce specialized roles such as data engineers.

<!-- p 52  -->

Que para o Data Mesh, devemos investir em mais tecnologias interoperáveis.

> If a data mesh platform wants to realistically scale out sharing data, within and beyond the bounds of an organization, it must wholeheartedly embrace the Unix philosophy and yet adapt it to the unique needs of data management and data sharing. It must design the platform as a set of interoperable services that can be implemented by different vendors with different implementations yet play nicely with the rest of the platform services.

Ao meu ver, as plataformas de Big Data já seguem a filosofia Unix de componentes especializados e interoperáveis a partir de protocolos e especificações. Ainda existiam muitas soluções verticalizadas, mas não é o caso do "ecossistema Hadoop" e seus derivados, que hoje são a plataforma padrão de mercado.

É justamente essa interoperabilidade e especialização que torna os engenheiros de dados. Soluções proprietárias e verticalizadas trazem uma série de outras questões, mas normalmente são mais simples de escalar em uma empresa por oferecer um pacote fechado.

Por exemplo, em uma solução "clássica" de banco de dados relacional ou MPP, todos as consultas passam pelo mesmo motor de processamento: a aplicação conectada via JDBC, as procedures do banco de dados, a ferramenta de BI ou alguém diretamente conectado.

Em um ambiente Big Data, é comum você ter várias opções completamente diferentes de acessar o mesmo dado: usar uma engine baseada em MapReduce, soluções como Presto e Impala, Spark ou mesmo ler diretamente o storage consultando apenas o metastore.

A flexibilidade é ótima para atender diversos casos de uso, mas não é simples explicar as diferenças de cada estratégia para um engenheiro de software. E normalmente é muito pior explicar para os usuários finais do dado – cientistas e analistas de dados – que não são obrigados a entender detalhes de implementação.

Não é óbvio para alguém menos técnico, como é completamente diferente usar PySpark conectado ao cluster ou uma biblioteca como o Pandas para acessar um arquivo no storage: mas Gabriel, não é tudo Python?

Muitas vezes, esses usuários acabam preferindo soluções mais abstratas, que normalmente são menos interoperáveis com outras soluções como ferramentas "low-code".

> For example, many low-code or no-code platforms promise to work with data, but compromise on testing, version‐ ing, modularity, and other techniques. Over time they become unmaintainable

<!-- p 53  -->

Apoio a estratégia de priorizar ferramentas interoperáveis, deixar a implementação flexível e ao gosto do cliente, mas mantendo compatibilidade na empresa toda.

Na parte de construção dos pipelines iniciais, acho que é uma tendência seguir e deve ser abraçada pelos engenheiros de software, mas enxergo um grande desafio em tornar essas "ferramentas Unix-like" amigáveis para o usuário.

## Dificuldades em escalar boas práticas

Uma questão chave para gestão federada, é definir bons critérios de qualidade. Com vários times trabalhando de forma independente, é fácil o Data Lake virar um "Data Swamp": bases sem catalogação adequada, com estrutura física mal desenhada e dados inconsistentes.

### Catalogação de dados

Há uma piada sobre existir apenas duas coisas difíceis em computação: invalidação de cache e nomear coisas. A nível corporativo, a tarefa não poderia ser mais complicado.

Algumas empresas tentam definir padrões de nomenclatura para banco de dados, há diversos nomes para esses padrões, no livro são descritos como *polysemes*.

> Polysemes are shared concepts across different domains. They point to the same entity, with domain-specific attributes. Polysemes represent shared core concepts in a business such as “artist,” “listener,” and “song.”

Utilizar esteiras automatizadas para validar esses conceitos é bem plausível, mas a minha questão é anterior: como são organizados esses conceitos?

Se o cadastro for centralizado e controlado pelos ADs, podemos criar um gargalo para operação federada. Se liberar o cadastro, é provável que teremos termos repetidos ou pouco expressivos, que pouco servem ao usuário do dado.

Talvez eu simplesmente desconheça, mas ao meu ver falta teoria para embasar a motivação e utilidade de criar esses vocabulário. Questões ontologias e taxonomia são muito amplas e complexas, fora do domínio da computação e com séculos de estudo, mas o que vejo são soluções intuitivas para o problema.

Não vou dizer que acho inútil – seria perfeito um data lake todo padronizado – mas tem camadas de complexidade que hoje são pouco discutidas. Nesse sentido, acabamos com estratégias de padronização bem aquém das expectativas.

### Modelagem de tabelas

Erros de modelagem geram débitos técnicos enormes com juros altíssimos. Uma tabela importante mal modelada pode ser terrível: impacta desenvolvedores da aplicação e usuários do dados; a correção costuma envolver movimentações complexas de dados e refazer boa partes dos sistemas; pode gerar custos extras de armazenamento e processamento.

Nesse contexto, os DBAs e ADs funcionam como um "guardrail" para evitar problemas maiores. Infelizmente, muitos desenvolvedores não se interessam por essa parte o processo de desenvolvimento, então pode ser arriscado montar um processo federado.

Mas diferente da questão de nomenclatura, a teoria para modelagem de dados é muito desenvolvida e estável. Só não é simples de automatizar, pois um modelo depende muito do negócio e da aplicação, não há muitas métricas de "bom modelo de dados" independente do contexto.

## O risco dos eventos



<!-- O problema de modelagem é mais uma questão operacional, questões de modelagem lógica e física possuem soluções maduras, mas que nem todos os desenvolvedores dominam como eu acho que deveriam. -->



<!-- Desde que eu entrei no mercado, uma questão presente no desenvolvimento de sistemas é a relação difícil entre desenvolvedores e a área responsável pelos bancos de dados em grandes empresas, normalmente composta por ADs e DBAs que precisam aprovar mudanças no banco de dados.



Como alguém que trabalhou mais com dados que como desenvolvedor, entendo que é necessário cuidar de seus banco de dados. 
 -->
