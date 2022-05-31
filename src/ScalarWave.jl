module ScalarWave

include("Domains.jl")
include("Utils.jl")
include("Grids.jl")
include("GridFunctions.jl")
include("Base.jl")
include("SphericalHarmonics.jl")
include("Particle.jl")
include("MyPlots.jl")
include("ODE.jl")
include("ExecSBP.jl")

function runt(func::Function, varname::String)
    c = 1
    lmax = 40
    Ω = 0.5*c/5
    Nₜ = 201
    t = range(0, 2*2π/Ω, length=Nₜ)

    decomposition_radius = 6

    coefs = zeros(ComplexF64, Nₜ, lmax+1, lmax+1)

    SphericalHarmonics.decompose!(coefs, func, t, decomposition_radius, lmax)

    for ll in 0:4, mm in 0:ll
        @show ll, mm
        y = Particle.get_mode(coefs, ll, mm)
        fr, fi = Particle.get_interpolated_mode(t, y)
        MyPlots.plot_mode(t, y, fr, fi, varname, ll, mm)
    end
    return nothing
end

function runr(func::Function, varname::String)
    c = 1
    lmax = 40
    Ω = 0.5*c/5
    N = 201
    norbits= 2
    rstart = 6
    rend = rstart+c*norbits*2π/Ω
    rs = range(rstart, rend, length=N)
    decomposition_time = 0

    coefs = zeros(ComplexF64, N, lmax+1, lmax+1)

    SphericalHarmonics.decompose!(coefs, func, decomposition_time, rs, lmax)

    for ll in 0:4, mm in 0:ll
        @show ll, mm
        y = Particle.get_mode(coefs, ll, mm)
        fr, fi = Particle.get_interpolated_mode(rs, y)
        MyPlots.plot_mode(rs, y, fr, fi, varname, ll, mm)
    end
    return nothing
end

# runr(Particle.ψ, "ψr")
# runt(Particle.ψ, "ψt")

# runr(Particle.Φ, "Φr")
# runt(Particle.Φ, "Φt")
# runt(Particle.ξ, "xit")
# runr(Particle.ξ, "xir")


# include("ExecSBP.jl")


end
