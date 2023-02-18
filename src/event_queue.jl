struct EventQueue{WM<:AbstractWindowManager,W<:AbstractWindow}
  wm::WM
  events::Vector{Event{W}}
  sleep::Bool
end

EventQueue(wm::AbstractWindowManager; sleep::Bool = true) = EventQueue{typeof(wm), window_type(wm)}(wm, sleep)
EventQueue{WM,W}(wm::WM, sleep::Bool) where {WM,W} = EventQueue{WM,W}(wm, W[], sleep)

Base.push!(queue::EventQueue, event::Event) = push!(queue.events, event)
Base.popfirst!(queue::EventQueue) = popfirst!(queue.events)
Base.isempty(queue::EventQueue) = isempty(queue.events)

function Base.iterate(queue::EventQueue, state = nothing)
  (; sleep) = queue
  while isempty(queue)
    sleep ? Base.sleep(0.001) : yield()
    collect_events!(queue)
  end
  (popfirst!(queue), nothing)
end

# Is it assumed that the client API will not be sending events faster than we process them.
collect_events!(queue::EventQueue) = while poll_for_events!(queue) end

"Non-blocking poll for events. Must return whether a client event was consumed, even if no `Event` is added to the queue."
poll_for_events!(queue::EventQueue) = not_implemented_for(queue)
