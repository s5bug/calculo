const std = @import("std");

const fut = @cImport({
    @cInclude("algae.h");
});

pub const Error = error {
    OutOfMemory,
};

pub const FutConfig = struct {
    ptr: *fut.futhark_context_config,

    pub fn init() Error!@This() {
        var ptr_opt: ?*fut.futhark_context_config = fut.futhark_context_config_new();
        if(ptr_opt) |ptr| {
            return FutConfig {
                .ptr = ptr,
            };
        } else {
            return Error.OutOfMemory;
        }
    }

    pub fn deinit(self: @This()) void {
        fut.futhark_context_config_free(self.ptr);
    }
};

pub const FutContext = struct {
    ptr: *fut.futhark_context,

    pub fn init(cfg: FutConfig) Error!@This() {
        var ptr_opt: ?*fut.futhark_context = fut.futhark_context_new(cfg.ptr);
        if(ptr_opt) |ptr| {
            return FutContext {
                .ptr = ptr,
            };
        } else {
            return Error.OutOfMemory;
        }
    }

    pub fn deinit(self: @This()) void {
        fut.futhark_context_free(self.ptr);
    }
};

pub const FutU82D = struct {
    ctx: FutContext,
    ptr: *fut.futhark_u8_2d,

    pub fn init(ctx: FutContext, data: anytype) Error!FutU82D {
        const T = @TypeOf(data);
        comptime std.debug.assert(std.meta.trait.is(.Pointer)(T));
        const A = std.meta.Child(T);
        comptime std.debug.assert(std.meta.trait.is(.Array)(A));
        const B = std.meta.Child(A);
        comptime std.debug.assert(std.meta.trait.is(.Array)(B));
        const E = std.meta.Child(B);
        comptime std.debug.assert(E == u8);

        const dim0 = @typeInfo(A).Array.len;
        const dim1 = @typeInfo(B).Array.len;

        var ptr_opt: ?*fut.futhark_u8_2d = fut.futhark_new_u8_2d(ctx.ptr, @ptrCast([*]u8, data), dim0, dim1);
        if(ptr_opt) |ptr| {
            return FutU82D {
                .ctx = ctx,
                .ptr = ptr,
            };
        } else {
            return Error.OutOfMemory;
        }
    }

    pub fn deinit(self: @This()) void {
        _ = fut.futhark_free_u8_2d(self.ctx.ptr, self.ptr);
    }
};

pub fn main(ctx: FutContext, out: *f64, in: FutU82D) c_int {
    return fut.futhark_entry_main(ctx.ptr, out, in.ptr);
}
