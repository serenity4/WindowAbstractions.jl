KeyCombination(key::KeySymbol, modifiers::ModifierState) = KeyCombination(key.symbol, modifiers)

function KeyCombination(key_combination::AbstractString)
    els = split(key_combination, "+")
    key_symbol = Symbol(last(els))
    exact_modifiers = reduce((x, y) -> x | ModifierState(Symbol(y)), @view els[1:end-1]; init = zero(ModifierState))
    KeyCombination(Symbol(key_symbol), exact_modifiers)
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
The string must be a list of elements separated by '+' characters, with only one key symbol at the end. For example, `"k"`, `"alt+k"` and `"ctrl+alt+shift+f11"` are valid strings, but `"k+a"` is not. Casing is significant, as `z` and `Z` are different key symbols. For modifier strings, the casing should be lowercase, or will be forcefully converted into a lowercase string (reducing performance).
"""
macro key_str(expr) esc(:(KeyCombination($(Meta.parse("\"$(escape_string(expr))\""))))) end
