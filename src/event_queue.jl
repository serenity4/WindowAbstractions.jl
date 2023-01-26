struct EventQueue{WM<:AbstractWindowManager,W<:AbstractWindow}
  wm::WM
  events::Vector{Event{W}}
  sleep::Bool
end

EventQueue(wm::AbstractWindowManager; sleep::Bool = true) = EventQueue{typeof(wm), window_type(wm)}(wm, sleep)
EventQueue{WM,W}(wm::WM, sleep::Bool) where {WM,W} = EventQueue{WM,W}(wm, W[], sleep)

Base.push!(queue::EventQueue, event::Event) = push!(queue.events, event)
Base.pop!(queue::EventQueue) = popfirst!(queue.events)
Base.isempty(queue::EventQueue) = isempty(queue.events)

function Base.iterate(queue::EventQueue, state = nothing)
  (; sleep) = queue
  while isempty(queue.events)
    sleep ? Base.sleep(0.001) : yield()
    poll_for_events!(queue)
  end
  (pop!(queue), nothing)
end

"""
Non-blocking poll for events. Should return an element of type `Nothing` if no events were caught.
"""
poll_for_events!(queue::EventQueue) = not_implemented_for(queue)
