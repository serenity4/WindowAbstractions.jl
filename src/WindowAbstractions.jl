module WindowAbstractions

using BitMasks: @bitmask, enabled_flags
export enabled_flags

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


include("utils.jl")
include("keys.jl")
include("inputs.jl")
include("window.jl")
include("window_manager.jl")
include("events.jl")
include("event_queue.jl")

export
        # Windows
        AbstractWindow,
        AbstractWindowManager,
        current_screen,

        # Event types
        Event,
        KeyEvent,
        MouseEvent,
        PointerState,

        # Event queue
        EventQueue,
        collect_events!,

        # Keyboard
        KeyCombination,
        KeySymbol,
        key_symbol,
        is_key_defined,
        matches,

        # Windowing API functions
        extent,
        dpi,
        resize,
        map_window,
        unmap_window,
        set_title,
        set_icon,
        set_icon_title,
        poll_for_events!,
        windows,
        get_window,

        # Macros
        @key_str

end
