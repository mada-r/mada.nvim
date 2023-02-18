local proto          = require 'proto'
local define         = require 'proto.define'
local client         = require 'provider.client'
local json           = require "json"
local config         = require 'config'
local lang           = require 'language'
local nonil          = require 'without-check-nil'

local isEnable = false

local function toArray(map)
    local array = {}
    for k in pairs(map) do
        array[#array+1] = k
    end
    table.sort(array, function (a, b)
        return map[a] < map[b]
    end)
    return array
end

local function enable()
    if isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.semanticTokens.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = true
    log.debug('Enable semantic tokens.')
    proto.awaitRequest('client/registerCapability', {
        registrations = {
            {
                id = 'semantic-tokens',
                method = 'textDocument/semanticTokens',
                registerOptions = {
                    legend = {
                        tokenTypes     = toArray(define.TokenTypes),
                        tokenModifiers = toArray(define.TokenModifiers),
                    },
                    range = true,
                    full  = false,
                },
            },
        }
    })
    if client.isVSCode() and config.other.semantic == 'configuredByTheme' then
        proto.request('$/getState', {key = "ignoreSemantic"}, function (value)
            if not value then
                proto.request('window/showMessageRequest', {
                    type    = define.MessageType.Info,
                    message = lang.script.WINDOW_CHECK_SEMANTIC,
                    actions = {
                        {
                            title = lang.script.WINDOW_APPLY_SETTING,
                        },
                        {
                            title = lang.script.WINDOW_DONT_SHOW_AGAIN,
                        },
                    }
                }, function (item)
                    if item then
                        if item.title == lang.script.WINDOW_APPLY_SETTING then
                            proto.notify('$/command', {
                                command   = 'lua.config',
                                data      = {
                                    key    = 'editor.semanticHighlighting.enabled',
                                    action = 'set',
                                    value  = true,
                                    global = true,
                                }
                            })
                        end
                        if item.title == lang.script.WINDOW_DONT_SHOW_AGAIN then
                            proto.notify('$/setState', {
                                key = "ignoreSemantic",
                                value = true
                            })
                        end
                    end
                end)
            end
        end)
    end
end

local function disable()
    if not isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.semanticTokens.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = false
    log.debug('Disable semantic tokens.')
    proto.awaitRequest('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'semantic-tokens',
                method = 'textDocument/semanticTokens',
            },
        }
    })
end

local function refresh()
    log.debug('Refresh semantic tokens.')
    proto.notify('workspace/semanticTokens/refresh', json.null)
end

return {
    enable  = enable,
    disable = disable,
    refresh = refresh,
}
