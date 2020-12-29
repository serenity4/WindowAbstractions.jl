EventDetails(data, location::Tuple, time, window_symbol, window, window_handler) =
    EventDetails(data, Point2(location...), time, window_symbol, window, window_handler)

function default_on_invalid(e::InvalidWindow)
    @error("Window $(get_window_symbol(e.handler, e.window)) detected as invalid" * (isempty(e.msg) ? "" : ": $(e.msg)"))
    terminate_window!(e.handler, e.window)
end

function default_on_close(e::CloseWindow)
    !isempty(e.msg) && @info(string("Closing window $(get_window_symbol(e.handler, e.window))" * (isempty(e.msg) ? "" : ": $(e.msg)")))
    terminate_window!(e.handler, e.window)
end

Base.run(::EventLoop{W}, ::Synchronous; kwargs...) where {W <: AbstractWindowHandler} = not_implemented_for(W)
Base.run(::EventLoop{W}, ::Asynchronous; kwargs...) where {W <: AbstractWindowHandler} = not_implemented_for(W)

execute_callback(event_loop::EventLoop, event_details::EventDetails; kwargs...) = execute_callback(event_loop.callbacks[event_details.window_symbol], event_details)

execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ResizeEvent}; kwargs...) = callbacks.on_resize(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{<:MouseEvent{ButtonPressed}}; kwargs...) = callbacks.on_mouse_button_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{<:MouseEvent{ButtonReleased}}; kwargs...) = callbacks.on_mouse_button_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyPressed}}; kwargs...) = callbacks.on_key_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyReleased}}; kwargs...) = callbacks.on_key_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ExposeEvent}; kwargs...) = callbacks.on_expose(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerEntersWindowEvent}; kwargs...) = callbacks.on_pointer_enter(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerLeavesWindowEvent}; kwargs...) = callbacks.on_pointer_leave(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerMovesEvent}; kwargs...) = callbacks.on_pointer_move(event_details; kwargs...)
