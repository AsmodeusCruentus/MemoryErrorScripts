print("Scarab Catcher")
print("Created by Grundstadt")
print("Maintained by Asmodeus Cruentus")
--If the script goes too fast, increase the sleep times 
--If you want it to go faster, then lower them
--IF YOU CHANGE SOMETHING DO NOT COMPLAIN THAT IT IS BROKEN OR DOESN'T WORK
--The only things you should be changing are the flower ids and the max stack of scarabs you can have

local API = require("api")

local startXp = API.GetSkillXP("HUNTER")
local skillLvl = API.XPLevelTable(startXp)
local scarabStatus = true

---***DO NOT CHANGE ANY OF THESE IDS***---------------
--Scarab IDs
--These 4 are always the same. 
local scarabValues = {28711,28712,28713,28714,28715,28716,28717,28718}
--Croc state IDs
--Don't change these unless something is broken for you
local crocStates = {24584, 24592, 24589, 24594, 24587, 24586, 24591, 24590}
-------------------------------------------------------

---FLOWER IDS-----------
--ROSES         = 122495
--IRISES        = 122496
--HYDRANGEAS    = 122497
--HOLLYHOCKS    = 122498
--GOLDEN ROSE   = 122499
-----------------------
--Change this ID to the flower that you're going to be using
local flower = 122497

--Change this to the max stack of Scarabs you can have. 
--3 if you don't have the upgrade, 5 if you do
-- settings it to is not recommmended but will increase Shell yield when using Golden Roses
local maxStack = "5"

--Just used to track the amount of scarabs you have in your inventory

local fbOneQuantity, fbTwoQuantity = 0, 0

local startTime = os.time()
local chatTime = os.time()

local startTimeIdle = os.time()
local idleTimeThreshold = math.random(220, 260)

local function antiIdleTask()
    local currentTime = os.time()
    local elapsedTime = os.difftime(currentTime, startTimeIdle)

    if elapsedTime >= idleTimeThreshold then
        API.PIdle2()
        -- Reset the timer and generate a new random idle time
        startTimeIdle = os.time()
        idleTimeThreshold = math.random(220, 260)
        ScripCuRunning1 = "Timer interupt"
        print("Reset Timer & Threshhold")
    end
end


---GUI---
---Thank Higgins for the GUI---
-- Rounds a number to the nearest integer or to a specified number of decimal places.
local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Format script elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

local function calcProgressPercentage(skill, currentExp)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    if currentLevel == 120 then return 100 end
    local nextLevelExp = XPForLevel(currentLevel + 1)
    local currentLevelExp = XPForLevel(currentLevel)
    local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
    return math.floor(progressPercentage)
end

