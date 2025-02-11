QBCore = exports['qb-core']:GetCoreObject()

local medicPedCoords = vector3(308.15, -1434.89, 29.87)
local ambulanceCoords = vector4(294.1, -1439.0, 29.8, 234.11)
local healingPed = nil
local currentBlip = nil
local pedsHealed = 0
local missionInProgress = false
local scenarios = {
    {coords = vector3(245.5, -1400.8, 30.5), scenario = "car_accident"},
    {coords = vector3(305.3, -1312.5, 30.3), scenario = "street_fight"},
    {coords = vector3(327.6, -1204.7, 30.2), scenario = "slip_and_fall"},
    {coords = vector3(410.1, -1110.5, 29.8), scenario = "overdose"},
    {coords = vector3(455.9, -1022.3, 28.9), scenario = "construction_accident"}
}

-- Crée le PNJ médecin
CreateThread(function()
    local model = `s_m_m_doctor_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local medicPed = CreatePed(4, model, medicPedCoords.x, medicPedCoords.y, medicPedCoords.z, 141.4, false, true)
    SetEntityInvincible(medicPed, true)
    FreezeEntityPosition(medicPed, true)
    TaskStartScenarioInPlace(medicPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

-- Interaction avec le médecin
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - medicPedCoords)

        if distance < 2.0 then
            QBCore.Functions.DrawText3D(medicPedCoords.x, medicPedCoords.y, medicPedCoords.z, "[E] Parler au Médecin")
            if IsControlJustPressed(0, 38) then
                if missionInProgress then
                    QBCore.Functions.Notify("Médecin : Terminez votre mission actuelle.")
                else
                    StartMissionDialogue()
                end
            end
        end
    end
end)

function StartMissionDialogue()
    missionInProgress = true
    QBCore.Functions.Notify("Médecin : Voici une ambulance, allez sauver des vies !", "primary")
    SpawnAmbulance()
    SpawnNextHealingScenario()
end

function SpawnAmbulance()
    local model = `ambulance`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local vehicle = CreateVehicle(model, ambulanceCoords.x, ambulanceCoords.y, ambulanceCoords.z, ambulanceCoords.w, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true)

    -- Déverrouillage du véhicule
    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
end

function SpawnNextHealingScenario()
    if pedsHealed >= #scenarios then
        QBCore.Functions.Notify("Retournez voir le médecin pour recevoir votre récompense.")
        missionInProgress = false
        TriggerServerEvent('rewardPlayer', pedsHealed) -- Envoie le nombre de PNJ soignés au serveur
        pedsHealed = 0
        return
    end

    local scenario = scenarios[math.random(#scenarios)] -- Choix aléatoire d'un scénario
    local model = `a_m_y_stwhi_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    healingPed = CreatePed(4, model, scenario.coords.x, scenario.coords.y, scenario.coords.z - 1.0, 0.0, false, true) -- Spawn au sol
    FreezeEntityPosition(healingPed, true)

    -- Différentes animations en fonction du scénario
    if scenario.scenario == "car_accident" then
        TaskStartScenarioInPlace(healingPed, "WORLD_HUMAN_BUM_SLUMPED", 0, true)
        QBCore.Functions.Notify("Accident de voiture détecté. Allez aider !")
    elseif scenario.scenario == "street_fight" then
        TaskStartScenarioInPlace(healingPed, "WORLD_HUMAN_STUPOR", 0, true)
        QBCore.Functions.Notify("Une bagarre a éclaté, une personne est blessée.")
    elseif scenario.scenario == "slip_and_fall" then
        TaskStartScenarioInPlace(healingPed, "WORLD_HUMAN_SUNBATHE_BACK", 0, true)
        QBCore.Functions.Notify("Une personne a glissé, allez la soigner.")
    elseif scenario.scenario == "overdose" then
        TaskStartScenarioInPlace(healingPed, "WORLD_HUMAN_BUM_SLUMPED", 0, true)
        QBCore.Functions.Notify("Possible overdose signalée, intervention requise.")
    elseif scenario.scenario == "construction_accident" then
        TaskStartScenarioInPlace(healingPed, "WORLD_HUMAN_STUPOR", 0, true)
        QBCore.Functions.Notify("Accident sur un chantier.")
    end

    -- Création du blip pour le patient
    currentBlip = AddBlipForCoord(scenario.coords.x, scenario.coords.y, scenario.coords.z)
    SetBlipSprite(currentBlip, 153)
    SetBlipColour(currentBlip, 1)
    SetBlipScale(currentBlip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Patient blessé")
    EndTextCommandSetBlipName(currentBlip)
    SetNewWaypoint(scenario.coords.x, scenario.coords.y)
end

CreateThread(function()
    while true do
        Wait(0)
        if healingPed and DoesEntityExist(healingPed) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local pedCoords = GetEntityCoords(healingPed)
            local distance = #(playerCoords - pedCoords)

            if distance < 2.0 then
                QBCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, "[E] Soigner le patient")
                if IsControlJustPressed(0, 38) then
                    HealPed()
                end
            end
        end
    end
end)

function HealPed()
    TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
    Wait(5000)
    ClearPedTasks(PlayerPedId())

    DeleteEntity(healingPed)
    RemoveBlip(currentBlip)
    pedsHealed = pedsHealed + 1

    SpawnNextHealingScenario()
end