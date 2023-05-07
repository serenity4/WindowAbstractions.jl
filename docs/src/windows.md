# Windows

Windows, implemented via the [`AbstractWindow`](@ref) interface, are run within window managers, according to the [`AbstractWindowManager`](@ref) interface. Window managers manage all the information related to the execution of windows. They store active windows, connections to the display server (when applicable to the underlying windowing API), keymaps which are to be updated upon reception of specific events, and possibly more.

Typically, a program defines a single window manager, that manages one or several windows which can be created or closed at any given time. Then, an [`EventQueue`](@ref) may be created which wraps such a window manager; its role is to provide high-level events which the application can then process as it desires.
