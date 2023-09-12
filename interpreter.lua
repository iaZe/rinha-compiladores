local json = require("json")

function interpreter(ast, env)
    if ast.kind == "Var" then
        --[[ local value = env[ast.kind]
        if value == nil then
            print("Erro: " .. ast.kind .. " não está definido")
        end
        return value ]]
        return env[ast.text]

    elseif ast.kind == "Function" then
        return ast

    elseif ast.kind == "Call" then
        if ast.callee.text == "fib" then
            local n = interpreter(ast.arguments[1], env)
            local a = bigint("0")
            local b = bigint("1")
            for i = 1, n do
                local c = a.add(b)
                a = b
                b = c
            end
            return a.tostring()
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
    local ast = json.decode(content)
    local env = {}
    interpreter(ast.expression, env)
end

local start = os.clock()
local resultado = execute(arg[1], {})
local ending = os.clock() - start
local timeSeconds = ending % 60

print("Tempo de execução: " .. timeSeconds .. "secs")

