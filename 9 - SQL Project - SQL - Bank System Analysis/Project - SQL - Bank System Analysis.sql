-- Project: Bank System Analysis

-- PROJECT DESCRIPTION

/*
    Create a denormalized table containing behavioral indicators about the customer, calculated based on transactions 
    and product ownership. The goal is to create features for a potential supervised machine learning model.
    
    Indicators to be created
    Each indicator must be related to the individual id_cliente (client ID).

    -   1st indicator: Age
    -   2nd indicator: Number of outgoing transactions across all accounts
    -   3rd indicator: Number of incoming transactions across all accounts
    -   4th indicator: Amount transacted out across all accounts
    -   5th indicator: Amount transacted in across all accounts
    -   6th indicator: Total number of accounts owned
    -   7th indicator: Number of accounts owned by type (one indicator per type)
    -   8th indicator: Number of outgoing transactions by type (one indicator per type)
    -   9th indicator: Number of incoming transactions by type (one indicator per type)
    -   10th indicator: Amount transacted out by account type (one indicator per type)
    -   11th indicator: Amount transacted in by account type (one indicator per type)
    
*/

# ----------------------------------------------------------------------------------------------------------------

-- PROJECT EXPLORATION
-- Let's see the tables and data stored into them

SELECT
    *
FROM banca.cliente;

SELECT
    *
FROM banca.conto;

SELECT
    *
FROM banca.tipo_conto;

SELECT
    *
FROM banca.transazioni;

SELECT
    *
FROM banca.tipo_transazione;

# ----------------------------------------------------------------------------------------------------------------

-- PROJECT ANALYSIS

/* 
    
    Each client has got more than one bank account:
        - Join key: id_cliente 
        - Tables: 'cliente' - 'conto'
        
    Each bank account has one and only one type bank account associated:
        - Join key: id_tipo_conto
        - Tables: 'conto' - 'tipo_conto'
        
    Each bank account has also more than one transaction associated
        - Join key: id_conto
        - Tables: 'conto' - 'transazioni'
        
    Each transaction has got one and only one type transaction
        - Join key: id_tipo_trans
        - Tables: 'transazioni' - 'tipo_transazioni'
        
    Considering the amount of relationships between tables and the tasks to be done, 
    it could be useful to create a view that combines all tables and the necessary data to complete tasks.
    
*/

-- View that combine all tables between them
DROP VIEW IF EXISTS banca.cliente_transazioni;
CREATE VIEW banca.cliente_transazioni AS
    SELECT
        clt.*,
        ct.id_conto,
        ct.id_tipo_conto,
        tipo_ct.desc_tipo_conto,
        trans.id_tipo_trans,
        trans.importo,
        tipo_trans.desc_tipo_trans,
        tipo_trans.segno
    FROM banca.cliente AS clt
        LEFT JOIN banca.conto AS ct
        ON clt.id_cliente = ct.id_cliente
        INNER JOIN banca.tipo_conto AS tipo_ct
        ON ct.id_tipo_conto = tipo_ct.id_tipo_conto
        INNER JOIN banca.transazioni AS trans
        ON ct.id_conto = trans.id_conto
        INNER JOIN banca.tipo_transazione AS tipo_trans
        ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione;

# ----------------------------------------------------------------------------------------------------------------

-- INDICATOR ANALYSIS: Creation of selects
-- Following the 11th indicators to be created for the project. In particular, every following section contains a query used to
-- retrieve and calculate the behavior indicators of bank client in order to create the final denormalized table.
-- The query create will be included into INSERT istruction.


-- 1st indicator: Age
-- Calculate the 'age' client using an arithmetic operation between dates so select all years and compute 
-- the diff with current year in order to calculate the age.

SELECT 
    clt.nome,
    clt.cognome,
    YEAR(CURRENT_DATE()) - YEAR(clt.data_nascita) AS eta
FROM banca.cliente AS clt;

-- Creation of temporary table: client_age
DROP TEMPORARY TABLE IF EXISTS banca.client_age;
CREATE TEMPORARY TABLE banca.client_age AS
SELECT 
    clt.*,
    YEAR(CURRENT_DATE()) - YEAR(clt.data_nascita) AS age
FROM banca.cliente AS clt;

