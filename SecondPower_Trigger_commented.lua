function(allstates,event,arg1,arg2,...)

    local unitPowerIndex,unitPowerName,maxPower = aura_env.GetUnitPowerType("player");
    local unitClass = UnitClassBase("player");
    
    if event == "UNIT_POWER_UPDATE" then
        
        if arg1 ~= "player" or arg2 ~= unitPowerName then

            return true;

        end
        
        if arg1 == "player" and arg2 == unitPowerName then

            -- ChatFrame3:AddMessage(UnitPower("player",7,true) * 0.1)
            
            for currentPower=1,maxPower do

                allstates["power"..currentPower].value = aura_env.GetPowerValue(currentPower,unitPowerIndex);
                allstates["power"..currentPower].show = true;
                allstates["power"..currentPower].changed = true;

            end

            return true;

        end
        
    elseif event == "PLAYER_ENTERING_WORLD" then

        aura_env.CreateStates(allstates,maxPower,unitPowerIndex);
        
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