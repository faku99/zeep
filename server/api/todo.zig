const std = @import("std");
const zap = @import("zap");

const Database = @import("../database.zig");

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

fn get(endpoint: *zap.Endpoint, request: zap.Request) void {
    _ = endpoint;

    if (request.path) |path| {
        std.log.debug("path: {s}", .{path});
    }

    // TODO: Return todo's list from database
}
