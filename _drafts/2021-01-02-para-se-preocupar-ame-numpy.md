---
layout: post
title: "Pare de se preocupar e comece a amar o NumPy"
comments: true
mathjax: true
description: "Abraçando a programação vetorial"
keywords: "programação vetorial, NumPy, pandas"
---

No último texto sobre programação, fiz uma discussão mais ampla sobre o [porquê estudar conceitos de linguagens]({{site.url}}/2020/09/23/linguagens-programacao.html). Agora, pretendo colocar isso de forma mais prática com base no código desenvolvido para [esse estudo]({{site.url}}/2021/01/02/como-representar-dados-circulares.html), falando de como me acostumei a trabalhar com o Numpy.

Mais complicado que entender os conceitos por trás de diferentes paradigmas de programação, é como pensar e estruturar as soluções de forma idiomática. Para uma boa tradução texto, não basta simplesmente saber as regras gramaticas dos idiomas, o mesmo vale para diferentes paradigmas de programação em alguma medida.

Nesse sentido, demorei um pouco para me acostumar com o Numpy, [programação vetorial](https://en.wikipedia.org/wiki/Array_programming) é bem diferente do estilo mais imperativo e  orientado a objetos do Python puro. Até eu aprender alguns "truques", nunca me sentia muito confortável usando o Numpy.

Nesse post, vou abordar um problema a partir de uma abordagem mais imperativa e orientada a objetos em Python puro, para depois implementar uma solução vetorizada com Numpy. Dessa forma, consigo mostrar as diferenças na forma de resolver um problema, quando preciso lidar a partir de uma perspectiva ou outra.


## Definindo o problema

O problema que pretendo abordar, é como projetar horas de forma circular para uso em modelos. Esse problema pode ser resolvido com duas transformações bem simples, ideal para a discussão justamente por exigir pouco código e fácil de entender.

Primeiramente, devemos transformar as horas em um arco:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Depois, decompor esse arco em duas variáveis (x, y):

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Os detalhes do porquê e como essa transformação é útil, está no [post original]({{site.url}}/2021/01/02/como-representar-dados-circulares.html). Mas fique tranquilo de seguir nesse post sem entender a motivação ou a matemática, essa transformação pode ser tratada como uma caixa-preta sem prejuízo a essa discussão.

## Solução "a moda OO"

A solução para esse problema, usando orientação a objetos, fica bem elegante. Aproveitando a classe [datetime](https://docs.python.org/3/library/datetime.html#datetime-objects) nativa do Python, podemos criar uma sub-classe que adiciona esses dois métodos: 

```python
from datetime import datetime
import math

class datetime_circle(datetime):

    def to_radians(self) -> float:
        hours = self.hour + (self.minute / 60)
        return (math.pi / 2) - (hours * (math.pi/12))
    
    def to_coordinates(self) -> (float, float):
        radians = self.to_radians()
        return math.cos(radians), math.sin(radians)
```

Dessa forma, aproveitamos os métodos pré-existentes na implementação e o usuário pode aproveitar o polimorfismo:

```python
In [2]: datetime_circle.strptime('00:00', '%H:%M').to_coordinates()
Out[2]: (6.123233995736766e-17, 1.0)

In [3]: datetime_circle.strptime('12:00', '%H:%M').to_coordinates()
Out[3]: (6.123233995736766e-17, -1.0)

In [4]: datetime_circle.strptime('6:00', '%H:%M').to_coordinates()
Out[4]: (1.0, 0.0)
```

Nenhum problema inerente a essa solução, especialmente se estamos adicionando esses recursos a um sistema pré-existente com vários desenvolvedores envolvidos e códigos baseados na classe `datetime`. Porém, a minha necessidade era outra.

Eu precisei dessa transformação para resolver um problema de agrupamento, que envolve aplicá-la em milhões de linhas em um [DataFrame pandas](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html). Nesse cenário, dois problemas surgem: desempenho e integração desajeitada.

Para deixar essa transformação sobre DataFrame mais simples e reaproveitável, optei por encapsular a transformação em uma função auxiliar. Dessa forma, eu consigo usar com o método `apply` em qualquer DataFrame e esconder um pouco da implementação:

```python
def datetime_to_coordinates(row: pd.Series, column: str):
    x, y = datetime_circle.strptime(row[column], '%H:%M:%S').to_coordinates()
    row[f'{column}_x'] = x
    row[f'{column}_y'] = y
    return row
```

O problema é que ficou extremamente lento, demorando em média 5 segundos para ser executado em um DataFrame de 3000 linhas.

```python
%%timeit -n 15

df_samples.apply(lambda row: datetime_to_coordinates(row, 'time'), axis=1)

# 5.39 s ± 92.8 ms per loop (mean ± std. dev. of 7 runs, 15 loops each)
```

Ao procurar alguma forma de otimizar isso, certamente a primeira sugestão será transformar seu código em uma [solução vetorizada com NumPy](https://stackoverflow.com/questions/24870953/does-pandas-iterrows-have-performance-issues#24871316). Eu concordo 100%: se você está trabalhando com Dataframes, é sempre recomendável optar por código vetorizado pensando em performance.

 A questão é como fazer esse código, mas sem perder em reuso e clareza comparada a solução orientada a objetos em Python puro.

## Solução vetorial: bonita e eficiente

O Python é uma linguagem famosa por [ser lenta](https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b), então não precisa de muito coisa para cair em problemas de performance. Dependendo do problema, a pessoa se enxerga obrigada a implementar em NumPy algo que estava em Python puro.

Ao menos falando de códigos para análise de dados e modelagem, acredito que faz sentido já pensar de início em solução vetorizada. Não como uma forma de otimização prematura de performance, mas porque programação vetorial é um paradigma pensado para trabalhar com esse tipo de problema.

Sempre é complicado lidar com um paradigma novo. Mesmo que adequado para o problema em questão, de início é desgastante pensar de outra forma e o código simplesmente fica ruim. Essa era minha relação com o NumPy, mas ultimamente me sinto mais confortável em fazer soluções já pensando nele.

### Pense em modelar operações, não objetos

Um dos melhores insights sobre as diferenças entre os paradigmas funcional e orientado a objetos, é entender que eles lidam com os problemas de [perspectivas perfeitamente opostas](https://www.coursera.org/learn/programming-languages-part-c/lecture/mKEXO/oop-versus-functional-decomposition). Dessa forma, é mais simples pensar em como modelar um mesmo problema usando duas abordagens diferentes.

Em orientação a objetos, é normal pensarmos nas responsabilidades dos objetos. Em nosso problema, adicionamos ao objeto `datetime` a capacidade de apresentar as horas arco com o método `to_radians`. Na abordagem vetorial, pensamos em como transformar horários em radianos.

Não parece muito diferente, porque realmente é parecido, mas há um detalhe importante se olharmos a implementação vetorizada da transformação de horas em radianos `hour_to_radians`:

```python
import numpy as np

def hour_to_radians(hours):
    return (np.pi / 2) - (hours * (np.pi/12))
```

O atributo hours pode ser tanto uma escalar como uma matriz, porque o objetivo do NumPy é deixar a operação de multiplicação transparente para o usuário. Não importa os objetos, conquanto que seja válido multiplicá-los[^1]. Após anos abstraindo problemas a partir de objetos pode parecer estranho, mas é uma abstração que faz sentido no contexto.

[^1]: infelizmente esse exemplo é meio falho, porque o operador `*` não multiplica duas matrizes por exemplo. Há outros métodos como `matmul` e `dot`, mas a ideia geral da biblioteca é tentar abstrair isso ao máximo.

Suponha que temos uma matriz $$ A $$ e uma escalar $$ x $$. Quando escrevemos uma multiplicação entre matriz e escalar, escrevemos $$ xA $$ e não algo como $$ A.multiplicaEscalar(x) $$. O NumPy se parece muito mais com a linguagem matemática, que uma solução orientada a objetos.

Focando nas operações e não nos objetos envolvidos, a interface do NumPy faz mais sentido que olhando da perspectiva orientada a objetos.

### Sintaxe: assign e parenteses ao resgate

Abordada a questão da abstração, uma outra questão é a sintaxe. Em geral, não gosto muito de discussões sobre sintaxe, porque muitas vezes é uma simples questão de opinião e irrelevante também. Entretanto, apesar de adorar programar em Python puro, me sentia lutando contra a linguagem para lidar com código mais declarativo do paradigma vetorial.

Nessa "luta", acho que duas coisas me ajudaram: o método assign dos DataFrame e o uso de parenteses para concatenar comandos. Ainda há alguns percalços, como veremos na solução final, mas essas duas dicas já melhoraram bastante trabalhar com Numpy e pandas.

O [assign](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.assign.html) é a forma padrão de adicionar/modificar colunas do DataFrame, mas algo interessante que eu não sabia era possibilidade de auto-referenciar o DataFrame usando o `lambda`. 

No exemplo da documentação, podemos ver que uma variável criada no próprio assign é utilizada na criação de outra:

```python
>>> df.assign(temp_f=lambda x: x['temp_c'] * 9 / 5 + 32,
...           temp_k=lambda x: (x['temp_f'] +  459.67) * 5 / 9)
          temp_c  temp_f  temp_k
Portland    17.0    62.6  290.15
Berkeley    25.0    77.0  298.15
```

A despeito de ser possível criar duas variáveis em um comando `assign`, como no exemplo acima, eu prefiro fazer em comandos separados. Isso facilita a depuração, já que posso facilmente comentar trechos e a mim oferece uma relação de ordem mais clara. Colocando esses múltiplos comandos `assign` entre parenteses, consigo encadeá-los sem adicionar o escape (`"\"`) ao final de cada linha, já que tudo dentro dos parenteses é tratado com um único comando.

Abaixo, a minha solução para a transformação aproveitando essas dicas:

```python
%%timeit -n 15

(df_samples
        .assign(hour = lambda df: pd.to_datetime(df.time))
        .assign(hour_radians = lambda df: hour_to_radians(df.hour.dt.hour + df.hour.dt.minute.div(60)))
        .assign(hour_x = lambda df: np.cos(df.hour_radians),
                hour_y = lambda df: np.sin(df.hour_radians)))

# 164 ms ± 5.93 ms per loop (mean ± std. dev. of 7 runs, 15 loops each)
```

Em relação ao ganho de desempenho, não tem o que discutir: vai de 5,4 segundos em média para 0,164 segundos, 30 vezes mais rápido.

Em relação às qualidades subjetivas do código, acho que ficou muito simples de entender.  No contexto de código para notebooks, acho interessante que a implementação fica mais explícita: para alguém que deseja entender o que estou fazendo, o que geralmente não é um caso para código de sistema. Entretanto, toda essa discussão é bem subjetiva.

Infelizmente, para encapsular essa transformação nos moldes da função `datetime_to_coordinates`, precisaria recorrer a uma gambiarra para criar os campos com nomes dinâmicos:

```python
def datetime_to_coordinates(df: pd.DataFrame, column: str):
    return (df_samples
                .assign(hour = lambda df: pd.to_datetime(df[column]))
                .assign(hour_radians = lambda df: hour_to_radians(df.hour.dt.hour   + df.hour.dt.minute.div(60)))
                .assign(hour_x = lambda df: np.cos(df.hour_radians),
                        hour_y = lambda df: np.sin(df.hour_radians))
                .rename(columns={'hour_x': f'{column}_x',
                                 'hour_x': f'{column}_y'})
                .drop(columns=['hour', 'hour_radians'])
    )
```

Além de não ser muito bonito renomear as colunas ao final, caso o DataFrame tenha alguma coluna com o nome das transformações intermediárias, pode gerar uma alteração indesejada. Tratar seria possível, mas trabalhoso.

## Conclusão

Se você olhar o [notebook](https://github.com/gdarruda/representacao_circular/blob/main/estudo.ipynb) do estudo que originou esse post, perceberá que me adaptei bem a esse estilo de programação. Alguns meses atrás, eu mesmo acharia esse código bastante estranho, mas acredito que para problemas de análise exploratória e modelagem é o mais adequado.

Espero que, caso você tenha o mesmo desconforto que eu tive ao me acostumar com o NumPy, essas dicas ajudem na adaptação porque é inevitável utilizá-lo se você trabalha com análise de dados em Python.