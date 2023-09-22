# 🌑 Lua Interpreter

Interpretador para linguagem `.rinha` feito em lua para a rinha de compiladores (e intepretadores) 

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
> Não precisa adicionar arquivos, pois a especificação diz que o arquivo tem que ser lido de `/var/rinha/source.rinha.json` então o path já está configurado no dockerfile

Para usar sem docker, basta rodar o comando abaixo:
```
lua interpreter.lua <nome_do_arquivo>
```
> exemplo: `lua interpreter.lua fib`

Para rodar os testes, basta rodar o comando abaixo:
```
./run.sh
```
> Caso não tenha permissão, rode o comando `chmod +x run.sh` e tente novamente

### Exemplos

Deixei alguns arquivos JSON que foram dados como exemplo na especificação, para rodar basta rodar os comandos abaixo:
```
lua interpreter.lua fib
lua interpreter.lua sum
lua interpreter.lua print
lua interpreter.lua combination
lua interpreter.lua source.rinha
```