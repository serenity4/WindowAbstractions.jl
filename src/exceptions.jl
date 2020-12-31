InvalidWindow(handler::AbstractWindowHandler, window::AbstractWindow) = InvalidWindow(handler, window, "")
CloseWindow(handler::AbstractWindowHandler, window::AbstractWindow) = CloseWindow(handler, window, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")
