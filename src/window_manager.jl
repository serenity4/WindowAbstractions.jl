"""
Non-blocking poll for events. Should return an element of type `Nothing` if no events were caught.
"""
poll_for_event(wm::AbstractWindowManager) = not_implemented_for(wm)

"""
Wait until the next event occurs.
"""
wait_for_event(wm::AbstractWindowManager) = not_implemented_for(wm)

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

"""
Process an event received by either [`poll_for_event`](@ref) or [`wait_for_event`](@ref), modifying state (e.g. window, keymap) and/or returning an [`EventDetails`](@ref) instance.

If the returned value is not an [`EventDetails`](@ref), then it must either be of type [`CloseWindow`](@ref) or [`InvalidWindow`](@ref), or `nothing`.
"""
process_event(wm::AbstractWindowManager, event) = not_implemented_for(wm)