-- Check temporary table creation
SELECT *
FROM banca.client_age;

# ----------------------------------------------------------------------------------------------------------------

-- 2nd indicator: Number of outgoing transactions across all accounts
-- Count the negative (-) transaction of all accounts taking the tables 'conto', 'transazioni' and 'tipo_transazioni'.
-- Execute the join between the four table involved 'cliente', 'conto', 'transazioni' and 'tipo_transazioni', 
-- considering the relationships between them using the join keys. Select from this join the 'id_cliente' used for grouping
-- the final results and from 'tipo_transazione' the sum of transaction with sign '-'.

-- Solution without View
SELECT
    clt.id_cliente,
    SUM(
        CASE 
            WHEN tipo_trans.segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_transaction
FROM banca.cliente AS clt
    LEFT JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
GROUP BY 1;

-- Solution with view
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_transaction
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_number_outgoing_transaction
DROP TEMPORARY TABLE IF EXISTS banca.client_number_outgoing_transaction;
CREATE TEMPORARY TABLE banca.client_number_outgoing_transaction AS
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_transaction
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_number_outgoing_transaction;

# ----------------------------------------------------------------------------------------------------------------

-- 3rd indicator: Number of incoming transactions across all accounts
-- Count the positive (+) transaction of all accounts taking the tables 'conto', 'transazioni' and 'tipo_transazioni'.
-- Execute the join between the four table involved 'cliente', 'conto', 'transazioni' and 'tipo_transazioni', 
-- considering the relationships between them using the join keys. Select from this join the 'id_cliente' used for grouping
-- the final results and from 'tipo_transazione' the sum of transaction with sign '+'.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
        CASE 
            WHEN tipo_trans.segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_trans
FROM banca.cliente AS clt
    LEFT JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
GROUP BY 1;

-- Solution with view
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_transaction
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_number_incoming_transaction
DROP TEMPORARY TABLE IF EXISTS banca.client_number_incoming_transaction;
CREATE TEMPORARY TABLE banca.client_number_incoming_transaction AS
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_transaction
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_number_incoming_transaction;

# ----------------------------------------------------------------------------------------------------------------

-- 4th indicator: Amount transacted out across all accounts
-- Sum the total amount transacted out, all negative (-) transaction, for each client.
-- Execute the join between the four table involved 'cliente', 'conto', 'transazioni' and 'tipo_transazioni', 
-- considering the relationships between them using the join keys. Select from this join the 'id_cliente' used for grouping
-- the final results and from 'tipo_transazione' the sum of transaction amount with sign '-'.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(trans.importo) AS total_amount_transacted_out
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
WHERE tipo_trans.segno = '-'
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(importo) AS total_amount_transacted_out
FROM banca.cliente_transazioni
WHERE segno = '-'
GROUP BY 1;

-- Creation of temporary table: client_total_amount_transacted_out
DROP TEMPORARY TABLE IF EXISTS banca.client_total_amount_transacted_out;
CREATE TEMPORARY TABLE banca.client_total_amount_transacted_out AS
SELECT
    id_cliente,
    SUM(importo) AS total_amount_transacted_out
FROM banca.cliente_transazioni
WHERE segno = '-'
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_total_amount_transacted_out;

# ----------------------------------------------------------------------------------------------------------------

-- 5th indicator: Amount transacted in across all accounts
-- Sum the total amount transacted out, all positive (+) transaction, for each client.
-- Execute the join between the four table involved 'cliente', 'conto', 'transazioni' and 'tipo_transazioni', 
-- considering the relationships between them using the join keys. Select from this join the 'id_cliente' used for grouping
-- the final results and from 'tipo_transazione' the sum of transaction amount with sign '+'.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(trans.importo) AS total_amount_transacted_in
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
WHERE tipo_trans.segno = '+'
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(importo) AS total_amount_transacted_in
FROM banca.cliente_transazioni
WHERE segno = '+'
GROUP BY 1;

-- Creation of temporary table: client_total_amount_transacted_in
DROP TEMPORARY TABLE IF EXISTS banca.client_total_amount_transacted_in;
CREATE TEMPORARY TABLE banca.client_total_amount_transacted_in AS
SELECT
    id_cliente,
    SUM(importo) AS total_amount_transacted_in
FROM banca.cliente_transazioni
WHERE segno = '+'
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_total_amount_transacted_in;

# ----------------------------------------------------------------------------------------------------------------

-- 6th indicator: Total number of accounts owned
-- Count the total number of accounts owned by each client (id_cliente).
-- Execute the join between tables 'client' and 'conto', and compute the count of each 'id_conto' grouped by 'id_cliente'.

-- Solution without view
SELECT
    clt.id_cliente,
    COUNT(ct.id_conto) AS total_account_owned
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    COUNT(DISTINCT id_conto) AS total_account_owned
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_total_amount_transacted_in
DROP TEMPORARY TABLE IF EXISTS banca.client_total_account_owned;
CREATE TEMPORARY TABLE banca.client_total_account_owned AS
SELECT
    id_cliente,
    COUNT(DISTINCT id_conto) AS total_account_owned
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_total_account_owned;

# ----------------------------------------------------------------------------------------------------------------

-- 7th indicator: Number of accounts owned by type (one indicator per type)
-- Count the total number of accounts owned by each client (id_cliente).
-- Execute the join between tables 'client', 'conto' and 'tipo_conto', and compute the count of each type of account.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
        CASE
            WHEN tipo_ct.desc_tipo_conto = 'Conto Privati' THEN 1
            ELSE 0
        END) AS number_account_type_private,
    SUM(
        CASE
            WHEN tipo_ct.desc_tipo_conto = 'Conto Base' THEN 1
            ELSE 0
        END) AS number_account_type_base,
    SUM(
        CASE
            WHEN tipo_ct.desc_tipo_conto = 'Conto Business' THEN 1
            ELSE 0
        END) AS number_account_type_business,
    SUM(
        CASE
            WHEN tipo_ct.desc_tipo_conto = 'Conto Famiglie' THEN 1
            ELSE 0
        END) AS number_account_type_family
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.tipo_conto AS tipo_ct
    ON ct.id_tipo_conto = tipo_ct.id_tipo_conto
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Privati' THEN 1
            ELSE 0
        END) AS number_account_type_private,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Base' THEN 1
            ELSE 0
        END) AS number_account_type_base,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Business' THEN 1
            ELSE 0
        END) AS number_account_type_business,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Famiglie' THEN 1
            ELSE 0
        END) AS number_account_type_family
