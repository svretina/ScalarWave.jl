module MyPlots

using CairoMakie
using LaTeXStrings

function plot_mode(time::Union{Array,StepRangeLen}, data::AbstractArray, varname::String, l::Int, m::Int)
    f = Figure()
    ax = Axis(f[1,1], title = L"\%$(varname)_{%$(l)%$(m)}")
    lines!(ax, time, real(data), label="Real")
    lines!(ax, time, imag(data), xlabel=L"time", label="Imag")
    axislegend(ax)
    save("figures/$varname$l$m.png", f)
end


end #end of module
