using SafeTestsets


@safetestset "domains.jl" begin
    include("domain_tests.jl")
end
