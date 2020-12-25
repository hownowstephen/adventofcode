const std = @import("std");

fn handshake(subject: i32, loopSize: usize) i64 {
    var i: usize = 0;
    var o: i64 = 1;
    while (i < loopSize) {
        o = @mod(o * subject, 20201227);
        i += 1;
    }
    return o;
}

fn findLoopSize(pubKey: i32) usize {
    var i: usize = 0;
    var o: i32 = 1;
    while (true) {
        o = @mod(o * 7, 20201227);
        i += 1;
        if(o == pubKey){
            return i;
        }
    }
    return o;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {}!\n", .{"Dec 25th"});

    try stdout.print("{}\n", .{handshake(7, 8)});
    const loopSize = findLoopSize(9281649);
    try stdout.print("{}\n", .{handshake(9033205, loopSize)});
}