const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dotenv = b.dependency("dotenv", .{
        .optimize = optimize,
        .target = target,
    });

    const sqlite = b.dependency("sqlite", .{});

    const zap = b.dependency("zap", .{
        .openssl = false,
        .optimize = optimize,
        .target = target,
    });

    const exe = b.addExecutable(.{
        .name = "zeep",
        .root_source_file = b.path("server/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("dotenv", dotenv.module("dotenv"));
    exe.root_module.addImport("sqlite", sqlite.module("sqlite"));
    exe.root_module.addImport("zap", zap.module("zap"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // if (b.args) |args| {
    //     run_cmd.addArgs(args);
    // }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
