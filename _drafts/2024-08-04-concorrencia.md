---
layout: post
title: "Processos, threads e co-rotinas em Python"
comments: true
mathjax: true
description: "Discutindo as opções para programação paralela e concorrente em Python"
keywords: "python, concorrência, paralelismo"
---

Para explicar o que é um algoritmo, é normal descrever informalmente como uma sequência de passos para resolver um determinado problema. Para lidar com concorrência e paralelismo, ainda temos passos a serem seguidos, mas eles não estão mais em ordem.

Há várias camadas de abstração – para que o desenvolvedor posso pensar em seus algoritmos como sequência de passos – mas na prática muita coisa é executada fora de ordem. Nem mesmo o processador mantém as instruções em ordem, execução [out of order](https://en.wikipedia.org/wiki/Out-of-order_execution) é implementado em todas arquiteturas modernas para evitar desperdício de ciclos.

Essas abstrações funcionam muito bem em certos cenários, como é o caso de servidores web e sistemas de banco de dados por exemplo. Por outro lado, problemas como o [consumidor Kafka](({{site.url}}/2024/05/05/kafka-leitura.html)), exigem uma aplicação que considere questões de paralelismo e concorrência.

Não é fácil lidar com esses conceitos, é uma mudança fundamental no modelo mental do programador, não surpreende que seja um tópico intimidador para muita gente. Minha ideia é escrever (mais) um post para tentar explicar de forma didática, como trabalhar com concorrência e paralelismo em Python.

## Conceitos

O que complica (ainda mais) lidar de problemas de concorrência e paralelismo, é a abundância de conceitos e detalhes de implementação de cada linguagem. Por isso, é bom alinhar alguns conceitos mínimos, antes de entrar na implementação.

A ideia é realmente definir o mínimo, não se preocupe se a explicação resumida não fizer sentido, não acho que seja impeditivo para o entendimento das implementações.

# Processos

No contexto de sistemas operacionais, um [processo](https://en.wikipedia.org/wiki/Process_(computing)) é uma instância do programa sendo executado. Pontos importante sobre processos:  

* os processos têm memória isolada, o que está na memória de um processo não pode ser lido por outro;
* o sistema operacional é responsável por escalonar os processos, alternando a execução para que todos tenham algum tempo de execução de acordo com a prioridade;
* um processo em execução pode ser interrompido por I/O, entrando em espera quando precisa interagir com algo externo (e.g. rede, armazenamento);
* existe um custo para alternar entre diferentes processos no processador, como limpar os registradores e mudar de pilha.

# Threads (kernel threads)

Um processo pode conter uma ou múltiplas threads, são conceitos parecidos, mas com diferenças importantes:

* threads de um mesmo processo podem compartilhar recursos entre si, como conexões de rede e dados na memória;
* o custo de alternar entre threads do mesmo processo é mais baixo que alternar entre diferentes processos;
* dependendo do sistema operacional, o custo de criar e destruir threads é muito mais baixo que processos.

# Co-rotinas e tarefas

Os processos e threads são conceitos a nível do sistema operacional, mas é comum as linguagens implementaram uma versão mais enxuta no próprio runtime. O Python tem as [co-rotinas e tarefas](https://docs.python.org/3/library/asyncio-task.html), são mais leves para criar/destruir que threads e executadas de [forma cooperativa](https://en.wikipedia.org/wiki/Cooperative_multitasking) ao invés de preemptiva.

As implementações de tarefas diferem entre linguagens, as ideias e estratégias discutidas nesse post não necessariamente se aplicam a outras linguagens e runtimes.

# GIL (Global Interpreter Lock)

A [implementação padrão](https://en.wikipedia.org/wiki/CPython) do Python usa o GIL (Global Interpreter Lock), que não permite a execução paralela de threads de um mesmo processo. A presença do GIL simplifica o desenvolvimento da linguagem, mas impede o paralelismo de processamento a nível de thread.

A proposta de deixar [GIL opcional](https://peps.python.org/pep-0703/) foi aceita, será possível desabilita no Python 3.13. É necessário esperar para ver como será a migração do ecossistema, mas imagino que será necessário lidar com as limitações de paralelismo do GIL por muito tempo ainda.

## Paralelismo de dados

Raramente é simples transformar um problema sequencial em paralelizável, muitas vezes é simplesmente impossível. Uma estratégia alternativa é aplicar o paralelismo de dados, que consiste em dividir a entrada e combinar os resultados posteriormente.

Um candidato ideal para essa estratégia, é o script que utilizei em [outro post]({{site.url}}/2023/03/04/engenharia-dados.html) para gerar uma massa de dados aleatória, simulando a saída de um modelo de machine learning. Abaixo, a função que gera uma base de amostra:

```python
def generate(self, num_rows: int) -> pd.DataFrame:

    df = pd.DataFrame(
        {
            **{"id_client": [str(uuid.uuid4()) for _ in range(num_rows)]},
            **{f"class_{c}": np.random.uniform(size=num_rows)
               for c in range(self.num_classes)}
        }
    )

    df.to_parquet(f"{self.path}/{num_rows}-{uuid.uuid4()}.parquet")
```

A estratégia mais simples para paralelizar esse processo, é executar essa função múltiplas vezes de forma independente: podemos executar a função para gerar $$ n $$ amostras ou executar $$ k $$ vezes gerando $$ n/k $$ amostras por execução, é o mesmo resultado em termos de funcionalidade.

Um dos jeito mais simples de aplicar paralelismo de dados, é utilizando a ideia de [piscina de threads](https://en.wikipedia.org/wiki/Thread_pool). A "piscina" é um conjunto fixo de threads que ficam disponíveis para uso, as tarefas são enfileiradas e entram em processamento quando uma thread fica disponível. Abaixo, uma ilustração dessa estratégia:

<figure>
  <img src="{{ site.url }}/assets/images/paralelismo/pool.gif"/>
  <figcaption>Figura 1 – Ilustração de um Thread Pool</figcaption>
</figure>

Para implementá-la, é necessário separar o problemas em pedaços menores, o que é trivial nesse caso. É necessário dividir o total de linhas pelo tamanho desejado para cada batch:

```python
def _build_batches(self, num_rows) -> Iterable[int]:

    for _ in range(num_rows//self.batch_size):
        yield self.batch_size
    
    remainder = num_rows % self.batch_size

    if remainder > 0:
        yield remainder
```

O tamanho do batch não é muito importante, exceto pelo consumo de memória. Cada chamada da função gera um DataFrame com o tamanho do batch, é necessário ter memória suficiente para que todas as threads possam criar esse DataFrame simultaneamente.

Com os batches criados – usando função a função de alta ordem `map` de um `ThreadPool` – a função `generate` será chamada para cada item de `batches`:

```python
def generate_parallel(self,
                      num_rows: int) -> pd.DataFrame:

    batches = self._build_batches(num_rows)

    with ThreadPool(os.cpu_count()) as p:
        p.map(self.generate, batches)
```

Essa implementação está tecnicamente correta, mas não faz sentido devido a presença do GIL. No final, `generate_parallel` é mais lenta que `generate`, ja que as threads não podem ser executadas paralelamente e ainda é necessário coordená-las:

```python
NUM_ROWS = 1_000_000
BATCH_SIZE = 5_000
NUM_CLASSES = 10

generator = SampleGenerator(BATCH_SIZE, NUM_CLASSES, "samples")
%timeit generator.generate_parallel(NUM_ROWS)
%timeit generator.generate(NUM_ROWS)

# 4.8 s ± 51.6 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
# 3.73 s ± 16.9 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
```
A solução para esse caso, é simplesmente trocar o tipo de pool, usando processos ao invés de threads. O processo fica idêntico, bastando alterar o contexto utilizado:

```python
def generate_parallel(self,
                      num_rows: int) -> pd.DataFrame:

    batches = self._build_batches(num_rows)

    with Pool(os.cpu_count()) as p:
        p.map(self.generate, batches)
```

Usando um processo de 6 núcleos, criar a mesma quantidade de amostras é ~ 4,29 vezes mais rápido, gerando o aumento de desempenho esperado:

```python
NUM_ROWS = 1_000_000
BATCH_SIZE = 5_000
NUM_CLASSES = 10

generator = SampleGenerator(BATCH_SIZE, NUM_CLASSES, "samples")
%timeit generator.generate_parallel(NUM_ROWS)
%timeit generator.generate(NUM_ROWS)

# 873 ms ± 2.23 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
# 3.75 s ± 25.6 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
```

Algumas perguntas surgem com esses resultados. Se é tão simples, usar processos ao invés de threads, por que usar threads? Para que serve as threads, se existe o GIL?

O problema proposto tem características que o tornam ideal para o uso em múltiplos processos. Ele pode ser separado e combinado a custo zero, a função recebe apenas um inteiro de entrada e não precisa se comunicar com os demais processos. Além disso, é um processo que demanda muito processamento e pouca movimentação dados, o que é o pior caso do GIL.

## O cenário "I/O bound"

Muitos problemas do dia-a-dia não são limitados por tempo de processamento, mas por movimentação de dados: escrita em banco de dados, comunicação por rede, escrita em storage, postagem em filas, etc. São nesses cenários, que o uso de threads e co-rotinas fazem sentido, mesmo com a existência do GIL.

Para ilustrar esse cenário, o problema agora é salvar essas amostras em uma tabela no PostgreSQL. Para ter como baseline, a implementação mais simples possível para esse cenário, usando as classes `DatabaseNaive` e `LoaderNaive`:

```python
class DatabaseNaive(Database):

    def __init__(self,
                 connection_url: str,
                 num_classes: int) -> None:

        super().__init__(connection_url, num_classes)
        self.conn = psycopg.connect(connection_url)

    def _make_slices(self, df: pd.DataFrame):

        num_rows = df.shape[0]
        num_batches = num_rows//self.batch_size
        remainder = num_rows % self.batch_size

        for i in range(num_batches):
            yield df.iloc[i*self.batch_size:(i+1)*self.batch_size]

        if remainder > 0:
            yield df[self.batch_size*num_batches:num_rows]

    def save_message(self, prediction: dict):

        with self.conn.cursor() as cur:
            cur.execute(*self._build_insert(prediction))

        self.conn.commit()

class LoaderNaive():

    def __init__(self, db: DatabaseNaive) -> None:
        self.db = db

    def load(self, df: pd.DataFrame):

        for _, row in df.iterrows():
            self.db.save_message(row.to_dict())
```

A solução acima salva um registro de cada vez, esperando a escrita no banco de dados, antes de passar para o próximo. Para 100.000 registros, esse processo demora aproximadamente **6 minutos**:

```python
%%timeit

NUM_CLASSES = 10

db = DatabaseNaive(CONNECTION_URL, NUM_CLASSES)
db.create_table()

loader = LoaderNaive(db)
loader.load(predictions)

db.close()

# 5min 54s ± 6.42 s per loop (mean ± std. dev. of 7 runs, 1 loop each)
```

# Threads sendo úteis 

A estratégia de threads funciona nesse cenário, porque escrever em banco de dados depende muito de I/O, diferente de gerar amostras que é um processo que demanda muito processamento.

Uma das dificuldades em se trabalhar com threads, é garantir que os objetos compartilhados tenham [thread safety](https://en.wikipedia.org/wiki/Thread_safety). Nesse caso, a preocupação é com a conexão de banco de dados, que precisa ser compartilhada entre as threads.

O conector de PostgreSQL para Python tem a opção de criar o `ConnectionPool`, que cria uma piscina de conexões que podem ser alocadas. Dessa forma, cada thread pode alocar uma conexão e evitar possíveis problemas de concorrência (*e.g.* condição de corrida, corrupção de dados).

Para abstrair esse tipo de conexão, foi criada uma classe `DatabasePool`:

```python
class DatabasePool(Database):

    def __init__(self,
                 connection_url: str,
                 num_classes: int,
                 num_threads: int) -> None:

        self.connection_url = connection_url
        self.num_classes = num_classes

        self.pool = ConnectionPool(connection_url,
                                   min_size=num_threads)

    def create_table(self):
        with self.pool.connection() as conn:
            self._create_table(conn)

    def save_message(self, prediction: dict):

        with self.pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(*self._build_insert(prediction))
                conn.commit()
```

Usando a mesma solução da implementação anterior, é possível fazer a carga no banco de dados com múltiplas threads, implementada na classe `LoaderMultiThread`:

```python
class LoaderMultiThread(LoaderNaive):

    def __init__(self,
                 batch_size: int,
                 db: DatabasePool,
                 num_threads: int) -> None:

        self.db = db
        self.batch_size = batch_size
        self.num_threads = num_threads

    def load_parallel(self, df: pd.DataFrame):

        dfs = self._make_slices(df)

        with ThreadPool(self.num_threads) as p:
            p.map(self.load, dfs)
```

Diferente de gerar amostras, nesse cenário existe um ganho relevante de desempenho, com o processo sendo executado em cerca de 1 minuto e 30 segundos.

```python
%%timeit

NUM_THREADS = 48
BATCH_SIZE = 1_000

db = DatabasePool(CONNECTION_URL, NUM_CLASSES, NUM_THREADS)
db.create_table()

loader = LoaderMultiThread(BATCH_SIZE, db, NUM_THREADS)
loader.load_parallel(predictions)

db.close()

# 1min 32s ± 14.4 s per loop (mean ± std. dev. of 7 runs, 1 loop each)
```

O ganho desse desempenho não veio do aumento de paralelismo, mas da concorrência: quando a thread precisa aguardar o retorno do banco de dados e fica bloqueado, o sistema operacional alterna para executar outra.

Por que usei 48 threads?  É difícil calcular porque tem muitas variáveis: performance do banco de dados, latência de rede, operações concorrentes, etc. A estratégia foi experimentar diversos valores, mas esse valor só vale para esse contexto específico.

Apesar de efetivo usar threads, essa estratégia faz mais sentido quando não é possível usar co-rotinas e tarefas. Usar interrupções para escalonar as threads talvez não seja o cenário ideal, além de envolver decisões complicadas como o número de threads.

# Co-rotinas: mais simples e rápido

A programação assíncrona com `asyncio` tem vários conceitos como tarefas, corotinas, etc – eu mesmo tenho uma compreensão superficial – então recomendo a [documentação](https://docs.python.org/3/library/asyncio-task.html#coroutine) e [outros materiais](https://realpython.com/python-async-features/), caso o leitor queira entender melhor o que está sendo feito.

Para esse cenário, tentei manter a interface de uso o mais parecido possível com a versão síncrona, mas usando a implementação assíncrona do `psycopg`:

```python
class DatabaseAsync(Database):

    def __init__(self,
                 connection_url: str,
                 num_classes: int) -> None:

        self.connection_url = connection_url
        self.num_classes = num_classes

    def create_table(self):
        conn = psycopg.connect(self.connection_url)
        self._create_table(conn)
        conn.close()

    async def get_conn(self):
        return await psycopg.AsyncConnection.connect(self.connection_url)

    async def save_message(self, conn, prediction: dict):
        async with conn.cursor() as cur:
            await cur.execute(*self._build_insert(prediction))

        await conn.commit()

    async def close(self):
        await self.get_conn().close()
```

O `LoaderAsync` é muito parecido com o `LoaderNaive`, não existe mais o conceito de batches e piscinas. Ao invés de trabalhar com um número fixo e baixo de threads, é criada uma tarefa para inserir cada amostra. As tarefas são baratas de criar e construir, então não é necessários criá-las previamente e reaproveitá-las como no no caso das threads.

```python
class LoaderAsync(LoaderNaive):

    def __init__(self,
                 db: DatabaseAsync) -> None:
        self.db = db

    async def load_async(self, df: pd.DataFrame):

        conn = await self.db.get_conn()

        async with conn:
            async with asyncio.TaskGroup() as tg:
                for _, row in df.iterrows():
                    tg.create_task(self.db.save_message(conn, row.to_dict()))
```

O `TaskGroup` oferece uma abstração similar ao `ThreadPool`, inicializando as tarefas e esperando o término de todas que foram criadas sob o contexto. Em termos de performance, foi ainda mais rápido que a solução multi-thread, com execução em cerca de 25 segundos:

```python
db = DatabaseAsync(CONNECTION_URL, NUM_CLASSES)
db.create_table()

loader = LoaderAsync(db)
await loader.load_async(predictions)
```
A solução continua sujeita ao GIL, os ganhos devem ser provenientes do escalonamento colaborativo ser mais efetivo para o problema. Entretanto, é bom ressaltar que boa parte do ecossistema Python não suporta `asyncio`, então nem sempre é possível optar por essa solução.

Ainda assim, estamos utilizando apenas um núcleo do processador. Usando vários processos temos uma execução assíncrona menos eficiente, mas podemos utilizar mais proveito do hardware disponível.

# Processos no lugar de Threads

No primeiro exemplo, substituir processos por threads foi uma questão de trocar o contexto de `ThreadPool` para `Pool`. Nesse caso, a mudanças gera um erro pouco claro:

```python
db = DatabaseNaive(CONNECTION_URL, NUM_CLASSES)
loader = LoaderMultiProcess(BATCH_SIZE, NUM_THREADS, db)
loader.load_parallel(predictions)

db.close()

# TypeError: no default __reduce__ due to non-trivial __cinit__
```

É comum ter esses erros estranhos ao trabalhar com múltiplos processos, normalmente é um problema de serialização de objetos. Lembre-se que os processos têm memória isolada, para compartilhar objetos entre eles, pode ser necessário traduzir em um formato binário de transporte.

O problema é que muitos objetos não podem ser transportados, uma conexão de banco de dados tem conexões de rede abertas que não podem ser migradas entre processos.

Para lidar com isso, existe um "truque" que é atrasar a criação do objeto complexo. A diferença da classe `DatabaseLazy` para `DatabaseNaive`, é que o construtor da `DatabaseLazy` não cria a conexão no construtor:

```python
class DatabaseLazy(Database):

    def __init__(self,
                 connection_url: str,
                 num_classes: int) -> None:

        super().__init__(connection_url, num_classes)
        self.conn = None

    def _get_conn(self):

        if self.conn is None:
            self.conn = psycopg.connect(self.connection_url)

        return self.conn

    def create_table(self):
        self._create_table(self._get_conn())

    def save_message(self, prediction: dict):

        conn = self._get_conn()

        with self.conn.cursor() as cur:
            cur.execute(*self._build_insert(prediction))

        conn.commit()

    def close(self):
        self._get_conn().close()
```

A conexão é criada na primeira chamada de `_get_conn`, apenas quando o método `save_message` é chamado pela primeira vez. A cópia do objeto `DatabaseLazy` é feita enquanto ele não tem nenhuma conexão aberta, na abertura do contexto do `Pool`:

```python
class LoaderMultiProcess(LoaderNaive):

    def __init__(self,
                 batch_size: int,
                 num_threads: int,
                 db: DatabaseLazy) -> None:

        self.db = db
        self.batch_size = batch_size
        self.num_threads = num_threads

    def load_parallel(self, df: pd.DataFrame):

        dfs = self._make_slices(df)

        with Pool(self.num_threads) as p:
            p.map(self.load, dfs)
```

Usando `DatabaseLazy`, finalmente chegamos ao melhor tempo de execução, ficando abaixo de 10 segundos em média:

```python
%%timeit
import os

db_temp = DatabaseNaive(CONNECTION_URL, NUM_CLASSES)
db_temp.create_table()
db_temp.close()

db = DatabaseLazy(CONNECTION_URL, NUM_CLASSES)
loader = LoaderMultiProcess(BATCH_SIZE, NUM_THREADS*(os.cpu_count()//2), db)
loader.load_parallel(predictions)

db.close()

# 8.61 s ± 13.9 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
```

O ideal seriam as co-rotinas serem alocadas em múltiplos processadores, sem a necessidade de criar processos separados. Seria uma solução mais simples e rápida, mas contornar o GIL dessa forma pode ser interessante em um ambiente que tenha muitos núcleos de processador disponíveis.

## Alternativas e futuro

A maioria das linguagens foi desenvolvida sem pensar em concorrência e execução assíncrona, o que acaba em soluções sub-ótimas para o problema. A presença do GIL no Python, adiciona mais camadas de complexidade para uma questão que já inerentemente difícil.

A ideia de trabalhar com múltiplos processos é muito parecido com computação distribuída, o que faz o [PySpark](https://spark.apache.org/docs/latest/api/python/index.html) parecer uma alternativa interessante. Uso bastante e gosto quando a solução pode ser escrita em  [Spark SQL](https://spark.apache.org/sql/), mas é muito ineficiente integrar código procedural Python ao runtime em JVM.

O [Dask](https://www.dask.org) parece ser a melhor alternativa se a ideia é fazer código nativo. Não tenho experiência com o framework, mas por melhor que seja, é uma abstração complexa para contornar algo que a maioria das linguagens suporta nativamente.

Dado esse cenário, fico ansioso para acompanhar como será a adoção do ecossistema para execução sem o GIL. Existem muitas iniciativas([1](https://pypy.org), [2](https://github.com/facebookincubator/cinder) e [3](https://devblogs.microsoft.com/python/python-311-faster-cpython-team/)), mas o GIL depende de uma adoção pelos usuários, frameworks e bibliotecas para vingar.