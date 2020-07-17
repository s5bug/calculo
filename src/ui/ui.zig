const std = @import("std");
const gl = @import("zgl");
const sdl = @import("sdl2");
const sdl_c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_image.h");
});

const res = @import("res.zig");
const state = @import("state.zig");

pub fn run(alloc: *std.mem.Allocator) anyerror!void {
    const frame_delay = 1000 / 60; // TODO implement a real delta system
    // Why doesn't SDL have an /actual/ vsync/deltatime system???
    // I'm probably going to switch to a different library because of this

    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();

    const allocator = &arena.allocator;

    try sdl.init(.{
        .video = true,
    });
    defer sdl.quit();

    var window = try sdl.createWindow("Calculo Test UI", .{ .centered = {} }, .{ .centered = {} }, 640, 480, .{});
    defer window.destroy();

    var renderer = try sdl.createRenderer(window, null, .{ .accelerated = true });
    defer renderer.destroy();

    const cur_state = try allocator.create(state.UIState);

    try state.init_main_menu(allocator, cur_state);

    var quit = false;
    while (!quit) {
        const frame_start = sdl_c.SDL_GetTicks();

        quit = handle_state(allocator, cur_state);

        const frame_time = sdl_c.SDL_GetTicks() - frame_start;

        if(frame_delay > frame_time) {
            sdl_c.SDL_Delay(frame_delay - frame_time);
        }
    }
}

pub fn handle_state(allocator: *std.mem.Allocator, cur_state: *state.UIState) bool {
    while (sdl.pollEvent()) |ev| {
        switch (ev) {
            .quit => {
                return true;
            },
            else => {},
        }
    }

    return false;
}