FROM (
    SELECT DISTINCT
        id_cliente,
        id_conto,
        desc_tipo_conto
    FROM banca.cliente_transazioni
) AS unique_accounts
GROUP BY 1;

-- Creation of temporary table: client_number_account_type
DROP TEMPORARY TABLE IF EXISTS banca.client_number_account_type;
CREATE TEMPORARY TABLE banca.client_number_account_type AS
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Privati' THEN 1
            ELSE 0
        END) AS number_account_type_private,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Base' THEN 1
            ELSE 0
        END) AS number_account_type_base,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Business' THEN 1
            ELSE 0
        END) AS number_account_type_business,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Famiglie' THEN 1
            ELSE 0
        END) AS number_account_type_family
FROM (
    SELECT DISTINCT
        id_cliente,
        id_conto,
        desc_tipo_conto
    FROM banca.cliente_transazioni
) AS unique_accounts
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_number_account_type;

# ----------------------------------------------------------------------------------------------------------------

-- 8th indicator: Number of outgoing transactions by type (one indicator per type)
-- Count the total number of outgoing transaction by type for each client (id_cliente).
-- Execute the join between tables 'clienti', 'conto', 'transazioni' and 'tipo_transazioni', from them calculate the sum
-- for each type of negative transaction ('Acquisto su Amazon', 'Rata mutuo', 'Hotel', 'Biglietto aereo', 'Supermercato'), the total number.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Acquisto su Amazon' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_amazon,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Rata mutuo' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_mutual,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Hotel' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_hotel,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Biglietto aereo' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_aitplane_ticket,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Supermercato' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_market
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Acquisto su Amazon' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_amazon,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Rata mutuo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_mutual,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Hotel' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_hotel,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Biglietto aereo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_airplane_ticket,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Supermercato' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_market
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_number_outgoing_type_transaction
DROP TEMPORARY TABLE IF EXISTS banca.client_number_outgoing_type_transaction;
CREATE TEMPORARY TABLE banca.client_number_outgoing_type_transaction AS
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Acquisto su Amazon' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_amazon,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Rata mutuo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_mutual,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Hotel' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_hotel,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Biglietto aereo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_airplane_ticket,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Supermercato' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_market
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_number_outgoing_type_transaction;

