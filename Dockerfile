FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    lua5.1 \
    luajit \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

ENTRYPOINT ["luajit", "interpreter.lua", "source.rinha"]

