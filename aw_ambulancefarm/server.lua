RegisterNetEvent('rewardPlayer')
AddEventHandler('rewardPlayer', function(pedsHealed)
    local player = source
    local rewardAmount = pedsHealed * 100 -- 100$ par patient soigné

    -- Ajout de l'argent au joueur
    local xPlayer = QBCore.Functions.GetPlayer(player)
    if xPlayer then
        xPlayer.Functions.AddMoney('cash', rewardAmount)
        TriggerClientEvent('QBCore:Notify', player, "Vous avez reçu " .. rewardAmount .. "$ pour avoir soigné " .. pedsHealed .. " patients.")
    end
end)
