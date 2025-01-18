import std.stdio;
import transaction;
import std.format;

struct InstanceAdditionalInfo
{
    string name;
    this(string name) { this.name = name; }
}

class Instance
{
    InstanceAdditionalInfo info;

    this(string name) {
        this.info = InstanceAdditionalInfo(name);
    }

    Transaction execute_cmd(Transaction transaction)
    {
        writeln(format("Executing transaction:\nCMD: %s\n", transaction.cmd));
        transaction.change_status(STATUS_E.DONE);
        return transaction;
    }

}

class InstanceManager
{
    Instance[] instances;

    void create_instance(string name)
    {
        instances ~= new Instance(name);
    }

    Instance get_instance(string name)
    {
        foreach (instance; instances)
        {
            if (instance.info.name == name) {
                return instance;
            }
        }
        return null;
    }

    Transaction execute_transaction(Transaction transaction)
    {
        Instance instance = this.get_instance(transaction.tid);
        if (instance is null)
        {
            transaction.change_status(STATUS_E.ERROR);
            return transaction;
        }
        transaction = instance.execute_cmd(transaction);
        return transaction;
    }
}