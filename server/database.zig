const sqlite = @import("sqlite");
const std = @import("std");

const Todo = @import("models.zig").Todo;

pub const Database = struct {
    _db: sqlite.Db = undefined,

    const Self = @This();

    pub fn init() !Self {
        const db = try sqlite.Db.init(.{
            .open_flags = .{ .write = true },
        });

        var self = Self{
            ._db = db,
        };

        // WARNING: Development only!
        try self.populate();

        return self;
    }

    pub fn deinit(self: *Self) void {
        self._db.deinit();
    }

    // WARNING: Development only!
    fn populate(self: *Self) !void {
        // Create and insert some data in 'todo' table
        try self._db.exec("CREATE TABLE todo (id TEXT PRIMARY KEY, title TEXT)", .{}, .{});
        try self._db.exec("INSERT INTO todo (id, title) VALUES ('1', 'TODO #1')", .{}, .{});
        try self._db.exec("INSERT INTO todo (id, title) VALUES ('2', 'TODO #2')", .{}, .{});
    }

    pub fn fetchTodos(self: *Self, allocator: std.mem.Allocator) ![]Todo {
        var query = try self._db.prepare("SELECT * FROM todo");
        defer query.deinit();

        return query.all(Todo, allocator, .{}, .{});
    }
};
