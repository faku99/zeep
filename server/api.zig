const zap = @import("zap");

pub const ApiEndpoint = struct {
    _endpoint: zap.Endpoint = undefined,

    const Self = @This();

    pub fn init(path: []const u8) Self {
        return .{
            ._endpoint = zap.Endpoint.init(.{
                .path = path,
                .get = get,
            }),
        };
    }

    pub fn endpoint(self: *Self) *zap.Endpoint {
        return &self._endpoint;
    }

    fn get(ep: *zap.Endpoint, request: zap.Request) void {
        const self: *Self = @fieldParentPtr("_endpoint", ep);
        _ = self;

        return request.sendJson("{ \"response\": \"OK\" }") catch |e| {
            return request.sendError(e, if (@errorReturnTrace()) |t| t.* else null, 505);
        };
    }
};
