Base.broadcastable(window::AbstractWindow) = Ref(window)
Base.broadcastable(handler::AbstractWindowHandler) = Ref(handler)

"""
Window dimensions (width, height).
"""
extent(window::AbstractWindow) = not_implemented_for(window)

"""
Get window DPI.
"""
dpi(window::AbstractWindow) = not_implemented_for(window)

"""
Resize the window with `extent` reflecting the new (width, height).
"""
set_extent(window::AbstractWindow, extent) = not_implemented_for(window)

"""
Clean up window state upon destruction. The window cannot be assumed to be mapped or to be valid.
"""
terminate_window!(handler::AbstractWindowHandler, window::AbstractWindow) = not_implemented_for(window)

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
set_icon_title(window::AbstractWindow, icon_title) = not_implemented_for(window)

attach_graphics_context!(window::AbstractWindow, ctx) = not_implemented_for(window)

get_window_symbol(handler::AbstractWindowHandler, window) = not_implemented_for(handler)

get_window(handler::AbstractWindowHandler, id) = not_implemented_for(handler)
