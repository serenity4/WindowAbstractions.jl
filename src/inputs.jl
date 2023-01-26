Base.show(io::IO, keyctx::KeyContext) = print(io, "num_lock=", keyctx.numlock, ", caps=", keyctx.caps)

KeyCombination(key::KeySymbol, modifiers::KeyModifierState) = KeyCombination(key.symbol, modifiers)

function KeyCombination(key_combination::AbstractString)
    els = split(lowercase(key_combination), "+")
    char_part = last(els)
    fkey = match(r"f\d+$", char_part)
    if !isnothing(fkey)
        char_part = fkey.match
    else
        @assert length(char_part) == 1 "Character part $char_part of $key_combination must be a single character"
    end
    modifiers = els[1:end-1]
    KeyCombination(char_part, KeyModifierState(; map(x -> (Symbol(x), true), modifiers)...))
end

const fkeys = Dict(
    '\uffbe' => "f1",
    '\uffbf' => "f2",
    '\uffc0' => "f3",
    '\uffc1' => "f4",
    '\uffc2' => "f5",
    '\uffc3' => "f6",
    '\uffc4' => "f7",
    '\uffc5' => "f8",
    '\uffc6' => "f9",
    '\uffc7' => "f10",
    '\uffc8' => "f11",
    '\uffc9' => "f12",
)

function Base.show(io::IO, key::KeyCombination)
    states = String[]
    for field ∈ reverse(fieldnames(KeyModifierState))
        getproperty(key.state, field) ? push!(states, string(field)) : nothing
    end
    push!(states, key.key)
    print(io, join(states, '+'))
end

@bitmask MouseButton::UInt32 begin
    BUTTON_NONE = 0
    BUTTON_LEFT = 1
    BUTTON_MIDDLE = 2
    BUTTON_RIGHT = 4
    BUTTON_SCROLL_UP = 8
    BUTTON_SCROLL_DOWN = 16
end

MouseButton() = zero(MouseButton)

"""
Construct a KeyCombination instance from a string as `"[<state_1>+[...<state_n>+]]<key>"`.
The string must be a list of elements separated by '+' characters, with only one non-state character or one fkey as string. For example, `"k"`, `"alt+k"` and `"ctrl+alt+shift+k"` are valid strings, but `"k+a"` is not. Casing is ignored. Fkeys are simply f<1-12> keys, for example `key"alt+f4"` is valid.
"""
macro key_str(expr) esc(:(KeyCombination($(Meta.parse("\"$(escape_string(expr))\""))))) end
