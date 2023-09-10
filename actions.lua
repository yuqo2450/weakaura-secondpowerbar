function aura_env.GetPowerValue(currentPower,powerIndex)

  local totalPowerStatus;
  local class = UnitClassBase("player");

  if class == "WARLOCK" then
    if GetSpecialization() == 3 then
      totalPowerStatus = UnitPower("player",powerIndex,true) * 0.1;
    else
      totalPowerStatus = math.floor(UnitPower("player",powerIndex,true) * 0.1);
    end
  elseif class == "MONK" and GetSpecialization() == 1 then
    return UnitStagger("player");
  elseif class == "PALADIN" or "ROGUE" or "DRUID" or "MAGE" or "MONK" then
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
    maxPower = UnitPowerMax(unit,powerIndex,true) * 0.1;
  elseif class == "DRUID" then
    local _,catActive = GetShapeshiftFormInfo(2);

    if catActive then
      powerIndex = 4;
      powerName = "COMBO_POINTS";
      maxPower = UnitPowerMax(unit,powerIndex,true)
    else
      powerIndex = 0;
      powerName = "";
      maxPower = 0;
    end
  elseif class == "MONK" then
    if GetSpecialization() == 1 then
      powerIndex = 100;
      powerName = "STAGGER";
      maxPower = 1;
    elseif GetSpecialization() == 3 then
      powerIndex = 12;
      powerName = "CHI";
      maxPower = UnitPowerMax(unit,powerIndex,true);
    end
  else
    if class == "PALADIN" then
      powerIndex = 9;
      powerName = "HOLY_POWER";
    elseif class == "ROGUE" then
      powerIndex = 4;
      powerName = "COMBO_POINTS";
    elseif class == "MAGE" then
      powerIndex = 16;
      powerName = "ARCANE_CHARGES";
    elseif class == "DEATHKNIGHT" then
      powerIndex = 5;
      powerName = "RUNES";
    end
    maxPower = UnitPowerMax(unit,powerIndex,true);
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
    if GetSpecialization() == 1 then
      return aura_env.SetStaggerColor();
    else
      color = aura_env.config.chi;
    end
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
      total = powerIndex == 100 and UnitHealthMax("player") or 1,
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

  for _,state in pairs(allstates) do
    state.show = false;
    state.changed = true;
  end
end

function aura_env.CountStates(allstates)
  local counter = 0
  for _,_ in pairs(allstates) do
    counter = counter + 1
  end
  return counter
end

function aura_env.SetStaggerColor()
  local percentValue = math.floor(UnitStagger("player") / UnitHealthMax("player") * 100);
  local color;
  if percentValue >= 60 then
    color = aura_env.config.heavyStagger;
  elseif percentValue >= 30 then
    color = aura_env.config.mediumStagger;
  else
    color = aura_env.config.lightStagger;
  end

  return color[1],color[2],color[3],color[4];
end

function aura_env.TestStates(allstates, maxPower, powerIndex)
  if aura_env.CountStates(allstates) ~= maxPower then
    aura_env.ClearStates(allstates);
    aura_env.CreateStates(allstates,maxPower,powerIndex);
  end
end
