# Introduction

Although window systems tend to be quite different from one another in their core API, they expose a common set of functionality. For example, setting the window title or size, and detecting input events (keyboard/mouse events) is something that can be done from any window API.

## Windowing systems

Some major windowing systems are described here:

- [X Window System](https://en.wikipedia.org/wiki/X_Window_System): windowing system for Unix-like operating systems. The API is exposed through the X11 protocol, with the X11 and XCB libraries. A [Julia wrapper](https://github.com/JuliaGL/XCB.jl) is available for the XCB library.
- [Wayland](https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)): is meant to replace the X window system for Unix-like distributions in the future.
- [Desktop Window Manager](https://en.wikipedia.org/wiki/Desktop_Window_Manager): windowing system for Windows.

Many more exist, as can be seen on the [Wikipedia](https://en.wikipedia.org/wiki/Windowing_system) page.