//  Filename: transaction.zig
//
//  Description:
//      All structs and methods for dbms transactions.
//
//  Shortcuts:
//    - std
//    - uuid.zig
//
//    - pub const struct Transaction:
//      - enum transaction_status { obj, obj, obj }
//      - pub init([]const u8, []const u8) -> !Transaction
//      - pub print(Transaction) -> !void
//      - pub set_as_error(Transaction) -> !void
//      - pub set_as_done(Transaction) -> !void
//
//    - status_to_string(enum) -> []const u8
//
//    - pub const struct TransactionManager:
//      - pub init(*Allocator) -> !TransactionManager
//      - pub add_transaction(*TransactionManager, Transaction) -> !void
//      - pub print_all_transactions(*TransactionManager) -> !void
//
//
//
//  Copyright: Copyright © 2025, Даниил Ермолаев
//  License: MIT

const std = @import("std");
const UUID = @import("uuid.zig").UUID;

pub const Transaction = struct {
    transaction_id: UUID,
    transaction_cmd: []const u8,
    for_instance_id: []const u8,
    status: transaction_status,

    const transaction_status = enum { PENDING, DONE, ERROR };

    pub fn init(transaction_cmd: []const u8, for_instance_id: []const u8) !Transaction {
        return Transaction{
            .transaction_cmd = transaction_cmd,
            .transaction_id = UUID.init(),
            .for_instance_id = for_instance_id,
            .status = transaction_status.PENDING,
        };
    }

    pub fn print(self: Transaction) !void {
        std.debug.print("@-- Transaction: {s} --\n", .{self.transaction_id});
        std.debug.print("| Command: {s}\n", .{self.transaction_cmd});
        std.debug.print("| For Instance: {s}\n", .{self.for_instance_id});
        std.debug.print("| Status: {s}\n", .{status_to_string(self.status)});
        std.debug.print("-----END-------\n", .{});
    }

    pub fn set_as_error(self: *Transaction) void {
        self.status = transaction_status.ERROR;
    }

    pub fn set_as_done(self: *Transaction) void {
        self.status = transaction_status.DONE;
    }
};

fn status_to_string(status: Transaction.transaction_status) []const u8 {
    return switch (status) {
        Transaction.transaction_status.PENDING => "PENDING",
        Transaction.transaction_status.DONE => "DONE",
        Transaction.transaction_status.ERROR => "ERROR",
    };
}

pub const TransactionManager = struct {
    transactions: std.ArrayList(Transaction),

    pub fn init(allocator: *std.mem.Allocator) !TransactionManager {
        return TransactionManager{
            .transactions = std.ArrayList(Transaction).init(allocator.*),
        };
    }

    pub fn add_transaction(self: *TransactionManager, transaction: Transaction) !void {
        try self.transactions.append(transaction);
    }

    pub fn print_all_transactions(self: *TransactionManager) !void {
        for (self.transactions.items) |transaction| {
            transaction.print() catch {};
        }
    }
};
