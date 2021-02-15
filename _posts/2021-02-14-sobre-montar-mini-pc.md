---
layout: post
title: "Sobre montar um pequeno computador"
comments: true
description: "Um relato do trabalhoso processo de mntar um PC SFF"
keywords: 
---

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7293.jpg"/>
<figcaption>Lata de 410ml para escala</figcaption>

Eu tenho usado notebooks como computador pessoal há uns 10 anos, são suficientes para minhas necessidades. Não jogo, então um processador razoável e 16GB de memória, atendem plenamente todos os meus usos: desenvolvimento, análise de dados e edição de fotos. Mesmo assim, decidi montar um PC.

Meu maior incômodo com os últimos MacBooks, é como ficam quentes e são barulhentos para tarefas triviais. Além desse incômodo, eventualmente sinto falta de ter um computador de backup, com Windows instalado.

Mas sem tentar me enganar, o real motivo é que eu simplesmente gostei da ideia de montar um PC no meio desse ócio pandêmico. Mesmo em um cenário de escassez de peças e dólar disparado, que talvez seja o pior momento das últimas décadas para fazer isso.

Suponho que montar computadores não seja o jeito mais convencional (ou barato) de lidar com o tédio do isolamento, mas curiosamente acho divertido o processo de curadoria das peças: equilibrar preço, necessidade e possibilidades futuras. Para mais "diversão", defini como meta montar um PC compacto, os chamados Small Form Factor PCs ([SFFPCs](https://en.wikipedia.org/wiki/Small_form_factor_(desktop_and_motherboard))).

Independente da motivação duvidosa, eu fiz uma pesquisa bem extensa e trabalhosa sobre o assunto. Há bastante informação em [fóruns](https://www.reddit.com/r/sffpc) e [canais](https://www.youtube.com/channel/UCRYOj4DmyxhBVrdvbsUwmAA), mas guias de compra e preço são quase inúteis na realidade brasileira. Nesse cenário, acho que pode ser útil discutir como montar um SFFPC com peças disponíveis no Brasil.

Em geral, procuro escrever aqui conteúdo que considero útil e da forma mais concisa possível. Esse post é um pouco diferente, mais um relato despretensioso e informal de um projeto pessoal, que talvez seja útil para alguém.

## Você deveria investir em um SFF?

Por padrão, a reposta é não. Para a maioria dos casos de uso, é uma solução pato: é mais caro e limitado comparado a um computador de tamanho regular, mas não costuma chegar nem próximo da portabilidade e praticidade de um notebook.

Para alinhar conceitos: não existe um definição objetiva de SFF, mas vou considerar pequeno o que não ultrapassa 20 litros de volume.

Um motivo legítimo para optar por um SFFPC é falta de espaço, por isso é muito comum pensar neles para [HTPC](https://en.wikipedia.org/wiki/Home_theater_PC) ou jogar na sala. Mas se houver a possibilidade de usar um gabinete ATX compacto — os chamados Mini Tower — você terá mais opções de hardware, custos menores e (provavelmente) será muito mais simples o processo de montagem e manutenção.

Eu poderia ter optado por um Mini Tower. Meu motivo, para investir tempo/dinheiro em um SFF, pode ser resumido em algo como "quando um fã da Apple decide montar um desktop". 

A estética, minimalista e discreta dos Macs, é praticamente a antítese do que se encontra em PCs gamer. Em geral, os gabinetes SFF têm mais opções com visual discreto, mais Apple e menos Alienware por assim dizer.

Fora estética, o desperdício de espaço dos gabinetes tipo torre me incomoda, especialmente para hardware simples como o meu. É frescura pura e até irracional, mas prefiro ter espaço bem otimizado que espaço extra sem uso. Se dinheiro não fosse problema, meu gabinete certamente seria um [FormdD T1](https://formdworks.com/products/t1) ou [Louqe Ghost S1](https://www.amazon.com/LOUQE-Ghost-Limestone-Mini-ITX-Computer/dp/B088QTJMKW/ref=sr_1_1?dchild=1&keywords=LOUQE&qid=1612651341&sr=8-1).

<iframe 
    width="560" 
    height="315" 
    src="https://www.youtube-nocookie.com/embed/Ou4iWsBNSmY" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
</iframe>

Alguém pragmático, não veria sentido algum: gastar mais de $200,00 em um gabinete que vem desmontado, limitaria escolhas de hardware e seria um horror para montar e atualizar. Limitação bônus: sem I/O na frente e com botão de ligar escondido na parte traseira.

São questões válidas, que ilustram bem a ideia: para encarar um SFFPC, por vontade e não por necessidade, é preciso ser uma mistura peculiar de usuário Apple e Arch Linux.

De um lado, querer um hardware estilo Apple, com design industrial meio obsessivo e desnecessário ao ponto de poder incorrer em [dificuldades](https://9to5mac.com/wp-content/uploads/sites/6/2019/06/Magic-Mouse-problem.jpeg?quality=82&strip=all), [limitações](https://www.theverge.com/2017/4/4/15175994/apple-mac-pro-failure-admission) e [overengineering](https://www.ifixit.com/Teardown/Mac+Pro+2019+Teardown/128922). De outro, é estar disposto a seguir um [caminho bem tortuoso](https://wiki.archlinux.org/index.php/Arch_Linux#User_centrality) parar chegar ao objetivo, ao invés de simplesmente comprar um Mac ou outra solução pronta.

## A (difícil) escolha de peças

Montar um SFFPC é inegavelmente mais caro e trabalhoso, mas o maior problema é combinar as peças. 

Em termos financeiros — montando em plena pandemia, com falta de peças no mundo todo e dólar nas alturas — estimo em 15% a mais de custo, comparado a uma configuração similar em um gabinete padrão. Por outro lado, o custo em tempo de pesquisa e tomada de decisão, estimo em mais que o dobro para SFF.

Para ilustrar isso, nada melhor que a "série" ([1](https://www.youtube.com/watch?v=Fpe5wDBXpOI), [2](https://www.youtube.com/watch?v=ywgEEYDtsSE), [3](https://www.youtube.com/watch?v=x0pL5P3AIbw&t=530s) e [4](https://www.youtube.com/watch?v=9g4u88nfM1U)) sobre um PC compacto para jogar na sala, do canal [Peperaio Hardware](https://www.youtube.com/user/PeperaioHardwareBR). 

Resumo da história: inicialmente o processador ficou com temperaturas muito altas, trocar o cooler por um melhor não resolveu. O hardware foi movido para um gabinete "melhor", mas mesmo assim a fonte queimou nesse novo gabinete [^1]. 

[^1]:  Em relação a fonte, pode ser que tenha sido apenas um azar, mas ela foi montada invertida para funcionar como exaustor do processador...que me pareceu bem temerário e sem embasamento. Não quero criticar no texto, porque eu não cheguei a uma conclusão. 

Usando as mesmas peças da primeira montagem, em um gabinete comum, provavelmente não teriam ocorrido problemas. 

A configuração que montei é bem equivalente, colocada em um gabinete do mesmo tamanho: tenho zero problemas de temperatura e ruído. Não foi livre de problemas, mas a escolha cuidadosa de peças reduziu muitos custos extras e dores de cabeça posteriores.

Destacada a importância da escolha de peças, vou discutir os pontos de atenção na escolha de cada componente, em ordem de prioridade:

1. [Gabinete: o ponto de partida](#gabinete)
2. [Fonte: fator Brasil](#fonte)
3. [Refrigeração: o seu limite](#refrigeração)
3. [Placa de Vídeo: o barato saiu caro](#gpu)
4. [Armazenamento: M.2 sempre que possível](#armazenamento)
5. [Placa-mãe: só aceita](#mobo)
6. [Processador: cuidado com TDP](#processador)
7. [Memória: low-profile](#memoria)

A ideia desse guia é que você tenha em mente as configurações e necessidades, mas ainda esteja avaliando o custo e a complexidade de colocar essa configuração em um gabinete compacto. Um guia completo ficaria muito extenso, incompleto e rapidamente desatualizado. 

### <a name="gabinete"> Gabinete: o ponto de partida </a>

Um gabinete pequeno tem limitações, é inevitável. O ponto é escolher quais limitações você prefere, que normalmente estão relacionados às opções de refrigeração, tipo de fonte, tamanho da GPU e armazenamento. 

Essas limitações geram um efeito cascata em várias outras decisões: 

* Se a refrigeração é limitada, não se pode usar qualquer processador. 
* Se for necessária uma fonte SFX, o custo extra pode comprometer o restante do orçamento.
* Colocar mais discos para armazenamento, pode limitar instalação de outros hardwares.

Nesse cenário, quanto mais simples for a necessidade, mais opções de gabinete.

Eu optei pelo antiquado [Cooler Master Elite 110](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/elite110/?_escaped_fragment_=&_escaped_fragment_=#image-Item1), um modelo de 2014 e relativamente barato, focado em opções de armazenamento. Mostrou-se bem adequado para minhas necessidades, mas não recomendo para configurações high-end, que usem processadores de alto TDP e GPUs com mais de 21cm.

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7210.jpg"/>
<figcaption>O "cubo" Elite 110</figcaption>

A grande vantagem desse gabinete, é suportar fontes convencionais ATX, que são muito mais acessíveis no Brasil: metade do preço de uma SFX. Por outro lado, o espaço extra que a fonte ATX ocupa, acaba limitando bastante as opções de refrigeração.

Vale citar que a montagem é trabalhosa nesse gabinete, especialmente a organização de cabos usando o painel frontal.

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7309.jpg"/>
<figcaption>Usando o painel frontal para passar os cabos</figcaption>

Para quem deseja uma configuração básica ou intermediária, o Elite 110 é uma ótima opção no Brasil. Uma alternativa com design similar, mais compacta e com suporte a GPUs maiores, é o [Silverstone SG13](https://www.silverstonetek.com/product.php?pid=536&area=en).

Para quem está querendo montar algo bem básico, com processador de baixo TDP e GPU integrada, pode fazer sentido considerar soluções voltadas para o mercado corporativo. Há gabinetes acessíveis e compactos focados no mercado empresarial, como os da [K-MEX](http://www.k-mex.com.br/produtos.asp?pag=Produtos&parent=gabinetes1&chave=130&tsb=Mini-ITX) por exemplo. 

Por outro lado, se o plano é montar uma configuração high-end, no Brasil acho que temos basicamente três opções de gabinete: [Lian Li Pc-tu150 (1)](https://lian-li.com/product/pc-tu150/), [NZXT H210 (2)](https://www.nzxt.com/products/h200i-matte-white) e [Cooler Master MasterBox NR200 (3)](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/masterbox-nr200/). 

Os três suportam GPUs grandes e mais opções de refrigeração. Entretanto, há vários detalhes a se considerar nessa faixa de preço, acredito que a melhor recomendação que posso dar é recorrer a reviews e comparações detalhadas. 

Infelizmente, só encontrei conteúdo estrangeiro bom para avaliar esses gabinetes. No caso, os vídeos do Optimum Tech([1](https://www.youtube.com/watch?v=N5O6WZKERZ8), [2](https://www.youtube.com/watch?v=LqdcwwkGtpY&t=187s), [3](https://www.youtube.com/watch?v=8k1B2tai1yg&t=6s)) e Hardware Canucks ([1](https://www.youtube.com/watch?v=c3HcbOw1_YQ), [2](https://www.youtube.com/watch?v=AbDtYkmFzzU), [3](https://www.youtube.com/watch?v=aMP3-881X5o)).


### <a name="fonte"> Fonte: fator Brasil </a>

A questão da fonte é basicamente financeira, todos os modelos SFX com mais de 450W possuem preço inicial na faixa dos R$1000,00. São todas high-end, com altos valores de eficiência, modulares e garantia de 7-10 anos.

Nesse segmento, a recomendação padrão são as Corsair da [linha SF](https://www.corsair.com/br/pt/Categorias/Produtos/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o-avan%C3%A7adas/SF-Series/p/CP-9020186-WW). Acompanhando os fóruns, parece ser a fonte mais popular e bem avaliada para SFFPCs high-end. Há alternativas SFX da Cooler Master e Silverstone no Brasil, mas dado que os preços estão na mesma faixa da Corsair, não vejo muitos motivos para arriscar outra marca.

Uma opção para configurações simples, é optar por fontes SFX usadas da Seasonic, facilmente encontradas no Mercado Livre. É uma marca reconhecida e esses modelos são usados em computadores corporativos, entretanto elas não passam de 300W.

Se o gabinete suportar ATX, acredito que seja interessante optar por um modelo de fonte com cabos modulares/semi-modulares e compacto. Cabos de fonte são horríveis de organizar em gabinetes pequenos, podendo inclusive comprometer a ventilação.

Eu optei por uma ATX semi-modular, a [Masterwatt 450 TUF Gaming Edition](https://www.coolermaster.com/br/pt-br/catalog/power-supplies/masterwatt/masterwatt-450-tuf-gaming-edition/) da Cooler Master. É relativamente acessível, além de funcionar com a ventoinha desligada, quando o consumo de energia é baixo.

Fora priorizar modelos modulares e compactos, acredito que não haja nada de especial em escolher uma fonte para SFF. A fonte só está em segundo nessa lista, devido aos preços altíssimos dos modelos SFX no Brasil.

### <a name="refrigeração"> Refrigeração: o seu limite </a> 

Os gabinetes com layouts diferentes costumam limitar bastante as opções de refrigeração, então é bom verificar com cuidado a compatibilidade. Além do espaço físico disponível, o fluxo de ar interno também pode ser limitado.

O Elite 110 suporta coolers de apenas 76cm e o fluxo de ar é bem ruim. Poderia usar o cooler box da Intel, mas como minha prioridade ao montar o computador era reduzir o barulho, investi em um de [AIO de 120mm](https://www.coolermaster.com/br/pt-br/catalog/coolers/cpu-liquid-coolers/masterliquid-ml120l-v2-rgb/) da Cooler Master.

Um cooler de baixo perfil bom sairia por um preço alto e, como mostram os resultados [desse experimento](https://www.youtube.com/watch?v=vPDBENpbzJ4), provavelmente teriam um desempenho térmico pior. Ao meu ver, nesses gabinetes com design de cubo, é melhor partir para um AIO direto se for para trocar o cooler box.

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7273.jpg"/>
<figcaption>Layout interno ideal para AIO</figcaption>

Talvez tenha sido um exagero para minhas necessidades, mas funcionou muito bem. Usando apenas uma ventoinha de 120mm em 1000RPM, meu processador (Core i5 10400F) fica em torno de 60C rodando teste de stress em 4.1Ghz.

É bem complicado avaliar refrigeração *a priori*, porque depende de muitas variáveis: TDP dos componentes, fluxo de ar do gabinete e ruído. Para piorar, há aspectos subjetivos no que seria ideal para refrigeração: nível de ruído, estética e temperatura máxima. 

Em teoria, a temperatura é um critério objetivo, mas há muita discussão sobre a temperatura ideal que os componentes devem ficar.

Não vou entrar nessas polêmicas todas, mas esteja atento às dificuldades e necessidades de refrigeração em um gabinete pequeno.

### <a name="gpu"> Placa de Vídeo: barato saiu caro </a>

As placas de vídeos têm ficados cada vez maiores, então é preciso avaliar se o modelo escolhido cabe em um gabinete compacto. Ao contrário das demais peças, as versões menores de GPU normalmente são mais baratas, já que possuem soluções de refrigeração piores.

Assumi que não era um problema para mim esse *trade-off*: primeiro porque optei por uma GTX 1650 que é uma placa de baixo consumo, nem exige conector adicional de energia[^2]. Segundo, porque pretendo usar muito eventualmente, não jogo nada regularmente há anos para me preocupar com altas temperaturas por longos períodos.

[^2]: A maioria dos modelos do mercado exige o conector de 6 pinos, inclusive a que comprei e dizia que não na [especificação](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD/sp#sp) ¯\\_(ツ)_/¯.

O problema é que a [GTX 1650 da Gigabyte](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD) limita a velocidade mínima da ventoinha em 68%, que são incríveis 1800RPM. Pesquisando sobre a placa, descobri que é uma característica comum em placas baratas: coolers que não trabalham em baixa velocidade.

Para os meus padrões, era um barulho simplesmente insuportável, a ventoinha travada nessa velocidade. 

Entre tentar editar a VBIOS e fazer o que chamam de [deshroud da GPU](https://www.youtube.com/watch?v=QUaZVpN51Po), optei pela segunda opção. A substituição do hardware foi simples, mas para conseguir controlar esse cooler pela placa-mãe usando a temperatura da GPU, foi um pequeno inferno no Linux.

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7305.jpg"/>
<figcaption>Cooler de 120cm PWM substituindo o original</figcaption>

Em resumo, além da questão do tamanho, tome cuidado com placas que não desligam o cooler. Se eu não tivesse conseguido contornar fazendo "deshroud", o projeto seria um fracasso pelos meus objetivos, já que uma das minhas prioridades era reduzir o  ruído.

### <a name="armazenamento"> Armazenamento: M.2 sempre que possível </a>

As minhas necessidades de armazenamento são mínimas, então não pensei muito nisso. Mas caso sua demanda por armazenamento seja alta, envolvendo múltiplas unidades ou discos de 3,5 polegadas, recomendo avaliar bem as possibilidades do gabinete.

Para alguns layouts é indiferente a posição das unidades, mas no Elite 110 pode comprometer a ventilação usar unidades de 2,5 ou 3,5, tanto por precisar ter mais cabos de energia quanto pelo posicionamento das baias.

Acho que a questão de priorizar M.2 é relativamente óbvia para SFF, mas uma dica importante é considerar M.2 no padrão SATA: custam um valor parecido com os SSDs SATAs de 2,5 polegadas, mas podem ser instalados no M.2. Não é necessário investir em armazenamento high-end para dispensar os conectores SATA de dados e energia.

Optei por usar um [Kingston A400 SATA M.2 480GB](https://www.kingston.com/br/ssd/a400-solid-state-drive), já que não preciso de grandes velocidades ou muito espaço.


<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7302.jpg"/>
<figcaption>Dissipador "estilizado" do M.2 na placa-mãe</figcaption>


### <a name="mobo"> Placa-mãe: só aceita </a>

As placas-mãe para SFFPC são as ITX, que medem 17x17 cm. Elas normalmente são mais caras que modelos equivalentes ATX e têm menos opções. É um custo extra sem muita escapatória. Acabei optando por Intel e não AMD, muito pelo custo da placa-mãe, que acabou sendo o componente mais caro do computador.

Investi em uma [ASUS ROG STRIX H470-I](https://rog.asus.com/motherboards/rog-strix/rog-strix-h470-i-gaming-model/). Ela vem com Bluetooth 5, que uso bastante nos meus periféricos. Possui dois slots para armazenamento M.2. Por fim, o software da ASUS, de BIOS e Windows, parece ser um dos melhores do mercado.


### <a name="processador"> Processador: cuidado com TDP </a>

Não tem muito o que adicionar: só reiterar que a capacidade de refrigeração pode ser o limite do seu processador.

Eu optei por um modelo de entrada, o Core i5 10400F com 65W de TDP. Não confie muito nessa métrica de TDP, pois ela se refere a dissipação no clock base do processador, mas naturalmente processadores com menos núcleos e clocks mais baixos exigem menos refrigeração.

O ideal é dar uma olhada nos reviews, para entender as demandas de refrigeração e energia de cada processador. Mas exceto para casos extremos e overclock, a escolha do processador não é algo que muda muito por ser SFF ou não.

Algo que vale citar, é a possibilidade de fazer "undervolting" de processador, que é reduzir a tensão do processador sem reduzir o clock. A ideia é queimar um pouco de gordura da configuração padrão, reduzir o consumo de energia e geração de calor, mas sem gerar instabilidade. É algo que pode ser feito em GPUs também.

Se for por esse caminho, é bom verificar se o modelo de processador e placa-mãe suportam esses ajustes. Não destaquei essa alternativa antes, pois acho algo que a maioria não estará disposta e só faz sentido para casos específicos.

### <a name="memoria"> Memória: low-profile </a>

A memória pode ser um ponto de atenção se for usar coolers muito largos, como o [Noctua NH-L12](https://noctua.at/en/nh-l12) que cobrem toda a placa-mãe. Nesse caso, pentes de memória "low-profile" são recomendados. Eu optei pelos modelos [Ballistix da Crucial](https://br.crucial.com/products/memory/ballistix), são baixos e discretos com bom custo/benefício.

Essa questão da memória ficou para o final da lista, porque esse cooler é muito caro, apesar de ótimo. No Brasil, não temos muitas opções de gabinetes ultra-compactos e caros, um cooler saindo na faixa do R$700,00 não combina com um gabinete da K-MEX.


## Montagem

A montagem do computador foi bem trabalhosa, algo em torno de 3-4 horas, por uma séries de fatores:

* Faltou prática, nunca montei um PC completo anteriormente.
* AIO é chato em qualquer gabinete, pior nos pequenos.
* Não é possível remover a parte inferior do Elite 110.
* Organizar bem os cabos é possível, mas exige muita abraçadeira e paciência no Elite 110.

Apesar de um pouco frustante e demorado, acho que ainda foi o de menos comparado a todo o processo anterior de escolha de peças. Se o processo de montagem preocupa, considere gabinetes mais modernos, são melhores de montar normalmente.

Para não dizer que não ajudei nessa parte, uma dica de ouro: instale tudo que possível na placa-mãe antes de colocá-la dentro do gabinete. Fora isso, só posso recomendar paciência mesmo.

## Conclusão: super gratificante

<img class="big-images" 
     src="{{site.url}}/assets/images/pc/DSCF7330.jpg"/>
<figcaption>Uma graça né?</figcaption>

Depois de anos sem montar PCs, precisei dedicar muito tempo para me atualizar e entender as peculiaridades de um SFF. A montagem foi complexa e a GPU barulhenta por pouco não fez o projeto fracassar, mas no final fiquei bem satisfeito. Todo o esforço de pesquisa resultou em algo bem...adequado.

O objetivo era um PC compacto, mas que não fosse absurdamente mais caro ou limitado por esse anseio. Não queria gastar 2X mais por uma configuração similar em ATX ou compacto a ponto de ser limitante.

A configuração ficou equilibrada, sem exageros ou gargalos. O gabinete é grande o suficiente para uma refrigeração boa e silenciosa, mas muito menor que um Mini Tower. Por fim, o custo adicional pelo tamanho compacto não foi absurdo: recomendaria montar um idêntico, sem peso na consciência.

Esse processo de escolha e pesquisa é algo chato para a maioria, mas que acho interessante. Caso o leitor queira trocar uma ideia sobre SFF ou pedir dicas, sinta-se a vontade para entrar em contato.
