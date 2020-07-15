const gl = @import("zgl");
const sdl = @import("sdl2");

const res = @import("res.zig");

pub fn init() anyerror!void {
    try sdl.init(.{
        .video = true,
    });
    defer sdl.quit();

    var window = try sdl.createWindow("Calculo Test UI", .{ .centered = {} }, .{ .centered = {} }, 640, 480, .{});
    defer window.destroy();

    var renderer = try sdl.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    var tilesheet = try res.load_puyo_tilesheet(renderer);

    loop: while (true) {
        while (sdl.pollEvent()) |ev| {
            switch (ev) {
                .quit => {
                    break :loop;
                },
                else => {},
            }
        }

        try renderer.setColorRGB(0, 0, 0);
        try renderer.clear();

        const source = sdl.Rectangle {
            .x = 0,
            .y = 0,
            .width = 32,
            .height = 32,
        };
        const target = sdl.Rectangle {
            .x = 32,
            .y = 32,
            .width = 32,
            .height = 32,
        };

        try renderer.copy(tilesheet, target, source);

        renderer.present();
    }
}
