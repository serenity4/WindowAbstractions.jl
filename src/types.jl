"""
Entity that manages windows.
"""
abstract type AbstractWindowHandler end

"""
Abstract Window type.
"""
abstract type AbstractWindow end

"Provide information about key modifier state (shift, control, alt and the OS key)."
@with_kw struct KeyModifierState
    shift::Bool = 0
    ctrl::Bool = 0
    alt::Bool = 0
    super::Bool = 0
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

abstract type WindowException <: Exception end

"""
Signals that the window must be closed.
"""
struct CloseWindow <: WindowException
    handler::AbstractWindowHandler
    window::AbstractWindow
    msg::AbstractString
end

struct InvalidWindow <: WindowException
    handler::AbstractWindowHandler
    window::AbstractWindow
    msg::AbstractString
end

Base.@kwdef struct WindowCallbacks
    on_close::Function                 = e::CloseWindow -> default_on_close(e)
    on_invalid::Function               = e::InvalidWindow -> default_on_invalid(e)
    on_resize::Function                = event::EventDetails -> nothing
    on_mouse_button_pressed::Function  = event::EventDetails -> nothing
    on_mouse_button_released::Function = event::EventDetails -> nothing
    on_pointer_move::Function          = event::EventDetails -> nothing
    on_pointer_enter::Function         = event::EventDetails -> nothing
    on_pointer_leave::Function         = event::EventDetails -> nothing
    on_key_pressed::Function           = event::EventDetails -> nothing
    on_key_released::Function          = event::EventDetails -> nothing
    on_expose::Function                = event::EventDetails -> nothing
end

Base.@kwdef mutable struct EventLoop{W <: AbstractWindowHandler}
    window_handler::W
    callbacks::Dict{Symbol, WindowCallbacks}
    on_iter_first::Function = () -> nothing
    on_iter_last::Function = () -> nothing
end

abstract type ExecutionMode end

struct Asynchronous <: ExecutionMode end
struct Synchronous <: ExecutionMode end