# ----------------------------------------------------------------------------------------------------------------

-- 9th indicator: Number of incoming transactions by type (one indicator per type)
-- Count the total number of incoming transaction by type for each client (id_cliente).
-- Execute the join between tables 'clienti', 'conto', 'transazioni' and 'tipo_transazioni', from them calculate the sum
-- for each type of positive transaction ('Stipendio', 'Dividenti', 'Pensione'), the total number.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Stipendio' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_salary,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Dividendi' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_bonus,
    SUM(
        CASE
            WHEN tipo_trans.desc_tipo_trans = 'Pensione' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_retirement
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Stipendio' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_salary,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Dividendi' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_bonus,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Pensione' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_retirement
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_number_incoming_type_transaction
DROP TEMPORARY TABLE IF EXISTS banca.client_number_incoming_type_transaction;
CREATE TEMPORARY TABLE banca.client_number_incoming_type_transaction AS
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Stipendio' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_salary,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Dividendi' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_bonus,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Pensione' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_retirement
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_number_incoming_type_transaction;

# ----------------------------------------------------------------------------------------------------------------

-- 10th indicator: Amount transacted out by account type (one indicator per type)
-- Execute the join between all tables involved and calculate the sum of amount of outgoing transactions for each account type.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Privati' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_out_private,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Base' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_out_base,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Business' THEN importo 
			ELSE 0 
		END) AS total_amount_transacted_out_business,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Famiglie' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_out_family
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.tipo_conto AS tipo_ct
    ON ct.id_tipo_conto = tipo_ct.id_tipo_conto
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
WHERE tipo_trans.segno = '-'
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_family
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_total_amount_transacted_out_type
DROP TEMPORARY TABLE IF EXISTS banca.client_total_amount_transacted_out_type;
CREATE TEMPORARY TABLE banca.client_total_amount_transacted_out_type AS
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '-' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_out_family
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_total_amount_transacted_out_type;

# ----------------------------------------------------------------------------------------------------------------

-- 11th indicator: Amount transacted in by account type (one indicator per type)
-- Execute the join between all tables involved and calculate the sum of amount of incoming transactions for each account type.

-- Solution without view
SELECT
    clt.id_cliente,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Privati' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_in_private,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Base' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_in_base,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Business' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_in_business,
    SUM(
		CASE 
			WHEN desc_tipo_conto = 'Conto Famiglie' THEN importo 
            ELSE 0 
		END) AS total_amount_transacted_in_family
FROM banca.cliente AS clt
    INNER JOIN banca.conto AS ct
    ON clt.id_cliente = ct.id_cliente
    INNER JOIN banca.tipo_conto AS tipo_ct
    ON ct.id_tipo_conto = tipo_ct.id_tipo_conto
    INNER JOIN banca.transazioni AS trans
    ON ct.id_conto = trans.id_conto
    INNER JOIN banca.tipo_transazione AS tipo_trans
    ON trans.id_tipo_trans = tipo_trans.id_tipo_transazione
WHERE tipo_trans.segno = '+'
GROUP BY 1;

-- Solution with view
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_family
FROM banca.cliente_transazioni
GROUP BY 1;

-- Creation of temporary table: client_total_amount_transacted_in_type
DROP TEMPORARY TABLE IF EXISTS banca.client_total_amount_transacted_in_type;
CREATE TEMPORARY TABLE banca.client_total_amount_transacted_in_type AS
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '+' THEN importo 
            ELSE 0 
        END) AS total_amount_transacted_in_family
FROM banca.cliente_transazioni
GROUP BY 1;

-- Check temporary table creation
SELECT *
FROM banca.client_total_amount_transacted_in_type;

# ----------------------------------------------------------------------------------------------------------------

-- FINAL TABLE: Creation of dermonalized table with bank client information
-- Following the istructions to create the final table with all data retrieved and calculated from main tables.

