module grid_functions

import ..grids

struct GridFunction{T<:Union{Array{D} where D <: Real, StepRange{Int64, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}, S<:Real}
    x::T
    y::Array{S}
    function GridFunction(x::T, y::Array{S}) where {T<:Union{Array{D} where D <: Real, StepRange{Int64, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}, S<:Real}
        length(x) == length(y) || throw(DimensionMismatch("GridFunction: x has different length from y."))
        new{T, S}(x, y)
    end
end



function GridFunction(x::T, f::Function)::GridFunction where {T<:Union{Array{D} where D <: Real, StepRange{Int64, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}}
    return GridFunction(x, f.(x))
end

function GridFunction(g::grids.Grid, f::Function)::GridFunction
    return GridFunction(g.coords, f.(g.coords))
end

function GridFunction(g::grids.Grid, y::Array{S})::GridFunction where S <: Real
    return GridFunction(g.coords, y)
end

end # end of module
