module Particle

using LinearAlgebra
import ..Utils

function ParticlePosition(time, ω, orbital_radius)
    ϕ₀ = ω * t
    xₚ, yₚ, zₚ = Utils.Spherical2Cartesian(orbital_radius, π/2, ϕ₀)
    return xₚ, yₚ, zₚ
end

function Φ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    clight = 3e8
    particle_charge = 1
    radius_of_orbit = 5
    percentage_of_light = 0.5
    Ω = percentage_of_light * clight / radius_of_orbit

    x, y, z = Utils.Spherical2Cartesian(r, θ, ϕ)
    r⃗ = [x;y;z]
    r⃗′= [radius_of_orbit * cos(Ω*t); radius_of_orbit * sin(Ω*t); 0]
    R⃗ = r⃗ - r⃗′
    tᵣ = t - norm(R⃗)/clight
    ω⃗ = [0;0;Ω]
    r⃗′ᵣ = [radius_of_orbit * cos(Ω*tᵣ); radius_of_orbit * sin(Ω*tᵣ); 0]
    v⃗ = cross(ω⃗, r⃗′ᵣ)
    R⃗ᵣ = r⃗-r⃗′ᵣ
    return particle_charge / (norm(R⃗ᵣ)-dot(R⃗ᵣ, v⃗)/clight)
end

end # end of module
