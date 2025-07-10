using WindowAbstractions
using WindowAbstractions: matches
using XKeyboard
using Xorg_libxcb_jll: libxcb
using Test

struct FakeWindow <: AbstractWindow end
struct FakeWindowManager <: AbstractWindowManager end

WindowAbstractions.window_type(::FakeWindowManager) = FakeWindow

window = FakeWindow()
wm = FakeWindowManager()
queue = EventQueue(wm)

not_implemented_for(x) = ErrorException("Not implemented for $x")

@testset "WindowAbstractions.jl" begin
    @testset "Key symbols" begin
        @testset "Construction" begin
            key = KeySymbol(:p)
            @test key.name == Symbol(key) == :p
            @test key.description == 'p'
            @test repr(key) == "KeySymbol(:p)"
            key = KeySymbol(:P)
            @test key.name == :P
            @test key.description == 'P'
            @test repr(key) == "KeySymbol(:P)"
            key = KeySymbol(:alt_left)
            @test key.name == :alt_left
            @test key.description == "Alt (left)"
            @test repr(key) == "KeySymbol(:alt_left, \"Alt (left)\")"
            key = KeySymbol(:eurosign)
            @test key.name == :eurosign
            @test key.description == "eurosign"
            key = KeySymbol(:eurosign, '€')
            @test key.name == :eurosign
            @test key.description == '€'
            key = KeySymbol(:U20AC)
            @test key.name == :U20AC
            @test key.description == '€'
            key = KeySymbol(:escape)
            @test key == KeySymbol(:escape, '\e')
            @test hash(key) == hash(KeySymbol(:escape, '\e'))
        end

        @testset "Construction from XKB" begin
            conn = @ccall libxcb.xcb_connect(get(ENV, "DISPLAY", C_NULL)::Cstring, C_NULL::Ptr{Cint})::Ptr{Cvoid}
            code = @ccall libxcb.xcb_connection_has_error(conn::Ptr{Cvoid})::Cint
            @assert iszero(code) "XCB connection not successful (error code: $code)"
            @test conn ≠ C_NULL
            # Beware: the modifiers pressed during execution of this code will be encoded into the keymap state.
            km = keymap_from_x11(conn)
            @test all(≠(C_NULL), (km.handle, km.ctx, km.state))

            input_key(key::Symbol) = KeySymbol(km, PhysicalKey(km, key))
            @test input_key(:AC02) == KeySymbol(:s)
            @test input_key(:KP1) == KeySymbol(:kp_end, "End (keypad)")
            @test input_key(:SPCE) == KeySymbol(:space, ' ')

            @test KeySymbol('c') == KeySymbol(:c)
            @test KeySymbol('C') == KeySymbol(:C)
            @test KeySymbol('$') == KeySymbol(:dollar, '$')
            @test KeySymbol(']') == KeySymbol(:bracketright, ']')
        end
    end

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
        @test key"escape" == KeyCombination(:escape)
        @test key"escape" == KeyCombination(KeySymbol(:escape, '\e'))
    end

    @testset "AbstractWindow Interface" begin
        @test_throws not_implemented_for(window) dpi(window)
        @test_throws not_implemented_for(window) resize_window(window, (1, 1))
        @test_throws not_implemented_for(window) map_window(window)
        @test_throws not_implemented_for(window) unmap_window(window)
        @test_throws not_implemented_for(window) set_title(window, "title")
        @test_throws not_implemented_for(window) set_icon(window, nothing)
        @test_throws not_implemented_for(window) set_icon_title(window, "icon_title")
        @test_throws not_implemented_for(wm) close(wm, window)
        @test_throws not_implemented_for(wm) get_window(wm, nothing)
        @test_throws not_implemented_for(queue) poll_for_events!(queue)
    end
end;
