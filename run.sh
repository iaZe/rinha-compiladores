files=(
  "var/rinha/combination.json Combination"
  "var/rinha/fib.json Fibonacci"
  "var/rinha/print.json Print"
  "var/rinha/sum.json Sum"
)

for file in "${files[@]}"; do
  file_info=($file)
  json_file=${file_info[0]}
  description=${file_info[1]}

  clear
  echo "$description:"
  lua interpreter.lua "$json_file"
  echo
done
