---
layout: post
title: "Código simples, solução complexa"
comments: true
description: "A solução de código"
keywords: "Docker, programação assíncrono"
---

Desenhar a arquitetura de uma solução é, muitas vezes, uma tarefa crítica em certos casos. Soluções mal desenhadas de software podem gerar muitos problemas, como dificuldades em manter o código e problemas de escalabilidade. Considero uma das habilidades mais díficies e valiosas de um engenhiro de software.

Não há regras claras,  normalmente estamos falando de analisar *trade-offs*, que passam por diverso aspectos. Desde a qualidade intrinseca da tecnologia em si, até a disponibilidade de profissionais no mercado. E, claro, tudo isso pensando daqui 5 anos e não para entregar a história do próximo sprint.

Em geral, evoluir nesse aspecto exige bastante tempo de experiência, porque uma arquitetura ruim só vai mostrar sinais mais para frente. Exige também humildade e auto-reflexão, para assumir erros e mudar de opinião com os erros.

Não obstante a dificuldade inerente, tem sido cada vez mais desafiador desenhadr uma solução ideal, mas por um bom motivo. Novas soluções estão constantemente mudando como construímos softwares: CI/CD, NoSQL, nuvem, microsserviços, etc...

Um pequeno problema pessoal, me fez refletir como essas novidades mudam o cenário de escolha. No caso, como subir três containers pareceu mais simples que adicionar uma dezena de linha de códigos.

## O problema

Eu guardo minhas fotos no iCloud, mas gostaria de um backup local das fotos armazenadas por lá. Continuarei usando a ferramenta, mas gostaria de baixar as fotos usando o [PyiCloud](https://pypi.org/project/pyicloud/), que baixasse somente as novas fotos que ainda não estavam no backup. 

A solução é nada mais que um loop sobre todas as fotos da biblioteca, baixando as que ainda não estão presentes no diretório. Mais trivial impossível, o problema é que alguns downloads paravam e a execução ficava parada.

Pensei em simplesmente tratar com algum timeout, mas há de se considerar que o processo já estava insuportavelmente demorado. Não faz muito sentido paralelizar processos *cpu-bound* em Python pelo GIL, mas esse era um exemplo clássico de processo *io-bound*. 


## A solução

Considerando as opções de como resolver ambos os problemas, o [Celery](https://docs.celeryproject.org/en/stable/) me pareceu uma boa. À primeira vista, soa exagero algo tão sofisticado, para incluir em uma solução que consiste em um script de 100 linhas. Não parece razoável precisar de um broker (e.g. RabbitMQ, Redis) para esse tipo de problema.

Se por um lado, é chato depender desse tipo de infra para algo simples, ganharia em termos de código. Anos atrás, esse cálculo penderia por usar [multiprocessing] nas requisições. 

Talvez ainda seja o mais razoável, mas o Ce

É trivial subir um RabbitMQ com Docker, assim como um worker do Celery se o script já estiver em um container. Um [Docker Compose](https://docs.docker.com/compose/) é suficiente para orquestar a aplicação principal, o worker do Celery e o RabbitMQ:

```yaml
services:
    rabbitmq:
        image: rabbitmq:3.8
        ports:
            - "5672:5672"
    celery:
        build: .
        entrypoint: "celery -A async_download worker --loglevel=INFO"
        environment:
            - ENV_FOR_DYNACONF=docker
        depends_on:
            - rabbitmq
        volumes: 
            - ${DOWNLOAD_PATH}:/photos-mirror/downloads
    app:
        build: .
        stdin_open: true
        tty: true
        entrypoint: "python app.py"
        environment:
            - ENV_FOR_DYNACONF=docker
        volumes:
            - ${COOKIE_PATH}:/photos-mirror/cookies
        depends_on:
            - rabbitmq
            - celery
```

Usando um comando, eu consigo rodar a aplicação com as dependências: 

`docker-compose run app`

Em termos de código, bastou adicionar uma annotation do Celery, para paralelizar o processo e adicionar um tratamento de time-out:

```python
@app.task(soft_time_limit=90, task_time_limit=95, max_retries=10)
def save_file(url: str, filename: str) -> Tuple[bool, str]:

    if filename in downloaded_files:
        logger.info(f'Already downloaded file: {filename}, skipping.')
        return (False, filename)
    
    try:
        with requests.get(url, stream=True) as r:
            with open(path.join(download_path, filename), 'wb') as f:
                shutil.copyfileobj(r.raw, f)
    except SoftTimeLimitExceeded:
        remove(path.join(download_path, filename))

    return (True, filename)

```

