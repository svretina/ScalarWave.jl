using ModelingToolkit
using OrdinaryDiffEq
using CairoMakie
using ForwardDiff
using DifferentialEquations

# (1 - 0.1 * sin(2π * 1 * t))
φ(t, x, y, z) = 1 / sqrt(x^2 + y^2 + z^2)
∇₀φ(t, x, y, z) = ForwardDiff.derivative(tt -> φ(tt, x, y, z), t)
∇₁φ(t, x, y, z) = ForwardDiff.derivative(xx -> φ(t, xx, y, z), x)
∇₂φ(t, x, y, z) = ForwardDiff.derivative(yy -> φ(t, x, yy, z), y)
∇₃φ(t, x, y, z) = ForwardDiff.derivative(zz -> φ(t, x, y, zz), z)

function rhs!(du, u, p, t)
    c = 1 #3e8
    q = 1
    m = u[1]
    x, y, z = u[2], u[3], u[4]
    u₁, u₂, u₃ = u[5], u[6], u[7]
    ∂ₜm = du[1]
    ∂ₜx, ∂ₜy, ∂ₜz = du[2], du[3], du[4]
    ∂ₜu₁, ∂ₜu₂, ∂ₜu₃ = du[5], du[6], du[7]
    γ = sqrt(1 + (u₁^2 + u₂^2 + u₃^2) / c^2)
    u₀ = γ * c

    u∇φ = u₀ * ∇₀φ(t, x, y, z) + u₁ * ∇₁φ(t, x, y, z) + u₂ * ∇₂φ(t, x, y, z) + u₃ * ∇₃φ(t, x, y, z)

    ∂ₜm = -(q / γ) * u∇φ
    ∂ₜx = u₁ / γ
    ∂ₜy = u₂ / γ
    ∂ₜz = u₃ / γ
    ∂ₜu₁ = (q / (m * γ)) * (∇₁φ(t, x, y, z) + u₁ * u∇φ)
    ∂ₜu₂ = (q / (m * γ)) * (∇₂φ(t, x, y, z) + u₂ * u∇φ)
    ∂ₜu₃ = (q / (m * γ)) * (∇₃φ(t, x, y, z) + u₃ * u∇φ)

    u[1] = m
    u[2], u[3], u[4] = x, y, z
    u[5], u[6], u[7] = u₁, u₂, u₃
    du[1] = ∂ₜm
    du[2], du[3], du[4] = ∂ₜx, ∂ₜy, ∂ₜz
    du[5], du[6], du[7] = ∂ₜu₁, ∂ₜu₂, ∂ₜu₃
    return nothing
end

tf = 1 * 9
tspan = (0.0, tf)
N = 100 # tf * 2
ts = range(0, tf, length = N + 1)
dt = step(ts)
# Initial Data
m0 = 1
x0, y0, z0 = 2, 0, 0
vx0, vy0, vz0 = 0, 0.3, 0
u0 = [m0, x0, y0, z0, vx0, vy0, vz0]

#Energy calculation
PotentialEnergy = ∇₁φ(0, x0, y0, z0) + ∇₂φ(0, x0, y0, z0) + ∇₃φ(0, x0, y0, z0)
KineticEnergy = 0.5 * m0 * (vx0^2 + vy0^2 + vz0^2)
Energy = KineticEnergy + PotentialEnergy
@assert Energy < 0

#ODE setup
prob = ODEProblem(rhs!, u0, tspan)
sol = solve(prob, AutoTsit5(Kvaerno5()), saveat = ts)

f = Figure(resolution = (800, 500))
ax1 = Axis(f[1:2, 1:2], title = L"mass", titlesize = 20)
ax2 = Axis(f[3:4, 1:2], title = L"x", titlesize = 20)
ax3 = Axis(f[5:6, 1:2], title = L"v_x", titlesize = 20)
ax4 = Axis(f[1:6, 3:5], aspect = 1, xlabel = L"x", ylabel = L"y", xlabelsize = 20, ylabelsize = 20)

lines!(ax1, ts, sol[1, :])
lines!(ax2, ts, sol[2, :])
lines!(ax3, ts, sol[5, :])
lines!(ax4, sol[2, :], sol[3, :])

xlims!(ax1, ts[begin], ts[end])
xlims!(ax2, ts[begin], ts[end])
xlims!(ax3, ts[begin], ts[end])

display(f)
println("done")

# sys = modelingtoolkitize(prob)
# jac = eval(ModelingToolkit.generate_jacobian(sys)[2])
# f = ODEFunction(rhs!, jac = jac)
# prob_jac = ODEProblem(f, u0, tspan)
