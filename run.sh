files=(
  "combination Combination"
  "fib Fibonacci"
  "print Print"
  "sum Sum"
)

clear
for file in "${files[@]}"; do
  file_info=($file)
  json_file=${file_info[0]}
  description=${file_info[1]}

  echo "$description:"
  lua interpreter.lua "$json_file"
  echo
done
