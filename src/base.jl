module base

import ..grid_functions
import Base.+

#################
## Addition
#################
function +(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    return grid_functions.GridFunction(gf.x, gf.y .+ number)
end

function +(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    return grid_functions.GridFunction(gf.x, gf.y .+ number)
end

function +(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
    return grid_functions.GridFunction(gf1.x, gf1.y.+ gf2.y)
end

function +(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, gf.y)
end

#################
## Substraction
#################
import Base.-
function -(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    return grid_functions.GridFunction(gf.x, gf.y .- number)
end

function -(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    return grid_functions.GridFunction(gf.x, number .- gf.y)
end

function -(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
    return grid_functions.GridFunction(gf1.x, gf1.y.- gf2.y)
end

function -(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, -(gf.y))
end

#################
## Multiplication
#################
import Base.*
function *(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    return grid_functions.GridFunction(gf.x, gf.y .* number)
end

function *(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    return grid_functions.GridFunction(gf.x, gf.y .* number)
end

function *(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
    return grid_functions.GridFunction(gf1.x, gf1.y.* gf2.y)

end

#################
## Division
#################
import Base./
function /(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    return grid_functions.GridFunction(gf.x, gf.y ./ number)
end

function /(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    return grid_functions.GridFunction(gf.x, number ./ gf.y)
end

function /(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x || throw(DimensionMismatch("x's not the same"))
    return grid_functions.GridFunction(gf1.x, gf1.y./ gf2.y)
end

#################
## inv(x)
#################
import Base.inv
function inv(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, inv.(gf.y))
end

#################
## power
#################
import Base.^
function ^(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    return grid_functions.GridFunction(gf.x, gf.y .^ number)
end

function ^(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    return grid_functions.GridFunction(gf.x, number .^ gf.y)
end

function ^(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    if gf1.x == gf2.x
        return grid_functions.GridFunction(gf1.x, gf1.y .^ gf2.y)
    end
end

#################
## equality
#################
import Base.==
function ==(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y .== number)
end

function ==(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number .== gf.y)
end

function ==(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && gf1.y == gf2.y || throw(DimensionMismatch("x's or y's are not the same"))
end

#################
## not-equality
#################
import Base.!=
function !=(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y != number)
end

function !=(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number != gf.y)
end

function !=(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && gf1.y != gf2.y || throw(DimensionMismatch("x's are not the same"))
end

#################
## less
#################
import Base.<
function <(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y .< number)
end

function <(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number .< gf.y)
end

function <(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && all(gf1.y .< gf2.y) || throw(DimensionMismatch("x's not the same"))
end

#################
## less-equality
#################
import Base.<=
function <=(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y .<= number)
end

function <=(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number .<= gf.y)
end

function <=(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && all(gf1.y .<= gf2.y) || throw(DimensionMismatch("x's not the same"))
end

#################
## greater
#################
import Base.>
function >(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y .> number)
end

function >(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number .> gf.y)
end

function >(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && all(gf1.y .> gf2.y) || throw(DimensionMismatch("x's not the same"))
end

#################
## greater-equality
#################
import Base.>=
function >=(gf::grid_functions.GridFunction{T, S}, number::R) where {T, S, R}
    all(gf.y .>= number)
end

function >=(number::R, gf::grid_functions.GridFunction{T, S}) where {R, T, S}
    all(number .>= gf.y)
end

function >=(gf1::grid_functions.GridFunction{T, S}, gf2::grid_functions.GridFunction{K, L}) where {T, S, K, L}
    gf1.x == gf2.x && all(gf1.y .>= gf2.y) || throw(DimensionMismatch("x's not the same"))
end


#################
## sinx
#################
import Base.sin
function sin(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sin.(gf.y))
end

#################
## cosx
#################
import Base.cos
function sin(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cos.(gf.y))
end

#################
## tanx
#################
import Base.tan
function tan(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, tan.(gf.y))
end

#################
## sin(πx)
#################
import Base.sinpi
function sinpi(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sinpi.(gf.y))
end

#################
## cos(πx)
#################
import Base.cospi
function cospi(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cospi.(gf.y))
end

#################
## sinh(x)
#################
import Base.sinh
function sinh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sinh.(gf.y))
end

#################
## cosh(x)
#################
import Base.cosh
function cosh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cosh.(gf.y))
end

#################
## tanh(x)
#################
import Base.tanh
function tanh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, tanh.(gf.y))
end

#################
## asin(x)
#################
import Base.asin
function asin(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, asin.(gf.y))
end

#################
## acos(x)
#################
import Base.acos
function acos(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acos.(gf.y))
end

#################
## atan(x)
#################
import Base.atan
function atan(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, atan.(gf.y))
end

#################
## sec(x)
#################
import Base.sec
function sec(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sec.(gf.y))
end

#################
## csc(x)
#################
import Base.csc
function csc(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, csc.(gf.y))
end

#################
## cot(x)
#################
import Base.cot
function cot(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cot.(gf.y))
end

#################
## asec(x)
#################
import Base.asec
function asec(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, asec.(gf.y))
end

#################
## acsc(x)
#################
import Base.acsc
function acsc(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acsc.(gf.y))
end

#################
## acot(x)
#################
import Base.acot
function acot(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acot.(gf.y))
end

#################
## sech(x)
#################
import Base.sech
function sech(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sech.(gf.y))
end

#################
## csch(x)
#################
import Base.csch
function csch(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, csch.(gf.y))
end

#################
## coth(x)
#################
import Base.coth
function coth(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, coth.(gf.y))
end

#################
## asinh(x)
#################
import Base.asinh
function asinh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, asinh.(gf.y))
end

#################
## acosh(x)
#################
import Base.acosh
function acosh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acosh.(gf.y))
end

#################
## atanh(x)
#################
import Base.atanh
function atanh(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, atanh.(gf.y))
end

#################
## asech(x)
#################
import Base.asech
function asech(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, asech.(gf.y))
end

#################
## acsch(x)
#################
import Base.acsch
function acsch(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acsch.(gf.y))
end

#################
## acoth(x)
#################
import Base.acoth
function acoth(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, acoth.(gf.y))
end

#################
## sinc(x)
#################
import Base.sinc
function sinc(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sinc.(gf.y))
end

#################
## cosc(x)
#################
import Base.cosc
function cosc(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cosc.(gf.y))
end

#################
## log(x)
#################
import Base.log
function log(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, log.(gf.y))
end

#################
## exp(x)
#################
import Base.exp
function exp(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, exp.(gf.y))
end

#################
## min
#################
import Base.min
function min(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return min(gf.y...)
end

#################
## max
#################
import Base.max
function max(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return max(gf.y...)
end

#################
## minmax
#################
import Base.minmax
function minmax(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return minmax(gf.y...)
end

#################
## abs
#################
import Base.abs
function abs(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, abs.(gf.y))
end

#################
## abs2
#################
import Base.abs2
function abs2(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, abs2.(gf.y))
end

# Should this return a GridFunction or just the result array, maybe the 2nd
#################
## sign
#################
import Base.sign
function sign(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sign.(gf.y))
end

#################
## signbit
#################
import Base.signbit
function signbit(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, signbit.(gf.y))
end

#################
## sqrt
#################
import Base.sqrt
function sqrt(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, sqrt.(gf.y))
end

#################
## cbrt
#################
import Base.cbrt
function cbrt(gf::grid_functions.GridFunction{T, S}) where {T, S}
    return grid_functions.GridFunction(gf.x, cbrt.(gf.y))
end


end # end of module
