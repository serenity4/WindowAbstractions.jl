function default_on_invalid(wh::AbstractWindowHandler, e::InvalidWindow)
    @error("Window $(e.win) detected as invalid" * (isempty(e.msg) ? "" : ": $(e.msg)"))
    terminate_window!(wh, e.win)
end

function default_on_close(wh::AbstractWindowHandler, e::CloseWindow)
    !isempty(e.msg) && @info(string("Closing window $(e.win)" * (isempty(e.msg) ? "" : ": $(e.msg)")))
    terminate_window!(wh, e.win)
end

Base.run(W::AbstractWindowHandler, ::Synchronous; kwargs...) = not_implemented_for(W)
Base.run(W::AbstractWindowHandler, ::Asynchronous; kwargs...) = not_implemented_for(W)

execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ResizeEvent}; kwargs...) = callbacks.on_resize(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{<:MouseEvent{ButtonPressed}}; kwargs...) = callbacks.on_mouse_button_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{<:MouseEvent{ButtonReleased}}; kwargs...) = callbacks.on_mouse_button_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyPressed}}; kwargs...) = callbacks.on_key_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyReleased}}; kwargs...) = callbacks.on_key_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ExposeEvent}; kwargs...) = callbacks.on_expose(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerEntersWindowEvent}; kwargs...) = callbacks.on_pointer_enter(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerLeavesWindowEvent}; kwargs...) = callbacks.on_pointer_leave(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerMovesEvent}; kwargs...) = callbacks.on_pointer_move(event_details; kwargs...)
