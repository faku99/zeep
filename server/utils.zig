const std = @import("std");
const zap = @import("zap");

pub fn return404(request: zap.Request) void {
    request.setStatus(zap.StatusCode.not_found);
    request.sendBody("Not Found") catch return;
}

pub fn return500(location: std.builtin.SourceLocation, request: zap.Request, err: anyerror) void {
    std.log.err("{s}:{d} - {any}", .{ location.file, location.line, err });

    request.setStatus(zap.StatusCode.internal_server_error);
    request.sendBody("Internal Server Error") catch return;
}
