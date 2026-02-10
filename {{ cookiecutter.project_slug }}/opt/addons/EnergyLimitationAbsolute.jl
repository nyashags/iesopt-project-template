module EnergyLimitationAbsolute

# Limit the output of a create profile to a maximum value

# Necessary: 
# - loading the add on in the config, and providing the maximum output limit and relevant profile name
#       addons: {EnergyLimitationAbsolute: {max_value: 10000, proflie_name: "buy_biomethane"}}

# Comments:
# - This add on is applied to the example of limitting the output of a create profile called 'buy biomethane' which 
#   represents the biomethane market to 10000 energy units (i.e. MWh), but can be addapted to other applications.

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

using JuMP
using IESopt

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    # Get sum of biomethane bought
    T = get_T(model)
    snapshots = internal(model).model.snapshots
    relevant_profile = get_component(model, config["proflie_name"])
    
    total_output = sum(relevant_profile.exp.value[t]*snapshots[t].weight for t in T) 

    # Limit biomethane use to an absolute value
    JuMP.@constraint(
        model,
        total_output <= config["max_value"])

    return true
end

end


