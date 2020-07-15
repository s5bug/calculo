const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

const state = @import("state.zig");

const is_provider_trait = std.meta.trait.multiTrait(.{
    std.meta.trait.hasFn("init"),
    std.meta.trait.hasFn("pull"),
});

pub fn assert_is_provider(provider: anytype) void {
    comptime std.debug.assert(is_provider_trait(@TypeOf(provider)));
    comptime std.debug.assert(@TypeOf(provider.init()) == void);
    comptime std.debug.assert(@TypeOf(provider.pull()) == state.GameState);
}

pub fn do_thing(provider: anytype) void {
    assert_is_provider(provider);
    std.debug.print("{}\n", .{provider.pull()});
}
