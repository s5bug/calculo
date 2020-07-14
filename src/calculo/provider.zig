const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

const state = @import("state.zig");

pub const is_provider = std.meta.trait.multiTrait(.{
    hasFn("init"),
    hasFn("pull"),
});

pub fn do_thing(comptime provider: anytype) void {
    comptime assert(is_provider(provider.*));
    comptime assert(@TypeOf(provider.init()) == void);
    comptime assert(@TypeOf(provider.pull()) == state.GameState);
    std.debug.print("{}\n", .{provider.pull()});
}
