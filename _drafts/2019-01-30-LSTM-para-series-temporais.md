---
layout: post
title: "LSTM para séries temporais"
comments: true
description: "Rede neural para análise de sentimentos em português."
keywords: "Deep Learning, Convoluções, NLP, Análise de Sentimentos"
---

{% include lib/mathjax.html %}

Problemas que envolvem predições de séries temporais são comuns em várias áreas de negócios (*e.g.* previsão de demanda, acompanhamento de preços, evolução de carteira) e, geralmente, não exigem trabalho de rotulação para serem utilizados em algoritmos de predição. Por outro lado, não são muito fáceis de serem modelados.

Se optarmos por métodos autoregressivos, não é trivial adicionar variáveis exógenas a série nesse tipo de estratégia. Interpretando a série como um problema de regressão, é mais simples adicionar variáveis exógenas além do histórico da própria série, mas é mais complicado mapear características importantes como sazonalidade e tendência.

Nesse contexto de *trade-offs* entre técnicas de regressão e de séries temporais, as redes neurais recorrentes aparecem como uma boa alternativa que atava as limitações das duas estratégias. As redes neurais recorrentes têm capacidade de trabalhar com diversas variáveis para prever a série e também apresentar mecanismos para capturar características de ciclos e sazonalidades da série.

Nesse post, será apresentada o uso de uma LSTM para o desafio de prever o volume de aluguéis em um serviço de compartilhamento de bicicletas para ilustar o uso de redes neurais em problemas de séries temporais.

## Bike Sharing Dataset

O dataset utilizado nesse post é o [Bike Sharing Dataset](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset), que contém o histórico de 2 anos de um serviço de compartilhamento de bicicletas. Além do volume de bicicletas alugadas de hora em hora, esse dataset também contém informações das condições do tempo (temperatura, humidade e chuva/neve), variáveis que impactam no comportamento dos usuários de bicicletas.

Abaixo,  a descrição das variáveis fornecida pelo criador do dataset.

```
1. instant: record index
2. dteday : date
3. season : season (1:springer, 2:summer, 3:fall, 4:winter)
4.  yr : year (0: 2011, 1:2012)
5.  mnth : month ( 1 to 12)
6.  hr : hour (0 to 23)
7.  holiday : weather day is holiday or not (extracted from http://dchr.dc.gov/page/holiday-schedule)
8.  weekday : day of the week
9.  workingday : if day is neither weekend nor holiday is 1, otherwise is 0.
10.  weathersit : 
    * 1: Clear, Few clouds, Partly cloudy, Partly cloudy
    * 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist
    * 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds
    * 4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog
1. temp : Normalized temperature in Celsius. The values are divided to 41 (max)
2. atemp: Normalized feeling temperature in Celsius. The values are divided to 50 (max)
3. hum: Normalized humidity. The values are divided to 100 (max)
4. windspeed: Normalized wind speed. The values are divided to 67 (max)
5. casual: count of casual users
6. registered: count of registered users
7. cnt: count of total rental bikes including both casual and registered
```

O objetivo é projetar o valor de `cnt`, de hora em hora, com base em todas essas variáveis e o comportamento histórico da série. 
Para entender o porquê as variáveis adicionais do dataset são importantes, vamos fazer uma breeve análise exploratória do dataset.

## Análise Exploratória

Na própria descrição do dataset, o criador diz que as variáveis de clima impactam no comportamento da série, vamos plotar alguns gráficos para verificar como funciona essas relações.

Iniciando a análise no nível diário, vamos entender como se comportam os diferentes dias da semana no dataset, selecionando um mês arbitrário e um dia da semana para anáiise. Na figura 1, temos os sábados do mês de Outubro de 2011, já podemos ver que quando a temperatura ficou muito baixa, o volume do aluguel de bicicletas também ficou bastante abaixo comparado a outros sábados do mesmo mês.

