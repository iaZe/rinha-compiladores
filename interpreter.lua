local json = require("src.json")
local src = require("src.deepcopy")

local path = "var/rinha/" .. arg[1] .. ".json"

function interpreter(node, env)
    if node.kind == "Var" then
        return env[node.text]

    elseif node.kind == "Function" then
        for i, arg in ipairs(node.parameters) do
            table.insert(env, arg.text)
        end
        return function(newEnv)
            return interpreter(node.value, newEnv)
        end

    elseif node.kind == "Call" then
        if node.callee.text == "fib" then
            local number = tonumber(interpreter(node.arguments[1], env))

            if number <= 1 then
                return tostring(number)
            else
                local a = "0"
                local b = "1"
                local c = "0"
                
                for i = 2, number do
                    c = a + b
                    a = b
                    b = c
                end
                return tostring(c)
            end
        else
            local args = {}
            for i, arg in ipairs(node.arguments) do
                args[i] = interpreter(arg, env)
            end

            local newEnv = deepcopy(env)
            for i, arg in ipairs(env) do
                newEnv[arg] = args[i]
            end
            return interpreter(node.callee, newEnv)(newEnv)
        end

    elseif node.kind == "Let" then
        env[node.name.text] = interpreter(node.value, env)
        return interpreter(node.next, env)

    elseif node.kind == "Str" then
        return node.value

    elseif node.kind == "Int" then
        return node.value

    elseif node.kind == "Binary" then
        local lhs = interpreter(node.lhs, env)
        local rhs = interpreter(node.rhs, env)

        local operators = {
            Add = function(x, y)
                if type(x) == "string" or type(y) == "string" then
                    return x .. y
                end
                return x + y
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
        table.insert(tuple, interpreter(node.first, env))
        table.insert(tuple, interpreter(node.second, env))
        return tuple
    
    elseif node.kind == "First" then
        local tuple = interpreter(node.value, env)
        return tuple[1]
    
    elseif node.kind == "Second" then
        local tuple = interpreter(node.value, env)
        return tuple[2]

    elseif node.kind == "Print" then
        local term = interpreter(node.value, env)
        if type(term) == "table" then
            print(table.concat(term, ", "))
        else
            print(term)
        end
        return term
    end
end

function execute(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local node = json.decode(content)
        local env = {}
        interpreter(node.expression, env)
    else
        print("Arquivo não encontrado")
    end
end

execute(path)

