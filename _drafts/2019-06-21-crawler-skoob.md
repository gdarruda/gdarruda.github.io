---
layout: post
title: "Skoob com Scrapy"
comments: true
description: "Desenvolendo um crawler para Skoob com Scrapy"
keywords: "Skoob, crawler, redes-socias"
---

A criação de  *web scrapers* para gerar datasets não é a área mais descolada de ciência de dados, mas uma solução usando o  [Scrapy](https://scrapy.org) ficou tão simples e elegante, que deu vontade de escrever sobre. Neste post, vou explicar como desenvolvi um *web scrapper* para baixar as resenhas de livros da rede social [Skoob](https://www.skoob.com.br).

## Por que fazer um crawler de Skoob?

O Skoob é uma rede social para leitores, que tem um rico espaço de resenhas feito pelos usuários da rede. No momento de escrita desse blog, encontrei mais de 600.000 resenhas para 80.000 livros diferentes.

Apesar de ser um conceito manjado – criar *corpus* de resenhas para análise de sentimentos – sempre é mais complicado achar um que esteja em língua portuguesa. Nesse contexto, achei válido desenvolver esse projetinho para criar esse *dataset* com resenhas publicadas no Skoob.

## O que é o Scrapy?

O Scrapy é um framework Python para extração de dados da web, lidado com o fluxo de ponta a ponta: *crawling* das páginas, *scrapping* dos dados e persistência. 

A parte de *crawling* é a etapa de navegar pelas páginas que precisam ser baixadas, encontrar todas as URLs que precisam ser acessadas para ter o dado extraído. Em nosso caso, essa é a parte de identificar todas as URLs que contém as resenhas de livros.

O *scrapping* é a parte mais trabalhosa, a etapa de extração das informações. A partir do HTML das [páginas de resenhas](https://www.skoob.com.br/livro/resenhas/219/), precisamos achar uma forma de extrair as informações desejadas. Em nosso caso, como extrair as informações dos livros e das resenhas.

Por fim, temos a parte de persistência, que é basicamente salvar os resultados das etapas anteriores. Salvaremos os dados em um arquivo JSON, mas o Scrapy tem a possibilidade de integrar com banco de dados caso seja necessário.

Usando o Scrapy, lidar com todas essas etapas do processo exigiu o desenvolvimento de apenas uma classe!

### Instalando o Scrapy

A instalação do pacote Scrapy não poderia ser mais simples, basta um `pip install scrapy` ou `conda install -c conda-forge scrapy` caso você esteja usando o Anaconda.

### Criando um projeto Scrapy

O Scrapy é um framework e não uma biblioteca[^1], portanto é necessário criar um projeto com a estrutura própria. Para tal, basta usar o comando `scrapy startproject nomeprojeto`, sendo `nomeprojeto` um nome definido pelo usuário da aplicação.

Criado o projeto, temos uma estrutura pronto do projeto e podemos desenvolver o *spider* para ler e baixar as resenhas do Skoob.

## Criando o spider ReviewsSkoob

Os Spider são as classes que definem quais páginas serão acessadas e como os dados serão extraídos, ou seja, estamos falando da classe responsável pelas etapas de *crawling* e *scraping*.

A estrutura básica de um Spider, consiste em um método para listar as URLs que precisam ser acessadas e um método de *parse* para extração dos dados. Usando esses dois métodos principais criados pelo usuário, o Scrapy se responsabiliza por realizar as requisições e executar as extrações dos dados.

Vamos entender o passo-a-passo, de como o Spider para as resenhas do Skoob foi construído.

### Encontrando os livros

O primeiro passo para fazer um processo de *scrapping*, é entender como estão organizadas as URLs que devem ser acessadas. As resenhas do Skoob são agrupadas por livros, portanto devemos iterar sobre todos os livros para extrair as resenhas. 

No caso do Skoob, não poderia ser mais simples, já que as páginas de resenha estão indexadas por um sequencial inteiro:

*  `skoob.com.br/livro/resenhas/1/` - Resenhas de *Ensaio Sobre a Cegueira*
*  `skoob.com.br/livro/resenhas/2/` - Resenhas de *O Caçador De Pipas*
* ...
*  `skoob.com.br/livro/resenhas/456920/` - Resenhas de *Pronto para recomeçar*

Iterando de 1 em 1 nos IDs dos livros, conseguimos acesso às páginas que desejamos. Testanto as URLs no browser, identifiquei que o último ID disponível era o 456.920.

Agora, já é possível iniciar o desenvolvimeno da nossa classe `ReviewsSkoob`, que é uma extensão da classe `scrapy.Spider`, dentro do diretório `spiders`.

```python
class ReviewsSkoob(scrapy.Spider):
    name = "reviewsSkoob"

    def start_requests(self):

        urls = ["https://www.skoob.com.br/livro/resenhas/" + str(i) for i in range(1, 456920)]

        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)
```

O atributo `name` da classe é apenas uma chave para identificar o Spider, usaremos ela posteriormente durante a execução do processo.

O método responsável por listar todas as URLs, é o `start_requests`, ele deve retornar um iterável (por isso o uso do método `yield`) com todas as requisições que devem ser realizadas pelo Scrapy.

A partir desse lista geradas pelo método `start_requests`, o Scrapy conseguirá acessar todos livros, mas não todas as resenhas. Livros populares têm várias resenhas e, acessando apenas o primeiro link, estamos restrito às primeiras 15 resenhas. Como não sabemos *a priori* quantas páginas de resenha um livro tem, iremos lidas com esse problema na etapa de *scraping* usando o recurso de seguir links oferecido pelo framework.

[^1]: Não existe uma única definição de framework, mas estou partindo do príncipio da [inversão de controle](https://en.wikipedia.org/wiki/Inversion_of_control), em que o fluxo é controlado pelo framework e o código desenvolvido pelo usuário é chamado pelo framework.

### Extraindo as resenhas

A estratégia de *crawling* já foi (parcialmente) resolvida com o método acima, agora iremos para a parte mais trabalhosa que é o *scrapping* das resenhas: com o DOM da página, como pegar as informações de interesse? Para essa tarefa, a única opção é inspecionar o HTML em um browser e definir que *tags* serão extraídas.

Primeiramente, devemos definir o que desejamos extrair das páginas. Abaixo, a estrutura de dados que será extraídas para cada livro:

```python
{'author': '', # Nome do autor
 'book_name': '',# Nome do livro
 'reviews': []} # Lista de resenhas do livro
```
O campo `reviews` será uma lista de objetos, que contém as informações de resenhas daquele livro. Abaixo, a estrutura desse objeto de resenhas:

```python
 {'review_id': '', # Identificador único da resenha
  'user_id': '', # Identificador do usuário
  'rating': , # Nota da resenha
  'text': ''} # Texto da resenha.
```
Para melhor entendimento dessa estrutura, segue um exemplo do resultado da extração de um livro com 2 resenhas:

```python
{'author': 'Justin Herald',
 'book_name': 'Atitude',
 'reviews': [
  {'review_id': 'resenha79081806',
   'user_id': '3760854-juliana.fontes',
   'rating': 4,
   'text': '"Entusiasmo é bom, mas eu prefiro ter AÇÃO em minha vida."'},
  {'review_id': 'resenha185981',
   'user_id': '6311-andre-goeldner',
   'rating': 1,
   'text': 'O livro resume-se ao título. Espécie de auto-ajuda restrito à histórias pessoais vividas pelo autor.  \n \nPouco acrescentador, repetitivo e desnecessário. '}]}
```
Definida a estrutura, podemos agora explorar o DOM para entender como extrair essas informações. 

A tarefa de extraris dados do DOM é um desafio a parte, já que pode ser feito de diversas formas e a estratégia depende muito da estrutura da página. Para identificar as informações, eu usei o [Xpath](http://docs.scrapy.org/en/1.6/topics/selectors.html#working-with-xpaths), que é uma linguaguem padrão para navegar em arquivos XML. Ou seja, pode ser utilizada fora do Scrapy em outros frameworks e linguagens que trabalham com esse tipo de dado. 

A parte de extração não é o foco do post, portanto não irei me estender explicando como criei as expressóes Xpath, mas abaixo temos os códigos usados para a extração dos dados no método `parse`.

```python
def get_user(self, user):
    return user.split('/')[-1]

def get_review(self, review):
    return ' '.join(review)

def parse(self, response):

        self.log(f"Processing {response.url} ...")

        book_info = response.xpath("//div[@id='pg-livro-menu-principal-container']")
        author = book_info.xpath(".//a[contains(@href, '/autor/')]/text()").extract_first()
        book_name = book_info.xpath(".//strong[@class='sidebar-titulo']/text()").extract_first()

        if 'reviews' in response.meta:
            reviews = response.meta['reviews']
        else:
            reviews = []

        for review in response.xpath("//div[re:test(@id, 'resenha[0-9]+')]"):

            review_id = review.xpath("./@id").extract_first()
            user_id = self.get_user(review.xpath(".//a[contains(@href, '/usuario/')]/@href").extract_first())
            rating = review.xpath(".//star-rating/@rate").extract_first()
            text = self.get_review(response.xpath(f".//div[@id='resenhac{review_id[7:]}']/text()").extract())

            self.log(f"Review {review_id} processed for {book_name}")

            reviews.append({'review_id': review_id,
                   'user_id': user_id,
                   'rating': int(rating),
                   'text': text})

        reviews_page = {
            'author': author,
            'book_name': book_name,
            'reviews': reviews
        }
```

O método `parse` é chamado para cada requisição gerada pelo método `start_requests` e recebe de parâmetro um objeto [Response](https://docs.scrapy.org/en/latest/topics/request-response.html#response-objects), que contém o resultado da requisição. 

O código acima é a parte de extração dos dados a partir de um objeto response, perceba que eu apenas utilizo o método `Response.xpath` para extração dos dados dos livros e das resenhas. O uso do atributo `response.meta` será discutido logo mais, foi usado como forma de passar dados de uma requisição para outra.

Com as informações extraídas, basta usar o comando no `yield` no objeto criado (a variável `reviews_page`) para indicar que aqueles dados devem ser salvos. Entretanto, não podemos salvar os dados visitando apenas uma página, pois precisamos visitar as *N* páginas subsequentes de livros com mais de 15 resenhas.

Neste momento, temos a maior complicação desse processo, que é criar uma outra requisição dentro do método `parse` para as demais páginas de resenhas. Para tal, o primeiro passo é identificar se existe uma próxima página, que pode se feito procurando pela existência de um *link*:

```python
next_page = response.css('div.proximo').xpath('.//a/@href').extract_first()
```

Se houver uma próxima página, precisamos criar uma requisição para a próxima páginam com os `reviews` já extraídos. Dessa forma, quando chegarmos a última página, teremos um objeto com todas as resenhas juntas. 

Para passar essa informação para a próxima requisição, é possível adicionar a informação usando o atributo `meta` do objeto [Request](https://docs.scrapy.org/en/latest/topics/request-response.html#request-objects), que pode passar receber qualquer tipo de dado em um objeto dicionário.

As requisições serão criadas recursivamente, com os dados da anterior, até que cheguemos a última página. A condição de parada, é identificada pela presença do link de próxima página. Vale notar que livros sem resenhas não são salvos no final do processo.

```python
if next_page is not None:
    request = response.follow(next_page, callback=self.parse)
    request.meta['reviews'] = reviews
    yield request
elif len(reviews) > 0:
    self.log(f"Saving {len(reviews)} reviews for book {book_name}")
    yield reviews_page
```
[Nesse link](https://github.com/gdarruda/scrap-skoob/blob/master/skoob/spiders/reviews_skoob.py), temo a implementação completa dessa classe.

## Executando o crawler

A execução do crawler é a parte onde começamos a perceber as vantagens de usar um framework, já que o Scrapy irá nos oferecer várias recursos interessantes:

* Persistência automática, possibilitando o uso automático de vários formatos como JSON, CSV, XML em várias tipos de *storage* como S3 e FTP. 
* Controle de execução via *jobs*, possibilitando que um processo seja pausado/reiniciado quando necessário.
* Opções de *AutoThrottle* para evitar sobrecarga no site que as informações estão sendo baixadas.

Essas são os recursos que podemos usar nesse processo, que pode ser considerado um dos mais simples, mas além disso temos outros recursos úteis para processos de *crawling* e *scrapping* mais complexos, envolvendo questões de *cookies* e deploy.

### Definindo um AutoThrottle

A ideia do throttle é não onerar o site de onde estáo sendo extraídas as informações, já que a ideia não é gerar um custo ou indisponibilidade para o site. Para ativar esse recurso, basta editar o arquivo `settings.py` na pasta raiz do projeto:

```python
# Enable and configure the AutoThrottle extension (disabled by default)
# See https://doc.scrapy.org/en/latest/topics/autothrottle.html
AUTOTHROTTLE_ENABLED = True
# The initial download delay
AUTOTHROTTLE_START_DELAY = 5
# The maximum download delay to be set in case of high latencies
AUTOTHROTTLE_MAX_DELAY = 60
# The average number of requests Scrapy should be sending in parallel to
# each remote server
AUTOTHROTTLE_TARGET_CONCURRENCY = 1.0
# Enable showing throttling stats for every response received:
#AUTOTHROTTLE_DEBUG = False
```

A [documentação do Scrapy](http://docs.scrapy.org/en/1.6/topics/autothrottle.html) tem uma página sobre esse assunto, o que significa cada parâmetro. Como é apenas um projeto pessoal, eu deixei parâmetros bem relaxados e apenas uma requisição por vez, a fim de reduzir o impacto do crawler na infraestrutura do Skoob.

### Executando a extração

Para executar o crawler, basta usarmos o comando `crawl` do Scrapy:

```bash
scrapy crawl reviewsSkoob -o output/reviewsSkoob.json -s JOBDIR=crawls/skoob20190622
```
A variável `reviewsSkoob` é o atributo `name` que adicionamos na classe `ReviewsSkoob`. O parâmetro `-o` é o tipo de saída desejada para o processo, que definimos como um arquivo JSON[^2]. Por fim, o parâmetro `-s` é um diretórion no qual será controlado a execução do crawler, permitindo assim pausa-lo e reinicia-lo.

Agora, é só esperar o processo terminar, que ao final o arquivos `reviewsSkoob.json` estará com todas as resenhas.

[^2]: O recomendado para processos que serão pausados e reiniciados é o formato [JSON Lines](http://jsonlines.org/examples/) para evitar problemas de arquivos inválidos.

## Resultados

Após dias executando o processo, temos os seguintes números de uma extração realizada em Junho de 2019.

#### Notas