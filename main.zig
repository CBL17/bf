const std = @import("std");

pub fn main() !void {

    // allocator for argv and file
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // allocate argv
    var args_it = try std.process.argsWithAllocator(allocator);
    args_it.deinit();

    // open file
    _ = args_it.skip();
    const file_path = args_it.next() orelse {
        std.debug.print("File not provided!\n", .{});
        std.process.exit(1);
        unreachable;
    };
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    // alloc space for file in memory
    const buf = try file.readToEndAlloc(allocator, 1000000);
    defer allocator.free(buf);

    // program variables
    var program_memory: [65536]u8 = [_]u8{0} ** 65536;
    var address_ptr: u16 = 0;
    var program_counter: u16 = 0;

    while (program_counter < buf.len) : (program_counter += 1) {
        switch (buf[program_counter]) {
            '>' => address_ptr += 1,
            '<' => address_ptr -= 1,
            '+' => program_memory[address_ptr] +%= 1,
            '-' => program_memory[address_ptr] -%= 1,
            '.' => std.debug.print("{c}", .{program_memory[address_ptr]}),
            // ',' => 1,
            '[' => {
                if (program_memory[address_ptr] == 0) {
                    var pairs_open: u8 = 1;
                    // must move PC past initial '[' so it is not double counted
                    program_counter += 1;
                    while (pairs_open != 0) : (program_counter += 1) {
                        switch (buf[program_counter]) {
                            '[' => pairs_open += 1,
                            ']' => pairs_open -= 1,
                            else => continue,
                        }
                    }
                }
            },
            ']' => {
                if (program_memory[address_ptr] != 0) {
                    var pairs_open: u8 = 1;
                    // must move PC past initial '[' so it is not double counted
                    program_counter -= 1;

                    while (pairs_open != 0) : (program_counter -= 1) {
                        switch (buf[program_counter]) {
                            '[' => pairs_open -= 1,
                            ']' => pairs_open += 1,
                            else => continue,
                        }
                    }
                }
            },
            else => continue,
        }
    }
}
