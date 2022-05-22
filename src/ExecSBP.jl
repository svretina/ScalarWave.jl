module SBP

using SummationByPartsOperators, OrdinaryDiffEq
using Plots
using Printf; using LaTeXStrings

xmin, xmax = 0.0, 2.0
N = 101
D = derivative_operator(MattssonNordström2004(), derivative_order=1, accuracy_order=4, xmin=xmin, xmax=xmax, N=N)

α=0.5


center = 1
s = 1/50
A = 8

ψ(x, t) = @. A*exp(-((x-(center+t))^2 )/s)
χ(x, t) = @. -A*(2*center + 2*t - 2*x)*exp(-(-center - t + x)^2/s)/s
ξ(x, t) = @. -A*(-2*center - 2*t + 2*x)*exp(-(-center - t + x)^2/s)/s

# u = χ-ξ
# v = χ+ξ
u(x, t) = χ(x, t) - ξ(x, t)
v(x, t) = χ(x, t) + ξ(x, t)

xs = SummationByPartsOperators.grid(D)

dx = xs[begin+1] - xs[begin]
cfl = 0.4
dt = cfl * dx
tspan = (0., 3.0)
tarray = range(tspan[begin], tspan[end], step=dt)

U0 = hcat(ψ(xs, 0), χ(xs, 0), ξ(xs, 0))
du = similar(U0)
ustarf(τ) = u(xs[begin], τ)
vstarf(τ) = v(xs[end], τ)

params = (D=D, α=α, ustarf=ustarf, vstarf=vstarf)

function rhs!(du, U, params, t)
  D = params.D
  α = params.α

  ustar = 0 #params.ustarf(t)
  vstar = 0 #params.vstarf(t)

  du[:,1] = U[:,2]
  du[:,2] = D * U[:,3]
  du[:,3] = D * U[:,2]

  ### SAT boundary treatment
  ### Left Boundary
  du[begin,2] -=  (α/(2.0*left_boundary_weight(D))) * (U[begin,2]-U[begin,3] - ustar)
  du[begin,3] += (α/(2.0*left_boundary_weight(D))) * (U[begin,2]-U[begin,3]- ustar)

  ### Right Boundary
  du[end,2] -= (α/(2.0*right_boundary_weight(D))) * (U[end,2]+U[end,3]- vstar)
  du[end,3] -= (α/(2.0*right_boundary_weight(D))) * (U[end,2]+U[end,3]- vstar)
  return nothing
end

ode = ODEProblem(rhs!, U0, tspan, params)

sol = solve(ode, RK4(), dt=dt, adaptive=false, saveat=tarray)

maxchi = max(sol[:,2,1]...)

anim = Animation()
for (i, t) ∈ enumerate(tarray)
  p1 = plot(xs, sol[:,2,i], ylims=(-1.1*maxchi, 1.1*maxchi), label="χ=∂ₜ Ψ")
  p2 = plot(xs, sol[:,3,i], ylims=(-1.1*maxchi, 1.1*maxchi), label="ξ=∂ₓ Ψ")
  p = plot(p1, p2, layout=(2,1))
  # savefig(p, "figures/$i.png")
  frame(anim)
end

gif(anim, "animation.gif")
end # end of module
