include("ScalarWave.jl")

import .ScalarWave

d = ScalarWave.domains.Domain([0,1])
ncells = 10
npoints = ncells + 1
coords = ScalarWave.utils.discretize(d.dmin, d.dmax, ncells)
spacing = ScalarWave.utils.spacing(d, ncells)
println(d)
println(typeof(d))
g = ScalarWave.grids.Grid(d, ncells, npoints, coords, spacing)
