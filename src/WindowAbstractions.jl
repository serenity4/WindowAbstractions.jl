module WindowAbstractions

using BitMasks: @bitmask, enabled_flags
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
        EventType,
        is_key_event, is_button_event, is_pointer_event, is_window_event,
        KEY_PRESSED,
        KEY_RELEASED,
        BUTTON_PRESSED,
        BUTTON_RELEASED,
        POINTER_ENTERED,
        POINTER_MOVED,
        POINTER_EXITED,
        WINDOW_GAINED_FOCUS,
        WINDOW_LOST_FOCUS,
        WINDOW_RESIZED,
        WINDOW_EXPOSED,
        WINDOW_CLOSED,
        WINDOW_INVALID,
        EventQueue,

        # Keyboard
        ModifierState,
        enabled_flags,
        NO_MODIFIERS,
        SHIFT_MODIFIER,
        LOCK_MOIDIFER,
        CTRL_MODIFIER,
        MOD1_MODIFIER,
        MOD2_MODIFIER,
        MOD3_MODIFIER,
        MOD4_MODIFIER,
        MOD5_MODIFIER,
        KeyCombination,
        KeySymbol,
        key_symbol,
        is_key_defined,

        # Mouse
        MouseButton,
        BUTTON_NONE,
        BUTTON_LEFT,
        BUTTON_MIDDLE,
        BUTTON_RIGHT,
        BUTTON_SCROLL_UP,
        BUTTON_SCROLL_DOWN,

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
