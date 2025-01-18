const std = @import("std");
const Transaction = @import("transaction.zig").Transaction;
const TransactionManager = @import("transaction.zig").TransactionManager;
const Instance = @import("instance.zig").Instance;
const InstanceManager = @import("instance.zig").InstanceManager;

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var manager = try TransactionManager.init(&allocator);

    var transaction1 = try Transaction.init("cmd1", "instance1");
    var transaction2 = try Transaction.init("cmd2", "instance2");

    transaction1.set_as_done();
    transaction2.set_as_error();

    try manager.add_transaction(transaction1);
    try manager.add_transaction(transaction2);

    try manager.print_all_transactions();

    var instance_manager = try InstanceManager.init(&allocator);
    try instance_manager.create_instance("hello instance1");
}
