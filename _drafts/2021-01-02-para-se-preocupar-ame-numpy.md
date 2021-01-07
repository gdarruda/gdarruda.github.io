---
layout: post
title: "Pare de se preocupar e comece a amar o NumPy"
comments: true
mathjax: true
description: "Abraçando a programação vetorial"
keywords: "programação vetorial, NumPy, pandas"
---

Eu demorei um pouco para me acostumar com o Numpy, [programação vetorial](https://en.wikipedia.org/wiki/Array_programming) é bem diferente do estilo mais imperativo e  orientado a objetos do Python puro. Até eu aprender alguns "truques", nunca me sentia muito confortável usando o Numpy.

Nesse post, vou abordar um problema inicialmente a partir de uma abordagem mais imperativa e orientada a objetos em Python puro, para depois re-implementar uma solução vetorizada com Numpy. Dessa forma, consigo ilustrar as diferenças, lidando com o mesmo problema a partir de abordagens diferentes.

## Definindo o problema

O problema, que será usado de exemplo, é de representar a hora como um ponto no círculo trigonométrico. Esse problema pode ser resolvido com duas transformações simples. Primeiramente, devemos calcular um arco que a hora gera a partir da meia-noite:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Depois, projetar esse arco no círculo trigonométrico:

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Os detalhes do porquê e como essa representação é útil, está no [post original]({{site.url}}/2021/01/02/como-representar-dados-circulares.html). Mas fique tranquilo de seguir nesse post sem entender a motivação ou a matemática, essa transformação pode ser tratada como uma caixa-preta sem prejuízo a essa discussão. A ideia é justamente abstrair o que está feito.

## Solução "a moda OO"

A solução para esse problema, usando orientação a objetos, funciona muito bem. Já existe a classe [datetime](https://docs.python.org/3/library/datetime.html#datetime-objects) nativa do Python, para adicionar esse novo comportamento, foi criada uma sub-classe `datetime_circle` contendo dois novos métodos conforme o código abaixo:

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

Dessa forma, adicionamos os métodos novos que precisamos, mas o polimorfismo possibilita que os usuários continuem se aproveitando dos métodos da classe `datetime` como podemos observar no exemplo abaixo:

```python
In [2]: datetime_circle.strptime('00:00', '%H:%M').to_coordinates()
Out[2]: (6.123233995736766e-17, 1.0)

In [3]: datetime_circle.strptime('12:00', '%H:%M').to_coordinates()
Out[3]: (6.123233995736766e-17, -1.0)

In [4]: datetime_circle.strptime('6:00', '%H:%M').to_coordinates()
Out[4]: (1.0, 0.0)
```

Nenhum problema inerente a essa solução, especialmente se estamos adicionando esses recursos a uma base de código pré-existente com vários desenvolvedores envolvidos e códigos baseados na classe `datetime`. 

Porém, a minha necessidade era outra.

Eu precisei dessa transformação para resolver um problema de agrupamento, que envolve aplicá-la em milhões de linhas em um [DataFrame](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html). Nesse cenário, dois problemas surgem: desempenho e integração desajeitada.

Para deixar essa transformação sobre DataFrame reaproveitável, optei por encapsular a transformação em uma função auxiliar. Dessa forma, eu consigo usar com o método `apply` em qualquer DataFrame e esconder um pouco da implementação:

```python
def datetime_to_coordinates(row: pd.Series, column: str):
    x, y = datetime_circle.strptime(row[column], '%H:%M:%S').to_coordinates()
    row[f'{column}_x'] = x
    row[f'{column}_y'] = y
    return row
```

O problema é que ficou extremamente lento, demorando uma média de 5 segundos para ser executado em um DataFrame de somente 3000 linhas.

```python
%%timeit -n 15

df_samples.apply(lambda row: datetime_to_coordinates(row, 'time'), axis=1)

# 5.39 s ± 92.8 ms per loop (mean ± std. dev. of 7 runs, 15 loops each)
```

Ao procurar alguma forma de otimizar isso, certamente a primeira sugestão será transformar seu código em uma [solução vetorizada com NumPy](https://stackoverflow.com/questions/24870953/does-pandas-iterrows-have-performance-issues#24871316). A questão é como fazer esse código, sem perder em reuso e clareza da solução orientada a objetos em Python puro.

## Solução vetorial: bonita e eficiente

O Python é uma linguagem famosa por [ser lenta](https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b), então não precisa de muito coisa para cair em problemas de performance. Quando se fala de análise de dados, não é raro precisar re-implementar algo em NumPy por esse motivo.

Acredito que faz sentido sempre pensar em uma solução vetorizada nesses casos. Não como uma forma de otimização prematura, mas porque programação vetorial é um paradigma pensado para trabalhar com esse tipo de problema.

Sempre é complicado lidar com um paradigma novo. Mesmo que adequado para o problema em questão, de início é desgastante pensar de outra forma. Minha relação com o NumPy era justamente essa: preferia fazer o código usando orientação a objetos e Python puro, mas acabava obrigado a transformar em NumPy para ter uma performance aceitável.

Depois de aprender alguns conceitos e alguns truques de sintaxe, minha relação com o NumPy melhorou.

### Pense em modelar operações, não objetos

Um dos melhores insights sobre as diferenças entre os paradigmas funcional e orientado a objetos, é entender que eles lidam com os problemas de [perspectivas perfeitamente opostas](https://www.coursera.org/learn/programming-languages-part-c/lecture/mKEXO/oop-versus-functional-decomposition).

Em orientação a objetos, é normal pensarmos nas nas características dos objetos (atributos) e seus comportamentos (métodos). Na solução apresentada, adicionei ao objeto `datetime` o comportamento de apresentar as horas na forma de um arco com o método `to_radians`. 

Na abordagem vetorial, que lembra a funcional nesse aspecto, pensamos apenas na transformação sem associá-la ao comportamento de um objeto:

```python
import numpy as np

def hour_to_radians(hours):
    return (np.pi / 2) - (hours * (np.pi/12))
```

Não parece muito diferente, porque no final ainda precisamos escrever a função, mas há um detalhe importante se olharmos a implementação vetorizada da transformação de horas em radianos `hour_to_radians`. O atributo `hours` pode ser tanto uma escalar como uma matriz, porque o objetivo do NumPy é deixar a operação de multiplicação transparente para o usuário. 

Para alguns tipos de problema, faz mais sentido pensar nas abstrações dessa forma que associando a objetos. Suponha que temos uma matriz $$ A $$ e uma escalar $$ x $$. Quando definimos uma multiplicação entre matriz e escalar, escrevemos da mesma forma que entre duas escalares ou duas matrizes, na forma "$$ xA $$" e não algo como "$$ A.multiplicaEscalar(x) $$". 

Para linguagem matemática, essa abstração do NumPy[^1] da mutplicação me parece mais intuitiva que orientação a objetos. Após anos abstraindo problemas a partir de objetos pode parecer estranho, mas é uma que faz mais sentido dependendo do contexto.

[^1]: infelizmente esse exemplo é meio falho, porque o operador `*` não multiplica duas matrizes por exemplo. Há outros métodos como `matmul` e `dot`, mas a ideia geral da biblioteca é tentar abstrair isso ao máximo.

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