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

Assim como a distribuição, a alternativa é lidar com a hora como se fosse um arco descrito em relação à meia-noite, basicamente como um relógio analógico:

$$
    hora_{r} = \frac{\pi}{2} - \frac{(hora + minutos/60)}{\pi/12}
$$

Para representar esses dados no plano cartesiano como coordenadas $$ x,y $$ – dentro do círculo trigonométrico de raio 1 – basta calcular o seno e o cosseno do ângulo calculado com a fórmula anterior.

$$
    f(hora_{r}) = (cos(hora_{r}), sin(hora_{r})) \\
    x, y = f(hora_{r})
$$

Na figura 2, podemos ver como ficam os mesmos dados representados após essa transformação.

<figure>
  <img src="{{site.url}}/assets/images/variaveis-circulares/representacao_circular.svg"/>  
  <figcaption>Figura 2 – Horários representados no círculo trigonométrico</figcaption>
</figure>