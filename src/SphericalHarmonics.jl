module SphericalHarmonics

using SHTOOLS

cphase = -1
normalization = "ortho"

function GaussLegendreGrid(lmax; radians=true)
    latitude, longitude = GLQGridCoord(lmax, extend=false)
    θ = @. 90 - latitude
    ϕ = longitude
    if radians
        θ = deg2rad.(θ)
        ϕ = deg2rad.(ϕ)
    end
    return θ, ϕ
end

function Decompose(data, lmax)
    zero, w = SHGLQ(nothing, lmax, norm=4, csphase=-1)
    try
        global cilm = SHExpandGLQ(lmax, data, w, nothing, zero, norm=4, csphase=-1)
    catch e
        global cilm = SHExpandGLQ(lmax, transpose(data), w, nothing, zero, norm=4, csphase=-1)
    end
    return cilm
end
end # end of module