-- Table creation
DROP TABLE IF EXISTS banca.bank_client_behavior;
CREATE TABLE banca.bank_client_behavior 
(
    id_client INT PRIMARY KEY,
    age INT,
    number_outgoing_transaction INT,
    number_incoming_transaction INT,
    total_amount_transacted_out DECIMAL(15,2),
    total_amount_transacted_in DECIMAL(15,2),
    total_account_owned INT,
    number_account_type_private INT,
    number_account_type_base INT,
    number_account_type_business INT,
    number_account_type_family INT,
    number_outgoing_type_transaction_amazon INT,
    number_outgoing_type_transaction_mutual INT,
    number_outgoing_type_transaction_hotel INT,
    number_outgoing_type_transaction_airplane_ticket INT,
    number_outgoing_type_transaction_market INT,
    number_incoming_type_transaction_salary INT,
    number_incoming_type_transaction_bonus INT,
    number_incoming_type_transaction_retirement INT,
    total_amount_transacted_out_private DECIMAL(15,2),
    total_amount_transacted_out_base DECIMAL(15,2),
    total_amount_transacted_out_business DECIMAL(15,2),
    total_amount_transacted_out_family DECIMAL(15,2),
    total_amount_transacted_in_private DECIMAL(15,2),
    total_amount_transacted_in_base DECIMAL(15,2),
    total_amount_transacted_in_business DECIMAL(15,2),
    total_amount_transacted_in_family DECIMAL(15,2)
);

-- Data Extraction

