"""
Abstract window type.
"""
abstract type AbstractWindow end

Base.broadcastable(window::AbstractWindow) = Ref(window)

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
resize(window::AbstractWindow, extent) = not_implemented_for(window)

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
