---
layout: post
title: "Engenharia de dados: por que tão díficil?"
comments: true
mathjax: true
description: "Os desafios de engenharia de dados"
keywords: "Spark"
---

No trabalho, apareceu um problema relativamente simples, enviar predições de machine learning armazenadas em uma tabela para uma fila no formato `json`. Algo simples em termos de requisitos funcionais, mas menos trivial ao adicionar requisitos de escalabilidade e taxa de transferência.

Nem pretendia escrever nada sobre isso, mas acabou sendo um exemplo didático dos desafios particulares da engenharia de dados. Passando pelas dificuldades desse problema específico, posso ilustrar os desafios que aparecem ao fazer fluxos de dados para grandes volumes de dados.

## Mockando a entrada

A saída do modelo, que precisamos enviar para a fila, é uma tabela com o schema abaixo.

```
root
 |-- id_client: string (nullable = true)
 |-- class_0: double (nullable = true)
 |-- class_1: double (nullable = true)
 |-- class_2: double (nullable = true)
 ...
 |-- class_29: double (nullable = true)
```

O campo `id_client` identifica o cliente unicamente. Os campos com a nomenclatura `class_[0-9]+` estão no intervalo [0,29], eles representam as probabilidades de cada classe gerada para o modelo.

Para gerar dados fictícios nesse formato, foi utilizado esse [script Python](https://github.com/gdarruda/spark-demo/blob/main/python/fake_data.py) para criar esses dados aleatórios em formato parquet. Para esse experimento, está configurando para gerar 60.000.000 milhões de predições.

Antes de executar esse script, é necessário definir o tamanho da variável chamada `BATCH_SIZE`, que vai depender da memória disponível e da quantidade de núcleos.

```python
UM_CLASSES = 30
BATCH_SIZE = 2_000_000
NUM_CLIENTS = 60_000_000
PATH = '../resources/inline.parquet'
```

O batch de de 2.000.000 milhões de clientes, foi considerando que posso rodar 12 threads em paralelo e tenho 16GB livres. Fazendo alguns testes, foi possível chegar nesse valor, que otimiza o uso dos núcleos e memória disponíveis.

Pensando nesses requisitos funcionais, eu poderia ter feito um script *single-thread* que escreve um registro de cada vez no format texto. Mas **engenharia de dados é muito mais sobre os requisitos não funcionais que não funcionais.**

Entre as duas opções de solução, o papel do engenheiro de dados é entender os requisitos não funcionais e a disponibilidade de poder computacional.

Por exemplo, se esse processo é executado por uma aplicação transacional online, é temerário pressionar a memória com a solução *multi-thread*. Por outro lado, se estamos alocando uma máquina dedicada em cloud, estamos perdendo tempo e dinheiro ao não estressar ao máximo a memória e o processamento.

As lógicas de fluxo de dados costumam ser simples, mas é importante que o engenheiro saiba os *trade-offs*  de implementá-la de diferentes formas, que sejam adequadas ao contexto.

Com a base de exemplo gerada, podemos partir para o problema em questão: transformar essas 60.000.000 milhões de predições em mensagens JSON.

## Agrupando as predições

Para enviar essas predições em uma fila, o ideal é agrupar as predições para criar um `payload` com múltiplas predições e enviar uma quantidade menor de mensagens com mais dados.

As predições podem ser agrupadas arbitrariamente, mas precisam ter um tamanho máximo para não ultrapassar o tamanho máximo do `payload`, nesse caso iremos trabalhar com 10 predições por mensagens.

Para fazer isso, é simples: sabendo o total de linhas $$N$$ e a quantidade de mensagens por grupo $$K$$, precisamos criar $$G$$ grupos, sendo $$G=N/K$$. Para alocar as predições dentro desses grupos, para cada linha $$\#N$$, podemos obter o grupo da linha com o resto da divisão: $$\#N \ mod \ G$$.

Em um processo *single-thread*, é trivial associar um sequencial para as linhas e usar no cálculo do grupo, mas não nem tanto quando se fala em processamento distribuído.

No próprio [knowledge base da Databricks](https://kb.databricks.com/en_US/sql/gen-unique-increasing-values), é recomendado fazer da seguinte forma para um DataFrame Spark:

```python
from pyspark.sql.functions import *
from pyspark.sql.window import *

df_with_increasing_id = df.withColumn("monotonically_increasing_id", monotonically_increasing_id())
window = Window.orderBy(col('monotonically_increasing_id'))
df_with_consecutive_increasing_id = df_with_increasing_id.withColumn('increasing_id', row_number().over(window))
```

Solução elegante, mas ao executar esse código, o próprio Spark avisa que você pode estar criando um problemão:

```
WARN WindowExec: No Partition Defined for Window operation! Moving all data to a single partition, this can cause serious performance degradation.
```

