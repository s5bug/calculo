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
            .add_controller => try handle_add_controller(allocator, cur_state),
            else => unreachable,
        }
    }
}

pub fn handle_main_menu(allocator: *std.mem.Allocator, cur_state: *state.UIState) !void {
    const main_menu_state = cur_state.screen.main_menu;

    const can_go = cur_state.controllers.items.len > 0;

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
        switch (main_menu_state.selected_button) {
            .go => unreachable,
            .configure_controllers => try state.main_menu_to_controller_configuration(allocator, cur_state),
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

    const num_controllers = cur_state.controllers.items.len;

    const can_add = num_controllers < 4;
    const can_remove = num_controllers > 0;

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

    const starting_y = 160;
    const gap = 20;
    for (cur_state.controllers.items) |ctrl, idx| {
        const controller_color = switch (controller_configuration_state.selected_button) {
            .controller => |i| if (i == idx) ray.RED else ray.DARKGRAY,
            else => ray.DARKGRAY,
        };

        const controller_size = 20;
        const controller_name: [*:0]const u8 = switch (ctrl) {
            .player => "Player",
            .calculo => "Calculo",
        };
        const controller_text = ray.FormatText("%i: %s", idx + 1, controller_name);
        const controller_offset = @divTrunc(ray.MeasureText(controller_text, controller_size), 2);
        const controller_y = @intCast(c_int, starting_y + (gap * idx));
        ray.DrawText(controller_text, @divTrunc(width, 2) - controller_offset, controller_y, controller_size, controller_color);
    }

    ray.EndDrawing();

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

    if (ray.IsKeyPressed(ray.KEY_UP)) {
        controller_configuration_state.selected_button = switch (controller_configuration_state.selected_button) {
            .remove_controller, .add_controller => .back,
            .back => .back,
            .controller => |cnum| if (cnum == 0) state.ControllerConfigurationButton{ .add_controller = {} } else state.ControllerConfigurationButton{ .controller = cnum - 1 },
        };
    }
    if (ray.IsKeyPressed(ray.KEY_DOWN)) {
        controller_configuration_state.selected_button = switch (controller_configuration_state.selected_button) {
            .back => if (can_add) state.ControllerConfigurationButton{ .add_controller = {} } else state.ControllerConfigurationButton{ .remove_controller = {} },
            .remove_controller => if (num_controllers > 0) state.ControllerConfigurationButton{ .controller = 0 } else state.ControllerConfigurationButton{ .remove_controller = {} },
            .add_controller => if (num_controllers > 0) state.ControllerConfigurationButton{ .controller = 0 } else state.ControllerConfigurationButton{ .add_controller = {} },
            .controller => |cnum| if (num_controllers > (cnum + 1)) state.ControllerConfigurationButton{ .controller = cnum + 1 } else state.ControllerConfigurationButton{ .controller = cnum },
        };
    }
    if (ray.IsKeyPressed(ray.KEY_LEFT) and controller_configuration_state.selected_button == .add_controller and can_remove) {
        controller_configuration_state.selected_button = .remove_controller;
    }
    if (ray.IsKeyPressed(ray.KEY_RIGHT) and controller_configuration_state.selected_button == .remove_controller and can_add) {
        controller_configuration_state.selected_button = .add_controller;
    }

    if (ray.IsKeyPressed(ray.KEY_ENTER)) {
        switch (controller_configuration_state.selected_button) {
            .back => try state.controller_configuration_to_main_menu(allocator, cur_state),
            .add_controller => try state.controller_configuration_to_add_controller(allocator, cur_state),
            .remove_controller => {
                if (num_controllers > 0) {
                    if (num_controllers == 1) {
                        controller_configuration_state.selected_button = .add_controller;
                    }
                    _ = cur_state.controllers.orderedRemove(num_controllers - 1);
                } else unreachable;
            },
            else => unreachable,
        }
    }
}

const ButtonEntry = struct {
    text: [*:0]const u8,
    binding: fn (state.PlayerController) ?c_int,
    button: state.AddControllerButton,
};
fn hc_rl(pc: state.PlayerController) ?c_int {
    return pc.rotate_left;
}
fn hc_rr(pc: state.PlayerController) ?c_int {
    return pc.rotate_right;
}
fn hc_ml(pc: state.PlayerController) ?c_int {
    return pc.move_left;
}
fn hc_mr(pc: state.PlayerController) ?c_int {
    return pc.move_right;
}
fn hc_sd(pc: state.PlayerController) ?c_int {
    return pc.soft_drop;
}
const data = [_]ButtonEntry{
    ButtonEntry{ .text = "Rotate Left", .binding = hc_rl, .button = state.AddControllerButton.player_rotate_left },
    ButtonEntry{ .text = "Rotate Right", .binding = hc_rr, .button = state.AddControllerButton.player_rotate_right },
    ButtonEntry{ .text = "Move Left", .binding = hc_ml, .button = state.AddControllerButton.player_move_left },
    ButtonEntry{ .text = "Move Right", .binding = hc_mr, .button = state.AddControllerButton.player_move_right },
    ButtonEntry{ .text = "Soft Drop", .binding = hc_sd, .button = state.AddControllerButton.player_soft_drop },
};

pub fn handle_add_controller(allocator: *std.mem.Allocator, cur_state: *state.UIState) !void {
    const add_controller_state = cur_state.screen.add_controller;

    ray.BeginDrawing();

    ray.ClearBackground(ray.RAYWHITE);

    const cancel_color = if (add_controller_state.selected_button == .cancel) ray.RED else ray.DARKGRAY;

    const cancel_text = "Cancel";
    const cancel_size = 20;
    ray.DrawText(cancel_text, 20, 20, cancel_size, cancel_color);

    const keybind_size = 20;
    const unset_text = "Unset";
    const unset_width = ray.MeasureText("Unset", keybind_size);
    switch (add_controller_state.candidate) {
        .player => |player_candidate| {
            const player_color = if (add_controller_state.selected_button == .select_candidate) ray.RED else ray.DARKGRAY;

            const player_size = 20;
            const player_text = "Player";
            const player_y = 80;
            const player_offset = @divTrunc(ray.MeasureText(player_text, player_size), 2);
            ray.DrawText(player_text, @divTrunc(width, 2) - player_offset, player_y, player_size, player_color);

            const starting_y = 160;
            const gap = 20;
            inline for (data) |entry, idx| {
                const text: [*:0]const u8 = entry.text;
                const binding: ?c_int = entry.binding(player_candidate);
                const button: state.AddControllerButton = entry.button;

                const text_y: c_int = @intCast(c_int, starting_y + (gap * idx));

                ray.DrawText(text, @divTrunc(width, 3), text_y, keybind_size, ray.DARKGRAY);

                if (binding != null) {
                    const key_text = ray.FormatText("%i", binding.?);
                    const key_width = ray.MeasureText(key_text, keybind_size);
                    ray.DrawText(key_text, @divTrunc(2 * width, 3) - key_width, text_y, keybind_size, ray.GREEN);
                } else {
                    const unused_color = if (add_controller_state.selected_button == button) ray.RED else ray.LIGHTGRAY;
                    ray.DrawText(unset_text, @divTrunc(2 * width, 3) - unset_width, text_y, keybind_size, unused_color);
                }
            }
        },
        .calculo => |calculo_candidate| {
            const calculo_color = if (add_controller_state.selected_button == .select_candidate) ray.RED else ray.DARKGRAY;

            const calculo_size = 20;
            const calculo_text = "Calculo";
            const calculo_y = 80;
            const calculo_offset = @divTrunc(ray.MeasureText(calculo_text, calculo_size), 2);
            ray.DrawText(calculo_text, @divTrunc(width, 2) - calculo_offset, calculo_y, calculo_size, calculo_color);
        },
    }

    const confirm_color = if (add_controller_state.selected_button == .confirm) ray.RED else ray.DARKGRAY;

    const confirm_size = 20;
    const confirm_text = "Confirm";
    const confirm_y = 400;
    const confirm_offset = @divTrunc(ray.MeasureText(confirm_text, confirm_size), 2);
    ray.DrawText(confirm_text, @divTrunc(width, 2) - confirm_offset, confirm_y, confirm_size, confirm_color);

    ray.EndDrawing();

    if (ray.IsKeyPressed(ray.KEY_UP)) {
        add_controller_state.selected_button = switch (add_controller_state.selected_button) {
            .cancel => .cancel,
            .select_candidate => .cancel,
            .player_rotate_left => .select_candidate,
            .player_rotate_right => .player_rotate_left,
            .player_move_left => .player_rotate_right,
            .player_move_right => .player_move_left,
            .player_soft_drop => .player_move_right,
            .confirm => if (add_controller_state.candidate == .player) state.AddControllerButton.player_soft_drop else state.AddControllerButton.select_candidate,
        };
    }

    if (ray.IsKeyPressed(ray.KEY_DOWN)) {
        add_controller_state.selected_button = switch (add_controller_state.selected_button) {
            .cancel => .select_candidate,
            .select_candidate => if (add_controller_state.candidate == .player) state.AddControllerButton.player_rotate_left else .confirm,
            .player_rotate_left => .player_rotate_right,
            .player_rotate_right => .player_move_left,
            .player_move_left => .player_move_right,
            .player_move_right => .player_soft_drop,
            .player_soft_drop => .confirm,
            .confirm => .confirm,
        };
    }

    if (ray.IsKeyPressed(ray.KEY_ENTER)) {
        switch (add_controller_state.selected_button) {
            .cancel => try state.add_controller_to_controller_configuration(allocator, cur_state),
            .select_candidate => {
                add_controller_state.candidate = switch (add_controller_state.candidate) {
                    .player => state.Controller{
                        .calculo = state.CalculoController{},
                    },
                    .calculo => state.Controller{
                        .player = state.PlayerController{
                            .rotate_left = null,
                            .rotate_right = null,
                            .move_left = null,
                            .move_right = null,
                            .soft_drop = null,
                        },
                    },
                };
            },
            .confirm => {
                try cur_state.controllers.append(add_controller_state.candidate);
                try state.add_controller_to_controller_configuration(allocator, cur_state);
            },
            else => unreachable,
        }
    }
}
