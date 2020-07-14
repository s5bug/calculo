const puyo = @import("../puyo/puyo.zig");

pub const PieceRotation = enum {
    Up,
    Right,
    Down,
    Left,
};

pub const CurrentPiece = struct {
    piece: puyo.Piece,
    rotation: PieceRotation,
    position: [2]u8, // TODO not sure if this is "correct"
};

pub const GameState = struct {
    colors: []const puyo.ColorId,
    board: puyo.Board,
    current_piece: CurrentPiece,
    queue: [2]puyo.Piece,
};
