local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local CONFIG = {
    MaxArgLength = 500,
    MaxDepth = 3,
    LogToConsole = true,
    LogToFile = false,
    BlockRemoteNames = {},
    BlockArgumentPatterns = {},
    ShowFullPath = true,
    ShowReturnValues = true,
    TimestampFormat = "%H:%M:%S.%f",
    GroupSimilarCalls = false
}

local remoteCache = {}
local callHistory = {}
local lastPrintTime = {}
local printThrottle = 0.1 

local function GetFullPath(instance)
    if not instance then return "nil" end
    if instance == game then return "game" end
    
    local path = instance.Name
    local current = instance
    
    while current.Parent and current.Parent ~= game do
        current = current.Parent
        path = current.Name .. "." .. path
    end
    
    if instance.Parent == game then
        path = "game." .. path
    end
    
    return path
end

local function FormatValue(value, depth, seen)
    depth = depth or 0
    seen = seen or {}
    
    if depth > CONFIG.MaxDepth then
        return "{...}"
    end
    
    local valueType = typeof(value)
    
    if value == nil then
        return "nil"
    elseif valueType == "string" then
        local escaped = value:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\t", "\\t"):gsub("\"", "\\\"")
        if #escaped > CONFIG.MaxArgLength then
            escaped = escaped:sub(1, CONFIG.MaxArgLength) .. "..."
        end
        return "\"" .. escaped .. "\""
    elseif valueType == "number" then
        if value == math.huge then return "math.huge"
        elseif value == -math.huge then return "-math.huge"
        elseif value ~= value then return "0/0" -- NaN
        else return tostring(value)
        end
    elseif valueType == "boolean" then
        return tostring(value)
    elseif valueType == "Instance" then
        if value.Parent == nil then
            return "<Destroyed: " .. value.Name .. " (" .. value.ClassName .. ")>"
        end
        if CONFIG.ShowFullPath then
            return "<" .. GetFullPath(value) .. " (" .. value.ClassName .. ")>"
        else
            return "<" .. value.Name .. " (" .. value.ClassName .. ")>"
        end
    elseif valueType == "Vector3" then
        return string.format("Vector3(%.3f, %.3f, %.3f)", value.X, value.Y, value.Z)
    elseif valueType == "CFrame" then
        local pos = value.Position
        return string.format("CFrame(%.3f, %.3f, %.3f, ...)", pos.X, pos.Y, pos.Z)
    elseif valueType == "Color3" then
        return string.format("Color3(%.3f, %.3f, %.3f)", value.R, value.G, value.B)
    elseif valueType == "EnumItem" then
        return tostring(value)
    elseif valueType == "function" then
        return "<function>"
    elseif valueType == "userdata" then
        return "<" .. tostring(value) .. ">"
    elseif valueType == "table" then
        if seen[value] then
            return "<circular reference>"
        end
        seen[value] = true
        
        local count = 0
        for _ in pairs(value) do count = count + 1 end
        
        if count == 0 then
            return "{}"
        elseif count > 50 then
            return "{... " .. count .. " items ...}"
        end
        
        local items = {}
        local index = 1
        for k, v in pairs(value) do
            if index > 20 then
                table.insert(items, "...")
                break
            end
            local keyStr = "[" .. FormatValue(k, depth + 1, seen) .. "]"
            local valStr = FormatValue(v, depth + 1, seen)
            table.insert(items, keyStr .. " = " .. valStr)
            index = index + 1
        end
        
        return "{ " .. table.concat(items, ", ") .. " }"
    else
        return "<" .. valueType .. ": " .. tostring(value) .. ">"
    end
end

local function ShouldBlock(remoteName, args)
    for _, blocked in ipairs(CONFIG.BlockRemoteNames) do
        if remoteName:find(blocked) then
            return true
        end
    end
    
    local argStr = HttpService:JSONEncode(args)
    for _, pattern in ipairs(CONFIG.BlockArgumentPatterns) do
        if argStr:find(pattern) then
            return true
        end
    end
    
    return false
end

local function GetTimestamp()
    local t = os.date("*t")
    local ms = math.floor((tick() % 1) * 1000)
    return string.format("%02d:%02d:%02d.%03d", t.hour, t.min, t.sec, ms)
end

