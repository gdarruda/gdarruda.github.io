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

Por padrão, a reposta é não. Para a maioria dos casos de uso, é uma solução pato: é mais caro e limitado em opções de peças comparado a um computador regular, mas não costuma chegar nem próximo da portabilidade e praticidade de um notebook.

Um bom motivo é falta de espaço, por isso é muito comum pensar em SFF para [HTPC](https://en.wikipedia.org/wiki/Home_theater_PC) ou jogar na sala. Mas se houver opção para usar um gabinete padrão pequeno — os chamados Mini Tower — você terá mais opções de hardware, custos menores e (provavelmente) será muito mais simples o processo de montagem e manutenção.

Eu teria espaço para um gabinete Mini Tower, meu motivo para investir tempo/dinheiro em um SFFPC pode ser resumido em algo como "quando um fã da Apple decide montar um desktop". 

A estética minimalista e discreta dos Macs, que aprecio, é praticamente a antítese do que se encontra em PCs gamer. Em geral, os gabinetes SFFPCs ofereces mais opções com visual mais discreto, mesmo os mais em conta.

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

Montar um SFFPC é inegavelmente mais caro, mas a grande dificuldade é combinar as peças. A "taxa ITX" que paguei — montando em plena pandemia com falta de peças no mundo todo e dólar nas alturas — estimo em 20%.  O maior custo, foi o tempo de pesquisa e tomada de decisão, sobre quais peças escolher.

Para ilustrar isso, nada melhor que a "série" ([1](https://www.youtube.com/watch?v=Fpe5wDBXpOI), [2](https://www.youtube.com/watch?v=ywgEEYDtsSE), [3](https://www.youtube.com/watch?v=x0pL5P3AIbw&t=530s) e [4](https://www.youtube.com/watch?v=9g4u88nfM1U)) sobre um PC ITX para jogar na sala do canal [Peperaio Hardware](https://www.youtube.com/user/PeperaioHardwareBR). 

Para resumir: inicialmente ficou com temperaturas muito altas, usar um cooler melhor não resolveu, trocou-se por um gabinete "melhor" e depois a fonte queimou nesse novo gabinete [^1]. 

[^1]:  Em relação a fonte, pode ser que tenha sido apenas um azar, mas ela foi montada invertida para funcionar como exaustor do processador...que me pareceu bem temerário e sem embasamento. Não vou assumir incompetência nessa série, porque esses problemas são "legais" para um canal do YouTube, além disso as peças parecem ter sido enviadas pelos parceiros e não escolhidas.

Usando essas mesmas peças, não haveria problema nenhum se fosse um gabinete torre comum. Para um SFFPC, deveria ter feito uma escolha mais criteriosa dos componentes.

Em ordem de prioridade, vou discutir os pontos de atenção na escolha de cada componente.

### Gabinete: o ponto de partida

Um gabinete pequeno tem limitações, é invevitável. O ponto é escolher quais limitações você prefere, que geralmente estão relacionados às opções de refrigeração, fonte, tamanho da GPU e armazenamento. 

Essas limitações geram um efeito cascata em várias outras decisões: 

* Se a refrigeração é limitada, não se pode usar qualquer processador. 
* Se for necessária uma fonte SFX, o custo extra pode comprometer o restante do orçamento.
* Colocar mais discos para armazenamento, pode limitar instalação de outros hardwares.

Nesse cenário, quanto mais simples for sua necessidade, mais opções de gabinete.

Eu optei pelo antiquado [CooleMaster Elite 110](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/elite110/?_escaped_fragment_=&_escaped_fragment_=#image-Item1), um modelo de 2014 e relativamente barato, focado em opções de armazenamento. Bem adequado para meu uso, mas não recomendo para configurações high-end, usando processadores de alto TDP e GPUs com mais de 21cm.

A grande vantagem desse gabinete, é suportar fontes convencionais ATX que são muito mais acessíveis no Brasil: metade do preço de uma SFX. Por outro lado, a fonte enorme acaba limitando bastante as opções de refrigeração, a altura máximo do cooler é 76mm com um fluxo de ar horrível.

A melhor opção para refrigerar processador, é um AIO de 120mm. Se as necessidades de refrigeração forem maiores que essa, recomendo fugir desse design de cubo. Vale citar que a montagem é trabalhosa, especialmente para organizar cabos da fonte, mas o painel frontal ajuda na tarefa.

Para quem deseja uma configuração básica ou intermediária, o Elite 110 é uma ótima opção no Brasil. Uma alternativa com design similar, mais compacta e com suporte a GPUs maiores, é o [Silverstone SG13](https://www.silverstonetek.com/product.php?pid=536&area=en).

Para quem está querendo montar algo bem simples e barato, com processador de baixo TDP e GPU integrada, pode fazer sentido considerar soluções voltadas para o mercado corporativo. 

Há gabinetes acessíveis e compactos focados no mercado empresarial, como os da [kmex](http://www.k-mex.com.br/produtos.asp?pag=Produtos&parent=gabinetes1&chave=130&tsb=Mini-ITX) por exemplo. O mercado de usados pode ser uma opção também, já que empresas com Dell e Lenovo costumam oferecer SFFPCs para uso em escritório.

Se o plano é montar uma configuração high-end, no Brasil acho que temos basicamente três opções: [Lian Li Pc-tu150 (1)](https://lian-li.com/product/pc-tu150/), [NZXT (2)](https://www.nzxt.com/products/h200i-matte-white) e [CoolerMaster NR200 (3)](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/masterbox-nr200/). 

Os três suportam GPUs grandes, cooler maiores e AIOs de 240mm. Entretanto, há vários detalhes a se considerar nessa faixa de preço, acredito que a melhor recomendação que posso dar é recorrer a reviews e comparações detalhadas. 

Infelizmente, só encontrei conteúdo estrangeiro (em vídeo) bom para avaliar esses gabinetes. No caso, os vídeos do Optimum Tech([1](https://www.youtube.com/watch?v=N5O6WZKERZ8), [2](https://www.youtube.com/watch?v=LqdcwwkGtpY&t=187s), [3](https://www.youtube.com/watch?v=8k1B2tai1yg&t=6s)) e Hardware Canucks ([1](https://www.youtube.com/watch?v=c3HcbOw1_YQ), [2](https://www.youtube.com/watch?v=AbDtYkmFzzU), [3](https://www.youtube.com/watch?v=aMP3-881X5o)).


### Fonte: fator Brasil

A questão da fonte é basicamente financeira, todos os modelos SFX com mais de 400W possuem preço inicial na faixa dos R$1000,00. São todas high-end, com altos valores de eficiência, cabos modulares e garantia de 7-10 anos.

Nesse segmento, a recomendação padrão são as Corsair da [linha SF](https://www.corsair.com/br/pt/Categorias/Produtos/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o-avan%C3%A7adas/SF-Series/p/CP-9020186-WW). Acompanhando os fóruns, parece ser disparada a fonte mais popular para SFFPCs high-end. 

Uma alternativa do mercado brasileiro, é optar por fontes SFX usadas da Seasonic, facilmente encontradas no Mercado Livre. É uma marca reconhecida e esses modelos são encontrados em computadores corporativos, entretanto não passam de 300W.

Se o gabinete suportar ATX, acredito que seja interessante considerar uma modular/semi-modular e compacta. Esses cabos de fonte inutilizados cabos são horríveis de organizar em gabinetes pequenos, acho que vale muito a pena pagar o custo adicional.

Eu optei por uma semi-modular, a [Masterwatt 450 TUF Gaming](https://www.coolermaster.com/br/pt-br/catalog/power-supplies/masterwatt/masterwatt-450-tuf-gaming-edition/) da CoolerMaster. É relativamente acessível e a ventoinha fica desligada em uso regular e mesmo quando ativa é pouca ruidosa.

Além de priorizar modulares, acredito que não haja nada de especial em escolher uma fonte ATX para SFFPCs.

### Placa de Vídeo: barato saiu caro

A única questão específica em relação a GPU, é ser compatível com o gabinete escolhido. O único ponto de atenção, é que isso normalmente significa optar por modelos mais básicos, com sistemas de refrigeração mais limitados.

Assumi que não era um problema para mim: primeiro porque optei por uma GTX 1650 porque é uma placa de baixo consumo, que nem exige conector adicional de energia[^2]. Segundo, que acho um exagero essa preocupação com temperatura, a não ser que você esteja minerando criptomoedas.

[^2]: A maioria dos modelos do mercado exige o conector de 6 pinos, inclusive a que comprei e dizia que não na [especificação](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD/sp#sp) ¯\\_(ツ)_/¯.

O problema é que a [GTX 1650 da Gigabyte](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD) compacta limita seu cooler a 68% da velocidade, que são incríveis 1800RPM. Parece algo comum em placas baratas, que usam coolers mais simples que não trabalham em velocidades menores e bloqueiam isso.

Para os meus padrões, era um barulho simplesmente insuportável e uma das minhas prioridades era justamente ter um sistema silencioso. Entre tentar editar a BIOS e fazer o que chamam de [deshroud da GPU](https://www.youtube.com/watch?v=QUaZVpN51Po), optei pela segunda opção. A substituição do hardware foi simples, mas conseguir controlar esse cooler com base na temperatura da GPU foi um inferno.

Em resumo, além da questão do tamanho, tome cuidado com placas que não desligam o cooler. Não sabia que existia isso e quase desisti de resolver, fique atento se o ruído for uma questão relevante.

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