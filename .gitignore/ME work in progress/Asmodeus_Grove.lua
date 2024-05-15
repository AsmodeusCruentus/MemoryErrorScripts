local API = require("api")
local UTILS = require("utils")

--Normal Tree ID = 119459 // Sleep 2500 - log pile sleep 1500
--Oak Tree ID = 125564  // Sleep 6500 - Log pile sleep 1500
--Willow Tree ID = 125487, 125488 // sleep 7500 - Log pile sleep 8000
--Yew Tree ID = 125490 // sleep 5500 - Log pile sleep 1500
--Elder Tree ID = 125584 // sleep 10500 - log pile sleep 4500
--Sleep is Seperated into two parts,, one part tree chopping interval, one part delay for clicking tree after interacting with log pile
--the Log timers are more importand than the tree timers since depending on tree, run time to log pile varies

-- Function to click a tree
local function clickTree()
    API.DoAction_Object1(0x3b, 0, { 125490 }, 50) -- Click the tree
    UTILS.randomSleep(7500) -- Sleep for the action to complete(Edit this Sleep with the appropriate sleep designated in the Trees above and their sleep function)
end

-- Function to click the log pile
local function clickLogPile()
    API.DoAction_Object1(0x29, 0, { 125466 }, 50) -- Click the log pile
    UTILS.randomSleep(1500) -- Sleep for the action to complete(Edit this Sleep with the appropriate sleep designated in the Trees above and their sleep function)
end

-- Function for idle check
local afk = os.time() -- Initialize the afk variable with the current time
local MAX_IDLE_TIME_MINUTES = 5

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
    clickTree() -- Click the tree
	API.DoRandomEvents()
    
    local inventoryCount = API.Invfreecount_()

    if inventoryCount == 0 then
        clickLogPile() -- Click the log pile to deposit logs when the inventory is completely empty
    end

    idleCheck() -- Call the idleCheck function

    UTILS.randomSleep(900) -- Sleep between iterations (adjust as needed)
end