local function PrintRemote(direction, remote, args, returnValue, err)
    local remotePath = GetFullPath(remote)
    local remoteName = remote.Name
    
    if ShouldBlock(remoteName, args) then
        return
    end
    
    local callKey = direction .. remotePath .. HttpService:JSONEncode(args)
    local now = tick()
    if lastPrintTime[callKey] and (now - lastPrintTime[callKey]) < printThrottle then
        return
    end
    lastPrintTime[callKey] = now
    
    local argStrs = {}
    for i, arg in ipairs(args) do
        table.insert(argStrs, FormatValue(arg))
    end
    local argsFormatted = #argStrs > 0 and table.concat(argStrs, ", ") or ""
    
    local lines = {}
    table.insert(lines, string.rep("=", 80))
    table.insert(lines, string.format("[%s] %s | %s", GetTimestamp(), direction, remotePath))
    table.insert(lines, string.rep("-", 40))
    
    if #args > 0 then
        table.insert(lines, "Arguments:")
        for i, arg in ipairs(args) do
            table.insert(lines, string.format("  [%d] = %s", i, FormatValue(arg)))
        end
    else
        table.insert(lines, "Arguments: (none)")
    end
    
    if direction == "INCOMING (Return)" and returnValue ~= nil then
        table.insert(lines, string.rep("-", 40))
        table.insert(lines, "Return Value: " .. FormatValue(returnValue))
    end
    
    if err then
        table.insert(lines, string.rep("-", 40))
        table.insert(lines, "ERROR: " .. tostring(err))
    end
    
    table.insert(lines, string.rep("=", 80))
    table.insert(lines, "")
    
    local output = table.concat(lines, "\n")
    
    if CONFIG.LogToConsole then
        if direction:find("OUTGOING") then
            print(output)
        elseif direction:find("INCOMING") then
            print(output)
        else
            print(output)
        end
    end
    
    if CONFIG.LogToFile and writefile then
        local fileName = "remote_spy_log.txt"
        local existing = isfile(fileName) and readfile(fileName) or ""
        writefile(fileName, existing .. output .. "\n")
    end
end

local function HookRemoteEvent(remote)
    if remoteCache[remote] then return end
    remoteCache[remote] = true
    
    local originalFireServer = remote.FireServer
    local originalFireClient = remote.FireClient
    
    remote.FireServer = function(self, ...)
        if self ~= remote then
            return originalFireServer(self, ...)
        end
        
        local args = {...}
        PrintRemote("OUTGOING (FireServer)", remote, args)
        
        local success, err = pcall(function()
            return originalFireServer(self, table.unpack(args))
        end)
        
        if not success then
            PrintRemote("OUTGOING (FireServer) [FAILED]", remote, args, nil, err)
            error(err, 2)
        end
    end
    
    local originalConnect = remote.OnClientEvent.Connect
    remote.OnClientEvent.Connect = function(self, callback)
        if self ~= remote.OnClientEvent then
            return originalConnect(self, callback)
        end
        
        local wrappedCallback = function(...)
            local args = {...}
            PrintRemote("INCOMING (OnClientEvent)", remote, args)
            return callback(...)
        end
        
        return originalConnect(self, wrappedCallback)
    end
    
    local originalOnce = remote.OnClientEvent.Once
    remote.OnClientEvent.Once = function(self, callback)
        local wrappedCallback = function(...)
            local args = {...}
            PrintRemote("INCOMING (OnClientEvent.Once)", remote, args)
            return callback(...)
        end
        return originalOnce(self, wrappedCallback)
    end
    
    local mt = getrawmetatable and getrawmetatable(remote.OnClientEvent)
    if mt and mt.__index then
        local originalWait = mt.__index.Wait
        mt.__index.Wait = function(self)
            local result = {originalWait(self)}
            PrintRemote("INCOMING (OnClientEvent.Wait)", remote, result)
            return table.unpack(result)
        end
    end
end

local function HookRemoteFunction(remote)
    if remoteCache[remote] then return end
    remoteCache[remote] = true
    
    local originalInvokeServer = remote.InvokeServer
    local originalInvokeClient = remote.InvokeClient
    
    remote.InvokeServer = function(self, ...)
        if self ~= remote then
            return originalInvokeServer(self, ...)
        end
        
        local args = {...}
        PrintRemote("OUTGOING (InvokeServer)", remote, args)
        
        local success, result = pcall(function()
            return originalInvokeServer(self, table.unpack(args))
        end)
        
        if success then
            PrintRemote("INCOMING (InvokeServer Return)", remote, {result}, result)
            return result
        else
            PrintRemote("INCOMING (InvokeServer Error)", remote, {}, nil, result)
            error(result, 2)
        end
    end
    
    local originalOnClientInvoke
    local mt = getrawmetatable and getrawmetatable(remote)
    
    if mt then
        local originalIndex = mt.__index
        local originalNewIndex = mt.__newindex
        
        mt.__newindex = function(self, key, value)
            if self == remote and key == "OnClientInvoke" and value then
                local wrappedHandler = function(...)
                    local args = {...}
                    PrintRemote("INCOMING (OnClientInvoke)", remote, args)
                    
                    local success, result = pcall(value, ...)
                    
                    if success then
                        PrintRemote("OUTGOING (OnClientInvoke Return)", remote, {result}, result)
                        return result
                    else
                        PrintRemote("OUTGOING (OnClientInvoke Error)", remote, {}, nil, result)
                        error(result, 2)
                    end
                end
                
                return originalNewIndex(self, key, wrappedHandler)
            end
            
            return originalNewIndex(self, key, value)
        end
    end
