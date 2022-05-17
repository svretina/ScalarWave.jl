module grids

import ..domains
import ..utils

struct Grid{T<:Integer}
    domain::domains.Domain{T}
    ncells::T
    npoints::T
    coords::Union{Array{AbstractFloat}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}
    spacing::AbstractFloat
end


function Grid(domain::domains.Domain{T}, ncells::T)::Grid where T<:Integer
    npoints = ncells + 1
    coords = utils.discretize(domain.dmin, domain.dmax, ncells)
    spacing = utils.spacing(domain, ncells)
    return Grid(domain, ncells, npoints, coords, spacing)
end

end # end of module
