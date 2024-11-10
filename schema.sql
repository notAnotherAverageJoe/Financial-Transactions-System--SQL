

-- CREATE DATABASE banking_system;
-- Create the customer table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT
);
-- Create the account table with a FK from customers table
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    account_type VARCHAR(50) CHECK (account_type IN ('Savings', 'Checking')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- One to Many from Accounts to transactions
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    transaction_type VARCHAR(50) CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')),
    amount DECIMAL(15, 2) CHECK (amount > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    related_account INT, -- For transfers, references the other account involved
    description TEXT
);

CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    loan_amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    loan_start_date DATE NOT NULL,
    loan_due_date DATE NOT NULL,
    balance DECIMAL(15, 2) NOT NULL
);

CREATE TABLE suspicious_activity (
    transaction_id INT,
    flagged_at TIMESTAMP,
    reason TEXT
);