local function printProgressReport(final)
    local skill = "HUNTER"
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp)
    local xpPH = round((diffXp * 60) / elapsedMinutes)
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    IGP.radius = calcProgressPercentage(skill, API.GetSkillXP(skill)) / 100
    IGP.string_value = time ..
    " | " ..
    string.lower(skill):gsub("^%l", string.upper) ..
    ": " .. currentLevel .. " | XP/H: " .. formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp)


    IGP2.string_value = "Flower Basket 1 Quantity: " .. fbOneQuantity .. " | Flower Basket 2 Quantity: " .. fbTwoQuantity 
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(5, 5, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(61, 37, 20);
    IGP.string_value = "Scarab Catching"

    IGP2 = API.CreateIG_answer()
    IGP2.box_start = FFPOINT.new(5, 40, 0)
    IGP2.box_name = "Flowers"
    IGP2.colour = ImColor.new(61, 37, 20);
    IGP2.string_value = "Flower Quantity"
end

function drawGUI()
    DrawProgressBar(IGP)
    DrawProgressBar(IGP2)
end

setupGUI()
---END GUI---

--Gets the amount of scarabs that the player currently has stacked
--If you have achieved max stacks, the function returns false and it will stop clicking
local function getScarabStatus() 
    local scarabBar = API.Buffbar_GetIDstatus(52770)
    if scarabBar.id > 0 then 
        if scarabBar.text == maxStack then 
            print("Caught " .. maxStack .. " Scarabs, waiting for Croc to finish")
            scarabStatus = false
            API.RandomSleep2(300,300,300)
        end 
    else 
        scarabStatus = true
    end 
    return scarabStatus
end 

---Added this for people under level 30.. Didn't do too much testing sooooo good luck
local function catchPlain()
    local crocStateUnder30 = API.VB_FindPSett(10340).state
    local scarabUnder30 = {28711,28712,28713,28714,28715,28716,28717,28718}
    local crocStatesUnder30 = {24584, 24592, 24589, 24594, 24587, 24586, 24591, 24590}
    local arrIndex = 1
    for _,value in ipairs(scarabUnder30) do
        local skipValue = false
            if crocStateUnder30 == crocStatesUnder30[arrIndex] and value == scarabValues[arrIndex] then
                skipValue = true
            end
        if not skipValue and getScarabStatus()then
            API.DoAction_NPC(0x29, 3120, {value}, 50)
            API.RandomSleep2(200, 200, 200)
        end
        crocStateUnder30 = API.VB_FindPSett(10340).state
        arrIndex = arrIndex + 1 -- Move to the next index in the arrays
    end 
end

while API.Read_LoopyLoop() do 
    --Does Pumpkins, Seren, and the invention one
    API.DoRandomEvents()
    drawGUI()
    --Used to get the amount of scaras stacked. If it's 3 or 5 - depending on upgrads - script will wait until it resets
    local scarabBar = API.Buffbar_GetIDstatus(52770)

    --Used to get the flower quantity so it always stays at 25+ so we can always have 4 scarabs
    local flowerBasketVB = API.VB_FindPSett(10330).state

    fbOneQuantity = flowerBasketVB >> 18 & 0xfff
    --UGLY WORKAROUND TO GET QUANTITY FOR BASKET 2
    fbTwoQuantity = (flowerBasketVB - fbOneQuantity*262144) >> 12 & 0xfff

    --Used to get which scarab the croc is going after to avoid clicking on a scarab we can't get
    local crocState = API.VB_FindPSett(10340).state

    --Used to check if you are handling the croc
    local crocHandle = API.VB_FindPSett(10339).state

    if crocHandle < 0 then 
        print("Not Handling Croc")
        API.DoAction_NPC(0x29,1488,{ 28659 },API.OFF_ACT_InteractNPC_route)
        API.RandomSleep2(600,300,300)
    end    

    ---THIS IS FOR UNDER LEVEL 30 FEEL FREE TO IGNORE THIS IF YOU'RE HIGHER THAN 30---
    --You can also just remove this whole block of code if you want
    if skillLvl < 30 then 
        catchPlain()
        goto skip
    end 

    -- Used to refill flowers if flower quantity is at 24 or lower
    -- If the buff for stacking scarabs is gone
    -- and if the croc is not currently going after a scarab
    if (fbOneQuantity <= 24 or fbTwoQuantity <= 24) and scarabBar.id == 0 and crocState == -1 then 
        if API.InvItemFound2({52807,52808,52809,52810,52811}) == false then 
            print("NO FLOWERS FOUND IN INVENTORY, ENDING SCRIPT")
            break
        end 
        if fbOneQuantity <= 24 then 
            print("Flower Basket 1 Quantity under 25, refilling")
            API.DoAction_Object2(0x29, 240, { flower }, 50, WPOINT.new(3344.439453125, 3257.50390625, 1))
            API.RandomSleep2(600,600,600)
            API.WaitUntilMovingEnds()
        end
        if fbTwoQuantity <= 24 then 
            print("Flower Basket 2 Quantity under 25, refilling")
            API.DoAction_Object2(0x29, 240, { flower }, 50, WPOINT.new(3334.439453125, 3248.50390625, 1))
            API.RandomSleep2(600,600,600)
            API.WaitUntilMovingEnds()
        end 

        --You can use either Keyboard Press or the DoAction_Interface 
        --Test the out if you want

        --API.KeyboardPress32(0x20, 0)
        API.DoAction_Interface(0xffffffff,0xffffffff,0,1189,19,-1,API.OFF_ACT_GeneralInterface_Choose_option)
        API.RandomSleep2(600,600,600)     
    end


    if fbOneQuantity > 24  and fbTwoQuantity > 24 then
        local arrIndex = 1 -- Initialize the array index for crocStates
        for _, value in ipairs(scarabValues) do
            --Getting Flower Basket state in for loop so we can always check quant to make sure it is greater than 24
            --That way we don't lose xp by clicking on Plain whirligigs
            flowerBasketVB = API.VB_FindPSett(10330).state
            fbOneQuantity = flowerBasketVB >> 18 & 0xfff
            fbTwoQuantity = (flowerBasketVB - fbOneQuantity*262144) >> 12 & 0xfff
    
            -- Check if we need to skip the value based on crocState
            -- This makes it avoid clicking on the scarab that the croc is going after
            local skipValue = false
            if crocState == crocStates[arrIndex] and value == scarabValues[arrIndex] then
                skipValue = true
            end

            -- Jumps out of the for loop if either basket is at 24 flowers
            -- This is so the for loop doesn't have to go to completion before filling the baskets
            if (fbOneQuantity <= 24 or fbTwoQuantity <= 24) then 
                goto skip
            end 

            --If the script goes too fast, increase the sleep times 
            --If you want it to go faster, then lower them
                --IF YOU CHANGE SOMETHING DO NOT COMPLAIN THAT IT IS BROKEN OR DOESN'T WORK
            if not skipValue and getScarabStatus() and fbOneQuantity > 24 and fbTwoQuantity > 24 then
                API.DoAction_NPC(0x29, 1488, {value}, 50)
                API.RandomSleep2(300, 300, 300)
            end 

            --Gets the state of VB 10340 -> This is the Scarab that the crocoidle is going after
            crocState = API.VB_FindPSett(10340).state
            arrIndex = arrIndex + 1 -- Move to the next index in the arrays
        end
    end
    ::skip::
    printProgressReport()
    antiIdleTask()
    API.RandomSleep2(100, 100, 100)
end
