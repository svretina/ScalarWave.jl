using SafeTestsets

@safetestset "domains.jl" begin
    include("domain_tests.jl")
end

@safetestset "grids.jl" begin
    include("grid_tests.jl")
end
