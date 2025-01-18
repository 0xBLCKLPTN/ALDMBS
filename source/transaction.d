/*
  Filename: transaction.d

  Description:
      All structs and methods for dbms transactions.

  Shortcut:
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
      
    Enumerates:
      - STATUS_E { PLACED, DONE, ERROR }

  Copyright: Copyright © 2025, Даниил Ермолаев
  License: MIT
*/

import std.stdio;
import std.uuid;

// STATUS OF TRANSACTION
enum STATUS_E {PLACED, DONE, ERROR}

// Transaction for every Alice Database command.
struct Transaction
{
    STATUS_E status;  // transaction status.
    string tid;       // this is a instance name. It generated automatically.
    string cmd;       // transaction command that will be executed via instance.
    string uid;       // transaction uuid as string.

    // Default struct or class constructor.
    this(STATUS_E status, string to_instance_id, string transaction_cmd)
    {
      this.status = status;
      this.tid = to_instance_id;
      this.cmd = transaction_cmd;
      this.uid = randomUUID().toString(); // generates and converts UUID type to String.
    }

    // Change transaction status.
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
        if (transaction.tid == transaction_id) { return transaction; }
      }
      assert(0);
    }
    
    ulong transactions_count() {
      return this.transactions.length;
    }
}
