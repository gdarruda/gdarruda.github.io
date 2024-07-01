---
layout: post
title: "Código limpo, positivismo e fotografia"
comments: true
mathjax: false
description: "Refletindo sobre código limpo"
keywords: "clean code, engenharia de software"
---

Os conhecimentos em engenharia de software são um requisito universal para qualquer tipo de programador, especialmente os mais experientes. Diferente dos [desafios de programação](https://x.com/mxcl/status/608682016205344768?lang=en), não há muita discussão sobre a relevância da engenharia de software no dia-a-dia. Há um consenso sobre a importância de escrever um código que seja "limpo": não basta funcionar, precisa ser fácil de evoluir e sustentar. A questão complicada, é como definir e construir código limpo.

Imagino que a maioria aceite que existe um grau de subjetividade no que tange qualidade de código. Não existe um "ideal platônico" de código, que pode ser criado sistematicamente seguindo uma série de passos. Mas o quanto a engenharia de software pode nos ajudar a reduzir essa subjetividade?

## O positivismo da engenharia de software

As várias [definições de engenharia de software](https://en.wikipedia.org/wiki/Software_engineering#Definition), normalmente destacam seu caráter sistemático e científico, como a definição da IEEE por exemplo:

> The systematic application of scientific and technological knowledge, methods, and experience to the design, implementation, testing, and documentation of software

Quando se discute as limitações da engenharia de software, normalmente é levado em conta o fato de ser uma nova área de conhecimento. Aos poucos, esse rol de métodos e conhecimentos da engenharia de software está sendo construído, os problemas atuais são uma questão de maturidade.

É uma perspectiva [positivista](https://en.wikipedia.org/wiki/Positivism) da situação: seja pela ideia de seguir uma metodologia científica para construção do conhecimento real (positivo), seja pela perspectiva de estarmos nos primeiros passos de uma área  [complexa e específica](https://en.wikipedia.org/wiki/Auguste_Comte#/media/File:Theory_of_Science_by_A._Comte.svg) na hierarquia de Comte.

Uma área próxima, que evoluiu de acordo com o positivismo, é o design de banco de dados. Existiam várias abordagens para o problema, mas o modelo de [representação relacional](https://en.wikipedia.org/wiki/Relational_model) se consolidou nos anos 70 e os conceitos se mantiveram até os dias de hoje. Surgiram alternativas aos bancos relacionais, mas o aspecto interessante é como dominamos o seu uso: os métodos são bem definidos, já vi modelos lógicos criados na década de 80 que eu desenharia da mesma forma hoje.

A minha percepção no início da carreira – fim dos anos 2000, início dos anos 2010 – era que a orientação a objetos seguiria o mesmo caminho do modelo relacional. Pode ter sido ser sido a ingenuidade de um iniciante, mas eu imaginava que existiria um análogo às [regras de normalização](https://en.wikipedia.org/wiki/Database_normalization) para modelagem de classes.

Alguém lembra de [UML](https://en.wikipedia.org/wiki/Unified_Modeling_Language)? A ideia era que poderíamos ter uma documentação tão precisa, que alguém poderia traduzir em código em uma fábrica de software do outro lado do mundo. Uma solução temporária, porque logo mais seria possível gerar [código automaticamente](https://www.ibm.com/support/pages/how-create-uml-code-transformation-rsa) a partir de UML, alcançado o sonhado low-code que [já discuti](/2024/01/20/low-code-dilema) em outra oportunidade.

A orientação a objetos foi largamente adotada no desenvolvimento de sistemas e trouxe avanços, mas não se chegou a um método rigoroso e sistemático. Pode-se enxergar como um erro de percurso – que podemos evoluir a orientação a objetos, misturar com outros paradigmas, criar um completamente novo – ou entender que não existe um percurso.

É completamente razoável, a ideia de sistematizar uma área derivada da computação, mas talvez a parcela de computação do problema que queremos resolver seja muito pequena. A engenharia de software, não estaria sofrendo de [inveja da física](https://en.wikipedia.org/wiki/Physics_envy)?

## Software como processo criativo

O livro Clean Code era uma recomendação padrão sobre  engenharia de software, mas nos últimos anos tem sido questionado [[1](https://qntm.org/clean), [2](https://overreacted.io/goodbye-clean-code/), [3](https://theaxolot.wordpress.com/2024/05/08/dont-refactor-like-uncle-bob-please/)], discussões sobre Uncle Bob e o livro tendem a ser acaloradas  [[1](https://www.reddit.com/r/csharp/comments/1cwbv37/is_clean_code_dead/), [2](https://www.reddit.com/r/programming/comments/hhlvqq/its_probably_time_to_stop_recommending_clean_code/), [3](https://news.ycombinator.com/item?id=22022466), [4](https://news.ycombinator.com/item?id=34966137), [...](https://www.hillelwayne.com/post/uncle-bob/)].

Não quero discutir o mérito do livro em si – se ele ficou datado ou se nunca foi bom para início de conversa – mas pensar na forma que o consumimos. Seria um debate menos polêmico, se tratássemos desenvolvimento como um processo criativo, mais parecido com fotografia[^1] que construção de pontes.

[^1]: Escrita literária provavelmente seria uma analogia melhor, mas conheço mais sobre fotografia. Meu um único traço de personalidade é ter fotografia como hobby, todo o resto é ser um programador.

O Clean Code não deve ser lido como um guia de práticas, mas uma obra influente na época em que foi escrita. Ler como formação de repertório, para entender como as coisas eram feitas e como chegamos aqui, da mesma forma que tratamos os clássicos do cinema e literatura por exemplo.

No capítulo introdutório, Uncle Bob até faz uma analogia de programação com o processo criativo.

> Considere esse livro como uma descrição da Escola de Código Limpo da Object Mentor. As técnicas e ensinamentos são a maneira pela qual praticamos nossa arte. Estamos dispostos a alegar que se você seguir esses ensinamentos, desfrutará de benefícios que também aproveitamos e aprenderá a escrever códigos limpos e profissionais. Mas não pense que estamos 100% "certos". Provavelmente há outras escolas e mestres que têm tanto para oferecer quanto nós. O correto seria que você aprendesse com elas também.

Por outro lado, o restante do livro tem outro tom. São muitas afirmações assertivas e prescritivas de como as coisas devem ser, conclusões unilaterais sobre aspectos subjetivos. Um exemplo dessa postura, é essa afirmação sobre parâmetros das funções:

> A quantidade ideal de parâmetros para uma função é zero (nulo). Depois vem um (mônade), seguido de dois (díade). Sempre que possível devem-se evitar três (tríade) parâmetros. Para mais de três (políade) deve ter um motivo muito especial – mesmo assim não devem ser usados.

É uma preferência do autor, mas escrita como um lema matemático. Uma opinião que está no contexto da linguagem Java de 2008: sem parâmetros com valor padrão, orientada a objetos e sem suporte a funções de alta ordem. A escrita reflete a visão positivista, apesar de não ser um conhecimento de caráter científico.

Pessoalmente, acho (bem) estranha essa aversão a parâmetros, mesmo para a época em que foi escrito o livro. Posso citar vários argumentos sobre o porquê discordo, mas é possível encerrar essa discussão? A proposição não é sustentada por um experimento ou algum outro tipo de evidência científica, mas meus argumentos contrários também não.

Mesmo que você também discorde dessa ideia, ainda é interessante conhecê-la. Dada a influência do livro, muitos códigos foram criados seguindo essa premissa e novos seguirão sendo criados, independente da opinião individual sobre o tema.

Seria melhor, se tratássemos esse tipo de afirmação mais como "regras" de composição da fotografia (*e.g.* [regra dos terços](https://www.adobe.com/br/creativecloud/photography/discover/rule-of-thirds.html#:~:text=O%20que%20é%20a%20regra,fotos%20atraentes%20e%20bem%20estruturadas.), [espaço negativo](https://www.epics.com.br/blog/o-que-e-espaco-negativo-na-fotografia) e [linhas principais](https://annphoto.net/fotografia/quais-sao-as-linhas-principais-e-como-usa-los-em-fotos/)), do que como um método de engenharia.

A regra dos terços tem uma [longa história](https://petapixel.com/2024/06/27/the-true-photographic-history-of-the-rule-of-thirds-and-golden-mean/), originando-se na [escola pictorialista](https://en.wikipedia.org/wiki/Pictorialism) dos primórdios da fotografia. Voltou a tona com a popularização das câmeras fotográficas entre fotógrafos amadores – é uma regra objetiva e prática, assim como a questão de parâmetros – que a torna atraente para iniciantes. O teor científico torna a regra atraente, mas seu reducionismo já era era criticado pelo famoso fotógrafo [Henri Catier-Bresson](https://en.wikipedia.org/wiki/Henri_Cartier-Bresson) na década de 50:

> In applying the Golden Rule, the only pair of compasses at the photographer’s disposal is his own pair of eyes. Any geometrical analysis, any reducing of the picture to a schema, can be done only (because of its very nature) after the photograph has been taken, developed, and printed — and then it can be used only for a postmortem examination of the picture. I hope we will never see the day when photo shops sell little schema grills to clamp onto our viewfinders; and the Golden Rule will never be found etched on our ground glass.

Não existe uma ciência por trás das técnicas de composição, mas também não existe a ambição de ser algo científico. Sem essa pretensão, os debates ficam mais leves e não se espera uma aplicação sistemática sem reflexão. Um fotógrafo experiente conhece as regras, mas as quebra quando necessário.

O Clean Code é um conteúdo indiscutivelmente importante pela relevância – mas que deve ser consumido com parcimônia e olhar crítico – e nós programadores não estamos acostumados com isso.

## Diferentes escolas

É uma situação complicada, quando sua opinião vai em direção oposta a alguém renomado. Quem sou eu para discordar do Uncle Bob, autor de vários livros influentes? Talvez, essa anedota do encontro do fotógrafo [Willian Eggleston](https://en.wikipedia.org/wiki/William_Eggleston) com o supracitado Henri Catier-Bresson, tenha algo a nos ensinar:

<blockquote>

<strong>William Eggleston</strong>: You know, I had a meeting with him [Henri Cartier-Bresson], one in particular, it was at this party in Lyon. Big event, you know. I was seated with him and a couple of women. You’ll never guess what he said to me.<br>
<br>
<strong>Drew Barrymore</strong>: What?<br>
<br>
<strong>William Eggleston</strong>: “William, color is bullshit.” End of conversation. Not another word. And I didn’t say anything back. What can one say? I mean, I felt like saying I’ve wasted a lot of time. As this happened, I’ll tell you, I noticed across the room this really beautiful young lady, who turned out to be crazy. So I just got up, left the table, introduced myself, and I spent the rest of the evening talking to her, and she never told me color was bullshit.

</blockquote>

Esse tipo de dissidência é comum no processo criativo, é pressuposto e importante que surjam diversas linhas de pensamento. Em computação, estamos sempre procurando convergir para uma solução ótima, é desconfortável aceitar que existam múltiplos caminhos sem um vencedor claro. É importante estar confortável com divergências, porque qualidade de código é sobre os outros.

Se formos definir o [principal motivo](https://www.youtube.com/watch?v=ug8XX2MpzEw&t=2224s) para fazer códigos limpos, é que seja possível modificá-lo no futuro. Um código que nunca será alterado, é indiferente a essa questão. Em geral, a ideia é que várias pessoas consigam mexer no código, não somente o autor. Logo, a sua ideia de código limpo precisa ser compartilhada com outras pessoas que trabalharão nele, senão ela perde o sentido.

Quando comecei a trabalhar na área de dados, passei a lidar com profissionais e problemas mais heterogêneos e isso me ajudou a enxergar a importância do contexto nas discussões sobre código. Por exemplo, o que é código limpo para esse cenários:

1. cientistas de dados acostumados com [programação vetorial](https://en.wikipedia.org/wiki/Array_programming), preparando dados para entrada em uma rede neural;

2. analista de negócio, querendo apenas substituir uma planilha Excel cheia de macros por um Jupyter Notebook;

3. desenvolvedor back-end acostumado com conceitos como DTOs, polimorfismo, interfaces, injeção de dependência, etc.

A melhor solução para cada problema, provavelmente é um *anti-pattern* para os demais. Por exemplo, normalmente prefiro manter códigos repetidos ao invés de usar polimorfismo no cenário (2), o que não faria sentido para o cenário (3).

Obviamente tenho minhas preferências, mas elas não sobrepõem as necessidades dos  "clientes" do meu código, as pessoas que precisarão mantê-lo. Não existe código limpo *a priori* – o que está sendo feito e para quem – definem o que é ser limpo.

## Não se abstenha

O meu argumento é que devemos conviver melhor com diversas perspectivas de código limpo, mas há um risco em adotar uma postura muito flexível. Abster-se de uma decisão e acabar com um código insustentável para manter.

É importante identificar as brigas corretas, afinal discussões podem ser cansativas e gerar desgastes, não queremos gastar energia com debates infrutíferos. Infelizmente, não sei dizer um modo de diferenciar os cenários: esse código é ruim e insustentável ou é simplesmente diferente do que estou acostumado?

Só posso sugerir criação de repertório para responder essa pegunta, explorar problemas e tecnologias diferentes com a cabeça aberta. Dar-se um tempo para se sentir confortável, tomar cuidado para não adotar posições dogmáticas prematuras. Por fim, o mais difícil: aceitar que nem sempre iremos gostar.

Willian Eggleston pôde seguir com sua fotografia colorida, a despeito da opinião de Henri Cartier-Bresson sobre ela. Você também pode seguir suas preferências em seu projeto pessoal, mas não em um contexto profissional. Assim como artistas fazem concessões em trabalhos comerciais, devemos fazer o mesmo pelo time.

Sugeri inspiração no processo criativo para desenvolvimento de software, mas essa é uma diferença fundamental: o seu código deve ser limpo para os outros, não para você. Seja lá, o que código limpo significa.