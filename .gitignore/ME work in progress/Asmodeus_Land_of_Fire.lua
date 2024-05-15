local API = require("api")
local UTILS = require("utils")
API.SetDrawTrackedSkills(true)

--bank chest id 43807 "Bank chest"
    --Needed for: DO::DoAction_Object(0x33,240,{ 43807 },50);
    --Needed for: DO::DoAction_Object(0x33,240,{ 43807 },50,{5034,9641,0});
    --Needed for: DO::DoAction_Object_r(0x33,240,{ ids },50,{5034,9641,0},5);
    --Needed for: API.DoAction_Object1(0x33,240,{ 43807 },50);
    --Needed for: API.DoAction_Object2(0x33,240,{ ids },50,WPOINT.new(5034,9641,0));
    --Needed for: API.DoAction_Object_r(0x33,240,{ ids },50,WPOINT.new(5034,9641,0),5);
    --Matching action: OFF_ACT::GeneralObject_route3
    --Matching action: API.OFF_ACT_GeneralObject_route3

--bonfire id 43084
    --object id?:43894 might be wrong
    --Needed for: DO::DoAction_Object(0x41,0,{ ids },50);
    --Needed for: DO::DoAction_Object(0x41,0,{ ids },50,{5022,9639,0});
    --Needed for: DO::DoAction_Object_r(0x41,0,{ ids },50,{5022,9639,0},5);
    --Needed for: API.DoAction_Object1(0x41,0,{ ids },50);
    --Needed for: API.DoAction_Object2(0x41,0,{ ids },50,WPOINT.new(5022,9639,0));
    --Needed for: API.DoAction_Object_r(0x41,0,{ ids },50,WPOINT.new(5022,9639,0),5);
    --Matching action: OFF_ACT::GeneralObject_route0
    --Matching action: API.OFF_ACT_GeneralObject_route0
--random sleep stuff
    --UTILS.randomSleep(150000) -- Sleep for the action to complete
    --API.RandomSleep2(2000, 600, 900) -- 2000 is base sleep ++ 1-600ms, 900is raresleep simulated afk or not paying attention
--


-- Function to click the Bonfire
local function Bonfire()
    API.DoAction_Object1(0x41,0,{ 43897 },50) -- Click the Bonfire
    API.RandomSleep2(150000, 5000, 20000)
end

-- Function to withdraw last preset
local function Bank()
	API.DoAction_Object1(0x33,240,{ 43807 },50)
    API.RandomSleep2(5000, 3000, 12000)
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

-- Main loop
API.Write_LoopyLoop(true)
while (API.Read_LoopyLoop()) do
    idleCheck() -- Call the idleCheck function
    API.DoRandomEvents()
	if API.Invfreecount_() == 0 then
		bank()
	else
		Bonfire()
	end
end





local startXp = API.GetSkillXP("FIREMAKING")