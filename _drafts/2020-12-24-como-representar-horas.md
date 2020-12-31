---
layout: post
title: "Como representar dados circulares?"
comments: true
mathjax: true
description: "Discutindo formas de representar horas"
keywords: "classificação, clustering"
---

A preparação das variáveis é um tópico obrigatório em qualquer curso introdutório de ciência de dados, mas não vejo quase nada sobre a questão de variáveis circulares.

Por exemplo, imagine que você queira avaliar as características das compras do cartão: faz sentido considerar que duas compras – uma realizada às 23:00 e outra às 01:00 – são próximas uma da outra. Ao representar o horário como uma variável contínua, essas compras ficarão em extremos opostos da distribuição.

No contexto corporativo, é muito comum os problemas de dados envovlerem variáveis com informações de calendário (horário/mês/dia da semana) que possuem essa dinâmica circular. Anedoticamente, posso citar três problemas bem diferentes em que precisei lidar com essa questão. Mesmo assim, não parece uma questão foco de muito debate ou preocupação na área.

A ideia desse post é avaliar essa questão: faz alguma diferença representar horas de forma circular ou linear? 


## Entendendo o problema

Para estudar esse problema, gerei um conjunto de dados sintético. Usando aa distribuição de [von Mises](https://en.wikipedia.org/wiki/Von_Mises_distribution) – análoga à gaussiana para dados circulares[^1] – gerei 500 amostras de horário para 3 médias distintas com a mesma dispersão: meia-noite, 6 horas e 21 horas. A dispersão da distribuição, equivalente ao desvio padrão de uma curva normal, foi definida empiricamente para gerar uma intersecção entre os três conjuntos.

[^1]: Como pontuei na introdução, não é um assunto muito debatido então não é fácil encontrar muito material, a melhor explicação que achei sobre distribuição foram os primeiros 10 minutos [dessa palestra](https://www.youtube.com/watch?v=rwFEQklcJvw).

Na figura 1, podemos perceber o problema em questão de tratar horário como variável contínua: a distribuição com $$ \mu $$ à meia-noite (1) fica separada entre os dois extremos, dando a falsa impressão de que foi gerada por duas distribuições.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/histograma.svg"/>
  <figcaption>Figura 1 – Histograma dos horários gerados</figcaption>
</figure>

Uma representação alternativa, que lida com essa questão, é tratar a hora como se fosse um arco descrito em relação à meia-noite:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Para representar os arcos no plano cartesiano como coordenadas $$ x,y $$ – dentro do círculo trigonométrico de raio 1 – basta calcular o seno e o cosseno do ângulo calculado com a fórmula anterior.

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Na figura 2, podemos ver como os mesmos dados da figura 1 ficam representados após essa transformação. Ao projetar os arcos gerados no círculo trigonométrico, os dados parecem estar em um relógio analógico de 24 horas, sem a descontinuidade artificial.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/representacao_circular.svg"/>
  <figcaption>Figura 2 – Dados representados em formato circular</figcaption>
</figure>

Aos olhos e a intuição, essa representação faz mais sentido, mas qual o impacto em modelagem? Para verificar, eu fiz experimentos envolvendo problemas de classificação e agrupamento, usando esse conjunto de dados e as duas representações.

## Classificação

A proposta do experimento é comparar qual o impacto das representação em cada tipo de classificador, não comparar os classificadores entre si. Minhas hipóteses eram essas:

1. Modelos basedaos em distância, como o $$k$$-NN por exemplo, seriam os mais beneficiados ao usar a representação circular.
2. Modelos lineares perderiam acurácia, já que é impossível separar esses dados em uma dimensão com apenas um ponto.

Para comparar o impacto das representações, além de avaliar a acurácia máxima de cada uma velas, gostaria de saber se é mais "fácil" para os modelos trabalhar. O que estou definindo como é "fácil", é se o modelo chega a bons resultados com menor necessidade de ajuste de parâmetros.

Optei pelos seguintes classificadores: $$k$$-NN, SVM Linear, MLP e Random Forest. Para estimar o quão fácil é para o classificador chegar ao resultado, gerei 50 variações aleatórias de hiperparâmetros para cada combinação (classificador, representação) usando o módulo [RandomizedSearchCV](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html). No total, foram realizados 400 experimentos: 

$$ 
4 \ classificadores \times 50 \ variações \times 2 \ representações = 400
$$

<!-- Mais detalhes, de quais parâmetros variados e qual a distribuição utilizada, podem ser encontradas no notebook dos experimentos. -->

A ideia desse experimento é gerar uma distribuição dos resultados de acurácia de cada modelo. Com base nessa distribuição, considero como representação mais "fácil", a que oferece menor variância em torno da acurácia 
ótima. Em outras palavras, a representação é fácil se chega a uma boa acurácia sem a necessidade de muito ajuste de hiperparâmetros.

Para gerar essa distribuição de acurácia, eu usei o método de [Kernel Density Estimation (kde)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.kde.html) do Pandas, que plota uma distribuição não-paramétrica a partir de um histograma. Na figura 3, temos os resultados desse experimento por modelos. Destaquei no título de cada gráfico a melhor acurácia obtida em cada uma das representações.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/classificadores.svg"/>
  <figcaption>Figura 3 – Distribuição de resultados dos classificadores</figcaption>
</figure>

Em termos de acurácia máxima, todos os modelos chegaram à valores similares com ambas representações, exceto o SVM Linear que obteu um máximo de $$ 0,67 $$ com a representação linear e $$ 0,84 $$ com a representação circular. Os demais modelos chegaram a valores próximos de $$ 0,84 $$ em ambas as representações.

Curiosamente, o $$k$$-NN foi o modelo que se saiu melhor com ambas as representações. Os demais modelos parecem se beneficiar da representação circular, especialmente a MLP, que com a representação linear teve mais modelos caindo em uma acurácia abaixo de $$ 0,4 $$ que próximo a $$ 0,84 $$.

Em resumo, não houve mudanças no resultado ótimo dos classificadores, com os parâmetros certos todos chegaram ao nível máximo de acurácia com exceção do SVM linear. Por outro lado, pode-se argumentar que os modelos chegaram na solução ótima mais facilmente com a representação circular.

## Agrupamento

Os algoritmos de classificação mais poderosos conseguem lidar com ambas as representações, mas para tarefas de agrupamento a questão é mais crítica. Não tendo uma função objetivo bem definida – uma representação pior pode simplesmente levar a piores conclusões – como uma escolha errada do número de clusters por exemplo.

Não tenho muita experiência com problemas de agrupamento, então vou me restringir a comparar dois dos modelos mais simples: $$k$$-means e Gaussian Mixture Models (GMM). 

Para avaliar, eu rodei os algoritmos 50 vezes com inicialização aleatória e fixado 3 grupos. A ideia é que, com uma melhor representação, seja mais fácil para os algoritmos de agrupamento chegarem próximos aos processos de origem dos dados. Em outras palavras, gerar grupos que estejam centralizados próximos de meia-noite, 6 horas e 21 horas.

O $$k$$-means consegiu bons resultados com ambas as representações, posicionado os centróides próximo da média das distribuições originais. Entretanto, na representação linear o grupo que deveria ficar centralizado à meia-noite, acaba ficando deslocado algumas horas para cima, "puxado" pelo grupo de 6 horas.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/centroides_kmeans.svg"/>
  <figcaption>Figura 4 – Centróides do k-means</figcaption>
</figure>

Curiosamente, o GMM teve mais difculdades, a despeito dos dados terem sido gerados usando uma distribuição análoga à gaussiana. Na representação linear, as médias não ficaram estáveis, algumas ficaram longe do que foi usado na geração dos dados.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/medias_gmm.svg"/>
  <figcaption>Figura 4 – Médias do GMM</figcaption>
</figure>

Em ambos os casos, a representação circular facilitou o trabalho do algoritmo de agrupamento, possibilitando que eles chegassem mais próximos das médias usadas para gerar o dado. Na representação linear, ambos se perderam, mas o GMM em especial ficou bem caótico.

## Conclusão

Após esse breve estudo, não encontrei motivos para não usar representação circular. É uma transformação bem simples – conceitualmente e computacionalmente – que não gera distorções em dados próximo aos extremos da distrbuição.

É uma questão similar ao uso de sequências numéricas para representar dados categóricos: provavelmente vai funcionar, mas não é bom adicionar uma relação de ordem inexistente à representação. Nesse caso, provavelmente vai funcionar usando representação linear, mas não é bom ignorar o caráter circular da variável.

Talvez eu esteja chovendo no molhado, mas não vejo muitos códigos prontos em bibliotecas e não lembro de ter visto esse debate em outros lugares. Achei válidos fazer esses experimentos, porque apesar de intuitivamente fazer sentido, queria validar se a representação circular realmente leva a melhores resultados.

Mais detalhes de comos os experimentos foram realizados, estão nesse notebook. Recomendo dar uma olhada, porque essa implementação ensejou outro post: como desenvolver códigos usando a abordagem vetorial.