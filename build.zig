const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "bf",
        .target = b.host,
        .optimize = .Debug,
        .root_source_file = b.path("main.zig"),
    });

    b.installArtifact(exe);
}
