module SummationByPartsOperators

using LinearAlgebra
import LinearAlgebra: mul!
import Base: *
using CairoMakie
using SparseArrays
import ..Domains
import ..Grids

struct DerivativeOperator{T<:Real}
    spacing::T
    matrix::SparseMatrixCSC{T,Int}
end

function DerivativeOperator(type::String, grid::Grids.Grid)::DerivativeOperator
    matrix_c = D_cartesian(grid.npoints)
    if lowercase(type) == "cartesian"
        # Ghost zones
        matrix_c[1, 1] = 0
        matrix_c[1, 2] = 0
        return DerivativeOperator(grid.spacing, matrix_c)
    elseif lowercase(type) == "spherical"
        matrix_c[1, 1] = 0
        matrix_c[1, 2] = 1
        R = Diagonal(grid.coords .^ 2)
        R[begin, begin] = 1
        Rinv = inv(R)
        matrix_s = (Rinv * matrix_c * R) / grid.spacing
        # matrix_c[1, 2] = 1 / grid.spacing
        return DerivativeOperator(grid.spacing, matrix_s)
    else
        throw(MethodError("Not implemented type of derivative operator."))
    end
end

function mul!(g::Array{<:Real}, D::DerivativeOperator, func::Array{<:Real})
    return LinearAlgebra.mul!(g, D.matrix, func)
end

function *(D::DerivativeOperator, A::AbstractArray)
    return D.matrix * A
end

function *(A::AbstractArray, D::DerivativeOperator)
    return A * D.matrix
end

function D_cartesian(N::Integer)
    diagonal = zeros(Float64, N)
    off_diagonal1 = -ones(Float64, N - 1) / 2
    off_diagonal2 = ones(Float64, N - 1) / 2
    upper_part = zeros(Float64, N)
    upper_part[begin] = -1
    upper_part[begin + 1] = 1
    lower_part = -reverse(upper_part)
    interior = Tridiagonal(off_diagonal1, diagonal, off_diagonal2)[(begin + 1):(end - 1), :]
    D = vcat(upper_part', interior)
    D = vcat(D, lower_part')
    return D
end

end  # module SummationByPartsOperators
