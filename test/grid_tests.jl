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
    @test gg.coords == 0:0.1:1
    @test length(gg.coords) == ncells + 1
end

@testset "grid_tests_spacing" begin
    @test gg.spacing == 0.1
end