<figure>
  <img src="{{site.url}}/assets/images/lstm/saturdays_october_cnt.png"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/saturdays_october_atemp.png"/>
  <figcaption>Figura 1 - Sábados do mês de outubro</figcaption>
</figure>

Na figura 2, podemos ver um exemplo inverso da figura 1, de uma quinta-feira muito quente no mês de de junho (2011-06-09), em que também tivemos um menor volume de aluguéis.

<figure>
  <img src="{{site.url}}/assets/images/lstm/thursdays_june_cnt.png"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/thursdays_june_atemp.png"/>
  <figcaption>Figura 2 - Quintas-feiras do mês de outubro</figcaption>
</figure>

Além da questão das temperaturas extremas, é interessante notar a diferença da curva entre as quintas-feiras e os sábados. Nas quintas, o pico de aluguéis está nos horários de chegada e saída do trabalho, enquanto nos sábados o pico é no horário da tarde.

Utilizando apenas a visão diária, os extremos (tanto calor quanto frio) aparentam ter uma relação negativa com o aluguel de bicicletas. Partindo para um visão anual, podemos ver que o calor tem um impacto positivo no aluguel de bicicletas, como podemos ver na figura 3 que apresenta o agregagado de aluguéis e temperatuas diários no ano de 2011 .

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_2011_cnt.png"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_2011_atemp.png"/>
  <figcaption>Figura 3 - Volume de aluguel e temperaturas no ano de 2011</figcaption>
</figure>

Expandindo essa série para o ano de 2012, além desse ciclo anual das temperaturas do ano, podemos observar que há uma tendência de crescimento de 2011 para 2012 no uso do serviço como um todo (Figura 4).

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_cnt.png"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_atemp.png"/>
  <figcaption>Figura 4 - Volume de luguel e temperaturas diário</figcaption>
</figure>

Dessa forma, podemos entender que a temperatura é uma variável importante para estimar o volume de bicicletas alugadas. Além da temperatura, outras características como a indicação de dia chuvoso, nublado ou com neve também parecem relevantes para o modelo. No boxplot da Figura 5, podemos ver como chuva e neve impactam negativamente no aluguel de bicicletas , enquanto dias abertos tem um efeito positivo.

<figure>
  <img src="{{site.url}}/assets/images/lstm/boxplot_weathersit_2011.png"/>
  <figcaption>Figura 5 - Volume de aluguel diário por clima do dia</figcaption>
</figure>

A partir dessa breve análise [^1], podemos perceber que as condições climáticas são um fator relevante para estimar o volume de aluguéis de bicicletas. Não seria interessante usar um modelo de séries temporais que não levasse em conta essas informações adicionais, mas também é claro que temos características inerentemente temporais como os ciclos diários, semanais e a tendência de crescimento do serviço ao decorrer do tempo.

