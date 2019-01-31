---
layout: post
title: "LSTM para séries temporais"
comments: true
description: "Rede neural para análise de sentimentos em português."
keywords: "Deep Learning, Convoluções, NLP, Análise de Sentimentos"
---

Os problemas de predição envolvendo de séries temporais são bastante comuns em diversas áreas, entretanto não são muito fáceis de serem modelados. Se optarmos por métodos autoregressivos, não é trivial adicionar variáveis exógenas a série nesse tipo de estratégia. Interpretando a série como um problema de regressão, é mais simples trabalhar com dados além do histórico da série, mas é mais complicado mapear características importantes como sazonalidade e tendência.

Nesse contexto de *trade-offs* entre técnicas, as redes neurais recorrentes aparecem como uma boa alternativa. Além da capacidade de trabalhar com diversas variáveis para prever a série, é fácil modelar o caráter temporal do problema. Nesse post, será apresentada o uso de uma rede neural recorrente para o desafio de prever o volume de aluguéis em um serviço de compartilhamento de bicicletas.

## Bike Sharing Dataset

O dataset utilizado nesse post é o [Bike Sharing Dataset](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset), que contém o histórico de 2 anos de um serviço de compartilhamento de bicicletas. Além do volume de bicicletas alugadas, esse dataset também contém informações das condições do tempo (temperatura, humidade, chuva), variáveis que impactam no comportamento dos usuários de bicicletas.

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

Nosso objetivo aqui é projetar o valor de `cnt`, de hora em hora, com base em todas essas variáveis e o comportamento histórico da série. Antes de aplicar os modelos, é interessante fazer uma análise exploratória para termos uma ideia das variáveis mais relevantes e do comportamento geral dessa série.

## Análise Exploratória

Na própria descrição do dataset, o criador diz que as variáveis de clima impactam no comportamento da série, então vamos plotar alguns gráficos para verificar como isso é relacionado.

Primeiramente a nível de dia, é possível notar que temperaturas extremas impactam negativamente o volume de usuários. Na figura 1,  um exemplo de um sábado muito frio (2011-10-29) no mês de outubro, que impactou negativamente no volume de aluguéis.

<figure>
  <img src="{{site.url}}/assets/images/lstm/saturdays_october_cnt.png" alt="my alt text"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/saturdays_october_atemp.png" alt="my alt text"/>
  <figcaption>Figura 1 - Sábados do mês de outubro</figcaption>
</figure>

Na figura 2, podemos ver um exemplo de uma quinta muito quente no mês de de junho (2011-06-09), em que também tivemos um menor volume de aluguéis.

<figure>
  <img src="{{site.url}}/assets/images/lstm/thursdays_june_cnt.png" alt="my alt text"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/thursdays_june_atemp.png" alt="my alt text"/>
  <figcaption>Figura 2 - Quintas-feiras do mês de outubro</figcaption>
</figure>

Além disso, é interessante perceber a diferença da curva durante as quintas-feiras e os sábados. Durante as quintas, o pico está nos horários de chegada e saída do trabalho, enquanto nos sábados o pico é no horário da tarde.

Apesar dos extremos aparentemente ter uma relação negativa com o aluguel de bicicletas, temperaturas mais altas tendem a aumentar o uso de bicicletas. Na Figura 3, em que temos o aluguel de bicicletas agregado por dia do ano de 2011, podemos ver que o aumento de temperatura no meio do ano impacta positivamente no aluguel de bicicletas.

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_2011_cnt.png" alt="my alt text"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_2011_atemp.png" alt="my alt text"/>
  <figcaption>Figura 3 - Volume de aluguel e temperaturas no ano de 2011</figcaption>
</figure>

Expandindo essa série, além desse ciclo anual das estações do ano, podemos observar que há uma tendência de crescimento de 2011 para 2012 no uso do serviço como um todo (Figura 4).

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_cnt.png" alt="my alt text"/>
</figure>

<figure>
  <img src="{{site.url}}/assets/images/lstm/daily_atemp.png" alt="my alt text"/>
  <figcaption>Figura 4 - Volume de luguel e temperaturas diário</figcaption>
</figure>

Pelos gráficos anteriores, é possível perceber a influência da temperatura no volume de aluguel de bicicletas. Outra variável de interesse. é a indicação de dia chuvoso, nublado ou com neve. No gráfio da Figura 5, podemos ver como chuva e neve impactam negativamente no aluguel de bicicletas , enquanto dias abertos tem um efeito positivo.

<figure>
  <img src="{{site.url}}/assets/images/lstm/boxplot_weathersit_2011.png" alt="my alt text"/>
  <figcaption>Figura 5 - Volume de aluguel diário por clima do dia</figcaption>
</figure>

Por essas análises, podemos perceber que as condições climáticas são um fator relevante para estimar o volume de aluguéis de bicicletas. As características da série também se mostram relevantes, como o ciclo das estações e a curva típica dos dias dasemana e dos finais de semana.

Nessa seção, foi feito um resumo das análises, os gráficos e os códigos dessa anaálise estão nesse [notebook](https://github.com/gdarruda/bike-predict/blob/master/Explanatory_analysis.ipynb).