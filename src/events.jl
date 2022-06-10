action(::Type{PointerMovesEvent}) = PointerMoves
action(::Type{PointerLeavesWindowEvent}) = PointerLeavesWindow
action(::Type{PointerEntersWindowEvent}) = PointerEntersWindow
action(::Type{ExposeEvent}) = Expose
action(::Type{ResizeEvent}) = Resize
action(::Type{<:MouseEvent{A}}) where {A} = A
action(::Type{<:KeyEvent{A}}) where {A} = A
action(::Type{<:EventDetails{T}}) where {T} = action(T)
action(ed::EventDetails) = action(typeof(ed))
action(ed::EventData) = action(typeof(ed))

callback_symbol(::Type{Resize}) = :on_resize
callback_symbol(::Type{ButtonPressed}) = :on_mouse_button_pressed
callback_symbol(::Type{ButtonReleased}) = :on_mouse_button_released
callback_symbol(::Type{KeyPressed}) = :on_key_pressed
callback_symbol(::Type{KeyReleased}) = :on_key_released
callback_symbol(::Type{Expose}) = :on_expose
callback_symbol(::Type{PointerEntersWindow}) = :on_pointer_enter
callback_symbol(::Type{PointerLeavesWindow}) = :on_pointer_leave
callback_symbol(::Type{PointerMoves}) = :on_pointer_move
callback_symbol(::Type{CloseWindow}) = :on_close
callback_symbol(::Type{InvalidWindow}) = :on_invalid

callback(callbacks::Callbacks, T) = getproperty(callbacks, callback_symbol(action(T)))
callback(callbacks::Callbacks, T::Union{Type{InvalidWindow}, Type{CloseWindow}}) = getproperty(callbacks, callback_symbol(T))

execute_callback(wm::AbstractWindowManager, ed::EventDetails) = execute_callback(callbacks(wm, ed.win), ed)

function execute_callback(callbacks::Callbacks, ed::EventDetails)
    f = callback(callbacks, typeof(ed))
    isnothing(f) && return
    f(ed)
end

function handle_events(wm::AbstractWindowManager, event)
    ed = process_event(wm, event)
    isnothing(ed) && return nothing
    isa(ed, EventDetails) && (ed = execute_callback(wm, ed))
    if isa(ed, CloseWindow) || isa(ed, InvalidWindow)
        f = callback(callbacks(wm, ed.win), typeof(ed))
        f(wm, ed)
    end
end

"""
Run an event loop for the window manager `wm` which listens for events and processes them.

If `sleep_time` is non-zero, `Base.sleep` will be called between each round of polling (i.e. between successive tries that return no event).
"""
function listen_for_events(wm::AbstractWindowManager; sleep_time::Real = 0.001)
    !iszero(sleep_time) && sleep_time < 0.001 && @warn("The granularity of `sleep` is 0.001 (1 millisecond). Any non-zero value higher lower than 1ms will be clamped to 1ms.")
    while !isempty(wm.windows)
        while true
            event = poll_for_event(wm)
            isnothing(event) && break
            handle_events(wm, event)
        end
        !iszero(sleep_time) && sleep(sleep_time)
    end
end

"""
Run an event loop for the window manager `wm` which listens for events and processes them.

If `sleep_time` is non-zero, `Base.sleep` will be called between each round of polling (i.e. between successive tries that return no event).
"""
Base.run(wm::AbstractWindowManager; sleep_time::Real = 0.001) = listen_for_events(wm; sleep_time)
