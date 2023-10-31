--[[
  Power creation trigger
  Events: PLAYER_SPECIALIZATION_CHANGED,TRAIT_CONFIG_UPDATED,UPDATE_SHAPESHIFT_FORM,PLAYER_ENTERING_WORLD,UNIT_POWER_UPDATE
  ]]
function(allstates,event,arg1,arg2,...)
  local class = UnitClassBase("player");
  local powerIndex,powerName,maxPower = aura_env.GetUnitPowerType("player");

  if event == "PLAYER_ENTERING_WORLD" then
    if class == "DEATHKNIGHT" then
      aura_env.SetDKRunes(allstates,maxPower);
    else
      aura_env.TestStates(allstates, maxPower, powerIndex);
    end
    return true;

  elseif "PLAYER_SPECIALIZATION_CHANGED" == event or "TRAIT_CONFIG_UPDATED" == event then
    aura_env.TestStates(allstates,maxPower,powerIndex);
    return true;

  elseif event =="UPDATE_SHAPESHIFT_FORM" and class == "DRUID" then
    local _,catActive = GetShapeshiftFormInfo(2);
    if catActive then
      aura_env.TestStates(allstates, maxPower, powerIndex);
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

    if class == "DEATHKNIGHT" then
      return false;
    end

    --[[
      There exists an issue with event PLAYER_ENTERING_WORLD and function UnitPowerMax().
      On the named event UnitPowerMax() retunrs for Chi and HolyPower a value smaller than the actual.
      This causes a lua error that is fixed with the following code.
    ]]
    aura_env.TestStates(allstates, maxPower, powerIndex);
    aura_env.SetPowerValue(allstates,maxPower,powerIndex);
    return true;

  else
    return false;
  end
end
