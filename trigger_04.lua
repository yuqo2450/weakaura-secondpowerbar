--[[
  Stagger only trigger
  Events: UNIT_AURA
  ]]
function(allstates,event,arg1,arg2,...)
  if arg1 ~= "player" then
    return false;
  end

  local class = UnitClassBase("player");
  if class ~= "MONK" and GetSpecialization() ~= 1 then
    return false;
  end

  local powerIndex,powerName,maxPower = aura_env.GetUnitPowerType("player");
  --[[
    When states are not tested, there will be an LUA error when loading the aura in combat
    Testing the states fixes this bug
  ]]
  aura_env.TestStates(allstates, maxPower, powerIndex);
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
