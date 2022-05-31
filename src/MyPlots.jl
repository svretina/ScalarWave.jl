module MyPlots

using CairoMakie
using LaTeXStrings
import ..Particle
import ..Utils
"""
Plots the real and imaginary part of a mode
"""
function plot_mode(time::Union{Array,StepRangeLen}, data::AbstractArray, varname::String, l::Int, m::Int)
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
        dmax = 1.1 *dmax
    end

    f = Figure()
    ax = Axis(f[1,1], title = L"\%$(varname)_{%$(l)%$(m)}")
    lines!(ax, time, real(data), label="Real")
    lines!(ax, time, imag(data), xlabel=L"time", label="Imag")
    ylims!(dmin, dmax)
    axislegend(ax)
    save("figures/$varname$l$m.png", f)
end

"""
Plots the mode and the interpolated functions
"""
function plot_mode(time::Union{Array,StepRangeLen}, data::AbstractArray, fr::AbstractArray, fi::AbstractArray, varname::String, l::Int, m::Int)
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
        dmax = 1.1 *dmax
    end

    f = Figure()
    ax = Axis(f[1,1], title = L"%$(varname)_{%$(l)%$(m)}")
    scatter!(ax, time, real(data), label="Real")
    lines!(ax, time, fr(time))
    scatter!(ax, time, imag(data), xlabel=L"time", label="Imag")
    lines!(ax, time, fi(time))
    ylims!(dmin, dmax)
    axislegend(ax)
    save("figures/$varname$l$m.png", f)
end

function animate_potential()
    Ω = 0.5*3e8/5
    rs = range(0,200,length=101)
    φs = range(0,2π,length=51)
    ϕ = zeros(length(rs),length(φs))
    for (ri, r) in enumerate(rs)
        for (φi, φ) in enumerate(φs)
            ϕ[ri,φi] = r*Particle.Φ(0,r,π/2,φ)
            replace!(ϕ, Inf=>0)
        end
    end

    time = Observable(0.0)
    listener = on(time) do val
        for (ri, r) in enumerate(rs)
            for (φi, φ) in enumerate(φs)
                ϕ[ri,φi] = r*Particle.Φ(val,r,π/2,φ)
                replace!(ϕ, Inf=>0)
            end
        end
    end

    fig = Figure();
    ax = Axis(fig[1,1]);

    hm = heatmap!(rs, φs, ϕ, extendlow = :auto, extendhigh = :auto);
    # , colorrange=(0,0.8)
    Colorbar(fig[:, end+1], hm)
    framerate = 30
    timestamps = range(0, 2π/Ω, length=101)
    record(fig, "potential.gif", timestamps;
        framerate = framerate) do t
            # @show t
            time[] = t
            hm = heatmap!(rs, φs, ϕ, extendlow = :auto, extendhigh = :auto);
    end


end
 # animate_potential()

end #end of module
