abstract type AbstractWindow end

abstract type InputDevice end

struct Keyboard <: InputDevice end
struct Mouse <: InputDevice end