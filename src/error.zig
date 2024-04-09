const std = @import("std");
const logging = @import("logging.zig");

pub const ZymphonyError = error{
    UnknownError,
    FileNoteFound,
    InvalidConfig,
};

pub fn handleError(err: ZymphonyError) void {
    switch (err) {
        ZymphonyError.UnknownError => {
            logging.err("An unknown error occurred.", .{});
        },
        ZymphonyError.FileNoteFound => {
            logging.err("File not found.", .{});
        },
        ZymphonyError.InvalidConfig => {
            logging.err("Invalid configuration.", .{});
        },
    }
}

test "handleError - UnknownError" {
    const expected_output = "[ERROR] An unknown error occurred.\n";

    // Create a pipe to capture stderr output
    const pipe = try std.os.pipe();
    defer std.os.close(pipe[0]);
    defer std.os.close(pipe[1]);

    // Duplicate stderr file descriptor
    const stderr_fd = std.io.getStdErr().handle;
    const dup_stderr_fd = try std.os.dup(stderr_fd);
    defer std.os.close(dup_stderr_fd);

    // Redirect stderr to the write end of the pipe
    try std.os.dup2(pipe[1], stderr_fd);

    // Call handleError with UnknownError
    handleError(ZymphonyError.UnknownError);

    // Restore the original stderr
    try std.os.dup2(dup_stderr_fd, stderr_fd);

    // Read the captured stderr output from the read end of the pipe
    var buffer = std.ArrayList(u8).init(std.testing.allocator);
    defer buffer.deinit();
    try buffer.resize(1024);
    const bytes_read = try std.os.read(pipe[0], buffer.items);
    buffer.items.len = bytes_read;

    // Check if the captured output matches the expected output
    try std.testing.expectEqualStrings(expected_output, buffer.items);
}
