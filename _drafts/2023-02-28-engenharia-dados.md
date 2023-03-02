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

## Como não agrupar as predições

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

Solução elegante, mas ao executar esse código, o próprio Spark avisa que você pode estar gerando um problemão:

```
WARN WindowExec: No Partition Defined for Window operation! Moving all data to a single partition, this can cause serious performance degradation.
```

A função de janela envolve ordenar todo o dataframe, que é um processo muito custoso em execução distribuída, já que envolve transferir e processar todos os dados em um executor.

Em uma execução local, não seria problema porque todos os dados estão em uma memória compartilhada. **Reproduzir um ambiente de execução distribuído é muito complexo, gerando erros que só aparecem tardiamente no processo de desenvolvimento.**

## Agrupando com *zipWithIndex*

Uma alternativa menos onerosa, é utilizar a função [zipWithIndex](https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.RDD.zipWithIndex.html), que ordena os registros dentro de suas partições. O problema é que essa função é do objeto [RDD](https://spark.apache.org/docs/latest/rdd-programming-guide.html), uma abstração mais simples sobre a qual o DataFrame é construído.

Em outras palavras, significa que teremos que usar código procedural ao invés de [Spark SQL](https://spark.apache.org/sql/). Enquanto usamos a API de alto nível, a linguagem utilizada não impacta na performance, mas o cenário muda quando manipulamos diretamente o RDD.

O Python é a lingua franca do mundo dos dados, mas em cenários que demandam alto desempenho, ele trabalha como a "cola" e não como runtime principal. Por exemplo, ao utilizar Spark para preparação de dados e PyTorch para machine learning, estamos usando Python para orquestrar o trabalho pesado feito em Scala e C++.

Abaixo os códigos – em Python e Scala – para o mesmo problema: incluir uma coluna sequencial a um DafaFrame.

```python
# Criação de coluna sequencial em Python
def add_sequence_column(df: DataFrame, col: str) -> DataFrame:
    
    return (df
            .rdd
            .zipWithIndex()
            .map(lambda x: Row(**(x[0].asDict() | {col: x[1]})))
            .toDF())
```
```scala
// Criação de coluna sequencial em Scala
def add_sequence_column(df: DataFrame, 
                        col: String,
                        spark: SparkSession) : DataFrame = {
    
    val rdd = df
        .rdd
        .zipWithIndex()
        .map(x => Row.fromSeq(x._1.toSeq ++ Array(x._2)))
    
    val schema = df.schema.add(StructField(col, LongType))
  
    spark.createDataFrame(rdd, schema)
  }

```

Utilizando essa função, podemos fazer uma comparação de performance gerando um DataFrame com as predições agrupadas e serializadas em json. Exceto pela função `add_sequence_column`, a solução em Scala e Python são idênticas.

```scala
// Solução em Scala
val messages_to_send = add_sequence_column(file, "sequential_id", spark)
      .withColumn("predict", 
                  struct(file
                          .schema
                          .fields
                          .map(column => col(column.name)): _*))
      .withColumn("predict_group", col("sequential_id") % lit(num_groups))
      .groupBy(col("predict_group"))
      .agg(collect_list("predict").alias("predicts"))
      .select(to_json(col("predicts")).alias("predicts"))

messages_to_send
      .write
      .mode("overwrite")
      .parquet("../resources/output_scala.parquet")
```
```python
# Solução em Python
messages_to_send = (add_sequence_column(file, 'sequential_id')
    .withColumn('predict', struct([col(c.name) 
                                   for c 
                                   in file.schema]))
    .withColumn('predict_group', col('sequential_id') % lit(num_groups))
    .groupBy(col('predict_group'))
    .agg(collect_list('predict').alias('predicts'))
    .select(to_json(col("predicts"))))

(messages_to_send
    .write
    .mode("overwrite")
    .parquet("../resources/output_python.parquet"))
```

Em termos de performance, são precisos mais dois jobs (4 e 5) para integrar Python com Spark.

![Spark History - Python](/assets/images/spark-demo/spark-history-python.png)

Não são jobs muito demorados, mas o processo em Python consome mais memória, exigindo mais do swap e atrasando os últimos dois jobs (6 e 7). No processo em Scala, além de menos jobs, os dois últimos são executados mais rapidamente.

![Spark History - Scala](/assets/images/spark-demo/spark-history-scala.png)

No final, o processo em Python demorou um total de 12 minutos, enquanto o processo em Scala demorou 5 minutos.

Em um cenário com mais memória, talvez a diferença fosse menor, mas **estimar a performance, de um processo para diferentes configurações de hardware e distribuição, demanda investigação e conhecimento profundo do funcionamento interno das ferramentas**.

Ou seja, quando se trabalha com processos distribuídos, é complicado reproduzir cenários produtivos e extrapolar conclusão em cenários diferentes. Por isso, é importante que **o engenheiro de dados tenha uma noção intuitiva dos gargalos e evite deixar performance na mesa**.

No contexto de empresas que precisam se mover com agilidade, é normal priorizar velocidade e manutenabilidade no desenvolvimento em detrimento a performance. Melhor investir em máquina e otimizar depois, muito citam a famosa frase do Knuth: 

> premature optimization is the root of all evil.

Não discordo desse "zeitgest", mas não acho que se aplique tão bem às necessidades da engenharia de dados. Os fluxos de processamento de dados costumam ter pouca lógica de negócio e sofrerem menos modificações, mas ter muitos requisitos de performance e escalabilidade.

Vamos considerar os cenários:

* Para implementar esse pipeline, vale a pena usar uma linguagem mais acessível como Python, em detrimento a usar Scala que é a linguagem nativa do Spark? 

* Para fazer o backend de um MVP, faz sentido usar Rust ao invés de Python, por ser uma linguagem com mais performance?

São cenários muito diferentes, mas nas empresas sinto que para processos de engenharia de dados, tomamos decisões de engenharia sempre com a cabeça do segundo cenário.
