var documenterSearchIndex = {"docs":
[{"location":"input/#Input","page":"Input","title":"Input","text":"","category":"section"},{"location":"input/#Keyboard","page":"Input","title":"Keyboard","text":"","category":"section"},{"location":"input/","page":"Input","title":"Input","text":"A keystroke sends a signal corresponding to the physical key being pressed. This signal is then translated into a symbol by a windowing API. For example, if the key KP6 (6 on the keypad) is pressed, the symbol may correspond to kp_6 or kp_right depending on whether the num lock was on or off. Therefore, the translation of the key to a symbol depends on a state, referred to as keyboard state. It encodes whether shift, control, alt and super modes, also referred to as modifier state, are enabled, along with the num lock and caps lock among others.","category":"page"},{"location":"input/","page":"Input","title":"Input","text":"A symbol does not necessarily represent a printable character, particularly for keys not in the alphanumeric set. However, it is often desired to get a printable character from a keystroke as an input. For non-printable symbols, this input is simply the null character.","category":"page"},{"location":"input/","page":"Input","title":"Input","text":"The translation from physical keystroke to key symbol depends on the state of the keyboard, but also on its associated keymap. A keymap, as its name implies, partially defines a mapping from keystrokes to key symbols. It is separate from keyboard state, and can be described using a keyboard layout, along with country and language codes. Keymaps can be changed dynamically, for example with super + space on Ubuntu 20.10, usually to switch between languages.","category":"page"},{"location":"input/","page":"Input","title":"Input","text":"To summarize, a physical keystroke is converted to a key symbol using a keymap and knowing the keyboard state. It may be printable or not, in which case the corresponding input character is null.","category":"page"},{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"","category":"page"},{"location":"api/","page":"API","title":"API","text":"Modules = [WindowAbstractions]\nPrivate = true","category":"page"},{"location":"api/#Core.Type-Tuple{AbstractWindowManager}","page":"API","title":"Core.Type","text":"(::Type{<:AbstractWindow})(wm::AbstractWindowManager; kwargs...)\n\nCreate a window.\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.AbstractWindow","page":"API","title":"WindowAbstractions.AbstractWindow","text":"Abstract window type.\n\nabstract type AbstractWindow\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.AbstractWindowManager","page":"API","title":"WindowAbstractions.AbstractWindowManager","text":"Entity that manages windows.\n\nabstract type AbstractWindowManager\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.Callbacks","page":"API","title":"WindowAbstractions.Callbacks","text":"Abstract type for callback structures. Callback structures should possess function fields with names coherent with the corresponding callback type.\n\nabstract type Callbacks\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.CloseWindow","page":"API","title":"WindowAbstractions.CloseWindow","text":"Signals that the window must be closed.\n\nstruct CloseWindow <: WindowException\n\nwin::AbstractWindow\nmsg::String\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.EventDetails","page":"API","title":"WindowAbstractions.EventDetails","text":"Generic event structure holding data as an EventData member.\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.InvalidWindow","page":"API","title":"WindowAbstractions.InvalidWindow","text":"Exception to be raised when a window is deemed invalid. The conditions for tagging a window as invalid depend on the windowing API used. It is typically used to signal that a window crashed or does not exist, but for which an event was reported. It may however not possible to know exactly why or when a window becomes invalid. For example, the X11 protocol does not offer a way to check for window validity, since the window may get invalidated by the time the X server answer comes back. Windows that are tagged invalid should be terminated.\n\nstruct InvalidWindow <: WindowException\n\nwin::AbstractWindow\nmsg::String\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.KeyCombination","page":"API","title":"WindowAbstractions.KeyCombination","text":"Key binding associated to a character and a key modifier state.\n\nstruct KeyCombination\n\nkey::String\nstate::KeyModifierState\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.KeyContext","page":"API","title":"WindowAbstractions.KeyContext","text":"State of the keyboard, with regards to numlock and caps states.\n\nstruct KeyContext\n\nnumlock::Bool\ncaps::Bool\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.KeyEvent","page":"API","title":"WindowAbstractions.KeyEvent","text":"Event data regarding a keystroke.\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.KeyModifierState","page":"API","title":"WindowAbstractions.KeyModifierState","text":"Provide information about key modifier state (shift, control, alt and the OS key).\n\nstruct KeyModifierState\n\nshift::Bool\nctrl::Bool\nalt::Bool\nsuper::Bool\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.KeySymbol","page":"API","title":"WindowAbstractions.KeySymbol","text":"Representation of a symbol that may be bound to a key, depending on a keyboard layout. It differs from the physical representation of a key, denoted by names such as AD01 which represent physical keys (in this case, q on a US keyboard). A key symbol is sent when a physical key is pressed, even if no input character is bound to the key. This structure provides a friendly symbol field, and a prettier repr field (mostly used for printing). For example, the right arrow, with symbol :right_arrow (resp. :kp_right_arrow for keypad input), is represented by \"→\" (resp. \"→ (keypad)\").\n\nThere is no consistent representation, so the one provided here may differ from windowing API implementations.\n\nstruct KeySymbol\n\nsymbol::Symbol\nrepr::String\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.MouseState","page":"API","title":"WindowAbstractions.MouseState","text":"Store mouse input events, including clicking buttons and scrolling.\n\nstruct MouseState\n\nleft::Bool\nmiddle::Bool\nright::Bool\nscroll_up::Bool\nscroll_down::Bool\nany::Bool\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.WindowCallbacks","page":"API","title":"WindowAbstractions.WindowCallbacks","text":"Set of common window callbacks, in response to specific window events.\n\nThe callbacks on_close and on_invalid take respectively a CloseWindow and an InvalidWindow as argument, while other callbacks take an EventDetails as argument parametrized according to the event.\n\nEach field documents when and in which context the callback may be called.\n\nstruct WindowCallbacks <: Callbacks\n\non_close::Any\nThe window is closing normally upon raising an exception of type CloseWindow.\n\non_invalid::Any\nThe window is detected as invalid (for example, when closed externally) through an exception of type InvalidWindow.\n\non_resize::Any\nThe window was resized.\n\non_mouse_button_pressed::Any\nA mouse button was pressed.\n\non_mouse_button_released::Any\nA mouse button was released.\n\non_pointer_move::Any\nThe pointer moves in the window.\n\non_pointer_enter::Any\nThe pointer enters the window area.\n\non_pointer_leave::Any\nThe pointer leaves the window area.\n\non_key_pressed::Any\nA key was pressed. Note that some key combinations can be reserved by the OS, so they don't trigger the corresponding event. On Ubuntu 20.04, this is for example the case with some combinations of the form alt+fkey such as alt+f4.\n\non_key_released::Any\nA key was released.\n\non_expose::Any\nA window was exposed to the screen; either right after creation, or when it was previously hidden and then visible again.\n\n\n\n\n\n","category":"type"},{"location":"api/#WindowAbstractions.WindowException","page":"API","title":"WindowAbstractions.WindowException","text":"Exception attached to a specific AbstractWindow instance.\n\nabstract type WindowException <: Exception\n\n\n\n\n\n","category":"type"},{"location":"api/#Base.close-Tuple{AbstractWindowManager, AbstractWindow}","page":"API","title":"Base.close","text":"close(wm::AbstractWindowManager, win::AbstractWindow)\n\nClose a window.\n\nclose(wm::AbstractWindowManager, _::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.run-Tuple{AbstractWindowManager}","page":"API","title":"Base.run","text":"Run an event loop for the window manager wm which listens for events and processes them.\n\nIf sleep_time is non-zero, Base.sleep will be called between each round of polling (i.e. between successive tries that return no event).\n\nrun(wm::AbstractWindowManager; sleep_time)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.dpi-Tuple{AbstractWindow}","page":"API","title":"WindowAbstractions.dpi","text":"Get window DPI.\n\ndpi(win::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.extent-Tuple{AbstractWindow}","page":"API","title":"WindowAbstractions.extent","text":"Window dimensions (width, height).\n\nextent(win::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.key_symbol-Tuple{Symbol}","page":"API","title":"WindowAbstractions.key_symbol","text":"Define an internal representation and a readable description for some key inputs.\n\nThe keys that are listed here are not exhaustive and only cover a very small subset of all possible keys.\n\nkey_symbol(name::Symbol) -> KeySymbol\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.listen_for_events-Tuple{AbstractWindowManager}","page":"API","title":"WindowAbstractions.listen_for_events","text":"Run an event loop for the window manager wm which listens for events and processes them.\n\nIf sleep_time is non-zero, Base.sleep will be called between each round of polling (i.e. between successive tries that return no event).\n\nlisten_for_events(wm::AbstractWindowManager; sleep_time)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.map_window-Tuple{AbstractWindow}","page":"API","title":"WindowAbstractions.map_window","text":"Map a window to the screen.\n\nmap_window(win::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.poll_for_event-Tuple{AbstractWindowManager}","page":"API","title":"WindowAbstractions.poll_for_event","text":"Non-blocking poll for events. Should return an element of type Nothing if no events were caught.\n\npoll_for_event(wm::AbstractWindowManager)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.pressed_buttons-Tuple{MouseState}","page":"API","title":"WindowAbstractions.pressed_buttons","text":"Retrieve a list of pressed button symbols for the left, middle and right buttons from a MouseState.\n\npressed_buttons(input::MouseState) -> Set{Symbol}\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.process_event-Tuple{AbstractWindowManager, Any}","page":"API","title":"WindowAbstractions.process_event","text":"Process an event received by either poll_for_event or wait_for_event, modifying state (e.g. window, keymap) and/or returning an EventDetails instance.\n\nIf the returned value is not an EventDetails, then it must either be of type CloseWindow or InvalidWindow, or nothing.\n\nprocess_event(wm::AbstractWindowManager, event)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.set_extent-Tuple{AbstractWindow, Any}","page":"API","title":"WindowAbstractions.set_extent","text":"Resize the window with extent reflecting the new (width, height).\n\nset_extent(win::AbstractWindow, extent)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.set_icon-Tuple{AbstractWindow, Any}","page":"API","title":"WindowAbstractions.set_icon","text":"Set window icon.\n\nset_icon(win::AbstractWindow, icon)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.set_icon_title-Tuple{AbstractWindow, Any}","page":"API","title":"WindowAbstractions.set_icon_title","text":"Set window icon title.\n\nset_icon_title(win::AbstractWindow, icon_title)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.set_title-Tuple{AbstractWindow, Any}","page":"API","title":"WindowAbstractions.set_title","text":"Set window title.\n\nset_title(win::AbstractWindow, title)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.terminate_window!-Tuple{AbstractWindowManager, AbstractWindow}","page":"API","title":"WindowAbstractions.terminate_window!","text":"Clean up window state upon destruction. The window cannot be assumed to be mapped or to be valid.\n\nterminate_window!(wm::AbstractWindowManager, win::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.unmap_window-Tuple{AbstractWindow}","page":"API","title":"WindowAbstractions.unmap_window","text":"Unmap a window from the screen.\n\nunmap_window(win::AbstractWindow)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.wait_for_event-Tuple{AbstractWindowManager}","page":"API","title":"WindowAbstractions.wait_for_event","text":"Wait until the next event occurs.\n\nwait_for_event(wm::AbstractWindowManager)\n\n\n\n\n\n\n","category":"method"},{"location":"api/#WindowAbstractions.@key_str-Tuple{Any}","page":"API","title":"WindowAbstractions.@key_str","text":"Construct a KeyCombination instance from a string as \"[<state_1>+[...<state_n>+]]<key>\". The string must be a list of elements separated by '+' characters, with only one non-state character or one fkey as string. For example, \"k\", \"alt+k\" and \"ctrl+alt+shift+k\" are valid strings, but \"k+a\" is not. Casing is ignored. Fkeys are simply f<1-12> keys, for example key\"alt+f4\" is valid.\n\n\n\n\n\n","category":"macro"},{"location":"events/#Events","page":"Events","title":"Events","text":"","category":"section"},{"location":"events/","page":"Events","title":"Events","text":"Keystrokes, mouse buttons and pointer motions are associated to specific events, wrapped around an EventDetails that adds information regarding time, location and the window on which the event happened. For example, keystrokes are represented by KeyEvent structures, which contain all the details regarding the physical key that was pressed. These include the code of the physical key, the symbol it was translated to, the associated input character, the active modifiers and the action (whether the key was pressed or released).","category":"page"},{"location":"events/","page":"Events","title":"Events","text":"These events are configured per-window and tied to a WindowCallbacks structure. Note that implementations such as XCB.jl may not capture events on windows that do not implement the associated callbacks. For example, keystrokes may not be detected if the on_key_pressed and on_key_released fields of the WindowCallbacks structure are set to nothing.","category":"page"},{"location":"events/","page":"Events","title":"Events","text":"Events happen asynchronously, but the user has control over whether the program should listen to those synchronously or asynchronously. This is exposed via the run function of the AbstractWindowManager implementation, which must be invoked for events to start being processed.","category":"page"},{"location":"intro/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"Although window systems tend to be quite different from one another in their core API, they expose a common set of functionality. For example, setting the window title or size, and detecting input events (keyboard/mouse events) is something that can be done from any window API.","category":"page"},{"location":"intro/#Windowing-systems","page":"Introduction","title":"Windowing systems","text":"","category":"section"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"Some major windowing systems are described here:","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"X Window System: windowing system for Unix-like operating systems. The API is exposed through the X11 protocol, with the X11 and XCB libraries. A Julia wrapper is available for the XCB library.\nWayland: is meant to replace the X window system for Unix-like distributions in the future.\nDesktop Window Manager: windowing system for Windows.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"Many more exist, as can be seen on the Wikipedia page.","category":"page"},{"location":"#WindowAbstractions.jl","page":"Home","title":"WindowAbstractions.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Abstractions for windowing APIs. This library is intended for developers, and not for general use. It is currently only used by XCB.jl, but aims at being applicable for other windowing APIs (such as Windows and Wayland). Julia developers wrapping windowing APIs are encouraged to use and contribute to this library as much as possible.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"intro.md\", \"api.md\"]","category":"page"},{"location":"windows/#Windows","page":"Windows","title":"Windows","text":"","category":"section"},{"location":"windows/","page":"Windows","title":"Windows","text":"Windows, implemented via the AbstractWindow interface, are run within window managers, according to the AbstractWindowManager interface. Window managers manage all the information related to the execution of windows. They store callbacks, handle errors and run an event loop that listens to events on any of its windows. Typically, a program defines a single window manager, that manages one or several windows which can be created or closed at any given time. This window manager can be run synchronously, blocking all execution until events are received, or asynchronously, periodically polling for new events. Asynchronous execution may be done via the task system on the same thread, or on any other thread.","category":"page"}]
}
