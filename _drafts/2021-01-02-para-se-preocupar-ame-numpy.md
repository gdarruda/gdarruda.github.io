---
layout: post
title: "Pare de se preocupar e comece a amar o NumPy"
comments: true
mathjax: true
description: "Abraçando a programação vetorial"
keywords: "programação vetorial, NumPy, pandas"
---

Eu demorei um pouco para me acostumar com o Numpy, [programação vetorial](https://en.wikipedia.org/wiki/Array_programming) é bem diferente do estilo mais imperativo e  orientado a objetos do Python puro. Até eu entender melhor a diferença dos paradigmas e aprender alguns "truques" de linguagem, não me sentia muito confortável usando o Numpy.

Para ilustrar minha adaptação à biblioteca, vou abordar nesse post um problema a partir de duas perspectivas. Primeiro, desenvolver uma solução mais imperativa e orientada a objetos em Python. Depois, implementar o mesmo problema usando uma abordagem vetorial com NumPy.

## Definindo o problema

O objetivo do post é contrastar dois paradigmas, então usarei um problema simples como base. A ideia é projetar a informação de hora como um ponto no círculo trigonométrico, os detalhes do porquê disso e como essa representação é útil,  está em [outro post ]({{site.url}}/2021/01/02/como-representar-dados-circulares.html). 

O leitor pode ficar tranquilo de seguir nesse post sem entender a motivação ou a matemática, essa transformação pode ser tratada como uma caixa-preta sem prejuízo a discussão. 

 Abaixo, as duas equações que serã implementadas. O primeiro passo, é calcular o arco que a hora gera a partir da meia-noite:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Depois, esse arco é projetado no círculo trigonométrico:

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

## Solução "a moda OO"

Conforme definido na introdução, primeiramente será desenvolvida uma solução orientada a objetos para resolver o problema, sem o uso da biblioteca NumPy.

Para trabalhar com horas e datas, já existe a classe [datetime](https://docs.python.org/3/library/datetime.html#datetime-objects) nativa do Python. Criando uma sub-classe `datetime_circle`, contendo dois novos métodos, podemos adicionar esse novo comportamento ao objeto `datetime`:

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

Utilizando o conceito de sub-classe, foi possível adicionar o novo comportamento aproveitando as vantagens do polimorfismo. Abaixo, um exemplo de uso, combinando os métodos nativos da classe `datetime` junto com os métodos criados na classe `datetime_circle`:

```python
In [2]: datetime_circle.strptime('00:00', '%H:%M').to_coordinates()
Out[2]: (6.123233995736766e-17, 1.0)

In [3]: datetime_circle.strptime('12:00', '%H:%M').to_coordinates()
Out[3]: (6.123233995736766e-17, -1.0)

In [4]: datetime_circle.strptime('6:00', '%H:%M').to_coordinates()
Out[4]: (1.0, 0.0)
```

Nenhum problema inerente a essa solução, especialmente se estamos adicionando esses recursos a uma base de código pré-existente, com vários desenvolvedores envolvidos e códigos baseados na classe `datetime`. 

Porém, a minha necessidade era outra.

Eu precisei dessa transformação para resolver um problema de agrupamento, que envolve aplicá-la em milhões de linhas de um [DataFrame](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html). Nesse cenário, dois problemas surgem: desempenho e integração desajeitada.

Para deixar essa transformação sobre DataFrame reaproveitável, optei por encapsular a transformação em uma função auxiliar. Dessa forma, eu consigo usar com o método `apply` em qualquer DataFrame e esconder um pouco da implementação:

```python
def datetime_to_coordinates(row: pd.Series, column: str):
    x, y = datetime_circle.strptime(row[column], '%H:%M:%S').to_coordinates()
    row[f'{column}_x'] = x
    row[f'{column}_y'] = y
    return row
```

O problema é que ficou extremamente lento, demorando uma média de 5 segundos, para ser executado em um DataFrame de apenas 3000 linhas:

```python
%%timeit -n 15

df_samples.apply(lambda row: datetime_to_coordinates(row, 'time'), axis=1)

# 5.39 s ± 92.8 ms per loop (mean ± std. dev. of 7 runs, 15 loops each)
```

Ao procurar alguma forma de otimizar essa solução, certamente a primeira sugestão será transformar seu código em uma [solução vetorizada com NumPy](https://stackoverflow.com/questions/24870953/does-pandas-iterrows-have-performance-issues#24871316).

A questão é como fazer essa transformação, sem perder em reuso e clareza, comparada à solução orientada a objetos.

## Solução vetorial: bonita e eficiente

O Python é uma linguagem famosa por [ser lenta](https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b), então não precisa de muito para cair em problemas de performance. Quando se fala de análise de dados, não é raro esse cenário de precisar re-implementar algo em NumPy por desempenho.

Considerando esse fator, acredito que faça sentido pensar em uma solução vetorizada como abordagem padrão para análise de dados em Python. Não somente por isso, mas também porque programação vetorial é um paradigma pensado para trabalhar com esse tipo de problema.

Entendo que sempre é complicado lidar com um paradigma novo – mesmo que adequado para o problema em questão – é desgastante pensar de outra forma. Minha relação com o NumPy era exatamente esse cenário: preferia fazer o código usando orientação a objetos e Python puro que estava acostumado, mas acabava obrigado a transformar em NumPy para ter uma performance aceitável.

Depois de aprender alguns conceitos e alguns truques de sintaxe, minha relação com o NumPy melhorou.

### Pense em modelar operações, não objetos

Um dos melhores insights sobre as diferenças entre os paradigmas funcional e orientado a objetos, é entender que eles lidam com os problemas de [perspectivas perfeitamente opostas](https://www.coursera.org/learn/programming-languages-part-c/lecture/mKEXO/oop-versus-functional-decomposition).

Em orientação a objetos, é normal pensarmos nas nas características dos objetos (atributos) e seus comportamentos (métodos). Na solução implementada, adicionei ao objeto `datetime` o comportamento de apresentar as horas na forma de um arco com o método `to_radians`. 

Na abordagem vetorial, que lembra a funcional nesse aspecto, pensamos apenas na transformação sem associá-la a um objeto:

```python
import numpy as np

def hour_to_radians(hours):
    return (np.pi / 2) - (hours * (np.pi/12))
```

Não parece muito diferente, porque no final ainda precisamos escrever a função, mas há um detalhe importante se olharmos a implementação vetorizada. O atributo `hours` pode ser tanto uma escalar como uma matriz, porque o objetivo do NumPy é deixar a operação de multiplicação transparente em relação aos objetos envolvidos.

Para alguns tipos de problema, faz mais sentido pensar nas abstrações dessa forma que associando a objetos. Suponha que temos uma matriz $$ A $$ e uma escalar $$ x $$. Quando definimos uma multiplicação entre matriz e escalar, escrevemos da mesma forma que entre duas escalares ou duas matrizes, na forma "$$ xA $$" e não algo como "$$ A.multiplicaEscalar(x) $$". 

Para linguagem matemática, essa abstração do NumPy[^1] me parece mais intuitiva que orientação a objetos. Após anos abstraindo problemas a partir de objetos, pode parecer estranho essa perspectiva, mas faz sentido dependendo do contexto.

[^1]: infelizmente esse exemplo é meio falho, porque o operador `*` não multiplica duas matrizes. Há outros métodos como `matmul` e `dot`, mas a organização geral do NumPy é para manipular os objetos independentemente dos `shapes` envolvidos.

### Sintaxe: assign e parenteses ao resgate

Abordada a questão da abstração, um outro problema é a sintaxe.

Em geral, não gosto muito de discussões sobre sintaxe, porque normalmente se resume a uma questão de preferências. Entretanto, apesar de adorar programar em Python, me sentia lutando contra a linguagem para lidar com código mais declarativo do paradigma vetorial.

Nessa "luta", acho que duas coisas me ajudaram muito: o método assign dos DataFrame e o uso de parenteses para concatenar comandos. Ainda há alguns percalços, como será discutido adiante, mas essas duas dicas já ajudaram bastante na hora de trabalhar com Numpy e pandas.

O [assign](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.assign.html) é a forma padrão de adicionar/modificar colunas do DataFrame, mas algo interessante que eu não sabia, é a possibilidade de auto-referenciar o DataFrame usando `lambda`. 

No exemplo da documentação, podemos ver que uma variável criada no próprio `assign`, pode ser utilizada na criação de outra dentro do mesmo comando:

```python
>>> df.assign(temp_f=lambda x: x['temp_c'] * 9 / 5 + 32,
...           temp_k=lambda x: (x['temp_f'] +  459.67) * 5 / 9)
          temp_c  temp_f  temp_k
Portland    17.0    62.6  290.15
Berkeley    25.0    77.0  298.15
```

A despeito de ser possível criar duas variáveis dependentes em um comando `assign`, prefiro fazer em comandos separados. 

Separar os comandos facilita a depuração, já que posso facilmente comentar algumas partes do processo e também oferece uma relação de ordem mais explícita. Colocando esses múltiplos comandos `assign` entre parenteses, consigo encadeá-los sem adicionar o escape (`"\"`) ao final de cada linha, já que tudo dentro dos parenteses é tratado com um único comando.

Abaixo, a minha solução para a transformação, aproveitando essas dicas:

```python
%%timeit -n 15

(df_samples
        .assign(hour = lambda df: pd.to_datetime(df.time))
        .assign(hour_radians = lambda df: hour_to_radians(df.hour.dt.hour + df.hour.dt.minute.div(60)))
        .assign(hour_x = lambda df: np.cos(df.hour_radians),
                hour_y = lambda df: np.sin(df.hour_radians)))

# 164 ms ± 5.93 ms per loop (mean ± std. dev. of 7 runs, 15 loops each)
```

Em relação ao ganho de desempenho, não tem o que discutir: vai de 5,4 segundos em média para 0,164 segundos, 30 vezes mais rápido. Em relação às qualidades subjetivas do código, acho que essa solução continuou elegante e clara.

Infelizmente, para encapsular essa transformação nos moldes da função `datetime_to_coordinates` criada para a solução orientada a objetos, precisei recorrer a uma gambiarra. Usando o método `rename` do pandas, é possível manter a definição das colunas de forma dinâmica:

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