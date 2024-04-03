const std = @import("std");

pub fn main() !void {
    const title: *const [12:0]u8 = "Basic Kernel";
    var videomemptr = 0xb8000;
    var i = 0;
    var j = 0;

    while (j < (80 * 25 * 2)) {
        videomemptr[j] = ' ';
        videomemptr[j + 1] = 0x02;
        j += 2;
    }
    j = 0;
    while (title[j] != null) {
        videomemptr[i] = title[j];
        videomemptr[i + 1] = 0x02;
        j += 1;
        i += 2;
    }
    return;
}
