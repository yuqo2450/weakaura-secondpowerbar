--[[This function calculates the current value for each state in allstates.]]
function aura_env.GetPowerValue(currentPower,unitPowerIndex)

    local allPowerStatus;
    
    if UnitClassBase("player") == "WARLOCK" then
        allPowerStatus = UnitPower("player",unitPowerIndex,true) * 0.1;
        --ChatFrame3:AddMessage("Hello");
    elseif UnitClassBase("player") == "PALADIN" or "MONK" or "ROGUE" or "DRUID" or "MAGE" then
        allPowerStatus = UnitPower("player",unitPowerIndex,true);
    end

    if allPowerStatus >= currentPower then
        return 1;
    elseif currentPower - allPowerStatus > 1 then        
        return 0;
    else
        return allPowerStatus - (currentPower - 1);
    end    
end

--[[This function sets values for different classes to apply the correct SecondPower
    to each class.]]
function aura_env.GetUnitPowerType(unit)

    local unitPowerIndex,unitPowerName,maxPower;
    local unitClass = UnitClassBase(unit);
    
    if unitClass == "WARLOCK" then

        unitPowerIndex = 7;
        unitPowerName = "SOUL_SHARDS";
        maxPower = UnitPowerMax("player",unitPowerIndex,true) * 0.1;
        
    elseif unitClass == "PALADIN" then

        unitPowerIndex = 9;
        unitPowerName = "HOLY_POWER";
        --For event PLAYER_ENTERIN_WORLD this returns 3 instead of 5
        --maxPower = UnitPowerMax("player",unitPowerIndex,true);
        maxPower = 5;
    
    elseif unitClass == "MONK" then

        -- needed to check if Monk has selected #Ascension#
        local _,_,_,talentSelected = GetTalentInfoByID(22098,1);
        unitPowerIndex = 12;
        unitPowerName = "CHI";
        --For event PLAYER_ENTERIN_WORLD this returns 4 instead of 6
        --maxPower = UnitPowerMax("player",unitPowerIndex,true);
        maxPower = talentSelected and 6 or 5;

    elseif unitClass == "ROGUE" then

        -- needed to check if Rogue has selected #Ascension#
        local _,_,_,talentSelected = GetTalentInfoByID(19240,1);
        unitPowerIndex = 4;
        unitPowerName = "COMBO_POINTS";
        --For event PLAYER_ENTERING_WORLD this returns 4 instead of 5 or 6
        --maxPower = UnitPowerMax("player",unitPowerIndex,true);
        maxPower = talentSelected and 6 or 5;

    elseif unitClass == "DRUID" then

        local _,catActive = GetShapeshiftFormInfo(2);
        --This has to be checked so the bars only appear when in cat form on #PLAYER_ENTERING_WORLD# event
        if catActive then

            unitPowerIndex = 4;
            unitPowerName = "COMBO_POINTS";
            maxPower = UnitPowerMax("player",unitPowerIndex,true);
        -- Since wow version 9.0.5 lua for loops don't accept nil as a limiter so maxPower has to be set to 0 if not in cat
        else
            unitPowerIndex = 0;
            unitPowerName = "";
            maxPower = 0;

        end

    elseif unitClass == "MAGE" then
        unitPowerIndex = 16;
        unitPowerName = "ARCANE_CHARGES";
        maxPower = UnitPowerMax("player",unitPowerIndex,true);
    end

    return unitPowerIndex,unitPowerName,maxPower;

end

--[[This function changes the color of each bar to the maching SecondPower color.
    These colors can be changed in the #Custom Options# panel.
    Default Colors match the Blizzard color code.]]
function aura_env.SetBarColour(class)

    local color;

    if class == "WARLOCK" then
        color = aura_env.config.soulShard;
    elseif class == "PALADIN" then
        color = aura_env.config.holyPower;
    elseif class == "MONK" then
        color = aura_env.config.chi;
    elseif class == "MAGE" then
        color = aura_env.config.arcaneCharge;
    elseif class == "ROGUE" or "DRUID" then
        color = aura_env.config.comboPoints;
    end

    return color[1],color[2],color[3],color[4];
end

--[[This function initializes the allstates table]]
function aura_env.CreateStates(allstates,maxPower,unitPowerIndex)

    for currentPower=1,maxPower do

        allstates["power"..currentPower] = {
            show = true,
            progressType = "static",
            total = 1,
            value = aura_env.GetPowerValue(currentPower,unitPowerIndex),
            name = currentPower,
            -- This attribute is needed for the right order
            index = currentPower,
        };

    end
end

--[[This function is needed to Clear the allstates table when SecondPowers are
    not existent anymore.]]
function aura_env.ClearStates(allstates)

    for _,value in pairs(allstates) do
        value.show = false;
    end
end