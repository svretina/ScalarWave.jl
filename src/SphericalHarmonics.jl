module SphericalHarmonics

using SHTOOLS


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
    @assert size(data) == (lmax+1, 2lmax+1)
    zero, w = SHGLQ(nothing, lmax, norm=4, csphase=-1)
    cilm = SHExpandGLQ(lmax, data, w, nothing, zero, norm=4, csphase=-1)
    return cilm
end
end # end of module
