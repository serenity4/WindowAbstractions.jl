using Documenter, WindowAbstractions

makedocs(;
    modules=[WindowAbstractions],
    format=Documenter.HTML(prettyurls = false),
    pages=[
        "Home" => "index.md",
        "API" => 
            "api.md"
        ,
    ],
    repo="https://github.com/serenity4/WindowAbstractions.jl/blob/{commit}{path}#L{line}",
    sitename="WindowAbstractions.jl",
    authors="serenity4 <cedric.bel@hotmail.fr>",
)

deploydocs(
    repo = "github.com/serenity4/WindowAbstractions.jl.git",
)