module ODE

import SummationByPartsOperators as SBPO

function rhs!(du, U, params, t)
    D = params.D
    α = params.α

    ustar = params.ustarf(t)
    vstar = params.vstarf

    du[:,1] = U[:,2]
    du[:,2] = D * U[:,3]
    du[:,3] = D * U[:,2]

    ### SAT boundary treatment
    ### Left Boundary
    du[begin,2] -=  (α/(2.0*SBPO.left_boundary_weight(D))) * (U[begin,2]-U[begin,3] - ustar)
    du[begin,3] += (α/(2.0*SBPO.left_boundary_weight(D))) * (U[begin,2]-U[begin,3]- ustar)

    ### Right Boundary
    du[end,2] -= (α/(2.0*SBPO.right_boundary_weight(D))) * (U[end,2]+U[end,3]- vstar)
    du[end,3] -= (α/(2.0*SBPO.right_boundary_weight(D))) * (U[end,2]+U[end,3]- vstar)
    return nothing
end

end  # module ODE
