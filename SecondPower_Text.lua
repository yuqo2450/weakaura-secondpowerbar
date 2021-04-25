function()
    
    local class = UnitClassBase("player");
    
    if not aura_env.config.defaultColor then
        aura_env.region:Color(aura_env.SetBarColor(class));
    end
    if class == "DEATHKNIGHT" then
        aura_env.region:SetInverse(true);
    end
end