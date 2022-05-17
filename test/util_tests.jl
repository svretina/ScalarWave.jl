using Test
using ScalarWave

@testset "discretize_test" begin
    ui = 0
    uf = 10
    nu = 10
    @test ScalarWave.utils.discretize(ui, uf, nu) == [0, 1, 2, 3, 4, 5, 6, 7, 8 ,9 ,10]

    ui = 0.0
    uf = 10.0
    nu = 10
    @test ScalarWave.utils.discretize(ui, uf, nu) == [0.0, 1., 2., 3., 4., 5., 6., 7., 8., 9., 10.]

    @test typeof(ScalarWave.utils.discretize(ui, uf, nu)) == StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}
end

@testset "spacing_tests" begin

    @test ScalarWave.utils.spacing(0, 10, 10) == 1
    @test ScalarWave.utils.spacing(0, 1, 10) == 0.1
    @test ScalarWave.utils.spacing(0, 2, 10) == 0.2

    d = ScalarWave.domains.Domain([0, 1])
    @test ScalarWave.utils.spacing(d, 10) == 0.1
    d = ScalarWave.domains.Domain([0, 10])
    @test ScalarWave.utils.spacing(d, 10) == 1
    d = ScalarWave.domains.Domain([0, 2])
    @test ScalarWave.utils.spacing(d, 10) == 0.2
end
