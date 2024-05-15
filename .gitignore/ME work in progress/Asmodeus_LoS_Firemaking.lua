local API = require("api")
local UTILS = require("utils")
--UI and XP tracking from Higgins
--Higgins is a Scholar and a Gentleman


-- Function to click the Bonfire
local function Bonfire()
    API.DoAction_Object1(0x41,0,{ 43897 },50) -- Click the Bonfire
    API.RandomSleep2(10000, 5000, 20000)
end

-- Function to withdraw the last preset selected from the bank/chest
local function Loadpreset()
    print("Loading your last preset")
    API.DoAction_Object1(0x33,240,{ 43807 },50) -- withdraws last preset from chest
    API.RandomSleep2(2500, 3050, 12000)
    print("Last preset loaded")
    presetLoaded = true
end


-- Function for idle check and Skill check
local afk, startTime = os.time(), os.time() -- Initialize the afk variable with the current time
local skill = "FIREMAKING"
local startXp = API.GetSkillXP(skill)
local MAX_IDLE_TIME_MINUTES = 9

local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
    end
end

local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

local function formatNumber(num)
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
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp);
    local xpPH = round((diffXp * 60) / elapsedMinutes);
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
    IGP.colour = ImColor.new(6, 82, 221);
    IGP.string_value = "BONFIRE FIREMAKING"
end

local function drawGUI()
    DrawProgressBar(IGP)
end

setupGUI()

-- Main loop
while (API.Read_LoopyLoop()) do
    idleCheck() -- Call the idleCheck function
    drawGUI()
    API.DoRandomEvents()
	if API.Invfreecount_() == 28 then
		Loadpreset()
	else
		Bonfire()
	end
    ::continue::
    printProgressReport()
    API.RandomSleep2(50, 100, 100)
end