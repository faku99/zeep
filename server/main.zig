const std = @import("std");
const zap = @import("zap");

const Config = @import("config.zig").Config;
const Database = @import("database.zig");

const ApiTodoEndpoint = @import("api/todo.zig");

fn onRequest(req: zap.Request) void {
    // Disable caching
    req.setHeader("Cache-Control", "no-cache") catch unreachable;

    req.setStatus(zap.StatusCode.not_found);
    req.sendBody("Not Found") catch |e| {
        std.log.err("Unable to serve 404 page: {any}\n", .{e});
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .thread_safe = true,
    }){};
    defer switch (gpa.deinit()) {
        .leak => @panic("Memory leak!"),
        .ok => {},
    };

    const allocator = gpa.allocator();

    // Load configuration
    var config = try Config.init(allocator);
    defer config.deinit();
    std.debug.print("{s}", .{config});

    // Instanciate database
    var db = try Database.init();
    defer db.deinit();

    var listener = zap.Endpoint.Listener.init(allocator, .{
        .port = config.port,
        .on_request = onRequest,
        .public_folder = config.static_dir,
        .log = true,
    });
    defer listener.deinit();

    var api_todo_ep = ApiTodoEndpoint.init(allocator, "/api/todo", &db);
    try listener.register(api_todo_ep.getEndpoint());

    try listener.listen();

    std.debug.print("Listening on http://0.0.0.0:{d}\n", .{config.port});

    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
