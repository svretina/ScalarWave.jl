using ModelingToolkit
using OrdinaryDiffEq
using CairoMakie
using ForwardDiff
using DifferentialEquations

φ(t, x, y, z) = sin(t) / sqrt(x^2 + y^2 + z^2)
∇₀φ(t, x, y, z) = ForwardDiff.derivative(tt -> φ(tt, x, y, z), t)
∇₁φ(t, x, y, z) = ForwardDiff.derivative(xx -> φ(t, xx, y, z), x)
∇₂φ(t, x, y, z) = ForwardDiff.derivative(yy -> φ(t, x, yy, z), y)
∇₃φ(t, x, y, z) = ForwardDiff.derivative(zz -> φ(t, x, y, zz), z)

function rhs!(du, u, p, t)
    c = 3e8
    q = 1
    mass = u[1]
    x, y, z = u[2], u[3], u[4]
    ux, uy, uz = u[5], u[6], u[7]
    u = sqrt(ux^2 + uy^2 + uz^2)
    γ = 1 / sqrt(1 - u^2 / c^2)
    u∇φ = c * ∇₀φ(t, x, y, z) + ux * ∇₁φ(t, x, y, z) + uy * ∇₂φ(t, x, y, z) + uz * ∇₃φ(t, x, y, z)

    # dm/dt = (q/γ)u∇Φ
    du[1] = (q / γ) * u∇φ
    # dx^μ/dt = u^μ
    du[2] = -(1 / γ) * ux
    du[3] = -(1 / γ) * uy
    du[4] = -(1 / γ) * uz

    # du^μ / dt  = -q/mγ ( ∇φ + u * u∇φ)
    du[5] = -(q / (mass * γ)) * (∇₁φ(x, y, z) + ux * u∇φ)
    du[6] = -(q / (mass * γ)) * (∇₂φ(x, y, z) + uy * u∇φ)
    du[7] = -(q / (mass * γ)) * (∇₃φ(x, y, z) + uz * u∇φ)
    return nothing
end

tf = 1500
tspan = (0.0, tf)
N = 2000
ts = range(0, tf, length = N + 1)
dt = step(ts)
m0 = 1
x0, y0, z0 = 2, 0, 0
vx0, vy0, vz0 = 0, 0.6, 0
u0 = [m0, x0, y0, z0, vx0, vy0, vz0]
prob = ODEProblem(rhs!, u0, tspan)
# sys = modelingtoolkitize(prob)
# jac = eval(ModelingToolkit.generate_jacobian(sys)[2])
# f = ODEFunction(rhs!, jac = jac)
# prob_jac = ODEProblem(f, u0, tspan)
sol = solve(prob, Tsit5(), saveat = ts)

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
