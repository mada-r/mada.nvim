local files  = require 'files'
local guide  = require 'core.guide'
local vm     = require 'vm'
local lang   = require 'language'
local define = require 'proto.define'
local await  = require 'await'

local function countCallArgs(source)
    local result = 0
    if not source.args then
        return 0
    end
    result = result + #source.args
    return result
end

local function countFuncArgs(source)
    local result = 0
    if not source.args or #source.args == 0 then
        return result
    end
    local lastArg = source.args[#source.args]
    if lastArg.type == "type.variadic" then
        return math.maxinteger
    elseif source.args[#source.args].type == '...' then
        return math.maxinteger
    end
    result = result + #source.args
    return result
end

local function countOverLoadArgs(source, doc)
    local result = 0
    local func = doc.overload
    if not func.args or #func.args == 0 then
        return result
    end
    if func.args[#func.args].type == '...' then
        return math.maxinteger
    end
    result = result + #func.args
    return result
end

local function getFuncArgs(func)
    local funcArgs
    local defs = vm.getDefs(func)
    for _, def in ipairs(defs) do
        if def.value then
            def = def.value
        end
        if def.type == 'function'
        or def.type == 'type.function' then
            local args = countFuncArgs(def)
            if not funcArgs or args > funcArgs then
                funcArgs = args
            end
            if def.bindDocs then
                for _, doc in ipairs(def.bindDocs) do
                    if doc.type == 'doc.overload' then
                        args = countOverLoadArgs(def, doc)
                        if not funcArgs or args > funcArgs then
                            funcArgs = args
                        end
                    end
                end
            end
        elseif def.type == "type.inter" then
            for _, value in ipairs(guide.getAllValuesInType(def, "type.function")) do
                local args = countFuncArgs(value)
                if not funcArgs or args > funcArgs then
                    funcArgs = args
                end
            end
        end
    end
    return funcArgs
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local cache = vm.getCache 'redundant-parameter'

    guide.eachSourceType(ast.ast, 'call', function (source)
        local callArgs = countCallArgs(source)
        if callArgs == 0 then
            return
        end

        local func = source.node
        local funcArgs = cache[func]
        if funcArgs == nil then
            funcArgs = getFuncArgs(func) or false
            local refs = vm.getRefs(func, 0)
            for _, ref in ipairs(refs) do
                cache[ref] = funcArgs
            end
        end

        if not funcArgs then
            return
        end

        local delta = callArgs - funcArgs
        if delta <= 0 then
            return
        end
        if callArgs == 1 and source.node.type == 'getmethod' then
            return
        end
        for i = #source.args - delta + 1, #source.args do
            local arg = source.args[i]
            if arg then
                callback {
                    start   = arg.start,
                    finish  = arg.finish,
                    tags    = { define.DiagnosticTag.Unnecessary },
                    message = lang.script('DIAG_OVER_MAX_ARGS', funcArgs, callArgs)
                }
            end
        end
    end)
end
