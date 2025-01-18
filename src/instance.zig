//  Filename: instance.zig
//
//  Description:
//      Instance struct and Instance Manager struct that will be used
//   in db as instances and instance controller.
//
//  Shortcuts:
//    - std
//
//    - pub const struct Instance
//      - pub init([]const u8) -> !Instance
//
//    - pub const struct InstanceManager
//      - pub init(*allocator) -> !InstanceManager
//      - pub create_instance(*InstanceManager, []const u8) -> !void
//      - pub get_instance(*InstanceManager, []const u8) -> ?*const Instance
//      - pub remove_instance(*InstanceManager, []const u8) -> !void
//
//
//
//  Copyright: Copyright © 2025, Даниил Ермолаев
//  License: MIT

const std = @import("std");

pub const Instance = struct {
    instance_name: []const u8,

    pub fn init(name: []const u8) !Instance {
        return Instance{
            .instance_name = name,
        };
    }
};

pub const InstanceManager = struct {
    instances: std.ArrayList(Instance),

    pub fn init(allocator: *std.mem.Allocator) !InstanceManager {
        return InstanceManager{
            .instances = std.ArrayList(Instance).init(allocator.*),
        };
    }
    pub fn create_instance(self: *InstanceManager, instance_name: []const u8) !void {
        const instance = try Instance.init(instance_name);
        try self.instances.append(instance);
    }
    pub fn get_instance(self: *InstanceManager, instance_name: []const u8) ?*const Instance {
        var index: usize = 0;
        while (index < self.instances.len()) {
            const instance = self.instances.items[index];
            if (std.mem.eql(u8, instance.instance_name, instance_name)) {
                return &instance;
            }
            index += 1;
        }
        return null;
    }

    pub fn remove_instance(self: *InstanceManager, instance_name: []const u8) !void {
        var index: usize = 0;
        while (index < self.instances.len()) {
            const instance = self.instances.items[index];
            if (std.mem.eql(u8, instance.instance_name, instance_name)) {
                try self.instances.remove(index);
                return;
            }
            index += 1;
        }
    }
};
