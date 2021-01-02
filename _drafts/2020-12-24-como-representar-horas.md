---
layout: post
title: "Como representar dados circulares?"
comments: true
mathjax: true
description: "Discutindo formas de representar horas"
keywords: "classificação, clustering"
---

O pré-processamento variáveis é um tópico obrigatório em qualquer curso introdutório de ciência de dados, mas não vejo quase nenhum material ou discussão sobre variáveis circulares.

Por exemplo, imagine que você queira classificar compras do cartão: faz sentido considerar que duas compras – uma realizada às 23:00 e outra às 01:00 – são próximas uma da outra. Ao representar o horário como uma variável contínua, essas compras ficarão em extremos opostos da distribuição.

Em bases "corporativas", é comum os dados envolverem variáveis com informações de calendário (horário/mês/dia da semana), que possuem essa dinâmica circular. Anedoticamente, posso citar três problemas bem diferentes em que precisei lidar com essa questão.

Como não encontro muito material sobre isso, fiz esse post para avaliar a questão: faz alguma diferença, representar os dados de forma circular ou linear? 

## Preparando os dados

Para estudar esse problema, gerei um conjunto de dados sintético contendo apenas uma variável de hora. 

Usando a distribuição de [von Mises](https://en.wikipedia.org/wiki/Von_Mises_distribution) – análoga à gaussiana para dados circulares[^1] – gerei 1500 amostras usando 3 médias diferentes: meia-noite, 6 horas e 21 horas. O parâmetro de dispersão da distribuição ($$ \kappa $$), equivalente ao desvio padrão de uma curva normal, foi definido empiricamente como 0,1 para as três distribuições com o objetivo de gerar uma interesecção entre elas.

[^1]: Como pontuei na introdução, não é um assunto muito debatido então não é fácil encontrar muito material, a melhor explicação que achei sobre distribuição foram os primeiros 10 minutos [dessa palestra](https://www.youtube.com/watch?v=rwFEQklcJvw).

Na figura 1, está o histograma dos dados gerados por esse processo. Nessa visualização, podemos perceber o problema de tratar horas como uma variável contínua: a distribuição com $$ \mu $$ à meia-noite fica separada entre os dois extremos, dando a falsa impressão de que foi gerada por duas distribuições e não somente uma.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/histograma.svg"/>
  <figcaption>Figura 1 – Histograma dos horários gerados</figcaption>
</figure>

Uma representação alternativa, que estou chamando de circular, é tratar a hora como se fosse um arco descrito em relação à meia-noite:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Para transportar o arco $$ hora_{r} $$ ao plano cartesiano, basta calcular o seno e o cosseno do ângulo descrito:

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Na figura 2, podemos ver como os mesmos dados da figura 1 ficam representados após essa transformação. Ao projetar os arcos gerados no círculo unitário, os dados parecem estar em um relógio analógico de 24 horas, sem a descontinuidade artificial da representação linear.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/representacao_circular.svg"/>
  <figcaption>Figura 2 – Dados representados em formato circular</figcaption>
</figure>

Aos olhos e a intuição, a representação circular faz mais sentido, mas qual o impacto em modelos? Para descobrir, eu fiz alguns experimentos envolvendo problemas de classificação e agrupamento usando esse conjunto de dados.

## Classificação

A proposta do experimento é comparar qual o impacto das representação em cada tipo de classificador, não comparar os classificadores entre si. Por isso, foi necessário um experimento diferente de simplesmente comparar a acurácia de cada modelo.

Para avaliar o impacto da representação, gostaria de medir se é mais "fácil" para os modelos trabalhar com uma ou com outra. O que estou definindo como "fácil", é se o modelo chega a bons resultados com menor necessidade de ajuste de parâmetros.

Optei pelos seguintes classificadores: $$k$$-NN, SVM Linear, MLP e Random Forest. Para comparar esses modelos, gerei 50 variações aleatórias de hiperparâmetros para cada combinação <classificador, representação> usando o módulo [RandomizedSearchCV](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html). No total, foram realizados 400 experimentos: 4 classificadores $$ \times $$ 50 variações $$ \times $$ 2  representações.

A ideia do experimento é gerar uma distribuição dos resultados de acurácia de cada modelo. Com base nessa distribuição, considero como representação mais "fácil", a que oferece menor variância em torno da acurácia 
ótima. Em outras palavras, a representação é boa se chega a uma boa acurácia sem a necessidade de muito ajuste de hiperparâmetros.

Minhas hipóteses eram essas:

1. Modelos baseados em distância, como o $$k$$-NN por exemplo, seriam os mais beneficiados ao usar a representação circular.
2. Modelos lineares perderiam acurácia, já que é impossível separar esses dados em uma dimensão com apenas um ponto.

Para visualizar essa distribuição de acurácia, eu usei o método de [Kernel Density Estimation (KDE)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.kde.html), que plota uma distribuição não-paramétrica a partir de um histograma. Na figura 3, temos essas distribuições plotada e a maior acurácia obtida destacada no título.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/classificadores.svg"/>
  <figcaption>Figura 3 – Distribuição de resultados dos classificadores</figcaption>
</figure>

Em termos de acurácia máxima, todos os modelos chegaram à valores similares com ambas representações, exceto o SVM Linear que atingiu um máximo de 0,67 com a representação linear e 0,84 com a representação circular. Os demais modelos chegaram a valores próximos de 0,84 em ambas as representações.

Curiosamente, o $$k$$-NN foi o modelo que lidou bem com ambas as representações. Os demais modelos lidaram mais facilmente com a representação circular em comparação a linear, com mais hiperparâmetros chegando ao valor máximo de acurácia, especialmente quando olhamos os resultados do MLP.

Em resumo, não houve mudanças no resultado ótimo dos classificadores, com os parâmetros certos todos chegaram ao nível máximo de acurácia (exceto o SVM linear). Por outro lado, os modelos chegaram na solução ótima mais facilmente com a representação circular.

## Agrupamento

No experimento anterior, percebemos que os algoritmos de classificação mais poderosos conseguem lidar bem com ambas as representações, mesmo que tenham mais dificuldades com a representação linear. Para tarefas de agrupamento, o cenário é mais complicado.  

Mesmo usando modelos sofisticados, não é fácil lidar com uma representação deficiente. Não havendo uma função objetivo bem definida – uma representação pior pode simplesmente levar a conclusões piores – como uma escolha errada do número de clusters por exemplo.

Não tenho muita experiência com problemas de agrupamento, então vou me restringir a comparar dois dos modelos mais simples: $$k$$-means e Gaussian Mixture Models (GMM). 

Para avaliar o desempenho das representações, eu rodei cada um dos modelos 50 vezes com inicialização aleatória e 3 grupos ($$ k = 3 $$). A ideia é que, com uma melhor representação, seja mais fácil para os algoritmos de agrupamento chegarem próximo do processo que originou os dados. Em outras palavras, gerar grupos que estejam centralizados próximos de meia-noite, 6 horas e 21 horas.

Na figura 4, temos a localização dos centróides gerados para cada distribuição do $$k$$-means. Os resultados com ambas as representações foram bons, posicionado os centróides próximo das médias das distribuições originais. Entretanto, o grupo centralizadado à meia-noite acaba ficando deslocado algumas horas para cima na representação linear, "puxado" pelo grupo de 6 horas.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/centroides_kmeans.svg"/>
  <figcaption>Figura 4 – Centróides do k-means</figcaption>
</figure>

Na figura 5, temos a mesma visualização da figura 4 para o GMM. Curiosamente, o GMM teve mais difculdades em definir os grupos, a despeito dos dados terem sido gerados usando uma distribuição análoga à gaussiana. Na representação linear, as médias não ficaram estáveis, alguns grupos ficaram longe das médias utilizadas na geração dos dados. Para a representação circular, os dados ficaram bem similares aos do $$k$$-means.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/medias_gmm.svg"/>
  <figcaption>Figura 4 – Médias do GMM</figcaption>
</figure>

Em ambos os casos, a representação circular facilitou o trabalho do algoritmo de agrupamento, possibilitando que ambos os modelos chegassem mais próximo das médias usadas para gerar o dado. Na representação linear, ambos tiveram dificuldades em lidar com os dados cenralizados à meia-noite.

## Conclusão

Como não vejo muita discussão, nem nada implementado em bibliotecas de machine learning e afins, achei que fazia sentido fazer esses experimentos para entender se eu não estava ignorando algum problema da representação circular.

Após esse breve estudo, não encontrei motivos para não usar representação circular. É uma transformação bem simples – conceitualmente e computacionalmente – que não gera distorções em dados próximo aos extremos da distribuição.

É um problema similar ao uso de sequências numéricas para representar dados categóricos: provavelmente vai funcionar, mas não é bom adicionar uma relação de ordem inexistente. Nesse caso, provavelmente vai funcionar usando representação linear, mas não é bom ignorar o caráter circular da variável.

Mais detalhes de como os experimentos foram realizados, estão nesse notebook. Recomendo dar uma olhada, porque essa implementação ensejou outro post: como desenvolver códigos usando a abordagem vetorial.