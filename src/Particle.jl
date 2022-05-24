module Particle

using LinearAlgebra
using ForwardDiff
import ..Utils
import ..SphericalHarmonics
import ..MyPlots

function Φ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    clight = 1 #3e8
    particle_charge = 1
    radius_of_orbit = 5
    particle_speed = 0.5
    Ω = particle_speed * clight / radius_of_orbit

    x, y, z = Utils.spherical2cartesian(r, θ, ϕ)
    r⃗ = [x;y;z]
    r⃗′= [radius_of_orbit * cos(Ω*t); radius_of_orbit * sin(Ω*t); 0]
    R⃗ = r⃗ - r⃗′
    tᵣ = t - norm(R⃗)/clight
    ω⃗ = [0;0;Ω]
    r⃗′ᵣ = [radius_of_orbit * cos(Ω*tᵣ); radius_of_orbit * sin(Ω*tᵣ); 0]
    v⃗ = cross(ω⃗, r⃗′ᵣ)
    R⃗ᵣ = r⃗-r⃗′ᵣ
    return 1 / (norm(R⃗ᵣ)-dot(R⃗ᵣ, v⃗)/clight)
end

function ∂ᵣΦ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return ForwardDiff.derivative(rr->Φ(t, rr, θ, ϕ), r)
end

function ∂ₜΦ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return ForwardDiff.derivative(tt->Φ(tt, r, θ, ϕ), t)
end

"""
Right moving mode
"""
function χ(t::T, r::R, θ::S, ϕ::X)::AbstractFloat where {T<:Real, R<:Real, S<:Real, X<:Real}
    return r*∂ₜΦ(t,r,θ,ϕ)-Φ(t,r,θ,ϕ)-r*∂ᵣΦ(t,r,θ,ϕ)
end

function get_mode(coefs::Array, l::Int, m::Int)
    return @view coefs[:, 1+l, 1+m]
end

function decompose!(coefs::Array, func::Function, time_grid::Union{Array,StepRangeLen}, radius::Real, lmax::Int)
    θᴳ, ϕᴳ = SphericalHarmonics.GaussLegendreGrid(lmax)

    # allocate memory for outputs
    functionGL = zeros(length(θᴳ), length(ϕᴳ))
    @assert size(coefs) == (length(time_grid), lmax+1, lmax+1)

    for (ti, t) in enumerate(time_grid)
        # sample function on sphere of radius `radius`
        for (j, ϕᵢ) in enumerate(ϕᴳ)
            for (i, θᵢ) in enumerate(θᴳ)
                functionGL[i,j] = func(t, radius, θᵢ, ϕᵢ)
            end
        end
        coefsti = SphericalHarmonics.Decompose(functionGL, lmax)

        coefs[ti,:,:,:] = coefsti[1,:,:] .+ coefsti[2,:,:]*im
    end
    return nothing
end

clight = 1
lmax = 40
Ω = 0.5*clight/5
Nₜ = 501
t = range(0, 6 * 2π/Ω, length=Nₜ)
decomposition_radius = 150
func1 = (t, r, θ, ϕ) -> decomposition_radius * Φ(t, r, θ, ϕ)

phi_coefs = zeros(ComplexF64, Nₜ, lmax+1, lmax+1)
chi_coefs = zeros(ComplexF64, Nₜ, lmax+1, lmax+1)

decompose!(phi_coefs, func1, t, decomposition_radius, lmax)
decompose!(chi_coefs, χ, t, decomposition_radius, lmax)

for ll in range(0, 8)
    for mm in range(0, ll)
        @show ll, mm
        y1 = get_mode(phi_coefs, ll, mm)
        y2 = get_mode(chi_coefs, ll, mm)
        MyPlots.plot_mode(t, y1, "Psi", ll, mm)
        MyPlots.plot_mode(t, y2, "Chi", ll, mm)
    end
end

end # end of module
