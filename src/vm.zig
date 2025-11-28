const std = @import("std");
const commands = @import("commands.zig");

const InstructionSet = std.AutoHashMap(commands.CommandType, fn (*State, []const u8) []const u8);

const State = struct {
    running: bool
};

const VM = struct {
    state: State,
    instructionSet: InstructionSet,

    pub fn Init(instructionSet: InstructionSet) VM {
        return .{
            .instructionSet = instructionSet,
            .state = .{
                .running = false,
            }
        };
    }

    pub fn start(self: VM) void {
        self.state.running = true;
    }

    pub fn stop(self: VM) void {
        self.isRunning = false;
    }

    pub fn exec(self: VM,command: commands.Command) []const u8 {
        const runner = self.commandRunner.get(command.kind);
        return runner(self, command.args);
    } 

    pub fn CommandExit(self: VM, _: []const u8) []const u8 {
        self.isRunning = false;
        return "Exit";
    }
};

const defaultInstructionSet = (fn() InstructionSet {

})();

