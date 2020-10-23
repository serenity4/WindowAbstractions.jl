"""
Retrieve a list of pressed button symbols for the left, middle and right buttons from a `MouseEvent`.
"""
function pressed_buttons(input::MouseEvent)
    inputs = filter(x -> x.second && x.first ∈ (:left, :middle, :right), Dict(input))
    pressed_buttons = collect(keys(inputs))
end
"""
Compute drag source and destination from a vector of `MouseEvent`s.
If several drag events are present in `events`, only the first one is computed. If a drag is still ongoing after the last event, a `InDrag` instance is returned.
"""
function drag(events::Vector{Event{MouseEvent}}; drag_threshold=4)
    for (i, event) ∈ enumerate(events)
        buttons = pressed_buttons(event.data)
        if !isempty(buttons) && i ≠ length(events)
            for (j, new_event) ∈ enumerate(events[i+1:end])
                in_drag = j - i < drag_threshold
                new_buttons = pressed_buttons(new_event.data)
                if buttons ≠ new_buttons # end of drag condition
                    in_drag && return Drag(event, new_event)
                    break
                end
            end
            in_drag && return InDrag(event)
        end
    end
end