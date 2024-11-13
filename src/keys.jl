"""
Representation of a symbol that may be bound to a key, depending on a keyboard layout.
It differs from the physical representation of a key, denoted by names such as `AD01` which represent physical keys (in this case, `q` on a US keyboard).
A key symbol is sent when a physical key is pressed, even if no input character is bound to the key.
This structure provides a friendly `symbol` field, and a prettier `description` field (mostly used for printing).
For example, the right arrow, with symbol `:right_arrow` (resp. `:kp_right_arrow` for keypad input), is represented by `"→"` (resp. `"→ (keypad)"`).

There is no consistent representation, so the one provided here may differ from windowing API implementations.
"""
struct KeySymbol
    name::Symbol
    description::Union{Char, String}
    function KeySymbol(name::Symbol, description = nothing)
        description = get(key_descriptions, name, description)
        description = @something description begin
            str = String(name)
            length(str) ≠ 5 ? length(str) == 1 ? str[1] : str : begin
                m = match(r"u([\da-f]{4})", lowercase(str))
                isnothing(m) ? str : Char(parse(UInt32, "0x$(m[1])"))
            end
        end
        new(name, description)
    end
end

Base.:(==)(x::KeySymbol, y::KeySymbol) = x.name == y.name
Base.hash(x::KeySymbol, h::UInt) = hash(x.name, hash(KeySymbol, h))

Base.Symbol(key::KeySymbol) = key.name

const key_descriptions = Dict(
    :shift_right     => "Shift (right)",
    :shift_left      => "Shift (left)",
    :control_right   => "Control (right)",
    :control_left    => "Control (left)",
    :alt_left        => "Alt (left)",
    :alt_gr          => "Alt (Graph)",
    :backspace       => "Backspace",
    :enter           => "Enter",
    :insert          => "Insert",
    :delete          => "Delete",
    :home            => "Home",
    :end             => "End",
    :next            => "Next",
    :prior           => "Prior",
    :tab             => "Tab",
    :num_lock        => "NumLock",
    :up              => '↑',
    :down            => '↓',
    :left            => '←',
    :right           => '→',
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
)

"""
Define an internal representation and a readable description for some key inputs.

The keys that are listed here are not exhaustive and only cover a very small subset of all possible keys.
"""
key_symbol(name::Symbol) = _keys[name]
key_symbol(name::AbstractString) = key_symbol(Symbol(name))

function Base.show(io::IO, key::KeySymbol)
    print(io, KeySymbol, '(', repr(key.name))
    string(key.name) ≠ string(key.description) && print(io, ", ", repr(key.description))
    print(io, ')')
end

@bitmask exported = true ModifierState::UInt8 begin
    NO_MODIFIERS = 0
    SHIFT_MODIFIER = 1
    LOCK_MODIFIER = 2
    CTRL_MODIFIER = 4
    MOD1_MODIFIER = 8
    MOD2_MODIFIER = 16
    MOD3_MODIFIER = 32
    MOD4_MODIFIER = 64
    MOD5_MODIFIER = 128
end

const modifier_names_short = Dict(
    :shift => SHIFT_MODIFIER,
    :caps_lock => LOCK_MODIFIER,
    :ctrl => CTRL_MODIFIER,
    :alt => MOD1_MODIFIER,
    :num_lock => MOD2_MODIFIER,
    :super => MOD3_MODIFIER,
    :super_right => MOD3_MODIFIER,
    :super_left => MOD4_MODIFIER,
    :alt_gr => MOD5_MODIFIER,
)

function ModifierState(name::Symbol)
    ret = @something(get(modifier_names_short, name, nothing), get(modifier_names_short, Symbol(lowercase(String(name))), Some(nothing)))
    isnothing(ret) && throw(ArgumentError("Name `$name` is not a known modifier name."))
    ret
end

function ModifierState(key::KeySymbol)
    (; name) = key
    in(name, (:shift_left, :shift_right)) && return SHIFT_MODIFIER
    name == :caps_lock && return LOCK_MODIFIER
    in(name, (:control_left, :control_right)) && return CTRL_MODIFIER
    name == :alt_left && return MOD1_MODIFIER
    name == :num_lock && return MOD2_MODIFIER
    name == :super_right && return MOD3_MODIFIER
    name == :super_l && return MOD4_MODIFIER
    name == :alt_gr && return MOD5_MODIFIER
    NO_MODIFIERS
end

"Key binding associated to a character and a key modifier state."
@struct_hash_equal struct KeyCombination
    key::KeySymbol
    exact_modifiers::ModifierState
    significant_modifiers::ModifierState
    KeyCombination(key::KeySymbol, exact_modifiers = NO_MODIFIERS, significant_modifiers = SHIFT_MODIFIER | CTRL_MODIFIER | MOD1_MODIFIER) = new(key, exact_modifiers, significant_modifiers)
end
KeyCombination(key, exact_modifiers = NO_MODIFIERS, significant_modifiers = SHIFT_MODIFIER | CTRL_MODIFIER | MOD1_MODIFIER) = KeyCombination(KeySymbol(key), exact_modifiers, significant_modifiers)

function matches(kc::KeyCombination, key::KeySymbol, active_modifiers::ModifierState, consumed_modifiers::ModifierState)
    kc.key == key && kc.exact_modifiers == (active_modifiers & ~consumed_modifiers) & kc.significant_modifiers
end
