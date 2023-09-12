local json = require("json")

function interpreter(ast, env)
    if ast.kind == "Var" then
        local value = env[ast.kind]
        if value == nil then
            print("Erro: " .. ast.kind .. " não está definido")
        end
        return value
        
    elseif ast.kind == "Function" then
        return ast

    elseif ast.kind == "Call" then
        if ast.callee.text == "fib" then
            local n = tonumber(interpreter(ast.arguments[1], env))

            if n <= 1 then
                return tostring(n)
            else
                local baseMatrix = {{1, 1}, {1, 0}}
                local result = matrixPower(baseMatrix, n - 1)
                return tostring(result[1][1])
            end
        else
            local func = interpreter(ast.callee, env)
            local args = {}
            for i, arg in ipairs(ast.arguments) do
                table.insert(args, interpreter(arg, env))
            end
            if type(func) == "function" then
                return func(unpack(args))
            else
                print("Erro: " .. ast.callee.text .. " não é uma função")
            end
        end

    elseif ast.kind == "Let" then
        local value = interpreter(ast.value, env)
        env[ast.name.text] = value
        return interpreter(ast.next, env)

    elseif ast.kind == "Str" then
        return ast.value

    elseif ast.kind == "Int" then
        return tonumber(ast.value)

    elseif ast.kind == "Binary" then
        local lhs = interpreter(ast.lhs, env)
        local rhs = interpreter(ast.rhs, env)
        if ast.op == "Add" then
            if type(lhs) == "string" or type(rhs) == "string" then
                return tostring(lhs) .. tostring(rhs)
            end
            return lhs + rhs
        elseif ast.op == "Sub" then
            return lhs - rhs
        elseif ast.op == "Mul" then
            return lhs * rhs
        elseif ast.op == "Div" then
            if rhs == 0 then
                print("Divisão por zero")
                return
            end
            return lhs / rhs
        elseif ast.op == "Rem" then
            return lhs % rhs
        elseif ast.op == "Eq" then
            return lhs == rhs
        elseif ast.op == "Lt" then
            return lhs < rhs
        elseif ast.op == "Gt" then
            return lhs > rhs
        elseif ast.op == "Lte" then
            return lhs <= rhs
        elseif ast.op == "Gte" then
            return lhs >= rhs
        elseif ast.op == "And" then
            return lhs and rhs
        elseif ast.op == "Or" then
            return lhs or rhs
        else
            print("Erro no operador" .. ast.op)
        end

    elseif ast.kind == "Bool" then
        return ast.value

    elseif ast.kind == "If" then
        local cond = interpreter(ast.cond, env)
        if cond then
            return interpreter(ast["then"], env)
        else
            return interpreter(ast.otherwise, env)
        end
    
    elseif ast.kind == "Tuple" then
        local tuple = {}
        for i, value in ipairs(ast.values) do
            table.insert(tuple, interpreter(value, env))
        end
        return tuple
    
    elseif ast.kind == "First" then
        local tuple = interpreter(ast.value, env)
        return tuple[1]
    
    elseif ast.kind == "Second" then
        local tuple = interpreter(ast.value, env)
        return tuple[2]

    elseif ast.kind == "Print" then
        local term = interpreter(ast.value, env)
        if type(term) == "number" or type(term) == "string" then
            print(term)
        end
        return term


    end
end

function matrixMultiply(a, b)
    local c = {{0, 0}, {0, 0}}
    for i = 1, 2 do
        for j = 1, 2 do
            for k = 1, 2 do
                c[i][j] = c[i][j] + a[i][k] * b[k][j]
            end
        end
    end
    return c
end

function matrixPower(matrix, n)
    local result = {{1, 0}, {0, 1}}
    local base = matrix
    while n > 0 do
        if n % 2 == 1 then
            result = matrixMultiply(result, base)
        end
        base = matrixMultiply(base, base)
        n = math.floor(n / 2)
    end
    return result
end

function execute(path, env)
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    local ast = json.decode(content)
    local env = {}
    interpreter(ast.expression, env)
end

local start = os.clock()
local resultado = execute(arg[1], {})
local ending = os.clock() - start

local timeSeconds = ending % 60

print("Tempo de execução: " .. timeSeconds .. "secs")

