"""
Non-blocking poll for events. Should return an element of type `Nothing` if no events were caught.
"""
poll_for_event(handler::AbstractWindowHandler) = not_implemented_for(handler)

"""
Wait until the next event occurs.
"""
wait_for_event(handler::AbstractWindowHandler) = not_implemented_for(handler)