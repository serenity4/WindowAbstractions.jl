
#=

Interaction entities, something that reacts in a specific manner to inputs
Structure the interior of the window

Service 1: structuring the interior of the window to allow for fine-grained interaction through both capturing the input by a specific region and reacting to this input in a manner specific to this region.

Example: defining a rectangular region which does nothing, and a rectangular region which shrinks its area when we click on it (no visuals required).

Service 2: record past interactions to define a richer set of events.

Examples: Retain active buttons for detecting double clicks, drag events and drop events; retain event data to be passed to non-unary callback functions, like dragging (with a drag source and dragged over target).

=#

struct InputState <: InteractionState
  active_keys::Dictionary{Symbol,EventDetails{KeyEvent{KeyPressed},W,Float64}}
  active_buttons::Dictionary{MouseButton,EventDetails{<:MouseEvent{ButtonPressed},W,Float64}}
  history::Dictionary{Event,EventDetails}
end
