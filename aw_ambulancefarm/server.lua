QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rewardPlayer')
AddEventHandler('rewardPlayer', function(pedsHealed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local reward = pedsHealed * 10 -- 10 par personne soignée
        Player.Functions.AddMoney('cash', reward)
        TriggerClientEvent('QBCore:Notify', src, "Merci pour votre aide ! Voici votre récompense : $" .. reward .. ".", "success")
    end
end)