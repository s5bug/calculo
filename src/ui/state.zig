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

    pub fn next(self: MainMenuButton) MainMenuButton {
        return switch (self) {
            .go => .configure_controllers,
            .configure_controllers => .go,
        };
    }

    pub fn previous(self: MainMenuButton) MainMenuButton {
        return switch (self) {
            .go => .configure_controllers,
            .configure_controllers => .go,
        };
    }
};

pub const ControllerConfigurationState = struct {
    fill: u8,
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
        .selected_button = .go,
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
        .fill = 0,
    };
    state.*.screen = UIScreen{ .controller_configuration = new_screen };
}
