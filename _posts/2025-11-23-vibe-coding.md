---
layout: post
title: "Programar não é a parte difícil"
comments: true
mathjax: false
description: "Mais uma opinião sobre vibe coding"
keywords: "IA, Vibe Coding"
---

Como alguém que trabalha com dados e gosta de refletir sobre programação ([1](/2025/05/24/aprendendo-com-cientistas-dados.html), [2](/2024/ 01/20/low-code-dilema.html), [3](/2024/06/26/codigo-limpo-positivismo-fotografia.html) e [4](/2020/09/23/linguagens-programacao.html)), um post sobre "vibe coding" era inevitável. Ao final, chego a conclusão não muito bombástica: é uma ferramenta muito útil e difícil de abandonar após se acostumar, mas não resolve o problema fundamental de fazer software.

# A eterna promessa do low code, a nova do vibe code

A promessa do vibe code é muito similar ao low code, tornar desenvolvimento de software acessível para quem não sabe programar. Mas, ao invés de inventar uma nova linguagem visual baseadas em workflows, a ideia é que os agentes consigam traduzir especificações em linguagem natural para código.

Eu já discuti sobre os motivos do [low code](/2024/01/20/low-code-dilema.html) sempre ficar aquém das expectativas criada pelos vendedores – alguns desses problemas são mitigados com vibe coding, outros persistem – mas a limitação fundamental é a mesma: a grande dificuldade não é programar, mas lidar com a complexidade inerente de grandes sistemas.

