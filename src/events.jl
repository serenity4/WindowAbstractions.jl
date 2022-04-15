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

callback(callbacks::Callbacks, T) = getproperty(callbacks, callback_symbol(action(T)))

function execute_callback(wm::AbstractWindowManager, ed::EventDetails)
    execute_callback(callback(callbacks(wm, ed.win), typeof(ed)), (ed,))
end

function execute_callback(cb::Function, args::Tuple)
    cb(args...)
end

execute_callback(cb::Nothing, args::Tuple) = nothing

"""
    run(wm, mode; kwargs...)

Run an event loop associated with the window manager `wm` in a synchronous or asynchronous fashion.
"""
Base.run(W::AbstractWindowManager, ::ExecutionMode) = not_implemented_for(W)
