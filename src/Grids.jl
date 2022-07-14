module Grids

import ..Domains
import ..Utils

struct Grid
    domain::Domains.Domain{<:Real}
    ncells::Int
    npoints::Int
    coords::Array{<:AbstractFloat}
    spacing::AbstractFloat
end

function Grid(domain::Domains.Domain, ncells::Int)::Grid
    npoints = ncells + 1
    coords = Utils.discretize(domain.dmin, domain.dmax, ncells)
    spacing = Utils.spacing(domain, ncells)
    return Grid(domain, ncells, npoints, collect(coords), spacing)
end

function TimeGrid_from_cfl(spatial_grid::Grid, time_domain::Domains.Domain, cfl::Real)::Grid
    ncells_t = ceil(Int64,
                    (1 / cfl) *
                    ((time_domain.domain[2] - time_domain.domain[1]) /
                     (spatial_grid.domain.domain[2] - spatial_grid.domain.domain[1])) *
                    spatial_grid.ncells)
    return Grid(time_domain, ncells_t)
end

end # end of module
