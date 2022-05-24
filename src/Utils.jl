module Utils

import ..Domains

function discretize(ui::T, uf::T, nu::S) where {T<:Real, S<:Integer}
    du = spacing(ui, uf, nu)
    ns = 0:1:nu
    u = ui .+ ns .* du
    return u
end

function spacing(xi::T, xn::T, ncells::Integer)::AbstractFloat where {T<:Real}
    dx = (xn - xi) / ncells  # (n+1 -1)
    return dx
end

function spacing(domain::Domains.Domain, ncells::T)::AbstractFloat where T<:Integer
    dx = (domain.dmax - domain.dmin) / ncells  # (n+1 -1)
    return dx
end

function spherical2cartesian(r::T, θ::R, ϕ::S) where {T<:Real, R<:Real, S<:Real}
    x = @. r * cos(ϕ) * sin(θ)
    y = @. r * sin(ϕ) * sin(θ)
    z = @. r * cos(θ)
    return x, y, z
end

end
