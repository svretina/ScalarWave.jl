using Test
using ScalarWave
using PyCall

@testset "GaussLegendreGrid tests" begin
    lmax = 4
    θ, ϕ = ScalarWave.SphericalHarmonics.GaussLegendreGrid(lmax, radians=true)
    @test length(θ) == lmax+1
    @test length(ϕ) == 2*lmax + 1
end

@testset "Decompose tests" begin
    lmax = 10
    θ, ϕ = ScalarWave.SphericalHarmonics.GaussLegendreGrid(lmax, radians=true)
    l = 2
    m = 0
    scipy = pyimport("scipy.special")
    ylm = zeros(ComplexF64,length(θ), length(ϕ))
    for (i, θᵢ) in enumerate(θ)
        for (j, ϕⱼ) in enumerate(ϕ)
            ylm[i,j] = scipy.sph_harm(m, l, ϕⱼ, θᵢ)
        end
    end
    coefs = ScalarWave.SphericalHarmonics.Decompose(ylm, lmax)
    @test isapprox(coefs[1,1+l,1+m], 1, atol=1e-10)
end
