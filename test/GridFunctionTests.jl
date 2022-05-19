using Test
using ScalarWave

@testset "gf_tests_arrays" begin
    x = [0,1,2,3,4]
    y = [0,1,2,3,4]
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == y

    x = [0.,1.,2.,3.,4.]
    y = [0.,1.,2.,3.,4.]
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == y

end

@testset "gf_tests_stepranges" begin
    x = 0:1:4
    y = [0,1,2,3,4]
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == y

    x = 0:0.1:0.4
    y = [0.,1.,2.,3.,4.]
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == y
end

@testset "gf_tests_functions" begin
    x = 0:1:10
    f = sin
    @test ScalarWave.GridFunctions.GridFunction(x,f).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,f).y == sin.(x)

    x = 0:0.1:1
    y = sin
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == sin.(x)

    x = [0,1,2,3,4,5]
    y = sin
    @test ScalarWave.GridFunctions.GridFunction(x,y).x == x
    @test ScalarWave.GridFunctions.GridFunction(x,y).y == sin.(x)
end

@testset "gf_tests_Grids" begin
    d = ScalarWave.Domains.Domain([0,1])
    x = ScalarWave.Grids.Grid(d, 10)
    f = sin
    @test ScalarWave.GridFunctions.GridFunction(x, f).y == sin.(x.coords)

    y = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @test ScalarWave.GridFunctions.GridFunction(x, y).y == y
    @test ScalarWave.GridFunctions.GridFunction(x, y).x == x.coords
end


@testset "gf_tests_dimensions" begin
    @test_throws DimensionMismatch ScalarWave.GridFunctions.GridFunction([0, 1], [0,2,3])

    @test_throws DimensionMismatch ScalarWave.GridFunctions.GridFunction(0:1:4, [0,1,2])

    @test_throws DimensionMismatch ScalarWave.GridFunctions.GridFunction(0:0.1:1, [0,1])
end
