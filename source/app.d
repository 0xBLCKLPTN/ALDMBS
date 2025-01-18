import std.stdio;
import std.logger;
import transaction;
import instance_manager;


void main()
{
    TransactionManager manager;
    Transaction t1 = Transaction(STATUS_E.PLACED, "instance1", "cmd1");
    Transaction t2 = Transaction(STATUS_E.DONE, "instance2", "cmd2");

    manager.add_transaction(t1);
    manager.add_transaction(t2);

    writeln("Transaction 1 ID: ", t1.tid);
    writeln("Transaction 2 ID: ", t2.tid);
    writeln("Total transactions: ", manager.transactions_count());


    InstanceManager im = new InstanceManager();
    im.create_instance("instance4");
    im.execute_transaction(t1);
}