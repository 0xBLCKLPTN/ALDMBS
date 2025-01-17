/*
  Filename: transaction.d

  Description:
      All structs and methods for dbms transactions.
  
  Imports:
    - std
      - stdio, uuid
  
  Structs and methods:
    - Transaction ( STATUS_E, string, string ) -> Transaction
      - this ( STATUS_E, string, string ) -> Transaction
      - change_status( STATUS_E ) -> void

    - TransactionManager ( ) -> TransactionManager
      - add_transaction( Transaction ) -> void
      - get_transaction ( string ) -> Transaction
      - transactions_count () -> ulong

  Copyright: Copyright © 2025, Даниил Ермолаев
  License: MIT
*/

import std.stdio;
import std.uuid;

// STATUS OF TRANSACTION
enum STATUS_E {PLACED = 0, DONE = 1, ERROR = 2}

// Transaction for every Alice Database command.
struct Transaction
{
    STATUS_E status;
    string to_instance_id;
    string transaction_cmd;
    string transaction_id;

    this(STATUS_E status, string to_instance_id, string transaction_cmd)
    {
      this.status = status;
      this.to_instance_id = to_instance_id;
      this.transaction_cmd = transaction_cmd;
      this.transaction_id = randomUUID().toString();
    }

    void change_status(STATUS_E status)
    {
      this.status = status;
    }

}

struct TransactionManager
{
    Transaction[] transactions;

    void add_transaction(Transaction transaction)
    {
        this.transactions ~= transaction;
    }

    Transaction get_transaction(string transaction_id)
    {
      foreach(transaction; this.transactions)
      {
        if (transaction.transaction_id == transaction_id) { return transaction; }
      }
      assert(0);
    }
    
    ulong transactions_count() {
      return this.transactions.length;
    }
}
