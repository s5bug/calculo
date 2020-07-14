const hash_map = @import("std").hash_map;
const chm = @import("comptime_hash_map.zig");

pub fn AutoComptimeGrouping(comptime I: type, comptime K: type) type {
    return ComptimeGrouping(I, K, hash_map.getAutoHashFn(I), hash_map.getAutoEqlFn(I), hash_map.getAutoHashFn(K), hash_map.getAutoEqlFn(K));
}

pub fn ComptimeGrouping(comptime I: type, comptime K: type, comptime ihash: fn (ind: I) u32, comptime ieql: fn (a: I, b: I) bool, comptime khash: fn (key: K) u32, comptime keql: fn (a: K, b: K) bool) type {
    return struct {
        groups: chm.ComptimeHashMap(I, chm.ComptimeHashMap(K, void, khash, keql), ihash, ieql),
        entries: chm.ComptimeHashMap(K, I, khash, keql),

        pub fn init(comptime values: anytype) @This() {
            const exports = comptime blk: {
                var groups_tuple = (struct {
                    tuple: anytype = .{},
                }){};
                var entries_tuple = (struct {
                    tuple: anytype = .{},
                }){};
                var group_index = 0;
                for (values) |group| {
                    var group_set = (struct {
                        tuple: anytype = .{},
                    }){};
                    for (group) |group_entry| {
                        group_set.tuple = group_set.tuple ++ .{.{ group_entry, {} }};
                        entries_tuple.tuple = entries_tuple.tuple ++ .{.{ group_entry, group_index }};
                    }

                    groups_tuple.tuple = groups_tuple.tuple ++ .{.{ group_index, chm.ComptimeHashMap(K, void, khash, keql).init(group_set.tuple) }};

                    group_index += 1;
                }
                break :blk .{
                    .groups = groups_tuple.tuple,
                    .entries = entries_tuple.tuple,
                };
            };

            return @This(){
                .groups = chm.ComptimeHashMap(I, chm.ComptimeHashMap(K, void, khash, keql), ihash, ieql).init(exports.groups),
                .entries = chm.ComptimeHashMap(K, I, khash, keql).init(exports.entries),
            };
        }
    };
}

const testing = @import("std").testing;

test "comptime grouping" {
    const i = AutoComptimeGrouping(u2, [2]u8).init(.{
        .{[2]u8{ 0, 0 }},
        .{[2]u8{ 0, 1 }},
    });

    testing.expectEqual(@as(u2, 0), i.entries.get([2]u8{ 0, 0 }).?.*);
    testing.expectEqual(@as(u2, 1), i.entries.get([2]u8{ 0, 1 }).?.*);
    testing.expect(i.groups.get(0).?.*.has([2]u8{ 0, 0 }));
    testing.expect(i.groups.get(1).?.*.has([2]u8{ 0, 1 }));
}
