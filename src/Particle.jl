module Particle

using ForwardDiff
using StaticArrays
using LinearAlgebra
using Interpolations

import ..Utils
import ..SphericalHarmonics as SH

function ΦCart(t::T, x::R, y::S, z::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    clight = 1
    radius_of_orbit = 5
    particle_speed = 0.5
    Ω = particle_speed * clight / radius_of_orbit

    r⃗ = @SVector [x;y;z]
    r⃗′= @SVector [radius_of_orbit * cos(Ω*t); radius_of_orbit * sin(Ω*t); 0]
    R⃗ = r⃗ - r⃗′
    tᵣ = t - norm(R⃗)/clight
    ω⃗ = @SVector [0;0;Ω]
    r⃗′ᵣ = @SVector [radius_of_orbit * cos(Ω*tᵣ); radius_of_orbit * sin(Ω*tᵣ); 0]
    v⃗ = cross(ω⃗, r⃗′ᵣ)
    R⃗ᵣ = r⃗-r⃗′ᵣ
    return 1 / (norm(R⃗ᵣ)-dot(R⃗ᵣ, v⃗)/clight)
end

function Φ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    clight = 1
    radius_of_orbit = 5
    particle_speed = 0.5
    Ω = particle_speed * clight / radius_of_orbit

    x, y, z = Utils.spherical2cartesian(r, θ, ϕ)
    r⃗ = @SVector [x;y;z]
    r⃗′= @SVector [radius_of_orbit * cos(Ω*t); radius_of_orbit * sin(Ω*t); 0]
    R⃗ = r⃗ - r⃗′
    tᵣ = t - norm(R⃗)/clight
    ω⃗ = @SVector [0;0;Ω]
    r⃗′ᵣ = @SVector [radius_of_orbit * cos(Ω*tᵣ); radius_of_orbit * sin(Ω*tᵣ); 0]
    v⃗ = cross(ω⃗, r⃗′ᵣ)
    R⃗ᵣ = r⃗-r⃗′ᵣ
    return norm(R⃗ᵣ) / (norm(R⃗ᵣ)-dot(R⃗ᵣ, v⃗)/clight)
end

function ∂ᵣΦ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return ForwardDiff.derivative(rr->Φ(t, rr, θ, ϕ), r)
end

function ∂ₜΦ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return ForwardDiff.derivative(tt->Φ(tt, r, θ, ϕ), t)
end

function ψ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return r*Φ(t,r,θ,ϕ)
end

function χ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return r*∂ₜΦ(t,r,θ,ϕ)
end

function ξ(t::T, r::R, θ::S, ϕ::X) where {T<:Real, R<:Real, S<:Real, X<:Real}
    return Φ(t,r,θ,ϕ) + r*∂ᵣΦ(t, r, θ, ϕ)
end

"""
Right moving mode
"""
function u(t::T, r::R, θ::S, ϕ::X)::AbstractFloat where {T<:Real, R<:Real, S<:Real, X<:Real}
    return χ(t,r,θ,ϕ)-ξ(t,r,θ,ϕ)
end

function get_mode(coefs::Array, l::Int, m::Int)
    return @view coefs[:, 1+l, 1+m]
end


function get_interpolated_mode(x::AbstractArray{<:Real}, mode::AbstractArray{<:Real})
    itp = interpolate(mode, BSpline(Cubic(Line(OnGrid()))))
    sitp = scale(itp, x)
    return sitp
end

function get_interpolated_mode(x::AbstractArray{<:Real}, mode::AbstractArray{<:Complex})
    itpr = interpolate(real(mode), BSpline(Cubic(Line(OnGrid()))))
    itpi = interpolate(imag(mode), BSpline(Cubic(Line(OnGrid()))))
    sitpr = scale(itpr, x)
    sitpi = scale(itpi, x)
    return sitpr, sitpi
end

function get_interpolated_mode(x::AbstractArray{<:Real}, coefs::AbstractArray{<:Complex},l::Int, m::Int)
    mode = get_mode(coefs, l, m)
    itpr = interpolate(real(mode), BSpline(Cubic(Line(OnGrid()))))
    itpi = interpolate(imag(mode), BSpline(Cubic(Line(OnGrid()))))
    sitpr = scale(itpr, x)
    sitpi = scale(itpi, x)
    return sitpr, sipti
end

# run(Φ, "Phi")
# run(ψ, "Psi")

end # end of module
