const sqlite = @import("sqlite");
const std = @import("std");

const Todo = @import("models.zig").Todo;

const Self = @This();

_db: sqlite.Database = undefined,

pub fn init() !Self {
    const db = try sqlite.Database.open(.{});

    var self = Self{
        ._db = db,
    };

    // WARNING: Development only!
    try self.populate();

    return self;
}

pub fn deinit(self: *Self) void {
    self._db.close();
}

// WARNING: Development only!
fn populate(self: *Self) !void {
    // Create and insert some data in 'todo' table
    try self._db.exec("CREATE TABLE todo (id TEXT PRIMARY KEY, title TEXT)", .{});
    try self._db.exec("INSERT INTO todo (id, title) VALUES ('1', 'TODO #1')", .{});
    try self._db.exec("INSERT INTO todo (id, title) VALUES ('2', 'TODO #2')", .{});
}

pub const listTodo = @import("database/todo.zig").list;

// pub fn fetchTodos(self: *Self, allocator: std.mem.Allocator) ![]Todo {
//     var todos = std.ArrayList(Todo).init(allocator);

//     const query = try self._db.prepare(
//         struct {},
//         Todo,
//         "SELECT * FROM todo",
//     );
//     defer query.finalize();

//     // try query.bind(.{});
//     // defer query.reset();

//     while (try query.step()) |todo| {
//         std.log.info("id: {s}, title: '{s}'", .{ todo.id.data, todo.title.data });
//         try todos.append(todo);
//     }

//     return todos.toOwnedSlice();
// }