end

local function HookBindableEvent(bindable)
    if remoteCache[bindable] then return end
    remoteCache[bindable] = true
    
    local originalFire = bindable.Fire
    bindable.Fire = function(self, ...)
        if self ~= bindable then
            return originalFire(self, ...)
        end
        
        local args = {...}
        PrintRemote("BINDABLE (Fire)", bindable, args)
        
        return originalFire(self, table.unpack(args))
    end
    
    local originalConnect = bindable.Event.Connect
    bindable.Event.Connect = function(self, callback)
        local wrapped = function(...)
            local args = {...}
            PrintRemote("BINDABLE (Event)", bindable, args)
            return callback(...)
        end
        return originalConnect(self, wrapped)
    end
end

local function HookBindableFunction(bindable)
    if remoteCache[bindable] then return end
    remoteCache[bindable] = true
    
    local originalInvoke = bindable.Invoke
    bindable.Invoke = function(self, ...)
        if self ~= bindable then
            return originalInvoke(self, ...)
        end
        
        local args = {...}
        PrintRemote("BINDABLE (Invoke)", bindable, args)
        
        local success, result = pcall(function()
            return originalInvoke(self, table.unpack(args))
        end)
        
        if success then
            PrintRemote("BINDABLE (Invoke Return)", bindable, {result}, result)
            return result
        else
            PrintRemote("BINDABLE (Invoke Error)", bindable, {}, nil, result)
            error(result, 2)
        end
    end
    
    local mt = getrawmetatable and getrawmetatable(bindable)
    if mt and mt.__newindex then
        local originalNewIndex = mt.__newindex
        mt.__newindex = function(self, key, value)
            if self == bindable and key == "OnInvoke" and value then
                local wrapped = function(...)
                    local args = {...}
                    PrintRemote("BINDABLE (OnInvoke)", bindable, args)
                    return value(...)
                end
                return originalNewIndex(self, key, wrapped)
            end
            return originalNewIndex(self, key, value)
        end
    end
end

local function ScanAndHook(parent, depth)
    depth = depth or 0
    if depth > 10 then return end
    
    local children = {}
    pcall(function()
        children = parent:GetDescendants()
    end)
    
    for _, child in ipairs(children) do
        local className = child.ClassName
        
        if className == "RemoteEvent" then
            pcall(function() HookRemoteEvent(child) end)
        elseif className == "RemoteFunction" then
            pcall(function() HookRemoteFunction(child) end)
        elseif className == "BindableEvent" then
            pcall(function() HookBindableEvent(child) end)
        elseif className == "BindableFunction" then
            pcall(function() HookBindableFunction(child) end)
        end
    end
end

print(string.rep("=", 80))
print("REMOTE SPY INITIALIZED")
print("Scanning ReplicatedStorage...")
print(string.rep("=", 80))

ScanAndHook(ReplicatedStorage)
ScanAndHook(game)

spawn(function()
    while task.wait(2) do
        ScanAndHook(ReplicatedStorage)
        ScanAndHook(game)
    end
end)

pcall(function()
    ReplicatedStorage.DescendantAdded:Connect(function(descendant)
        local className = descendant.ClassName
        if className == "RemoteEvent" then
            pcall(function() HookRemoteEvent(descendant) end)
        elseif className == "RemoteFunction" then
            pcall(function() HookRemoteFunction(descendant) end)
        end
    end)
end)

_G.RemoteSpy = {
    Config = CONFIG,
    ClearCache = function()
        remoteCache = {}
        print("[RemoteSpy] Cache cleared, will re-hook on next call")
    end,
    SetThrottle = function(seconds)
        printThrottle = seconds
        print("[RemoteSpy] Throttle set to " .. seconds .. "s")
    end,
    BlockRemote = function(namePattern)
        table.insert(CONFIG.BlockRemoteNames, namePattern)
        print("[RemoteSpy] Blocking pattern: " .. namePattern)
    end,
    UnblockRemote = function(namePattern)
        for i, v in ipairs(CONFIG.BlockRemoteNames) do
            if v == namePattern then
                table.remove(CONFIG.BlockRemoteNames, i)
                print("[RemoteSpy] Unblocked: " .. namePattern)
                return
            end
        end
    end,
    GetHistory = function()
        return callHistory
    end
}

print("[RemoteSpy] Ready. Use _G.RemoteSpy for commands")
