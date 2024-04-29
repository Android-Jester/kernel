const VGA_WIDTH = 600;
const VGA_HEIGHT = 400;
var terminal_row: usize = 0;
var terminal_column: usize = 0;
var terminal_color: VGA_COLOR = VGA_COLOR.VGA_COLOR_BLACK;
var terminal_buffer: [*]u8 = 0xB8000;
const VGA_COLOR = enum {
    VGA_COLOR_BLACK,
    VGA_COLOR_BLUE,
    VGA_COLOR_GREEN,
    VGA_COLOR_CYAN,
    VGA_COLOR_RED,
    VGA_COLOR_MAGENTA,
    VGA_COLOR_BROWN,
    VGA_COLOR_LIGHT_GREY,
    VGA_COLOR_DARK_GREY,
    VGA_COLOR_LIGHT_BLUE,
    VGA_COLOR_LIGHT_GREEN,
    VGA_COLOR_LIGHT_CYAN,
    VGA_COLOR_LIGHT_RED,
    VGA_COLOR_LIGHT_MAGENTA,
    VGA_COLOR_LIGHT_BROWN,
    VGA_COLOR_WHITE,
};

fn vga_entry_color(foreground: VGA_COLOR, background: VGA_COLOR) !VGA_COLOR {
    const foregroundColor = @intFromEnum(foreground);
    const backgroundColor = @intFromEnum(background);
    const result = foregroundColor | backgroundColor;
    return @as(u4, result) <<| 4;
}
fn vga_entry(uc: u8, color: u8) !u8 {
    return uc | color << 8;
}

fn initialize() !void {
    terminal_row = @as(usize, 0);
    terminal_column = @as(usize, 0);
    terminal_color = try vga_entry_color(VGA_COLOR.VGA_COLOR_LIGHT_GREY, VGA_COLOR.VGA_COLOR_BLACK);
    for (0..VGA_HEIGHT) |y| {
        for (0..VGA_WIDTH) |x| {
            const index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(0x00, terminal_color);
        }
    }
}

fn put_entry_at(c: u8, color: VGA_COLOR, x: usize, y: usize) !void {
    const index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}

fn put_char(c: u8) !void {
    put_entry_at(c, terminal_color, terminal_column, terminal_row);
    if (terminal_column + 1 == VGA_WIDTH) {
        terminal_column = 0;
        if (terminal_row + 1 == VGA_HEIGHT) {
            terminal_row = 0;
        }
    }
}

fn write_buf(data: [*]u8, size: usize) void {
    for (0..size) |i| {
        put_char(data[i]);
    }
}

fn write_string(data: [*]u8) void {
    write_buf(data, data.len);
}

pub export fn kmain() void {
    initialize();
    write_string("Hello World\n");
}
