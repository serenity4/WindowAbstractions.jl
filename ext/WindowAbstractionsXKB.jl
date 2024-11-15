module WindowAbstractionsXKB

import WindowAbstractions: KeySymbol, EventType, KeyEvent, ModifierState, NO_MODIFIERS
import XKeyboard: print_key_info
using XKeyboard: Keymap, PhysicalKey, Keysym, xkb_state_key_get_consumed_mods2, LibXKB, XKB_CONSUMED_MODE_GTK

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
  str = String(keysym)
  name = length(str) == 1 ? Symbol(str[1]) : Symbol(lowercase(str))
  name = get(keysym_names_translation, name, name)
  char = Char(keysym)
  KeySymbol(name, ifelse(char ≠ '\0', char, nothing))
end

KeySymbol(km::Keymap, key::PhysicalKey) = KeySymbol(Keysym(km, key))
@static if LibXKB.xkbcommon_jll.is_available()
  # The dependency on XKB for this method isn't great, in the future
  # we could instead define our own mapping from characters to names.
  # On the other hand, using XKB makes sure that inputs and manually
  # constructed `KeySymbol`s have consistent names.
  KeySymbol(char::Char) = KeySymbol(Keysym(char))
end

"""
Produce a key event based on a key name, a modifier state and an action using a keymap.
"""
function KeyEvent(km::Keymap, key::PhysicalKey, modifiers::ModifierState = NO_MODIFIERS)
  KeyEvent(Symbol(km, key), KeySymbol(km, key), Char(km, key), modifiers, consumed_modifiers(km, key))
end

consumed_modifiers(km::Keymap, key::PhysicalKey) = ModifierState(xkb_state_key_get_consumed_mods2(km.state, key.code, XKB_CONSUMED_MODE_GTK))

function print_key_info(io::IO, km::Keymap, event::KeyEvent)
  (; key_name, key, input) = event
  print_key_info(io, string(key_name), PhysicalKey(km, key_name).code, input, string(key))
end

end