Os problemas que um ERP precisa resolver são bem conhecidos (e.g. gestão de estoque, cálculos de imposto, contabilidade) e não exigem conhecimentos em tópicos avançados de computação. Só que cada empresa tem um ERP diferente, seguindo a  ["lei de Conway"](https://en.wikipedia.org/wiki/Conway%27s_law):

> [O]rganizations which design systems (in the broad sense used here) are constrained to produce designs which are copies of the communication structures of these organizations.

Suponha uma nova regra para cálculo imposto – o desafio não é compreender e codificar a regra – é saber em que parte do sistema esse cálculo é feito, identificar os impactos da mudança e desenhar como será alterado. O padrão é que profissionais mais experientes e arquitetos façam o desenho da solução, profissionais menos experientes fazem a codificação.

No "mundo real", especificar o problema é bem mais complexo do que implementar. Os agentes são muito efetivos na implementação de algo específico, mas ainda são bem limitados para tratar problemas vagos. Existem agentes mais ambiciosos como [Devin](https://devin.ai), que se propõe a trabalhar a partir de um chamado, mas os relatos são de [experiências frustrantes](https://www.answer.ai/posts/2025-01-08-devin.html):

> But that’s the problem - it rarely worked. Out of 20 tasks we attempted, we saw 14 failures, 3 inconclusive results, and just 3 successes. More concerning was our inability to predict which tasks would succeed. Even tasks similar to our early wins would fail in complex, time-consuming ways. The autonomous nature that seemed promising became a liability - Devin would spend days pursuing impossible solutions rather than recognizing fundamental blockers.

O vibe code compartilha da mesma limitação fundamental do low code, mas seria injusto dizer que ele não é um avanço em outros aspectos. O principal avanço é trabalhar com código em linguagens e frameworks populares, ao invés de DAGs especificados em uma tecnologia proprietária.

As grandes evoluções em linguagens, arquiteturas e metodologias – orientação a objetos, microsserviços, data mesh, devops – surgiram para (tentar) domar a entropia dos sistemas. As ferramentas de low code são ótimas para demonstrações simples, mas oferecem muito pouco para controlar a complexidade.

Mesmo com pessoas capacitadas e experientes, acabamos com sistemas insustentáveis que precisam ser substituídos. Pessoas leigas gerando milhares de linhas de código – como podemos ver com sistemas feito sem boas práticas, planilhas e ferramentas low code – é apenas acelerar esse processo.

Por melhor que seja o código, qualquer linha a mais significa débito técnico: mais possibilidades de falhas de segurança, erros de lógica e tempo para entender o sistema. Gerar muito código com vibe code é fácil, mas pode ser uma armadilha disfarçada de produtividade.

# Reduzindo expectativas

A frustração é proporcional às expectativas criada, até os mais entusiastas concordam que "IA" ficou aquém: o Chat GPT foi lançado em Novembro de 2022, três anos depois e não temos um mundo tão diferente assim. Deixando as expectativas de lado, é algo que tenho usado regularmente para programação e certamente sentiria falta se perdesse acesso.

Nesse cenário de hype infinito, talvez a opinião de alguém que tem preguiça disso tudo e até 
um pouco de "ranço", seja interessante: uso apenas o chat como um Stack Overflow melhorado. Não fico explorando diferentes modelos, nunca usei IDEs otimizadas para agentes e nem perco muito tempo com "prompt engineering".

A minha primeira experiência com IA foi usando o auto completar, algo que eu logo desisti. Algumas vezes o auto completar parecia estar lendo minha mente, mas na maioria dos casos era uma distração perigosa:

* código verboso demais, com tratamentos de erro desnecessários e padrões diferentes do restante do código;

* geração de código para problemas que eu sei resolver, perdia mais tempo lendo a sugestão que implementando sem auxílio;

* erros bobos, como um nome de variável ou definição de constante, que podem ser identificados muito tarde no processo de desenvolvimento.

Por isso, eu prefiro ir proativamente ao chat quando faz sentido. Eu testei o modo agente do VS Code, mas não gostei muito de precisar revisar as mudanças, prefiro ler a resposta e editar manualmente os arquivos. Era muito trabalhoso, quando o agente fazia mudanças parcialmente corretas, para aceitar apenas o que eu desejava.

Pedir via chat é o jeito mais básico de aplicar IA, nada que não conseguiria resolver olhando a documentação e Stack Overflow. A grande vantagem é o contexto: não preciso ir para um navegador tirar dúvidas e o agente responde melhor com acesso ao código. Não perco o [flow](https://en.wikipedia.org/wiki/Flow_(psychology)), porque não preciso sair da IDE para pesquisar e as soluções vêm mais prontas.

A estrutura principal do código eu prefiro fazer manualmente, o que eu peço são trechos de código para resolver problemas pontuais (e.g. como sortear uma posição do array, conectar ao banco de dados e fazer uma requisição HTTP). Quando preciso trabalhar em outras linguagens ou com novas bibliotecas, uso mais regularmente e isso deixa o aprendizado mais fluído.

Para códigos descartáveis, eu não vejo problemas em delegar completamente para IA. Códigos para gerar gráficos ou scripts que serão utilizados uma vez, não faço questão de cuidar da estrutura. Além de códigos menos críticos, problemas repetitivos em projetos como scaffold de modelos e criação de mocks para testes, sou menos criterioso com o código gerado.

Se eu não pudesse mais utilizar AI para programar, eu perderia produtividade? Imagino que de forma marginal, mas certamente teria uma percepção de menos produtividade. As tarefas que delego são as coisas chatas e repetitivas, que talvez não tomem muito tempo, mas é justamente o que não quero fazer.

É muito comum programadores discutirem avidamente, qual linguagem ou IDE é mais produtiva, mas existe zero rigor ou mesmo dados para essas afirmações. E tudo bem, é importante que você se sinta bem com as suas ferramentas, não precisa de um resultado científico que comprove isso. Esse anseio moderno de metrificar tudo, gera algo pior que não ter métricas: usar números pouco representativos como verdade absoluta.

Como eu disse, tenho um pouco de preguiça de explorar mais e faço um uso básico. Já li relatos de pessoas que viraram quase orquestradoras de agentes, mas não me convenci de que se aplica bem ao meu dia-a-dia. Se existir um jeito maravilhoso de usar IA para programação, tenho certeza que chegará em mim de alguma forma.

# Vamos chegar lá?

Pessoalmente, não tenho expectativas que esse cenário vá mudar no futuro próximo, ainda estaremos presos nessa situação: IA ajudará cada vez mais a programar, mas ainda não consegue descobrir o que deve ser programado. Posso estar errado, mas novamente: eu vou saber, se existir um jeito incrível de utilizar IA para programação.

Minha preocupação atual, é mais com os iniciantes. Já era um problema pessoas que copiavam código do Stack Overflow sem entender, caindo em um [máximo local]("https://pt.wikipedia.org/wiki/Pontos_extremos_de_uma_função"): consegue fazer algumas tarefas básicas, mas não evolui por estar copiando sem entender. O vibe code te leva muito mais longe sem entender as coisas, mas é ruim pensando em evolução profissional trabalhar dessa forma.

A minha maior dúvida é como o mercado ficaria, se uma [possível bolha de IA](https://www.npr.org/2025/11/23/nx-s1-5615410/ai-bubble-nvidia-openai-revenue-bust-data-centers) estourasse. Eu não sei quanto custa para manter os maiores modelos rodando, quantos usuários seriam necessários e qual o valor a ser cobrado. Quais modelos seriam financeiramente viáveis? Utilizaríamos modelos locais menores?

Talvez o cenário mude muito – mas ao final de 2025 – ainda utilizo IA como mais um recurso legal da IDE.