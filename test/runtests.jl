using WindowAbstractions
using XKeyboard
using Test

struct FakeWindow <: AbstractWindow end
struct FakeWindowManager <: AbstractWindowManager end

WindowAbstractions.window_type(::FakeWindowManager) = FakeWindow

win = FakeWindow()
wm = FakeWindowManager()
queue = EventQueue(wm)

not_implemented_for(x) = ErrorException("Not implemented for $x")

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

    @testset "AbstractWindow Interface" begin
        @test_throws not_implemented_for(win) extent(win)
        @test_throws not_implemented_for(win) dpi(win)
        @test_throws not_implemented_for(win) resize(win, (1, 1))
        @test_throws not_implemented_for(win) map_window(win)
        @test_throws not_implemented_for(win) unmap_window(win)
        @test_throws not_implemented_for(win) set_title(win, "title")
        @test_throws not_implemented_for(win) set_icon(win, nothing)
        @test_throws not_implemented_for(win) set_icon_title(win, "icon_title")
        @test_throws not_implemented_for(wm) terminate_window!(wm, win)
        @test_throws not_implemented_for(wm) get_window(wm, nothing)
        @test_throws not_implemented_for(queue) poll_for_events!(queue)
    end
end;
