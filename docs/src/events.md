# Events

Keystrokes, mouse buttons and pointer motions are associated to specific events, wrapped around an [`EventDetails`](@ref) that adds information regarding time, location and the window on which the event happened.
For example, keystrokes are represented by [`KeyEvent`](@ref) structures, which contain all the details regarding the physical key that was pressed. These include the code of the physical key, the symbol it was translated to, the associated input character, the active modifiers and the action (whether the key was pressed or released).

These events are configured per-window and tied to a [`WindowCallbacks`](@ref) structure. Note that implementations such as [XCB.jl](https://github.com/JuliaGL/XCB.jl) may not capture events on windows that do not implement the associated callbacks. For example, keystrokes may not be detected if the `on_key_pressed` and `on_key_released` fields of the `WindowCallbacks` structure are set to `nothing`.

Events happen asynchronously, but the user has control over whether the program should listen to those synchronously or asynchronously. This is exposed via the [`run`](@ref) function of the [`AbstractWindowHandler`](@ref) implementation, which must be invoked for events to start being processed.
