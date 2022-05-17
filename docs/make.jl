using ScalarWave
using Documenter

DocMeta.setdocmeta!(ScalarWave, :DocTestSetup, :(using ScalarWave); recursive=true)

makedocs(;
    modules=[ScalarWave],
    authors="Stamatis Vretinaris",
    repo="https://github.com/svretina/ScalarWave.jl/blob/{commit}{path}#{line}",
    sitename="ScalarWave.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://svretina.github.io/ScalarWave.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/svretina/ScalarWave.jl",
    devbranch="master",
)
