FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    lua5.1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

ENTRYPOINT ["lua", "interpreter.lua", "source.rinha"]

