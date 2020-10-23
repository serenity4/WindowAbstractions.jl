"""
Abstract Window type.
"""
abstract type AbstractWindow end

"""
Device used for sending inputs to an AbstractWindow.
"""
abstract type InputDevice end

abstract type Keyboard <: InputDevice end
abstract type Mouse <: InputDevice end

"Provide information about key modifier state (shift, control, alt and the OS key)."
@with_kw struct KeyModifierState
    shift::Bool = 0
    ctrl::Bool = 0
    alt::Bool = 0
    super::Bool = 0
end

"Key binding associated to a character and a key modifier."
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

abstract type KeyAction end

struct KeyReleased <: KeyAction end
struct KeyPressed <: KeyAction end

abstract type EventData end

struct KeyEvent <: EventData
    kc::KeyCombination
    action::KeyAction
end

"""
Store mouse input events, including clicking buttons and scrolling.
"""
@with_kw struct MouseEvent <: EventData
    left::Bool = false
    middle::Bool = false
    right::Bool = false
    scroll_up::Bool = false
    scroll_down::Bool = false
    any::Bool = false
end

struct Event{T <: EventData, F <: AbstractFloat}
    data::T
    location::Point2{Int}
    time::F
end

struct Drag
    src::MouseEvent
    dst::MouseEvent
end

struct InDrag
    src::MouseEvent
end