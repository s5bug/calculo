const std = @import("std");

pub const number_of_colors = 4;
pub const board_width = 6;
pub const board_height = 13;

pub const ColorId = comptime blk: {
    var result = 0;
    var work = number_of_colors;
    while(work > 1) {
        work /= 2;
        result += 1;
    }
    break :blk if(result == 0) void else @Type(.{
        .Int = .{
            .is_signed = false,
            .bits = result
        }
    });
};

pub const Tile = union(enum) {
    puyo: ColorId,
    garbage,
    empty
};

pub const Board = [board_width][board_height]Tile;

pub const Drop = [4]?u2;
pub const DropSet = [16]Drop;

pub const drops = .{
    .i = [4]?ColorId{ 0, null, 1, null },
    .lv = [4]?ColorId{ 0, 1, 0, null },
    .lh = [4]?ColorId{ 0, 0, 1, null },
    .s = [4]?ColorId{ 0, 1, 0, 1 },
    .o = [4]?ColorId{ 0, 0, 0, 0 }
};

pub const drop_sets = .{
    .tsu = [1]Drop{ drops.i } ** 16,
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
        drops.lv
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
        drops.s
    }
};
