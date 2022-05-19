using Test
using ScalarWave


@testset "gf_base_equality" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    @test a == b
    @test a.y == b.y
    @test a == 0
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a == c
    @test_throws DimensionMismatch c == a

end

@testset "gf_base_inequality" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,2,3])
    @test a != b
    @test b != a
    @test a.y != b.y
    @test a != 1
    @test 1 != a
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a != c
    @test_throws DimensionMismatch c != a
end

@testset "gf_base_greater" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,2,3])
    @test b > a
    @test 1 > a
    @test 5 > b
    @test a > -1
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a > c
    @test_throws DimensionMismatch c > a
end

@testset "gf_base_greatereq" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,2,3])
    @test b >= a
    @test a >= a
    @test 1 >= a
    @test 3 >= b
    @test a >= 0
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a >= c
    @test_throws DimensionMismatch c >= a
end

@testset "gf_base_lesseq" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,2,3])
    @test a <= b
    @test a <= a
    @test a <= 0
    @test a <= 5
    @test 1 <= b
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a <= c
    @test_throws DimensionMismatch c <= a
end

@testset "gf_base_less" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,2,3])
    @test a < b
    @test a < 1
    @test b < 5
    @test -1 < a
    c = ScalarWave.grid_functions.GridFunction([0,1,3], [0,0,0])
    @test_throws DimensionMismatch a > c
    @test_throws DimensionMismatch c > a
end

@testset "gf_base_addition" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    b = a+1
    c = 1+a
    d = a+a
    e = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    @test b == e
    @test a == a+0
    @test a == 0+a
    @test a == a+a
    @test a == +a
    @test +a == a
end

@testset "gf_base_substraction" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    b = a-1
    c = 1-a
    d = a-a
    e = ScalarWave.grid_functions.GridFunction([0,1,2], [0,0,0])
    @test b == e
    @test a == a-0
    @test -a == 0-a
    @test d == e
    @test d == 0
    @test b == 0
end

@testset "gf_base_multiplication" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])

    @test a == 1*a
    @test a == a*1
    @test +a == 1*a
    @test +a == a*1
    @test -a == -1*a
    @test -a == a*(-1)
    @test a+a == 2*a
    @test a+a == a*2
    @test 0 == a*0
    @test 0 == 0*a
    @test 0 == -a*0
    @test 0 == 0*(-a)
    @test 0 == +a*0
    @test 0 == 0*(+a)
    @test 5 == 5*a
    @test -5 == -5*a
    @test 1 == a*b
    @test 1 == b*a
end

@testset "gf_base_division" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    b = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    @test 0.5 == a/2
    @test a == a/1
    @test +a == a/1
    @test -a == a/(-1)
    @test 5 == 5/a
    @test -5 == -5/a
    @test 1 == a/b
    @test 1 == b/a
    @test 1 == a/a
    @test Inf == a/0
end

@testset "gf_base_power" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    @test 1 == a^1
    @test 1 == a^2
    @test 1 == a^-1
    @test a == a^1
    @test 1 == a^0
    @test 1 == a^a
    @test 1 == 1^a
    @test 0 == 0^a
end

@testset "gf_base_inv" begin
    a = ScalarWave.grid_functions.GridFunction([0,1,2], [1,1,1])
    @test 1/a == inv(a)
end
