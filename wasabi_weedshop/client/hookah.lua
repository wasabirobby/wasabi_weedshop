ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



local hookahObjects = {}
local hookahSingleObject = nil
local carryingHookah = false
local marpuc = nil
local sessionStarted = false
local currentHookah = nil
local carryingKoz = false
local koz = {

    obj = nil
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(coords - Config.hookahYap.coords) < 1.5 then

            local text = '[~g~E~s~] - Take Hookah | [~g~K~s~] - Take Hookah Embers'


            if(carryingHookah)then
                text = '[~g~E~s~] - Delete Hookah | [~g~K~s~] - Take Hookah Embers'
            end

            if carryingKoz then
                text = '[~g~E~s~] - Take Hookah | [~g~K~s~] - Delete Hookah Embers'
            end

            local hookahYapLoc = vector3(Config.hookahYap.coords.x, Config.hookahYap.coords.y, Config.hookahYap.coords.z)
            DrawText3D(hookahYapLoc, text, 0.55, 1.5)

            if IsControlJustReleased(0, 38)  then
                if  not carryingHookah then
                    if  not carryingKoz then
                        local obj = CreateObject(4037417364, 0,0,0, true, 0, true)
                        local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
                        hookahSingleObject = obj
                        carryingHookah = true
                        anim()
                        AttachEntityToEntity(obj, ply, boneIndex2, -0.15, 0.2, 0.18, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    else
                        ESX.ShowNotification("You are already carrying something!")

                    end
                else
                    DeleteEntity(hookahSingleObject)
                    hookahSingleObject = nil
                    carryingHookah = false   
                    ClearPedTasks(PlayerPedId())
                end
            end
            if IsControlJustPressed(0, 311)  then
                if koz.obj == nil and not carryingKoz then
                    if  not carryingHookah then
                        carryingKoz = true
                        attachKoz()
                    else
                        ESX.ShowNotification("You are already carrying something!")
                    end
                else

                    DeleteEntity(koz.obj)
                    koz.obj = nil
                    carryingKoz = false   
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.Masalar) do
            if carryingHookah or v.alreadyHaveHookah then
                 local ply = PlayerPedId()
                 local coords = GetEntityCoords(ply, true)
                  if #(coords - v.coords) < 2.5 and not v.alreadyHaveHookah then 
                    DrawText3D(v.coords, "Press [~g~E~s~] to place hookah", 0.55, 1.5)
                    if IsControlJustReleased(0, 38) then
                        putHookahToTable(k)
                     end
                 elseif #(coords - v.coords) < 2.5 and v.alreadyHaveHookah then 
                    DrawText3D(v.coords, "Press [~g~E~s~] to take hookah", 0.55, 1.5)
                     if IsControlJustReleased(0, 38) then
                           takeHookahFromTable(k)
                     end
                end
            end
        end
    end
end)

RegisterNetEvent('codem-hookah:client:deleteMarpuc')
AddEventHandler('codem-hookah:client:deleteMarpuc', function(masa)
    local masa = Config.Masalar[masa].coords
    if sessionStarted then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(masa - coords ) < 3.0 then

            currentHookah = nil
            SetEntityAsMissionEntity(marpuc, true, true)
            DeleteEntity(marpuc)
            marpuc = nil
            ClearPedTasks(ply)
            ESX.ShowNotification("You are taking hookah from table")
        end
    end
end)


RegisterNetEvent('codem-hookah:client:deleteHookah')
AddEventHandler('codem-hookah:client:deleteHookah', function(masa)

    local ply = PlayerPedId()
    local coords = GetEntityCoords(ply, true)

    for k,v in pairs(hookahObjects) do
        print(v.table, masa)
        if v.table == masa then
            ESX.ShowNotification("You removed the hookah from the table")
             SetEntityAsMissionEntity(NetworkGetEntityFromNetworkId(v.obj), true, true)
             DeleteEntity(NetworkGetEntityFromNetworkId(v.obj))

             table.remove(hookahObjects, k)

             return;
        end
    end
  
end)

RegisterNetEvent('codem-hookah:client:getConfig')
AddEventHandler('codem-hookah:client:getConfig', function(newConfig)
    Config.Masalar = newConfig
end)

function putHookahToTable(masa)
    DeleteEntity(hookahSingleObject)
    hookahSingleObject = nil
    carryingHookah = false
    local obj =  CreateObject(4037417364, Config.Masalar[masa].coords, false, 0, false)
    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
    NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(obj), false)
	FreezeEntityPosition(obj, true)
    table.insert(hookahObjects, {obj = NetworkGetNetworkIdFromEntity(obj), table = masa, koz = 100})
    TriggerServerEvent('codem-hookah:server:syncHookahTable', hookahObjects)

    TriggerServerEvent('codem-hookah:server:setAlreadyHaveHookah',masa, true)


    ClearPedTasks(PlayerPedId())
end

function takeHookahFromTable(masa)
    for k,v in pairs(hookahObjects) do
        if v.table == masa then
            TriggerServerEvent('codem-hookah:server:deleteMarpuc', v.table)

            TriggerServerEvent('codem-hookah:server:deleteHookah', v.table)

            TriggerServerEvent('codem-hookah:server:setAlreadyHaveHookah',masa, false)
        end
    end
end

