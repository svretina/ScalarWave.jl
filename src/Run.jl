module run

import ..Domains
import ..Grids
import ..GridFunctions
import ..SphericalHarmonics
import ..SummationByPartsOperators
import ..ODE

using ForwardDiff
using OrdinaryDiffEq
using SpecialFunctions
using CairoMakie

function get_mode(coefs::Array, l::Int, m::Int)
    return @view coefs[:, 1 + l, 1 + m]
end

function gaussian(r, t, d, r0)
    return exp(-(r - (r0 + t))^2 / d^2)
end

function gaussiant(r, t, d, r0)
    return ForwardDiff.derivative(tt -> gaussian(r, tt, d, r0), t)
end

function gaussianr(r, t, d, r0)
    return ForwardDiff.derivative(rr -> gaussian(rr, t, d, r0), r)
end

l = 0
tf = 35
cfl = 0.9
ncells = 350

time_domain = Domains.Domain([0, tf])
spatial_domain = Domains.Domain([0, 1])

spatial_grid = Grids.Grid(spatial_domain, ncells)
time_grid = Grids.TimeGrid_from_cfl(spatial_grid, time_domain, cfl)

# Initial condition
r0 = 0.5
d = 0.1
f(t, r, θ, ϕ) = exp(-((t + r0) + r)^2 / d^2) / r - exp(-((t + r0) - r)^2 / d^2) / r
ft(t, r, θ, ϕ) = ForwardDiff.derivative(tt -> f(tt, r, θ, ϕ), t)
fr(t, r, θ, ϕ) = ForwardDiff.derivative(rr -> f(t, rr, θ, ϕ), r)

Ψ = f.(0, spatial_grid.coords, 0, 0)
Π = ft.(0, spatial_grid.coords, 0, 0)
ξ = fr.(0, spatial_grid.coords, 0, 0)

replace!(Ψ, NaN => 0)
replace!(Π, NaN => 0)
replace!(ξ, NaN => 0)

u = hcat(Ψ, Π, ξ)
D_s = SummationByPartsOperators.DerivativeOperator("spherical", spatial_grid)
D_c = SummationByPartsOperators.DerivativeOperator("cartesian", spatial_grid)

params = (D_s=D_s, D_c=D_c, l=l, w=D_c.matrix[end, end])
ode = ODEProblem(ODE.spherical_rhs!, u, (0, tf), params)

sol = solve(ode, AutoTsit5(Rosenbrock23()); dt=time_grid.spacing, adaptive=false, saveat=time_grid.coords)

maxpi = max(sol[:, 2, :]...)
maxxi = max(sol[:, 3, :]...)
maxpsi = max(sol[:, 1, :]...)
maxx = max(maxpi, maxxi, maxpsi)
println(maxx)

# fig = Figure()
# ax1 = Axis(fig[1, 1:2])
# ax2 = Axis(fig[2, 1:2])
# ax3 = Axis(fig[3, 1:2])
# ax1.title = "Ψ"
# ax2.title = "π = ∂ₜ Ψ"
# ax3.title = "ξ = ∂ₓ Ψ"
# ax3.xlabel = "r"
# ylims!(ax1, -1.1 * maxx, 1.1 * maxx)
# ylims!(ax2, -1.1 * maxx, 1.1 * maxx)
# ylims!(ax3, -1.1 * maxx, 1.1 * maxx)
# t = 3500
# ti = time_grid.coords[t]
# fig = Figure()
# ax = Axis(fig[1, 1]; title="t=$(ti)")
# lines!(ax, spatial_grid.coords, sol[:, 1, t]; label="Ψ")
# lines!(ax, spatial_grid.coords, sol[:, 2, t]; label="Π")
# lines!(ax, spatial_grid.coords, sol[:, 3, t]; label="ξ")

# energy
energy = GridFunctions.GridFunction(time_grid, zeros(time_grid.npoints))
for i in 1:(time_grid.npoints)
    energy.y[i] = 0.5 .* (GridFunctions.integrate(sol[:, 1, i] .^ 2, spatial_grid.spacing) +
                          GridFunctions.integrate(sol[:, 3, i] .^ 2, spatial_grid.spacing))
end

fig = Figure()
ax = Axis(fig[1, 1]; title="Energy", xlabel="time")
lines!(ax, energy.x, energy.y)
save("energy.png", fig)

# println("producing gif")
# record(fig, "simulation.gif", 1:150:(time_grid.npoints); framerate=15) do i
#     empty!(ax1)
#     empty!(ax2)
#     empty!(ax3)
#     ti = time_grid.coords[i]
#     # Label(fig[0, :]; text="t=$ti", textsize=20)
#     lines!(ax1, spatial_grid.coords, sol[:, 1, i]; color=:blue)
#     lines!(ax2, spatial_grid.coords, sol[:, 2, i]; color=:blue)
#     lines!(ax3, spatial_grid.coords, sol[:, 3, i]; color=:blue)
#     # save("timesnap.png", fig)
#     return nothing
# end

end
