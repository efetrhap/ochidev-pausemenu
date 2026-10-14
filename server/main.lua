local QBCore = nil

CreateThread(function()
    Wait(500)
    if Config.Framework == 'qbcore' or (Config.Framework == 'qbox' and not exports.qbx_core) then
        pcall(function()
            QBCore = exports['qb-core']:GetCoreObject()
        end)
    end
end)

local function getPlayerObject(source)
    if Config.Framework == 'qbox' then
        if exports.qbx_core then
            return exports.qbx_core:GetPlayer(source)
        end
        if QBCore then
            return QBCore.Functions.GetPlayer(source)
        end
        local qb = exports['qb-core']:GetCoreObject()
        return qb.Functions.GetPlayer(source)
    elseif Config.Framework == 'qbcore' then
        if QBCore then
            return QBCore.Functions.GetPlayer(source)
        end
        local qb = exports['qb-core']:GetCoreObject()
        return qb.Functions.GetPlayer(source)
    end
    return nil
end

local lastCalls = {}
local cachedData = {}

AddEventHandler('playerDropped', function()
    local src = source
    lastCalls[src] = nil
    cachedData[src] = nil
end)

lib.callback.register('ochidev:pause:getPlayerData', function(source)
    local now = GetGameTimer()
    if lastCalls[source] and (now - lastCalls[source]) < 1000 and cachedData[source] then
        return cachedData[source]
    end
    lastCalls[source] = now

    local player = getPlayerObject(source)
    if not player then
        local fallback = {
            name = GetPlayerName(source),
            job = 'Civilian',
            cash = 0,
            bank = 0,
            time = os.date('%H:%M')
        }
        cachedData[source] = fallback
        return fallback
    end

    local charName = GetPlayerName(source)
    local jobLabel = 'Civilian'
    local cashAmount = 0
    local bankAmount = 0

    local charinfo = player.PlayerData.charinfo
    if charinfo and charinfo.firstname and charinfo.lastname then
        charName = charinfo.firstname .. ' ' .. charinfo.lastname
    end

    local job = player.PlayerData.job
    if job and job.label then
        local gradeName = job.grade and job.grade.name or ''
        if gradeName ~= '' then
            jobLabel = job.label .. ' - ' .. gradeName
        else
            jobLabel = job.label
        end
    end

    local money = player.PlayerData.money
    if money then
        cashAmount = money.cash or 0
        bankAmount = money.bank or 0
    end

    local result = {
        name = charName,
        job = jobLabel,
        cash = cashAmount,
        bank = bankAmount,
        time = os.date('%H:%M')
    }
    cachedData[source] = result
    return result
end)

RegisterNetEvent('ochidev:pause:disconnect', function()
    local src = source
    if src and src > 0 then
        DropPlayer(src, Config.DisconnectReason)
    end
end)
