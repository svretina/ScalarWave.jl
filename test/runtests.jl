using SafeTestsets

@safetestset "domains.jl" begin
    include("domain_tests.jl")
end

@safetestset "utils.jl" begin
    include("util_tests.jl")
end

@safetestset "grids.jl" begin
    include("grid_tests.jl")
end

@safetestset "grid_functions.jl" begin
    include("grid_function_tests.jl")
end

@safetestset "base.jl" begin
    include("base_tests.jl")
end
