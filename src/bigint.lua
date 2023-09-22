function addBigInts(a, b)
    local maxLength = math.max(#a, #b)
    local carry = 0
    local result = {}

    for i = 1, maxLength do
        local digitA = a[i] or 0
        local digitB = b[i] or 0
        local sum = digitA + digitB + carry
        carry = math.floor(sum / 10)
        table.insert(result, sum % 10)
    end

    if carry > 0 then
        table.insert(result, carry)
    end

    return result
end

function stringToBigInt(str)
    local result = {}
    for i = #str, 1, -1 do
        table.insert(result, tonumber(str:sub(i, i)))
    end
    return result
end

function bigIntToString(bigInt)
    local str = ""
    for i = #bigInt, 1, -1 do
        str = str .. bigInt[i]
    end
    return str
end