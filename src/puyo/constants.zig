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

const cg = @import("../comptime_grouping.zig");

/// A Drop is Coordinates grouped by ColorIds
pub const Drop = cg.AutoComptimeGrouping(ColorId, [2]u8);

/// A DropSet is an array of 16 Drops
pub const DropSet = [16]Drop;
