module SummationByPartsOperators

using LinearAlgebra
using SparseArrays
import ..Grids

function Gradient(grid::Grids.Grid)
    matrix_c = D_cartesian(grid.npoints)
    return matrix_c / grid.spacing
end

function Divergence(p::Int, grid::Grids.Grid)
    # matrix_c = D_cartesian(grid.npoints)
    # R = Diagonal(grid.coords .^ p)
    # R[begin, begin] = 1 / 1 + p
    # Rinv = inv(R)
    # # Rinv[begin] = p + 1
    # matrix_s = Rinv * matrix_c * R
    # return matrix_s / grid.spacing
    grad = Gradient(grid)
    w = SphericalNorm(p, grid)
    b = SphericalBoundary(p, grid)
    return -inv(w) * transpose(grad) * w + inv(w) * b
end

function Divergence(W::AbstractMatrix, B::AbstractMatrix, G::AbstractMatrix)
    return -inv(W) * transpose(G) * W + inv(W) * B
end

function D_cartesian(N::Integer)
    diagonal = zeros(Float64, N)
    off_diagonal1 = -ones(Float64, N - 1) / 2
    off_diagonal2 = ones(Float64, N - 1) / 2
    upper_part = zeros(Float64, N)
    upper_part[begin] = -1
    upper_part[begin + 1] = 1
    lower_part = -reverse(upper_part)
    interior = Tridiagonal(off_diagonal1, diagonal, off_diagonal2)[(begin + 1):(end - 1),
                                                                   :]
    D = vcat(upper_part', interior)
    D = vcat(D, lower_part')
    return D
end

function CartesianBoundary(grid::Grids.Grid)
    matrix = Diagonal(zeros(grid.npoints))
    matrix[begin, begin] = -2 / grid.spacing
    matrix[end, end] = 2 / grid.spacing
    return matrix
end

function SphericalBoundary(p::Int, grid::Grids.Grid)
    matrix = Diagonal(zeros(grid.npoints))
    matrix[end, end] = (grid.coords[end] / grid.spacing)^p
    return matrix
end

function CartesianNorm(grid::Grids.Grid)
    matrix = Diagonal(grid.spacing .* ones(grid.npoints))
    matrix[begin, begin] /= 2
    matrix[end, end] /= 2
    return matrix
end

function SphericalNorm(p::Int, grid::Grids.Grid)
    matrix_s = Diagonal((grid.coords / grid.spacing) .^ p)
    matrix_s[begin, begin] = 2 / (1 + p)
    matrix_s[end, end] /= 2
    return matrix_s
end

end  # module SummationByPartsOperators
