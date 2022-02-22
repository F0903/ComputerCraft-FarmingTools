local farmSize = {x = 5, y = 10}
local totalFarmSize = farmSize.x * farmSize.y
local cropName = "minecraft:wheat"
local cropMatureAge = 7
local seedName = "minecraft:wheat_seeds"

local abort = false
local farming = false
local turnRight = false

function IsCropMature(blockData)
    if blockData.name ~= cropName then
        print("Crop is not as specified. Please specify crop in prog/Farmer.lua")
        abort = true
        return false
    end
    if blockData.state.age ~= cropMatureAge then
        print("Crop is not mature... Continuing...")
        return false
    end
    return true
end

function EquipSeeds()
    for i = 1, 16 do
        local info = turtle.getItemDetail(i)
        if info ~= nil and info.name == seedName then
            turtle.select(i)
            return true
        end
    end
    return false
end

function EquipCrop()
    for i=1, 16 do
        local info = turtle.getItemDetail(i)
        if info ~= nil and info.name == cropName then
            turtle.select(i)
            return true
        end
    end
    return false
end

function PlantCrop()
    EquipSeeds()
    turtle.placeDown()
end

function HarvestCrop()
    isBlock, blockData = turtle.inspectDown()
    if not isBlock or not IsCropMature(blockData) then
        return
    end
    if not turtle.digDown() then
        print("Could not dig down. Something might be wrong.")
        return
    end
    turtle.suckDown()
    PlantCrop()
end

function Forward()
    turtle.forward()
end

function Turn()
    if turnRight then
        turtle.turnRight()
        Forward()
        turtle.turnRight()
    else
        turtle.turnLeft()
        Forward()
        turtle.turnLeft()
    end
    turnRight = not turnRight
end

function DropHarvest()
    while EquipCrop() or EquipSeeds() do
        if not turtle.dropDown() then
            print("Harvest chest is full. Please empty.")
            return
        end
    end
end

function Return(x, y)
    print("Returning...")
    local isLevel = x % 2 == 0
    if not isLevel then
        turtle.turnLeft()
        turtle.turnLeft()
        for i=1, y do
            Forward()
        end
    end
    Forward()
    turtle.turnLeft()
    for i=1, farmSize.x - 1 do
        Forward()
    end
    turtle.turnLeft()
    DropHarvest()
end

function Refuel()
    local gotFuel = false
    for i=1, 16 do
        turtle.select(i)
        if turtle.refuel(1) then
            i = 17
            gotFuel = true
        end
    end
    return gotFuel
end

function CheckFuel()
    if turtle.getFuelLevel() < totalFarmSize + 3 then
        return Refuel()
    end
    return true
end

function Farm()
    if not CheckFuel() then
        print("Fuel critically low. Please refuel.")
        return
    end

    Forward()
    for x=1, farmSize.x do
        for y=1, farmSize.y - 1 do
            HarvestCrop()
            Forward()
            HarvestCrop()
            print("X = " .. x)
            print("Y = " .. y)
            if x == farmSize.x and y == farmSize.y - 1 then
                Return(x, y)
                return
            end
        end
        Turn()
    end
end

Farm()
