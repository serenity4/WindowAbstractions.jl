abstract type WindowException <: Exception end

"""
Signals that the window must be closed.
"""
struct CloseWindow <: WindowException
    window::AbstractWindow
    msg::AbstractString
end

struct InvalidWindow <: WindowException
    window::AbstractWindow
    msg::AbstractString
end
InvalidWindow(window::AbstractWindow) = InvalidWindow(window, "")
CloseWindow(window::AbstractWindow) = CloseWindow(window, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")