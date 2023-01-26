"Provide information about key modifier state (shift, control, alt and the OS key)."
Base.@kwdef struct KeyModifierState
    shift::Bool = false
    ctrl::Bool = false
    alt::Bool = false
    super::Bool = false
end

"Key binding associated to a character and a key modifier state."
struct KeyCombination
    key::String
    state::KeyModifierState
    KeyCombination(key, state) = new(key ∈ keys(fkeys) ? fkeys[key] : string(key), state)
end

"State of the keyboard, with regards to numlock and caps states."
struct KeyContext
    numlock::Bool
    caps::Bool
end

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

const _keys = Dict((k => KeySymbol(k, v) for (k, v) ∈ [
            :shift_right     => "Shift (right)",
            :shift_left      => "Shift (left)",
            :control_right   => "Control (right)",
            :control_left    => "Control (left)",
            :alt_left        => "Alt (left)",
            :alt_gr          => "Alt (Graph)",
            :less            => "<",
            :greater         => ">",
            :twosuperior     => "²",
            :ampersand       => "&",
            :eacute          => "é",
            :quotedbl        => "\"",
            :apostrophe      => "\'",
            :minus           => "-",
            :egrave          => "è",
            :underscore      => "_",
            :ccedilla        => "ç",
            :agrave          => "à",
            :parenleft       => "(",
            :parenright      => ")",
            :equal           => "=",
            :notsign         => "¬",
            :onesuperior     => "¹",
            :asciitilde      => "~",
            :numbersign      => "#",
            :braceleft       => "{",
            :bracketleft     => "[",
            :bar             => "|",
            :grave           => "`",
            :backslash       => "\\",
            :asciicircum     => "^",
            :at              => "@",
            :bracketright    => "]",
            :braceright      => "}",
            :backspace       => "Backspace",
            :enter           => "Enter",
            :insert          => "Insert",
            :delete          => "Delete",
            :home            => "Home",
            :end             => "End",
            :next            => "Next",
            :prior           => "Prior",
            :num_lock        => "NumLock",
            :up              => "↑",
            :down            => "↓",
            :left            => "←",
            :right           => "→",
            :kp_1            => "1 (keypad)",
            :kp_2            => "2 (keypad)",
            :kp_3            => "3 (keypad)",
            :kp_4            => "4 (keypad)",
            :kp_5            => "5 (keypad)",
            :kp_6            => "6 (keypad)",
            :kp_7            => "7 (keypad)",
            :kp_8            => "8 (keypad)",
            :kp_9            => "9 (keypad)",
            :kp_0            => "0 (keypad)",
            :kp_divide       => "/ (keypad)",
            :kp_subtract     => "- (keypad)",
            :kp_multiply     => "* (keypad)",
            :kp_add          => "+ (keypad)",
            :kp_decimal      => ". (keypad)",
            :kp_enter        => "Enter (keypad)",
            :kp_insert       => "Insert (keypad)",
            :kp_delete       => "Delete (keypad)",
            :kp_home         => "Home (keypad)",
            :kp_end          => "End (keypad)",
            :kp_next         => "Next (keypad)",
            :kp_prior        => "Prior (keypad)",
            :kp_up           => "↑ (keypad)",
            :kp_down         => "↓ (keypad)",
            :kp_left         => "← (keypad)",
            :kp_right        => "→ (keypad)",
            :comma           => ",",
            :semicolon       => ";",
            :colon           => ":",
            :exclam          => "!",
            :question        => "?",
            :asterisk        => "*",
            :ugrave          => "ù",
            :dollar          => "\$",
            :dead_circumflex => "^",
            :dead_diaeresis  => "¨",
            :percent         => "%",
            :mu              => "μ",
            :period          => ".",
            :slash           => "/",
            :section         => "§",
            :degree          => "°",
            :plus            => "+",
            :currency        => "¤",
            :sterling        => "£",
            :eurosign        => "€",
]))

is_key_symbol_defined(key) = key ∈ keys(_keys)

"""
Define an internal representation and a readable description for some key inputs.

The keys that are listed here are not exhaustive and only cover a very small subset of all possible keys.
"""
key_symbol(name::Symbol) = _keys[name]
key_symbol(name::AbstractString) = key_symbol(Symbol(name))

Base.show(io::IO, key::KeySymbol) = print(io, key.symbol)
