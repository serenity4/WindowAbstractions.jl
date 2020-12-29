using Documenter, WindowAbstractions

makedocs(;
    modules=[WindowAbstractions],
    format=Documenter.HTML(prettyurls = true),
    pages=[
        "Home" => "index.md",
        "Introduction" => "intro.md",
        "Input" => "input.md",
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
