module MyPlots

using CairoMakie
using LaTeXStrings
# import ..Particle
import ..Utils
import ..Grids
import ..GridFunctions
import OrdinaryDiffEq

figure_path = "/home/svretina/Codes/PhD/ScalarWave/figures/"

"""
Plots the real and imaginary part of a mode
"""
function plot_mode(time::Union{Array,StepRangeLen}, data::AbstractArray,
                   varname::String, l::Int, m::Int)
    dmin = min(min(real(data)..., min(imag(data)...)))
    dmax = max(max(real(data)..., max(imag(data)...)))

    if dmin < 0
        dmin = 1.1 * dmin
    else
        dmin = 0.9 * dmin
    end

    if dmax < 0
        dmax = 0.9 * dmax
    else
        dmax = 1.1 * dmax
    end

    f = Figure()
    ax = Axis(f[1, 1]; title=L"\%$(varname)_{%$(l)%$(m)}")
    lines!(ax, time, real(data); label="Real")
    lines!(ax, time, imag(data); xlabel=L"time", label="Imag")
    ylims!(dmin, dmax)
    axislegend(ax)
    save(string(figure_path, "$varname$l$m.png"), f)
end

"""
Plots the mode and the interpolated functions
"""
function plot_mode(time::Union{Array,StepRangeLen}, data::AbstractArray,
                   fr::AbstractArray, fi::AbstractArray, varname::String,
                   l::Int, m::Int)
    dmin = min(min(real(data)..., min(imag(data)...)))
    dmax = max(max(real(data)..., max(imag(data)...)))

    if dmin < 0
        dmin = 1.1 * dmin
    else
        dmin = 0.9 * dmin
    end

    if dmax < 0
        dmax = 0.9 * dmax
    else
        dmax = 1.1 * dmax
    end

    f = Figure()
    ax = Axis(f[1, 1]; title=L"%$(varname)_{%$(l)%$(m)}")
    scatter!(ax, time, real(data); label="Real")
    lines!(ax, time, fr(time))
    scatter!(ax, time, imag(data); xlabel=L"time", label="Imag")
    lines!(ax, time, fi(time))
    ylims!(dmin, dmax)
    axislegend(ax)
    save(string(figure_path, "$varname$l$m.png"), f)
end

function animate_potential()
    Ω = 0.5 * 3e8 / 5
    rs = range(0, 200; length=101)
    φs = range(0, 2π; length=51)
    ϕ = zeros(length(rs), length(φs))
    for (ri, r) in enumerate(rs)
        for (φi, φ) in enumerate(φs)
            ϕ[ri, φi] = r * Particle.Φ(0, r, π / 2, φ)
            replace!(ϕ, Inf => 0)
        end
    end

    time = Observable(0.0)
    listener = on(time) do val
        for (ri, r) in enumerate(rs)
            for (φi, φ) in enumerate(φs)
                ϕ[ri, φi] = r * Particle.Φ(val, r, π / 2, φ)
                replace!(ϕ, Inf => 0)
            end
        end
    end

    fig = Figure()
    ax = Axis(fig[1, 1])

    hm = heatmap!(rs, φs, ϕ; extendlow=:auto, extendhigh=:auto)
    # , colorrange=(0,0.8)
    Colorbar(fig[:, end + 1], hm)
    framerate = 30
    timestamps = range(0, 2π / Ω; length=101)
    record(fig, "potential.gif", timestamps; framerate=framerate) do t
        # @show t
        time[] = t
        hm = heatmap!(rs, φs, ϕ; extendlow=:auto, extendhigh=:auto)
    end
end

function plot_frames(sol::OrdinaryDiffEq.ODECompositeSolution,
                     time_grid::Grids.Grid, spatial_grid::Grids.Grid)
    maxpi = max(sol[:, 2, :]...)
    maxxi = max(sol[:, 3, :]...)
    maxpsi = max(sol[:, 1, :]...)
    maxx = max(maxpi, maxxi, maxpsi)

    fig = Figure()
    ax1 = Axis(fig[1, 1:2])
    ax2 = Axis(fig[2, 1:2])
    ax3 = Axis(fig[3, 1:2])
    ax1.title = "Ψ"
    ax2.title = "π = ∂ₜ Ψ"
    ax3.title = "ξ = ∂ₓ Ψ"
    ax3.xlabel = "r"
    ylims!(ax1, -1.1 * maxx, 1.1 * maxx)
    ylims!(ax2, -1.1 * maxx, 1.1 * maxx)
    ylims!(ax3, -1.1 * maxx, 1.1 * maxx)

    for i in 1:(time_grid.npoints)
        empty!(ax1)
        empty!(ax2)
        empty!(ax3)
        lines!(ax1, spatial_grid.coords, sol[:, 1, i]; color=:blue)
        lines!(ax2, spatial_grid.coords, sol[:, 2, i]; color=:blue)
        lines!(ax3, spatial_grid.coords, sol[:, 3, i]; color=:blue)
        save(string(figure_path, "$i.png"), fig)
    end
    return nothing
end

function make_gif(sol::OrdinaryDiffEq.ODECompositeSolution,
                  time_grid::Grids.Grid, spatial_grid::Grids.Grid)
    maxpi = max(sol[:, 2, :]...)
    maxxi = max(sol[:, 3, :]...)
    maxpsi = max(sol[:, 1, :]...)
    maxx = max(maxpi, maxxi, maxpsi)

    fig = Figure()
    ax1 = Axis(fig[1, 1:2])
    ax2 = Axis(fig[2, 1:2])
    ax3 = Axis(fig[3, 1:2])
    ax1.title = "Ψ"
    ax2.title = "π = ∂ₜ Ψ"
    ax3.title = "ξ = ∂ₓ Ψ"
    ax3.xlabel = "r"
    ylims!(ax1, -1.1 * maxpsi, 1.1 * maxpsi)
    ylims!(ax2, -1.1 * maxpi, 1.1 * maxpi)
    ylims!(ax3, -1.1 * maxxi, 1.1 * maxxi)

    record(fig, string(figure_path, "simulation.gif"), 1:(time_grid.npoints);
           framerate=15) do i
        empty!(ax1)
        empty!(ax2)
        empty!(ax3)
        lines!(ax1, spatial_grid.coords, sol[:, 1, i]; color=:blue)
        lines!(ax2, spatial_grid.coords, sol[:, 2, i]; color=:blue)
        lines!(ax3, spatial_grid.coords, sol[:, 3, i]; color=:blue)
        return nothing
    end
end

function plot_energy(sol::OrdinaryDiffEq.ODECompositeSolution,
                     time_grid::Grids.Grid, Norm::AbstractMatrix)
    Πsol = sol[:, 2, :]
    ξsol = sol[:, 3, :]

    energy = GridFunctions.GridFunction(time_grid, zeros(time_grid.npoints))
    for i in 1:(time_grid.npoints)
        energy.y[i] = (2 * π) * (transpose(Πsol[:, i]) * Norm * Πsol[:, i] +
                                 transpose(ξsol[:, i]) * Norm * ξsol[:, i])
    end
    fig = Figure()
    ax = Axis(fig[1, 1]; title="Energy", xlabel="time",
              titlefont="Computer Modern")
    lines!(ax, energy.x, energy.y)
    save(string(figure_path, "energy.png"), fig)
end

end #end of module
