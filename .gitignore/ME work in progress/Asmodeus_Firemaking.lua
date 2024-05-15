local API = require("api")

local startXp = API.GetSkillXP("FIREMAKING")
local skillLvl = API.XPLevelTable(startXp)
local afk = os.time() -- Initialize the afk variable with the current time


local startTime = os.time()
local chatTime = os.time()

local startTimeIdle = os.time()
local idleTimeThreshold = math.random(220, 260)

local MAX_IDLE_TIME_MINUTES = 5


local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
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
    local skill = "FIREMAKING"
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
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(5, 5, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(61, 37, 20);
    IGP.string_value = "Burning logs"

end

function drawGUI()
    DrawProgressBar(IGP)
end

setupGUI()
---END GUI---

local function bonfire()
    API.DoAction_Object1(0x41,0,{ 43894 },50); -- fill in the action
    API. -- likely a confirm action here for the interface that pops up 
    API.WaitUntilMovingandAnimEnds()
    end
    
    local function bank()
    API.Do-- you get the gist, now the load preset function of right clicking bank chest
    API.WaitUntilMovingandAnimEnds()
    end


while API.Read_LoopyLoop() do 
    --Does Pumpkins, Seren, and the invention one
    API.DoRandomEvents()
    drawGUI()
   

    ::skip::
    printProgressReport()
    idleCheck()
    API.RandomSleep2(100, 100, 100)
end
