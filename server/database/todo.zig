const std = @import("std");

const Database = @import("../database.zig");
const models = @import("../models.zig");

pub fn list(self: *Database, allocator: std.mem.Allocator) ![]models.Todo {
    var todos = std.ArrayList(models.Todo).init(allocator);

    const query = try self._db.prepare(
        struct {},
        models.Todo.sqlite_t,
        "SELECT * FROM todo",
    );
    defer query.finalize();

    while (try query.step()) |todo| {
        try todos.append(try models.Todo.fromSqlite(allocator, todo));
    }

    return todos.toOwnedSlice();
}
