module ScalarWave

include("Domains.jl")
include("Utils.jl")
include("Grids.jl")
include("GridFunctions.jl")
include("Base.jl")
include("SphericalHarmonics.jl")
include("SummationByPartsOperators.jl")
include("ODE.jl")
include("MyPlots.jl")
include("Run.jl")
# include("Particle.jl")
# include("ExecSBP.jl")

# function runt(func::Function, varname::String)
#     c = 1
#     lmax = 40
#     Ω = 0.5 * c / 5β
#     Nₜ = 201
#     t = range(0, 2 * 2π / Ω, length = Nₜ)

#     decomposition_radius = 6

#     coefs = zeros(ComplexF64, Nₜ, lmax + 1, lmax + 1)

#     SphericalHarmonics.decompose!(coefs, func, t, decomposition_radius, lmax)

#     for ll in 0:4, mm in 0:ll
#         @show ll, mm
#         y = Particle.get_mode(coefs, ll, mm)
#         fr, fi = Particle.get_interpolated_mode(t, y)
#         MyPlots.plot_mode(t, y, fr, fi, varname, ll, mm)
#     end
#     return nothing
# end

# function runr(func::Function, varname::String)
#     c = 1
#     lmax = 40
#     Ω = 0.5 * c / 5
#     N = 201
#     norbits = 2
#     rstart = 6
#     rend = rstart + c * norbits * 2π / Ω
#     rs = range(rstart, rend, length = N)
#     decomposition_time = 0

#     coefs = zeros(ComplexF64, N, lmax + 1, lmax + 1)

#     SphericalHarmonics.decompose!(coefs, func, decomposition_time, rs, lmax)

#     for ll in 0:4, mm in 0:ll
#         @show ll, mm
#         y = Particle.get_mode(coefs, ll, mm)
#         fr, fi = Particle.get_interpolated_mode(rs, y)
#         MyPlots.plot_mode(rs, y, fr, fi, varname, ll, mm)
#     end
#     return nothing
# end

# runr(Particle.ψ, "ψr")
# runt(Particle.ψ, "ψt")

# runr(Particle.Φ, "Φr")
# runt(Particle.Φ, "Φt")
# runt(Particle.ξ, "xit")
# runr(Particle.ξ, "xir")
# import SummationByPartsOperators as SBPO
# using CairoMakie
# xmin, xmax = 100., 300.
# N = 401
# D = SBPO.derivative_operator(SBPO.DienerDorbandSchnetterTiglio2007(),
#                             derivative_order=1,
#                             accuracy_order=2,
#                             xmin=xmin, xmax=xmax,
#                             N=N)
# # spatial grid
# lmax = 40
# l, m = 2, 2
# xs = SBPO.grid(D)
# coefs_ϕ = zeros(ComplexF64, N, lmax+1, lmax+1)
# Ω = 0.5*1/5
# Nₜ = 201
# t = range(0, 4 * 2π/Ω, length=Nₜ)
# φ = real(Particle.get_mode(coefs_ϕ, l, m))
# fig = Figure()
# ax1 = Axis(fig[1,1:2], title = L"φ_{%$(l)%$(m)}")
# ylims!(ax1, -1, 1)
# record(fig, "analytic_simulation.gif", 1:Nₜ) do i
#     empty!(ax1)
#     SphericalHarmonics.decompose!(coefs_ϕ, Particle.Φ, t[i], xs, lmax)
#     φ = real(Particle.get_mode(coefs_ϕ, l, m))
#     lines!(ax1, xs, φ, color=:blue)
# end

# xdip = xs[114]
# vlines!(ax1, xdip, ymin=0.2, ymax=0.8)
# xdip2 = xs[91]
# vlines!(ax1, xdip2, ymin=0.2, ymax=1.2)
# xdip3 = xs[138]
# vlines!(ax1, xdip3, ymin=0.2, ymax=1.2)
#
# ax2 = Axis(f[2,1:2], title = L"angle")
# ϕs = rad2deg.(mod.(Particle.φ.(0, xs, π/2, 0), 2π))
# @show ϕs[114], ϕs[91], ϕs[138]
# @show cos(ϕs[114]), sin(ϕs[114])
# vlines!(ax2, xdip, ymin=0, ymax=360)
#
# hlines!(ax2, ϕs[114], xmin=0, xmax=160)
# hlines!(ax2, ϕs[91], xmin=0, xmax=160)
# hlines!(ax2, ϕs[138], xmin=0, xmax=160)
# lines!(ax2, xs, ϕs, label="angle")
# lines!(ax2, xs, π.*ones(length(xs)))
# axislegend(ax1)
# axislegend(ax2)
# display(f)
# save("angle.png", f)
end
