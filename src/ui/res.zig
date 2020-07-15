const sdl = @import("sdl2");

pub const PuyoColor = enum {
    red,
    green,
    blue,
    yellow,
    purple,
};

pub const PuyoConnections = packed struct {
    down: bool = false,
    up: bool = false,
    right: bool = false,
    left: bool = false,

    pub fn to_index(self: PuyoConnections) u4 {
        return @bitCast(u4, self);
    }
};

pub const tile_size = 32;

pub fn tilesheet_position_single(color: PuyoColor, connections: PuyoConnections) sdl.Rectangle {
    const horizontal_idx: i32 = connections.to_index();
    const vertical_idx: i32 = switch (color) {
        .red => 0,
        .green => 1,
        .blue => 2,
        .yellow => 3,
        .purple => 4,
    };
    return sdl.Rectangle{
        .x = horizontal_idx * tile_size,
        .y = vertical_idx * tile_size,
        .width = tile_size,
        .height = tile_size,
    };
}

pub fn load_puyo_tilesheet(renderer: sdl.Renderer) !sdl.Texture {
    return sdl.image.loadTexture(renderer, "puyo_tilesheet.png");
}