/* 

	OLD SOLUTION
    
    Not a good chioce in term of performance and efficiency use huge amount of insert in this way.
    It is better to create temporary tables for each indicator and create a unique query that extract
    the data from them.
    
-- Insert clients age
INSERT INTO banca.bank_client_behavior (id_client, age)
SELECT 
    clt.id_cliente,
    YEAR(CURRENT_DATE) - YEAR(clt.data_nascita) AS age
FROM banca.cliente AS clt
ON DUPLICATE KEY UPDATE
    age = VALUES(age);

-- Insert of total number of outgoing transaction
INSERT INTO banca.bank_client_behavior (id_client, number_outgoing_transaction)
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_transaction
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    number_outgoing_transaction = VALUES(number_outgoing_transaction);	

-- Insert of total number of incoming transaction
INSERT INTO banca.bank_client_behavior (id_client, number_incoming_transaction)
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_transaction
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    number_incoming_transaction = VALUES(number_incoming_transaction);

-- Insert of total amount of outgoing transaction
INSERT INTO banca.bank_client_behavior (id_client, total_amount_transacted_out)
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '-' THEN importo
            ELSE 0
        END) AS total_amount_transacted_out
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    total_amount_transacted_out = VALUES(total_amount_transacted_out);

-- Insert of total amount of incoming transaction
INSERT INTO banca.bank_client_behavior (id_client, total_amount_transacted_in)
SELECT 
    id_cliente,
    SUM(
        CASE 
            WHEN segno = '+' THEN importo
            ELSE 0
        END) AS total_amount_transacted_in
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    total_amount_transacted_in = VALUES(total_amount_transacted_in);

-- Insert of total number of account owned
INSERT INTO banca.bank_client_behavior (id_client, total_account_owned)
SELECT 
    id_cliente,
    COUNT(DISTINCT id_conto) AS total_account_owned
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    total_account_owned = VALUES(total_account_owned);

-- Insert of total number of account owned for each type
INSERT INTO banca.bank_client_behavior (id_client, number_account_type_private, number_account_type_base, number_account_type_business, number_account_type_family)
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Privati' THEN 1
            ELSE 0
        END) AS number_account_type_private,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Base' THEN 1
            ELSE 0
        END) AS number_account_type_base,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Business' THEN 1
            ELSE 0
        END) AS number_account_type_business,
    SUM(
        CASE
            WHEN desc_tipo_conto = 'Conto Famiglie' THEN 1
            ELSE 0
        END) AS number_account_type_family
FROM 
    (SELECT 
		id_cliente, desc_tipo_conto 
	FROM banca.conto as ct
	INNER JOIN banca.tipo_conto AS tipo_ct
    ON ct.id_tipo_conto = tipo_ct.id_tipo_conto) AS distinct_accounts
GROUP BY 1
ON DUPLICATE KEY UPDATE
    number_account_type_private = VALUES(number_account_type_private),
    number_account_type_base = VALUES(number_account_type_base),
    number_account_type_business = VALUES(number_account_type_business),
    number_account_type_family = VALUES(number_account_type_family);

-- Insert of total number of outgoing transaction for each transaction type
INSERT INTO banca.bank_client_behavior (id_client, number_outgoing_type_transaction_amazon, number_outgoing_type_transaction_mutual, number_outgoing_type_transaction_hotel, number_outgoing_type_transaction_airplane_ticket, number_outgoing_type_transaction_market)
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Acquisto su Amazon' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_amazon,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Rata mutuo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_mutual,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Hotel' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_hotel,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Biglietto aereo' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_airplane_ticket,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Supermercato' AND segno = '-' THEN 1
            ELSE 0
        END) AS number_outgoing_type_transaction_market
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    number_outgoing_type_transaction_amazon = VALUES(number_outgoing_type_transaction_amazon),
    number_outgoing_type_transaction_mutual = VALUES(number_outgoing_type_transaction_mutual),
    number_outgoing_type_transaction_hotel = VALUES(number_outgoing_type_transaction_hotel),
    number_outgoing_type_transaction_airplane_ticket = VALUES(number_outgoing_type_transaction_airplane_ticket),
    number_outgoing_type_transaction_market = VALUES(number_outgoing_type_transaction_market);

-- Insert of total number of incoming transaction for each transaction type
INSERT INTO banca.bank_client_behavior (id_client, number_incoming_type_transaction_salary, number_incoming_type_transaction_bonus, number_incoming_type_transaction_retirement)
SELECT
    id_cliente,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Stipendio' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_salary,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Dividendi' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_bonus,
    SUM(
        CASE
            WHEN desc_tipo_trans = 'Pensione' AND segno = '+' THEN 1
            ELSE 0
        END) AS number_incoming_type_transaction_retirement
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    number_incoming_type_transaction_salary = VALUES(number_incoming_type_transaction_salary),
    number_incoming_type_transaction_bonus = VALUES(number_incoming_type_transaction_bonus),
    number_incoming_type_transaction_retirement = VALUES(number_incoming_type_transaction_retirement);

-- Insert of total amount of outgoing transaction for each account type
INSERT INTO banca.bank_client_behavior (id_client, total_amount_transacted_out_private, total_amount_transacted_out_base, total_amount_transacted_out_business, total_amount_transacted_out_family)
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '-' THEN importo
            ELSE 0
        END) AS total_amount_transacted_out_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '-' THEN importo
            ELSE 0
        END) AS total_amount_transacted_out_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '-' THEN importo
            ELSE 0
        END) AS total_amount_transacted_out_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '-' THEN importo
            ELSE 0
        END) AS total_amount_transacted_out_family
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    total_amount_transacted_out_private = VALUES(total_amount_transacted_out_private),
    total_amount_transacted_out_base = VALUES(total_amount_transacted_out_base),
    total_amount_transacted_out_business = VALUES(total_amount_transacted_out_business),
    total_amount_transacted_out_family = VALUES(total_amount_transacted_out_family);

-- Insert of total amount of incoming transaction for each account type
INSERT INTO banca.bank_client_behavior (id_client, total_amount_transacted_in_private, total_amount_transacted_in_base, total_amount_transacted_in_business, total_amount_transacted_in_family)
SELECT
    id_cliente,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Privati' AND segno = '+' THEN importo
            ELSE 0
        END) AS total_amount_transacted_in_private,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Base' AND segno = '+' THEN importo
            ELSE 0
        END) AS total_amount_transacted_in_base,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Business' AND segno = '+' THEN importo
            ELSE 0
        END) AS total_amount_transacted_in_business,
    SUM(
        CASE 
            WHEN desc_tipo_conto = 'Conto Famiglie' AND segno = '+' THEN importo
            ELSE 0
        END) AS total_amount_transacted_in_family
FROM banca.cliente_transazioni
GROUP BY 1
ON DUPLICATE KEY UPDATE
    total_amount_transacted_in_private = VALUES(total_amount_transacted_in_private),
    total_amount_transacted_in_base = VALUES(total_amount_transacted_in_base),
    total_amount_transacted_in_business = VALUES(total_amount_transacted_in_business),
    total_amount_transacted_in_family = VALUES(total_amount_transacted_in_family);
    
*/

