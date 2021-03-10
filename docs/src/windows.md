# Windows

Windows, implemented via the [`AbstractWindow`](@ref) interface, are run within window handlers, according to the [`AbstractWindowHandler`](@ref) interface. Window handlers manage all the information related to the execution of windows. They store callbacks, handle errors and run an event loop that listens to events on any of its windows.
Typically, a program defines a single window handler, that manages one or several windows which can be created or closed at any given time. This window handler can be run synchronously, blocking all execution until events are received, or asynchronously, periodically polling for new events. Asynchronous execution may be done via the task system on the same thread, or on any other thread.
