
-- Pay for Surgery
ESX.RegisterServerCallback('esx_plastinesoperacijos:paySurgery', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.SurgeryPrice

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
			account.addMoney(price)
		end)
		xPlayer.showNotification(_U('surgery_paid', ESX.Math.GroupDigits(price)))

		cb(true)
	else
		cb(false)
	end
end)
