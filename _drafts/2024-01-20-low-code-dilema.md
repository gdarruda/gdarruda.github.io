---
layout: post
title: "Low-code e complexidade acidental"
comments: true
mathjax: true
description: "Soluções (low|no)-code não resolvem complexidade inerente"
keywords: "Low Code"
---

A proposta das soluções \(low\|no\)-code é irresistível para os executivos. Quem antes dependia de tecnologia – usando ferramentas low-code – consegue resolver problemas com mais autonomia, menos custo e maior agilidade.

Por outro lado, programadores costumam tratar com desdém a ideia de low-code. Muitas vezes por simples elitismo e protecionismo, mas também por experiências terríves: soluções desnecessariamente complexas; dificuldades de operação e manutenção; "lock-in" em plataformas proprietárias.

A diferença entre os cenários, enxergo como uma questão de compreender as diferenças de [complexidade acidental e essencial](https://en.wikipedia.org/wiki/No_Silver_Bullet). Low-code funciona muita bem para problemas com baixa complexidade essencial e criticidade, mas pode virar um caos para problemas inerentemente complexos.

# Complexidade essencial e acidental

A complexidade acidental são questões "técnicas", aspectos do problema que os engenheiros devem saber lidar e são inerentes ao desenvolvimento da solução. Por exemplo, como escolher o banco de dados ideal, que se adequa ao problema e atenda aos requisitos funcionais e não-funcionais.

A complexidade essencial se refere ao problema de negócio. Se precisamos implementar um sistema de tributação, não podemos mexer nos requisitos para simplificar o código.

Um boa solução de software lida com a complexidade essencial, adicionando o mínimo possível de complexidade acidental. 

Não é uma tarefa fácil, mesmo com bons engenheiros e ferramentas, é comum acabar com muita complexidade acidental. Quando a solução fica a cargo de alguém não especializado, usando ferramentas limitadas, a chance de criar mais problemas ao invés de solução é enorme.

O quanto uma solução low-code faz sentido, depende muito da complexidade essencial. Entretanto, é comum a complexidade essencial passar batido pelos arquitetos de solução.

# O cenário do caos

Por natureza da especialidade, engenheiros são treinados para focar em complexidade acidental: é interessante discutir como montar uma linha do tempo em baixa latências para milhões de usuários, mas nem tanto em entender todas as regras de cobrança do ICMS.

Suponha que existe um processo para estimar valor dos impostos, consumindo arquivos tabulares e gerando outro, para relatório e acompanhamento. Esse tipo de cenário, normalmente é visto como o ideal para low-code: os contadores conseguem implementar e validar de forma autônonoma, as demandas de latência são mínimas e não é operacional.

Depois de algum tempo, temos o seguinte cenário:

* A ferramenta low-code depende de várias outras, que também não são adequadas mas resolvem outras limitações, como planilhas Excel e/ou scripts Python locais.

* Poucas pessoas conseguem entender a solução, porque é uma ferramenta proprietária e a lógica é representada como um diagrama incompreensível.

* O custo de migrar a solução para um sistema é muito alto (e ninguém quer fazer), é preciso pagar e sustentar indefinidamente a solução.

* O relatório também está sendo usado de forma operacional, porque era a melhor fonte dessa informação.

# A natureza do problema

O problema desse cenário hipotético, foi desconsiderar a complexidade essencial do problema. Um fluxo com arquitetura de solução simular, mas uma lógica de negócios simples, realmente seria um bom caso para utilizar low-code.

Em um cenário de lógica mais complexa, o ideal seria um programador competente, para desenvolver um código sustentável para o problema. Apesar de ser uma arquitetura simples, as regras podem demandar milhares de linhas de código e abstrações sofisticadas.

Muito dos esforços na engenharia de software, estão relacionados a esse tipo de problema:

* A consolidação da programação orientada a objetos e mantras como [SOLID](https://en.wikipedia.org/wiki/SOLID) e [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), foi pelo anseio de melhor organização e abstração;

* o uso de ferramentas de versionamento é fundamental em cenários de alta complexidade essencial, para orquestrar e controlar mudanças;

* um dos atrativos da arquitetura de micro-serviços, é conseguir distribuir a complexidade essencial por múltiplos sistemas.

Mesmo que seja possível aplicar essas ideias em ferramentas low-code, muita dessas ideias dependem de recursos de linguagens modernas e ambientes em nuvem.

# Usando "bad-code" no lugar

Nem sempre é viável ter especialistas, para fazer desenhar e contruir a solução. Uma alternativa que não resolve, mas pode mitigar alguns problemas, é considerar o uso de soluções em código desenvolvida por quem não é especialista.

Posso estar errado – realmente não sou o melhor para opiniar, dado que programo há muito tempo – mas entendo que o problema do usuário não é sobre aprender a programar.

Na área de dados, é muito comum ter pessoas que sabem programar bem, mas que não estão familiarizadas com processos de tecnologia e boas práticas. Inclusive, a ideia de usar soluções low-code, muitas é para substituir códigos ruins de VBA em planilhas ou em linguagens como PL/SQL e Transact-SQL. 

Fazer um notebook linguição usando Python não é necessariamente melhor, normalmente vira uma reprodução dos mesmos erros, mas em outro lugar. A questão é facilitar uma possível evolução, para algo mais estruturado e fácil de integrar.

Por exemplo, pode-se criar um ambiente restrito para implantar essas soluções, usar uma imagem com Python instalado e as bibliotecas básicas. Mesmo que seja necessário uma re-escrita completa do código no futuro, esse processo costuma ser bem menos doloroso usando a mesma plataforma que migrando de outra.

# Acertando o problema

Não acho low-code uma ideia terrível, mas não muito boa também: resolve uma classe de problemas, mas as promessas são irreais. A ideia  de abolir código não é nova, há 20 anos tinha-se a ideia de [gerar código a partir de UML](https://en.wikipedia.org/wiki/Rational_Software_Modeler) e ferramentas [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) para fazer construir sites. Por que elas não se tornaram o padrão?

Grandes empresas – as consumidoras dessas ferramentas – são cheias de complexidade essencial, que são difíceis de implementar em código e pior ainda em ferramentas low-code. É importante identificar, se o problema ser resolvido tem esse tipo complexidade, pois há o risco de solução virar um problemas.

Somos cobrados e ensinados para lidar com complexidade adicional, [pecando mais por excesso que falta](https://blog.bradfieldcs.com/you-are-not-google-84912cf44afb?gi=7cf9084614af) de precaução. Talvez, seja hora de prestarmos mais atenção para complexidade essencial, que nem sempre são problemas interessantes de computação.