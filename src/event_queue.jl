"""
Event queue meant to hold events to be processed by an application.

The event queue is bound to a window manager, and will be filled upon notification of low-level events sent by that window manager. Only high-level events will be recorded in the event queue, which are typically suited for use in applications.

The event queue is infinitely iterable, returning [`Event`](@ref)s as they are received. When no events are available, the queue will either enter a sleeping state of approximately 1 ms (if `sleep = true`) or spin while yielding at every iteration.

Any task iterating over the event queue is therefore a good candidate to be scheduled using an interactive thread from Julia 1.9 onwards.

Alternatively, the event queue may be manually filled with [`collect_events!`](@ref) and processed using `Base.isempty` and `Base.popfirst!`.

The parameter `record_history` may be set to `true` to save all events that have been processed (either by iteration or manual `Base.popfirst!`). Implementations of window managers may extend [`save_history`](@ref) and [`replay_history`](@ref) to allow for the saving and replay of events that have been stored. Note that `record_history` will have to be set to true for [`save_history`](@ref) to work.
"""
struct EventQueue{WM<:AbstractWindowManager,W<:AbstractWindow}
  wm::WM
  events::Vector{Event{W}}
  history::Vector{Event{W}}
  sleep::Bool
  record_history::Bool
end

EventQueue(wm::AbstractWindowManager; sleep::Bool = true, record_history::Bool = false) = EventQueue{typeof(wm), window_type(wm)}(wm, sleep, record_history)
EventQueue{WM,W}(wm::WM, sleep::Bool, record_history::Bool = false) where {WM,W} = EventQueue{WM,W}(wm, W[], W[], sleep, record_history)

Base.push!(queue::EventQueue, event::Event) = push!(queue.events, event)
function Base.popfirst!(queue::EventQueue)
  event = popfirst!(queue.events)
  queue.record_history && push!(queue.history, event)
  event
end
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

"""
    save_history(wm::WM, queue::EventQueue{WM}) -> Vector{<:Event}

Save actions stored inside the event queue for later replay with [`replay_history`](@ref).

The event queue must have been created with `record_history = true`.
"""
function save_history end

"""
    replay_history(wm, events)

Replay events generated by [`save_history`](@ref) on the provided window manager.

Delays between events should be respected. The window manager is free to assume that no other event will be generated during the replay: user interactinos with the window while the replay is ongoing may affect the integrity of the replication.

Note that any global state such as RNG is not saved; the application is responsible for managing state appropriately for effects outside of the event system.
"""
function replay_history end
