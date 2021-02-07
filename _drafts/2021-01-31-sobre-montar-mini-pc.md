---
layout: post
title: "Sobre montar um pequeno computador"
comments: true
description: "Um relato do trabalhoso processo de mntar um PC SFF"
keywords: 
---

Eu tenho usado notebooks como computador pessoal há uns 10 anos, mais especificamente MacBooks. Não jogo absolutamente nada, um processador razoável e 16GB de memória são plenamente suficientes para todos os meus usos: desenvolvimento, análise de dados e edição de fotos. 

Meu notebook atual contiua atendendo perfeitamente, mas mesmo assim decidi montar um PC nesse começo de ano. Algumas coisas me incomodam no meu notebook — especialmente barulho e temperatura — mas o grande motivo foi mesmo o tédio do isolamento durante a pandemia.

Suponho que montar computadores não seja o jeito mais convencional (ou barato) de lidar com o tédio do isolamento, mas curiosamente acho divertido o processo de fazer a curadoria de peças: equilibrar preço, necessidade e possibilidades futuras. Consegui deixar mais "divertido" ainda ao definir como meta montar um PC compacto, os chamados "Small Form Factor PC" ([SFFPC](https://en.wikipedia.org/wiki/Small_form_factor_(desktop_and_motherboard))).

Em geral, procuro escrever aqui conteúdo que considero útil e da forma mais concisa possível. Esse post é bem diferente, mais um relato desprentesioso e informal de um "hobby" marginalmente relacionado com tópicos como desenvolvimento ou ciência de dados.

Independente da motivação fraca, eu fiz uma pesquisa bem extensa e trabalhosa sobre o assunto. Há bastante informação em [fóruns](https://www.reddit.com/r/sffpc) e [canais internacionais](https://www.youtube.com/channel/UCRYOj4DmyxhBVrdvbsUwmAA), mas guias de compra e preço são quase inúteis na realidade brasileira.

## Você deveria investir em um SFF?

Por padrão, a reposta é não. Para a maioria dos casos de uso, é uma solução pato: é um custo adicional comparado a um computador padrão, mas não costuma ser pequeno o suficiente para ser transportado regularmente.

Uma razão legítima é falta de espaço, por isso é muito comum pensar em SFF para [HTPC](https://en.wikipedia.org/wiki/Home_theater_PC) ou jogar na sala. Mas se houver opção para usar um gabinete padrão pequeno — os chamados Mini Tower — você terá mais opções de hardware, custos menores e (provavelmente) será muito mais simples o processo de montagem e manutenção.

Eu teria espaço para um gabinete Mini Tower, meu motivo para investir tempo/dinheiro em um SFFPC pode ser resumido em algo como "quando um fã da Apple decide montar um desktop". 

A estética minimalista e discreta dos Macs que aprecio, é praticamente a antítese do que se encontra em PCs gamer. Em geral, os gabinetes SFFPCs ofereces mais opções com visual mais discreto, mesmo os mais em conta.

O desperdício de espaço dos gabinetes tipo torre me incomoda, foi uma decepção quando abri um gabinete pela primeira vez e encontrei todo aquele espaço sem uso. Prefiro ver espaço bem utlizado, que espaço extra que não pretendo usar como expansão PCI Express ou múltiplas baias para HD 3.5.

Se dinheiro não fosse problema, meu gabinete certamente seria um [FormdD T1](https://formdworks.com/products/t1) ou [Louqe Ghost S1](https://www.amazon.com/LOUQE-Ghost-Limestone-Mini-ITX-Computer/dp/B088QTJMKW/ref=sr_1_1?dchild=1&keywords=LOUQE&qid=1612651341&sr=8-1). É gratificante ver tanto hardware em um espaço tão reduzido e bem pensado:

<iframe 
    width="560" 
    height="315" 
    src="https://www.youtube-nocookie.com/embed/Ou4iWsBNSmY" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
</iframe>

Alguém pragmático não veria sentido algum: gastar mais de $200,00 em um gabinete que vem desmontado, limitaria escolhas de hardware e seria um horror para montar e atualizar as peças. Limitação bônus: sem I/O na frente e com botão de ligar escodindo na parte traseira.

No final, para encarar um SFFPC por vontade, é preciso ser uma mistura peculiar de usuário Apple e Arch Linux.

De um lado, querer um hardware estilo Apple, com design industrial meio obsessivo ao ponto de poder incorrer em [dificuldades desnecessárias](https://9to5mac.com/wp-content/uploads/sites/6/2019/06/Magic-Mouse-problem.jpeg?quality=82&strip=all), [limitações](https://www.theverge.com/2017/4/4/15175994/apple-mac-pro-failure-admission) e [overengineering](https://www.ifixit.com/Teardown/Mac+Pro+2019+Teardown/128922). De outro, é estar disposto a seguir um [caminho bem tortuoso](https://wiki.archlinux.org/index.php/Arch_Linux#User_centrality) para ter as coisas exatamente do seu jeito.

## Escolhendo as peças

Para escolher peças em um SFFPC, a prioridade das escolhas é bem diferente. Por isso, vou listas minhas escolhas e recomendações, na ordem que entendo como ideal para um SFFPC.


<!-- ### Restrições

As restrições eram poucas, mas é um ponto de partida para definir se fazia o mínimo sentido andar com o projeto.

* Especificações iguais ou superiores ao meu [notebook atual](https://support.apple.com/kb/SP756?locale=pt_BR).

* Caber sobre a mesa: 35 cm (L) e 50 cm (P).

* Rede Wi-Fi 

### Objetivos

Não seria complicado fazer o básico para atender às restrições, mas investi muito tempo para chegar na solução ótima, equilibrando esses objetivos na seguinte ordem de prioridade:

* Ruído baixo.

* Ocupar o mínimo de espaço, especialmente em termos de área (footprint).

* Qualidade de construção e estética.

* Relação custo/performance.

* Intangíveis

Para que outros possam usar de referência, vou detalhar o que cada objetivo desse funciona e como optar por SFF impacta esse objetivo. 

#### Ruído baixo - neutro

Se não houver nada errado, o único barulho relevante do seu computador deve vir da refrigeração. Nesse sentido, quando falamos de baixo ruído, estamos falando da qualidade do "airflow" do seu gabinete.

Execto casos extremos — CPU/GPU de alta performance em gabinetes muito pequenos — normalmente não é um problema. Entretanto, é bom possível que saia mais caro por opções limitadas pelo layout do gabinete. Mas diria que o maior custo é em pesquisa, do que em custo.

Por outro lado, se a prioridade for menor temperatura, SFF pode ser um problema. Talvez seja polêmico, mas acho que a preocupação com essas temperaturas é muito exagerada entre entusiastas, incorrendo em gastos e preocupações exageradas.

Normalmente, notebooks trabalham em temperaturas muito altas, especialmente os MacBooks a partir de 2016 como o que uso. Isso gera muito barulho, calor no chassi e perda de desempenho — duramente (e justamente) criticados por muitos — mas não há relatos deles falhando.

Naturalmente, é melhor para a durabilidade do hardware trabalhar em temperaturas mais baixas, mas os impactos em durabilidade para uso regular me parecem bem exagerados.

#### Espaço - ótimo

adsaas -->