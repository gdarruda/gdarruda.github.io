---
layout: post
title: "Organizando férias com otimização"
comments: true
description: "Brincando de otimizar férias em tempos de pandemia"
keywords: 
---

Organizar férias pode ser divertida, mesmo que seja entremeado de algumas tarefas chatas. Em tempos de pandemia, talvez sobre apenas a parte chata, caso não haja planos de viagens e afins. Nesse caso, vire apenas uma questão de otimizar a duração/formato das folgas.

Pensando dessa forma, organizar férias vira um típico problema a ser resolvido com [programação por restrição](https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_por_restri%C3%A7%C3%B5es): é possível definir uma função objetivo, as regras são bem definidas e há várias soluções possíveis.

Para uma única pessoa, resolver esse problema com otimização é claramente  *overengineering*. Talvez faça sentido modelar, pensando em organizar férias de um time com dezenas ou centenas de pessoas, mas para uma única pessoa é mais simples perder alguns minutos e resolver manualmente.

Deixado claro que é somente um exercício, vamos partir para a definição e solução do problema.

## Definindo restrições

As regras de férias são bem claras e definidas pela CLT, o que facilita a definição das restrições:

* Férias podem ser divididas em 3 períodos, um deles precisa ter ao menos 14 dias e todos devem ter mais do que 5 dias.

* O período total é de 30 dias corridos, que devem ser utilizados no período de 12 meses.

* As férias não podem começar próximo de feriados e folgas remuneradas, precisam ser ao menos 3 dias antes.

* O funcionário pode vender até 10 dias de férias no máximo para o empregador.

A organização das férias é prerrogativa do empregador, então na prática é possivel que haja mais regras, mas por lei temos apenas essas regras até onde levantei. Em geral, as pessoas também tem várias restrições, como viagens/evento e período de férias de amigos e familiares. 

Considerando um cenário mais realista, com essas restrições, o problema de otimização se torna mais irrelevante: o espaço de busca é pequeno, basta uma olhada no calendário para organizar.

## Definindo a função objetivo

A função objetivo não é bem definida como as regras, cada pessoa tem suas prioridades, apesar de haver alguns padrões e premissas universais. Como é apenas um exercício, vou usar o que considero padrão:

1. Otimizar a quantidade de folga total, evitando férias que coincidam com feriados e finais de semana.

2. Emendar as férias com algum feriado extendido, aumentado o tempo contíguo de descanso.

3. Ponderar a distância entre elas, para não ficarem muito próximas uma das outras.

Diferente das restrições, numerei os objetivos, porque nesse caso a ordem importa. Se eu alterar a ordem ou peso, preciso alterar a função objetivo utilizada.

Pensando em uma pessoa somente, talvez essa seja a parte mais complexa: as prioridades são subjetivas e individuais, não é fácil generalizar como as restrições. Por outro lado, para o caso de uma empres que organiza as férias de seus funcionários, é até interessante que essa função seja matematicamente definida.


<!-- No começo da pandemia, acabei me envolvendo em um projeto (dos vários) que estava tentando modelar a progressão da pandemia no Brasil com [modelos de compartimento](https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology) e a situação dos leitos com [simulação de evento discretos](https://pt.wikipedia.org/wiki/Simula%C3%A7%C3%A3o_de_eventos_discretos). Um ano depois — com a crise em seu pior estado e os hospitais colapsados — estou pensando em um otimizador de férias. -->
