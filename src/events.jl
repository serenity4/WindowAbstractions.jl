@enum EventType::UInt32 begin
    KEY_PRESSED  = 0x10000001
    KEY_RELEASED = 0x10000002

    BUTTON_PRESSED  = 0x20000001
    BUTTON_RELEASED = 0x20000002

    POINTER_ENTERED = 0x30000001
    POINTER_MOVED   = 0x30000002
    POINTER_EXITED  = 0x30000003

    WINDOW_GAINED_FOCUS = 0x40000001
    WINDOW_LOST_FOCUS   = 0x40000002
    WINDOW_RESIZED      = 0x40000003
    WINDOW_EXPOSED      = 0x40000004
    WINDOW_CLOSED       = 0x40000005
    WINDOW_INVALID      = 0x40000006
end

has_flags(event::EventType, i) = (UInt32(event) >> 28) == i

is_key_event(event::EventType) = has_flags(event, 1)
is_button_event(event::EventType) = has_flags(event, 2)
is_pointer_event(event::EventType) = has_flags(event, 3)
is_window_event(event::EventType) = has_flags(event, 4)

"""
A key was pressed. Note that some key combinations can be reserved by the OS, so they don't trigger the corresponding event. On Ubuntu 20.04, this is for example the case with some combinations of the form alt+fkey such as alt+f4.
"""
KEY_PRESSED
"""
A key was released.
"""
KEY_RELEASED
"A mouse button was released."
BUTTON_PRESSED
"The pointer entered the window area."
BUTTON_RELEASED
"A mouse button was pressed."
POINTER_ENTERED
"The pointer moves in the window."
POINTER_MOVED
"The pointer left the window area."
POINTER_EXITED
"The window gained focus."
WINDOW_GAINED_FOCUS
"The window lost focus."
WINDOW_LOST_FOCUS
"The window was resized."
WINDOW_RESIZED
"""
A window was exposed to the screen; either right after creation, or when it was previously hidden and then visible again.
"""
WINDOW_EXPOSED
"""
The window is closing normally upon raising an exception of type [`CloseWindow`](@ref).
"""
WINDOW_CLOSED
"""
The window is detected as invalid (for example, when closed externally).

The conditions for tagging a window as invalid depend on the windowing API used. It is typically used to signal that a window crashed or does not exist, but for which an event was reported. It may however not possible to know exactly why or when a window becomes invalid. For example, the X11 protocol does not offer a way to check for window validity, since the window may get invalidated by the time the X server answer comes back.
Windows that are tagged invalid should be terminated.
"""
WINDOW_INVALID

"""
Generic event structure identified by its type (see [`EventType`](@ref)) and which may hold data depending on the type of event.

The type of `data` follows the association (with respect to the event type):
- `KEY_PRESSED` or `KEY_RELEASED`: [`KeyEvent`](@ref)
- `BUTTON_PRESSED` or `BUTTON_RELEASED`: [`MouseEvent`](@ref)
- `POINTER_MOVED`: [`PointerState`](@ref)
- `WINDOW_RESIZED`: `Tuple{Float64,Float64}` # new dimensions
- `WINDOW_EXPOSED`: `Tuple{Float64,Float64}` # area to redraw
- Other event types: `Nothing`

"""
struct Event{W <: AbstractWindow}
    type::EventType
    data::Any
    location::Tuple{Float64,Float64}
    time::Float64
    win::W
end

function Base.getproperty(event::Event, name::Symbol)
    name === :key_event && return event.data::KeyEvent
    name === :mouse_event && return event.data::MouseEvent
    name === :pointer_state && return event.data::PointerState
    name === :new_dimensions && return event.data::Tuple{Int64,Int64}
    name === :area && return event.data::Tuple{Float64,Float64}
    getfield(event, name)
end

is_key_event(event::Event) = is_key_event(event.type)
is_button_event(event::Event) = is_button_event(event.type)
is_pointer_event(event::Event) = is_pointer_event(event.type)
is_window_event(event::Event) = is_window_event(event.type)

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
end

struct MouseEvent
    button::MouseButton
    state::MouseButton
end

struct PointerState
    state::MouseButton
    modifiers::ModifierState
end
