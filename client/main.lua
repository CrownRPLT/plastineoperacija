local HasAlreadyEnteredMarker, IsInMainMenu = false, false
local LastZone, CurrentAction, CurrentActionMsg

-- Open Surgery Menu
function OpenSurgeryMenu()
	local playerPed = PlayerPedId()
	IsInMainMenu = true

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu) -- Not 100% sure what the difference is between openSaveableMenu & openRestrictedMenu
		menu.close()
		FreezeEntityPosition(playerPed, true)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'surgery_confirm', {
			title = _U('buy_surgery', ESX.Math.GroupDigits(Config.SurgeryPrice)),
			align = GetConvar('esx_MenuAlign', 'top-left'),
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_plastinesoperacijos:paySurgery', function(success)
					if success then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						IsInMainMenu = false
						FreezeEntityPosition(playerPed, false)
						menu.close()
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						ESX.ShowNotification(_U('not_enough_money'))
						IsInMainMenu = false
						FreezeEntityPosition(playerPed, false)
						menu.close()
					end
				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

				IsInMainMenu = false
				FreezeEntityPosition(playerPed, false)
				menu.close()
			end
		end, function(data, menu)
			IsInMainMenu = false
			FreezeEntityPosition(playerPed, false)
			menu.close()
			CurrentAction = 'surgery_menu'
		end)
	end, function(data, menu)
		IsInMainMenu = false
		FreezeEntityPosition(playerPed, false)
		menu.close()
		CurrentAction = 'surgery_menu'
	end, {
		'sex', 'face', 'skin', 'age_1', 'age_2', 'beard_1', 'beard_2', 'beard_3', 'beard_4', 'hair_1', 'hair_2', 'hair_color_1', 'hair_color_2',
		'eye_color', 'eyebrows_1', 'eyebrows_2', 'eyebrows_3', 'eyebrows_4', 'makeup_1', 'makeup_2', 'makeup_3', 'makeup_4', 'lipstick_1',
		'lipstick_2', 'lipstick_3', 'lipstick_4', 'blemishes_1', 'blemishes_2', 'blush_1', 'blush_2', 'blush_3', 'complexion_1', 'complexion_2',
		'sun_1', 'sun_2', 'moles_1', 'moles_2', 'chest_1', 'chest_2', 'chest_3', 'bodyb_1', 'bodyb_2'
		--'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'arms_2', 'pants_1', 'pants_2', 'shoes_1', 'shoes_2'
	})
end

-- Entered Marker
AddEventHandler('esx_plastinesoperacijos:hasEnteredMarker', function(zone)
	if zone == 'SurgeryLocations' then
		CurrentAction = 'surgery_menu'
		CurrentActionMsg = _U('surgery_menu', ESX.Math.GroupDigits(Config.SurgeryPrice))
	end
end)

-- Exited Marker
AddEventHandler('esx_plastinesoperacijos:hasExitedMarker', function(zone)
	if not IsInMainMenu or IsInMainMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInMainMenu then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

-- Create Blips
CreateThread(function()
	if Config.UseHospital and Config.UseHospitalBlips then
		for k,v in pairs(Config.Locations) do
			for i=1, #v.Healer, 1 do
				local blip = AddBlipForCoord(v.Healer[i])

				SetBlipSprite (blip, Config.BlipHospital.Sprite)
				SetBlipColour (blip, Config.BlipHospital.Color)
				SetBlipDisplay(blip, Config.BlipHospital.Display)
				SetBlipScale  (blip, Config.BlipHospital.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('healing_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end

	if Config.UseSurgeon and Config.UseSurgeonBlips then
		for k,v in pairs(Config.Locations) do
			for i=1, #v.Surgery, 1 do
				local blip = AddBlipForCoord(v.Surgery[i])

				SetBlipSprite (blip, Config.BlipSurgery.Sprite)
				SetBlipColour (blip, Config.BlipSurgery.Color)
				SetBlipDisplay(blip, Config.BlipSurgery.Display)
				SetBlipScale  (blip, Config.BlipSurgery.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('surgery_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Enter / Exit marker events & Draw Markers
CreateThread(function()
	while true do
		Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true, nil

		if Config.UseSurgeon then
			for k,v in pairs(Config.Locations) do
				for i=1, #v.Surgery, 1 do
					local distance = #(playerCoords - v.Surgery[i])

					if distance < Config.DrawDistance then
						letSleep = false

						if Config.SurgMarker.Type ~= -1 then
							DrawMarker(Config.SurgMarker.Type, v.Surgery[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.SurgMarker.x, Config.SurgMarker.y, Config.SurgMarker.z, Config.SurgMarker.r, Config.SurgMarker.g, Config.SurgMarker.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.SurgMarker.x then
							isInMarker, currentZone = true, 'SurgeryLocations'
						end
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			LastZone = currentZone
			TriggerEvent('esx_plastinesoperacijos:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_plastinesoperacijos:hasExitedMarker', LastZone)
		end

		if letSleep then
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'surgery_menu' then
					OpenSurgeryMenu()
				end

				CurrentAction = nil
			end
		end
	end
end)


-- Export
function getESXplastinesoperacijos(type)
	if type == 'surgeryP' then
		return ESX.Math.GroupDigits(Config.SurgeryPrice)
	end
end

function openESXplastinesoperacijos(type)
	if type == 'surgery' then
		OpenSurgeryMenu()
	end
end
