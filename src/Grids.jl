module Grids

import ..Domains
import ..Utils

struct Grid{T<:Integer}
    domain::Domains.Domain{T}
    ncells::T
    npoints::T
    coords::Union{Array{AbstractFloat}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}
    spacing::AbstractFloat
end


function Grid(domain::T, ncells::S)::Grid where {T, S}
    npoints = ncells + 1
    coords = Utils.discretize(domain.dmin, domain.dmax, ncells)
    spacing = Utils.spacing(domain, ncells)
    return Grid(domain, ncells, npoints, coords, spacing)
end

end # end of module
