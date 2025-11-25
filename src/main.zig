const std = @import("std");
const eql = std.mem.eql;

const Command = @import("./commands.zig");

const version = "0.0.1";

pub fn main() !void {
    const debug = std.debug;
    const stdin = std.fs.File.stdin();
    var running = true;

    var context_buffer: [100]u8 = undefined;
    var context: []const u8 = "";

    debug.print("Welcome to Zephyr v{s}\n\n", .{version});
    while (running) {
        
        if (eql(u8, context, "")) {
          debug.print(">> ", .{});
        } else {
          debug.print("[{s}] >> ", .{context});
        }

        var buffer: [255]u8 = undefined;
        const bytes_read = try stdin.deprecatedReader().readUntilDelimiterOrEof(&buffer, '\n');

        if (bytes_read) |slice| {
            if (eql(u8, slice, "exit")) {
                running = false;
                debug.print("Thanks for using Zephyr!\n", .{});
            }

            if (eql(u8, slice, "version")) {
                debug.print("{s}\n", .{version});
            }

            if (std.mem.startsWith(u8, slice, "set ")) {
                const msg = slice["set ".len..];

                if (eql(u8, msg, "root")) {
                    context = "";
                } else {
                  @memcpy(context_buffer[0..msg.len], msg);
                  context = context_buffer[0..msg.len];
                }
            }
        }
    }

}
