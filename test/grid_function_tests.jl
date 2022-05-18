using Test
using ScalarWave

@testset "gf_tests_arrays" begin
    x = [0,1,2,3,4]
    y = [0,1,2,3,4]
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == y

    x = [0.,1.,2.,3.,4.]
    y = [0.,1.,2.,3.,4.]
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == y

end

@testset "gf_tests_stepranges" begin
    x = 0:1:4
    y = [0,1,2,3,4]
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == y

    x = 0:0.1:0.4
    y = [0.,1.,2.,3.,4.]
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == y
end

@testset "gf_tests_functions" begin
    x = 0:1:10
    f = sin
    @test ScalarWave.grid_functions.GridFunction(x,f).x == x
    @test ScalarWave.grid_functions.GridFunction(x,f).y == sin.(x)

    x = 0:0.1:1
    y = sin
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == sin.(x)

    x = [0,1,2,3,4,5]
    y = sin
    @test ScalarWave.grid_functions.GridFunction(x,y).x == x
    @test ScalarWave.grid_functions.GridFunction(x,y).y == sin.(x)
end


@testset "gf_tests_dimensions" begin
    @test_throws DimensionMismatch ScalarWave.grid_functions.GridFunction([0, 1], [0,2,3])

    @test_throws DimensionMismatch ScalarWave.grid_functions.GridFunction(0:1:4, [0,1,2])

    @test_throws DimensionMismatch ScalarWave.grid_functions.GridFunction(0:0.1:1, [0,1])
end
