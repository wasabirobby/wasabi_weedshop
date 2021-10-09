Config = {}
Config.DrawDistance = 100
Config.Size = {x = 0.5, y = 0.5, z = 0.5}
Config.Color = {r = 0, g = 128, b = 255}
Config.Type = 0
Config.OldESX = false

Config.Zones = {
	HookahLounge = {
		Items = {
			{item = 'backwoods', label = 'Backwoods Cigars', price = 25, limit = -1}, --If NOT using Old ESX, just set to -1 for limit
			{item = 'gelato_weed', label = 'Gelato No.33', price = 60, limit = -1},
			{item = 'gorilla_weed', label = 'Gorilla Glue', price = 82, limit = -1},
			{item = 'gushers_weed', label = 'Gushers', price = 58, limit = -1},
			{item = 'sweeties_weed', label = 'Sweeties', price = 58, limit = -1},
			{item = 'wedding_weed', label = 'Wedding Cake', price = 61, limit = -1},
		},
		Pos = {
			{x = -633.41,   y = 236.19,  z = 81.88}
		}
	}
}

Config.hookahYap = { --Hookah/Embers collecting
    coords = vector3(-635.5601, 233.80023, 81.88153),
}

Config.Masalar = { -- Hookah tables
    ['masa1'] = {
        coords =  vector3(-624.4308, 235.83943, 81.731251),
        alreadyHaveHookah = false,
    },
    ['masa2'] = {
        coords =  vector3(-619.482, 231.2573,  81.731251),
        alreadyHaveHookah = false,
    },
    ['masa3'] = {
        coords =  vector3(-626.8977, 231.6661, 81.731251),
        alreadyHaveHookah = false,
    },   
    ['masa4'] = {
        coords =  vector3(-630.1084, 236.72761, 81.731251),
        alreadyHaveHookah = false,
    },
    ['masa5'] = {
        coords =   vector3(-633.453, 237.29647, 86.149487),
        alreadyHaveHookah = false,
    },
    ['masa6'] = {
        coords =  vector3(-637.1328, 232.70741, 86.149487),
        alreadyHaveHookah = false,
    },
    ['masa7'] = {
        coords =  vector3(-630.662, 241.22686, 86.143002),
        alreadyHaveHookah = false,
    },
    ['masa8'] = {
        coords =  vector3(-624.7784, 238.54182, 86.149002),
        alreadyHaveHookah = false,
    },     
    ['masa9'] = {
        coords =  vector3(-625.9837, 241.92947, 86.149002),
        alreadyHaveHookah = false,
    },     
    ['masa10'] = {
        coords =  vector3(-621.3502, 241.97508, 86.149002),
        alreadyHaveHookah = false,
    },     
    ['masa11'] = {
        coords =  vector3(-628.6834, 237.03849, 86.122364),
        alreadyHaveHookah = false,
    }               
}



Strings = {
    ["press_menu"] = "Press ~r~[E]~s~ to access the ~y~store~s~.",
	["blip_name"] = "Weed Shop",
	["cannot_hold"] = "You do ~r~not~s~ have enough ~y~free space~s~ in your inventory!",
	["purchased"] = "You ~g~successfully~s~ purchased some products!",
	["not_enough"] = "~r~You do not have the money to cover this purchase!~s~",
    ["no_wrap"] = "~r~You do not have blunt wrap!~s~",
	
}
