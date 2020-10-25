"""
Entity that manages windows.
"""
abstract type AbstractWindowHandler end

"""
Abstract window type.
"""
abstract type AbstractWindow end

"Provide information about key modifier state (shift, control, alt and the OS key)."
@with_kw struct KeyModifierState
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

abstract type EventData end

struct KeyEvent{A <: KeyAction} <: EventData
    kc::KeyCombination
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
@with_kw struct MouseState
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
    new_dimensions::Point2{Int}
end

struct ExposeEvent <: EventData
    exposed_dimensions::Point2{Int}
    count::Int
end

struct PointerMovesEvent <: EventData end
struct PointerLeavesWindowEvent <: EventData end
struct PointerEntersWindowEvent <: EventData end

"""
Generic event structure holding data as an `EventData` member.
"""
struct EventDetails{T <: EventData, W <: AbstractWindow, F <: AbstractFloat, WH <: AbstractWindowHandler}
    data::T
    location::Point2{Int}
    time::F
    window_symbol::Symbol
    window::W
    window_handler::WH
end

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
Event loop attached to a window handler, executing callbacks upon looping and/or receiving window events.

Typically, real-time render operations should be registered as callbacks in either of `on_iter_first` or `on_iter_last`.
"""
Base.@kwdef mutable struct EventLoop{W <: AbstractWindowHandler}
    """
    Window handler with which to handle window events.
    """
    window_handler::W
    """
    Set of callbacks for each window, designated by the same symbol that is used for the `window_handler`. See [`get_window_symbol`](@ref).
    """
    callbacks::Dict{Symbol, WindowCallbacks}
    """
    First action executed inside the loop, before polling for window events.
    """
    on_iter_first::Function = () -> nothing
    """
    Last action executed inside the loop, after polling and processing of window events.
    """
    on_iter_last::Function = () -> nothing
end

"""
Abstract execution mode. Is only used for controlling [`EventLoop`](@ref) execution at the moment.
"""
abstract type ExecutionMode end

struct Asynchronous <: ExecutionMode end
struct Synchronous <: ExecutionMode end