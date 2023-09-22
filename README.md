# Lua Interpreter

Interpretador para linguagem .rinha feito em lua para a rinha de comiladores (e intepretadores) 

### Funções

- [x] Fibonacci
- [x] Operações matemáticas
- [x] Print
- [x] Combinação
- [x] Concatenação

## 🚀 Instalando o Interpreter

Caso queira utilizar sem docker, instale o lua5.1 no seu sistema

Linux:
```
apt-get update && apt-get install -y lua5.1
```

## ☕ Usando o Interpreter

Para usar com docker, basta rodar o comando abaixo:

```
docker build -t interpreter .
docker run -e file=<nome_do_arquivo> interpreter
```

> Não precisa adicionar extensões, o interpretador lê o .JSON por padrão
> exemplo: `docker run -e file=fib interpreter`

Para usar sem docker, basta rodar o comando abaixo:

```
lua interpreter.lua <nome_do_arquivo>
```
> exemplo: `lua interpreter.lua fib`


### Exemplos

Usando docker
```
docker run -e file=fib interpreter
docker run -e file=sum interpreter
docker run -e file=print interpreter
docker run -e file=combination interpreter
docker run -e file=source.rinha interpreter
```

Usando lua
```
lua interpreter.lua fib
lua interpreter.lua sum
lua interpreter.lua print
lua interpreter.lua combination
lua interpreter.lua source.rinha
```