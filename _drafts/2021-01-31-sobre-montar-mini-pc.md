---
layout: post
title: "Sobre montar um pequeno computador"
comments: true
description: "Um relato do trabalhoso processo de mntar um PC SFF"
keywords: 
---

Eu tenho usado notebooks como computador pessoal há uns 10 anos, mais especificamente MacBooks. Não jogo absolutamente nada, um processador razoável e 16GB de memória são plenamente suficientes para todos os meus usos: desenvolvimento, análise de dados e edição de fotos. 

Meu notebook atual contiua atendendo perfeitamente, mas mesmo assim decidi montar um PC nesse começo de ano. Algumas coisas me incomodam no meu notebook — especialmente barulho e temperatura — mas o grande motivo foi o tédio do isolamento durante a pandemia.

Suponho que montar computadores não seja o jeito mais convencional (ou barato) de lidar com o tédio do isolamento, mas curiosamente acho divertido o processo de fazer a curadoria de peças: equilibrar preço, necessidade e possibilidades futuras. Consegui deixar mais "divertido" ainda ao definir como meta montar o PC mais compacto possível, os chamados "Small Form Factor" ([SFF](https://en.wikipedia.org/wiki/Small_form_factor_(desktop_and_motherboard))).

Em geral, procuro escrever aqui conteúdo que considero útil e da forma mais concisa possível. Esse post é bem diferente, mais um relato desprentesioso e informal de um "hobby" marginalmente relacionado com tópicos como desenvolvimento ou ciência de dados.

Independente da motivação fraca, eu fiz uma pesquisa bem extensa e trabalhosa sobre o assunto. Há bastante informação em [fóruns](https://www.reddit.com/r/sffpc) e [canais internacionais](https://www.youtube.com/channel/UCRYOj4DmyxhBVrdvbsUwmAA), mas guias de compra e preço são quase inúteis na realidade brasileira.

Nesse cenário, decide ao menos indexar o testo. Assim o leitor pode ir direto para tópicos críticos de montagens SFF, como  escolha de gabinete, GPU e ventilação:

## Você deveria investir em um SFF?

Para explicar a minha motivação, vou seguir a lógica de um cientista de dados e definir o problema como uma otimização, em termos de prioridades e restrições.

E, antes de qualquer coisa, vou definir SFF como qualquer solução que não exija uma placa-mãe ITX.


### Restrições

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

adsaas