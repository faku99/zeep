const std = @import("std");
const zap = @import("zap");

const Database = @import("../database.zig");
const utils = @import("../utils.zig");

const Self = @This();

_allocator: std.mem.Allocator = undefined,
_database: *Database = undefined,
_endpoint: zap.Endpoint = undefined,

pub fn init(allocator: std.mem.Allocator, path: []const u8, database: *Database) Self {
    return .{
        ._allocator = allocator,
        ._database = database,
        ._endpoint = zap.Endpoint.init(.{
            .path = path,
            .get = get,
        }),
    };
}

pub fn getEndpoint(self: *Self) *zap.Endpoint {
    return &self._endpoint;
}

fn getList(self: *Self, request: zap.Request) !void {
    const todo_list = try self._database.listTodo(self._allocator);
    defer self._allocator.free(todo_list);

    const json = try std.json.stringifyAlloc(self._allocator, todo_list, .{});
    defer self._allocator.free(json);

    try request.sendJson(json);
}

fn get(endpoint: *zap.Endpoint, request: zap.Request) void {
    const self: *Self = @fieldParentPtr("_endpoint", endpoint);

    if (request.path) |path| {
        const relative_path = std.fs.path.relative(self._allocator, self._endpoint.settings.path, path) catch |e| return utils.return500(@src(), request, e);
        defer self._allocator.free(relative_path);

        // TODO: Use routes map instead of 'if' chain
        if (std.mem.eql(u8, relative_path, "")) {
            self.getList(request) catch |e| return utils.return500(@src(), request, e);
        }
    }

    return utils.return404(request);
}
