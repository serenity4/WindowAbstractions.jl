InvalidWindow(win::AbstractWindow) = InvalidWindow(win, "")
CloseWindow(win::AbstractWindow) = CloseWindow(win, "")

Base.showerror(io::IO, e::T) where {T <: WindowException} = print(io, string(T), isempty(e.msg) ? "" : ": $(e.msg)")

function default_on_invalid(wm::AbstractWindowManager, e::InvalidWindow)
    @error("Window $(e.win) detected as invalid" * (isempty(e.msg) ? "" : ": $(e.msg)"))
    terminate_window!(wm, e.win)
end

function default_on_close(wm::AbstractWindowManager, e::CloseWindow)
    !isempty(e.msg) && @info(string("Closing window $(e.win)" * (isempty(e.msg) ? "" : ": $(e.msg)")))
    terminate_window!(wm, e.win)
end
