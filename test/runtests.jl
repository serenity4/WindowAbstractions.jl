using WindowAbstractions
using Test

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
struct FakeWindowManager <: AbstractWindowManager end

win = FakeWindow()
wm = FakeWindowManager()

WindowAbstractions.callbacks(wm::FakeWindowManager, _) = cb

not_implemented_for_window_exc = ErrorException("Not implemented for $win")
not_implemented_for_window_manager_exc = ErrorException("Not implemented for $wm")

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
        @test execute_callback(wm, EventDetails(ExposeEvent((1, 1), 1), (1, 1), 1.0, win)) == 1
        @test execute_callback(wm, EventDetails(ResizeEvent((1, 1)), (1, 1), 1.0, win)) == 2
        @test execute_callback(wm, EventDetails(PointerMovesEvent(MouseState(), KeyModifierState()), (1, 1), 1.0, win)) == 3
        @test execute_callback(wm, EventDetails(PointerEntersWindowEvent(), (1, 1), 1.0, win)) == 4
        @test execute_callback(wm, EventDetails(PointerLeavesWindowEvent(), (1, 1), 1.0, win)) == 5
        @test execute_callback(wm, EventDetails(KeyEvent(:Z02, KeySymbol(:z), 'z', KeyModifierState(ctrl=true), KeyPressed()), (1, 1), 1.0, win)) == 6
        @test execute_callback(wm, EventDetails(KeyEvent(:Z02, KeySymbol(:z), 'z', KeyModifierState(ctrl=true), KeyReleased()), (1, 1), 1.0, win)) == 7
        @test execute_callback(wm, EventDetails(MouseEvent(ButtonLeft(), MouseState(), ButtonPressed()), (1, 1), 1.0, win)) == 8
        @test execute_callback(wm, EventDetails(MouseEvent(ButtonLeft(), MouseState(), ButtonReleased()), (1, 1), 1.0, win)) == 9
    end

    @testset "AbstractWindow Interface" begin
        @test_throws not_implemented_for_window_exc extent(win)
        @test_throws not_implemented_for_window_exc dpi(win)
        @test_throws not_implemented_for_window_exc set_extent(win, (1, 1))
        @test_throws not_implemented_for_window_exc map_window(win)
        @test_throws not_implemented_for_window_exc unmap_window(win)
        @test_throws not_implemented_for_window_exc set_title(win, "title")
        @test_throws not_implemented_for_window_exc set_icon(win, nothing)
        @test_throws not_implemented_for_window_exc set_icon_title(win, "icon_title")
        @test_throws not_implemented_for_window_exc attach_graphics_context!(win, nothing)
        @test_throws not_implemented_for_window_manager_exc terminate_window!(wm, win)
        @test_throws not_implemented_for_window_manager_exc get_window(wm, nothing)
        @test_throws not_implemented_for_window_manager_exc get_window_symbol(wm, nothing)
        @test_throws not_implemented_for_window_manager_exc wait_for_event(wm)
        @test_throws not_implemented_for_window_manager_exc poll_for_event(wm)
    end
end
