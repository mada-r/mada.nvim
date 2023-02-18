local vm       = require 'vm'
local ws       = require 'workspace'
local furi     = require 'file-uri'
local files    = require 'files'
local guide    = require 'core.guide'
local markdown = require 'provider.markdown'
local config   = require 'config'
local lang     = require 'language'
local util     = require 'utility'

local function asString(source)
    local literal = guide.getLiteral(source)
    if type(literal) ~= 'string' then
        return nil
    end
    local rawLen = source.finish - source.start - 2 * #source[2] + 1
    if  config.config.hover.viewString
    and (source[2] == '"' or source[2] == "'")
    and rawLen > #literal then
        local view = literal
        local max = config.config.hover.viewStringMax
        if #view > max then
            view = view:sub(1, max) .. '...'
        end
        local md = markdown()
        md:add('txt', view)
        return md:string()
    end
end

local function getBindComment(source, docGroup, base)
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    if source.parent.type == 'funcargs' then
        return
    end
    local continue
    local lines
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if not continue then
                continue = true
                lines = {}
            end
            if doc.comment.text:sub(1, 1) == '-' then
                lines[#lines+1] = doc.comment.text:sub(2)
            else
                lines[#lines+1] = doc.comment.text
            end
        elseif doc == base then
            break
        else
            continue = false
            if doc.type == 'doc.field'
            or doc.type == 'doc.class' then
                lines = nil
            end
        end
    end
    if source.comment then
        if not lines then
            lines = {}
        end
        lines[#lines+1] = source.comment.text
    end
    if not lines or #lines == 0 then
        return nil
    end
    return table.concat(lines, '\n')
end

local function tryDocClassComment(source)
    for _, def in ipairs(vm.getDefs(source, 0)) do
        if def.type == 'doc.class.name'
        or def.type == 'doc.alias.name' then
            local class = guide.getDocState(def)
            local comment = getBindComment(class, class.bindGroup, class)
            if comment then
                return comment
            end
        end
    end
    if source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.alias' then
                local comment = getBindComment(doc, source.bindDocs, doc)
                return comment
            end
        end
    end
end

local function buildEnumChunk(docType, name)
    local enums = vm.getDocEnums(docType)
    if not enums or #enums == 0 then
        return
    end
    local types = {}
    for _, tp in ipairs(docType.types) do
        types[#types+1] = tp[1]
    end
    local lines = {}
    for _, typeUnit in ipairs(docType.types) do
        local comment = tryDocClassComment(typeUnit)
        if comment then
            for line in util.eachLine(comment) do
                lines[#lines+1] = ('-- %s'):format(line)
            end
        end
    end
    lines[#lines+1] = ('%s: %s'):format(name, table.concat(types))
    for _, enum in ipairs(enums) do
        lines[#lines+1] = ('   %s %s%s'):format(
               (enum.default    and '->')
            or (enum.additional and '+>')
            or ' |',
            enum[1],
            enum.comment and (' -- %s'):format(enum.comment) or ''
        )
    end
    return table.concat(lines, '\n')
end

local function isFunction(source)
    if source.type == 'function' then
        return true
    end
    local value = guide.getObjectValue(source)
    if not value then
        return false
    end
    return value.type == 'function'
end

local function getBindEnums(source, docGroup)
    if not isFunction(source) then
        return
    end

    local mark = {}
    local chunks = {}
    local returnIndex = 0
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.param' then
            local name = doc.param[1]
            if mark[name] then
                goto CONTINUE
            end
            mark[name] = true
            chunks[#chunks+1] = buildEnumChunk(doc.extends, name)
        elseif doc.type == 'doc.return' then
            for _, rtn in ipairs(doc.returns) do
                returnIndex = returnIndex + 1
                local name = rtn.name and rtn.name[1] or ('return #%d'):format(returnIndex)
                if mark[name] then
                    goto CONTINUE
                end
                mark[name] = true
                chunks[#chunks+1] = buildEnumChunk(rtn, name)
            end
        end
        ::CONTINUE::
    end
    if #chunks == 0 then
        return nil
    end
    return table.concat(chunks, '\n\n')
end

local function tryDocFieldUpComment(source)
    if source.type ~= 'doc.field' then
        return
    end
    if not source.bindGroup then
        return
    end
    local comment = getBindComment(source, source.bindGroup, source)
    return comment
end

local function getFunctionComment(source)
    local docGroup = source.bindDocs

    local hasReturnComment = false
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.return' and doc.comment then
            hasReturnComment = true
            break
        end
    end

    local comments = {}
    local isComment = true
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if not isComment then
                comments[#comments+1] = '\n'
            end
            isComment = true
            if doc.comment.text:sub(1, 1) == '-' then
                comments[#comments+1] = doc.comment.text:sub(2)
            else
                comments[#comments+1] = doc.comment.text
            end
            comments[#comments+1] = '\n'
        elseif doc.type == 'doc.param' then
            if doc.comment then
                isComment = false
                comments[#comments+1] = '\n'
                comments[#comments+1] = ('@*param* `%s` — %s'):format(
                    doc.param[1],
                    doc.comment.text
                )
                comments[#comments+1] = '\n'
            end
        elseif doc.type == 'doc.return' then
            if hasReturnComment then
                isComment = false
                comments[#comments+1] = '\n'
                local name = {}
                for _, rtn in ipairs(doc.returns) do
                    if rtn.name then
                        name[#name+1] = rtn.name[1]
                    end
                end
                if doc.comment then
                    if #name == 0 then
                        comments[#comments+1] = ('@*return* — %s'):format(doc.comment.text)
                    else
                        comments[#comments+1] = ('@*return* `%s` — %s'):format(table.concat(name, ','), doc.comment.text)
                    end
                else
                    if #name == 0 then
                        comments[#comments+1] = '@*return*'
                    else
                        comments[#comments+1] = ('@*return* `%s`'):format(table.concat(name, ','))
                    end
                end
                comments[#comments+1] = '\n'
            end
        elseif doc.type == 'doc.overload' then
            comments[#comments+1] = '---'
        end
    end
    if comments[1] == '\n' then
        table.remove(comments, 1)
    end
    if comments[#comments] == '\n' then
        table.remove(comments)
    end
    comments = table.concat(comments)

    local enums = getBindEnums(source, docGroup)
    if comments == '' and not enums then
        return
    end
    local md = markdown()
    md:add('md', comments)
    md:add('lua', enums)
    return md:string()
end

local function tryDocComment(source)
    if not source.bindDocs then
        return
    end
    if not isFunction(source) then
        local comment = getBindComment(source, source.bindDocs)
        return comment
        end
    return getFunctionComment(source)
end

local function tryDocOverloadToComment(source)
    if source.type ~= 'doc.type.function' then
        return
    end
    local doc = source.parent
    if doc.type ~= 'doc.overload'
    or not doc.bindSources then
        return
    end
    for _, src in ipairs(doc.bindSources) do
        local md = tryDocComment(src)
        if md then
            return md
        end
    end
end

local function tyrDocParamComment(source)
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    if source.type ~= 'local' then
        return
    end
    if source.parent.type ~= 'funcargs' then
        return
    end
    if not source.bindDocs then
        return
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.param' then
            if doc.param[1] == source[1] then
                if doc.comment then
                    return doc.comment.text
                end
                break
            end
        end
    end
end

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
    if source.type == 'field' then
        source = source.parent
    end
    if source.type == 'type.library'
    or source.type == "type.field" then
        return source.description
    elseif source.parent then
        if source.parent.type == "type.library"
        or source.parent.type == "type.field" then
            return source.parent.description
        elseif source.parent.type == "type.inter" then
            if source.parent.parent.overloadDescription then
                for index, value in ipairs(source.parent) do
                    if value == source then
                        local overload = source.parent.parent.overloadDescription[index]
                        if overload then
                            return overload.description
                        end
                    end
                end
            end
            return source.parent.parent.description
        end
    end
    return tryDocOverloadToComment(source)
        or tryDocFieldUpComment(source)
        or tyrDocParamComment(source)
        or tryDocComment(source)
        or tryDocClassComment(source)
end