-- NEW SOLUTION
-- Unique query for data extraction
INSERT INTO banca.bank_client_behavior (
    id_client,
    age,
    number_outgoing_transaction,
    number_incoming_transaction,
    total_amount_transacted_out,
    total_amount_transacted_in,
    total_account_owned,
    number_account_type_private,
    number_account_type_base,
    number_account_type_business,
    number_account_type_family,
    number_outgoing_type_transaction_amazon,
    number_outgoing_type_transaction_mutual,
    number_outgoing_type_transaction_hotel,
    number_outgoing_type_transaction_airplane_ticket,
    number_outgoing_type_transaction_market,
    number_incoming_type_transaction_salary,
    number_incoming_type_transaction_bonus,
    number_incoming_type_transaction_retirement,
    total_amount_transacted_out_private,
    total_amount_transacted_out_base,
    total_amount_transacted_out_business,
    total_amount_transacted_out_family,
    total_amount_transacted_in_private,
    total_amount_transacted_in_base,
    total_amount_transacted_in_business,
    total_amount_transacted_in_family
)
SELECT 
    ca.id_cliente,
    ca.age,
    cot.number_outgoing_transaction,
    cit.number_incoming_transaction,
    tao.total_amount_transacted_out,
    tai.total_amount_transacted_in,
    ta.total_account_owned,
    cat.number_account_type_private,
    cat.number_account_type_base,
    cat.number_account_type_business,
    cat.number_account_type_family,
    cotr.number_outgoing_type_transaction_amazon,
    cotr.number_outgoing_type_transaction_mutual,
    cotr.number_outgoing_type_transaction_hotel,
    cotr.number_outgoing_type_transaction_airplane_ticket,
    cotr.number_outgoing_type_transaction_market,
    citr.number_incoming_type_transaction_salary,
    citr.number_incoming_type_transaction_bonus,
    citr.number_incoming_type_transaction_retirement,
    taot.total_amount_transacted_out_private,
    taot.total_amount_transacted_out_base,
    taot.total_amount_transacted_out_business,
    taot.total_amount_transacted_out_family,
    tait.total_amount_transacted_in_private,
    tait.total_amount_transacted_in_base,
    tait.total_amount_transacted_in_business,
    tait.total_amount_transacted_in_family
FROM banca.client_age AS ca
LEFT JOIN banca.client_number_outgoing_transaction AS cot ON ca.id_cliente = cot.id_cliente
LEFT JOIN banca.client_number_incoming_transaction AS cit ON ca.id_cliente = cit.id_cliente
LEFT JOIN banca.client_total_amount_transacted_out AS tao ON ca.id_cliente = tao.id_cliente
LEFT JOIN banca.client_total_amount_transacted_in AS tai ON ca.id_cliente = tai.id_cliente
LEFT JOIN banca.client_total_account_owned AS ta ON ca.id_cliente = ta.id_cliente
LEFT JOIN banca.client_number_account_type AS cat ON ca.id_cliente = cat.id_cliente
LEFT JOIN banca.client_number_outgoing_type_transaction AS cotr ON ca.id_cliente = cotr.id_cliente
LEFT JOIN banca.client_number_incoming_type_transaction AS citr ON ca.id_cliente = citr.id_cliente
LEFT JOIN banca.client_total_amount_transacted_out_type AS taot ON ca.id_cliente = taot.id_cliente
LEFT JOIN banca.client_total_amount_transacted_in_type AS tait ON ca.id_cliente = tait.id_cliente;


-- Check data extraction
SELECT * 
FROM banca.bank_client_behavior;

-- CONCLUSION

/*
	The workflow followed to perform the tasks explosed by project is:
		- Analysis of the project
        - Exploration of data stored into database
        - Study and creation of query to extract and calculate the necessary data
        - Create for each indicator a specific temporary table
        - Creation of final table with the extracted data
	
    The final table has got some NULL values because there are clients without any bank account.
    
    At the current status, the final table can be used to train an AI model on client behavior to do:
		- Classification: client similarity, Client near to close account or not
        - Regression: Estimation of future amount of money, estimation of future expenses
        - Fraud Detection: Idenfitication of fraud transaction
/*
