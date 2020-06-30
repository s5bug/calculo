const cg = @import("../comptime_grouping.zig");

usingnamespace @import("constants.zig");

pub const i: Drop = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
    .{[2]u8{ 0, 0 }},
    .{[2]u8{ 0, 1 }},
});

pub const lv: Drop = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
    .{ [2]u8{ 0, 0 }, [2]u8{ 0, 1 } },
    .{[2]u8{ 1, 0 }},
});

pub const lh: Drop = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
    .{ [2]u8{ 0, 0 }, [2]u8{ 1, 0 } },
    .{[2]u8{ 0, 1 }},
});

pub const s: Drop = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{
    .{ [2]u8{ 0, 0 }, [2]u8{ 0, 1 } },
    .{ [2]u8{ 1, 0 }, [2]u8{ 1, 1 } },
});

pub const o: Drop = cg.AutoComptimeGrouping(ColorId, [2]u8).init(.{.{ [2]u8{ 0, 0 }, [2]u8{ 1, 0 }, [2]u8{ 0, 1 }, [2]u8{ 1, 1 } }});
