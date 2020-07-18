const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const res = @import("res.zig");
const state = @import("state.zig");

pub fn run(alloc: *std.mem.Allocator) anyerror!void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const width = 640;
    const height = 480;

    ray.InitWindow(width, height, "Calculo Test UI");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    const cur_state = try allocator.create(state.UIState);

    try state.init_main_menu(allocator, cur_state);

    while (!ray.WindowShouldClose()) {
        switch (cur_state.*) {
            .main_menu => |main_menu_state| blk: {
                ray.BeginDrawing();

                ray.ClearBackground(ray.RAYWHITE);

                const mm_text = "Main Menu";
                const mm_size = 60;
                const mm_offset = @divTrunc(ray.MeasureText(mm_text, mm_size), 2);
                ray.DrawText(mm_text, @divTrunc(width, 2) - mm_offset, 24, mm_size, ray.LIGHTGRAY);

                ray.EndDrawing();
            },
            else => unreachable,
        }
    }
}
