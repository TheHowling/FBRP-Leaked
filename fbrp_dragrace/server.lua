ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('fbrp_dragrace:cb', function(source, cb, targetPlayer, confirmText)
	
end)

RegisterServerEvent('fbrp_dragrace:event')
AddEventHandler('fbrp_dragrace:event', function()

end)

RegisterCommand("dragrace", function(source, args, rawCommand)
	local xPlayers = ESX.GetPlayers()

	TriggerClientEvent('fbrp_dragrace:startRace', 4, 1)
	TriggerClientEvent('fbrp_dragrace:startRace', 9, 2)
	TriggerClientEvent('fbrp_dragrace:startRace', 10, 3)
	--TriggerClientEvent('fbrp_dragrace:startRace', 10, 2)
end, true)