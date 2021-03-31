---
layout: post
title: "Organizando férias com otimização"
comments: true
description: "Brincando de otimizar férias em tempos de pandemia"
keywords: 
---

Organizar férias pode ser divertido, mesmo que seja um processo entremeado de tarefas chatas. Em tempos de pandemia, talvez sobre apenas a parte chata, caso não haja planos de viagens e afins. Vira apenas uma questão de otimizar a duração/formato das folgas.

Nesse contexto, "organizar" férias vira um típico problema a ser resolvido com [programação por restrição](https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_por_restri%C3%A7%C3%B5es): é possível definir uma função objetivo, as regras são bem definidas e há várias soluções possíveis.

Para uma única pessoa, resolver esse problema com otimização é claramente  *overengineering*. Talvez faça sentido modelar alguns casos, como organizar férias de um time com centenas de pessoas, mas para uma única pessoa é mais simples perder alguns minutos e resolver manualmente.

Não é algo realmente útil, mas achei interessante como exercício. Nesse post, vou tentar fazer um modelo de otimização para resolver esse problema.

# Especificando o problema

Levantar requisitos do problema é crucial, seja ao desenvolver um software ou modelo, mas em casos de otimização talvez seja grande parte do problema. A depender dos requisitos, pode ser simplesmente impossível modelar o problema.

Ao menos para mim, um leigo no assunto, preciso pensar bastante para conseguir implementar algumas restrições e cálculos para um problema de otimização. Soluções com soluções triviais, em programação imperativa "tradicional".

Depois de algum esforço, consegui resolver o problema.

## Definindo restrições

As regras de férias são bem claras e definidas pela CLT, o que facilita a parte das restrições:

* Férias podem ser divididas em 3 períodos, um deles precisa ter ao menos 14 dias e todos devem ter mais do que 5 dias.

* O período total é de 30 dias corridos, que devem ser utilizados no período de 12 meses.

* As férias não podem começar próximo de feriados e folgas remuneradas, precisam ser ao menos 3 dias antes.

* O funcionário pode vender até 10 dias de férias no máximo para o empregador.

A organização das férias é prerrogativa do empregador, então na prática é provável que haja mais regras, mas por lei são essas até onde eu pude levantar. 

Além das regras do empregador, o próprio empregado costuma ter restrições de cunho pessoal: combinar as férias com o restante da família, estar alinhada com outros (*e.g* viagens, casamentos e mudanças).

Considerando um cenário mais realista, com restrições adicionais, o problema de otimização se torna ainda menos útil: o espaço de busca é se torna tão pequeno, que basta uma olhada no calendário para resolvê-lo.

## Definindo a função objetivo

A função objetivo não é bem definida como as regras, cada pessoa tem suas prioridades, apesar de haver alguns padrões e premissas comum a maioria das pessoas. Como é apenas um exercício, vou usar o que considero mais comum a maioria das pessoas:

1. Otimizar a quantidade de folga total, evitando férias que coincidam com feriados e finais de semana.

2. Emendar as férias com algum feriado extendido, aumentado o tempo contíguo de descanso.

3. Ponderar a distância entre elas, para não ficarem muito próximas uma das outras.

Diferente das restrições, numerei os objetivos, porque nesse caso a ordem importa. Se eu alterar a ordem ou peso, preciso alterar a função objetivo utilizada.

Pensando em uma pessoa somente, talvez essa seja a parte menos práticas: as prioridades são subjetivas e individuais, não é fácil generalizar como as restrições.

Por outro lado, para o caso de uma empresa que organiza as férias de seus funcionários, é até interessante que essa função seja matematicamente definida para que todos estejam alinhados.

# Resolvendo o problema

