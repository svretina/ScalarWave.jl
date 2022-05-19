module base

import ..grid_functions

#################
## isapprox
#################
import Base.isapprox
function Base.isapprox(gf::grid_functions.GridFunction, number; atol::Real=0, rtol::Real=0, nans::Bool=false, norm::Function=abs)
    all(isapprox.(gf.y, number; atol, rtol, nans, norm))
end

function Base.isapprox(number, gf::grid_functions.GridFunction; atol::Real=0, rtol::Real=0, nans::Bool=false, norm::Function=abs)
    all(isapprox.(number, gf.y; atol, rtol, nans, norm))
end

function Base.isapprox(gf1::grid_functions.GridFunction, gf2::grid_functions.GridFunction; atol::Real=0, rtol::Real=0, nans::Bool=false, norm::Function=abs)
    gf1.x == gf2.x || throw(DimensionMismatch("x's are not the same"))
    return all(isapprox.(gf1.y, gf2.y; atol, rtol, nans, norm))
end

math_operators = [:+, :-, :*, :/, :^]
for op in math_operators
    @eval import Base.$op
    @eval $op(gf::grid_functions.GridFunction, number) = grid_functions.GridFunction(gf.x, @. $op(gf.y, number))

    @eval $op(number, gf::grid_functions.GridFunction) = grid_functions.GridFunction(gf.x, @. $op(number, gf.y))

    @eval begin
        function $op(gf1::grid_functions.GridFunction, gf2::grid_functions.GridFunction)
                gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
                return grid_functions.GridFunction(gf1.x, @. $op(gf1.y, gf2.y))
        end
    end
end

logical_operators = [:<, :(==), :<=]
for op in logical_operators
    @eval import Base.$op
    @eval $op(gf::grid_functions.GridFunction, number) = all(@. $op(gf.y, number))

    @eval $op(number, gf::grid_functions.GridFunction) = all(@. $op(number, gf.y))

    @eval begin
        function $op(gf1::grid_functions.GridFunction, gf2::grid_functions.GridFunction)
            gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
            return $op(gf1.y, gf2.y)
        end
    end
end

math_functions = [:sin, :cos, :tan,
                  :asin, :acos, :atan,
                  :sinh, :cosh, :tanh,
                  :asinh, :acosh, :atanh,
                  :sec, :csc, :cot,
                  :asec, :acsc, :acot,
                  :sech, :csch, :coth,
                  :asech, :acsch, :acoth,
                  :sinpi, :cospi,
                  :sinc, :cosc,
                  :log, :log2, :log10, :exp, :exp2, :abs, :abs2, :sqrt,
                  :cbrt, :inv, :+, :-
                 ]

for op in math_functions
    @eval import Base.$op
    @eval $op(gf::grid_functions.GridFunction) = grid_functions.GridFunction(gf.x, @. $op(gf.y))
end

reductions = [:max, :min]
for op in reductions
    @eval import Base.$op
    @eval $op(gf::grid_functions.GridFunction) = $op(gf.y...)
end
end # end of module
