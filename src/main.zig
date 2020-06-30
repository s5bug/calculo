const std = @import("std");

const puyo = @import("puyo/puyo.zig");

pub fn main() anyerror!void {
    std.debug.warn("All your {} are belong to us.\n", .{puyo.drop_sets.sig[3].entries.get([2]u8{ 1, 0 }).?.*});
}
