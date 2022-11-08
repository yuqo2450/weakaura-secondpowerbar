function(allstates,event,arg1,arg2,...)
    
  local powerIndex,powerName,maxPower = aura_env.GetUnitPowerType("player");
  local class = UnitClassBase("player");
  
  if event == "UNIT_POWER_UPDATE" then
      
    if arg1 == "player" and arg2 == powerName and class ~= "DEATHKNIGHT" then          
      aura_env.SetPowerValue(allstates,maxPower,powerIndex);
    end
    return true;
      
  elseif event == "RUNE_POWER_UPDATE" and class == "DEATHKNIGHT" then
      
    aura_env.SetDKRunes(allstates,maxPower);
    return true;
      
  elseif event == "PLAYER_ENTERING_WORLD" then
      
    if class == "DEATHKNIGHT" then
      aura_env.SetDKRunes(allstates,maxPower);
    else
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    end
    return true;
      
  elseif event == "PLAYER_TALENT_UPDATE" then
      
    aura_env.ClearStates(allstates);
    aura_env.CreateStates(allstates,maxPower,powerIndex);
    return true;
      
  elseif event =="UPDATE_SHAPESHIFT_FORM" and class == "DRUID" then
      
    local _,catActive = GetShapeshiftFormInfo(2);
    
    if catActive then
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    elseif next(allstates) == nil then
      return true;
    else
      aura_env.ClearStates(allstates);
    end
    
    return true;
  end
end

