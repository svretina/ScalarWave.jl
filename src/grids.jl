include("domains.jl")

module grids

import ..domains

struct Grid
    domain::Int
    ncells::Int
    npoints::Int
    coords::Array{AbstractFloat}
    spacing::AbstractFloat
    dx::AbstractFloat
end


"""
    spacing(xi::T, xn::T, ncells::S) where {T<:AbstractFloat, S<:Integer}

Calculates the dx for an interval, given the start/end
of the interval and the number of cells. The number of points is
automatically calculated as ncells+1.

# Input
- `xi::T`: Initial point of grid.
- `xn::T`: Last point of grid.
- `ncells::S`: Number of cells of the grid.
# Output
   - `dx::AbstractFloat`: The grid spacing
"""
function spacing(xi::T, xn::T, ncells::S)::AbstractFloat where {T<:AbstractFloat,S<:Integer}
    dx = (xn - xi) / n  # (n+1 -1)
    return dx
end


end
