## Be sure to complete the full setup!

### Ensure account exists!

```SQL
SELECT \* FROM accounts WHERE account_id = 1;
```

if not then
use the code below!

```SQL
INSERT INTO accounts (account_id, customer_id, balance) VALUES (1, 1, 0.00);
INSERT INTO accounts (account_id, customer_id, balance) VALUES (2, 2, 40.00);
```

### Deposit money function

```sql
SELECT deposit_funds(1, 200.00);

```

### check the balance of the account we deposited money in

```SQL
SELECT balance FROM accounts WHERE account_id = 1;
```

### withdraw money

this will leave 150.00 in the balance

```SQL
SELECT withdraw_funds(1, 50.00);
```

### Check the overdraft protection

should receive ERROR: Insufficient balance

```SQL
SELECT withdraw_funds(1, 500.00);
```

### Testing Transfers Between Accounts with transfer_funds

first make sure there is a second account

```SQL
INSERT INTO accounts (account_id, customer_id, balance) VALUES (2, 1, 50.00);

SELECT transfer_funds(1, 2, 50.00);

SELECT balance FROM accounts WHERE account_id = 2;
SELECT balance FROM accounts WHERE account_id = 1;
```

will return account 2 with 100.00
where account 1 will also be down to 100.00

### Testing Loan Interest Calculation with calculate_interest

First thing is we need to create the loan!

```SQL
INSERT INTO loans (loan_id, customer_id, loan_amount, interest_rate, loan_start_date, loan_due_date, balance)
VALUES (1, 1, 5000.00, 5.0, '2024-01-01', '2025-01-01', 5000.00);

SELECT calculate_interest(1);

SELECT balance FROM loans WHERE loan_id = 1;

```

The balance should have increased by 5% of the original loan balance

### Now we will check the suspicious activity

```SQL
INSERT INTO transactions (account_id, amount, transaction_type, transaction_date)
VALUES (1, 15000.00, 'Deposit', NOW());

SELECT * FROM suspicious_activity;
```

SELECT c.name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.name;
