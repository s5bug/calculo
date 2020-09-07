const std = @import("std");

const puyo = @import("puyo/puyo.zig");

const state = @import("calculo/state.zig");
const provider = @import("calculo/provider.zig");

const algae = @import("algae/algae.zig");

const TestProvider = struct {
    lstate: state.GameState = state.GameState{
        .colors = &[_]puyo.ColorId{ 0, 1, 2, 3 },
        .board = [1][puyo.board_width]puyo.Tile{[1]puyo.Tile{.empty} ** puyo.board_width} ** puyo.board_height,
        .current_piece = state.CurrentPiece{
            .piece = puyo.Piece{
                .drop = puyo.drops.i,
                .colors = &[2]puyo.ColorId{ 1, 2 },
            },
            .rotation = state.PieceRotation.Up,
            .position = [2]u8{ 0, 0 }, // TODO name common positions
        },
        .queue = [2]puyo.Piece{
            puyo.Piece{
                .drop = puyo.drops.i,
                .colors = &[2]puyo.ColorId{ 0, 0 },
            },
            puyo.Piece{
                .drop = puyo.drops.i,
                .colors = &[2]puyo.ColorId{ 2, 3 },
            },
        },
    },
    pub const Self = @This();
    pub fn init(self: *const Self) void {
        std.debug.print("Hello!", .{});
    }
    pub fn pull(self: *const Self) state.GameState {
        return self.lstate;
    }
};

pub fn main() anyerror!void {
    const cfg = try algae.FutConfig.init();
    defer cfg.deinit();
    const ctx = try algae.FutContext.init(cfg);
    defer ctx.deinit();

    const board_data: [2][2]u8 = [_][2]u8 {
        [_]u8 { 0, 1 },
        [_]u8 { 2, 3 },
    };

    const arr = try algae.FutU82D.init(ctx, &board_data);
    defer arr.deinit();

    var out: f64 = 0.0;
    _ = algae.main(ctx, &out, arr);

    std.log.crit("Result: {}", .{ out });
    // var tprovider = TestProvider{};
    // provider.do_thing(tprovider);
    try @import("ui/ui.zig").run(std.heap.c_allocator);
}
