---
layout: post
title: "Data Mesh e os problemas (ainda) em aberto"
comments: true
mathjax: false
---

A expectativa em relação ao uso de dados nas empresas é enorme, quem na área de ados nunca ouvi que [dados são o novo petróleo](https://www.economist.com/leaders/2017/05/06/the-worlds-most-valuable-resource-is-no-longer-oil-but-data)? Talvez seja, mas dentro das grandes empresas, é como extrair petróleo de águas profundas.

Há inúmeras e variadas dificuldades para empresas extraírem valor dos dados que possuem mas – dentro das minhas experiências atuando como analista, engenheiro e cientista de dados – engenharia de dados tem sido o maior problema.

Após anos de fracassos, é válido considerar que precisamos repensar o modelo de trabalho. Nesse contexto, surgiu o Data Mesh: uma proposta "sociotécnica" para compartilhar, acessar e gerenciar dados em grandes empresas.

É um assunto muito recente, a única literatura disponível sobre o assunto é o livro [Data Mesh da Zhamak Dehghani](https://www.oreilly.com/library/view/data-mesh/9781492092384/). O livro aborda o problema a partir de uma perspectiva teórica, usando uma empresa fictícia que trabalha com streaming de música: estamos falando de uma proposta/hipótese, não de práticas de mercado testadas e consolidadas.

Em resumo, é algo novo e que precisa se provar, mas gostei muito da proposta geral.

O foco do Data Mesh é a gestão federada de dados, aumentando agilidade e autonomia em estruturas organizacionais complexas. Está em linha com outras tendências do mercado de tecnologia, tanto organizacionais como técnicas (*e.g*  microsserviços, metodologias ágeis, design orientado a eventos, tecnologias de cloud e DevOps).

Mas Data Mesh não é panaceia, acredito que além dos problemas organizacionais, algumas questões técnicas ainda continuarão trazendo dores de cabeça em estruturas federadas.

A autora do livro tem um [post resumo](https://martinfowler.com/articles/data-mesh-principles.html) no blog do Martin Fowler, para quem desejar se inteirar mais do assunto antes de ler esse post.

## Complexidade das ferramentas como obstáculo a federação

O problema principal que a gestão federada propõe resolver são os gargalos que existem, quando existe uma única grande área responsável por criar e manter os pipelines de dados. Para resolver essa questão, além de distribuir as responsabilidades em relação aos dados, é necessário distribuir capacidade técnica.

A autora propõe que a plataforma do Data Mesh pense em facilidade de uso, para que "qualquer" engenheiro de software consiga implementar e manter pipelines de dados.

> "Incentivizing and enabling generalist developers with experiences, languages, and APIs that are easy to learn is a starting point to lower the cognitive load of generalist developers. To scale out data-driven develop‐ ment to the larger population of practitioners, data mesh platforms must stay relevant to generalist technologists."

<!-- p 53  -->
Concordo com a solução, mas discordo  do diagnóstico a necessidade de especialistas em dados no cenário atual, em particular de engenheiro de dados.

> Another barrier to the adoption of data platforms today is the level of proprietary specialization that each technology vendor assumes—the jargon and the vendor- specific knowledge. This has led to the creation of scarce specialized roles such as data engineers.

<!-- p 52  -->

Ao meu ver, as plataformas de Big Data já seguiam a filosofia Unix de componentes especializados e interoperáveis a partir de protocolos e especificações. Ainda existiam muitas soluções verticalizadas, mas o ecossistema Hadoop sempre teve essa premissa.

Soluções verticalizadas possuem seus jargões e especificidades, mas abstraem o funcionamento interno. Eu vejo muito mais dificuldade das pessoas entenderem como as coisas funcionam em um ambiente Big Data. 

Em uma solução "clássica" de bando de dados, todos as consultas passam pelo mesmo motor de processamento. Seja a aplicação conectada via JDBC, as procedures do banco de dados, a ferramenta de BI ou alguém diretamente conectado.

Em um ambiente Big Data, é comum você ter várias opções completamente diferentes de acessar o mesmo dado: usar uma engine baseada em MapReduce, soluções como Presto e Impala, Spark ou mesmo ler diretamente o storage consultando apenas o metastore.

Não é simples explicar essas diferenças para engenheiros de software, mas quem mais sofre com essa complexidade, são os usuários como os cientistas e analistas de dados.

Não é óbvio para alguém menos técnico, como é completamente diferente usar PySpark conectado ao cluster ou uma biblioteca como o Pandas para acessar um arquivo no storage: mas Gabriel, não estou usando Python?

Dentro dessa complexidade, é comum esses usuários priorizarem soluções mais simples, que a autora reconhece como problemáticas.

> For example, many low-code or no-code platforms promise to work with data, but compromise on testing, version‐ ing, modularity, and other techniques. Over time they become unmaintainable

<!-- p 53  -->

Ao meu ver, a complexidade das ferramentas interoperáveis que empurra muitos usuários para soluções proprietárias e low-code, que tem seu valor mas trazem outra série de problemas como manutenablidade e "lock-in".

## Não é fácil escalar boas práticas de dados

Desde que eu entrei no mercado, uma questão presente no desenvolvimento de sistemas é a relação difícil entre desenvolvedores e a área responsável pelos bancos de dados em grandes empresas, normalmente composta por ADs e DBAs que precisam aprovar mudanças no banco de dados.

Erros de modelagem geram débitos técnicos enormes, que rapidamente se tornam inviáveis se forem implementados no sistema. Uma tabela central mal modelada envolve mudar grandes parte do sistema, implantação arriscada e longa para movimentação de dados e as "dores" impactam boa parte dos desenvolvedores.

Como alguém que trabalhou mais com dados que como desenvolvedor, entendo que é necessário cuidar de seus banco de dados. 

<!-- Polysemes are shared concepts across different domains. They point to the same entity, with domain-specific attributes. Polysemes represent shared core concepts in a business such as “artist,” “listener,” and “song.” -->
