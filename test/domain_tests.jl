using ScalarWave
using Test


@testset "domain_tests_domain" begin
    @test ScalarWave.Domain([0, 1]).domain == [0, 1]
end

@testset "domain_tests_dims" begin
    @test ScalarWave.Domain([0, 1]).dims == 1
    @test ScalarWave.Domain([[0, 1] [2, 3]]).dims == 2
    @test ScalarWave.Domain([[0, 1] [2, 3] [3, 5]]).dims == 3
end
