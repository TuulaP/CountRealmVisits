
--dofile( "tablesave.lua" )


SLASH_CMTV1 = "/czv"
SLASH_CMTV2 = "/countzonevisits"


local options  = {
    ["totalSwaps"] = 0,
    class = "mega",
}

local zoneVisits = {} 
zoneVisits["magetower"] = 0



local function maxFromHash(hash) 

    local max = 0
    local key = nil
    for k,v in pairs(hash) do
        if v > max then
            max = v
            key = k
        end
    end

    return key, max;


end


local function CountZoneVisitsHandler()

    print("CZV: Realms visited: " .. options["totalSwaps"])  -- BUG?
 
    if CountZoneVisitsData == nil then
        -- This is the first time this addon is loaded; set SVs to default values
        CountZoneVisitsData = 0
    end

    local mapID = C_Map.GetBestMapForUnit("player"); 
    local zoneName = C_Map.GetMapInfo(mapID).name
   
    if zoneVisits[zoneName] then
        zoneVisits[zoneName] = zoneVisits[zoneName] + 1
    else
        zoneVisits[zoneName] = 1
    end


    options["totalSwaps"] = options["totalSwaps"] + 1
    
    local location, qty = maxFromHash(zoneVisits)

    CountZoneVisitsData = options["totalSwaps"]

    print("CZV: " .. location .. " with " .. qty .. " visits")
        --// test save to file
    --assert( table.save( zoneVisits, "test_tbl2.lua" ) == nil )

end


SlashCmdList["CZV"] = CountZoneVisitsHandler


local frame = CreateFrame("FRAME", "FoobarAddonFrame");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
local function eventHandler(self, event, ...)
    CountZoneVisitsHandler();
end
frame:SetScript("OnEvent", eventHandler);


local frame2 = CreateFrame("FRAME", "FoobarAddonFrame2");

frame2:RegisterEvent("ADDON_LOADED")
frame2:RegisterEvent("PLAYER_LOGOUT")

frame2:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "CountZoneVisits" then
        -- Our saved variables, if they exist, have been loaded at this point.
        if CountZoneVisitsData == nil then
            -- This is the first time this addon is loaded; set SVs to default values
            CountZoneVisitsData = 0
        end

        if CountZoneVisitsData == nil then
            -- Haven't yet seen this character, so increment the number of characters met
            CountZoneVisitsData = CountZoneVisitsData + 1
            options['totalSwaps'] = CountZoneVisitsData
        end

    elseif event == "PLAYER_LOGOUT" then
            -- Save the time at which the character logs out
            CountZoneVisitsData = options["totalSwaps"]
    end
end)

