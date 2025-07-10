"""
Abstract window type.

Must hold the following properties:
- `.position::Tuple{Int,Int}`: window position within its parent (x, y).
- `.extent::Tuple{Int,Int}`: window dimensions (width, height).
"""
abstract type AbstractWindow end

Base.broadcastable(window::AbstractWindow) = Ref(window)

"""
Get window DPI.
"""
dpi(window::AbstractWindow) = not_implemented_for(window)

"""
Resize the window with `extent` reflecting the new (width, height).
"""
resize_window(window::AbstractWindow, extent; corner = nothing) = not_implemented_for(window)

"""
Move the window to `new_position`.
"""
move_window_to(window::AbstractWindow, position) = not_implemented_for(window)

"""
Move the window, relative to the current window position.
"""
move_window_by(window::AbstractWindow, offset) = move_window_to(window, window.position .+ offset)

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
