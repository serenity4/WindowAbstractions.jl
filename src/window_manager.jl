"""
Entity that manages windows.
"""
abstract type AbstractWindowManager end

Base.broadcastable(wm::AbstractWindowManager) = Ref(wm)

"""
    (::Type{<:AbstractWindow})(wm::AbstractWindowManager; kwargs...)

Create a window.
"""
(::Type{<:AbstractWindow})(wm::AbstractWindowManager; kwargs...) = not_implemented_for(wm)

"""
    close(wm::AbstractWindowManager, win::AbstractWindow)

Close a window.
"""
Base.close(wm::AbstractWindowManager, ::AbstractWindow) = not_implemented_for(wm)

current_screen(wm::AbstractWindowManager) = not_implemented_for(wm)

window_type(wm::AbstractWindowManager) = not_implemented_for(wm)

"""
Retrieve all the [`AbstractWindow`](@ref)s in use by `wm`.
"""
windows(wm::AbstractWindowManager) = not_implemented_for(wm)

"""
Retrieve a window given an identifier `id`, would typically be an integer identifier, a handle or a name.
"""
get_window(wm::AbstractWindowManager, id) = not_implemented_for(wm)
