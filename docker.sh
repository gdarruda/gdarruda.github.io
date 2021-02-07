#!/bin/bash

docker container rm blog

docker run \
    --detach \
    --name blog \
    -p 4000:4000/tcp \
    --volume $(pwd):/gdarruda.github.io \
    gdarrudagithub:latest

