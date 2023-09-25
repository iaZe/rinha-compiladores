# 🌑 Lua Interpreter

Interpretador para linguagem `.rinha` feito em lua para a [rinha de compiladores (e intepretadores)](https://github.com/aripiprazole/rinha-de-compiler/)

### Funções

- [x] Fibonacci
- [x] Operações matemáticas
- [x] Print
- [x] Combinação
- [x] Concatenação
- [x] First & Second

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
docker run -e interpreter
```
> Não precisa adicionar arquivos, pois a [especificação](https://github.com/aripiprazole/rinha-de-compiler/#especificação) diz que o arquivo tem que ser lido de `/var/rinha/source.rinha.json` então o path já está configurado no dockerfile

Para usar sem docker, basta rodar o comando abaixo:
```
lua interpreter.lua
```

