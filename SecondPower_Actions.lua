function aura_env.GetPowerValue(currentPower,unitPowerIndex)

    local allPowerStatus;
    
    if UnitClassBase("player") == "WARLOCK" then
        allPowerStatus = UnitPower("player",unitPowerIndex,true) * 0.1;
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
        maxPower = 5;    
    elseif unitClass == "MONK" then
        local _,_,_,talentSelected = GetTalentInfoByID(22098,1);
        unitPowerIndex = 12;
        unitPowerName = "CHI";
        maxPower = talentSelected and 6 or 5;
    elseif unitClass == "ROGUE" then
        local _,_,_,talentSelected = GetTalentInfoByID(19240,1);
        unitPowerIndex = 4;
        unitPowerName = "COMBO_POINTS";
        maxPower = talentSelected and 6 or 5;
    elseif unitClass == "DRUID" then
        local _,catActive = GetShapeshiftFormInfo(2);

        if catActive then
            unitPowerIndex = 4;
            unitPowerName = "COMBO_POINTS";
            maxPower = UnitPowerMax("player",unitPowerIndex,true);
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

function aura_env.SetBarColor(class)

    local color;

    if class == "WARLOCK" then
        color = aura_env.config.soulShard;
    elseif class == "PALADIN" then
        color = aura_env.config.holyPower;
    elseif class == "MAGE" then
        color = aura_env.config.arcaneCharge;
    elseif (class == "ROGUE") or (class == "DRUID") then
        color = aura_env.config.comboPoints;
    elseif class == "MONK" then
        color = aura_env.config.chi;
    end

    return color[1],color[2],color[3],color[4];
end

function aura_env.CreateStates(allstates,maxPower,unitPowerIndex)

    for currentPower=1,maxPower do
        allstates["power"..currentPower] = {
            show = true,
            progressType = "static",
            total = 1,
            value = aura_env.GetPowerValue(currentPower,unitPowerIndex),
            name = currentPower,
            index = currentPower,
        };
    end
end

function aura_env.ClearStates(allstates)

    for _,value in pairs(allstates) do
        value.show = false;
    end
end