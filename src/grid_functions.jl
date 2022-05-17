module grid_functions

import ..grids

struct GridFunction{T<:Real}
    x::Array{T}
    y::Array{T}
end

function GridFunction(x::Array{T}, f::Function)::GridFunction where T<:Real
    return GridFunction(x, f(x))
end

function GridFunction(g::grids.Grid, f::Function)::GridFunction
    return GridFunction(g.coords, f(g.coords))
end


end # end of module
