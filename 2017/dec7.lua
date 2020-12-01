lines = {}
for line in io.lines(arg[1]) do 
    lines[#lines + 1] = line
end

-- for part one
names = {}
excludes = {}
-- for part two
weights = {}
children = {}
for k,v in pairs(lines) do
    local parent
    for name, weight in string.gmatch(v, "(%l+) %((%d+)%)") do
        if excludes[name] == nil then
            names[name] = true
        end
        weights[name] = tonumber(weight)
        parent = name
    end
    i, j = string.find(v, "->")
    if i ~= nil then
        c = {}
        for name in string.gmatch(string.sub(v, j+1), "(%l+)") do
            c[#c + 1] = name
            names[name] = nil
            excludes[name] = true
        end
        children[parent] = c
    end
end

for k, v in pairs(names) do
    print("part1:", k)
end

function total_weight(name)
    local t = weights[name]
    if children[name] == nil then
        return t
    end
    for i, child in pairs(children[name]) do
        t = t + total_weight(child)
    end
    return t
end

-- iterate through children
-- figure out what level the unbalance is at