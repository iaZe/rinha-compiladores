function fibonacci(n)
  local a, b = 0, 1
  for i = 2, n do
      a, b = b, a + b
  end
  return b
end

local result = fibonacci(100000)
print(result)
