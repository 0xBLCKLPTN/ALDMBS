use uuid::Uuid;
use std::collections::HashMap;

#[derive(Debug)]
enum TSTATUS {
    PENDING,
    DONE,
    ERROR,
    EXECUTING,
}

#[derive(Debug)]
pub struct Transaction {
    pub transaction_id: String,
    pub transaction_cmd: String,
    pub executor_id: String,
    pub fact_executor_id: String,
    pub status: TSTATUS,
    pub client_id: String,
}

impl Transaction {
    pub fn init(transaction_cmd: &str, executor_id: &str, client_id: String) -> std::io::Result<Transaction> {
        let transaction_id: String = Uuid::new_v4().to_string();
        let executor_id: String = executor_id.to_string();
        let mut fact_executor_id: String = String::new();
        let mut status = TSTATUS::PENDING;

        Ok(Transaction {
            transaction_id,
            transaction_cmd: transaction_cmd.to_string(),
            executor_id: executor_id.to_string(),
            fact_executor_id,
            status,
            client_id,
        })
    }

    pub fn change_status(&mut self, status: TSTATUS) { 
        self.status = status;
    }
}
#[derive(Debug)]
pub struct Database {
    pub name: String,
    pub tables: Vec<String>,
    pub engine: String,
}

impl Database {
    pub fn init(name: &str, engine: &str) -> std::io::Result<Database> {
        let mut tables: Vec<String> = vec![];
        let engine: String = engine.to_string();
        Ok(Database {name:name.to_string(), tables, engine})
    }
    pub fn create_table(&mut self, tablename: &str) {
        self.tables.push(tablename.to_string());
    }
}
#[derive(Debug)]
pub struct Instance {
    pub instance_id: String,
    pub databases: HashMap<String, Database>,
}

impl Instance {
    pub fn init() -> std::io::Result<Instance> {
        let instance_id: String = Uuid::new_v4().to_string();
        let mut databases: HashMap<String, Database> = HashMap::new();
        
        Ok(Instance {
            instance_id,
            databases,
        })
    }

    pub fn create_database(&mut self, database_name: &str, database_engine: &str) {
        self.databases.insert(database_name.to_string(), Database::init(&database_name, database_engine).unwrap());
        println!("Creating new database with name {} and engine - {}", database_name, database_engine);
    }

    pub fn delete_database(&mut self, database_name: String) {
        println!("Deleting database.");
    }

    pub fn create_table(&self, database_name: &str, table_name: &str) {
        
    }
    pub fn execute_transaction(&self, transaction: &Transaction) -> TSTATUS {
        return TSTATUS::DONE;
    }
}



fn main() {
    let mut instance = Instance::init().unwrap();
    instance.create_database("database1", "kv_engine");

}
