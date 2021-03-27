Base.broadcastable(win::AbstractWindow) = Ref(win)
Base.broadcastable(wh::AbstractWindowHandler) = Ref(wh)

"""
Window dimensions (width, height).
"""
extent(win::AbstractWindow) = not_implemented_for(win)

"""
Get window DPI.
"""
dpi(win::AbstractWindow) = not_implemented_for(win)

"""
Resize the window with `extent` reflecting the new (width, height).
"""
set_extent(win::AbstractWindow, extent) = not_implemented_for(win)

"""
Clean up window state upon destruction. The window cannot be assumed to be mapped or to be valid.
"""
terminate_window!(wh::AbstractWindowHandler, win::AbstractWindow) = not_implemented_for(wh)

"""
Map a window to the screen.
"""
map_window(win::AbstractWindow) = not_implemented_for(win)

"""
Unmap a window from the screen.
"""
unmap_window(win::AbstractWindow) = not_implemented_for(win)

"""
Set window title.
"""
set_title(win::AbstractWindow, title) = not_implemented_for(win)

"""
Set window icon.
"""
set_icon(win::AbstractWindow, icon) = not_implemented_for(win)

"""
Set window icon title.
"""
set_icon_title(win::AbstractWindow, icon_title) = not_implemented_for(win)

attach_graphics_context!(win::AbstractWindow, ctx) = not_implemented_for(win)

get_window_symbol(wh::AbstractWindowHandler, win) = not_implemented_for(wh)

get_window(wh::AbstractWindowHandler, id) = not_implemented_for(wh)

callbacks(wh::AbstractWindowHandler, id) = not_implemented_for(wh)
