"""
Compute drag source and destination from a vector of `MouseEvent`s.
If several drag events are present in `events`, only the first one is computed. If a drag is still ongoing after the last event, a `InDrag` instance is returned.
"""
function drag(events::Vector{EventDetails{MouseEvent}}; drag_threshold=4)
    for (i, event) ∈ enumerate(events)
        buttons = pressed_buttons(event.data)
        if !isempty(buttons) && i ≠ length(events)
            for (j, new_event) ∈ enumerate(events[i+1:end])
                in_drag = j - i < drag_threshold
                new_buttons = pressed_buttons(new_event.data)
                if buttons ≠ new_buttons # end of drag condition
                    in_drag && return Drag(event, new_event)
                    break
                end
            end
            in_drag && return InDrag(event)
        end
    end
end

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

execute_callback(event_loop::EventLoop{W}, event_details::EventDetails{E}; kwargs...) where {W <: AbstractWindowHandler, E <: EventData} = execute_callback(event_loop.callbacks[event_details.window_symbol], event_details)

execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ResizeEvent}; kwargs...) = callbacks.on_resize(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{MouseEvent{ButtonPressed, B}, W, F}; kwargs...) where {B <: MouseButton, W <: AbstractWindow, F <: AbstractFloat} = callbacks.on_mouse_button_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{MouseEvent{ButtonReleased, B}, W, F}; kwargs...) where {B <: MouseButton, W <: AbstractWindow, F <: AbstractFloat} = callbacks.on_mouse_button_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyPressed}}; kwargs...) = callbacks.on_key_pressed(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{KeyEvent{KeyReleased}}; kwargs...) = callbacks.on_key_released(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{ExposeEvent}; kwargs...) = callbacks.on_expose(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerEntersWindowEvent}; kwargs...) = callbacks.on_pointer_enter(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerLeavesWindowEvent}; kwargs...) = callbacks.on_pointer_leave(event_details; kwargs...)
execute_callback(callbacks::WindowCallbacks, event_details::EventDetails{PointerMovesEvent}; kwargs...) = callbacks.on_pointer_move(event_details; kwargs...)