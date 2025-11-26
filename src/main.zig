const std = @import("std");
const eql = std.mem.eql;

const Command = @import("./commands.zig");

const version = "0.0.1";

pub fn main() !void {
    const debug = std.debug;
    const stdin = std.fs.File.stdin();
    var state: Command.State = .{
        .root = "root",
        .isRunning = true
    };

    debug.print("Welcome to Zephyr v{s}\n\n", .{version});
    while (state.isRunning) {

        debug.print("[{s}] >> ", .{state.root});

        var buffer: [255]u8 = undefined;
        const bytes_read = try stdin.deprecatedReader().readUntilDelimiterOrEof(&buffer, '\n');

        if (bytes_read) |slice| {
            var iter = std.mem.splitScalar(u8, slice, ' ');
            const rawCommand: Command.RawCommand = .{
                .name = iter.next() orelse "unknown",
                .args = &.{iter.next() orelse "unknown"}
            };

            const command = rawCommand.parse();

            state = command.Run(state);
        } else {
            state.isRunning = false;
        }
    }

    std.debug.print("\n\nBye!\n", .{});

}
