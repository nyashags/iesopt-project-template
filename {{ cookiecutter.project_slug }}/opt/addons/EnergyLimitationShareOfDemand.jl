module EnergyLimitationShareOfDemand

# Limit the output of units tagged with "Biomass" to a maximum share of the total heat demand.
# Here it is applied to the example of limitting heat output from components with biomass as a fuels source.

# Necessary: 
# - loading the add on in the config, and providing the maximum output limit
#       addons: {EnergyLimitationShareOfDemand: {max_biomass_share: <max_biomass_as_share_of_demand>}}
# - tagging all components that are being targetted with a common tag, e.g. "Biomass"

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

using JuMP
using IESopt

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    # Get timesteps 
    T = get_T(model)

    # Get all templates tagged with "Biomass"
    biomass_components = get_components(model, tagged="Biomass")
    demand = get_component(model, "demand_heat")

    # Get total heat output from biomass components
    total_heat_out_from_biomass_components = 0.0

    # Apply get heat out function to component labeled 'unit' in the templates tagged 'Biomass
    for component in biomass_components
        total_heat_out_from_biomass_components += get_heat_out(component.unit)
    end

    # Get total heat demand
    total_heat_demand = sum(demand.exp.value)

    # Add constraint to limit biomass share to maximum share of heat demand
    JuMP.@constraint(
        model,
        total_heat_out_from_biomass_components <= config["max_biomass_share"] * total_heat_demand)

    return true
end

# the function get_heat_out works differently depending on the input type
function get_heat_out(unit::Profile)
    return sum(unit.exp.value)
end

function get_heat_out(unit::Unit)
    return sum(unit.exp.out_heat)
end

end

