---
layout: post
title: "Como representar horas em modelagem?"
comments: true
mathjax: true
description: "Discutindo formas de representar horas"
keywords: "classificação, clustering"
---

O pré-processamento das variáveis é um tópico obrigatório em qualquer curso introdutório de ciência de dados, mas pouco se fala de reprentação de dados com características cíclicas. Ao ignorar essa propriedade, acaba-se jogando fora uma informação importante sem motivos, já que é algo simples de tratar. 

Por exemplo, imagine que você queira avaliar as características das compras do cartão: faz sentido considerar que duas compras, uma realizada às 23:00 e outra às 01:00, são próximas uma da outra. Representando o horário como variável continua, essas compras estarão em extermos opostos em relação em um cálculo de distância.

Especialmente no contexto corporativo, é muito comum lidar com esse tipo de variável, de forma anedótica posso citar três problemas bem diferentes em que precisei lidar com essa questão. Mesmo assim, não vejo praticamente nenhum conteúdo exceto alguns posts em blogs como esse.

Entendo que não seja um problema muito grave, a maioria dos modelos conseguem contornar essa questão. Entretanto, pode ser um problema em alguns casos e a solução é trivial, por que não representar da forma mais adequada?

## Visualizando a questão

Para estudar o problema, gerei um conjunto de dados sintético. A partir da distribuição de [von Mises](https://en.wikipedia.org/wiki/Von_Mises_distribution) – análoga à gaussiana para dados circulares[^1] – gerei 500 amostras de horário para 3 médias distintas com a mesma dispersão: meia-noite, 6 horas e 21 horas. A dispersão da distribuição, definada pelo parâmetro $$ \kappa $$, foi estimada empiricamente para gerar uma intersecção entre os três conjuntos.

[^1]: Como pontuei na introdução, não é um assunto muito debatido então não é fácil encontrar muito material, a melhor explicação que achei sobre distribuição foram os primeiros 10 minutos [dessa palestra](https://www.youtube.com/watch?v=rwFEQklcJvw).

Na figura 1, podemos perceber o problema em questão de tratar horário como variável contínua: a distribuição com $$ \mu $$ à meia-noite (1) fica separada entre os dois extremos, aparenta ter sido gerada por dois processos.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/histograma.svg"/>
  <figcaption>Figura 1 – Histograma dos horários gerados</figcaption>
</figure>

Assim como a distribuição, a alternativa é lidar com a hora como se fosse um arco descrito em relação à meia-noite, como um relógio analógico de 24 horas:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Para representar os arcos no plano cartesiano como coordenadas $$ x,y $$ – dentro do círculo trigonométrico de raio 1 – basta calcular o seno e o cosseno do ângulo calculado com a fórmula anterior.

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Na figura 2, podemos ver como os mesmos dados da figura 1 ficam representados após essa transformação. Ao projetar os arcos gerados no círculo trigonométrico, não temos mais uma descontinuidade artificial.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/representacao_circular.svg"/>
  <figcaption>Figura 2 – Dados representados em formato circular</figcaption>
</figure>

Aos olhos e a intuição, essa representação faz mais sentido, mas isso tem algum impacto em modelagens? Não tanto para classificações, mas é um ponto de atenção para agrupamentos.

## Classificação

A ideia do experimento proposta aqui é comparar qual o impacto das diferentes representações nos classificadores, avaliar se há diferenças na acurácia ao usar uma outra representação. MInhas hipóteses eram essas:

1. Modelos basedaos em distância, como o $$k$$-NN por exemplo, seriam os mais beneficiados ao usar a representação circular.
2. Modelos lineares perderiam acurácia, já que é impossível separar esses dados em uma dimensão com apenas um ponto.

Além de avaliar a acurácia máxima, gostaria de saber se é mais "fácil" para os modelos lidar com uma ou outra. Estou chamando de "fácil", se modelos chegam aos resultados com menor necessidade de ajuste de parâmetros. 

Como é um cenário um pouco diferente de simplesmente avaliar o melhor classificador, optei por testar 50 variações aleatórias para cada classificador usando o módulo [RandomizedSearchCV](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html) do scikit-learn. Optei pelos seguintes classificadores: $$k$$-NN, SVM Linear, MLP e Random Forest. Mais detalhes, de quais parâmetros variados e qual a distribuição utilizada, podem ser encontradas no notebook dos experimentos.

A ideia desse método, é gerar uma distribuição dos resultados de acurácia obtido por cada modelo. Com base nessa distribuição, considero como melhor representação de hora, a que oferece menor variância em torno do resultado ótimo. Em outras palavras, uma representação que funciona bem com menor necessidade de ajuste de parâmetros.

Para gerar essa distribuição, eu usei o método de [Kernel Density Estimation (kde)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.kde.html) do Pandas que plota uma distribuição não-paramétrica a partir do histograma. Na figura 3, temos os resultados desse experimento para cada um dos modelos. Destaquei no título de cada gráfico a melhor acurácia obtida pelo modelo.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/classificadores.svg"/>
  <figcaption>Figura 3 – Distribuição de resultados dos classificadores</figcaption>
</figure>

Em termos de acurácia máxima, todos os modelos chegaram à valores similares com ambas representações, exceto o SVM Linear que obteu um máximo de $$ 0,67 $$ com a representação linear e $$ 0,84 $$ com a representação circular. Os demais modelos chegaram a valores de $$ 0,85 $$ em ambas as representações.

Curiosamente, o $$k$$-NN foi o modelo que se saiu melhor com a representação linear, tendo mais resultados concentrado próximo a ao ótimo em comparação a representação linear. Os demais modelos parecem se beneficiar da representação circular, especialmente a MLP que com a representação linear teve mais modelos caindo em uma acurácia abaixo de $$ 0,4 $$ que próximo a $$ 0,85 $$.

Em resumo, não houve mudanças no resultado do classificador, com os parâmetros certos todos chegaram ao nível máximo de acurácia com exceção do SVM linear. Por outro lado, os modelos chegaram na solução ótima mais facilmente com a representação circular.

## Agrupamento

Os resultados obtidos na classificação nos levam ao ponto em que a representação circular pode ser mais útil, que são algoritmo de agrupamento não-supervisionado.