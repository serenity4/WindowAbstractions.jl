# Input

## Keyboard

A keystroke sends a signal corresponding to the physical key being pressed. This signal is then translated into a symbol by a windowing API. For example, if the key `KP6` (6 on the keypad) is pressed, the symbol may correspond to `kp_6` or `kp_right` depending on whether the num lock was on or off. Therefore, the translation of the key to a symbol depends on a state, referred to as keyboard state. It encodes whether shift, control, alt and super modes, also referred to as modifier state, are enabled, along with the num lock and caps lock among others.

A symbol does not necessarily represent a printable character, particularly for keys not in the alphanumeric set. However, it is often desired to get a printable character from a keystroke as an input. For non-printable symbols, this input is simply the null character.

The translation from physical keystroke to key symbol depends on the state of the keyboard, but also on its associated keymap. A keymap, as its name implies, partially defines a mapping from keystrokes to key symbols. It is separate from keyboard state, and can be described using a keyboard layout, along with country and language codes. Keymaps can be changed dynamically, for example with `super + space` on Ubuntu 20.10., usually to switch between languages.

To summarize, a physical keystroke is converted to a key symbol using a keymap and knowing the keyboard state. It may be printable or not, in which case the corresponding input character is null.
