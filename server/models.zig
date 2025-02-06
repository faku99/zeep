const sqlite = @import("sqlite");

pub const Color = enum {
    Black,
    Red,
};

pub const Todo = struct {
    id: sqlite.Text,
    title: sqlite.Text,
    // notes: []*Note,
    // labels: []*Label,
    // color: Color,
    // checkboxes: bool,
    // user_id: []const u8,
};
