module WindowAbstractions

using Parameters
using GeometryBasics
using Dates

include("utils.jl")
include("types.jl")
include("exceptions.jl")
include("inputs.jl")
include("window.jl")
include("events.jl")

export AbstractWindow,
       InvalidWindow,
       CloseWindow,
       extent,
       dpi,
       set_extent,
       on_close,
       on_invalid,
       terminate,
       map_window,
       unmap_window,
       set_title,
       set_icon,
       set_icon_title,
       attach_graphics_context
end
