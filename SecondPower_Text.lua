function()
    
  local class = UnitClassBase("player");
  
  if not aura_env.config.defaultColor then
    aura_env.region:Color(aura_env.SetBarColor(class));
  end
  if class == "DEATHKNIGHT" then
    aura_env.region:SetInverse(true);
  end
  if class == "MONK" and GetSpecialization() == 1 then
    aura_env.region:SetOrientation("HORIZONTAL")
    aura_env.region:SetRegionWidth(150)
    aura_env.region:SetRegionHeight(15)
  end
end
