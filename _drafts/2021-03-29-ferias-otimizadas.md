---
layout: post
title: "Organizando férias com otimização"
comments: true
description: "Brincando de otimizar férias em tempos de pandemia"
keywords: 
---

Organizar férias pode ser divertido, mesmo que seja um processo entremeado de tarefas chatas. Em tempos de pandemia, talvez sobre apenas a parte chata, caso não haja planos de viagens e afins. Vira apenas uma questão de otimizar a duração das folgas.

Nesse contexto, "organizar" férias vira um típico problema a ser resolvido com [programação por restrição](https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_por_restri%C3%A7%C3%B5es): é possível definir uma função objetivo, as regras são bem definidas e há várias soluções possíveis.

Para uma única pessoa, resolver esse problema com otimização é claramente *overengineering*. Talvez faça sentido modelar em alguns casos, organizar férias de um time com centenas de pessoas por exemplo, mas para uma única pessoa é mais simples perder alguns minutos e resolver manualmente.

Não é algo realmente útil, mas achei interessante como exercício. Nesse post, vou tentar fazer um modelo de otimização para resolver esse questão.

# Especificando o problema

Levantar requisitos do problema é crucial, seja ao desenvolver um software ou modelo, mas em problemas de otimização os requisitos podem inviabilizar a solução "facilmente". 

A depender dos requisitos, pode ser simplesmente impossível modelar o problema ou executá-lo em tempo hábil. Ao menos para mim, basicamente um leigo no assunto, há muitas coisas que não saberia descrever como um modelo. Preciso pensar bastante para conseguir implementar algumas restrições e cálculos, quer seriam triviais em programação imperativa. 

Há exemplos disso nesse simples exercício, que vou comentar posteriormente na parte da implementação. Destacada a importância dessa etapa, vamos partir para a especificação em si.

## Definindo restrições

As regras de férias são bem claras e definidas pela CLT, o que facilita a parte das restrições:

* Férias podem ser divididas em 3 períodos, um deles precisa ter ao menos 14 dias e todos devem ter mais do que 5 dias.

* O período total é de 30 dias corridos, que devem ser utilizados no período de 12 meses.

* As férias não podem começar próximo de feriados e folgas remuneradas, precisam ser ao menos 3 dias antes.

* O funcionário pode vender até 10 dias de férias no máximo para o empregador.

A organização das férias é prerrogativa do empregador, então na prática é provável que haja mais regras.

Além das regras do empregador, o próprio empregado costuma ter restrições de cunho pessoal: combinar as férias com o restante da família ou estar alinhada com outros eventos (*e.g* viagens, casamentos e mudanças).

Considerando um cenário mais realista, com restrições adicionais, o problema de otimização se torna ainda menos útil: o espaço de busca é se torna tão pequeno, que basta uma olhada no calendário para resolvê-lo.

## Definindo a função objetivo

A função objetivo não é bem definida, como as restrições, cada pessoa tem suas prioridades. Como é apenas um exercício, vou usar o que anedoticamente considero as prioridades mais comuns à maioria das pessoas:

1. Otimizar a quantidade de folga total, evitando férias que coincidam com feriados e finais de semana.

2. Emendar as férias com algum feriado estendido, aumentado o tempo contíguo de descanso.

3. Ponderar a distância entre elas, para não ficarem muito próximas uma das outras.

Diferente das restrições, numerei os objetivos, porque a ordem importa. A prioridade dos objetivos muda a definição da função objetivo.

Pensando em uma pessoa somente, definir uma função objetivo é a parte mais complicada: as prioridades são subjetivas e individuais, não é fácil generalizar. Por outro lado, para o caso de uma empresa que organiza as férias de seus funcionários, diria que é até recomendável ter as regras definidas matematicamente.

# Resolvendo o problema

