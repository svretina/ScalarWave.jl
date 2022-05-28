using Test
using ScalarWave

@testset "domain_tests_domain" begin
    @test ScalarWave.Domains.Domain([0, 1]).domain == [0, 1]
end

@testset "domain_tests_dims" begin
    @test ScalarWave.Domains.Domain([0, 1]).dims == 1
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3]]).dims == 2
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3] [3, 5]]).dims == 3
end

@testset "domain_tests_minmax" begin
    @test ScalarWave.Domains.Domain([0, 1]).dmin == 0
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3]]).dmin == 0
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3] [3, 5]]).dmin == 0

    @test ScalarWave.Domains.Domain([0, 1]).dmax == 1
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3]]).dmax == 3
    @test ScalarWave.Domains.Domain([[0, 1] [2, 3] [3, 5]]).dmax == 5
end