module WindowAbstractions

using Parameters
using GeometryBasics
using DocStringExtensions

@template (FUNCTIONS, METHODS, MACROS) =
    """
    $(DOCSTRING)
    $(TYPEDSIGNATURES)
    """

@template TYPES =
    """
    $(DOCSTRING)
    $(TYPEDEF)
    $(TYPEDSIGNATURES)
    $(TYPEDFIELDS)
    """


# using Dates

include("utils.jl")
include("types.jl")
include("exceptions.jl")
include("inputs.jl")
include("window.jl")
include("window_handler.jl")
include("events.jl")

export AbstractWindow,
       AbstractWindowHandler,
       InvalidWindow,
       CloseWindow,

       # Event types
       Event,
       EventData,
       KeyEvent,
       KeyAction,
       KeyPressed,
       KeyReleased,
       MouseEvent,
       MouseAction,
       ButtonPressed,
       ButtonReleased,
       PointerEvent,
       PointerMoves,
       PointerEntersWindow,
       PointerLeavesWindow,
       ResizeEvent,
       ExposeEvent,
       PointerEntersWindowEvent,
       PointerLeavesWindowEvent,
       PointerMovesEvent,

       # Keyboard
       KeyModifierState,
       KeyContext,
       KeyCombination,

       # Mouse
       MouseButton,
       ButtonLeft,
       ButtonMiddle,
       ButtonRight,
       ButtonScrollDown,
       ButtonScrollUp,
       MouseState,

       # Windowing API functions
       extent,
       dpi,
       set_extent,
       terminate_window!,
       map_window,
       unmap_window,
       set_title,
       set_icon,
       set_icon_title,
       attach_graphics_context!,
       wait_for_event,
       poll_for_event,
       get_window,
       get_window_symbol,
       pressed_buttons,

       # Events and callbacks
       WindowCallbacks,
       EventLoop,
       EventDetails,
       execute_callback,

       # Execution modes
       Synchronous,
       Asynchronous,

       # Macros
       @key_str

end
