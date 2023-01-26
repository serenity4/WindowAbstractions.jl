"""
Abstract window type.
"""
abstract type AbstractWindow end

Base.broadcastable(win::AbstractWindow) = Ref(win)

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
resize(win::AbstractWindow, extent) = not_implemented_for(win)

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
