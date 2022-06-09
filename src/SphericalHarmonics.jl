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

function _decompose(data::AbstractArray, lmax::Int)
    @assert size(data) == (lmax+1, 2lmax+1)
    zero, w = SHGLQ(nothing, lmax, norm=4, csphase=-1)
    cilm = SHExpandGLQ(lmax, data, w, nothing, zero, norm=4, csphase=-1)
    return cilm[1,:,:] .+ cilm[2,:,:]*im
end

function _decompose!(cout::AbstractArray, data::AbstractArray, lmax::Int)
    @assert size(cout) == (lmax+1, lmax+1)
    @assert size(data) == (lmax+1, 2lmax+1)
    zero, w = SHGLQ(nothing, lmax, norm=4, csphase=-1)
    cilm = SHExpandGLQ(lmax, data, w, nothing, zero, norm=4, csphase=-1)
    cout = cilm[1,:,:] .+ cilm[2,:,:]*im
    return nothing
end

function decompose!(coefs::AbstractArray, func::Function, time_grid::Union{Array,StepRangeLen}, radius::Real, lmax::Int)
    # println("constant radius")
    @assert size(coefs) == (length(time_grid), lmax+1, lmax+1)
    # get Gauss-Legendre Grid
    θᴳ, ϕᴳ = GaussLegendreGrid(lmax)
    # allocate memory for outputs
    functionGL = zeros(length(θᴳ), length(ϕᴳ))

    for (ti, t) in enumerate(time_grid)
        # sample function on sphere of radius `radius`
        for (j, ϕᵢ) in enumerate(ϕᴳ)
            for (i, θᵢ) in enumerate(θᴳ)
                functionGL[i,j] = func(t, radius, θᵢ, ϕᵢ)
            end
        end

        coefs[ti,:,:] = _decompose(functionGL, lmax)
    end
    return nothing
end

function decompose!(coefs::AbstractArray, func::Function, time_instance::Real, spatial_grid::Union{Array,StepRangeLen}, lmax::Int)
    # println("constant time")
    @assert size(coefs) == (length(spatial_grid), lmax+1, lmax+1)
    println("constant time")
    # get Gauss-Legendre Grid
    θᴳ, ϕᴳ = GaussLegendreGrid(lmax)
    # allocate memory for outputs
    functionGL = zeros(length(θᴳ), length(ϕᴳ))

    for (ri, r) in enumerate(spatial_grid)
        # sample function on sphere of radius `radius`
        for (j, ϕᵢ) in enumerate(ϕᴳ)
            for (i, θᵢ) in enumerate(θᴳ)
                functionGL[i,j] = func(time_instance, r, θᵢ, ϕᵢ)
            end
        end

        coefs[ri,:,:] = _decompose(functionGL, lmax)
    end
    return nothing
end



end # end of module
