"""
Window dimensions (width, height).
"""
extent(window::AbstractWindow) = not_implemented_for(window)

"""
Get window DPI
"""
dpi(window::AbstractWindow) = not_implemented_for(window)

"""
Resize the window with `extent` reflecting the new (width, height).
"""
set_extent(window::AbstractWindow, extent) = not_implemented_for(window)

"""
Action to perform when an exception of type CloseWindow is raised.
"""
function on_close(e::CloseWindow)
    !isempty(e.msg) && @info(string("Closing window: ", e.msg))
    terminate(e.window)
end

"""
Clean up window state upon destruction. The window cannot be assumed to be mapped or to be valid.
"""
terminate(window::AbstractWindow) = not_implemented_for(window)

"""
Action to perform when an exception of type InvalidWindow is raised.
"""
function on_invalid(e::InvalidWindow)
    @error("Invalid window detected", isempty(e) ? "" : ": $(e.msg)")
    terminate(e.window)
end

"""
Map a window to the screen.
"""
map_window(window::AbstractWindow) = not_implemented_for(window)

"""
Unmap a window from the screen.
"""
unmap_window(window::AbstractWindow) = not_implemented_for(window)

"""
Set window title.
"""
set_title(window::AbstractWindow, title) = not_implemented_for(window)

"""
Set window icon.
"""
set_icon(window::AbstractWindow, icon) = not_implemented_for(window)

"""
Set window icon title.
"""
set_icon_title(window::AbstractWindow, icon) = not_implemented_for(window)

attach_graphics_context(window::AbstractWindow, ctx) = not_implemented_for(window)