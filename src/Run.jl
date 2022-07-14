module Run

import ..Domains
import ..Grids
import ..GridFunctions
import ..SphericalHarmonics
import ..SummationByPartsOperators
import ..ODE
import ..MyPlots

using ForwardDiff
using OrdinaryDiffEq
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

function run()
    D = 3
    n = D - 1
    l = 0
    p = 2 * l + n
    tf = 16
    cfl = 0.2
    ncells = 100

    time_domain = Domains.Domain([0, tf])
    spatial_domain = Domains.Domain([0, 1])

    spatial_grid = Grids.Grid(spatial_domain, ncells)
    time_grid = Grids.TimeGrid_from_cfl(spatial_grid, time_domain, cfl)

    # Initial condition
    r0 = 0.5
    d = 0.1
    function f(t, r)
        -exp(-((-t + r0) + r)^2 / d^2) / r + exp(-((-t + r0) - r)^2 / d^2) / r
    end
    ft(t, r) = ForwardDiff.derivative(tt -> f(tt, r), t)
    fr(t, r) = ForwardDiff.derivative(rr -> f(t, rr), r)

    Ψ = f.(0, spatial_grid.coords)
    Π = ft.(0, spatial_grid.coords)
    ξ = fr.(0, spatial_grid.coords)

    replace!(Ψ, NaN => 0)
    replace!(Π, NaN => 0)
    replace!(ξ, NaN => 0)
    ξ[1] = 0

    u = hcat(Ψ, Π, ξ) # StateVector
    B = SummationByPartsOperators.SphericalBoundary(p, spatial_grid)
    Grad = SummationByPartsOperators.Gradient(spatial_grid)
    Norm = SummationByPartsOperators.SphericalNorm(p, spatial_grid)
    Div = SummationByPartsOperators.Divergence(Norm, B, Grad)

    params = (Div=Div, Grad=Grad, p=p, w=Grad[end, end],
              h=spatial_grid.spacing)
    ode = ODEProblem(ODE.spherical_rhs!, u, (0, tf), params)

    sol = solve(ode, AutoTsit5(Rosenbrock23()); dt=time_grid.spacing,
                adaptive=false, saveat=time_grid.coords)

    MyPlots.plot_energy(sol, time_grid, Norm)
    # MyPlots.make_gif(sol, time_grid, spatial_grid)
    # MyPlots.plot_frames(sol, time_grid, spatial_grid)
end

end
