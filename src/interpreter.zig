const std = @import("std");

pub fn run(source: []const u8) void {
    var tokens = std.mem.tokenizeScalar(u8, source, ' ');

    while (tokens.next()) |token| {
        std.debug.print("token {s} ", .{ token });
    }

    std.debug.print("\n", .{});
}

test "tokenizer" { 
    run("set context");
}

