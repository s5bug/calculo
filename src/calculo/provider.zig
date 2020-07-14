const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

const state = @import("state.zig");

pub const is_provider = std.meta.trait.multiTrait(.{
    std.meta.trait.hasFn("init"),
    std.meta.trait.hasFn("pull"),
});

pub fn do_thing(provider: anytype) void {
    comptime std.debug.assert(is_provider(@TypeOf(provider)));
    comptime std.debug.assert(@TypeOf(provider.init()) == void);
    comptime std.debug.assert(@TypeOf(provider.pull()) == state.GameState);
    std.debug.print("{}\n", .{provider.pull()});
}
