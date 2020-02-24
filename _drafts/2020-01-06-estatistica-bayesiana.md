---
layout: post
title: "O que é estatística bayesiana?"
comments: true
mathjax: true
description: "A intuição do debate entre as abordagens frequentistas e bayesianas"
keywords: "Estatística, Frequentista, Bayesiana"
---

Eu já ouvi muito se falar sobre um debate entre as abordagens bayesiana e frequentista na estatística, mas a verdade é que nunca entendi muito bem as diferenças. Por isso, decidi fazer o (ótimo) curso [Bayesian Statistics: From Concept to Data Analysis](https://www.coursera.org/learn/bayesian-statistics)[^1]. Ainda não me sinto completamente confortável com todos os conceitos, mas ajudou bastante a compreender melhor a questão.

[^1]: Muitos cursos do Coursera fazem parte de uma graduação, que tem acesso liberado por uma mensalidade. Esse é um curso isolado, o acesso a todo conteúdo e tarefas é gratuito, sendo necessário pagar apenas pelo certificado se for desejável.

Esse post é a minha tentativa de explicar o conceito, para quem precisa de uma definição maior que uma linha e menor que um curso.

## Conceito

A ideia do paradigma frequentista é que estamos lidando com uma série (hipotética) de eventos infinitos e observamos a frequência relativa dessa sequência de eventos. Por exemplo, um problema que se encaixaria bem nessa abordagem, seria o de estimar a perda de pacotes de um roteador. Acompanhando am quantidade de pacotes perdidas pelo roteador, é intuitivo enxergar os pacotes como uma série infinita e estimar a perda como $$ P(\text{Perda pacotes}) = \frac{1}{1000} $$. Por mais que não seja realmente infinito, é pouco custoso gerar um grande volume desses eventos.

Outros problemas não se encaixam tão facilmente nessa premissa. Estimar a proporção de caras e coroas de uma moeda seria razoável – um problema muito parecido com o do roteador inclusive – mas e definir com base nesses lançamentos se essa moeda honesta?

No paradigma frequentista, temos apenas duas respostas possíveis: $$ P(\text{Moeda Honesta}) = \{0,1\} $$. Apesar de podermos verificar essa probabilidade com vários lançamentos de moedas, o que queremos saber é sobre a moeda em si e essa informação não muda em face dos lançamentos.

Usando uma abordagem bayesiana, podemos interpretar a questão $$ P(\text{Moeda Honesta}) $$ como um palpite em relação a moeda. Duas pessoas, com informações diferentes sobre o problema, podem atribuir probabilidade diferentes a uma mesma moeda por exemplo. No framework bayesiano, podemos considerar uma hipótese inicial e atualiza-la à medida em que temos mais informações.

Imagino que continue pouco palpável a diferença entre as duas abordagens. Desenvolvendo melhor esse exemplo de definir se a moeda é justa, usando ambas as abordagens, acredito que os conceitos fiquem mais claras das implicações de um paradigma lidar com palpites enquanto outro não considera esse tipo de incerteza.

## Inferência frequentista

Primeiro, vamos observar o problema de definir $$ P(\text{Moeda Honesta}) $$ a partir de uma abordagem frequentista. A ideia é realizar uma série de $$ N $$ lançamentos da moeda e inferir a distribuição usando o [teorema do limite central](https://pt.wikipedia.org/wiki/Teorema_central_do_limite). 

Vamos supor que foram realizados 100 lançamentos de moeda, resultando em 44 caras e 56 coroas. Para efeitos de notação, vou definir cara como um \[S\]ucesso e coroa como \[F\]racasso. Interpretando esse problema como uma distribuição de Bernoulli, conseguimos chegar a um intervalo de confiança para a probabilidade $$ p $$ de um lançamento ser um sucesso.

$$
S = 44 \ F = 56 \\
X_{i} \sim Bernoulli(p) \\
\text{pelo CLT} \ \sum\limits_{i=1}^{100} \sim N(100p, 100p(1-p))
$$

Lembrando que aproxidamente 95% dos eventos em uma curva normal ficam entre 1,96 desvios-padrão, podemos encontrar o intervalo de confiança da seguinte forma:

$$
100p - 1.96\sqrt{100p(1-p)} \ \text{e} \ 100p + 1.96\sqrt{100p(1-p)}
$$

O valor de $$ \hat{p} $$ é simplesmente a proporção de caras: $$ \hat{p} = \frac{44}{100} $$. Substituindo-o na equação anterior:

$$
44 - 1,96\sqrt{44(0.56)} \ \text{e} \ 44 + 1,96\sqrt{44(0.56)} \\
44 \pm 9.7 = (34.3 , 53.7)
$$

Pelo intervalo de confiança, podemos afirmar com 95% de confiança que a moeda é justa. Isso significa que – se repetirmos esse experimento indefinidamente – 95% das vezes a média estará dentro do intervalo gerado usando os cálculos descritos acima. Além de ser uma afirmação pouco intuitiva, não nos fornece tantas informações como a mesma inferência realizada usando a abordagem bayesiana.

## Inferência Bayesiana

A inferência bayesiana nos ajuda a modelar melhor esse problema com os conceitos de distribuição *a priori* e *a posteriori*. No caso de nossa moeda, a distribuição *a priori* é referente a informação inicial que temos da moeda. Ou seja, o nosso palpite antes de observar qualquer experimento. A distribuição *a posteriori* é o nosso palpite mais a informação obtida com os experimentos. É um modelo bem intuitivo: temos um palpite inicial em relação ao valor de $$ P(\text{Moeda Honesta}) $$ e vamos atualizando ele à medida em que fazemos os experimentos. 

Na abordagem frequentista, não temos a ideia do palpite inicial, pois a intepretação é que a moeda tem uma distribuição real que funciona como uma característica física...como se encontrar a distribuição fosse um processo similar a medir o diâmetro dela.

### Simplificando a questão

Um problema da abordagem bayesiana é que ela é mais complexa de modelar em comparação a frequentista, então para começar é interessante trabalhar com uma hipótese mais simples do problema original.

Suponha que temos 5 lançamentos de moeda e apenas duas duas distribuições candidatas e temos o seguinte problema[^2]:

$$

\theta = \{\text{honesta}, \text{desonesta}\} \\
X \sim Bin(5, ?) \\
f(x \mid \theta) =
\begin{cases} 
    {5\choose x} \frac{1}{2}^5 \ \text{se} \ \theta = \text{honesta}  \\
    {5\choose x} (0.7)^x(0.3)^{(5-x)} \ \text{se} \ \theta = \text{desonesta}
\end{cases}

$$

[^2]: perceba que estamos usando a notação $$ f(x \mid \theta) $$ ao invés de $$ P(x \mid \theta) $$ porque – segundo o curso – é mais comum usar essa notação em estatística bayesiana.

De acordo com a definição acima, estamos considerando 5 lançamentos de moedas para definir se a moeda é honesta. Se $$ \theta = honesta$$, esperamos que o parâmetro $$ ? $$ (a probabilidade $$ p $$ da distribuição binomial) seja igual a $$ \frac{1}{2} $$. Por outro lado, se $$ \theta = desonesta$$, estamos esperando que o parâmetro $$ ? $$ seja igual a $$ 0.7$$.

Supondo que tivemos 2 sucessos em 5 lançamentos, podemos usar $$ x = 2 $$ para calcular a máxima verosssimilhança e inferir qual das duas distribuições é mais provável:

$$
f(\theta \mid 2) =
\begin{cases}
    {5\choose 2} \frac{1}{2}^5 = 0.3125 \ \text{se} \ \theta = \text{honesta} \\
    {5\choose 2} (0.7)^2(0.3)^{(5-2)} = 0.1323 \ \text{se} \ \theta = \text{desonesta}
\end{cases}
$$

A partir da comparação desses resultados, podemos inferir que a moeda está **mais** de uma distribuição honesta do que desonesta. Entretanto, não há uma resposta de **probabilidade** de cada uma das distribuições.

Sabemos que $$ f(\theta=honesta \mid x=2) > f(\theta=desonesta \mid x=2) $$, mas não sabemos o valor da probabilidade $$ f(\theta=honesta \mid x=2) $$. Lembre-se: o paradigma frequentista não considera $$ P(\theta=honesta) $$ como uma probabilidade, já que nessa abordagem essa questão é tratada como uma grande física no qual só temos dois valores possíveis  $$ \{0,1\} $$

### Bayes ao resgate

A abordagem bayesiana será útil para termos uma estimativa de $$ f(\theta=honesta \mid x=2) $$, o que não conseguimos obter pela abordagem frequentista. Como palpite inicial, vamos considerar que $$ P(\text{desonesta}) = 0.6 $$. Isso significa que, antes de qualquer experimento, entendemos que essa moeda tem uma chance ligeiramente maior de ser desonesta do que honesta.

Transformando o problema de máxima verossilhança para incluir a probabilidade *a priori*, chegamos a seguinte formulação do problema usando o teorema de Bayes:

$$
f(\theta \mid x) =  \frac{f(\theta \mid x)f(\theta)}{\sum_{\theta} f(\theta \mid x)f(\theta)}
$$

Adaptando os cálculos realizados para essa formulação, chegamos ao seguinte resultado para o problema [^3]:

[^3]: A função $$ I_{\{\text{condição}\}} $$ é chamada de [função indicadora](https://pt.wikipedia.org/wiki/Função_indicadora). Ela é apenas uma forma de escrever funções condicionais usando multiplicadore de 0 e 1.

{% raw %}{::nomarkdown}
    <div>
    $$
    f(\theta \mid x) = \frac{
        {5 \choose x} \left[\frac{1}{2}^5 \ .4 \ I_{\{\theta = \text{honesta}\}} + (.7)^x(.3)^{(5-x)} \ .6 \ I_{\{\theta = \text{desonesta}\}} \right]}
        {{5 \choose x} \left[\frac{1}{2}^5 \ .4 \ + \ (.7)^x(.3)^{(5-x)} \ .6 \right]}
    $$
    </div>
{:/}{% endraw %}

Na parte superior da equação, temos o mesmo cálculo usado na inferência anterior condicionado às probabilidade *a priori* de cada uma das hipóteses de distribuição: $$ P(\text{honesta}) = 0.4 $$ e $$ P(\text{desonesta}) = 0.6 $$. Na parte inferior, temos uma constante de normalização que considera a soma de todas as distribuições possíveis.

Substituindo pelos resultados dos experimentos nessa formulação nova, conseguimos estimar $$ f(\theta=honesta \mid x=2) $$:

{% raw %}{::nomarkdown}
    <div>
    $$
    f(\theta \mid x) = \frac
        {.0125 \ I_{\{\theta = \text{honesta}\}} + .0079 \ I_{\{\theta = \text{desonesta}\}} }
        {.0125 + .0079} \\
    f(\theta \mid x) = .612 \ I_{\{\theta = \text{honesta}\}} +  .388 \ I_{\{\theta = \text{desonesta}\}}
    $$
    </div>
{:/}{% endraw %}

Agora, nós temos uma resposta para $$ P(\theta=honesta \mid x=2) $$ que é $$ .612 $$. A questão proposta é definir se a moeda é justa e agora nós temos uma probabilidade para essa pergunta, considerando uma probabilidade *a priori* definida por nós e *a posteriori* a partir dos resultados dos experimentos.

Usando a abordagem bayesiana, temos uma resposta muito mais clara e informativa para o problema. Um porém, que pode incomodar alguns, é a questão de definirmos uma probabilidade *a priori* de forma subjetiva. o que é compreensível, já que um dos pontos de debate filosófico é justamente como [lidar com a priori](https://en.wikipedia.org/wiki/Prior_probability#Uninformative_priors) nos métodos bayesianos.

Nesse momento, acredito que já seja possível ter uma visão mais clara de quais as diferenças práticas e conceituais entre as duas abordagens.


### Complicando a questão

Para mostrar a diferença conceitual entre as duas abordagens, foi utilizada uma versão simplificada do problema em que temos apenas duas hipóteses de distribuições Imaginando um problema real, é mais provável que desejamos inferir $$ P(\theta=honesta) $$ sem definir quais são as outras distribuições desonestas possíveis.

Para isso, precisamos de uma abordagem contínua com uma distribuição *a priori* uniforme. Ou seja, consideramos inicialmente que todos os valores do parâmetro $$ p $$ da distribuição binomial são equiprováveis. Primeiramente, precisamos de uma versão contínua do teorema de bayes:

{% raw %}{::nomarkdown}
    <div>
    $$
    f(\theta \mid y) = \frac
        {f(y \mid \theta)f(\theta)}
        {f(y)} \\
    f(\theta \mid y) = \frac
        {f(y \mid \theta)f(\theta)}
        {\int f(y \mid \theta)f(\theta) d\theta} 
    $$
    </div>
{:/}{% endraw %}

A estrutura dessa forma contínua é a mesma da proposição na forma discreta, seguindo a estrutura $$\frac{\text{a posteriori} \ * \ \text{a priori}}{\text{constante de normalização}}$$.

Assumindo que $$ \theta \sim U[0,1] $$, podemos considerar que $$ f(\theta) = I_{\{0 \leq \theta \leq 1\}} $$. A distribuição *a posteriori* continua seguindo uma binomial, logo temos que $$ f(\theta \mid y) = \theta^y(1-0)^{(n-y)} $$. Para $$ Y= 1 $$ em um lanamento, conseguimos calcular facilmente a distribuição resultante:

{% raw %}{::nomarkdown}
    <div>
    $$
    f(\theta \mid y) = \frac{\theta^1(1- \theta)^0 \ I_{\{0 \leq \theta \leq 1\}}}
    {\int_\infty^\infty \theta^1(1- \theta)^0 \ I_{\{0 \leq \theta \leq 1\}} d\theta} = 
    
    \frac {\theta \ I_{\{0 \leq \theta \leq 1\}}}
    {\int_0^1 \theta d\theta} =

    2\theta \ I_{\{0 \leq \theta \leq 1\}}

    $$
    </div>
{:/}{% endraw %}

Nesse caso, estamos trabalhando com uma simples função linear. TESTANDO!

<figure>
  <img src="{{site.url}}/assets/images/lstm/validation_1.png"/>
</figure>
<figure>
  <img src="{{site.url}}/assets/images/lstm/validation_1.png"/>
</figure>

