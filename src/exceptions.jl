"""
Signals that the window must be closed.
"""
@with_kw struct CloseWindow <: Exception
    msg::AbstractString = ""
end

struct InvalidWindow <: Exception
    window::AbstractWindow
    msg::AbstractString
end
InvalidWindow(window::AbstractWindow) = InvalidWindow(window, "")

Base.showerror(io::IO, e::InvalidWindow) = print(io, "InvalidWindow: ", e.msg)