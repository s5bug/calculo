# calculo

Calculo is a Puyo Puyo AI, meant for Puyo Puyo Tetris, heavily based on
_Playing PuyoPuyo: Two Search Algorithms for Constructing Chain and Tactical
Heuristics_ by Kokolo Ikeda, Daisuke Tomizawa, Simon Viennot, and Yuu Tanaka.

## running calculo

If you don't want to install Zig and Futhark, every commit should generate a
debug build in the [Main GitHub Action](https://github.com/sorenbug/calculo/actions?query=workflow%3AMain).

### "raylib not found"

You will need to point your Operating System to Raylib. If your OS has some
package manager with a `raylib` package, that should suffice.

#### without a package manager

Otherwise, download the appropriate archive from
[Raylib's latest release](https://github.com/raysan5/raylib/releases/latest)
according to your OS. Common architectures:
- Windows x64: `raylib-{version}-Win64-msvc15.zip`
- Mac OS x86_64: `raylib-{version}-macOS.tar.gz`
- Linux x86_64: `raylib-{version}-Linux-amd64.tar.gz`

If on Windows, you'll need the `msvc` variant of Raylib, not the `mingw`
variant. All you need to do then is place `raylib.dll` in the same directory
as `calculo.exe`.

If on Mac OS, you'll need to place `libraylib.301.dylib` in the same directory
as `calculo`, and run `LD_LIBRARY_PATH=. ./calculo`.

If on Linux, you'll need to place `libraylib.so.301` in the same directory as
`calculo`, and run `LD_LIBRARY_PATH=. ./calculo`.

## compiling calculo

To compile and run: `zig build run`. Optionally,
`zig build run -Drelease-fast=true`. Compiling calculo requires a working
install of the [Futhark](https://futhark-lang.org/index.html) compiler.
