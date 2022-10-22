-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ESX = exports["es_extended"]:getSharedObject()
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

function OpenShopMenu(zone)
	SendNUIMessage{
		message		= "show",
		clear = true
	}

	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		SendNUIMessage{
			message		= "add",
			item		= item.item,
			label      	= item.label,
			item       	= item.item,
			price      	= item.price,
			max        	= item.limit,
			loc			= zone
		}

	end

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

AddEventHandler('wasabi_weedshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = Strings["press_menu"]
	CurrentActionData = {zone = zone}
end)

AddEventHandler('wasabi_weedshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
CreateThread(function()
	for k,v in pairs(Config.Zones) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
			SetBlipSprite (blip, 469)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 2)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Strings["blip_name"])
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Display markers
CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				local shopCoord = vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				local shopDist = #(coords - shopCoord)
				if Config.Type ~= -1 and shopDist < Config.DrawDistance then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		Wait(10)
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				local shopCoord = vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				local shopDist = #(coords - shopCoord)
				if shopDist < Config.Size.x then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('wasabi_weedshop:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('wasabi_weedshop:hasExitedMarker', LastZone)
		end
		Wait(10)
	end
end)

-- Key Controls
CreateThread(function()
	while true do
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			elseif IsControlJustReleased (0, 44) then
				ESX.SetTimeout(200, function()
					SetNuiFocus(false, false)
				end)
			end

		else
			Wait(500)
		end
		Wait(10)
	end
end)

closeGui = function()
  	SetNuiFocus(false, false)
  	SendNUIMessage{message = "hide"}
end

RegisterNUICallback('quit', function(data, cb)
  	closeGui()
  	cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
	TriggerServerEvent('wasabi_weedshop:buyItem', data.item, data.count, data.loc)
	cb('ok')
end)

RegisterNetEvent('wasabi_weedshop:smokeblunt')
AddEventHandler('wasabi_weedshop:smokeblunt', function()
  local playerPed = PlayerPedId()

    RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
    	Wait()
    end

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@hipster@a", true)

    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.3)
	SetPlayerMaxArmour(player, 100)
	AddArmourToPed(ESX.PlayerData.ped, 20)

    Wait(60000)
	SetTimecycleModifier("classic")
	SetPedMotionBlur(playerPed, false)
    SetRunSprintMultiplierForPlayer(player, 1.0)
end)