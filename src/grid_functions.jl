module grid_functions

import ..grids

struct GridFunction{T<:Union{Array{D} where D <: Real, StepRange{Int64, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}, S<:Real}
    x::T
    y::Array{S}
    function GridFunction(x::T, y::Array{S}) where {T, S}
        length(x) == length(y) || throw(DimensionMismatch("GridFunction: x has different length from y."))
        new{T, S}(x, y)
    end
end

function GridFunction(x::T, f::Function)::GridFunction where {T}
    return GridFunction(x, f.(x))
end

function GridFunction(g::grids.Grid{T}, f::Function)::GridFunction where T
    return GridFunction(g.coords, f.(g.coords))
end

function GridFunction(g::grids.Grid{T}, y::Array{<:Real})::GridFunction where T
    return GridFunction(g.coords, y)
end

end # end of module
