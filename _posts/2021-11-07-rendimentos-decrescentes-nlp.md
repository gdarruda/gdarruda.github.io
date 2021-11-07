---
layout: post
title: "Rendimentos decrescentes em NLP"
comments: true
mathjax: true
description: "A solução de código"
keywords: "LSTM, NLP, Deep Learning"
---

Em Economia, a lei dos [rendimentos descrescentes](https://en.wikipedia.org/wiki/Diminishing_returns) fala sobre a relação entre trabalho e produção, que tende a piorar à medida em que se investe mais trabalho. De forma mais precisa, dado: $$ Entrada = E $$, $$ Saida = S $$ e $$ S = f(E) $$. A teoria diz que: $$ 2 \times f(E) > f(2 \times E) $$.

Talvez não por esse nome, mas essa dinâmica é muito familiar às pessoas que lidam com modelagem. Aumentar o desempenho de um modelo vai se tornando mais complicado à medida em que se avança, como podemos ver nas soluções desenvolvidas em [cenários competitivos](https://analyticsindiamag.com/how-useful-was-the-netflix-prize-really/).

Em outras palavras: melhorar os últimos 5% de um modelo é muito mais difícil que os primeiros 10%. No contexto de problemas reais, é muito importante ter em mente essa dinâmica, pois há um momento em que não faz mais sentido continuar evoluindo um modelo.

Nesse post, quero explorar um pouco essa dinâmica em problemas de NLP. Quando vale a pena, pular de uma solução mais simples baseada em *bag of words*, para algo mais sofisticado envolvendo *embeddings* e redes neurais? Aliás, realmente vale a pena fazer esse pulo?

A proposta não é muito inovadora: usando um [corpus do Skoob](/2019/07/27/corpus-skoob.html), a ideia é comparar abordagens em diferentes níveis de complexidade para desenvolvedor um classificador.

## Neural NLP 

A área de NLP passou por uma [revolução](https://jmlr.csail.mit.edu/papers/volume12/collobert11a/collobert11a.pdf) com o uso de *word embeddings* e redes neurais convolucionais/recorrentes. São conceitos relativamente independentes – e que já existiam há tempos – mas que algumas evoluções tornaram seu uso muito interessante para problemas de NLP.

Um dos exemplos de sucesso dessa nova abordagem, são os sistemas de tradução automática. Deixaram de ser sistemas complexos e altamente especializados, para se tornarem modelos de linguagem condicionais, chamados [Seq2seq](https://en.wikipedia.org/wiki/Seq2seq). 

Quando os avanços dependiam de recursos e sistemas sofisticados, com uso de corpus [anotados por linguistas](https://en.wikipedia.org/wiki/Treebank) e [ontologias](https://wordnet.princeton.edu/frequently-asked-questions), era muito díficil adaptar soluções de outros idiomas para língua portuguesa. Um modelo como Seq2seq por outro lado, é muito mais fácil de adaptar para outros idiomas e necessidades, a despeito de trazer outros problemas como a opacidade das redes neurais.

Nesse novo cenário, de modelos mais agnósticos, podemos seguir por dois caminhos ao lidar com um problema de NLP:

* Soluções baseadas em *[bag of words](https://en.wikipedia.org/wiki/Bag-of-words_model)*, que a despeito das claras limitações, são muito simples de implementar e acabam atendendo vários casos de uso.

* Soluções baseadas em redes neurais, que lidam com muito das limitações dos modelos *bag of words* e são mais próximas do estado da arte, mas demandam mais esforço de desenvolvimento e poder computacional.

Há um degrau claro de complexidade entre as as duas abordagens, mas é dificil estimar o custo/benefício de ultrapassá-lo. Pensando em  elucidar um pouco essa questão, experimentei resolver um mesmo problema usando as duas abordagens.

## O problema ~~manjado~~ de resenhas

Anos atrás, eu fiz [um Scrapy para extrair as resenhas do Skoob](https://github.com/gdarruda/scrap-skoob), que não usei para nada até esse experimento. Felizmente, o site não mudou nesse período, então foi possível re-extrair as resenhas com dados até Outubro de 2021.

Se tratando de um corpus de resenhas, o leitor já deve suspeitar do plano: fazer um classificador de notas, o clássico problema de análise de sentimentos[^1].

[^1]: não gosto do termo "análise de sentimentos", pois é um tanto abrangente e mal definido, mas é o termo que mais vejo sendo usado para descrever esses tipos de problema.

Ao escrever uma resenha, o usuário do Skoob tem a opção de atribuir estrelas ao livro. As estrelas variam no intervalo $$  [1,5] $$, mas optei por trabalhar apenas com o subconjunto $$ \{1, 3, 5\} $$ para testar os classificadores.

Optei por essa estratégia, porque essa gradação de notas subjetivas é uma questão difícil de se trabalhar, tanto que YouTube e Netflix migraram de um sistema de estrelas para um de notas binárias. Há muitas questões conceituais ao lidar com gradações: por exemplo, será que existe um critério comum entre as pessoas para distinguir um livro 4 e 5 estrelas? 

Inclusive, o plano original era usar somente os valores extremos $$ \{1,5\} $$, entretanto as classes ficariam muito desbalanceadas  e dificultaria a análise dos resultados. 

Filtrando o corpus pelo critério de seleção, o dataset final ficou com um total **828.118** resenhas: **23.893** com 1 estrela,  **174.836** com 3 estrelas e **629.389** com 5 estrelas.

## Comparando as estratégias

O dataset gerado é multi-classe e desbalanceado, aspectos que aumentam a complexidade na interpretação de resultados. Usarei acurácia simples como referência, mas no post colocarei a matriz de confusão para facilitar a análise pelo leitor.

Para realizar os experimentos, vou utilizar 90% do conjunto (**745.307**  amostras) para treino e os 10% restantes (**82.811** amostras) para validação. A estratégia será a mesma para todos os modelos.

Definido o problema de classificação, a ideia é comparar duas abordagens macro: uma baseada em redes neurais e *word-embeddings* e outra utilizando classificadores mais simples e representação *bag of words*. Não será uma comparação exaustiva, abordarei apenas as soluções mais imediatas dessas abordagens. 

Ou seja, a ideia é emular o que seria um trabalho exploratório, por onde normalmente se começa a resolver um problema de classificação de textos.

## Montando o baseline

Para começar um experimento de classificação em NLP, acredito que o caminho mais clássico possível é usar o Naive Bayes. É um classificador simples, que separa as classes baseada na diferença das distribuições de palavras que compõe cada uma delas.

Uma limitação desse classificador – que está em seu próprio nome – é a premissa "ingênua" de que as dimensões são independentes. Ou seja, que as ocorrências das palavras dentro de um texto são independentes entre si. Outra limitação, mas essa proveniente da representação *bag of words*, é desconsiderar a ordem das palavras.

A despeita dessas limitações, é um classificador [bem adaptado](https://www.cs.unb.ca/~hzhang/publications/FLAIRS04ZhangH.pdf) ao problema de classificação de texto. É simples de utilizar e demanda pouco processamento para treinamento e predições.

O modelo foi testado usando a configuração padrão do [`MultinomialNB`](https://scikit-learn.org/stable/modules/generated/sklearn.naive_bayes.MultinomialNB.html#sklearn.naive_bayes.MultinomialNB):

```python
clf = MultinomialNB()
```
Testei a possibilidade de ignorar a probabilidade *a priori* (`fit_prior = False`), mas impactou negativamente o desempenho geral do classificador.

Para fazer a transformação dos textos, usei o [`CountVectorizer`](https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html) do scikit-learn e uma lista de stopwords (proveniente do [NLTK](https://gist.github.com/alopes/5358189)) a serem ignoradas:

```python
vectorizer = CountVectorizer(stop_words=stopwords.words('portuguese'))
```

Além de remover stopwords, experimentei aplicar o [RSLP](https://www.nltk.org/_modules/nltk/stem/rslp.html), um algoritmo de *stemming* para língua portuguesa. É um pré-processamento custoso de ser executado e acabou tendo pouco impacto nos resultados do classificador.

Infelizmente, não consegui testar o modelo com [n-gram](https://en.wikipedia.org/wiki/N-gram) maior que 2, devido a falta de memória no computador. De qualquer forma, os melhores resultados foram obtidos sem o uso de n-grams no Naive Bayes.

Abaixo, os resultados obtidos por esse modelo:

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/MultinomialNB.svg"/>
  <figcaption>Figura 1 – Resultados Naive Bayes </figcaption>
</figure>


## Subindo o baseline com SVM e TF-IDF

Um outro classificador, bastante utilizado em problemas de NLP, é o [SVM linear](https://link.springer.com/chapter/10.1007%2FBFb0026683). 

Textos representados como vetores *bag of words* são esparsos e possuem alta dimensão, o que aumenta a chance de serem linearmente separáveis. Por outro lado, pode ser complexo ajustar um modelo com vetores tão esparsos.

O treinamento do SVM – que é feito via a otimização distância entre as amostras de diferentes classes – acaba sendo uma boa opção para esse tipo de problema.

No SVM, é possível variar alguns hiperparâmetros, como a formulação da otimização e penalização das margens, mas em testes rápidos vi poucas diferenças. Assim como o classificador *Naive Bayes*, optei por usar o SVM com os hiperparâmetros padrão do [LinearSVC](https://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html):

```python
clf = LinearSVC()
```

Uma possibilidade interessante do SVM, é utilizá-lo com a representação [tf-idf](https://en.wikipedia.org/wiki/Tf–idf), para destacar as palavras mais importantes do corpus, ao invés de simplesmente fazer a contagem das palavras. É uma representação muito usada em problemas de [information retrieval](https://en.wikipedia.org/wiki/Information_retrieval), mas que também pode ser útil em classificação.

Além de usar td-idf para construir os vetores *bag-of-words*, o uso de 2-grams ajudou a obter melhores resultados no SVM:

```python
vectorizer = TfidfVectorizer(ngram_range=(1,2))
```
Com essa configuração, já é possível obter ganhos significativos de desempenho em relação ao Naive Bayes, especialmente nas classes negativa e neutra:

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/LinearSVC.svg"/>
  <figcaption>Figura 2 – Resultados SVM </figcaption>
</figure>

Com esse baseline aprimorado, podemos partir para a solução baseada em redes neurais e *word embeddings*.

## Usando LSTM e word-embeddings

Ao trabalhar com soluções mais complexas, a primeira dificuldade são as muitas decisões a serem tomadas: arquitetura/tamanho da rede, hiperparâmetros, embeddings treináveis ou não, algoritmo de treinamento, etc...

Devido a essa complexidade, acredito que muitos possam discordar que minha proposta é a solução baseline ideal. Entrentanto, esse aspecto já faz parte da questão em pauta: como um leigo em redes neurais para NLP começaria? Bons resultados demandam demandam mais habilidade/tempo para serem alcançados?

Deixando essa discussão para o final, vamos à solução testada.

### Arquitetura da rede

A rede neural utilizado foi uma LSTM bi-direcional, talvez a arquitetura mais popular de RNN para textos. Há soluções que usam somente a saída final para classificação, mas até mesmo por serem textos longos, acho melhor trabalhar com a saída de cada "etapa" da LSTM:

```python
emb = tf.keras.layers.Embedding(mask_zero=True, 
                                input_dim=len(encoder.get_vocabulary()),
                                output_dim=EMBEDDING_DIM, 
                                trainable=True)

model = tf.keras.Sequential([
    encoder,
    emb,
    tf.keras.layers.Bidirectional(tf.keras.layers.LSTM(300, return_sequences=True, stateful=False)),
    tf.keras.layers.Dense(SEQUENCE_LENGTH, activation='relu'),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dropout(.6),
    tf.keras.layers.Dense(3, activation='softmax')
])

emb.set_weights([embedding_matrix])
```

O tamanho da rede ficou limitada pela memória da minha GPU, que possui apenas 4GB de memória. A versão final da arquitetura ficou dessa forma:

* Camada de embeddings com 300 dimensões.
* LSTM com 300 neurônios.
* Camada densa com 1.000 neurônios.
* Camada de dropout com .6 de probabilidade.
* Batch de 16 amostras.

Abaixo, o `summary` do modelo:

```
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
text_vectorization (TextVect (None, 1000)              0         
_________________________________________________________________
embedding (Embedding)        (None, 1000, 300)         15467100  
_________________________________________________________________
bidirectional (Bidirectional (None, 1000, 600)         1442400   
_________________________________________________________________
dense (Dense)                (None, 1000, 1000)        601000    
_________________________________________________________________
flatten (Flatten)            (None, 1000000)           0         
_________________________________________________________________
dropout (Dropout)            (None, 1000000)           0         
_________________________________________________________________
dense_1 (Dense)              (None, 3)                 3000003   
=================================================================
Total params: 20,510,503
Trainable params: 20,510,503
Non-trainable params: 0
_________________________________________________________________
```

### Embeddings pré-treinados

Uma das possibilidades mais interessantes das redes neurais, é usar *word embeddings* pré-treinados. Para português, o grupo [NILC](http://www.nilc.icmc.usp.br/embeddings) tem um repositório com embeddings gerados por diferentes métodos: Word2Vec, FastText , Wang2Vec e Glove. Para esse experimento, testei o Wang2Vec e Glove. 

Na [avaliação do grupo](https://arxiv.org/pdf/1708.06025.pdf), o Glove apresentou melhor desempenho na avaliação intrínseca por analogias e o Wang2Vec na avaliação extrínseca (POS-tagging e similaridade de sentenças). A diferença entre os métodos é mínima, como esperado, mas o Wang2Vec acabou se saindo ligeiramente melhor nesse experimento.

Para integrar esse embeddings no modelo, é relativamente simples. Usando o gensim é fácil fazer a leitura dos vetores, indexado por palavra:

```python
from gensim.models import KeyedVectors

EMBEDDING_DIM = 300
USE_EMBEDDING = True
EMBEDDING_TYPE = 'skip'

base_dir = 'sa-experiments/corpus'

if USE_EMBEDDING:
    embeddings_index = KeyedVectors.load_word2vec_format(f'{base_dir}/embeddings/{EMBEDDING_TYPE}_s{EMBEDDING_DIM}.txt')
```

Após fazer a leitura dos embeddings, é necessário criar uma matriz do vocabulário que será utilizada pela rede neural:

```python
if USE_EMBEDDING:
    voc = encoder.get_vocabulary()
    word_index = dict(zip(voc, range(len(voc))))

    num_tokens = len(voc)
    embedding_matrix = np.zeros((num_tokens, EMBEDDING_DIM))

    hits = 0
    misses = 0

    for word, i in word_index.items():
        
        if embeddings_index.has_index_for(word):
            embedding_matrix[i] = embeddings_index[word]
            hits+=1
        else:
            misses+=1

    print(f"Hits: {hits}")
    print(f"Misses: {misses}")
```

Uma limitação importante de destacar é o tamanho do vocabulário, já que não foi possível treinar a rede com ele completo. Foram usadas "apenas" as 200.000 palavras mais comuns no corpus, sendo um total de 136.725 presentes nos embeddings pré-treinados. 

O dataset completo tem mais de 600.000 palavras no vocabulário, é interessante fazer uma investigação posterior, do impacto dessa restrição técnica no desempenho do classificador.

### Pré-processamento do texto

Assim como nos métodos *bag-of-words*, não apliquei nenhum pré-processamento sofisticado para a rede neural.

Uma questão adicional para usar a LSTM, é a necessidade de definir o tamanho da sequência [^2]. Poderia usar o tamanho máximo de amostra no corpus como limite superior, mas seria um problema, já que há resenhas enormes.

[^2]: há opção de fazer uma LSTM stateful, mas implicaria em outra arquitetura de rede sem a camada densa.

Pelo histograma, é possível perceber que a maioria está na ordem de centenas de palavras, mas há resenhas muito maiores:

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/contagem_palavras.svg"/>
  <figcaption>Figura 3 – Histograma do tamanho das resenhas </figcaption>
</figure>

Por esses números, optei por deixar um limite de 1.000 palavras, já que 99% das resenhas têm 1.000 ou menos palavras. Com esse limite, poucas resenhas serão cortadas, devendo impactar pouco no desempenho do modelo.

### Treinamento

O treinamento da rede neural foi feita usando Adam e entropia cruzada como função de perda:

```python
model.compile(loss=tf.keras.losses.CategoricalCrossentropy(),
              optimizer=tf.keras.optimizers.Adam(1e-4),
              metrics=[tf.keras.metrics.CategoricalAccuracy()])
```

A rede acaba convergindo bem rápido, até por ser um dataset bastante grande. Abaixo, os resultados da execução de 5 épocas:

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/training.svg"/>
  <figcaption>Figura 4 – Resultados treinamento </figcaption>
</figure>

Cada época demorou cerca de 2:20 horas para rodar, usando a seguinte configuração:

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/neofetch.png"/>
  <figcaption>Figura 5 – Configuração </figcaption>
</figure>

### Resultados

Usando essa solução de rede neural, foi obtido um resultado similar de acurácia geral: 0,86 para o SVM e 0,87 para a LSTM.

<figure>
  <img src="{{site.url}}/assets/images/ml-skoob/LSTM.svg"/>
  <figcaption>Figura 6 – Resultados LSTM </figcaption>
</figure>

O SVM teve melhor desempenho na classe negativa, com 0,81 de acurácia contra 0,78 da LSTM. Por outro lado, a LSTM teve 0,77 de acurácia para a classe neutra enquanto o SVM chegou em 0,72 apenas.

Olhando esses números, podemos dizer que os resultados são parecidos nas duas soluções. 

## Conclusão

Não há muito o que ponderar sobre a relação custo/benefício para esse problema, a solução *bag-of-words* é muito mais simples e chegou a resultados comparáveis.

A "complexidade" da solução é subjetiva em alguns pontos, já que envolve várias dimensões. Alguém mais experiente em redes neurais poderia ter desenvolvido essa solução em um fração do tempo que demorei. Entretanto, os limites de hardware e o tempo de treinamento são dificuldades inerentes das redes neurais.

Há muito que explorar na solução de redes neurais, incluindo aspectos óbvios como aumentar a rede e usar o vocabulário completo. Lembrando também que essa solução não é o estado da arte, longe disso, pretendo testar outras possibilidades como o uso de subword embeddings por exemplo.

Talvez os resultados melhorem bastante com um maior investimento de tempo e mais conhecimento, mas no limite do meu hardware e competência atual, não consegui extrair um resultado muito melhor usando redes neurais e *word embdeddings*.

No final, há mais questões em aberto que respondidas com esse experimento simples, mas a ideia era justamente ver a diferença entre as propostas em um estágio inicial do processo de modelagem.

Os códigos utilizados para esse experimento [estão no GitHub](https://github.com/gdarruda/skoob-experimentos), incluindo os embeddings pré-treinados e o dataset utilizado. Qualquer dúvida sobre como executar esse código, ou sugestão de novos experimentos, fico a diposição :)