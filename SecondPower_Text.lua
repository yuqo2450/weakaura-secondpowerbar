function()
    
    local activeUnit = UnitClassBase("player");
    
    if not aura_env.config.defaultColor then
        aura_env.region:Color(aura_env.SetBarColor(activeUnit));
    end

end