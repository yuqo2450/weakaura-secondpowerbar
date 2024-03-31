--[[
  Power creation trigger
  Events: PLAYER_SPECIALIZATION_CHANGED,TRAIT_CONFIG_UPDATED,PLAYER_ENTERING_WORLD,UPDATE_SHAPESHIFT_FORM,UNIT_POWER_UPDATE,RUNE_POWER_UPDATE,UNIT_AURA
  ]]
function (allstates,event,arg1,arg2,...)
  local class = UnitClassBase("player");
  local powerIndex,powerName,maxPower = aura_env.GetUnitPowerType("player");

  if event == "PLAYER_ENTERING_WORLD" then
    if class == "DEATHKNIGHT" then
      aura_env.SetDKRunes(allstates,maxPower);
    elseif class == "EVOKER" then
      aura_env.SetEssences(allstates,maxPower);
    else
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    end
    return true;

  elseif event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
    aura_env.ClearStates(allstates);
    if class == "DEATHKNIGHT" then
      aura_env.SetDKRunes(allstates,maxPower);
    elseif class == "EVOKER" then
      aura_env.SetEssences(allstates,maxPower);
    else
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    end
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

  elseif event == "UNIT_POWER_UPDATE" then
    if arg1 ~= "player" then
      return false;
    end

    if arg2 ~= powerName then
      return false;
    end

    if class == "DEATHKNIGHT" then
      return false;
    elseif class == "MONK" and GetSpecialization() == 1 then
      return false;
    elseif class == "EVOKER" then
      aura_env.SetEssences(allstates,maxPower)
      return true;
    end


    aura_env.TestStates(allstates, maxPower, powerIndex);
    aura_env.SetPowerValue(allstates,maxPower,powerIndex);
    return true;

  elseif event == "RUNE_POWER_UPDATE" then
    if class ~= "DEATHKNIGHT" then
      return false;
    end

    aura_env.TestStates(allstates, maxPower, powerIndex);
    aura_env.SetDKRunes(allstates, maxPower);
    return true;

  elseif event == "UNIT_AURA" then
    if arg1 ~= "player" then
      return false;
    end

    if class ~= "MONK" and GetSpecialization() ~= 1 then
      return false;
    end

    aura_env.TestStates(allstates, maxPower, powerIndex);
    aura_env.SetPowerValue(allstates,maxPower,powerIndex);
    return true;

  else
    return false;
  end
end
