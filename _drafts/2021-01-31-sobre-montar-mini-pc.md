---
layout: post
title: "Sobre montar um pequeno computador"
comments: true
description: "Um relato do trabalhoso processo de mntar um PC SFF"
keywords: 
---

Eu tenho usado notebooks como computador pessoal há uns 10 anos, mais especificamente MacBooks e sempre me atenderam bem. Não jogo absolutamente nada, um processador razoável e 16GB de memória são plenamente suficientes para todos os meus usos: desenvolvimento, análise de dados e edição de fotos. 

Meu notebook atual continua atendendo esses casos perfeitamente, mas mesmo assim decidi montar um PC nesse começo de ano. Algumas coisas me incomodam no notebook — especialmente barulho e temperatura — mas nada muito grave, ainda mais com ele conectado sempre ao monitor com teclado e mouse externo.

Além disso, algumas necessidades profissionais tornaram mais relevante eu ter um PC com Windows para lidar fom algumas ferramentas. Mas nada que não pudesse ser resolvido com dual boot no MacBook, ruim mas funciona.

Sem tentar me enganar, o real motivo é que eu simplesmente gostei da ideia de montar um PC no meio desse ócio pandêmico. Talvez, o pior momento nas últimas décadas para fazer isso.

Suponho que montar computadores não seja o jeito mais convencional (ou barato) de lidar com o tédio do isolamento, mas curiosamente acho divertido o processo de fazer a curadoria de peças: equilibrar preço, necessidade e possibilidades futuras. Para mais diversão ainda, defini como meta montar um PC compacto, os chamados "Small Form Factor PC" ([SFFPC](https://en.wikipedia.org/wiki/Small_form_factor_(desktop_and_motherboard))).

Em geral, procuro escrever aqui conteúdo que considero útil e da forma mais concisa possível. Esse post é bem diferente, mais um relato desprentesioso e informal de um "hobby" marginalmente relacionado com tópicos como desenvolvimento ou ciência de dados.

Independente da motivação fraca, eu fiz uma pesquisa bem extensa e trabalhosa sobre o assunto. Há bastante informação em [fóruns](https://www.reddit.com/r/sffpc) e [canais internacionais](https://www.youtube.com/channel/UCRYOj4DmyxhBVrdvbsUwmAA), mas guias de compra e preço são quase inúteis na realidade brasileira.

## Você deveria investir em um SFF?

Por padrão, a reposta é não. Para a maioria dos casos de uso, é uma solução pato: é mais caro e limitado comparado a um computador regular, mas não costuma chegar nem próximo da portabilidade e praticidade de um notebook.

Para alinhar conceitos: não existe um definição objetiva de SFFPC, mas vou considerar pequeno o que não ultrapassar dos 20 litros de volume.

Um motivo legítimo é falta de espaço, por isso é muito comum pensar em SFF para [HTPC](https://en.wikipedia.org/wiki/Home_theater_PC) ou jogar na sala. Mas se houver a possibilidade de usar um gabinete ATX compacto — os chamados Mini Tower — você terá mais opções de hardware, custos menores e (provavelmente) será muito mais simples o processo de montagem e manutenção.

Eu poderia ter optado por um Mini Tower, meu motivo para investir tempo/dinheiro em um SFFPC pode ser resumido em algo como "quando um fã da Apple decide montar um desktop". 

A estética minimalista e discreta dos Macs, é praticamente a antítese do que se encontra em PCs gamer. Em geral, os gabinetes SFFPCs têm mais opções com visual discreto, mais Apple e menos Alienware por assim dizer.

Fora estética, o desperdício de espaço dos gabinetes tipo torre me incomoda, foi uma decepção quando abri um gabinete pela primeira vez e encontrei todo aquele espaço vazio. É frescura pura, mas prefiro ter espaço bem utilizado, que espaço extra para coisas que não pretendo usar.

Se dinheiro não fosse problema, meu gabinete certamente seria um [FormdD T1](https://formdworks.com/products/t1) ou [Louqe Ghost S1](https://www.amazon.com/LOUQE-Ghost-Limestone-Mini-ITX-Computer/dp/B088QTJMKW/ref=sr_1_1?dchild=1&keywords=LOUQE&qid=1612651341&sr=8-1).

<iframe 
    width="560" 
    height="315" 
    src="https://www.youtube-nocookie.com/embed/Ou4iWsBNSmY" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
</iframe>

Alguém pragmático, não veria sentido algum: gastar mais de $200,00 em um gabinete que vem desmontado, limitaria escolhas de hardware e seria um horror para montar e atualizar. Limitação bônus: sem I/O na frente e com botão de ligar escondido na parte traseira.

Não discuto, mas ilustra bem a ideia: para encarar um SFFPC por vontade e não por necessidade, é preciso ser uma mistura peculiar de usuário Apple e Arch Linux.

De um lado, querer um hardware estilo Apple, com design industrial meio obsessivo e desnecesário ao ponto de poder incorrer em [dificuldades desnecessárias](https://9to5mac.com/wp-content/uploads/sites/6/2019/06/Magic-Mouse-problem.jpeg?quality=82&strip=all), [limitações](https://www.theverge.com/2017/4/4/15175994/apple-mac-pro-failure-admission) e [overengineering](https://www.ifixit.com/Teardown/Mac+Pro+2019+Teardown/128922). De outro, é estar disposto a seguir um [caminho bem tortuoso](https://wiki.archlinux.org/index.php/Arch_Linux#User_centrality) para chegar ao objetivo.

## A (difícil) escolha de peças

Montar um SFFPC é inegavelmente mais caro, mas a grande questão como é combinar as peças. 

Em termos financeiras — montando em plena pandemia com falta de peças no mundo todo e dólar nas alturas — estimo em 20% a mais de custo comparado a uma configuração similar em um gabinete padrão. O custo maior é o tempo de pesquisa e tomada de decisão, estimaria em mais que o dobro para SFFPC.

Para ilustrar isso, nada melhor que a "série" ([1](https://www.youtube.com/watch?v=Fpe5wDBXpOI), [2](https://www.youtube.com/watch?v=ywgEEYDtsSE), [3](https://www.youtube.com/watch?v=x0pL5P3AIbw&t=530s) e [4](https://www.youtube.com/watch?v=9g4u88nfM1U)) sobre um PC compacto para jogar na sala do canal [Peperaio Hardware](https://www.youtube.com/user/PeperaioHardwareBR). 

Resumo da história: inicialmente o processador ficou com temperaturas muito altas, trocar o cooler por um melhor não resolveu. O hardware foi movido para um gabinete "melhor", mas mesmo assim a fonte queimou nesse novo gabinete [^1]. 

Usando as mesmas peças do primeiro vídeo, em um gabinete comum, provavelmente não haveria problema algum. 

[^1]:  Em relação a fonte, pode ser que tenha sido apenas um azar, mas ela foi montada invertida para funcionar como exaustor do processador...que me pareceu bem temerário e sem embasamento. Não vou assumir incompetência nessa série, porque esses problemas são "legais" para um canal do YouTube, além disso as peças parecem ter sido enviadas pelos parceiros e não escolhidas. 

A configuração que montei é bem equivalente em um gabinete do mesmo tamanho: zero problemas de temperatura e ruído. Não foi livre de erros e problemas a montagem, mas a escolha cuidadosa de peças reduziu muitos custos extras e dores de cabeça.

Colocada a importância da escolha de peças, vou discutir os pontos de atenção na escolha de cada componente, em ordem de prioridade:

1. [Gabinete: o ponto de partida](#gabinete)
2. [Fonte: fator Brasil](#fonte)
3. [Refrigeração: o seu limite](#refrigeração)
3. [Placa de Vídeo: o barato saiu caro](#gpu)
4. [Armazenamento: M.2 sempre que possível](#armazenamento)
5. [Placa-mãe: só aceita](#mobo)
6. [Processador: cuidado com TDP](#processador)
### <a name="gabinete"> Gabinete: o ponto de partida </a>

Um gabinete pequeno tem limitações, é invevitável. O ponto é escolher quais limitações você prefere, que geralmente estão relacionados às opções de refrigeração, fonte e tamanho da GPU e armazenamento. 

Essas limitações geram um efeito cascata em várias outras decisões: 

* Se a refrigeração é limitada, não se pode usar qualquer processador. 
* Se for necessária uma fonte SFX, o custo extra pode comprometer o restante do orçamento.
* Colocar mais discos para armazenamento, pode limitar instalação de outros hardwares.

Nesse cenário, quanto mais simples for sua necessidade, mais opções de gabinete.

Eu optei pelo antiquado [CooleMaster Elite 110](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/elite110/?_escaped_fragment_=&_escaped_fragment_=#image-Item1), um modelo de 2014 e relativamente barato, focado em opções de armazenamento. Mostrou-se bem adequado para minhas necessidades, mas não recomendado para configurações high-end, usando processadores de alto TDP e GPUs com mais de 21cm.

A grande vantagem desse gabinete, é suportar fontes convencionais ATX, que são muito mais acessíveis no Brasil: metade do preço de uma SFX. Por outro lado, o espaço extra que a fonte ATX ocupa, acaba limitando bastante as opções de refrigeração.

Vale citar que a montagem é trabalhosa, especialmente para organizar cabos da fonte, mas o painel frontal ajuda na tarefa.

Para quem deseja uma configuração básica ou intermediária, o Elite 110 é uma ótima opção no Brasil. Uma alternativa com design similar, mais compacta e com suporte a GPUs maiores, é o [Silverstone SG13](https://www.silverstonetek.com/product.php?pid=536&area=en).

Para quem está querendo montar algo bem básico, com processador de baixo TDP e GPU integrada, pode fazer sentido considerar soluções voltadas para o mercado corporativo. Há gabinetes acessíveis e compactos focados no mercado empresarial, como os da [kmex](http://www.k-mex.com.br/produtos.asp?pag=Produtos&parent=gabinetes1&chave=130&tsb=Mini-ITX) por exemplo. 

Por outro lado, se o plano é montar uma configuração high-end, no Brasil acho que temos basicamente três opções: [Lian Li Pc-tu150 (1)](https://lian-li.com/product/pc-tu150/), [NZXT (2)](https://www.nzxt.com/products/h200i-matte-white) e [CoolerMaster NR200 (3)](https://www.coolermaster.com/br/pt-br/catalog/cases/mini-itx/masterbox-nr200/). 

Os três suportam GPUs grandes, cooler maiores e AIOs de 240mm. Entretanto, há vários detalhes a se considerar nessa faixa de preço, acredito que a melhor recomendação que posso dar é recorrer a reviews e comparações detalhadas. 

Infelizmente, só encontrei conteúdo estrangeiro (em vídeo) bom para avaliar esses gabinetes. No caso, os vídeos do Optimum Tech([1](https://www.youtube.com/watch?v=N5O6WZKERZ8), [2](https://www.youtube.com/watch?v=LqdcwwkGtpY&t=187s), [3](https://www.youtube.com/watch?v=8k1B2tai1yg&t=6s)) e Hardware Canucks ([1](https://www.youtube.com/watch?v=c3HcbOw1_YQ), [2](https://www.youtube.com/watch?v=AbDtYkmFzzU), [3](https://www.youtube.com/watch?v=aMP3-881X5o)).


### <a name="fonte"> Fonte: fator Brasil </a>

A questão da fonte é basicamente financeira, todos os modelos SFX com mais de 400W possuem preço inicial na faixa dos R$1000,00. São todas high-end, com altos valores de eficiência, modulares e garantia de 7-10 anos.

Nesse segmento, a recomendação padrão são as Corsair da [linha SF](https://www.corsair.com/br/pt/Categorias/Produtos/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o/Unidades-de-fonte-de-alimenta%C3%A7%C3%A3o-avan%C3%A7adas/SF-Series/p/CP-9020186-WW). Acompanhando os fóruns, parece ser disparada a fonte mais popular para SFFPCs high-end. Há outras alternativas SFX da Coolermaster e Silverstone no Brasil, mas dado que os preços estão na mesma faixa, não vejo muitos motivos para arriscar outra marca.

Uma alternativa do mercado brasileiro, é optar por fontes SFX usadas da Seasonic, facilmente encontradas no Mercado Livre. É uma marca reconhecida e esses modelos são usados em computadores corporativos, entretanto não passam de 300W.

Se o gabinete suportar ATX, acredito que seja interessante considerar uma modular/semi-modular e compacta. Cabos de fonte são horríveis de organizar em gabinetes pequenos, podendo inclusive comprometer a ventilação.

Eu optei por uma semi-modular, a [Masterwatt 450 TUF Gaming](https://www.coolermaster.com/br/pt-br/catalog/power-supplies/masterwatt/masterwatt-450-tuf-gaming-edition/) da CoolerMaster. É relativamente acessível e a ventoinha fica desligada quando o consumo está baixo.

Além de priorizar modulares, acredito que não haja nada de especial em escolher uma fonte para SFFPCs. Elas só estão em segundo na lista de prioridades devido aos preços altíssimos das compactas no Brasil.

### <a name="refrigeração"> Refrigeração: o seu limite </a> 

Os gabinetes com layouts diferentes costumam limitar bastante as opções de refrigeração, então é bom verificar com cuidado a compatibilidade. Além do espaço físico para o cooler do processador, o fluxo de ar interno também pode ser limitado.

O meu gabiente suporta coolers de apenas 76cm e o fluxo de ar é bem limitado. Como
minha prioridade ao montar o computador era reduzir o barulho, por isso investi em um [AIO 120mm da CoolerMaster](https://www.coolermaster.com/br/pt-br/catalog/coolers/cpu-liquid-coolers/masterliquid-ml120l-v2-rgb/) nesse cenário limitado. 

Um cooler de baixo perfil bom sairia por um preço alto e, como mostram os resultados [desse experimento](https://www.youtube.com/watch?v=vPDBENpbzJ4), provavelmente teriam um desempenho térmico pior. Ao meu ver, esse design de cubo foi feito pensando em um AIO frontal.

Talvez tenha sido um exagero, mas foi um sucesso. Usando apenas uma ventoinha de 120mm em 1000RPM, meu processador (Core i5 10400F) fica em torno de 60C rodando teste de stress em 4.1Ghz.

É bem complicado avaliar refrigeração, porque depende de muitas variáveis. Para piorar, há questões subjetivas como o ruído gerado e a temperatura máxima. Em teoria, a temperatura é um critério objetivo, mas há muita discussão e pessoas que não gostam de processadores funcionando a 80C. 

Além da dificuldade em estimar a relação desempenho/ruído, há outras pontos como a questão estética do gabinete e pessoas que não gostam de refrigeração líquida, o que restringe ainda mais as opções já limitadas.

Não vou entrar nessas polêmicas, mas esteja atento às dificuldades e necessidades de refrigeração em um gabinete pequeno, especialmente se o gabinete escolhido tiver um layout diferente do padrão torre.

### <a name="gpu"> Placa de Vídeo: barato saiu caro </a>

As placas de vídeos tem ficados cada vez maiores, então é preciso ter cuidado se o modelo cabe em um gabinete compacto. Os modelos compactos normalmente são mais baratos, já que possuem soluções de refrigeração mais simples.

Assumi que não era um problema para mim: primeiro porque optei por uma GTX 1650 que é uma placa de baixo consumo, nem exige conector adicional de energia[^2]. Segundo, porque pretendo usar muito eventualmente, não jogo nada regularmente há anos.

[^2]: A maioria dos modelos do mercado exige o conector de 6 pinos, inclusive a que comprei e dizia que não na [especificação](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD/sp#sp) ¯\\_(ツ)_/¯.

O problema é que a [GTX 1650 da Gigabyte](https://www.gigabyte.com/Graphics-Card/GV-N1650IXOC-4GD) limite a velocidade mínima da ventoinha em 68% da velocidade, que são incríveis 1800RPM. Após perceber o erro, descobri que é uma característica comum em placas baratas, ventoinhas que não trabalham em baixa velocidade.

Para os meus padrões, era um barulho simplesmente insuportável. Entre tentar editar a BIOS e fazer o que chamam de [deshroud da GPU](https://www.youtube.com/watch?v=QUaZVpN51Po), optei pela segunda opção. A substituição do hardware foi simples, mas conseguir controlar esse cooler com base na temperatura da GPU foi um inferno.

Em resumo, além da questão do tamanho, tome cuidado com placas que não desligam o cooler. Se eu não tivesse conseguido contornar fazendo "deshroud", o projeto seria um fracasso pelos meus objetivos, já que uma das minhas prioridades era reduzir o ruído.

### <a name="armazenamento"> Armazenamento: M.2 sempre que possível </a>

As minhas necessidades de armazenamento são mínimas, então não pensei muito nisso. Recomendo pensar quais discos e onde colocá-los antes de montar, pode ser um problema em alguns casos.

Para alguns layouts é indiferente a posição dos discos, no Elite 110 pode comprometer a ventilação usar discos de 2,5 ou 3,5 polegadas, tanto por precisar ter mais cabos de energia quanto pelo posicionamento das baias.

Acho que a questão de priorizar M.2 é relativamente óbvia, mas uma dica importante é considerar M.2 no padrão SATA: custam um valor parecido com os SSDs SATAs de 2,5 polegadas, mas podem ser instalados no M.2 como os modelos mais caros PCI Express.

Optei por usar um [A400 SATA M.2 480GB](https://www.kingston.com/br/ssd/a400-solid-state-drive), já que não preciso de grandes velocidades.

### <a name="mobo"> Placa-mãe: só aceita </a>

As placas-mãe para a SFFPC são as ITX, que medem 17x17 cm. Elas normalmente são mais caras que modelos equivalentes ATX e tem menor variedade de modelos. Não tem muito o que fazer, é um custo extra sem muita escapatória. 

Eu acabei optando por Intel e não AMD, muito pelas opções de placa-mãe, que acabou sendo o componente mais caro do computador.

Investi em um [ASUS ROG STRIX H470-I](https://rog.asus.com/motherboards/rog-strix/rog-strix-h470-i-gaming-model/). Ela vem com Bluetooth 5, que uso bastante nos meus periféricos. O software da ASUS, de BIOS e Windows, parece ser um dos melhores do mercado. Por fim, esse chipset possibilita um upgrade para a próxima geração.

A escolha de placa-mãe não foge do padrão para qualquer computador, tirando as limitações de expansão.

### <a name="processador"> Processador: cuidado com TDP </a>

Chegando ao último componente, não tem muito o que falar: só reiterar que a capacidade de refrigeração pode ser o limite do seu processador.

Eu optei por um processador de entrada, o Core i5 10400F com 65W de TDP. Não confie muito nessa métrica de TDP, pois ela se refere a dissipação no clock base do processador. Recomendar olhar os reviews, para ter uma noção do consumo "real" de cada processador.

## Montagem

A montagem do computador foi bem trabalhosa, algo em torno de 3 horas, por uma séries de fatores:

* Faltou de prática, nunca montei um PC completo anteriormente.
* AIO é chato em qualquer gabinete, pior nos pequenos.
* O gabinete não tem acesso inferior.
* Organizar os cabos é possível, mas exige muita abraçadeira e paciência.

Apesar de um pouco frustante e demorado, acho que é o de menos comparado a todo o processo anterior de escolha de peças. Se o processo de montagem preocupa, gabinetes melhores e mais modernos, são melhores de montar que o Elite 110.

Para não dizer que não ajudei, uma dica de ouro: instale tudo que possível na placa-mãe, antes de colocá-la dentro do gabinete.

## Conclusão: super gratificante

Depois de anos sem montar PCs, precisei dedicar muito tempo para me atualizar e entender as peculiaridades de um SFFPC. A montagem foi complexa e a GPU barulhenta por pouco não fez o projeto fracassar, mas no final fiquei bem satisfeito.

Todo o esforço de pesquisa, acabou em algo adequado. A configuração ficou equilibrada e sem exageros ou gargalos. O gabinete é grande o suficiente para uma refrigeração boa e silenciosa, mas muito menor que um Mini Tower. Por fim, o custo adicional pelo tamanho compacto não foi absurdo: recomendaria um igual, sem peso na consciência. 

Para usar uma analogia de programação, é uma satisfação de boas escolhas de design. Quando você faz uma abstração que encaixa perfeitamente na evolução do sistema: facilita manutenção e melhorias, sem adicionar camadas e complexidade desnecessárias.

Acho que é um traço curioso de personalidade, apreciar algo perfeitamente...adequado.