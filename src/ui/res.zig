const sdl = @import("sdl2");

pub const tile_size = 32;

pub fn load_puyo_tilesheet(renderer: sdl.Renderer) !sdl.Texture {
    return sdl.image.loadTexture(renderer, "puyo_tilesheet.png");
}
