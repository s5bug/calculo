const std = @import("std");

const puyo = @import("../puyo/puyo.zig");

pub const UIState = union(enum) {
    main_menu: *MainMenuState,
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
    state.* = UIState{
        .main_menu = new_main_menu,
    };
}
