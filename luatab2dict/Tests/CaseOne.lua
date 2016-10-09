--
-- Print Lua Table Elements
--
function print_lua_table (lua_table, indent)
    if lua_table == nil or type(lua_table) ~= "table" then
        return
    end

    local function print_func(str)
        print("[Log] " .. tostring(str))
    end
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print_func(formatting)
            print_lua_table(v, indent + 1)
            print_func(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print_func(formatting..szValue..",")
        end
    end
end

--
-- XCTest caseOne call this function
--
function CaseOne(dict)
    print_lua_table(dict)
end
