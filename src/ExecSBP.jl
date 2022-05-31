module SBP

import ..Utils
import ..Particle
import ..SphericalHarmonics as SH
import ..MyPlots
import ..ODE
import OrdinaryDiffEq as ODEjl
import SummationByPartsOperators as SBPO
using CairoMakie

xmin, xmax = 100., 300.
N = 401
D = SBPO.derivative_operator(SBPO.DienerDorbandSchnetterTiglio2007(), derivative_order=1, accuracy_order=2, xmin=xmin, xmax=xmax, N=N)

α=1

# spatial grid
xs = SBPO.grid(D)
dx = Utils.spacing(xmin, xmax, N-1)

# time array
Ω = 0.5*1/5
Nₜ = 301
t = range(0, 4 * 2π/Ω, length=Nₜ)
dt = Utils.spacing(t[begin],t[end],Nₜ-1)
tspan = (t[begin], t[end])

# Initial data
lmax = 40
l, m = 2, 2

coefs_u = zeros(ComplexF64, Nₜ, lmax+1, lmax+1)
coefs_ψ = zeros(ComplexF64, N, lmax+1, lmax+1)
coefs_χ = zeros(ComplexF64, N, lmax+1, lmax+1)
coefs_ξ = zeros(ComplexF64, N, lmax+1, lmax+1)

SH.decompose!(coefs_ψ, Particle.ψ, 0, xs, lmax)
SH.decompose!(coefs_χ, Particle.χ, 0, xs, lmax)
SH.decompose!(coefs_ξ, Particle.ξ, 0, xs, lmax)
SH.decompose!(coefs_u, Particle.u, t, xs[begin], lmax)

u = real(Particle.get_mode(coefs_u, l, m))
ψ₀ = real(Particle.get_mode(coefs_ψ, l, m))
χ₀ = real(Particle.get_mode(coefs_χ, l, m))
ξ₀ = real(Particle.get_mode(coefs_ξ, l, m))

fu = Particle.get_interpolated_mode(t, u)
# MyPlots.plot_mode(t, u, "u", l, m)
# MyPlots.plot_mode(xs, ϕ₀, "phi", l, m)
# MyPlots.plot_mode(xs, ψ₀, "psi", l, m)
# MyPlots.plot_mode(xs, χ₀, "chi", l,m)
# MyPlots.plot_mode(xs, ξ₀, "xi", l, m)

# U0 = hcat(ψ₀, χ₀, ξ₀)
U0 = zeros(N,3)
du = similar(U0)

ustarf = fu
vstarf = 0

params = (D=D, α=α, ustarf=ustarf, vstarf=vstarf)


ode = ODEjl.ODEProblem(ODE.rhs!, U0, tspan, params)

sol = ODEjl.solve(ode, ODEjl.RK4(), dt=dt, adaptive=false, saveat=t)

@show size(sol)
maxchi = max(sol[:,2,200]...)

fig = Figure()
ax1 = Axis(fig[1,1:2])
ax2 = Axis(fig[2,1:2])
ax1.title = "χ = ∂ₜ Ψ"
ax2.title = "ξ = ∂ₓ Ψ"
ax2.xlabel = "x"
ylims!(ax1, -1.1*maxchi, 1.1*maxchi)
ylims!(ax2, -1.1*maxchi, 1.1*maxchi)

record(fig, "simulation.gif", 1:Nₜ) do i
  empty!(ax1)
  empty!(ax2)
  lines!(ax1, xs, sol[:,2,i], color=:blue)
  lines!(ax2, xs, sol[:,3,i], color=:blue)
  # save("figures/$i.png",fig)
end
using UnPack: @unpack

function integrate(u::AbstractVector, D::SBPO.DerivativeOperator)
    @boundscheck begin
        length(u) == length(SBPO.grid(D))
    end
    @unpack Δx = D

    @inbounds res = sum(u)
    return Δx * res
end

energy = zeros(Nₜ)
energydt = zeros(Nₜ-1)
fig2 = Figure()
ax21 = Axis(fig2[1,1:2])
ax22 = Axis(fig2[2,1:2])

for i in 1:Nₜ
    energy[i] = 0.5 * integrate(sol[:,2,i].^2 .+ sol[:,3,i].^2, D)
end
for i in 1:Nₜ-1
    energydt[i] = energy[i+1]-energy[i]
end
ax21.title = "energy"
ax22.title = "∂ₜ energy"
ax22.xlabel = "time"
lines!(ax21, t, energy)
lines!(ax22, t[begin:end-1], energydt)

save("energy.png", fig2)
end # end of module
