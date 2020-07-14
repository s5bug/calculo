const std = @import("std");

const cg = @import("../comptime_grouping.zig");

pub usingnamespace @import("constants.zig");

pub const Tile = union(enum) {
    puyo: ColorId,
    garbage,
    empty,
};

pub const Board = [board_height][board_width]Tile;

pub const Piece = struct {
    drop: Drop,
    colors: [drop.groups.entries.len]ColorId,
};

pub fn is_valid_piece(piece: Piece) bool {
    return piece.colors.len == piece.drop.groups.entries.len;
}

pub const drops = @import("drops.zig");

pub const drop_sets = @import("drop_sets.zig");
