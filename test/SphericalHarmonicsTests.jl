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
    ylm = zeros(ComplexF64,length(θ), length(ϕ))
    for (j, ϕⱼ) in enumerate(ϕ)
        for (i, θᵢ) in enumerate(θ)
            ylm[i,j] = cos(θᵢ)
        end
    end
    coefs = ScalarWave.SphericalHarmonics.Decompose(ylm, lmax)
    l, m = 1, 0
    @test coefs[:,1+l,1+m] != 0
    coefs[1,1+l, 1+m] = 0
    @test all(isapprox.(coefs, 0, atol=1e-10))
end
