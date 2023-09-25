FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get install -y \
    lua5.1 \
    luajit \
    && rm -rf /var/lib/apt/lists/*

COPY . .

CMD ["luajit", "interpreter.lua", "/var/rinha/fib.json"]

