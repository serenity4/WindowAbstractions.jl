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
    "The window was resized."
    WINDOW_RESIZED      = 0x0400
    """
    A window was exposed to the screen; either right after creation, or when it was previously hidden and then visible again.
    """
    WINDOW_EXPOSED      = 0x0800
    """
    The window was closed, e.g. manually by the user or by a programmatic action.
    """
    WINDOW_CLOSED       = 0x1000
    """
    The window is detected as invalid (for example, when closed externally).

    The conditions for tagging a window as invalid depend on the windowing API used. It is typically used to signal that a window crashed or does not exist, but for which an event was reported. It may however not possible to know exactly why or when a window becomes invalid. For example, the X11 protocol does not offer a way to check for window validity, since the window may get invalidated by the time the X server answer comes back.
    Windows that are tagged invalid should be terminated.
    """
    WINDOW_INVALID      = 0x2000

    KEY_EVENT = KEY_PRESSED | KEY_RELEASED
    BUTTON_EVENT = BUTTON_PRESSED | BUTTON_RELEASED
    POINTER_EVENT = POINTER_ENTERED | POINTER_MOVED | POINTER_EXITED
    WINDOW_EVENT = WINDOW_GAINED_FOCUS | WINDOW_LOST_FOCUS | WINDOW_RESIZED | WINDOW_EXPOSED | WINDOW_CLOSED | WINDOW_INVALID
end

"""
Generic event structure identified by its type (see [`EventType`](@ref)) and which may hold data depending on the type of event.

The type of `data` follows the association (with respect to the event type):
- `KEY_PRESSED` or `KEY_RELEASED`: [`KeyEvent`](@ref), accessible with `event.key_event`
- `BUTTON_PRESSED` or `BUTTON_RELEASED`: [`MouseEvent`](@ref), accessible with `event.mouse_event`
- `POINTER_MOVED`: [`PointerState`](@ref), accessible with `event.pointer_state`
- `WINDOW_RESIZED`: `Tuple{Float64,Float64}` # new dimensions, accessible with `event.new_dimensions`
- `WINDOW_EXPOSED`: `Tuple{Float64,Float64}` # area to redraw, accessible with `event.area`
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
