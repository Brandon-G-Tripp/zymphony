const std = @import("std");
const logging = @import("logging.zig");
const zymphony_error = @import("error.zig");

pub fn main() !void {
    logging.info("Zymphony application started.", .{});

    // Example usage of error handling
    var result = someOperation();
    if (result) |value| {
        _ = value;
        //handle success
    } else |err| {
        zymphony_error.handleError(err);
    }
}

fn loadConfig(path: []const u8) !void {
    if (std.mem.eql(u8, path, "config.json")) {
        return zymphony_error.ZymphonyError.FileNotFound;
    } else if (std.mem.eql(u8, path, "invalid.json")) {
        return zymphony_error.ZymphonyError.InvalidConfig;
    } 
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