Os meus parcos conhecimentos de otimização são todos de um curso [introdutório de otimização](https://www.coursera.org/learn/basic-modeling). Nesse curso, é utilizada a linguagem MiniZinc para implementar as soluções.

O [MiniZinc](https://www.minizinc.org) é uma linguagem de alto nível, desenhada para descrever problemas de otimização e de restrições. A ideia é escrever somente o modelo nela, a integração com o solver é transparente: um mesmo programa pode rodar em vários solvers.

Não sei dizer se é a melhor ferramenta, mas parece ser uma boa para iniciantes. A linguagem focada já valida muita coisa na compilação, além de ter uma a sintaxe focada nesse tipo de problema, diferente de uma biblioteca em Python por exemplo. 

## Parâmetros da otimização

A otimização trabalha com dois tipos de dados: parâmetros passados para o problema e variáveis da otimização. Os parâmetros são definidos diretamente no código, ou a partir de um arquivo texto. 

Abaixo, os parâmetros da otimização:

```minizinc
enum WEEKDAY = {Work, Saturday, Sunday, Holiday};
array[int] of WEEKDAY: calendar;

int : leave_days;
int : intervals;
```
O enum `DAYTYPE` é para identificar o tipo de dia: dia útil, sábado, domingo ou feriado. O calendário é uma sequência de dias, que pode ser algum tipo de `DAYTPYE`. O parâmetro `leave_days` é a quantidade de dias disponíveis, `intervals` é a quantidade de períodos de férias.

Um arquivo de exemplo, com 60 dias de calendário, 30 dias de férias e 3 intervalos:

```minizinc
calendar = [Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Holiday,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work];
leave_days = 30;
intervals = 3;
```
O calendário não está definido da uma forma fácil de ler, mas para a otimização basicamente só podemos trabalhar com vetores numéricos. O enum `DAYTYPE` já é um *syntax sugar* oferecido pelo MiniZinc, já que são apenas apelidos para números inteiros.

## Representação das férias

A estrutura de dados usada para representar o problema é muito importante, impacta muito na forma de escrever a solução e na velocidade em que o solver chega na solução.

Inicialmente, estava considerando as férias como um conjunto de dias. Após dificuldades em codificar algumas restrições, optei por usar uma matriz, com o dia de início e fim de cada período de férias:

```minizinc
enum LEAVE = {Start, End};

array[1..intervals, LEAVE] of var 1..length(calendar): leave;
```

Criei outras variáveis, para validar restrições e calcular a função de otimização, mas todas elas são derivadas de algum cálculo sobre essa estrutura base.

## Implementando as restrições

As restrições codificadas estão abaixo, com comentários explicando a motivação de cada uma: 

```minizinc
%Os intervalos estão ordenados e com distância mínima
constraint forall(i in 2..intervals)(leave[i-1, End] < leave[i, Start]);

%Os intervalos tem começo e fim consistentes
constraint forall(i in 1..intervals)(leave[i, Start] < leave[i, End]);

%Um intervalo tem mais de 15 dias
constraint exists(i in 1..intervals)(leave[i, End] - leave[i, Start] + 1 >= 14);

%Todos intervalos tem mais de 5 dias
constraint forall(i in 1..intervals)(leave[i, End] - leave[i, Start] + 1 >= 5);

%O total de dias é igual ao disponível
constraint sum(i in 1..intervals)(leave[i, End] - leave[i, Start] + 1) == leave_days;

%Garante que não começa antes de um feriado/fds
constraint forall(i in 1..intervals)(calendar[leave[i, Start]] == Work 
                                     /\ calendar[leave[i, Start] + 1] == Work
                                     /\ calendar[leave[i, Start] + 2] == Work);

%Garante que não termina um dia antes de outra folga 
constraint forall(i in 1..intervals)(calendar[leave[i, End] + 1] != Work);
```

A restrição para ordenação é apenas para facilitar o código, saber que estão em sequência simplifica o código.

Coloquei uma restrição adicional ao final, para evitar que as férias terminem próximo de uma véspera de final de semana ou feriado, uma quinta-feira por exemplo. A função objetivo deve mitigar esse tipo de coisa, mas percebo que muitos acham uma situação muito ruim, então optei por definir como restrição.

## Calculando o objetivo

Calcular o objetivo, foi a parte mais complicada da modelagem. Tive que mudar alguns cálculos para evitar exponenciação e divisões, que não funcionam para determinadas operações. Além de simples falta de costume, de como lidar com determinados problemas em um problema de otimização.

### Calculando o descanso total

O principal ponto da omitização é aumentar os dias de folga. Para realizar esse cálculo, contei dias que são folgas previstas ou que estão no período de férias:

```minizinc
var int : total_leisure = sum([1 | day in 1..length(calendar) 
                               where calendar[day] != Work \/ 
                                     exists(i in 1..intervals)(day >= leave[i, Start] 
                                                               /\ day <= leave[i, End])]);
```

O conceito de "comprehension"