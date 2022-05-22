using SafeTestsets

@safetestset "Domains.jl" begin
    include("DomainTests.jl")
end

@safetestset "Utils.jl" begin
    include("UtilTests.jl")
end

@safetestset "Grids.jl" begin
    include("GridTests.jl")
end

@safetestset "GridFunctions.jl" begin
    include("GridFunctionTests.jl")
end

@safetestset "Base.jl" begin
    include("BaseTests.jl")
end

@safetestset "SphericalHarmonics.jl" begin
    include("SphericalHarmonicsTests.jl")
end
