const std = @import("std");
const zap = @import("zap");

const ApiEndpoint = @import("api.zig").ApiEndpoint;
const Config = @import("config.zig").Config;
const Database = @import("database.zig").Database;

fn onRequest(req: zap.Request) void {
    // Disable caching
    req.setHeader("Cache-Control", "no-cache") catch unreachable;

    req.setStatus(zap.StatusCode.not_found);
    req.sendBody("Not Found") catch |e| {
        std.log.err("Unable to serve 404 page: {any}\n", .{e});
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer switch (gpa.deinit()) {
        .leak => @panic("Memory leak!"),
        .ok => {},
    };

    const allocator = gpa.allocator();

    // Load configuration
    var config = try Config.init(allocator);
    defer config.deinit();

    std.debug.print("{s}", .{config});

    var listener = zap.Endpoint.Listener.init(allocator, .{
        .port = config.port,
        .on_request = onRequest,
        .public_folder = config.static_dir,
        .log = true,
    });
    defer listener.deinit();

    var api_endpoint = ApiEndpoint.init("/api");
    try listener.register(api_endpoint.endpoint());

    try listener.listen();

    std.debug.print("Listening on http://0.0.0.0:{d}\n", .{config.port});

    var db = try Database.init();
    defer db.deinit();

    const todo_list = try db.fetchTodos(allocator);
    std.debug.print("todo_list: {any}\n", .{todo_list});

    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
