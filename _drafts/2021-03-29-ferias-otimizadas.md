---
layout: post
title: "Organizando férias com otimização"
comments: true
description: "Brincando de otimizar férias em tempos de pandemia"
keywords: 
---

Organizar férias pode ser divertido, mesmo que seja um processo entremeado de tarefas chatas. Em tempos de pandemia, talvez sobre apenas a parte chata, caso não haja planos de viagens e afins. Vira apenas uma questão de otimizar a duração das folgas.

Nesse contexto, "organizar" férias vira um típico problema a ser resolvido com [programação por restrição](https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_por_restri%C3%A7%C3%B5es): é possível definir uma função objetivo, as regras são bem definidas e há várias soluções possíveis.

Para uma única pessoa, resolver esse problema com otimização é claramente *overengineering*. Talvez faça sentido modelar alguns casos, como organizar férias de um time com centenas de pessoas, mas para uma única pessoa é mais simples perder alguns minutos e resolver manualmente.

Não é algo realmente útil, mas achei interessante como exercício. Nesse post, vou tentar fazer um modelo de otimização para resolver esse problema.

# Especificando o problema

Levantar requisitos do problema é crucial, seja ao desenvolver um software ou modelo, mas em casos de otimização os requisitos podem inviabilizar a solução "facilmente". A depender dos requisitos, pode ser simplesmente impossível modelar o problema ou executá-lo em tempo hábil.

Ao menos para mim, basicamente um leigo no assunto, há muitas coisas que não saberia descrever como um modelo. Preciso pensar bastante para conseguir implementar algumas restrições e cálculos, quer seriam triviais em programação imperativa. 

Há exemplos disso nesse simples exercício, que vou comentar posteriormente na parte da implementação. Destacada a importância, vamos partir para a especificação em si.

## Definindo restrições

As regras de férias são bem claras e definidas pela CLT, o que facilita a parte das restrições:

* Férias podem ser divididas em 3 períodos, um deles precisa ter ao menos 14 dias e todos devem ter mais do que 5 dias.

* O período total é de 30 dias corridos, que devem ser utilizados no período de 12 meses.

* As férias não podem começar próximo de feriados e folgas remuneradas, precisam ser ao menos 3 dias antes.

* O funcionário pode vender até 10 dias de férias no máximo para o empregador.

A organização das férias é prerrogativa do empregador, então na prática é provável que haja mais regras, mas por lei são essas até onde eu pude levantar. 

Além das regras do empregador, o próprio empregado costuma ter restrições de cunho pessoal: combinar as férias com o restante da família, estar alinhada com outros eventos (*e.g* viagens, casamentos e mudanças).

Considerando um cenário mais realista, com restrições adicionais, o problema de otimização se torna ainda menos útil: o espaço de busca é se torna tão pequeno, que basta uma olhada no calendário para resolvê-lo.

## Definindo a função objetivo

A função objetivo não é bem definida como as restrições, cada pessoa tem suas prioridades, apesar de haver alguns padrões. Como é apenas um exercício, vou usar o que anedoticamente considero mais comum à maioria das pessoas:

1. Otimizar a quantidade de folga total, evitando férias que coincidam com feriados e finais de semana.

2. Emendar as férias com algum feriado estendido, aumentado o tempo contíguo de descanso.

3. Ponderar a distância entre elas, para não ficarem muito próximas uma das outras.

Diferente das restrições, numerei os objetivos, porque a ordem importa. A prioridade dos objetivos muda a definição da função objetivo.

Pensando em uma pessoa somente, talvez essa seja a parte menos prática: as prioridades são subjetivas e individuais, não é fácil generalizar. Além disso, cada prioridade deveria ser mapeada e codificada.

Por outro lado, para o caso de uma empresa que organiza as férias de seus funcionários, diria que é até recomendável ter as regras definidas matematicamente.

# Resolvendo o problema

