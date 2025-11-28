const std = @import("std");
const sdl = @import("sdl.zig").sdl;

pub const CommandHistory = struct {
    commands: []Command
};

pub const CommandType = enum(u8) {
    exit,
    set,
    version,
    add,
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

        if (std.mem.eql(u8, self.name, "set")) {
            return .{
                .kind = .set,
                .args = self.args
            };
        }

        if (std.mem.eql(u8, self.name, "version")) {
            return .{
                .kind = .version,
                .args = null
            };
        }

        if (std.mem.eql(u8, self.name, "add")) {
            return .{
                .kind = .add,
                .args = self.args
            };
        }

        return .{
            .kind = .unknown,
            .args = null
        };
    }
};

pub const State = struct {
    root: []const u8,
    version: []const u8,
    isRunning: bool,
    window: ?*sdl.SDL_Window,
};

pub const Command = struct {
    kind: CommandType,
    args: ?[]const []const u8,
    output: ?[]const u8,

    allocator: std.mem.Allocator = std.heap.page_allocator,

    pub fn Run(self: Command, state : State) State {
        var newState = state;
        switch (self.kind) {
            .exit => {
                newState.isRunning = false;
            },

            .set => {
                const args = self.args orelse unreachable;
                newState.root = args[0];
            },

            .add => {
                const window = sdl.SDL_CreateWindow("Hello", 640, 480, sdl.SDL_WINDOW_OPENGL);
                _ = sdl.SDL_GL_CreateContext(window);
                newState.window = window;
            },

            .version => {
                self.output = state.version;
            },

            .unknown => {
                self.output = "Command Unknown.";
            },
        }

        return newState;
    }
};

test "command format" {
    const cm: RawCommand = .{
        .name = "set",
        .args = &.{"context"}
    };

    const args = cm.args orelse return error.NoArgs;

    try std.testing.expect(std.mem.eql(u8, args[0], "context"));
}

test "command run" {

    const state: State = .{
        .isRunning = true,
        .root = "root"
    };

    const rc: RawCommand = .{
        .name = "exit",
        .args = null
    };

    const cm = rc.parse();

    const newState = cm.Run(state);

    try std.testing.expect(newState.isRunning == false);
}

test "command set" {

    const state: State = .{
        .isRunning = true,
        .root = "root"
    };


    const rc: RawCommand = .{
        .name = "set",
        .args = &.{"context"}
    };

    const cm = rc.parse();

    const newState = cm.Run(state);

    try std.testing.expect(std.mem.eql(u8, newState.root, "context"));
}
