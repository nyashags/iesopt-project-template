module EnergyLimitationAbsolute

# Limit the output of a create profile to a maximum value

# Necessary: 
# - loading the add on in the config, and providing the maximum output limit
#       addons: {EnergyLimitationAbsolute: {max_biomethane_MWh: <max_biomethane_in_MWh>}}

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

using JuMP
using IESopt

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    # Get sum of biomethane bought
    buy_biomethane = get_component(model, "buy_biomethane")
    total_biomethane_used = sum(buy_biomethane.exp.value) # TODO: multiply this by timestep duration
    

    # Limit biomethane use to an absolute value
    # TODO: fix that this only works if timestep duration is in 1 hour because if not then the heat output unit is in MW and not MWh by accounting for duration
    JuMP.@constraint(
        model,
        total_biomethane_used <= config["max_biomethane_MWh"])

    return true
end

end


