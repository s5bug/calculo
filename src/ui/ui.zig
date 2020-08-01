const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const res = @import("res.zig");
const state = @import("state.zig");

const title = "Calculo Testing UI";
const width = 640;
const height = 480;

pub fn run(alloc: *std.mem.Allocator) anyerror!void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();

    const allocator = &arena.allocator;

    ray.InitWindow(width, height, title);
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    const cur_state = try allocator.create(state.UIState);

    try state.init_main_menu(allocator, cur_state);

    while (!ray.WindowShouldClose()) {
        switch (cur_state.screen) {
            .main_menu => try handle_main_menu(allocator, cur_state),
            .controller_configuration => try handle_controller_configuration(allocator, cur_state),
            else => unreachable,
        }
    }
}

pub fn handle_main_menu(allocator: *std.mem.Allocator, cur_state: *state.UIState) !void {
    const main_menu_state = cur_state.screen.main_menu;

    const can_go = cur_state.controllers.len > 0;

    ray.BeginDrawing();

    ray.ClearBackground(ray.RAYWHITE);

    const mm_text = title;
    const mm_size = 60;
    const mm_offset = @divTrunc(ray.MeasureText(mm_text, mm_size), 2);
    ray.DrawText(mm_text, @divTrunc(width, 2) - mm_offset, 24, mm_size, ray.LIGHTGRAY);

    const go_color = if (main_menu_state.selected_button == .go) ray.RED else if (!can_go) ray.GRAY else ray.DARKGRAY;

    const go_text = "Go";
    const go_size = 20;
    const go_offset = @divTrunc(ray.MeasureText(go_text, go_size), 2);
    ray.DrawText(go_text, @divTrunc(width, 2) - go_offset, 300, go_size, go_color);

    const conf_color = if (main_menu_state.selected_button == .configure_controllers) ray.RED else ray.DARKGRAY;

    const conf_text = "Configure Controllers";
    const conf_size = 20;
    const conf_offset = @divTrunc(ray.MeasureText(conf_text, conf_size), 2);
    ray.DrawText(conf_text, @divTrunc(width, 2) - conf_offset, 340, conf_size, conf_color);

    ray.EndDrawing();

    if (ray.IsKeyPressed(ray.KEY_ENTER)) {
        if (main_menu_state.selected_button == .configure_controllers) {
            try state.main_menu_to_controller_configuration(allocator, cur_state);
        }
    }
    if (ray.IsKeyPressed(ray.KEY_UP)) {
        main_menu_state.selected_button = switch (main_menu_state.selected_button) {
            .go => .go,
            .configure_controllers => if (can_go) state.MainMenuButton.go else state.MainMenuButton.configure_controllers,
        };
    }
    if (ray.IsKeyPressed(ray.KEY_DOWN)) {
        main_menu_state.selected_button = switch (main_menu_state.selected_button) {
            .go => .configure_controllers,
            .configure_controllers => .configure_controllers,
        };
    }
}

pub fn handle_controller_configuration(allocator: *std.mem.Allocator, cur_state: *state.UIState) !void {
    const controller_configuration_state = cur_state.screen.controller_configuration;

    const can_add = cur_state.controllers.len < 4;
    const can_remove = cur_state.controllers.len > 0;

    ray.BeginDrawing();

    ray.ClearBackground(ray.RAYWHITE);

    const back_color = if (controller_configuration_state.selected_button == .back) ray.RED else ray.DARKGRAY;

    const back_text = "Back";
    const back_size = 20;
    ray.DrawText(back_text, 20, 20, back_size, back_color);

    const add_remove_y = 80;

    const remove_color = if (controller_configuration_state.selected_button == .remove_controller) ray.RED else if (!can_remove) ray.GRAY else ray.DARKGRAY;

    const remove_text = "Remove";
    const remove_size = 20;
    const remove_offset = @divTrunc(ray.MeasureText(remove_text, remove_size), 2);
    ray.DrawText(remove_text, @divTrunc(width, 3) - remove_offset, add_remove_y, remove_size, remove_color);

    const add_color = if (controller_configuration_state.selected_button == .add_controller) ray.RED else if (!can_add) ray.GRAY else ray.DARKGRAY;

    const add_text = "Add";
    const add_size = 20;
    const add_offset = @divTrunc(ray.MeasureText(add_text, add_size), 2);
    ray.DrawText(add_text, @divTrunc(2 * width, 3) - add_offset, add_remove_y, add_size, add_color);

    ray.EndDrawing();

    if (ray.IsKeyPressed(ray.KEY_BACKSPACE) or
        (ray.IsKeyPressed(ray.KEY_ENTER) and controller_configuration_state.selected_button == .back))
    {
        try state.controller_configuration_to_main_menu(allocator, cur_state);
    }

    if (ray.IsKeyPressed(ray.KEY_LEFT) and
        controller_configuration_state.selected_button == .add_controller and
        can_remove)
    {
        controller_configuration_state.selected_button = .remove_controller;
    }

    if (ray.IsKeyPressed(ray.KEY_RIGHT) and
        controller_configuration_state.selected_button == .remove_controller and
        can_add)
    {
        controller_configuration_state.selected_button = .add_controller;
    }

    // if(ray.IsKeyPressed(ray.KEY_UP)) {
    //     switch(controller_configuration_state.selected_button) {
    //         .remove_controller, .add_controller => .back,
    //         .back => .back,
    //         .controller => |n|
    //             if(n == 0)
    //                 if(can_add) state.ControllerConfigurationButton.add_controller
    //                 else state.ControllerConfigurationButton.remove_controller
    //             else state.ControllerConfigurationButton { .controller = n - 1 },
    //     }
    // }
}
