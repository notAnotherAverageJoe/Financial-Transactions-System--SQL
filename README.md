# 💳 Financial Transactions System 🚀

Welcome to the **Financial Transactions System**! This project is a robust and efficient solution for managing financial transactions, deposits, withdrawals, transfers, and interest calculations. 💰🔄 Whether you're managing bank accounts or tracking payments, this system has you covered!

## ✨ Features

- **Deposit Funds** 🏦: Easily deposit funds into an account.
- **Withdraw Funds** 💸: Withdraw funds securely from an account, with sufficient balance checks.
- **Transfer Funds** 🔁: Seamlessly transfer money between accounts.
- **Interest Calculation** 📊: Automatically calculate interest on loans and update balances.
- **Transaction Logging** 📝: Track all transactions, from deposits to withdrawals and transfers.
- **Suspicious Transaction Alerts** 🚨: Automatically flag transactions over a threshold amount (e.g., $10,000) for review.
- **Account Balance Summaries** 📑: Summarize balances for customers.

## 🛠️ Setup

### Prerequisites:

Before you get started, make sure you have the following installed:

- ✅ PostgreSQL (for database)
- ✅ A database client (e.g., pgAdmin, psql, etc.)

### Installation:

1. Clone this repository:

Set up your PostgreSQL database and create the necessary tables (e.g., accounts, transactions, loans, suspicious_activity).

Create the functions and triggers by executing the SQL scripts provided.

Functions Overview:

1. Deposit Funds 💵
   Deposits a specified amount into an account and logs the transaction.
   SQL Function: deposit_funds(p_account_id, p_deposit_amount)
2. Withdraw Funds 💳
   Withdraws an amount from an account after checking for sufficient balance.
   SQL Function: withdraw_funds(p_account_id, p_withdrawal_amount)
3. Transfer Funds 🔄
   Transfers funds between two accounts by calling the deposit and withdraw functions.
   SQL Function: transfer_funds(p_from_account, p_to_account, p_transfer_amount)
4. Calculate Interest 💹
   Calculates and adds interest to a loan balance.
   SQL Function: calculate_interest(p_loan_id)
5. Log Suspicious Transactions 🚨
   Flags transactions exceeding a certain amount (e.g., $10,000) as suspicious.
   SQL Trigger: after_transaction_insert
   Queries:
   Summarize account balances 💳:

sql
Copy code
SELECT c.name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.name;
Identify Suspicious Transactions 🧐:

sql
Copy code
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE amount > 10000;
📚 Documentation
This system includes several important features for managing financial transactions. Below is a brief overview:

💡 Functions:
deposit_funds: Adds funds to an account.
withdraw_funds: Deducts funds from an account, checking if sufficient balance is available.
transfer_funds: Moves funds between two accounts.
calculate_interest: Computes the interest for a loan and updates its balance.
⚠️ Triggers:
after_transaction_insert: Flags suspicious transactions (e.g., transactions over $10,000) for review.
💰 Database Structure:
accounts: Stores account information and balances.
transactions: Logs each financial transaction.
loans: Keeps track of loan details and balances.
suspicious_activity: Logs suspicious transactions flagged by the system.
🎉 Usage
Once everything is set up, you can use the functions for managing transactions:

Deposit funds: Call the deposit_funds() function with account ID and deposit amount.
Withdraw funds: Call the withdraw_funds() function with account ID and withdrawal amount.
Transfer funds: Call the transfer_funds() function with source and destination account IDs and transfer amount.
Calculate interest: Call the calculate_interest() function with loan ID.
