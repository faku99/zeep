const std = @import("std");

const sqlite = @import("sqlite");

pub const Color = enum {
    Black,
    Red,
};

pub const Todo = struct {
    id: []const u8,
    title: []const u8,
    // notes: []*Note,
    // labels: []*Label,
    // color: Color,
    // checkboxes: bool,
    // user_id: []const u8,

    pub const sqlite_t = struct {
        id: sqlite.Text,
        title: sqlite.Text,
    };

    pub fn fromSqlite(allocator: std.mem.Allocator, in: sqlite_t) !Todo {
        return .{
            .id = try allocator.dupe(u8, in.id.data),
            .title = try allocator.dupe(u8, in.title.data),
        };
    }
};
