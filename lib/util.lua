function string.trim(s)
    return s:gsub('^%s+', ''):gsub('%s+$','')
end

function commit_config()
    local function tserialize(t, prefix)
        local buf = ""
        for k,v in pairs(t) do
            if type(v) == "number" or type(v) == "boolean" then
                v = tostring(v)
            elseif type(v) == "string" then
                v = string.format("%q", v)
            elseif type(v) == "table" then
                v = "{\n"..tserialize(v, prefix.."  ")..prefix.."}"
            else
                error("malformed configuration table")
            end
            
            buf = buf..string.format("%s%s = %s;\n", prefix, k, v)
        end
        return buf
    end

    local buf = "config = {\n"..tserialize(config, "  ").."}\n"
    local fout = io.open("config.lua", "w")
    fout:write(buf)
    fout:close()
end

table.insert(package.loaders, 1, function(path)
    io.stdout:write("Loading "..path.."...\n")
    return nil
end)
