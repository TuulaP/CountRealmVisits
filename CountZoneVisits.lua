
--dofile( "tablesave.lua" )


SLASH_CMTV1 = "/czv"
SLASH_CMTV2 = "/countzonevisits"


local options  = {
    ["totalSwaps"] = 0,
    class = "mega",
}

local realmsVisits = {} 
realmsVisits["magetower"] = 0



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

    print("CZV: Realms visited: " .. options["totalSwaps"]) 
 
    local mapID = C_Map.GetBestMapForUnit("player"); 
    local newRealmName = C_Map.GetMapInfo(mapID).name
   
    if realmsVisits[newRealmName] then
        realmsVisits[newRealmName] = realmsVisits[newRealmName] + 1
    else
        realmsVisits[newRealmName] = 1
    end


    options["totalSwaps"] = options["totalSwaps"] + 1
    
    local location, qty = maxFromHash(realmsVisits)

    
    print("CZV: " .. location .. " with " .. qty .. " visits")
        --// test save to file
    --assert( table.save( realmsVisits, "test_tbl2.lua" ) == nil )

end


SlashCmdList["CZV"] = CountZoneVisitsHandler


local frame = CreateFrame("FRAME", "FoobarAddonFrame");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
local function eventHandler(self, event, ...)
    CountZoneVisitsHandler();
end
frame:SetScript("OnEvent", eventHandler);



