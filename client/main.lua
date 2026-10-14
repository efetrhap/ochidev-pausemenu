local isMenuOpen = false
local isOpeningFrontend = false
local camStart = nil
local camTarget = nil

local function cleanupCameras()
    if Config.Camera.BlurEffect then
        ClearTimecycleModifier()
    end
    if camTarget then
        DestroyCam(camTarget, false)
        camTarget = nil
    end
    if camStart then
        DestroyCam(camStart, false)
        camStart = nil
    end
end

local function startCameraTransition()
    local ped = cache.ped or PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local inVehicle = veh ~= 0 and DoesEntityExist(veh)

    local gameplayCoords = GetGameplayCamCoord()
    local gameplayRot = GetGameplayCamRot(2)

    camStart = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(camStart, gameplayCoords.x, gameplayCoords.y, gameplayCoords.z)
    SetCamRot(camStart, gameplayRot.x, gameplayRot.y, gameplayRot.z, 2)
    SetCamFov(camStart, GetGameplayCamFov())

    camTarget = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    if inVehicle then
        local minDim, maxDim = GetModelDimensions(GetEntityModel(veh))
        local camX = Config.Camera.OffsetX or 0.0
        local camY = maxDim.y + 1.4
        local camZ = maxDim.z * 0.35 + 0.35
        local pointY = maxDim.y * 0.1
        local pointZ = maxDim.z * 0.45

        AttachCamToEntity(camTarget, veh, camX, camY, camZ, true)
        PointCamAtEntity(camTarget, veh, 0.0, pointY, pointZ, true)
        SetCamFov(camTarget, 52.0)
    else
        local camX = Config.Camera.OffsetX or 0.0
        local camY = Config.Camera.OffsetY or 1.35
        local camZ = Config.Camera.OffsetZ or 0.45

        AttachCamToEntity(camTarget, ped, camX, camY, camZ, true)
        PointCamAtEntity(camTarget, ped, 0.0, 0.0, 0.55, true)
        SetCamFov(camTarget, 48.0)
    end

    SetCamActive(camStart, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamActiveWithInterp(camTarget, camStart, Config.Camera.TransitionTime, 1, 1)

    if Config.Camera.BlurEffect then
        SetTimecycleModifier(Config.Camera.Timecycle)
        SetTimecycleModifierStrength(0.85)
    end

    if SetCamUseShallowDofMode then
        SetCamUseShallowDofMode(camTarget, true)
        SetCamDofStrength(camTarget, Config.Camera.DofStrength)
    end
end

local function stopCameraTransition()
    if Config.Camera.BlurEffect then
        ClearTimecycleModifier()
    end
    RenderScriptCams(false, true, Config.Camera.ReturnTime, true, true)
    SetTimeout(Config.Camera.ReturnTime, function()
        cleanupCameras()
    end)
end

local function closeMenu()
    if not isMenuOpen then return end
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    stopCameraTransition()
end

local function openMenu()
    if isMenuOpen or isOpeningFrontend or IsPauseMenuActive() then return end
    local ped = cache.ped or PlayerPedId()
    if IsEntityDead(ped) then return end

    isMenuOpen = true
    SetPauseMenuActive(false)

    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and DoesEntityExist(veh) then
        if GetPedInVehicleSeat(veh, -1) == ped then
            TaskVehicleTempAction(ped, veh, 6, 2500)
        end
    else
        ClearPedTasks(ped)
    end

    startCameraTransition()

    local playerData = lib.callback.await('ochidev:pause:getPlayerData', false)
    if not isMenuOpen then return end

    if not playerData then
        playerData = {
            name = GetPlayerName(PlayerId()),
            job = 'Civilian',
            cash = 0,
            bank = 0,
            time = string.format('%02d:%02d', GetClockHours(), GetClockMinutes())
        }
    end

    SendNUIMessage({
        action = 'open',
        data = playerData,
        labels = Config.Labels
    })
    SetNuiFocus(true, true)
end

CreateThread(function()
    while true do
        if not isOpeningFrontend then
            SetPauseMenuActive(false)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)

            if isMenuOpen then
                local ped = cache.ped or PlayerPedId()
                if IsEntityDead(ped) then
                    closeMenu()
                else
                    DisableAllControlActions(0)
                    EnableControlAction(0, 249, true)
                end
            else
                if IsDisabledControlJustPressed(0, 199) or IsDisabledControlJustPressed(0, 200) then
                    CreateThread(openMenu)
                end
            end
            Wait(0)
        else
            Wait(150)
        end
    end
end)

RegisterNUICallback('resume', function(_, cb)
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('map', function(_, cb)
    closeMenu()
    isOpeningFrontend = true
    SetTimeout(200, function()
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_SP_PAUSE'), false, -1)
        CreateThread(function()
            Wait(500)
            while IsPauseMenuActive() do
                Wait(150)
            end
            Wait(250)
            isOpeningFrontend = false
        end)
    end)
    SetTimeout(5000, function()
        if isOpeningFrontend and not IsPauseMenuActive() then
            isOpeningFrontend = false
        end
    end)
    cb('ok')
end)

RegisterNUICallback('settings', function(_, cb)
    closeMenu()
    isOpeningFrontend = true
    SetTimeout(200, function()
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_SP_PAUSE'), false, -1)
        CreateThread(function()
            Wait(500)
            while IsPauseMenuActive() do
                Wait(150)
            end
            Wait(250)
            isOpeningFrontend = false
        end)
    end)
    SetTimeout(5000, function()
        if isOpeningFrontend and not IsPauseMenuActive() then
            isOpeningFrontend = false
        end
    end)
    cb('ok')
end)

RegisterNUICallback('disconnect', function(_, cb)
    closeMenu()
    TriggerServerEvent('ochidev:pause:disconnect')
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() then
        if isMenuOpen then
            SetNuiFocus(false, false)
        end
        cleanupCameras()
        RenderScriptCams(false, false, 0, true, true)
    end
end)
