local json = require("json")

function interpreter(node, env)
    if node.kind == "Var" then
        local var = node.text
        if env[var] then
            return env[var]
        else
            print("Variável não declarada: " .. var)
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
        else
            local callee = interpreter(node.callee, env)

            local args = {}
            for _, arg in ipairs(node.arguments) do
                args[#args + 1] = interpreter(arg, env)
            end

            local newEnv = {}
            for i, param in ipairs(callee.parameters) do
                newEnv[param] = args[i]
            end
            return interpreter(callee.value, newEnv)
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

function bigint(str)
    local self = {}
    self.value = str or "0"

    function self.add(other)
        local result = {}
        local carry = 0
        local maxLen = math.max(#self.value, #other.value)
        for i = 1, maxLen do
            local a = tonumber(self.value:sub(-i, -i)) or 0
            local b = tonumber(other.value:sub(-i, -i)) or 0
            local sum = a + b + carry
            carry = math.floor(sum / 10)
            table.insert(result, 1, tostring(sum % 10))
        end
        if carry > 0 then
            table.insert(result, 1, tostring(carry))
        end
        return bigint(table.concat(result, ""))
    end
    function self.tostring()
        return self.value
    end
    return self
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