[^1]: Nessa seção, foi feito um resumo das análises, os gráficos e os códigos dessa análise estão nesse [notebook](https://github.com/gdarruda/bike-predict/blob/master/Explanatory_analysis.ipynb).

## RNNs para séries temporais

O problema de prever o número de bicicletas alugadas envolve tanto questões sazonais (dia da semana e estações do ano) como variáveis exógenas (temperatura e chuva/neve). Nessa seção, iremos entender o porquê das redes neurais serem uma opção dequada para esse tipo de problema, já que elas têm o poder de incorporar ambas as dimensões na predição da série.

### RNN

As redes neurais recorrentes (RNN) são bastante utilizadas para problemas com dados sequênciais não estruturados, como processamento de linguagem natural e reconhecimento de fala por exemplo, mas suas características são interessantes para qualquer problema como caráter de sequência como é o caso das séries temporais.

As RNNs têm uma arquitetura básica como a da figura 6, na qual a informação computada em $$ t $$ é utilizada para calcular $$ t + 1 $$.

<figure>
  <img src="{{site.url}}/assets/images/lstm/rnn_basic.png"/>
  <figcaption>Figura 6 - Arquitetura das RNNs</figcaption>
</figure>

No momento $$ t $$, a rede computa $$ V_{t} $$ e $$ W_{t} $$, essas saídas são calculadas com base nas caraterísticas da posição atual ($$ X_{t}$$) e na saída do passo anterior ($$ V_{t-1}$$).

$$
  V_{t} = g(W_{vv}V_{t-1} + W_{vx}X_{t} + b_{a}) \\
  W_{t} = g(W_{ov}V_{t} + b_{o})
$$

A função de ativação $$ g(x) $$ é normalmente uma $$ tanh $$, mas nada impede de ser utilizada outra função de ativação para calcular $$ V_{t} $$ e $$ O_{t} $$.

Depois de calculado $$ W_{t} $$, esse vetor de saída pode ser conectada a uma camada final como uma softmax ou até mesmo ser conectada em outra rede neural. Para o nosso caso, em que queremos o total de aluguéis, a saída $$ W_{t} $$ pode ser uma função linear $$ O_{t} $$ com um neurônia na saída, que retornará o valor da projeção da rede feita para aquele momento.

Essa á a arquitetura mais básica de uma RNN, arquiteturas mais complexas como a GRU e LSTM, adicionam o conceito de portões a esse fluxo, que controlam a passagem de informação entre as etapas da sequência.

### LSTM

As LSTM é umas das arquiteturas de RNNs mais populares, muito usada na área de NLP. Como podemos ver na sua arquitetura (Figura 7), é uma rede que possui bastante componentes adicionais comparado a uma RNN simples.

Esses componentes são os chamados *gates* (portões), sua função é controlar a passagem de informação entre as etapas da rede, não limitando a "memória" apenas a etapa imediatamente anterior. Dessa forma, a rede neural pode aprender com informações de etapas muito anteriores que podem influenciar na etapa atual da série – como métodos autogressivos para séries temporais.

<figure>
  <img src="{{site.url}}/assets/images/lstm/rnn_lstm.png"/>
  <figcaption>Figura 7 - Arquitetura de uma LSTM</figcaption>
</figure>

Esses *gates* são aplicadas na entrada/saída das redes como um vetor de "máscara", com valores entre 0 e 1, que indicam o quanto de informação deve ser propagada. É bem similar ao conceito de *Dropout* [^2] em sua forma de funcionamento, mas aprendido pela rede para reaproveitar as informaçõe corretas da série,  ao invés de ser aplicado aleatoriamente durante o treinamento.

[^2]: O Dropout é uma técnica de regularização que pode ser aplicada em qualquer rede, apesar de termos uma analogia em termos de funcionamento, o objetivo dos gates e da técnica de dropout são diferentes.

#### Gates (portões) 

A LSTM utiliza três portões diferentes: *forget gate*, *input gate* e *output gate*.

$$F_{t} = \sigma(W_{fa}a_{t-1} + W_{fx}x_{t} + b_{f}) $$: chamado de *forget gate*, responsável por defininir o que deve ser ignorado das entradas da etapa atual.

$$I_{t} = \sigma(W_{ia}a_{t-1} + W_{ix}x_{t} + b_{i}) $$: chamado de *input gate*, responsável por defininir o que deve ser aproveitado das entradas da etapa atual.

$$O_{t} = \sigma(W_{oa}a_{t-1} + W_{ox}x_{t} + b_{l}) $$: chamado de *output gate*, responsável por defininir o que deve ser passsado da etapada atual para a próxima.

Os portões $$F_{t}$$ e $$I_{t}$$ são aplicados de forma a combinar $$ \widetilde{c}_{t} $$ e $$ c_{t-1} $$ para chegar na saída $$c_{t}$$, enquanto o portão $$O_{t}$$ é aplicado na saída da rede $$h_{t}$$.

$$ 
 \widetilde{c} = tanh(W_{ca}a_{t-1} + W_{xa}x_{t} + b_{c}) \\
 c_{t} = F_{t} \ast \widetilde{c}  + I_{t} \ast c_{t-1} \\
 h_{t} = O_{t} \ast tanh(c_{t})
 $$

A função sigmóide $$\sigma$$ usada nos portões podem ter qualquer valor entre 0 e 1, mas é comum que elas acabame com valores muito próximo dos extremos, funcionamento como um filtro binário do tipo "passa" ou "não passa" informação adiante.

São esses portõess que ajudam a rede a mapear características temporais do problema, é comum que um valor de $$ c_{0} $$ seja propagado para várias etapas posteriores, sendo utilizandos quando a rede achar "pertinente" e ir posteriormente "esquecendo" essa informação quando necessário.

## Utilizando a LSTM

 As redes LSTM são complexas de entender, mas simples de usar, sua arquitetura fixa e poucos parâmetros a serem definidos as tornam muito prática de serem utilizadas com o Keras. Com poucas linhas de código, é possível treinar uma rede para projetar os valores de uma série temporal.

### Preparação dos dados

 As variáveis contínuas desse dataset como temperatura e humidade do ar já estão em uma escala entre 0 e 1, mas é interessante tratar também os dados categóricos. Para variáveis categórias, iremos usar uma representação *one-hot-encoding*. Abaixo, o código feito para carregar o dataset e transformar as variáveis para o formato *one-hot-encoding*.

 ```python
import pandas as pd

def load_dataset():
    ds = pd.read_csv('hour.csv')
    ds['dteday'] = pd.to_datetime(ds['dteday'])
    return ds
    
def one_hot_encoding(df, field):
    one_hot_encoded = pd.get_dummies(df[field])
    return  pd.concat([df.drop(field, axis=1), one_hot_encoded], axis=1)
    
def preprocess_dataset(df):

    df_reduced = df[['dteday', 'cnt', 'season','yr', 'mnth','hr', 'holiday', 'weekday', 'workingday', 'weathersit', 'temp', 'atemp', 'hum', 'windspeed']]
    df_reduced = one_hot_encoding(df_reduced, 'season')
    df_reduced = one_hot_encoding(df_reduced, 'mnth')
    df_reduced = one_hot_encoding(df_reduced, 'hr')
    df_reduced = one_hot_encoding(df_reduced, 'weekday')
    df_reduced = one_hot_encoding(df_reduced, 'weathersit')
    
    return df_reduced

dataset = load_dataset()
dataset = preprocess_dataset(dataset)
 ```

 Note que variáveis periódicas, como `mnth` e `hr`, também foram transformadas em *one-hot-encoding*. Em meus testes, isso se mostrou fundamental. Apenas escalar as variáveis cíclicas entre 0 e 1, como se fossem variáveis contínuas, fez com que a rede não coonseguisse convergir mesmo com várias époas de treinamento.

### Treinamento e validação

O problema que estamos lidando é de séries temporais, então não faz sentido amostrar aleatoriamente para dividir em treino e validação em uma validação cruzada como seria o caso para uma regressão ou classificação, os dados de treino precisam estar antes no tempo que os dados de validação. 

Seguindo uma estratégia comum em deep learning, vamos separar o conjunto de dados como treino, desenvolvimento e validação. O conjunto de treino e desenvolvimento serão usadas na etapa de treinamento, para "tunar" os parâmetros de treinamento. O conjunto de validação será apenas para verificação final após treinamento, ou seja, não otimizaremos os parâmetros para alcançar bons resultados nesse conjunto.

* Treino: **2011-01-01** até **2012-10-31**
* Desenvolvimento: **2012-11-01** até **2012-11-30**
* Validação: **2012-12-01** até **2012-12-31**

Abaixo, o código para separação do dataframe entre treino, desenvolvimento e validação

```python
from datetime import datetime

def filter_by_date(ds, start_date, end_date):
    
    start_date_parsed = datetime.strptime(start_date, "%Y-%m-%d") 
    start_end_parsed = datetime.strptime(end_date, "%Y-%m-%d")
    
    return ds[(ds['dteday'] >= start_date_parsed) & (ds['dteday'] <= start_end_parsed)]

train = filter_by_date(dataset, '2011-01-01', '2012-10-31')
dev = filter_by_date(dataset, '2012-11-01', '2012-11-30')
val = filter_by_date(dataset, '2012-11-01', '2012-12-31')
``` 

Após separar os conjuntos, podemos transforma-los em vetores *numpy* para serem usados na rede neural. Perceba que o *reshape* do vetor de entrada é no formato (# de linhas, 1, # de variáveis) ao invés de (# de linhas, # de variáveis).

O dado precisa ser formatado assim, pois a segunda dimensão se refere ao comprimento da sequência que gera uma saída. Para alguns problemas, ao invés de gerar uma saída por etapa da sequência, geramos apenas uma saída final para a sequência toda por exemplo.

```python
import numpy as np

def reshape_dataset(ds):

    Y = ds['cnt'].values

    ds_values = ds.drop(['dteday', 'cnt'], axis=1).values
    X = np.reshape(ds_values, (ds_values.shape[0], 1, ds_values.shape[1]))
    
    return X, Y

X_train, Y_train = reshape_dataset(train)
X_dev, Y_dev = reshape_dataset(dev)
X_val, Y_val = reshape_dataset(val)
``` 

Por fim, é útil criar um *callback* do Keras para vermos o gráfico de evolução de treinamento em tempo real, isso é bastante útil para fazer o ajuste dos parâmetros, principalmente nas etapas inicias.

```python
%matplotlib inline

import keras
from matplotlib import pyplot as plt
from IPython.display import clear_output

class PlotLosses(keras.callbacks.Callback):
    def on_train_begin(self, logs={}):
        self.i = 0
        self.x = []
        self.losses = []
        self.val_losses = []
        
        self.fig = plt.figure()        
        self.logs = []

    def on_epoch_end(self, epoch, logs={}):
        
        self.logs.append(logs)
        self.x.append(self.i)
        self.losses.append(logs.get('loss'))
        self.val_losses.append(logs.get('val_loss'))
        self.i += 1
        
        clear_output(wait=True)
        plt.plot(self.x, self.losses, label="loss")
        plt.plot(self.x, self.val_losses, label="val_loss")
        plt.legend()
        plt.show()
        
plot_losses = PlotLosses()
```

### LSTM no Keras

O uso da LSTM no Keras é bastante simples, bastanto ao usuário definir a dimensão do vetor de entrada, a quantidade de neurônios e a função de saída. O vetor de entrada, após as transformações de variáveis, tem 58 dimensões. A quantidade de neurônios utilizados, após alguns testes, defini como 200 que alcançava o mesmo *fit* de redes maiores sem onerar tanto a perfomance do treinamento. Por fim, ligamos um output linear de 1 saída para treinamento.
 

Adicionei uma camada de Dropout entre a saída da rede ($$W_{t}$$) e a saída ($$O_{t}$$), procurando mitigar problemas de Dropout. Não utilizei essa técnica nas camadas internas da rede, pois elas acabavam atrasando muito o aprendizado, ainda preciso entender melhor quais as estratégias para uso de Dropout em redes neurais recorrentes.

<!--Adicionei uma camada de Dropout entre a saída da rede ($$W_{t}$$) e a saída ($$O_{t}$$), entretanto deixei desativada com probabilidade 0. Ativando essa camada, a rede não atingia o menor nível de erro, nem no treino e nem no desenvolvimento. Existem aplicações de dropout em LSTM, mas precisaria entender melhor como utiliza-las, nesse experimento as redes não convergem tão bem com esse método de regularização-->

O otimizador utilizado foi o Adam, que geralmente é o mais rápido e estável para convergir. Após experimentos, percebi que o valor padrão da taxa de aprendizado (0,001) era muito baixo, subindo para 0,01 a convergência ficou muito mais rápida e também alcançou taxas de erros menores. Combinando esse aumento de taxa de aprendizado com uma taxa de decaimento de 0,001, a rede consegue convergir no ajuste fino da rede.

A rede está sendo otimizada a métrica de [erro absoluto médio](https://en.wikipedia.org/wiki/Mean_absolute_error), dessa forma temos uma visão clara de quanto estamos errando comparado ao valor total das predições. Abaixo, o código completo para definição da LSTM.

```python
from keras.models import Model
from keras.layers import Input, Dense, LSTM, Dropout

def get_model():

    input = Input(shape=(1, 58))
    x = LSTM(200, dropout=.0)(input)
    x = Dropout(.5)(x)
    activation = Dense(1, activation='linear')(x)
    model = Model(inputs=input, outputs=activation)
    
    optimizer = keras.optimizers.Adam(lr=0.01,
                                      beta_1=0.9,
                                      beta_2=0.999,
                                      epsilon=None,
                                      decay=0.001,
                                      amsgrad=False)

    model.compile(loss='mean_absolute_error', optimizer=optimizer)
    model.summary()

    return model

get_model()
```
## Resultados e conclusão

A nossa rede está definida, agora podemos treina-la e avaliar os resultados no conjunto de validação. Assim como na definição dos parâmetros da rede, irei direto para a solução final para não deixar o *post* mais comprido ainda. Usando a arquitetura acima, com 50 épocas, chegamos ao ponto de estabilidade das perdas no conjunto de treino e desenvolvimento.

```python
def train_model(model, X_train, Y_train, validation, callbacks):

    model.fit(X_train, Y_train, epochs=50, batch_size=128, validation_data=validation, callbacks=callbacks)
    return model
  
model = train_model(get_model(), X_train, Y_train, (X_dev, Y_dev), [plot_losses])
```
Durante o processo de treinamento e validação, o erro da validação ficou na faixa de 40/50 aluguéis, enquanto o erro do treinamento ficou na faixa dos 20 aluguéis. A média de aluguéis a cada hora está em 189 para efeitos de comparação.

Abaixo, o gráfico de perda desse processo de treinamento especificado.

<figure>
  <img src="{{site.url}}/assets/images/lstm/train.png"/>
  <figcaption>Figura 8 - Gráfico de perda</figcaption>
</figure>

Para problemas de séries temporais é interessante observar os dados no olho para entender em que situações a rede está errando, segue abaixo o código para plotar o observado e o predito pela rede.

```python
from sklearn.metrics import mean_absolute_error

def show_predict(model, X, Y):
    
    Y_predict = model.predict(X)
    
    plt.figure(figsize=(40,10))
    plt.plot(list(range(len(Y))), Y, label="Real")
    plt.plot(list(range(len(Y_predict))), Y_predict, label="Predicted")
    plt.legend()
    plt.show()

    return mean_absolute_error(Y, Y_predict)

show_predict(model, X_val[:360], Y_val[:360])
show_predict(model, X_val[360:720], Y_val[360:720])
```
Comparando o real com o projetado para dezembro, obtemos um resultado muito melhor do que com o conjunto de dev, chegando próximo ao obtido no conjunto de treino, menos que 30 no erro médio. Alguns meses devem ter características específicas, seria interessante fazer testes com a rede aplicando outros cortes para entender melhor essa discrepância re resultados.

<figure>
  <img src="{{site.url}}/assets/images/lstm/validation_1.png"/>
</figure>
<figure>
  <img src="{{site.url}}/assets/images/lstm/validation_2.png"/>
  <figcaption>Figura 9 - Gráfico de perda</figcaption>
</figure>

A partir desse momento, o interessante seria fazer uma análise mais extensa, para um ajuste fino da rede e entender melhor as características do dataset, mas esses resultados já mostram que as redes recorrentes tem uma ótima capacidade de se adaptar a esses problemas de séries temporais. Combinando essa capacidade com a facilidade de implementação, são um ótimo ponto de partida para esses problemas de séries temporais.

#### Notas