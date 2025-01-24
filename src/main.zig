const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    std.debug.print("Hellow World!\n", .{});

    // Modify from raylib  Basic window example in c:
    // https://github.com/raysan5/raylib/blob/master/examples/core/core_basic_window.c
    ray.InitWindow(800, 450, "Hello Raylib");
    defer {
        ray.CloseWindow();
        std.debug.print("bye.\n", .{});
    }

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);
        ray.DrawText("Hi Raylib", 250, 250, 50, ray.WHITE);
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
