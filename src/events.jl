"""
Type of input or window event which may occur on a particular window.

This type is defined as a bitmask, to make it easier to work with sets of events.
"""
@bitmask exported = true EventType::UInt32 begin
    "Signals an absence of event."
    NO_EVENT     = 0x00

    """
    A key was pressed. Note that some key combinations can be reserved by the OS, so they don't trigger the corresponding event. On Ubuntu 20.04, this is for example the case with some combinations of the form alt+fkey such as alt+f4.
    """
    KEY_PRESSED  = 0x01
    "A key was released."
    KEY_RELEASED = 0x02

    "A mouse button was released."
    BUTTON_PRESSED  = 0x08
    "The pointer entered the window area."
    BUTTON_RELEASED = 0x10

    "A mouse button was pressed."
    POINTER_ENTERED = 0x20
    "The pointer moves in the window."
    POINTER_MOVED   = 0x40
    "The pointer left the window area."
    POINTER_EXITED  = 0x80

    "The window gained focus."
    WINDOW_GAINED_FOCUS = 0x0100
    "The window lost focus."
    WINDOW_LOST_FOCUS   = 0x0200
    "The window moved."
    WINDOW_MOVED        = 0x0400
    "The window was resized (and may have had its origin moved)."
    WINDOW_RESIZED      = 0x0800
    """
    A window was exposed to the screen; either right after creation, or when it was previously hidden and then visible again.
    """
    WINDOW_EXPOSED      = 0x1000
    """
    The window was closed, e.g. manually by the user or by a programmatic action.
    """
    WINDOW_CLOSED       = 0x2000
    """
    The window is detected as invalid (for example, when closed externally).

    The conditions for tagging a window as invalid depend on the windowing API used. It is typically used to signal that a window crashed or does not exist, but for which an event was reported. It may however not possible to know exactly why or when a window becomes invalid. For example, the X11 protocol does not offer a way to check for window validity, since the window may get invalidated by the time the X server answer comes back.
    Windows that are tagged invalid should be terminated.
    """
    WINDOW_INVALID      = 0x4000

    KEY_EVENT = KEY_PRESSED | KEY_RELEASED
    BUTTON_EVENT = BUTTON_PRESSED | BUTTON_RELEASED
    POINTER_EVENT = POINTER_ENTERED | POINTER_MOVED | POINTER_EXITED
    WINDOW_EVENT = WINDOW_GAINED_FOCUS | WINDOW_LOST_FOCUS | WINDOW_MOVED | WINDOW_RESIZED | WINDOW_EXPOSED | WINDOW_CLOSED | WINDOW_INVALID

    ALL_EVENTS = KEY_EVENT | BUTTON_EVENT | POINTER_EVENT | WINDOW_EVENT
end

"""
Generic event structure identified by its type (see [`EventType`](@ref)) and which may hold data depending on the type of event.

The event may have the following properties, depending on its type:
- `.key_event::KeyEvent`                | `KEY_PRESSED` or `KEY_RELEASED`
- `.mouse_event::KeyEvent`              | `BUTTON_PRESSED` or `BUTTON_RELEASED`
- `.pointer_state::PointerState`        | `POINTER_MOVED`
- `.resize::Tuple{Int64,Int64}`         | `WINDOW_RESIZED`: indicates the difference in size with respect to the previous dimensions.
- `.movement::Tuple{Int64,Int64}`       | `WINDOW_RESIZED` or `WINDOW_MOVED`: indicates how much the window moved along the `x` and `y` directions.
- `.area::Tuple{Float64,Float64}`       | `WINDOW_EXPOSED`
"""
struct Event{W <: AbstractWindow}
    type::EventType
    data::Any
    location::Tuple{Float64,Float64}
    time::Float64
    window::W
end

function Base.getproperty(event::Event, name::Symbol)
    name === :key_event && return event.data::KeyEvent
    name === :mouse_event && return event.data::MouseEvent
    name === :pointer_state && return event.data::PointerState
    name === :resize && return (event.data::NTuple{4,Int64})[1:2]
    name === :movement && return (event.data::Union{NTuple{2,Int64},NTuple{4,Int64}})[(end-1):end]
    name === :area && return event.data::Tuple{Float64,Float64}
    getfield(event, name)
end

"""
Details surrounding an event produced by a keystroke.
"""
struct KeyEvent
    """
    The name of the physical key.
    """
    key_name::Symbol
    """
    The symbol associated with the keystroke.
    """
    key::KeySymbol
    """
    Printable input (can be the empty string).
    """
    input::Char
    """
    Modifier state.
    """
    modifiers::ModifierState
    """
    Modifiers that were used when translating the physical key into a key symbol.
    """
    consumed_modifiers::ModifierState
end
KeyEvent(key_name, key, input, modifiers = NO_MODIFIERS) = KeyEvent(key_name, key, input, modifiers, NO_MODIFIERS)

"A mouse press/release associated to a certain state."
struct MouseEvent
    button::MouseButton
    state::MouseButton
end

"Context in which a pointer motion was performed, including active mouse buttons and keyboard modifiers."
struct PointerState
    state::MouseButton
    modifiers::ModifierState
end

matches(kc::KeyCombination, event::KeyEvent) = matches(kc, event.key, event.modifiers, event.consumed_modifiers)
matches(kc::KeyCombination, event::Event) = event.type in KEY_EVENT && matches(kc, event.key_event)
matches(event::Union{KeyEvent,Event}) = Base.Fix2(matches, event)