RegisterNetEvent('codem-hookah:client:setHookahs')
AddEventHandler('codem-hookah:client:setHookahs', function(hookahler)
    hookahObjects = hookahler
end)

RegisterNetEvent('codem-hookah:client:syncHookahTable')
AddEventHandler('codem-hookah:client:syncHookahTable', function()
end)



RegisterNetEvent('codem-hookah:client:syncKoz')
AddEventHandler('codem-hookah:client:syncKoz', function(obj, amount)
    for k,v in pairs(hookahObjects) do
        if v.obj == obj then
            v.koz = v.koz + amount
            if v.koz > 100 then
                v.koz = 100
            elseif v.koz <= 0 then
                v.koz = 0
            end
        end
    end
end)



function attachKoz()
	local hash = GetHashKey('v_corp_boxpaprfd')
	local ped = PlayerPedId()
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end

	local obj = CreateObject(hash,  GetEntityCoords(PlayerPedId()),  true,  true, true)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end
    UseParticleFxAsset("core")

    StartNetworkedParticleFxLoopedOnEntity("ent_anim_cig_smoke",obj,0,0,0.1, 0,0,0, 3.0, 0,0,0)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
	local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    koz.obj = obj;


    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)


	AttachEntityToEntity(obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
end


function kozle(v)
    local ped = PlayerPedId()

    RequestAnimDict("misscarsteal3pullover")
    while not HasAnimDictLoaded("misscarsteal3pullover") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "misscarsteal3pullover", "pull_over_right", 2.0, 2.0, -1, 49, 0, false, false, false)
    Citizen.Wait(5500)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
    local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)
	AttachEntityToEntity(koz.obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
    TriggerServerEvent('codem-hookah:server:syncKoz', v.obj, 50)

end


RegisterCommand('at', function()
    attachKoz()

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(hookahObjects) do
   
            local coords = GetEntityCoords(NetworkGetEntityFromNetworkId(v.obj), true)
            local ply = PlayerPedId()
            local coordsPly = GetEntityCoords(ply, true)
            if #(coords - coordsPly) < 3.0 then

                if IsControlJustPressed(0, 47) and v.koz < 100 and koz.obj and carryingKoz then
                    kozle(v)

                end
                if not sessionStarted then
                    DrawText3D(coords + 0.20, "[~g~K~s~] -  Smoke | [~g~G~s~] - Add Hookah Embers | ".. ' Hookah Embers : '.. v.koz, 0.55, 1.5)
                    if IsControlJustReleased(0, 311) then

                        currentHookah = v.obj
                        hookahIc(v.table)
                
                    end  
                else
                    if IsControlJustPressed(0, 74) and v.koz >  0 then -- Normal: H
                        TriggerServerEvent("hookah_smokes", PedToNet(ply))                            
                        TriggerServerEvent('codem-hookah:server:syncKoz', v.obj,  -5)
                        Citizen.Wait(5000)
                    end

                    if v.koz > 0 then
                        DrawText3D(coords + 0.7, "[~g~H~s~] - Smoke |  [~g~G~s~] - Add Hookah Embers | [~g~F~s~] - Stop Smoking ".. ' Hookah Embers : '.. v.koz, 0.55, 1.5)
                    else
                        DrawText3D(coords + 0.7, "[~g~F~s~] - Stop Smoking".. ' Hookah Embers : '.. v.koz, 0.55, 1.5)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if sessionStarted then
			local dist = #(GetEntityCoords(PlayerPedId(), true) - vector3(-625.7403, 233.51898, 81.881523))
			if dist > 20.0 or IsPedInAnyVehicle(PlayerPedId(), false) then
				sessionStarted = false
				SetEntityAsMissionEntity(marpuc, false, true)
				DeleteObject(marpuc)
				ClearPedTasks(PlayerPedId())
                ESX.ShowNotification("You cannot take the hookah outside the cafe")
			end
		end
	end
end)

function anim()
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

end

function hookahIc(masa)
   -- TriggerServerEvent('codem-hookah:server:setSessionStarted', masa, true)
    smoke()
    anim()
    local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	local model = GetHashKey('v_corp_lngestoolfd')
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(100)
	end								
	local obj = CreateObject(model,  coords.x+0.5, coords.y+0.1, coords.z+0.4, true, false, true)
	marpuc = obj
	AttachEntityToEntity(obj, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)	
    
    sessionStarted = true	
end

function smoke()
    Citizen.CreateThread(function()
        while true do
        local ped = PlayerPedId()
            Citizen.Wait(0)

            
            if IsControlJustReleased(0, 23) and sessionStarted then -- Normal: F
                sessionStarted = false
                SetEntityAsMissionEntity(marpuc, false, true)
                DeleteObject(marpuc)
                currentHookah = nil


                ClearPedTasks(PlayerPedId())
    
            end
        end
    end)
end


p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("c_hookah_smokes")
AddEventHandler("c_hookah_smokes", function(c_ped)
	local p_smoke_location = {
		20279,
	}
	local p_smoke_particle = "exp_grd_bzgas_smoke"
	local p_smoke_particle_asset = "core" 


	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
			createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
			createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 5.0, 0.0, 0.0, 0.0)
			Wait(1000)
			StopParticleFxLooped(createdSmoke, 1)
			Wait(1000*2)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)

DrawText3D = function(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(vector - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry('STRING')
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(vector.xyz, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end
