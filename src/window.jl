Base.broadcastable(win::AbstractWindow) = Ref(win)
Base.broadcastable(wm::AbstractWindowManager) = Ref(wm)

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
terminate_window!(wm::AbstractWindowManager, win::AbstractWindow) = not_implemented_for(wm)

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

get_window_symbol(wm::AbstractWindowManager, win) = not_implemented_for(wm)

"""
Retrieve a window given an identifier `id`, would typically be an integer identifier, a handle or a name.
"""
get_window(wm::AbstractWindowManager, id) = not_implemented_for(wm)

"""
Return the set of [`Callbacks`](@ref) attached to a window.
"""
callbacks(wm::AbstractWindowManager, win::AbstractWindow) = not_implemented_for(wm)
