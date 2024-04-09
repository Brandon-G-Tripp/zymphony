const std = @import("std");

pub const LogLevel = enum {
    debug,
    info,
    warning,
    err,
};

pub fn log(comptime level: LogLevel, comptime fmt: []const u8, args: anytype) void {
    const stderr = std.io.getStdErr().writer();
    const prefix = switch (level) {
        .debug => "[DEBUG] ",
        .info => "[INFO] ",
        .warning => "[WARNING] ",
        .err => "[ERROR] ",
    };

    stderr.print(prefix ++ fmt ++ "\n", args) catch {};
}

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    log(.debug, fmt, args);
}

pub fn info(comptime fmt: []const u8, args: anytype) void {
    log(.info, fmt, args);
}

pub fn warn(comptime fmt: []const u8, args: anytype) void {
    log(.warning, fmt, args);
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    log(.err, fmt, args);
}
