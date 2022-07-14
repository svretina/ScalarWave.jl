using Test
using ScalarWave

@testset "domain_tests_domain" begin
    @test ScalarWave.Domains.Domain([0, 1]).domain == [0, 1]
end

@testset "domain_tests_minmax" begin
    @test ScalarWave.Domains.Domain([0, 1]).dmin == 0
    @test ScalarWave.Domains.Domain([0, 1]).dmax == 1
end
