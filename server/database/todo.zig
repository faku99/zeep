const std = @import("std");

const Database = @import("../database.zig");
const Todo = @import("../models.zig").Todo;

pub fn list(self: *Database, allocator: std.mem.Allocator) void {
    var todos = std.ArrayList(Todo).init(allocator);

    const query = try self._db.prepare(
        struct {},
        Todo,
        "SELECT * FROM todo",
    );
    defer query.finalize();

    while (try query.step()) |todo| {
        std.log.info("id: {s}, title: '{s}'", .{ todo.id.data, todo.title.data });
        try todos.append(todo);
    }

    return todos.toOwnedSlice();
}
