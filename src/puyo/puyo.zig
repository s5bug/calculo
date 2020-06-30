const std = @import("std");

const cg = @import("../comptime_grouping.zig");

const constants = @import("constants.zig");
const ColorId = constants.ColorId;
const board_width = constants.board_width;
const board_height = constants.board_height;

pub const Tile = union(enum) {
    puyo: ColorId, garbage, empty
};

pub const Board = [board_height][board_width]Tile;

pub const drops = @import("drops.zig");

pub const drop_sets = @import("drop_sets.zig");
