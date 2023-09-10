function(allstates,event,arg1,arg2,...)

  local class = UnitClassBase("player");
  local powerIndex,powerName,maxPower = aura_env.GetUnitPowerType("player");

  if event == "UNIT_POWER_UPDATE" then
    if arg1 ~= "player" then
      return false
    end
    --[[
      There exists an issue with event PLAYER_ENTERING_WORLD and function UnitPowerMax().
      On the named event UnitPowerMax() retunrs for Chi and HolyPower a value smaller than the actual.
      This causes a lua error that is fixed with the following code.
    ]]
    if aura_env.CountStates(allstates) ~= maxPower then
      aura_env.ClearStates(allstates);
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    end
    if arg2 == powerName and class ~= "DEATHKNIGHT" then
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

  elseif next({"TRAIT_CONFIG_UPDATED", "PLAYER_SPECIALIZATION_CHANGED"}) == event then

    aura_env.ClearStates(allstates);
    -- aura_env.CreateStates(allstates,maxPower,powerIndex);
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
  elseif event == "UNIT_AURA" then
    if arg1 ~= "player" then
      return false;
    end

    if aura_env.CountStates(allstates) ~= maxPower then
      aura_env.ClearStates(allstates);
      aura_env.CreateStates(allstates,maxPower,powerIndex);
    end

    if arg2['addedAuras'] ~= nil and string.find(arg2['addedAuras'][1]['name'], 'Stagger') then
      aura_env.staggerAuraInstanceID = arg2['addedAuras'][1]['auraInstanceID'];
      aura_env.SetPowerValue(allstates,maxPower,powerIndex);

      return true;
    elseif arg2['updatedAuraInstanceIDs'] and arg2['updatedAuraInstanceIDs'][1] == aura_env.staggerAuraInstanceID then
      aura_env.SetPowerValue(allstates,maxPower,powerIndex);

      return true;
    elseif arg2['removedAuraInstanceIDs'] and arg2['removedAuraInstanceIDs'][1] == aura_env.staggerAuraInstanceID then
      aura_env.SetPowerValue(allstates,maxPower,powerIndex);
      aura_env.staggerAuraInstanceID = nil;

      return true;
    else
      return false
    end
  end
end
