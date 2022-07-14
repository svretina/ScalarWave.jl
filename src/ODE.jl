module ODE

import SummationByPartsOperators as SBPO

function rhs!(du, U, params, t)
    D = params.D
    α = params.α

    ustar = params.ustarf(t)
    vstar = params.vstarf

    du[:, 1] = U[:, 2]
    du[:, 2] = D * U[:, 3]
    du[:, 3] = D * U[:, 2]

    ### SAT boundary treatment
    ### Left Boundary
    du[begin, 2] -= (α / (2.0 * SBPO.left_boundary_weight(D))) *
                    (U[begin, 2] - U[begin, 3] - ustar)
    du[begin, 3] += (α / (2.0 * SBPO.left_boundary_weight(D))) *
                    (U[begin, 2] - U[begin, 3] - ustar)

    ### Right Boundary
    du[end, 2] -= (α / (2.0 * SBPO.right_boundary_weight(D))) *
                  (U[end, 2] + U[end, 3] - vstar)
    du[end, 3] -= (α / (2.0 * SBPO.right_boundary_weight(D))) *
                  (U[end, 2] + U[end, 3] - vstar)
    return nothing
end

function spherical_rhs!(du, U, params, t)
    Grad = params.Grad
    Div = params.Div
    h = params.h
    # Ψ = U[:, 1]
    # Π = U[:, 2]
    # ξ = U[:, 3]

    # dΨ = du[:, 1]
    # dΠ = du[:, 2]
    # dξ = du[:, 3]
    U[begin, 3] = 0
    du[:, 1] = U[:, 2]
    du[:, 2] = Div * U[:, 3]
    du[:, 3] = Grad * U[:, 2]

    ### Left Boundary
    ### already in the derivative operators
    du[begin, 2] = U[2, 3] / h
    du[begin, 3] = 0 #du[begin, 2]

    ### Right Boundary
    du[end, 2] -= (1 / (2.0 * params.w)) * (U[end, 2] + U[end, 3] - 0)
    du[end, 3] -= (1 / (2.0 * params.w)) * (U[end, 2] + U[end, 3] - 0)

    U[begin, 3] = 0
    # U = hcat(Ψ, Π, ξ)
    # du = hcat(dΨ, dΠ, dξ)
    return nothing
end

end  # module ODE
