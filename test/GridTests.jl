using Test
using ScalarWave

dd = ScalarWave.Domains.Domain([0,1])
ncells = 10
gg = ScalarWave.Grids.Grid(dd, ncells)

@testset "Grid_tests_domain" begin
    @test gg.domain == dd
end

@testset "Grid_tests_ncells" begin
    @test gg.ncells == ncells
    @test gg.npoints == ncells + 1
end

@testset "Grid_tests_coords" begin
    @test gg.coords == 0:0.1:1
    @test length(gg.coords) == ncells + 1
end

@testset "Grid_tests_spacing" begin
    @test gg.spacing == 0.1
end
