function default_on_invalid(wh::AbstractWindowHandler, e::InvalidWindow)
    @error("Window $(e.win) detected as invalid" * (isempty(e.msg) ? "" : ": $(e.msg)"))
    terminate_window!(wh, e.win)
end

function default_on_close(wh::AbstractWindowHandler, e::CloseWindow)
    !isempty(e.msg) && @info(string("Closing window $(e.win)" * (isempty(e.msg) ? "" : ": $(e.msg)")))
    terminate_window!(wh, e.win)
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

callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{ResizeEvent}}) = callbacks.on_resize
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{<:MouseEvent{ButtonPressed}}}) = callbacks.on_mouse_button_pressed
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{<:MouseEvent{ButtonReleased}}}) = callbacks.on_mouse_button_released
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{KeyEvent{KeyPressed}}}) = callbacks.on_key_pressed
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{KeyEvent{KeyReleased}}}) = callbacks.on_key_released
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{ExposeEvent}}) = callbacks.on_expose
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{PointerEntersWindowEvent}}) = callbacks.on_pointer_enter
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{PointerLeavesWindowEvent}}) = callbacks.on_pointer_leave
callback(callbacks::WindowCallbacks, ::Type{<:EventDetails{PointerMovesEvent}}) = callbacks.on_pointer_move

function execute_callback(callbacks::WindowCallbacks, event_details::EventDetails; kwargs...)
    cb = callback(callbacks, typeof(event_details))
    if !isnothing(cb)
        cb(event_details; kwargs...)
    else
        nothing
    end
end
