const std = @import("std");

const cg = @import("../comptime_grouping.zig");

usingnamespace @import("constants.zig");

pub const Tile = union(enum) {
    puyo: ColorId, garbage, empty
};

pub const Board = [board_height][board_width]Tile;

pub const drops = @import("drops.zig");

pub const drop_sets = @import("drop_sets.zig");
