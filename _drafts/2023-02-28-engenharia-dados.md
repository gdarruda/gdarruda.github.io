---
layout: post
title: "Engenharia de dados: por que tão díficil?"
comments: true
mathjax: true
description: "Os desafios de engenharia de dados"
keywords: "Spark"
---

No trabalho, apareceu um problema simples: enviar predições de machine learning, armazenadas em uma tabela, para uma fila no formato `json`. Uma questão trivial...até que sejam adicionados requisitos de performance e escalabilidade.

Nem pretendia escrever nada sobre isso, mas acabou sendo um exemplo didático dos desafios particulares da engenharia de dados. Resolvendo esse problema, é possível passar por muita das dores que é trabalhar com fluxos de dados.

## Mockando a entrada

Para começar, primeiro devemos gerar uma base de exemplo, idealmente seguindo a distribuição e volumetria dos dados reais. **Não é incomum encontrar problemas que só aparecem em produção, pelas características únicas do dado e volumetria**.

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

O campo `id_client` identifica o cliente unicamente com um UUID. Os campos com a nomenclatura `class_[0-9]+` estão no intervalo `[0,29]` e representam as probabilidades de cada classe do modelo de machine learning.

Para gerar os dados nesse formato, foi utilizado esse [script Python](https://github.com/gdarruda/spark-demo/blob/main/python/fake_data.py) que gera predições aleatórias em um arquivo parquet. Para esse experimento, foram geradas 60.000.000 milhões de predições.

Antes de executar esse script, é necessário definir o tamanho da variável chamada `BATCH_SIZE`, que vai depender da memória disponível e quantidade de processos utilizados.

```python
NUM_CLASSES = 30
BATCH_SIZE = 2_000_000
NUM_CLIENTS = 60_000_000
PATH = '../resources/inline.parquet'
```

O batch de de 2.000.000 milhões de clientes, foi considerando que tenho 12 "virtual cores" e aproximadamente 16GB livres de memória. Fazendo alguns testes, foi possível chegar nesse valor, que otimiza a velocidade do processo para essa configuração.

Para não precisar configurar esse script por máquina, eu poderia ter feito uma solução *single-thread* que escreve um registro de cada vez no formato texto. Demoraria muito mais para rodar, mas não geraria pressão na memória e nem exigiria equilibrar o trabalho de equilibrar essas três variáveis (`NUM_CLASSES`, `BATCH_SIZE` e `NUM_CLIENTS`).

É interessante discutir isso, porque **engenharia de dados é muito mais sobre os requisitos não funcionais que funcionais.** Entre as duas opções de solução, o papel do engenheiro de dados é entender os requisitos não funcionais e a disponibilidade de poder computacional.

Por exemplo, se esse processo é executado no mesmo servidor que uma aplicação transacional online, usar uma solução *multi-thread* pode gerar indisponibilidades. Por outro lado, se estamos usando máquina dedicada em nuvem para esse processo, estamos perdendo tempo e dinheiro ao não estressar ao máximo a memória e o processamento com a solução *multi-thread*.

Com a base de exemplo gerada, podemos partir para o problema em questão: transformar essas 60.000.000 milhões de predições em mensagens JSON.

## Como não agrupar as predições

Para enviar essas predições em uma fila, o ideal é agrupar as predições para criar um `payload` que contenha múltiplas predições, usando menos mensagens para transmitir os mesmos dados.

As predições podem ser agrupadas arbitrariamente, mas precisam ter um tamanho máximo para não ultrapassar o tamanho máximo do `payload`, nesse caso iremos trabalhar com 10 predições por mensagens.

Para fazer isso, é simples: sabendo o total de linhas $$N$$ e a quantidade de mensagens por grupo $$K$$, precisamos criar $$G$$ grupos, sendo $$G=N/K$$. Para alocar as predições dentro desses grupos, para cada linha $$\#N$$, podemos obter o grupo da linha com o resto da divisão: $$\#N \ mod \ G$$.

Em um processo *single-thread*, é trivial associar um sequencial para as linhas e usar no cálculo do grupo: basta iterar linha a linha e incrementar um sequencial a cada iteração.

Mas nesse processo, vamos usar o Spark como framework de programação distribuída, emulando o cenário real em que esse dado estará armazenado em um storage e será processador por um cluster de máquinas.

No próprio [knowledge base da Databricks](https://kb.databricks.com/en_US/sql/gen-unique-increasing-values), é sugerido adicionar uma coluna sequencial e contígua, da seguinte forma:

```python
from pyspark.sql.functions import *
from pyspark.sql.window import *

df_with_increasing_id = df.withColumn("monotonically_increasing_id", monotonically_increasing_id())
window = Window.orderBy(col('monotonically_increasing_id'))
df_with_consecutive_increasing_id = df_with_increasing_id.withColumn('increasing_id', row_number().over(window))
```

Primeiramente, é gerado uma coluna com um identificador crescente e monotônico , mas não contíguo. Usando esse identificador único das linhas, usar uma função de janela para criar uma coluna contígua.

Solução elegante, mas ao executar esse código, o próprio Spark avisa que você pode estar gerando um problemão:

> WARN WindowExec: No Partition Defined for Window operation! Moving all data to a single partition, this can cause serious performance degradation.

A função de janela envolve ordenar todo o DataFrame, um processo muito custoso em execução distribuída, já que envolve transferir e processar todos os dados para uma única máquina.

Em uma execução local, seria um processo demorado, mas funcionaria porque todos os dados estão na mesma memória e sendo utilizadas por processos diferentes. Em produção, com esse dado distribuído em vários nós de computação, o processo ficaria muito mais lento e podemos incorrer em erros de falta de memória.

**Reproduzir um ambiente de execução distribuído é muito complexo, gerando erros que só aparecem tardiamente no processo de desenvolvimento.** 

O argumento de "funciona na minha máquina", tem menos valor ainda quando se fala de engenharia de dados.

## Agrupando com *zipWithIndex*

Uma alternativa menos onerosa, é utilizar a função [zipWithIndex](https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.RDD.zipWithIndex.html), que ordena os registros dentro de suas partições. O problema é que essa função é do objeto [RDD](https://spark.apache.org/docs/latest/rdd-programming-guide.html), uma abstração mais simples sobre a qual o DataFrame é construído.

Em outras palavras, significa que teremos que usar código procedural ao invés de apenas [Spark SQL](https://spark.apache.org/sql/). Enquanto usamos a API de alto nível, a linguagem utilizada não impacta na performance do processo, mas o cenário muda quando manipulamos diretamente o RDD.

O Python é a lingua franca do mundo dos dados, mas em cenários que demandam alto desempenho, ele trabalha como a "cola" e não como runtime principal. Ao utilizar PySpark, estamos usando Python para orquestrar o trabalho pesado feito na JVM em Scala.

Abaixo os códigos – em Python e Scala – para a mesma solução: incluir uma coluna sequencial a um DafaFrame.

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

Utilizando essas funções, podemos fazer uma comparação de performance entre as duas linguagens. A ideia é gerar um DataFrame com as predições agrupadas e serializadas em json, pronto para envio. 

Ao invés de enviarmos para uma fila, os dados serão salvos em um arquivo parquet. Exceto pela função `add_sequence_column`, a solução em Scala e Python são idênticas.

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

Ao avaliar a execução da solução Python, podemos perceber que são necessários mais jobs para executa a parte Python da aplicação.

<figure>
  <img src="{{site.url}}/assets/images/spark-demo/spark-history-python.png"/>
  <figcaption>Figura 1 – Spark History do processo em Python</figcaption>
</figure>

Não são jobs muito demorados, mas os demais jobs demoraram mais também. Talvez, o motivo seja o maior uso de swap, pois enquanto executava percebi que o processo em Python acabava gastando mais memória que o processo em Scala.

<figure>
  <img src="{{site.url}}/assets/images/spark-demo/spark-history-scala.png"/>
  <figcaption>Figura 2 – Spark History do processo em Scala</figcaption>
</figure>

No final, o processo em Python demorou um total de 12 minutos, enquanto o processo em Scala demorou 5 minutos.

Em um cenário com mais memória, a diferença entre as soluçÕes poderia ser menor. Ou maior, se o problema for a performance do código Python. **Estimar a performance em fluxo de dados é muito complexo, porque além de processamento, é necessário considerar outras variáveis como memória, armazenamento e rede**.

Ou seja, quando se trabalha com fluxos de dados, é muito difícil extrapolar conclusões sobre performance de código executado em ambientes diferentes. Em um cenário de menos memória, pode haver mais demanda de armazenamento. Por outro lado, se o processo estiver distribuído em muitas máquinas, operações de shuffle podem minar completamente o desempenho.

Por isso, é importante que **o engenheiro de dados tenha uma noção intuitiva dos gargalos, evitar soluções que possam ter problema em escalar horizontalmente**. Em teoria, qualquer engenheiro de software deveria ter essas preocupações, mas normalmente fica em segundo plano.

No contexto de empresas que precisam se mover com agilidade, é normal priorizar velocidade e manutenabilidade no desenvolvimento em detrimento a performance do do software. Melhor investir em máquina e otimizar depois, muito citam a famosa frase do Knuth[^1]: 

> premature optimization is the root of all evil.

[^1]: a citação completa tem muito mais nuances: *Programmers waste enormous amounts of time thinking about, or worrying about, the speed of noncritical parts of their programs, and these attempts at efficiency actually have a strong negative impact when debugging and maintenance are considered. We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%*. Ao usar esses argumentos, provavelmente os programadores não estão pensando nos mesmos problema do Knuth de micro-otimizações, mas o argumento é usado de forma simplista para justificar entregas mais rápidas.

Não discordo desse "zeitgest", mas pode ser uma armadilha em engenharia de dados. **Fluxos de processamento de dados costumam ter pouca lógica de negócio e sofrem menos modificações, mas muitos requisitos de performance e escalabilidade**. Vamos considerar esses dois cenários:

* Para implementar esse pipeline, vamos usar Scala ao invés de Python, para evitar gargalos decorrentes de misturar dois runtimes na mesma aplicação.

* Para fazer o backend de um MVP, vamos usar Rust ao invés de Python, para termos garantia de performance e validação estática.

Ao meu ver, o primeiro argumento em prol de performance é muito melhor, mas o mercado nos condicionou sempre a pensar no segundo cenário, em que agilidade é sempre prioridade.

## Pontos Chave

Eu nem cheguei na parte de efetivamente enviar essas mensagens em uma fila, mas acredito que já foi possível ilustrar os desafios de lidar com fluxo de dados distribuídos:

* Não é incomum encontrar problemas que só aparecem em produção, pelas características únicas do dado e volumetria;

* engenharia de dados é muito mais sobre os requisitos não funcionais que funcionais;

* reproduzir um ambiente de execução distribuído é muito complexo, gerando erros que só aparecem tardiamente no processo de desenvolvimento;

* estimar a performance em fluxo de dados é muito complexo, porque além de poder de processamento, dependem de outras variáveis como memória, disco e rede;

* fluxos de processamento de dados costumam ter pouca lógica de negócio e sofrem menos modificações, mas muitos requisitos de performance e escalabilidade

Nesse exemplo, nem chegamos a discutir os desafios de arquitetura da solução: por que estamos usando Spark? Se não precisamos de escalabilidade – estamos trabalhando com uma base de tamanho constante – provavelmente seria mais simples optar por fazer um processo não distribuído usando uma infra bem dimensionada.

Algumas vezes é cansativo lidar com esses problemas, mas são questões interessantes e acho gratificante ver uma aplicação escalando bem no hardware.

![Alt text]({{site.url}}/assets/images/spark-demo/htop.png)

<figure>
  <img src="{{site.url}}/assets/images/spark-demo/htop.png"/>
  <figcaption>Figura 3 – Htop durante a geração da massa de dados</figcaption>
</figure>