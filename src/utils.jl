module utils


function discretize(ui, uf, nu)
    du = spacing(ui, uf, nu)
    ns = 0:1:nu
    u = ui .+ ns .* du
    return u
end


"""
    spacing(xi::T, xn::T, ncells::S) where {T<:AbstractFloat, S<:Integer}

Calculates the dx for an interval, given the start/end
of the interval and the number of cells. The number of points is
automatically calculated as ncells+1.

# Input
- `xn::T`: Last point of grid.
- `ncells::S`: Number of cells of the grid.
# Output
   - `dx::AbstractFloat`: The grid spacing
"""
function spacing(xi::T, xn::T, ncells::Integer)::AbstractFloat where {T<:Real}
    dx = (xn - xi) / ncells  # (n+1 -1)
    return dx
end

end
