using Consensus
using Documenter

DocMeta.setdocmeta!(Consensus, :DocTestSetup, :(using Consensus); recursive=true)

makedocs(;
    modules=[Consensus],
    authors="JingYu Ning <115336923+jrunkening@users.noreply.github.com> and contributors",
    repo="https://github.com/foldfelis-QO/Consensus.jl/blob/{commit}{path}#{line}",
    sitename="Consensus.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://foldfelis-QO.github.io/Consensus.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/foldfelis-QO/Consensus.jl",
    devbranch="main",
)
