using Test
using ScalarWave

dd = ScalarWave.domains.Domain([0,1])
ncells = 10
gg = ScalarWave.grids.Grid(dd, ncells)

@testset "grid_tests_domain" begin
    @test gg.domain == dd
end

@testset "grid_tests_ncells" begin
    @test gg.ncells == ncells
    @test gg.npoints == ncells + 1
end

@testset "grid_tests_coords" begin
    @test gg.coords == [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    println(length(gg.coords))
    println(ncells+1)
    @test length(gg.coords) == ncells + 1
end

@testset "grid_tests_spacing" begin
    @test gg.spacing == 0.1
end
