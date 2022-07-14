module GridFunctions

import ..Grids

struct GridFunction
    x::Array{<:Union{AbstractFloat,Int}}
    y::Array{<:Union{AbstractFloat,Int}}
    function GridFunction(x::Array{T}, y::Array{S}) where {T,S}
        length(x) == length(y) || throw(DimensionMismatch("GridFunction: x has different length from y."))
        return new(x, y)
    end
end

function GridFunction(x::Array{<:Union{AbstractFloat,Int}}, f::Function)::GridFunction
    return GridFunction(x, f.(x))
end

function GridFunction(g::Grids.Grid, f::Function)::GridFunction
    return GridFunction(g.coords, f.(g.coords))
end

function GridFunction(g::Grids.Grid, y::Array{<:Real})::GridFunction
    return GridFunction(g.coords, y)
end

function integrate(vector::GridFunction, dx::AbstractFloat)::AbstractFloat
    boundary_terms = 0.5 * (vector.y[begin] + vector.y[end])
    interior = sum(vector.y[(begin + 1):(end - 1)])
    result = boundary_terms + interior
    return result * dx
end

function integrate(vector::Array{<:AbstractFloat}, dx::AbstractFloat)::AbstractFloat
    boundary_terms = 0.5 * (vector[begin] + vector[end])
    interior = sum(vector[2:(end - 1)])
    result = boundary_terms + interior
    return result * dx
end

end # end of module
