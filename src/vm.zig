const std = @import("std");
const commands = @import("commands.zig");

const CommandRunner = fn (*State, []const u8) []const u8;

const State = struct {
    running: bool
};

fn commandExit(state: *State, _: []const u8) []const u8 {
    state.running = false;
    return "Exit";
}

const default_instruction_set = std.StaticStringMap(CommandRunner).initComptime(.{
    .{"exit", commandExit}
});

pub fn VM(comptime instruction_set: std.StaticStringMap(CommandRunner)) type {
    return struct {
        const Self = @This();

        state: State,

        pub fn init() Self {
            return .{
                .state = .{ .running = false }
            };
        }

        pub fn start(self: VM) void {
            self.state.running = true;
        }

        pub fn stop(self: VM) void {
            self.isRunning = false;
        }

        pub fn exec(self: VM,command: commands.Command) []const u8 {
            const runner = instruction_set.get(@tagName(command.kind)) orelse {
                return "Unknown Command";
            };

            return runner(&self.state, command.args);
        }
    };
}


test "Default Instruction set" {
    const DefaultVM = VM(default_instruction_set);
    const vm = DefaultVM.init();

    vm.start();
}

