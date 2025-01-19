use uuid::Uuid;

#[derive(Debug)]
enum TYPES {
    Serial(i32),
    I32(i32),
    String(String),
    Uidv4(String),
}

#[derive(Debug)]
pub struct Column {
    pub column_name: String,
    pub datatype: String,
    pub data: Vec<TYPES>,
    pub auto_increment: i32,
    pub primary_key: bool,
}

impl Column {
    pub fn new(column_name: &str, column_type: &str) -> Column {
        let datatype = match column_type {
            "string" => TYPES::String(String::from("")),
            "int" => TYPES::I32(0),
            "serial" => TYPES::Serial(0),
            "uuid_v4" => TYPES::Uidv4(String::from("")),
            _ => panic!("Content type doesn't exist."),
        };
        let data: Vec<TYPES> = vec![];
        let auto_increment = if column_type == "serial" { 1 } else { 0 };
        Column {
            column_name: column_name.to_string(),
            datatype: column_type.to_string(),
            data,
            auto_increment,
            primary_key: false,
        }
    }

    pub fn add_data(&mut self, data: TYPES) {
        if self.datatype == "serial" {
            self.data.push(TYPES::Serial(self.auto_increment));
            self.auto_increment += 1;
        } else if self.datatype == "uuid_v4" {
            self.data.push(TYPES::Uidv4(Uuid::new_v4().to_string()));
        } else {
            self.data.push(data);
        }
    }

    pub fn remove_data(&mut self, index: usize) {
        if index < self.data.len() {
            self.data.remove(index);
            if self.datatype == "serial" {
                self.auto_increment -= 1;
                for (i, data) in self.data.iter_mut().enumerate() {
                    if let TYPES::Serial(ref mut value) = data {
                        *value = (i + 1) as i32;
                    }
                }
            }
        } else {
            panic!("Index out of bounds");
        }
    }

    pub fn edit_data(&mut self, index: usize, new_data: TYPES) {
        if index < self.data.len() {
            self.data[index] = new_data;
        } else {
            panic!("Index out of bounds");
        }
    }
}

#[derive(Debug)]
struct Table {
    pub table_name: String,
    pub column_names: Vec<String>,
    pub columns: Vec<Column>,
    pub primary_key_column: Option<usize>,
}

impl Table {
    pub fn new(table_name: &str) -> Table {
        let columns: Vec<Column> = vec![];
        let column_names: Vec<String> = vec![];

        Table {
            table_name: table_name.to_string(),
            columns,
            column_names,
            primary_key_column: None,
        }
    }

    pub fn add_column(&mut self, column_name: &str, column_type: &str) {
        self.column_names.push(column_name.to_string());
        self.columns.push(Column::new(column_name, column_type));
    }

    pub fn set_primary_key(&mut self, column_name: &str) {
        for (i, column) in self.columns.iter_mut().enumerate() {
            if column.column_name == column_name {
                if self.primary_key_column.is_some() {
                    panic!("Primary key already set");
                }
                column.primary_key = true;
                self.primary_key_column = Some(i);
                return;
            }
        }
        panic!("Column not found");
    }

    pub fn add_row(&mut self, row_data: Vec<TYPES>) {
        if row_data.len() != self.columns.len() {
            panic!("Row data length does not match the number of columns");
        }

        for (i, data) in row_data.into_iter().enumerate() {
            self.columns[i].add_data(data);
        }
    }

    pub fn add_row_simple(&mut self, row_data: Vec<&str>) {
        if row_data.len() != self.columns.len() {
            panic!("Row data length does not match the number of columns");
        }

        let mut typed_data: Vec<TYPES> = Vec::new();
        for (i, data) in row_data.into_iter().enumerate() {
            match self.columns[i].datatype.as_str() {
                "string" => typed_data.push(TYPES::String(data.to_string())),
                "int" => typed_data.push(TYPES::I32(data.parse().expect("Invalid integer value"))),
                "serial" => typed_data.push(TYPES::Serial(0)), // Serial will be handled in add_data
                "uuid_v4" => typed_data.push(TYPES::Uidv4(String::from(""))), // UUID will be handled in add_data
                _ => panic!("Unknown data type"),
            }
        }

        self.add_row(typed_data);
    }

    pub fn remove_row(&mut self, index: usize) {
        if index < self.columns[0].data.len() {
            for column in &mut self.columns {
                column.remove_data(index);
            }
        } else {
            panic!("Index out of bounds");
        }
    }

    pub fn print_table(&self) {
        let mut table_str = String::new();

        // Calculate the maximum length of each column name and data
        let column_widths: Vec<usize> = self.columns.iter().enumerate().map(|(i, column)| {
            let name_len = self.column_names[i].len() + if column.primary_key { 4 } else { 0 };
            let data_len = column.data.iter().map(|data| match data {
                TYPES::I32(value) => value.to_string().len(),
                TYPES::String(value) => value.len(),
                TYPES::Serial(value) => value.to_string().len(),
                TYPES::Uidv4(value) => value.len(),
            }).max().unwrap_or(0);
            name_len.max(data_len)
        }).collect();
        println!("@---TABLE: {} --\n|", self.table_name);
        // Print column names
        for (i, column_name) in self.column_names.iter().enumerate() {
            let pk_marker = if self.columns[i].primary_key { "(PK)" } else { "" };
            table_str.push_str(&format!("| {:<width$} {} ", column_name, pk_marker, width = column_widths[i] - if self.columns[i].primary_key { 4 } else { 0 }));
        }
        table_str.push_str("|\n");

        // Print separator
        for width in &column_widths {
            table_str.push_str(&format!("|{}", "-".repeat(width + 2)));
        }
        table_str.push_str("|\n");

        // Print rows
        let num_rows = self.columns[0].data.len();
        for i in 0..num_rows {
            for (j, column) in self.columns.iter().enumerate() {
                match &column.data[i] {
                    TYPES::I32(value) => table_str.push_str(&format!("| {:<width$} ", value, width = column_widths[j])),
                    TYPES::String(value) => table_str.push_str(&format!("| {:<width$} ", value, width = column_widths[j])),
                    TYPES::Serial(value) => table_str.push_str(&format!("| {:<width$} ", value, width = column_widths[j])),
                    TYPES::Uidv4(value) => table_str.push_str(&format!("| {:<width$} ", value, width = column_widths[j])),
                }
            }
            table_str.push_str("|\n");
        }

        println!("{}", table_str);
    }
}

fn main() {
    let mut table = Table::new("users");
    table.add_column("ID", "uuid_v4");
    table.add_column("Username", "string");
    table.add_column("Password", "string");

    // Set the primary key column
    table.set_primary_key("ID");

    table.add_row_simple(vec!["0", "Alice", "PASS"]);
    table.add_row_simple(vec!["0", "Bob", "PASS"]);

    table.print_table();

    // Remove the first row
    table.remove_row(0);

    println!("After removing the first row:");
    table.print_table();
}
