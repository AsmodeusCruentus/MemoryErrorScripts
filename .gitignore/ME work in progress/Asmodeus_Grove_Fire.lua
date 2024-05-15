local API = require("api")
local UTILS = require("utils")

-- Function to click the bonfire
local function bonfire()
    API.DoAction_Object1(0x41, 0, { 43894 }, 50) -- Click the Bonfire
    UTILS.randomSleep(7500) -- Sleep for the action to complete(Edit this Sleep with the appropriate sleep designated in the Trees above and their sleep function)
end

-- Function to click the bank
local function bank()
    API.DoAction_Object1(0x33, 240, { 43807 }, 50)
    UTILS.randomSleep(1500) -- Sleep for the action to complete(Edit this Sleep with the appropriate sleep designated in the Trees above and their sleep function)
end

-- Function for idle check
local afk = os.time() -- Initialize the afk variable with the current time
local MAX_IDLE_TIME_MINUTES = 9

local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
    end
end

-- Main logic
API.Write_LoopyLoop(true)
while API.Read_LoopyLoop() do
    bonfire() -- Click the tree
	API.DoRandomEvents()
    
    local inventoryCount = API.Invfreecount_()

    if inventoryCount == 28 then
        bank() -- Click the log pile to deposit logs when the inventory is completely empty
    end

    idleCheck() -- Call the idleCheck function

    UTILS.randomSleep(900) -- Sleep between iterations (adjust as needed)
end
