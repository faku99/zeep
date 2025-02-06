const dotenv = @import("dotenv");
const std = @import("std");

const PORT_DEFAULT = "3000";

const PRODUCTION_KEY = "PRODUCTION";
const STATIC_DIR_KEY = "STATIC_DIR";
const PORT_KEY = "PORT";

pub const Config = struct {
    _allocator: std.mem.Allocator,

    is_production: bool,
    static_dir: ?[]const u8,
    port: u16,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) !Self {
        dotenv.load(allocator, .{}) catch |e| switch (e) {
            std.fs.File.OpenError.FileNotFound => std.log.warn("No .env file found. Using defaults\n", .{}),
            else => return e,
        };

        var env_vars = try std.process.getEnvMap(allocator);
        defer env_vars.deinit();

        const is_production = env_vars.get(PRODUCTION_KEY) != null;
        const static_dir = if (env_vars.get(STATIC_DIR_KEY)) |s| try allocator.dupe(u8, s) else null;
        const port = try std.fmt.parseUnsigned(u16, env_vars.get(PORT_KEY) orelse PORT_DEFAULT, 10);

        return .{
            ._allocator = allocator,
            .is_production = is_production,
            .static_dir = static_dir,
            .port = port,
        };
    }

    pub fn deinit(self: *Self) void {
        if (self.static_dir) |s| self._allocator.free(s);
    }

    pub fn format(config: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try writer.writeAll("Config:\n");
        _ = try writer.print("\tis_production: {s}\n", .{if (config.is_production) "YES" else "NO"});
        _ = try writer.print("\tstatic_dir   : {s}\n", .{if (config.static_dir) |s| s else "NaN"});
        _ = try writer.print("\tport         : {d}\n", .{config.port});
    }
};
