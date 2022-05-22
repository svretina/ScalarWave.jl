using Test
using ScalarWave

@testset "discretize_test" begin
    ui = 0
    uf = 10
    nu = 10
    @test ScalarWave.Utils.discretize(ui, uf, nu) == [0, 1, 2, 3, 4, 5, 6, 7, 8 ,9 ,10]

    ui = 0.0
    uf = 10.0
    nu = 10
    @test ScalarWave.Utils.discretize(ui, uf, nu) == [0.0, 1., 2., 3., 4., 5., 6., 7., 8., 9., 10.]

    @test typeof(ScalarWave.Utils.discretize(ui, uf, nu)) == StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}
end

@testset "spacing_tests" begin

    @test ScalarWave.Utils.spacing(0, 10, 10) == 1
    @test ScalarWave.Utils.spacing(0, 1, 10) == 0.1
    @test ScalarWave.Utils.spacing(0, 2, 10) == 0.2

    d = ScalarWave.Domains.Domain([0, 1])
    @test ScalarWave.Utils.spacing(d, 10) == 0.1
    d = ScalarWave.Domains.Domain([0, 10])
    @test ScalarWave.Utils.spacing(d, 10) == 1
    d = ScalarWave.Domains.Domain([0, 2])
    @test ScalarWave.Utils.spacing(d, 10) == 0.2
end

@testset "spherica2cartesian tests" begin
    r = 5.
    θ = π /2
    ϕ = 0.
    x, y, z = ScalarWave.Utils.Spherical2Cartesian(r, θ, ϕ)
    @test isapprox(x, 5, atol=1e-15)
    @test isapprox(y, 0, atol=1e-15)
    @test isapprox(z, 0, atol=1e-15)
end
