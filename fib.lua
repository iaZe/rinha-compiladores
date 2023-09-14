if node.callee.text == "fib" then
    local n = tonumber(interpreter(node.arguments[1], env))

    if n <= 1 then
        return tostring(n)
    elseif n <= 10000 then
        local a = bigint("0")
        local b = bigint("1")
        for i = 1, n do
            local c = a.add(b)
            a = b
            b = c
        end
        return a.tostring()
    else
        local a, b = 0, 1
        for i = 2, n do
            a, b = b, a + b
        end
        return b
    end

    local result = fibonacci(100000)
    print(result)

elseif node.callee.text == "sum" then
    local args = {}
    for _, arg in ipairs(node.arguments) do
        args[#args + 1] = interpreter(arg, env)
    end

    env["n"] = tonumber(env["n"]) or 0

    local result = 0
    for _, arg in ipairs(args) do
        if type(arg) == "number" then
            result = result + arg
        else
            print("Erro: Não é possível somar valores não numéricos")
            return nil
        end
    end
    return result

elseif node.callee.text == "combination" then
    local args = {}
    for _, arg in ipairs(node.arguments) do
        args[#args + 1] = interpreter(arg, env)
    end

    local n = tonumber(args[1])
    local k = tonumber(args[2])

    if n < k then
        print("Erro: n < k")
        return nil
    end

    local result = 1
    for i = 1, k do
        result = result * (n - i + 1) / i
    end
    return result
else
    local callee = interpreter(node.callee, env)
    local args = {}
    for _, arg in ipairs(node.arguments) do
        args[#args + 1] = interpreter(arg, env)
    end
    return interpreter(callee.value, args)
end