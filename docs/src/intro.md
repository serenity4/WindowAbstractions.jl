# Introduction

Although window systems tend to be quite different from one another in their core API, they expose a common set of functionality. For example, setting the window title or size, and detecting input events (keyboard/mouse events) is something that can be done from any windowing API.

## Windowing systems

Some major windowing systems are described here:

- [X Window System](https://en.wikipedia.org/wiki/X_Window_System): windowing system for Unix-like operating systems. The API is exposed through the X11 protocol, with the X11 and XCB libraries. The [XCB.jl](https://github.com/JuliaGL/XCB.jl) library is available and registered, serving as both a low-level interface to XCB and a high-level package using abstractions defined in this package.
- [Wayland](https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)): is aimed as a replacement to the old X window system, with better support for modern hardware features such as heterogeneous monitor refresh rates, high DPI monitors and HDR screens. [Wayland.jl](https://github.com/serenity4/Wayland.jl) exists as a work in progress, which currently only implements a low-level interface to Wayland as a Wayland client.
- [Desktop Window Manager](https://en.wikipedia.org/wiki/Desktop_Window_Manager): windowing system for Windows.

Many more exist, as can be seen on the [Wikipedia](https://en.wikipedia.org/wiki/Windowing_system) page.
