"""
Non-blocking poll for events. Should return an element of type `Nothing` if no events were caught.
"""
poll_for_event(wm::AbstractWindowManager) = not_implemented_for(wm)

"""
Wait until the next event occurs.
"""
wait_for_event(wm::AbstractWindowManager) = not_implemented_for(wm)