Os meus parcos conhecimentos de otimização são todos de um curso [introdutório de otimização](https://www.coursera.org/learn/basic-modeling). Nesse curso, é utilizada a linguagem MiniZinc para implementar as soluções.

O [MiniZinc](https://www.minizinc.org) é uma linguagem de alto nível, desenhada para descrever problemas de otimização e/ou restrições. A ideia é escrever somente o modelo nela, a integração com o solver é transparente: um mesmo programa pode rodar em vários solvers compatíveis.

Não sei dizer se é a melhor ferramenta, mas parece ser uma boa para iniciantes. A linguagem feita para isso já valida muita coisa na compilação, além de ter uma a sintaxe desenhada para descrever esse tipo de problema.

## Parâmetros da otimização

A otimização trabalha com dois tipos de dados: parâmetros passados para o problema e variáveis da otimização. Os parâmetros são definidos pelo usuário, enquanto as variáveis são calculadas durante a otimização e identificadas como `var`.

Abaixo, a especificação dos parâmetros utilizados no problema:

```minizinc
enum DAYTYPE = {Work, Saturday, Sunday, Holiday};
array[int] of DAYTYPE: calendar;

int : leave_days;
int : intervals;
```
O enum `DAYTYPE` é para identificar o tipo de dia: útil, sábado, domingo ou feriado. O calendário é uma sequência de dias, que pode ser algum tipo de `DAYTPYE`. O parâmetro `leave_days` é a quantidade de dias de férias, `intervals` é a quantidade de períodos de férias. 

Os parâmetros são definidos diretamente no código, ou a partir de um arquivo texto. Um arquivo de exemplo, com 60 dias de calendário, 30 dias de férias e 3 intervalos:

```minizinc
calendar = [Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Holiday,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work];
leave_days = 30;
intervals = 3;
```
O calendário está definido dessa forma peculiar, porque otimização trabalha basicamente com vetores numéricos. O enum `DAYTYPE` é apenas um *syntax sugar*, oferecido pelo MiniZinc, para dar apelidos aos números inteiros.

## Representação das férias

A estrutura de dados, que representa o problema, é muito importante. Ela impacta muito na forma de escrever a solução e na velocidade em que o solver chega na solução.

Inicialmente, estava considerando as férias como um conjunto de dias. Após dificuldades em codificar algumas restrições, optei por usar uma matriz, com o dia de início e fim de cada período de férias:

```minizinc
enum LEAVE = {Start, End};

array[1..intervals, LEAVE] of var 1..length(calendar): leave;
```

Criei outras variáveis, para validar restrições e calcular a função de otimização, mas todas elas são derivadas de algum cálculo sobre a variável `leave`.

## Implementando as restrições

As restrições definidas estão codificadas abaixo, com comentários explicando o objetivo de cada uma: 

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

```

A restrição de ordenação é apenas para facilitar o código, saber que estão em sequência simplifica a implementação das demais.

Além das restrições da especificação, optei por adicionar uma nova referente ao fim das férias: ela não deve acabar em uma quinta-feira, por exemplo, que tem um dia de trabalho e logo depois outra folga:

```minizinc
%O total de dias é igual ao disponível
constraint sum(i in 1..intervals)(leave[i, End] - leave[i, Start] + 1) == leave_days;
```

Não acho que seja um desejo unânime, mas conheço pessoas que não gostam de fazer algo assim. Em testes, percebi que adicionar essa restrição reduz muito o tempo de execução, então optei por deixar. 

Esse caso ilustra, como as definições do problema, impactam bastante na solução ao aumentar/reduzir o espaço de busca e — por consequência — no tempo de execução.

## Definindo um objetivo

Definir a função objetivo, foi a parte mais complicada da modelagem. A falta de prática dificultou, tive que repensar alguns cálculos e pensar muito para resolver questões aparentemente simples.

Vou ir passando por etapas, já que a função objetivo é uma combinação de múltiplas variáveis.

### Calculando o descanso total

O principal alvo da otimização é maximizar os dias de folga, evitando que as férias fiquem sobrepostas às outras folgas. Para realizar esse cálculo, somei todos os dias de folgas ou que estão dentro de algum período de férias:

```minizinc
var int : total_leisure = sum([calendar[day] != Work \/
                               exists(i in 1..intervals)(day >= leave[i, Start] 
                                                      /\ day <= leave[i, End]) 
                              | day in 1..length(calendar)]);
```
Usei o conceito de "list comprehension", em que se aplica filtros e transformações em uma lista. Funciona da mesma forma que em outras linguagens, como Python e Haskell.

### Calculando o descanso extra

Uma prática que parece comum ao organizar férias, é emendar com feriados prolongados. Para adicionar isso na otimização, criei uma variável adicional que consiste em contar os dias "bônus" de descanso antes e depois das férias:

```minizinc
function var int: extra_leisure_after(int: offset, int: leave_seq) = forall(i in 1..offset)
                                                                        (if leave[leave_seq, End] + i < length(calendar) 
                                                                         then calendar[leave[leave_seq, End] + i] != Work 
                                                                         else false endif);


function var int: extra_leisure_before(int: offset, int: leave_seq) = forall(i in 1..offset)
                                                                             (if leave[leave_seq, Start] - i >= 1
                                                                              then calendar[leave[leave_seq, Start] - i] != Work 
                                                                              else false endif);

var int : extra_leisure = sum(i in 1..intervals)(sum(j in 1..5)(extra_leisure_after(j, i))) +
                          sum(i in 1..intervals)(sum(j in 1..5)(extra_leisure_before(j, i)));
```

Esse foi um caso mais complicado de implementar do que eu esperava. Criei duas funções auxiliares, uma para verificar os dias antes do começo da férias e após o término. Para dado N, elas calculam se esses N dias antes (ou depois) são todos de folga também.

Para esse caso, considerei os próximos 5 dias, pensando no maior feriado brasileiro que é o Carnaval e totaliza 5 dias de folgas ao considerar a quarta-feira de cinzas.

### Calculando a distribuição das férias

Assumindo que temos N opções ótima, com o mesmo descanso total e extra, entendo que uma boa ideia é espaçar elas o máximo possível.

A ideia inicial era simplesmente maximizar a distância entre os intervalos, mas acabava sendo válido deixar duas parcelas bem próximas e outra muito distante. Depois de testar várias abordagens, optei por usar uma derivação de variância:

```minizinc
array[1..intervals-1] of var int : distances = [leave[i, Start] - leave[i-1, End] | i in 2..intervals];
var float : mean_distance = sum(distances) / intervals;
var float : variance = sum(i in 1..intervals-1)(abs(distances[i] - mean_distance)) / (intervals - 1);
```

O solver estava tendo problemas ao lidar com exponenciação e raiz, então optei por calcular a diferença absoluta em relação a média. Não sei se isso tem valida estatística, mas no olho resolveu o problema de tentar manter os intervalos equidistantes.

### Função objetivo

A função final é uma composição dos cálculos anteriores:

```minizinc
solve maximize (total_leisure + extra_leisure) * 1000
               + mean_distance - variance;
```

O ideal seria fazer uma otimização hierárquica, maximizando `total_leisure` e `extra_leisure`. Em caso de empate, maximizar `mean_distance` e reduzir `variance`.

Não é algo possível, então optei por essa estratégia de "garantir" que `total_leisure` e `extra_leisure` serão os critérios prioritários ao multiplicar a soma de ambos por 1000. Dentro de um ano, `mean_distance - variance`, não deve ter mais que 2 casas decimais.

