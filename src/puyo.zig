const std = @import("std");

const cg = @import("comptime_grouping.zig");

pub const number_of_colors = 4;
pub const board_width = 6;
pub const board_height = 13;

pub const ColorId = comptime blk: {
    if (number_of_colors > 0) {
        var result = 0;
        var work = 1;
        while (work < number_of_colors) {
            result += 1;
            work *= 2;
        }
        break :blk @Type(.{
            .Int = .{
                .is_signed = false,
                .bits = result,
            },
        });
    } else @compileError("number_of_colors must be 1 or greater");
};

pub const Tile = union(enum) {
    puyo: ColorId, garbage, empty
};

pub const Board = [board_height][board_width]Tile;

/// A Drop is Coordinates grouped by ColorIds
pub const Drop = cg.AutoComptimeGrouping(ColorId, [2]u8);

/// A DropSet is an array of 16 Drops
pub const DropSet = [16]Drop;

pub const drops = .{
    .i = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
        .{[2]u8{ 0, 0 }},
        .{[2]u8{ 0, 1 }},
    }),
    .lv = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
        .{ [2]u8{ 0, 0 }, [2]u8{ 0, 1 } },
        .{[2]u8{ 1, 0 }},
    }),
    .lh = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
        .{ [2]u8{ 0, 0 }, [2]u8{ 1, 0 } },
        .{[2]u8{ 0, 1 }},
    }),
    .s = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
        .{ [2]u8{ 0, 0 }, [2]u8{ 0, 1 } },
        .{ [2]u8{ 1, 0 }, [2]u8{ 1, 1 } },
    }),
    .o = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{.{ [2]u8{ 0, 0 }, [2]u8{ 1, 0 }, [2]u8{ 0, 1 }, [2]u8{ 1, 1 } }}),
};

pub const drop_sets = .{
    .tsu = [1]Drop{drops.i} ** 16,
    .ringo = [16]Drop{
        drops.i,
        drops.i,
        drops.i,
        drops.lv,
        drops.o,
        drops.i,
        drops.i,
        drops.i,
        drops.lh,
        drops.o,
        drops.s,
        drops.i,
        drops.i,
        drops.lv,
        drops.i,
        drops.lv,
    },
    .sig = [16]Drop{
        drops.i,
        drops.i,
        drops.i,
        drops.lv,
        drops.i,
        drops.i,
        drops.i,
        drops.s,
        drops.i,
        drops.i,
        drops.lh,
        drops.i,
        drops.o,
        drops.i,
        drops.i,
        drops.s,
    },
};

pub const Move = struct {
    time: u32, result: Board
};

pub const time_after_placement = 7;
pub const time_after_pop = 30;
pub const time_max_after_touch = 32;

pub fn possible_next_states(board: Board, drop: Drop) []Move {
    // There's four different rotations for a drop.
    // There's also some amount of placements for it based on its rotated width.
    // ComptimeGrouping would make this much much easier than it is now...
}
