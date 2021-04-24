function()
    
    local class = UnitClassBase("player");
    
    if not aura_env.config.defaultColor then
        aura_env.region:Color(aura_env.SetBarColor(class));
    end
end