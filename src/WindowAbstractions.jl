module WindowAbstractions

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
include("types.jl")
include("keys.jl")
include("exceptions.jl")
include("inputs.jl")
include("window.jl")
include("window_manager.jl")
include("events.jl")


export
        # Windows
        AbstractWindow,
        AbstractWindowManager,
        WindowException,
        InvalidWindow,
        CloseWindow,
        current_screen,

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
        Resize,
        ResizeEvent,
        Expose,
        ExposeEvent,
        PointerEntersWindowEvent,
        PointerLeavesWindowEvent,
        PointerMovesEvent,

        # Keyboard
        KeyModifierState,
        KeyContext,
        KeyCombination,
        no_input,
        KeySymbol,
        key_symbol,
        is_key_defined,

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
        EventDetails,
        action,
        Callbacks,
        WindowCallbacks,
        callback_symbol,
        execute_callback,

        # Execution modes
        ExecutionMode,
        Synchronous,
        Asynchronous,

        # Macros
        @key_str

end
