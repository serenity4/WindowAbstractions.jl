using WindowAbstractions
using WindowAbstractions: Point2
using Test

MouseEvent(ButtonLeft(), MouseState(), ButtonPressed())

cb = WindowCallbacks(
    on_expose=(details) -> 1,
    on_resize=(details) -> 2,
    on_pointer_move=(details) -> 3,
    on_pointer_enter=(details) -> 4,
    on_pointer_leave=(details) -> 5,
    on_key_pressed=(details) -> 6,
    on_key_released=(details) -> 7,
    on_mouse_button_pressed=(details) -> 8,
    on_mouse_button_released=(details) -> 9,
)

struct FakeWindow <: AbstractWindow end
struct FakeWindowHandler <: AbstractWindowHandler end
>
win = FakeWindow()
handler = FakeWindowHandler()

not_implemented_for_window_exc = ErrorException("Not implemented for $win")
not_implemented_for_window_handler_exc = ErrorException("Not implemented for $handler")

@testset "WindowAbstractions.jl" begin
    @testset "Key Combinations" begin
        @test key"ctrl+z" == KeyCombination('z', KeyModifierState(ctrl=true))
        @test key"alt+z" == KeyCombination('z', KeyModifierState(alt=true))
        @test key"super+z" == KeyCombination('z', KeyModifierState(super=true))
        @test key"z" == KeyCombination('z', KeyModifierState())
        @test key"ctrl+shift+z" == KeyCombination('z', KeyModifierState(ctrl=true, shift=true))
        @test key"ctrl+shift+alt+super+z" == KeyCombination('z', KeyModifierState(ctrl=true, shift=true, super=true, alt=true))
        @test key"ctrl+z" == key"CTRL+Z"
    end

    @testset "Callbacks" begin
        @test execute_callback(cb, EventDetails(ExposeEvent(Point2(1, 1), 1), Point2(1, 1), 1.0, :fake_window, win, handler)) == 1
        @test execute_callback(cb, EventDetails(ResizeEvent(Point2(1, 1)), Point2(1, 1), 1.0, :fake_window, win, handler)) == 2
        @test execute_callback(cb, EventDetails(PointerMovesEvent(), Point2(1, 1), 1.0, :fake_window, win, handler)) == 3
        @test execute_callback(cb, EventDetails(PointerEntersWindowEvent(), Point2(1, 1), 1.0, :fake_window, win, handler)) == 4
        @test execute_callback(cb, EventDetails(PointerLeavesWindowEvent(), Point2(1, 1), 1.0, :fake_window, win, handler)) == 5
        @test execute_callback(cb, EventDetails(KeyEvent(:Z02, KeySymbol(:z), 'z', KeyModifierState(ctrl=true), KeyPressed()), Point2(1, 1), 1.0, :fake_window, win, handler)) == 6
        @test execute_callback(cb, EventDetails(KeyEvent(:Z02, KeySymbol(:z), 'z', KeyModifierState(ctrl=true), KeyReleased()), Point2(1, 1), 1.0, :fake_window, win, handler)) == 7
        @test execute_callback(cb, EventDetails(MouseEvent(ButtonLeft(), MouseState(), ButtonPressed()), Point2(1, 1), 1.0, :fake_window, win, handler)) == 8
        @test execute_callback(cb, EventDetails(MouseEvent(ButtonLeft(), MouseState(), ButtonReleased()), Point2(1, 1), 1.0, :fake_window, win, handler)) == 9
    end

    @testset "AbstractWindow Interface" begin
        @test_throws not_implemented_for_window_exc extent(win)
        @test_throws not_implemented_for_window_exc dpi(win)
        @test_throws not_implemented_for_window_exc set_extent(win, Point2(1, 1))
        @test_throws not_implemented_for_window_exc terminate_window!(handler, win)
        @test_throws not_implemented_for_window_exc map_window(win)
        @test_throws not_implemented_for_window_exc unmap_window(win)
        @test_throws not_implemented_for_window_exc set_title(win, "title")
        @test_throws not_implemented_for_window_exc set_icon(win, nothing)
        @test_throws not_implemented_for_window_exc set_icon_title(win, "icon_title")
        @test_throws not_implemented_for_window_exc attach_graphics_context!(win, nothing)
        @test_throws not_implemented_for_window_handler_exc get_window(handler, nothing)
        @test_throws not_implemented_for_window_handler_exc get_window_symbol(handler, nothing)
        @test_throws not_implemented_for_window_handler_exc wait_for_event(handler)
        @test_throws not_implemented_for_window_handler_exc poll_for_event(handler)
    end
end


