const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

pub const UIState = struct {
    screen: UIScreen,
    controllers: []Controller,
};

pub const Controller = union(enum) {
    player: *PlayerController,
    calculo: *CalculoController,
};

pub const PlayerController = struct {};
pub const CalculoController = struct {};

pub const UIScreen = union(enum) {
    main_menu: *MainMenuState,
    controller_configuration: *ControllerConfigurationState,
    character_select: *CharacterSelectState,
    battle: *BattleState,
};

pub const MainMenuState = struct {
    selected_button: MainMenuButton,
};

pub const MainMenuButton = enum {
    go,
    configure_controllers,
};

pub const ControllerConfigurationState = struct {
    selected_button: ControllerConfigurationButton,
};

pub const ControllerConfigurationButton = union(enum) {
    back, remove_controller, add_controller, controller: u2
};

pub const CharacterSelectState = struct {};

pub const BattleState = struct {
    players: []BattlePlayer,
};

pub const BattlePlayer = struct {
    board: puyo.Board,
    score: u32,
};

pub fn init_main_menu(alloc: *std.mem.Allocator, state: *UIState) !void {
    const new_main_menu = try alloc.create(MainMenuState);
    new_main_menu.* = MainMenuState{
        .selected_button = .configure_controllers,
    };
    const no_controllers = try alloc.alloc(Controller, 0);
    state.* = UIState{
        .screen = UIScreen{ .main_menu = new_main_menu },
        .controllers = no_controllers,
    };
}

pub fn main_menu_to_controller_configuration(alloc: *std.mem.Allocator, state: *UIState) !void {
    alloc.destroy(state.*.screen.main_menu);
    const new_screen = try alloc.create(ControllerConfigurationState);
    new_screen.* = ControllerConfigurationState{
        .selected_button = if (state.controllers.len >= 4) .back else .add_controller,
    };
    state.*.screen = UIScreen{ .controller_configuration = new_screen };
}

pub fn controller_configuration_to_main_menu(alloc: *std.mem.Allocator, state: *UIState) !void {
    alloc.destroy(state.*.screen.controller_configuration);
    const new_screen = try alloc.create(MainMenuState);
    new_screen.* = MainMenuState{
        .selected_button = .configure_controllers,
    };
    state.*.screen = UIScreen{ .main_menu = new_screen };
}
