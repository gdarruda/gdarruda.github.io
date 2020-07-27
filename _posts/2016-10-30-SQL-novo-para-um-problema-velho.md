---
layout: post
title: "SQL novo para um problema velho"
comments: true
description: "Um jeito mais esperto de recuperar a última ocorrência de um histórico"
keywords: "SQL, Window Functions, Hive, HQL"
---

A necessidade de trabalhar com históricos é comum para diversos tipos de análise, mas usar históricos via SQL pode ser um tanto "chato" dependendo de como os dados estão estruturados e, mais importante, podem vir a ser consultas bastante pesadas (_e.g._ a visão dos dados de todos os clientes em uma data passada).

Usando [Window Functions](https://en.wikipedia.org/wiki/Select_(SQL)#Limiting_result_rows) do SQL, é possível resolver alguns problemas na hora de trabalhar com dados históricos, sem apelar desnecessariamente para joins e sub-queries.

### A tabela "tipo" histórica

Uma solução comum para guardar histórico de informações é replicar os dados do registro, alterado ou excluído da tabela original, em uma tabela histórica com alguma informação adicional que permite identificar o registro dentro do histórico (data, timestamp, sequencial, etc).

Para buscar dados de forma pontual, essa estrutura não representa um problema, com índices é simples buscar todas as alterações feitas nos dados cadastrais de um cliente por exemplo. Entretanto, quando falamos de buscar a última alteração de todos os clientes da base cadastral, as coisas podem complicar.

Essas tabelas "tipo" histórico, que contém um tracking das alterações na própria tabela, devem aparecer bastante em ambientes de Big Data devido à imutabilidade dos dados no Hadoop. No Hive não é possível atualizar linhas inseridas por exemplo, então acaba sendo necessário recorrer a esse tipo de solução para armazenar alterações de dados já inseridos.

### Lendo o histórico

Para exemplifcar o problema, vamos imaginar uma tabela de cadastro de pessoas com uma carga inicial completa e cargas incrementais diárias com informações de novos clientes e atualizações de clientes antigos. 

Naturalmente, o desafio desse cenário é criar uma visão atualizada dos dados sem ter a opção de atualizar registros já inseridos. Esse post da [HortonWorks](http://hortonworks.com/blog/four-step-strategy-incremental-updates-hive/) propõe uma solução para o problema da atualização de dados no Hive dividida em 4 etapas:

1. Os dados novos, de clientes incluídos e atualizados, são inseridos em uma tabela incremental (1).
2. **Uma view de conciliação é criada** (2).
3. Uma nova tabela é gerada com base na consulta do passo 2 (3).
4. A tabela final é apagada e re-criada com base na tabela do passo 3 e a tabela incremental apagada para a próxima carga diária (4).

Seguindo essa estratégia, imaginemos duas tabela de cliente, uma "final" e outra para ingestão incremental:

~~~sql
--Tabela final de clientes
CREATE TABLE cliente
(
 id_cliente INT,
 nome STRING,
 data_nascimento DATE,
 data_referencia DATE
);

--Tabela incremental de clientes
CREATE TABLE cliente_incremental
(
 id_cliente INT,
 nome STRING,
 data_nascimento DATE,
 data_referencia DATE
);
~~~

Na solução proposta, a tabela *cliente_incremental* receberia os novos dados no passo 1 e a *cliente* seria atualizada ao final na etapa 4. O "problema" é a view proposta no passo 2:

~~~sql
CREATE VIEW view_reconciliacao AS
SELECT t1.* 
FROM (SELECT * FROM cliente
      UNION ALL
      SELECT * FROM cliente_incremental) t1
JOIN (SELECT id_cliente, 
             max(data_referencia) AS max_data_referencia
      FROM (SELECT * FROM cliente
            UNION ALL
            SELECT * FROM cliente_incremental) t2
      GROUP BY id_cliente) s
ON  t1.id_cliente = s.id_cliente 
AND t1.data_referencia = s.max_data_referencia;
~~~

Usando o [Spark SQL](https://spark.apache.org/docs/2.0.0/sql-programming-guide.html) para acessar o Hive, essa consulta tem o seguinte plano de execução:

~~~
== Physical Plan ==
Project [id_cliente#63,nome#64,data_nascimento#65,data_referencia#66]
+- SortMergeJoin [id_cliente#63,data_referencia#66], [id_cliente#71,max_data_referencia#62]
   :- Sort [id_cliente#63 ASC,data_referencia#66 ASC], false, 0
   :  +- TungstenExchange hashpartitioning(id_cliente#63,data_referencia#66,200), None
   :     +- ConvertToUnsafe
   :        +- Union
   :           :- HiveTableScan [id_cliente#63,nome#64,data_nascimento#65,data_referencia#66], MetastoreRelation default, cliente, None
   :           +- HiveTableScan [id_cliente#67,nome#68,data_nascimento#69,data_referencia#70], MetastoreRelation default, cliente_incremental, None
   +- Sort [id_cliente#71 ASC,max_data_referencia#62 ASC], false, 0
      +- TungstenExchange hashpartitioning(id_cliente#71,max_data_referencia#62,200), None
         +- TungstenAggregate(key=[id_cliente#71], functions=[(max(data_referencia#74),mode=Final,isDistinct=false)], output=[id_cliente#71,max_data_referencia#62])
            +- TungstenExchange hashpartitioning(id_cliente#71,200), None
               +- TungstenAggregate(key=[id_cliente#71], functions=[(max(data_referencia#74),mode=Partial,isDistinct=false)], output=[id_cliente#71,max#81])
                  +- Union
                     :- HiveTableScan [id_cliente#71,data_referencia#74], MetastoreRelation default, cliente, None
                     +- HiveTableScan [id_cliente#75,data_referencia#78], MetastoreRelation default, cliente_incremental, None

~~~

Usando a função `rank()`, é possível definir uma query mais simples para obter os mesmos resultados da view de reconciliação. O ranking da função é gerado segundo um critério de ordenação e particionamento. Nesse caso, queremos ordenar os registros pela *data_referencia* de forma decrescente particionado por *id_cliente*. Ou seja, teremos um sequencial ordenado por data que é reiniciado para cada novo cliente.

Para exemplificar, vamos imaginar que a tabela *cliente* possui alguns registros incluídos e um registro atualizado para o cliente com `id_cliente = 3`.

| id_cliente | nome                         | data_nascimento | data_referencia |
|------------|------------------------------|-----------------|-----------------|
| 1          | Alan Turing                  | 1912-06-23      | 2016-01-05      |
| 2          | Donald Knuth                 | 1938-01-10      | 2016-03-05      |
| 3          | Edsger Dijkstra              | 1930-05-11      | 2016-03-12      |
| 3          | Edsger Dijkstra (atualizado) | 1930-05-11      | 2016-10-10      |

Tabela 1 - Tabela *clientes*

<br>

Na tabela *cliente_incremental*, temos uma atualização para o cliente com `id_cliente = 2`.

| id_cliente | nome                      | data_nascimento | data_referencia |
|------------|---------------------------|-----------------|-----------------|
| 2          | Donald Knuth (atualizado) | 1938-01-10      | 2016-10-29      |

Tabela 2 - Tabela *clientes_incremental*

<br>

Usando a função `rank()`,

~~~sql
SELECT t1.*, 
       rank() OVER (PARTITION BY id_cliente ORDER BY data_referencia DESC) ordem
FROM (SELECT * FROM cliente
      UNION ALL
      SELECT * FROM cliente_incremental) t1;
~~~

obtemos o resultado abaixo:

| id_cliente | nome                         | data_nascimento | data_referencia | ordem |
|------------|------------------------------|-----------------|-----------------|-------|
| 1          | Alan Turing                  | 1912-06-23      | 2016-01-05      | 1     |
| 2          | Donald Knuth (atualizado)    | 1938-01-10      | 2016-10-29      | 1     |
| 2          | Donald Knuth                 | 1938-01-10      | 2016-03-05      | 2     |
| 3          | Edsger Dijkstra (atualizado) | 1930-05-11      | 2016-10-10      | 1     |
| 3          | Edsger Dijkstra              | 1930-05-11      | 2016-03-12      | 2     |

Tabela 3 - Consulta com função `rank()`

<br>

Como desejamos apenas a informação mais recente, podemos filtar o resultado da query por `ordem = 1` para termos apenas um registro por cliente:

~~~sql
CREATE VIEW view_reconciliacao AS
SELECT id_cliente, nome, data_nascimento, data_referencia
FROM  (SELECT t1.*, 
             rank() OVER (PARTITION BY id_cliente ORDER BY data_referencia DESC) ordem
       FROM (SELECT * FROM cliente
             UNION ALL
             SELECT * FROM cliente_incremental) t1) t2
WHERE ordem = 1;
~~~

| id_cliente | nome                         | data_nascimento | data_referencia |
|------------|------------------------------|-----------------|-----------------|
| 1          | Alan Turing                  | 1912-06-23      | 2016-01-05      |
| 2          | Donald Knuth (atualizado)    | 1938-01-10      | 2016-10-29      |
| 3          | Edsger Dijkstra (atualizado) | 1930-05-11      | 2016-10-10      |

Tabela 4 - Resultados da view de reconciliação

<br>

O plano de execução com essa consulta é bem mais simples, precisando percorrer cada uma das tabelas apenas uma vez (ao invés de duas) e abrindo mão de um join.

~~~
== Physical Plan ==
Project [id_cliente#36,nome#37,data_nascimento#38,data_referencia#39]
+- Filter (ordem#26 = 1)
   +- Window [id_cliente#36,nome#37,data_nascimento#38,data_referencia#39], [HiveWindowFunction#org.apache.hadoop.hive.ql.udf.generic.GenericUDAFRank(data_referencia#39) windowspecdefinition(id_cliente#36,data_referencia#39 DESC,ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ordem#26], [id_cliente#36], [data_referencia#39 DESC]
      +- Sort [id_cliente#36 ASC,data_referencia#39 DESC], false, 0
         +- TungstenExchange hashpartitioning(id_cliente#36,200), None
            +- ConvertToUnsafe
               +- Union
                  :- HiveTableScan [id_cliente#36,nome#37,data_nascimento#38,data_referencia#39], MetastoreRelation default, cliente, None
                  +- HiveTableScan [id_cliente#40,nome#41,data_nascimento#42,data_referencia#43], MetastoreRelation default, cliente_incremental, None

~~~

Observe que fazer reconcialiação é uma das possibilidades da função `rank()`, mas poderíamos resolver problemas mais complexos. Por exemplo, poderíamos obter as 5 últimas alterações realizadas pelo cliente ordenado por data ou filtrar os dados até uma determinada data do passado.

### Conclusão

Quando falamos de big data é comum termos problemas com desempenho de consultas, qualquer otimização pode economizar muito tempo no trabalho ou no desempenho da aplicação. As window functions são bastante poderosas e bem suportadas, mas não vejo sendo muito utilizadas, a `rank()` é uma das mais simples mas [há várias delas](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+WindowingAndAnalytics) que podem quebrar um galho evitando joins e sub-queries de tabelas gigantes.

