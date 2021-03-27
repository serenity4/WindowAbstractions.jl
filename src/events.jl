action(::Type{PointerMovesEvent}) = PointerMoves
action(::Type{PointerLeavesWindowEvent}) = PointerLeavesWindow
action(::Type{PointerEntersWindowEvent}) = PointerEntersWindow
action(::Type{ExposeEvent}) = Expose
action(::Type{ResizeEvent}) = Resize
action(::Type{<:MouseEvent{A}}) where {A} = A
action(::Type{<:KeyEvent{A}}) where {A} = A
action(::Type{<:EventDetails{T}}) where {T} = action(T)

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

function execute_callback(callbacks::Callbacks, event_details; kwargs...)
    cb = callback(callbacks, typeof(event_details))
    if !isnothing(cb)
        cb(event_details; kwargs...)
    else
        nothing
    end
end

"""
    run(window_handler, Synchronous(); kwargs...)

Run an event loop associated with the `window_handler` in a synchronous fashion.
"""
Base.run(W::AbstractWindowHandler, ::Synchronous; kwargs...) = not_implemented_for(W)

"""
    run(window_handler, Asynchronous(); kwargs...)

Run an event loop associated with the `window_handler` in an asynchronous fashion.
"""
Base.run(W::AbstractWindowHandler, ::Asynchronous; kwargs...) = not_implemented_for(W)
