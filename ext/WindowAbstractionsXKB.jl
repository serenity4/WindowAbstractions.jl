module WindowAbstractionsXKB

import WindowAbstractions: KeySymbol, EventType, KeyEvent, ModifierState, NO_MODIFIERS
import XKeyboard: print_key_info
using XKeyboard: Keymap, PhysicalKey, Keysym, xkb_state_key_get_consumed_mods

"Translate a few names so that they are more friendly."
const keysym_names_translation = Dict(
    :shift_r          => :shift_right,
    :shift_l          => :shift_left,
    :control_r        => :control_right,
    :control_l        => :control_left,
    :iso_level3_shift => :alt_gr,
    :alt_l            => :alt_left,
    :return           => :enter,
)

"""
Generate a `KeySymbol` from an XKB `Keysym`.
"""
function KeySymbol(keysym::Keysym)
  name = Symbol(lowercase(String(keysym)))
  KeySymbol(get(keysym_names_translation, name, name))
end

KeySymbol(km::Keymap, key::PhysicalKey) = KeySymbol(Keysym(km, key))

"""
Produce a key event based on a key name, a modifier state and an action using a keymap.
"""
function KeyEvent(km::Keymap, key::PhysicalKey, modifiers::ModifierState = NO_MODIFIERS)
    KeyEvent(Symbol(km, key), KeySymbol(km, key), Char(km, key), modifiers, consumed_modifiers(km, key))
end

consumed_modifiers(km::Keymap, key::PhysicalKey) = ModifierState(xkb_state_key_get_consumed_mods(km.state, key.code))

function print_key_info(io::IO, km::Keymap, event::KeyEvent)
  (; key_name, key, input) = event
  print_key_info(io, string(key_name), PhysicalKey(km, key_name).code, input, string(key))
end

end
