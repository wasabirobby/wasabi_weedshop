ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

RegisterServerEvent('wasabi_weedshop:buyItem')
AddEventHandler('wasabi_weedshop:buyItem', function(itemName, amount, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	amount = ESX.Round(amount)

	if amount < 0 then
		print('wasabi_weedshop: ' .. xPlayer.identifier .. ' attempted to exploit the weed shop!')
		return
	end


	local price = 0
	local itemLabel = ''

	for i=1, #Config.Zones[zone].Items, 1 do
		price = Config.Zones[zone].Items[i].price
		itemLabel = Config.Zones[zone].Items[i].label
		break
	end

	price = price * amount

	
	if xPlayer.getMoney() >= price then
		if Config.OldESX then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, Strings["cannot_hold"])
			else
				xPlayer.removeMoney(price)
				xPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, Strings["purchased"])
			end
		end
		if not Config.OldESX then
			if xPlayer.canCarryItem(sourceItem.name, amount) then
				xPlayer.removeMoney(price)
				xPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, Strings["purchased"])
			else
				TriggerClientEvent('esx:showNotification', _source, Strings["cannot_hold"])
			end
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, Strings["not_enough"])
	end
end)

ESX.RegisterUsableItem('rolledblunt', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rolledblunt', 1)
	TriggerClientEvent('wasabi_weedshop:smokeblunt', source)
end)

ESX.RegisterUsableItem('gelato_weed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local backWoods = xPlayer.getInventoryItem('backwoods')
    if backWoods.count >= 1 then
        xPlayer.removeInventoryItem('backwoods', 1)
        xPlayer.removeInventoryItem('gelato_weed', 1)
        Wait(200)
        xPlayer.addInventoryItem('rolledblunt', 1)
    else 
        --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have blunt wrap!', length = 4500 }) Maybe add later
		TriggerClientEvent('esx:showNotification', _source, Strings["no_wrap"])
    end
end)

ESX.RegisterUsableItem('gushers_weed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local backWoods = xPlayer.getInventoryItem('backwoods')
    if backWoods.count >= 1 then
        xPlayer.removeInventoryItem('backwoods', 1)
        xPlayer.removeInventoryItem('gushers_weed', 1)
        Wait(200)
        xPlayer.addInventoryItem('rolledblunt', 1)
    else 
		TriggerClientEvent('esx:showNotification', _source, Strings["no_wrap"])
    end
end)

ESX.RegisterUsableItem('gorilla_weed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local backWoods = xPlayer.getInventoryItem('backwoods')
    if backWoods.count >= 1 then
        xPlayer.removeInventoryItem('backwoods', 1)
        xPlayer.removeInventoryItem('gorilla_weed', 1)
        Wait(200)
        xPlayer.addInventoryItem('rolledblunt', 1)
    else 
		TriggerClientEvent('esx:showNotification', _source, Strings["no_wrap"])
    end
end)

ESX.RegisterUsableItem('sweeties_weed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local backWoods = xPlayer.getInventoryItem('backwoods')
    if backWoods.count >= 1 then
        xPlayer.removeInventoryItem('backwoods', 1)
        xPlayer.removeInventoryItem('sweeties_weed', 1)
        Wait(200)
        xPlayer.addInventoryItem('rolledblunt', 1)
    else 
		TriggerClientEvent('esx:showNotification', _source, Strings["no_wrap"])
    end
end)

ESX.RegisterUsableItem('wedding_weed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local backWoods = xPlayer.getInventoryItem('backwoods')
    if backWoods.count >= 1 then
        xPlayer.removeInventoryItem('backwoods', 1)
        xPlayer.removeInventoryItem('wedding_weed', 1)
        Wait(200)
        xPlayer.addInventoryItem('rolledblunt', 1)
    else 
		TriggerClientEvent('esx:showNotification', _source, Strings["no_wrap"])
    end
end)