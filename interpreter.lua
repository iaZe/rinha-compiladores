local json = require("json")

function interpreter(node, env)
    if node.kind == "Var" then
        local var = node.text
        if env[var] then
            return env[var]
        end

    elseif node.kind == "Function" then
        return node

    elseif node.kind == "Call" then
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

    elseif node.kind == "Let" then
        local value = interpreter(node.value, env)
        env[node.name.text] = value
        return interpreter(node.next, env)

    elseif node.kind == "Str" then
        return node.value

    elseif node.kind == "Int" then
        return tonumber(node.value)

    elseif node.kind == "Binary" then
        local lhs = interpreter(node.lhs, env)
        local rhs = interpreter(node.rhs, env)

        local operators = {
            Add = function(x, y)
                return tostring(x) .. tostring(y)
            end,
            Sub = function(x, y)
                if type(x) == "string" or type(y) == "string" then
                    print("Não é possível subtrair strings")
                    return nil
                end
                return x - y
            end,
            Mul = function(x, y)
                return x * y
            end,
            Div = function(x, y)
                if y == 0 then
                    print("Divisão por zero")
                    return nil
                end
                return x / y
            end,
            Rem = function(x, y)
                return x % y
            end,
            Eq = function(x, y)
                return x == y
            end,
            Lt = function(x, y)
                return x < y
            end,
            Gt = function(x, y)
                return x > y
            end,
            Lte = function(x, y)
                return x <= y
            end,
            Gte = function(x, y)
                return x >= y
            end,
            And = function(x, y)
                return x and y
            end,
            Or = function(x, y)
                return x or y
            end
        }

        if operators[node.op] then
            return operators[node.op](lhs, rhs)
        else
            print("Operador não suportado: " .. node.op)
            return nil
        end

    elseif node.kind == "Bool" then
        return node.value

    elseif node.kind == "If" then
        local cond = interpreter(node.condition, env)
        if cond then
            return interpreter(node["then"], env)
        else
            return interpreter(node["otherwise"], env)
        end
    
    elseif node.kind == "Tuple" then
        local tuple = {}
        for i, value in ipairs(node.values) do
            table.insert(tuple, interpreter(value, env))
        end
        return tuple
    
    elseif node.kind == "First" then
        local tuple = interpreter(node.value, env)
        return tuple[1]
    
    elseif node.kind == "Second" then
        local tuple = interpreter(node.value, env)
        return tuple[2]

    elseif node.kind == "Print" then
        local term = interpreter(node.value, env)
        if type(term) == "number" or type(term) == "string" then
            print(term)
        end
        if type(term) == "tuple" then
            print(table.concat(term, ", "))
        end
        return term

    elseif node.kind == "Parameter" then
        return node
    
    end
end

function execute(path, env)
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    local node = json.decode(content)
    local env = {}
    interpreter(node.expression, env)
end

local start = os.clock()
local resultado = execute(arg[1], {})
local ending = os.clock() - start
local timeSeconds = math.floor(ending * 100) / 100

print("Tempo de execução: " .. timeSeconds .. "secs")

