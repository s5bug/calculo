const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

pub const UIState = struct {
    screen: UIScreen,
    controllers: ControllerList,
};

pub const ControllerList = std.ArrayList(Controller);

pub const Controller = union(enum) {
    player: PlayerController,
    calculo: CalculoController,
};

pub const PlayerController = struct {
    rotate_left: ?c_int,
    rotate_right: ?c_int,
    move_left: ?c_int,
    move_right: ?c_int,
    soft_drop: ?c_int,
};

pub const CalculoController = struct {};

pub const UIScreen = union(enum) {
    main_menu: *MainMenuState,
    controller_configuration: *ControllerConfigurationState,
    add_controller: *AddControllerState,
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
    parent: *MainMenuState,
    selected_button: ControllerConfigurationButton,
};

pub const ControllerConfigurationButton = union(enum) {
    back: void,
    remove_controller: void,
    add_controller: void,
    controller: usize,
};

pub const AddControllerState = struct {
    parent: *ControllerConfigurationState,
    selected_button: AddControllerButton,
    candidate: Controller,
};

pub const AddControllerButton = enum {
    cancel,
    confirm,
    select_candidate,
    player_rotate_left,
    player_rotate_right,
    player_move_left,
    player_move_right,
    player_soft_drop,
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
    const no_controllers = std.ArrayList(Controller).init(alloc);
    state.* = UIState{
        .screen = UIScreen{ .main_menu = new_main_menu },
        .controllers = no_controllers,
    };
}

pub fn main_menu_to_controller_configuration(alloc: *std.mem.Allocator, state: *UIState) !void {
    const new_screen = try alloc.create(ControllerConfigurationState);
    new_screen.* = ControllerConfigurationState{
        .parent = state.screen.main_menu,
        .selected_button = .back,
    };
    state.screen = UIScreen{ .controller_configuration = new_screen };
}

pub fn controller_configuration_to_main_menu(alloc: *std.mem.Allocator, state: *UIState) !void {
    const controller_configuration_state = state.screen.controller_configuration;
    const parent: *MainMenuState = controller_configuration_state.parent;
    state.screen = UIScreen{ .main_menu = parent };
    alloc.destroy(controller_configuration_state);
}

pub fn controller_configuration_to_add_controller(alloc: *std.mem.Allocator, state: *UIState) !void {
    const new_screen = try alloc.create(AddControllerState);
    new_screen.* = AddControllerState{
        .parent = state.screen.controller_configuration,
        .selected_button = .cancel,
        .candidate = Controller{
            .player = PlayerController{
                .rotate_left = null,
                .rotate_right = null,
                .move_left = null,
                .move_right = null,
                .soft_drop = null,
            },
        },
    };
    state.screen = UIScreen{ .add_controller = new_screen };
}

pub fn add_controller_to_controller_configuration(alloc: *std.mem.Allocator, state: *UIState) !void {
    const add_controller_state = state.screen.add_controller;
    const parent: *ControllerConfigurationState = add_controller_state.parent;
    state.screen = UIScreen{ .controller_configuration = parent };
    alloc.destroy(add_controller_state);
}
