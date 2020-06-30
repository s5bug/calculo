usingnamespace @import("constants.zig");

const drops = @import("drops.zig");

pub const tsu: DropSet = [1]Drop{drops.i} ** 16;
pub const ringo: DropSet = [16]Drop{
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
};
pub const sig: DropSet = [16]Drop{
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
};
