function(allstates,event,arg1,arg2,...)

    local unitPowerIndex,unitPowerName,maxPower = aura_env.GetUnitPowerType("player");
    local unitClass = UnitClassBase("player");
   
    if event == "UNIT_POWER_UPDATE" then
        
        if arg1 ~= "player" or arg2 ~= unitPowerName then
            return true;
        end
        
        if arg1 == "player" and arg2 == unitPowerName then
          
            aura_env.SetPowerValue(allstates,maxPower,unitPowerIndex)
            return true;
        end

    elseif event == "RUNE_POWER_UPDATE" then

        print("updated rune!")
        
    elseif event == "PLAYER_ENTERING_WORLD" then

        if unitClass == "DEATHKNIGHT" then
            aura_env.CreateDKStates(allstates,maxPower);
            print("using DK runes!")
        else
            aura_env.CreateStates(allstates,maxPower,unitPowerIndex);
            print("not using DK runes!")
        end
        return true;

    elseif event == "PLAYER_TALENT_UPDATE" then

        aura_env.ClearStates(allstates);
        aura_env.CreateStates(allstates,maxPower,unitPowerIndex);
        return true;

    elseif event =="UPDATE_SHAPESHIFT_FORM" and unitClass == "DRUID" then

        local _,catActive = GetShapeshiftFormInfo(2);
        
        if catActive then
            aura_env.CreateStates(allstates,maxPower,unitPowerIndex);
        elseif next(allstates) == nil then
            return true;
        else
            aura_env.ClearStates(allstates);
        end

        return true;
    end
end