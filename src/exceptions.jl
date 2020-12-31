InvalidWindow(wh::AbstractWindowHandler, win::AbstractWindow) = InvalidWindow(wh, win, "")
CloseWindow(wh::AbstractWindowHandler, win::AbstractWindow) = CloseWindow(wh, win, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")
