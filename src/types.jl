"""
Entity that manages windows.
"""
abstract type AbstractWindowHandler end

"""
Abstract window type.
"""
abstract type AbstractWindow end

"Provide information about key modifier state (shift, control, alt and the OS key)."
@with_kw_noshow struct KeyModifierState
    shift::Bool = false
    ctrl::Bool = false
    alt::Bool = false
    super::Bool = false
end

"Key binding associated to a character and a key modifier state."
struct KeyCombination
    key::AbstractString
    state::KeyModifierState
    KeyCombination(key, state) = new(key ∈ keys(fkeys) ? fkeys[key] : string(key), state)
end

"State of the keyboard, with regards to numlock and caps states."
struct KeyContext
    numlock::Bool
    caps::Bool
end

abstract type Event end
abstract type KeyAction <: Event end
abstract type MouseAction <: Event end
abstract type PointerEvent <: Event end

struct KeyReleased <: KeyAction end
struct KeyPressed <: KeyAction end

struct ButtonReleased <: MouseAction end
struct ButtonPressed <: MouseAction end
struct WindowHasFocus <: Event end
struct PointerEntersWindow <: PointerEvent end
struct PointerMoves <: PointerEvent end
struct PointerLeavesWindow <: PointerEvent end
struct Resize <: Event end
struct Expose <: Event end

abstract type EventData end

"""
Representation of a symbol that may be bound to a key, depending on a keyboard layout.
It differs from the physical representation of a key, denoted by names such as `AD01` which represent physical keys (in this case, `q` on a US keyboard).
A key symbol is sent when a physical key is pressed, even if no input character is bound to the key.
This structure provides a friendly `symbol` field, and a prettier `repr` field (mostly used for printing).
For example, the right arrow, with symbol `:right_arrow` (resp. `:kp_right_arrow` for keypad input), is represented by `"→"` (resp. `"→ (keypad)"`).

There is no consistent representation, so the one provided here may differ from windowing API implementations.
"""
struct KeySymbol
    symbol::Symbol
    repr::String
end

KeySymbol(symbol::Symbol) = is_key_symbol_defined(symbol) ? key_symbol(symbol) : KeySymbol(symbol, string(symbol))

struct KeyEvent{A <: KeyAction} <: EventData
    key_name::Symbol
    key::KeySymbol
    input::Char
    modifiers::KeyModifierState
    action::A
end

abstract type MouseButton end
struct ButtonLeft <: MouseButton end
struct ButtonMiddle <: MouseButton end
struct ButtonRight <: MouseButton end
struct ButtonScrollUp <: MouseButton end
struct ButtonScrollDown <: MouseButton end

"""
Store mouse input events, including clicking buttons and scrolling.
"""
@with_kw_noshow struct MouseState
    left::Bool = false
    middle::Bool = false
    right::Bool = false
    scroll_up::Bool = false
    scroll_down::Bool = false
    any::Bool = false
end

struct MouseEvent{A <: MouseAction, B <: MouseButton} <: EventData
    button::B
    state::MouseState
    action::A
end

struct ResizeEvent <: EventData
    new_dimensions::Tuple{Int,Int}
end

struct ExposeEvent <: EventData
    exposed_dimensions::Tuple{Int,Int}
    count::Int
end

struct PointerMovesEvent <: EventData end
struct PointerLeavesWindowEvent <: EventData end
struct PointerEntersWindowEvent <: EventData end

action(::PointerMovesEvent) = PointerMoves()
action(::PointerLeavesWindowEvent) = PointerLeavesWindow()
action(::PointerEntersWindowEvent) = PointerEntersWindow()
action(::ExposeEvent) = Expose()
action(::ResizeEvent) = Resize()
action(data::EventData) = data.action

"""
Generic event structure holding data as an `EventData` member.
"""
struct EventDetails{T <: EventData, W <: AbstractWindow, F <: AbstractFloat, WH <: AbstractWindowHandler}
    data::T
    location::Tuple{Int,Int}
    time::F
    window::W
    window_handler::WH
end

action(event::EventDetails) = action(event.data)

struct Drag
    src::MouseEvent
    dst::MouseEvent
end

struct InDrag
    src::MouseEvent
end

"""
Exception attached to a specific [`AbstractWindow`](@ref) instance.
"""
abstract type WindowException <: Exception end

"""
Signals that the window must be closed.
"""
struct CloseWindow <: WindowException
    handler::AbstractWindowHandler
    window::AbstractWindow
    msg::AbstractString
end

"""
Exception to be raised when a window is deemed invalid.
The conditions for tagging a window as invalid depend on the windowing API used. It is typically used to signal that a window crashed or does not exist, but for which an event was reported. It may however not possible to know exactly why or when a window becomes invalid. For example, the X11 protocol does not offer a way to check for window validity, since the window may get invalidated by the time the X server answer comes back.
Windows that are tagged invalid should be terminated.
"""
struct InvalidWindow <: WindowException
    handler::AbstractWindowHandler
    window::AbstractWindow
    msg::AbstractString
end

"""
Set of common window callbacks, in response to specific window events.

The callbacks `on_close` and `on_invalid` take respectively a [`CloseWindow`](@ref) and an [`InvalidWindow`](@ref) as argument, while other callbacks take an [`EventDetails`](@ref) as argument parametrized according to the event.

Each field documents when and in which context the callback may be called.
"""
Base.@kwdef struct WindowCallbacks
    """
    The window is closing normally upon raising an exception of type [`CloseWindow`](@ref).
    """
    on_close::Function                 = default_on_close
    """
    The window is detected as invalid (for example, when closed externally) through an exception of type [`InvalidWindow`](@ref).
    """
    on_invalid::Function               = default_on_invalid
    """
    The window was resized.
    """
    on_resize::Function                = event::EventDetails -> nothing
    """
    A mouse button was pressed.
    """
    on_mouse_button_pressed::Function  = event::EventDetails -> nothing
    """
    A mouse button was released.
    """
    on_mouse_button_released::Function = event::EventDetails -> nothing
    """
    The pointer moves in the window.
    """
    on_pointer_move::Function          = event::EventDetails -> nothing
    """
    The pointer enters the window area.
    """
    on_pointer_enter::Function         = event::EventDetails -> nothing
    """
    The pointer leaves the window area.
    """
    on_pointer_leave::Function         = event::EventDetails -> nothing
    """
    A key was pressed. Note that some key combinations can be reserved by the OS, so they don't trigger the corresponding event. On Ubuntu 20.04, this is for example the case with some combinations of the form alt+fkey such as alt+f4.
    """
    on_key_pressed::Function           = event::EventDetails -> nothing
    """
    A key was released.
    """
    on_key_released::Function          = event::EventDetails -> nothing
    """
    A window was exposed to the screen; either right after creation, or when it was previously hidden and then visible again.
    """
    on_expose::Function                = event::EventDetails -> nothing
end

"""
Abstract execution mode. Is only used for controlling [`EventLoop`](@ref) execution at the moment.
"""
abstract type ExecutionMode end

struct Asynchronous <: ExecutionMode end
struct Synchronous <: ExecutionMode end
