InvalidWindow(handler::AbstractWindowHandler, window::AbstractWindow) = InvalidWindow(handler, window, "")
CloseWindow(handler::AbstractWindowHandler, window::AbstractWindow) = CloseWindow(handler, window, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")

execute_callback(event_loop::EventLoop{W}, e::CloseWindow) where {W <: AbstractWindowHandler} = event_loop.callbacks[get_window_symbol(event_loop.window_handler, e.window)].on_close(e)

execute_callback(event_loop::EventLoop{W}, e::InvalidWindow) where {W <: AbstractWindowHandler} = event_loop.callbacks[get_window_symbol(event_loop.window_handler, e.window)].on_invalid(e)