const std = @import("std");

pub const CommandHistory = struct {
    commands: []Command
};

pub const CommandType = enum(u2) {
    exit,
    set,
    version,
    unknown
};

pub const RawCommand = struct {
    name: []const u8,
    args: ?[]const []const u8,

    pub fn parse(self: RawCommand) Command {
        if  (std.mem.eql(u8, self.name, "exit")) {
            return .{
                .kind = .exit,
                .args = null
            };
        }

        return .{
            .kind = .unknown,
            .args = null
        };
    }
};

pub const State = struct {
    isRunning: bool
};

pub const Command = struct {
    kind: CommandType,
    args: ?[]const []const u8,

    pub fn Run(self: Command, state : State) State {
        return switch (self.kind) {
            .exit => .{
                .isRunning = false
            },
            
            else => state
        };
    }
};

test "command format" {
    const c: RawCommand = .{
        .name = "set",
        .args = &.{"context"}
    };

    const args = c.args orelse return error.NoArgs;

    try std.testing.expect(std.mem.eql(u8, args[0], "context"));
}

test "command run" {

    const state: State = .{
        .isRunning = true
    };

    const rc: RawCommand = .{
        .name = "exit",
        .args = null
    };

    const c = rc.parse();

    const newState = c.Run(state);

   try std.testing.expect(newState.isRunning == false);
}
