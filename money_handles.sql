-- Function to deposit funds into an account
CREATE OR REPLACE FUNCTION deposit_funds(p_account_id INT, p_deposit_amount NUMERIC)
RETURNS VOID AS $$
BEGIN
    -- Update the account's balance by adding the deposit amount
    UPDATE accounts
    SET balance = balance + p_deposit_amount
    WHERE accounts.account_id = p_account_id; 
    
    -- Insert a new transaction record for the deposit
    INSERT INTO transactions (account_id, amount, transaction_type, transaction_date)
    VALUES (p_account_id, p_deposit_amount, 'Deposit', NOW());  
END;
$$ LANGUAGE plpgsql;

-- Function to withdraw funds from an account
CREATE OR REPLACE FUNCTION withdraw_funds(p_account_id INT, p_withdrawal_amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- Check if there is enough balance in the account
    IF (SELECT balance FROM accounts WHERE account_id = p_account_id) < p_withdrawal_amount THEN
        -- If insufficient balance, raise an exception
        RAISE EXCEPTION 'Insufficient balance';
    END IF;

    -- Update the account's balance by subtracting the withdrawal amount
    UPDATE accounts
    SET balance = balance - p_withdrawal_amount
    WHERE account_id = p_account_id;

    -- Insert a new transaction record for the withdrawal
    INSERT INTO transactions (account_id, transaction_type, amount, description)
    VALUES (p_account_id, 'Withdrawal', p_withdrawal_amount, 'Withdrawal from account');
END;
$$ LANGUAGE plpgsql;

-- Function to transfer funds between two accounts
CREATE OR REPLACE FUNCTION transfer_funds(p_from_account INT, p_to_account INT, p_transfer_amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    -- First, withdraw the transfer amount from the source account
    PERFORM withdraw_funds(p_from_account, p_transfer_amount);
    
    -- Then, deposit the transfer amount into the target account
    PERFORM deposit_funds(p_to_account, p_transfer_amount);

    -- Insert a transaction record for the transfer from the source account
    INSERT INTO transactions (account_id, transaction_type, amount, related_account, description)
    VALUES (p_from_account, 'Transfer', p_transfer_amount, p_to_account, 'Transfer to another account');
END;
$$ LANGUAGE plpgsql;

-- Query to summarize account balances by customer
SELECT c.name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.name;

-- Function to calculate interest on a loan
CREATE OR REPLACE FUNCTION calculate_interest(p_loan_id INT)
RETURNS VOID AS $$
DECLARE
    rate DECIMAL;
    principal DECIMAL;
BEGIN
    -- Get the interest rate and principal balance for the specified loan
    SELECT interest_rate, balance INTO rate, principal
    FROM loans WHERE loan_id = p_loan_id;

    -- Update the loan balance by adding the interest
    UPDATE loans
    SET balance = balance + (principal * rate / 100)
    WHERE loan_id = p_loan_id;
END;
$$ LANGUAGE plpgsql;

-- Query to identify suspicious transactions (over a threshold amount)
SELECT transaction_id, account_id, amount, transaction_date
FROM transactions
WHERE amount > 10000;

-- Function to log suspicious transactions (e.g., over $10,000)
CREATE OR REPLACE FUNCTION log_suspicious_transaction() 
RETURNS TRIGGER AS $$
BEGIN
    -- If the transaction amount is over $10,000, flag it as suspicious
    IF NEW.amount > 10000 THEN
        -- Insert a record into the suspicious_activity table with the flagged transaction details
        INSERT INTO suspicious_activity (transaction_id, flagged_at, reason)
        VALUES (NEW.transaction_id, CURRENT_TIMESTAMP, 'High amount');
    END IF;
    -- Return the transaction to continue normal processing
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the log_suspicious_transaction function after each transaction is inserted
CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION log_suspicious_transaction();

