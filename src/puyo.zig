const std = @import("std");

pub const number_of_colors = 4;
pub const board_width = 6;
pub const board_height = 13;

pub const ColorId = if(number_of_colors == 0) void else comptime blk: {
    var result = 1;
    var work = 1;
    while(work < number_of_colors) {
        result += 1;
        work *= 2;
    }
    break :blk @Type(.{
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

pub const Drop = [4]?ColorId;
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
