using Test
using ScalarWave
using LinearAlgebra

@testset "SBP property tests cartesian case" begin
    d = ScalarWave.Domains.Domain([0, 10])
    g = ScalarWave.Grids.Grid(d, 4)
    D = ScalarWave.SummationByPartsOperators.Gradient(g)
    B = ScalarWave.SummationByPartsOperators.CartesianBoundary(g)
    W = ScalarWave.SummationByPartsOperators.CartesianNorm(g)
    @test W * D + transpose(W * D) == W * B
end

@testset "SBP property tests spherical case" begin
    D = 3
    l = 2
    n = D - 1
    p = 2 * l + n
    d = ScalarWave.Domains.Domain([0, 4])
    g = ScalarWave.Grids.Grid(d, 4)

    Grad = Rational.(ScalarWave.SummationByPartsOperators.Gradient(g))
    B = Rational.(ScalarWave.SummationByPartsOperators.SphericalBoundary(p, g))
    W = Rational.(ScalarWave.SummationByPartsOperators.SphericalNorm(p, g))
    Div = ScalarWave.SummationByPartsOperators.Divergence(W, B, Grad)

    @test W * Div + transpose(W * Grad) == B
end

@testset "DerivativeOperator gradient tests" begin
    d = ScalarWave.Domains.Domain([0, 10])
    g = ScalarWave.Grids.Grid(d, 10)
    f = ScalarWave.GridFunctions.GridFunction(g, g.coords)
    D_c = ScalarWave.SummationByPartsOperators.Gradient(g)

    @test D_c * f == ones(g.npoints)
    @test (D_c * (f .^ 2))[(begin + 1):(end - 1)] ==
          2 .* g.coords[(begin + 1):(end - 1)]
end

# @testset "DerivativeOperator divergence tests" begin
#     h(r) = r
#     j(r) = 3 * r
#     h′(r) = 3 # ForwardDiff.derivative(rr -> rr^2 * h(rr), r) / r^2

#     d = ScalarWave.Domains.Domain([0, 10])
#     g = ScalarWave.Grids.Grid(d, 10)
#     f = ScalarWave.GridFunctions.GridFunction(g, h)
#     D_d = ScalarWave.SummationByPartsOperators.DerivativeOperator(:divergence,
#                                                                   g)
#     deriv_d = D_d * f
#     D_g = ScalarWave.SummationByPartsOperators.DerivativeOperator(:gradient, g)

#     deriv_g = D_g * ScalarWave.GridFunctions.GridFunction(g, j)
#     for i in 1:(g.npoints)
#         println(deriv_d[i], " ", deriv_g[i], " ", h′(g.coords[i]), " ",
#                 g.spacing^2)
#     end
#     @test D_d * f == h′.(g.coords)
# end