Os meus parcos conhecimentos de otimização são todos provenientes de um curso [introdutório de otimização](https://www.coursera.org/learn/basic-modeling). Nesse curso, é utilizada a linguagem MiniZinc para implementar as soluções.

O [MiniZinc](https://www.minizinc.org) é uma linguagem de alto nível, desenhada para descrever problemas de otimização e/ou restrições. A ideia é escrever somente o modelo nela, a integração com o solver é transparente: um mesmo programa pode rodar em vários solvers compatíveis.

Não sei dizer se é a melhor ferramenta, mas parece ser uma boa para iniciantes. A linguagem já valida muita coisa na compilação, além de ter uma a sintaxe desenhada para descrever esse tipo de problema.

Definido o problema e a ferramenta, agora é partir para a solução.

## Parâmetros da otimização

A otimização trabalha com dois tipos de dados: parâmetros passados para o problema e variáveis. Os parâmetros são definidos pelo usuário, enquanto as variáveis são calculadas durante a otimização e identificadas no MiniZinc com o prefixo `var`.

Abaixo, a especificação dos parâmetros utilizados no problema:

```minizinc
enum DAYTYPE = {Work, Saturday, Sunday, Holiday};
array[int] of DAYTYPE: calendar;

int : leave_days;
int : intervals;
```
O enum `DAYTYPE` é para identificar o tipo de dia: útil, sábado, domingo ou feriado. O calendário é uma sequência de dias, que pode ser algum tipo de `DAYTPYE`. O parâmetro `leave_days` é a quantidade de dias de férias, `intervals` é a quantidade de períodos de férias. 

Os parâmetros podem ser definidos diretamente no código, como no caso do enum `DAYTYPE`, ou a partir de um arquivo texto. Abaixo, um arquivo de exemplo, definindo um calendário de 60 dias, 30 dias de férias e 3 intervalos:

```minizinc
calendar = [Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Holiday,Holiday,Work,Work,Work,Saturday,Sunday,Work,Work,Work,Work,Work,Saturday,Sunday,Work];
leave_days = 30;
intervals = 3;
```
O calendário está definido como um array de inteiros, porque uma otimização trabalha basicamente com vetores numéricos. O enum `DAYTYPE` é apenas um *syntax sugar*, oferecido pelo MiniZinc, para dar apelidos aos números inteiros.

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
% Os intervalos estão ordenados e com distância mínima
constraint forall(i in 2..intervals)(leave[i-1, End] + 7 <= leave[i, Start]);

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

Observe que a primeira restrição, referente a ordenação dos períodos, também força que haja ao menos 7 dias de diferença entre eles. Não é uma regra definida pela CLT, mas isso possibilita casos como separar 10 dias de férias em dois períodos de 5 em semanas consecutivas. Suponho que a maioria das empresas não aceitaria essa malandragem.

Eu coloquei uma distância mínima de 7 dias e não 2 dias, porque isso ajuda a reduzir o espaço de busca, reduzindo o tempo de execução consequentemente. 

Além das restrições da especificação, optei por adicionar uma nova referente ao fim das férias: ela não deve acabar em uma quinta-feira, por exemplo, que tem um dia de trabalho e logo depois outra folga:

```minizinc
%O total de dias é igual ao disponível
constraint sum(i in 1..intervals)(leave[i, End] - leave[i, Start] + 1) == leave_days;
```

Não acho que seja um desejo unânime, mas conheço pessoas que não gostam de fazer algo assim. Em testes, percebi que adicionar essa restrição reduz muito o tempo de execução, então optei por deixar. 

Esses casos ilustram, como as definições do problema, impactam na solução ao aumentar/reduzir o espaço de busca e — por consequência — no tempo de execução. Adicionar essas duas restrições, de distância mínima e término de férias, chegaram a reduzir pela metade o tempo de execução.

## Definindo o objetivo

Definir a função objetivo, foi a parte mais complicada da modelagem. A falta de prática dificultou, tive que repensar alguns cálculos e pensar muito para resolver questões aparentemente simples.

Vou ir passando por cada "etapa" da função, já que ela é uma combinação de múltiplas variáveis.

### Calculando o descanso total

O principal alvo da otimização é maximizar os dias de folga, evitando que as férias fiquem sobrepostas às outras folgas. Para realizar esse cálculo, somei todos os dias de folgas ou que estejam dentro de algum período de férias:

```minizinc
var int : total_leisure = sum([calendar[day] != Work \/
                               exists(i in 1..intervals)(day >= leave[i, Start] 
                                                         /\ day <= leave[i, End]) 
                              | day in 1..length(calendar)]);
```
Usei o conceito de "list comprehension", em que se aplica filtros e transformações em uma lista. Funciona exatamente da mesma forma que em outras linguagens, como Python e Haskell por exemplo.

### Calculando o descanso extra

Uma prática que parece comum ao organizar férias, é emendar com feriados prolongados. Para considerar esse aspecto na função objetivo, criei uma variável adicional que consiste em contar os dias "bônus" de descanso, logo antes e depois das férias:

```minizinc
function var int: extra_leisure_after(int: offset, int: leave_seq) = forall(i in 1..offset)
                                                                        (if leave[leave_seq, End] + i <= length(calendar) 
                                                                         then calendar[leave[leave_seq, End] + i] != Work 
                                                                         else false endif);


function var int: extra_leisure_before(int: offset, int: leave_seq) = forall(i in 1..offset)
                                                                             (if leave[leave_seq, Start] - i >= 1
                                                                              then calendar[leave[leave_seq, Start] - i] != Work 
                                                                              else false endif);

var int : extra_leisure = sum(i in 1..intervals)(sum(j in 1..5)(extra_leisure_after(j, i))) +
                          sum(i in 1..intervals)(sum(j in 1..5)(extra_leisure_before(j, i)));

```

Esse foi um caso mais complicado de implementar do que eu esperava. Criei duas funções auxiliares, uma para verificar os dias antes do começo da férias e após o término. Para dado `K`, elas calculam se esses `K` dias antes (ou depois) são todos de folga também.

Para esse caso, considerei os próximos 5 dias, pensando no maior feriado brasileiro que é o Carnaval e totaliza 5 dias de folgas, ao considerar a quarta-feira de cinzas. Esses dias extras, serão somados como "bônus" de férias.

### Calculando a distribuição das férias

Assumindo que temos `N` opções ótima, considerando dias de descanso e emendas, entendo que uma boa ideia é espaçar elas o máximo possível como desempate.

A ideia inicial era simplesmente maximizar a distância entre os intervalos, mas acabava sendo válido deixar duas parcelas bem próximas e uma muito distante. 

Depois de testar várias abordagens, optei por calcular algo parecido com uma variância, para penalizar intervalos muito diferentes:

```minizinc
array[1..intervals-1] of var int : distances = [leave[i, Start] - leave[i-1, End] | i in 2..intervals];
var float : mean_distance = sum(distances) / intervals;
var float : variance = sum(i in 1..intervals-1)(abs(distances[i] - mean_distance)) / (intervals - 1);
```

O solver estava tendo problemas ao lidar com exponenciação e raiz, por isso optei por calcular a diferença absoluta em relação a média, ao invés de variância. Não sei se isso tem valida estatística, mas serviu para mitigar o problema de intervalos muito díspares entre si.

### Função objetivo

A função final é uma composição das variáveis calculadas:

```minizinc
solve maximize (total_leisure + extra_leisure) * 1000
               + mean_distance - variance;
```

O ideal seria fazer uma otimização hierárquica: maximizar `total_leisure` e `extra_leisure`. Em caso de empate, maximizar `mean_distance` e reduzir `variance`.

Não é algo possível, então optei por essa estratégia de "garantir" que `total_leisure` e `extra_leisure` serão os critérios prioritários ao multiplicar a soma de ambos por 1000. Dentro de um ano, `mean_distance - variance`, não deve ter mais que 2 casas decimais.

# Resultados

Um problema de avaliar problemas de otimização, é que normalmente é complicado calcular a solução ótima na mão. Se for fácil, não precisa modelar, basta calcular. 

Assim como a modelagem, a minha validação foi completamente informal, só fui ajustando o modelo e avaliando se os resultados pareciam plausíveis. 

Para ilustrar, um relatório de execução que gerei para o ano de 2021, com alguns feriados que registrei manualmente:

```
Início: 12:12:15
Fim: 12:15:09

total_leisure = 139
extra_leisure = 15
distances = [17, 51]
mean_distance = 22.6666666666667
variance = 17.0

Intervalo 1: 2021-01-04 - 2021-01-22
Intervalo 2: 2021-02-08 - 2021-02-13
Intervalo 3: 2021-04-05 - 2021-04-09
```

O modelo conseguiu alocou todas as divisões próximo de feriados: aniversário da cidade de São Paulo (25/01), Carnaval (15/02 até 17/02) e Páscoa (02/04). 

Se eu adicionar uma distorção, o [mega-feriado](https://vejasp.abril.com.br/cidades/megaferiado-abre-fecha-sp/) da cidade de São Paulo, as férias ficam antes e depois do feriado para criar uma férias enorme: 

```
Início: 12:06:26
Fim: 12:10:10

total_leisure = 143
extra_leisure = 20
distances = [24, 9]
mean_distance = 11.0
variance = 7.49999999999999

Intervalo 1: 2021-02-08 - 2021-02-12
Intervalo 2: 2021-03-08 - 2021-03-27
Intervalo 3: 2021-04-05 - 2021-04-09
```

Em uma execução sem feriados, as férias ficam bem espaçadas, como esperado pelo critério de desempate da otimização:

```
Início: 12:21:00
Fim: 12:24:13

total_leisure = 129
extra_leisure = 11
distances = [115, 213]
mean_distance = 109.333333333334
variance = 54.6666666666667

Intervalo 1: 2021-01-04 - 2021-01-08
Intervalo 2: 2021-05-03 - 2021-05-07
Intervalo 3: 2021-12-06 - 2021-12-25
```

Em relação ao tempo de execução, foi usado processamento paralelo (6 processos) e Gecode como solver. Os processos não consomem muita memória, mas escalam muito bem horizontalmente.

Abaixo, um resumo das configurações do sistema para contexto, que utilizei para rodar essas simulações: 

```
OS: Pop!_OS 20.10 x86_64 
Kernel: 5.11.0-7612-generic 
CPU: Intel i5-10400F (12) @ 4.300GHz 
GPU: NVIDIA GeForce GTX 1650 
Memory: 7902MiB / 15871MiB 
```

# Integração com Python

Para fazer essas execuções, eu usei um script em Python para facilitar a definição de parâmetros e formatação dos resultados.  