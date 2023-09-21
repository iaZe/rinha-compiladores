clear

# Lista de arquivos JSON e suas descrições
files=(
  "var/rinha/combination.json Combination"
  "var/rinha/fib.json Fibonacci"
  "var/rinha/print.json Print"
  "var/rinha/sum.json Sum"
)

# Loop para executar as funções
for file in "${files[@]}"; do
  file_info=($file)
  json_file=${file_info[0]}
  description=${file_info[1]}

  echo "$description:"
  lua interpreter.lua "$json_file"
  echo  # Adicionar uma linha em branco
done
