using WindowAbstractions
using WindowAbstractions: matches
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
        @test key"ctrl+z" == KeyCombination(:z, CTRL_MODIFIER)
        @test key"alt+z" == KeyCombination(:z, MOD1_MODIFIER)
        @test key"super+z" == KeyCombination(:z, MOD3_MODIFIER)
        @test key"alt_gr+z" == KeyCombination(:z, MOD5_MODIFIER)
        @test key"z" == KeyCombination(:z)
        @test key"ctrl+shift+z" == KeyCombination(:z, CTRL_MODIFIER | SHIFT_MODIFIER)
        @test key"ctrl+shift+alt+super+z" == KeyCombination(:z, CTRL_MODIFIER | SHIFT_MODIFIER | MOD1_MODIFIER | MOD3_MODIFIER)
        @test key"ctrl+z" != key"ctrl+Z"
        @test key"ctrl+z" == key"CTRL+z"
        @test !matches(key"ctrl+z", KeySymbol(:z), NO_MODIFIERS, NO_MODIFIERS)
        @test matches(key"ctrl+z", KeySymbol(:z), CTRL_MODIFIER, NO_MODIFIERS)
        @test matches(key"ctrl+Z", KeySymbol(:Z), CTRL_MODIFIER | SHIFT_MODIFIER, SHIFT_MODIFIER)
        @test !matches(key"ctrl+Z", KeySymbol(:Z), CTRL_MODIFIER | SHIFT_MODIFIER, NO_MODIFIERS)
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
        @test_throws not_implemented_for(wm) close(wm, win)
        @test_throws not_implemented_for(wm) get_window(wm, nothing)
        @test_throws not_implemented_for(queue) poll_for_events!(queue)
    end
end;
