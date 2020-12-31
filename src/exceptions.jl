InvalidWindow(win::AbstractWindow) = InvalidWindow(win, "")
CloseWindow(win::AbstractWindow) = CloseWindow(win, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")
