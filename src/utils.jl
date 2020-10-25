not_implemented_for(x) = error("Not implemented for $x")

"""
Construct an immutable struct with `f::Function` for only field, deriving from the abstract type `EventCallback`.
"""
macro callback(expr)
    name = expr.args[2]
    quote
        struct $name <: EventCallback
            f::Function
        end
    end
end