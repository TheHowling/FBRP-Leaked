-- 2018 Henric 'Kekke' Johansson

ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local currentGear = 1
local gearSpeedFactor = 8
local dragVehicle = nil

local DEBUG = true
local isRacing = false

local isDisplayingPowerBar = false

local powerSpriteDict = 'custom'
local powerSpriteName = 'bar'

local tennisSpriteDict = 'tennis'
local swingMeterSprite = 'swingmetergrad'

local penaltyTime = 0
local timeShiftedGear = 0

local startPositions = {
	{x = 1053.0, y = 3079.0, z = 42.0},
	{x = 1056.0, y = 3070.0, z = 42.0},
	{x = 1059.0, y = 3061.0, z = 42.0},
}

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	if DEBUG then
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 255, 255, 255, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end
end

function drawGearBar()
	Citizen.CreateThread(function()

		isDisplayingPowerBar = true
		local swingOffset = 0.1
		local swingReversed = false

		while isDisplayingPowerBar do
			Citizen.Wait(0)

			DrawSprite(powerSpriteDict, powerSpriteName, 0.5, 0.4, 0.01, 0.2, 0.0, 255, 255, 255, 255)

			DrawSprite(tennisSpriteDict, swingMeterSprite, 0.5, 0.4 + swingOffset, 0.025, 0.002, 180.0, 0, 0, 0, 255)

			--local decrease = ((1 * gearSpeedFactor * 1.01) - ((GetEntitySpeed(dragVehicle) - (currentGear - 1 * gearSpeedFactor * 1.01))))
			local increase = ((GetEntitySpeed(dragVehicle) - ((currentGear - 1) * gearSpeedFactor * 1.01))) / (1 * gearSpeedFactor * 1.01)
			local percentage = increase * 100
			swingOffset = (percentage / 5 / 100) - 0.1

			DrawAdvancedText(0.5, 0.65, 0.005, 0.0028, 0.4, "swing baby: " .. percentage, 255, 255, 255, 255, 0, 0)
			DrawAdvancedText(0.5, 0.7, 0.005, 0.0028, 0.4, "max: " .. (1 * gearSpeedFactor * 1.01), 255, 255, 255, 255, 0, 0)
			DrawAdvancedText(0.5, 0.75, 0.005, 0.0028, 0.4, "current: " .. (GetEntitySpeed(dragVehicle) - ((currentGear - 1) * gearSpeedFactor * 1.01)), 255, 255, 255, 255, 0, 0)
		end
	end)
end

RegisterNetEvent('fbrp_dragrace:startRace')
AddEventHandler('fbrp_dragrace:startRace', function(startPositionIndex)
	-- todo
	isRacing = not isRacing
	currentGear = 1

	ESX.Game.SpawnVehicle('flashgt', startPositions[startPositionIndex], 284.0, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)

	drawGearBar()
end)

isGearTooHigh = function()
	if GetEntitySpeed(dragVehicle) < currentGear * gearSpeedFactor * 1.01 - 12.0 then
		return true
	end

	return false
end

getPenaltyTime = function()
	local increase = ((GetEntitySpeed(dragVehicle) - ((currentGear - 1) * gearSpeedFactor * 1.01))) / (1 * gearSpeedFactor * 1.01)
	local percentage = increase * 100

	-- return 10ms per % from 100% RPM 
	return (100 - percentage) * 100
end

-- Main thread
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	RequestStreamedTextureDict(powerSpriteDict, false)
	RequestStreamedTextureDict(tennisSpriteDict, false)

	while not HasStreamedTextureDictLoaded(powerSpriteDict) or not HasStreamedTextureDictLoaded(tennisSpriteDict) do
		Wait(100)
	end

	while true do
		Citizen.Wait(0)

		if IsPedInAnyVehicle(PlayerPedId(), false) and isRacing then
			dragVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--SetFollowVehicleCamViewMode(4)
			--SetVehicleHandlingVector(dragVehicle, 'CHandlingData', 'fSteeringLock', 0.0)

			if GetPedInVehicleSeat(dragVehicle, -1) == GetPlayerPed(-1) then
				-- Player is driving
				SetEntityMaxSpeed(dragVehicle, currentGear * gearSpeedFactor * 1.01)

				if penaltyTime ~= 0 and GetGameTimer() - (timeShiftedGear + penaltyTime) > 0 then
					currentGear = currentGear + 1
					print('växlade: ' .. penaltyTime)
					penaltyTime = 0
				end

				if IsControlJustReleased(0, Keys['TOP']) and penaltyTime == 0 then
					timeShiftedGear = GetGameTimer() 
					penaltyTime = math.floor(getPenaltyTime()) + 1
					print("penalty time: " .. penaltyTime .. ' och nu: ' .. GetGameTimer())

				elseif IsControlJustReleased(0, Keys['DOWN']) then
					--currentGear = currentGear - 1
				end

				if currentGear < 1 then
					currentGear = 1
				elseif currentGear > 8 then
					currentGear = 8
				end

				if isGearTooHigh() then
					currentGear = currentGear - 1
					SetVehicleEngineOn(dragVehicle, false, true, false)
					DrawAdvancedText(0.5, 0.65, 0.005, 0.0028, 0.4, "Du har för hög växel i", 255, 255, 255, 255, 0, 0)
				end

				DrawAdvancedText(0.5, 0.4, 0.005, 0.0028, 0.4, "Växel: " .. currentGear, 255, 255, 255, 255, 0, 0)
				DrawAdvancedText(0.5, 0.5, 0.005, 0.0028, 0.4, "Hastighet: "..GetEntitySpeed(dragVehicle), 255, 255, 255, 255, 0, 0)
				DrawAdvancedText(0.5, 0.55, 0.005, 0.0028, 0.4,"Top-hastighet: "..currentGear * gearSpeedFactor * 1.01, 255, 255, 255, 255, 0, 0)
				DrawAdvancedText(0.5, 0.6, 0.005, 0.0028, 0.4, "SANT: " .. ((currentGear - 1) * gearSpeedFactor * 1.01), 255, 255, 255, 255, 0, 0)
			end
		end
	end
end)