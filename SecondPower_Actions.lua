function aura_env.GetPowerValue(currentPower,powerIndex)

  local totalPowerStatus;
  
  if UnitClassBase("player") == "WARLOCK" then
    totalPowerStatus = UnitPower("player",powerIndex,true) * 0.1;
  elseif UnitClassBase("player") == "PALADIN" or "MONK" or "ROGUE" or "DRUID" or "MAGE" then
    totalPowerStatus = UnitPower("player",powerIndex,true);
  end

  if totalPowerStatus >= currentPower then
    return 1;
  elseif currentPower - totalPowerStatus > 1 then
    return 0;
  else
    return totalPowerStatus - (currentPower - 1);
  end
end

function aura_env.GetUnitPowerType(unit)
    
  local powerIndex,powerName,maxPower;
  local class = UnitClassBase(unit);
  
  if class == "WARLOCK" then
      powerIndex = 7;
      powerName = "SOUL_SHARDS";
      maxPower = UnitPowerMax("player",powerIndex,true) * 0.1;        
  elseif class == "PALADIN" then
      powerIndex = 9;
      powerName = "HOLY_POWER";
      maxPower = UnitPowerMax("player",powerIndex,true);    
  elseif class == "MONK" then
      powerIndex = 12;
      powerName = "CHI";
      maxPower = UnitPowerMax("player",powerIndex,true);
  elseif class == "ROGUE" then
      powerIndex = 4;
      powerName = "COMBO_POINTS";
      maxPower = UnitPowerMax("player",powerIndex,true);
  elseif class == "DRUID" then
      local _,catActive = GetShapeshiftFormInfo(2);
      
      if catActive then
          powerIndex = 4;
          powerName = "COMBO_POINTS";
          maxPower = UnitPowerMax("player",powerIndex,true);
      else
          powerIndex = 0;
          powerName = "";
          maxPower = 0;
      end
  elseif class == "MAGE" then
      powerIndex = 16;
      powerName = "ARCANE_CHARGES";
      maxPower = UnitPowerMax("player",powerIndex,true);
  elseif class == "DEATHKNIGHT" then
      powerIndex = 5;
      powerName = "RUNES";
      maxPower = UnitPowerMax("player",powerIndex,true);
  end
  
  return powerIndex,powerName,maxPower;
  
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
  elseif class == "DEATHKNIGHT" then
    color = aura_env.config.dkRunes
  end

  return color[1],color[2],color[3],color[4];
end

function aura_env.CreateStates(allstates,maxPower,powerIndex)

  for currentPower=1,maxPower do
    allstates["power"..currentPower] = {
      show = true,
      progressType = "static",
      total = 1,
      value = aura_env.GetPowerValue(currentPower,powerIndex),
      name = currentPower,
      index = currentPower,
    };
  end
end

function aura_env.SetPowerValue(allstates,maxPower,powerIndex)

  for currentPower=1,maxPower do

    allstates["power"..currentPower].value = aura_env.GetPowerValue(currentPower,powerIndex);
    allstates["power"..currentPower].show = true;
    allstates["power"..currentPower].changed = true;

  end
end

function aura_env.SetDKRunes(allstates,maxPower)
    
  for currentPower=1,maxPower do
    local start,duration,runeState = GetRuneCooldown(currentPower)
    allstates["power"..currentPower] = {
      changed = true,
      show = true,
      progressType = "timed",
      expirationTime = start + duration,
      duration = duration,
      name = currentPower,
      index = start + duration,
    };
  end
end

function aura_env.ClearStates(allstates)

  for _,value in pairs(allstates) do
    value.show = false;
  end
end