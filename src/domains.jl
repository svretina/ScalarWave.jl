module domains

"""
Struct to hold information about the physical
domain of the numerical grid.

- domain:  the physical domai e.g [0,1] or [0,1]U[1,2]
- dims: number of dimensions of the domain e.g 1 for the first case or 2 for the 2nd
"""
struct Domain{T<:Integer}
    domain::Array{T}
    dims::T
end

## Constructor overloading to calculate dims from domain array
function Domain(domain::Array{T}) where {T<:Integer}
    dims = size(domain, 2)
    return Domain{T}(domain, dims)
end

end
