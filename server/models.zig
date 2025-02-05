pub const Color = enum {
    Black,
    Red,
};

pub const Todo = struct {
    id: []const u8,
    title: []const u8,
    // notes: []*Note,
    // labels: []*Label,
    // color: Color,
    // checkboxes: bool,
    // user_id: []const u8,
};
