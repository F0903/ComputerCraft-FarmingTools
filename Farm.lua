local farmSize = 4*5
local cropName = "minecraft:wheat"
local cropMatureAge = 7
local seedName = "minecraft:wheat_seeds"

local abort = false
local farming = false
local turnRight = false

local moveCount = 0
local moves = {}

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
    local currentInfo = turtle.getItemDetail()
    if currentInfo.name == seedName then return end
    for i = 1, 16 do 
        local info = turtle.getItemDetail(i)
        if info.name == seedName then 
            turtle.select(i)
            return
        end
    end        
end

function TurnOnce()
    if turnRight then turtle.turnRight()
    else turtle.turnLeft() end
end

function TurnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

function SwingAround()
    TurnOnce()
    turtle.forward()
    TurnOnce()
    turtle.forward()
    turnRight = not turnRight
end

function ForwardOnce()
    turtle.forward()
end

function Return()
    for i=0, moveCount - 1 do
        local move = moves[i]
        turnRight = not move.dir
        move.f()
    end
end

function OnFinish()
    print("Finished harvest. Returning...")
    TurnAround()
    ForwardOnce()
    Return()
    TurnAround()
    print("Done!")
end

local count = 0
ForwardOnce()
while not abort and count < farmSize do
    local isBlock, blockData = turtle.inspectDown()     
    if not isBlock then
        SwingAround()
        moves[moveCount] = { f = SwingAround, dir = not turnRight }
        moveCount = moveCount + 1
        isBlock, blockData = turtle.inspectDown()
    end
    if isBlock and IsCropMature(blockData) then
        turtle.digDown()
        turtle.suckDown()
        EquipSeeds()
        turtle.placeDown()
    end
    ForwardOnce()
    moves[moveCount] = { f = ForwardOnce, dir = turnRight }
    moveCount = moveCount + 1
    count = count + 1
    if turtle.getFuelLevel() < 5 then 
        if not shell.run("Refuel") then
            print("Fuel is low, please refuel.")
            abort = true
        end
    end
end
OnFinish()
