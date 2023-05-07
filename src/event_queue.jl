"""
Event queue meant to hold events to be processed by an application.

The event queue is bound to a window manager, and will be filled upon notification of low-level events sent by that window manager. Only high-level events will be recorded in the event queue, which are typically suited for use in applications.

The event queue is infinitely iterable, returning [`Event`](@ref)s as they are received. When no events are available, the queue will either enter a sleeping state of approximately 1 ms (if `sleep = true`) or spin while yielding at every iteration.

Any task iterating over the event queue is therefore a good candidate to be scheduled using an interactive thread from Julia 1.9 onwards.

Alternatively, the event queue may be manually filled with [`collect_events!`](@ref) and processed using `Base.isempty` and `Base.popfirst!`.
"""
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
"Gather all pending events."
collect_events!(queue::EventQueue) = while poll_for_events!(queue) end

"Non-blocking poll for events. Must return whether a client event was consumed, even if no `Event` is added to the queue."
poll_for_events!(queue::EventQueue) = not_implemented_for(queue)
