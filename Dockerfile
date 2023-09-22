FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    lua5.1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

CMD lua interpreter.lua $file