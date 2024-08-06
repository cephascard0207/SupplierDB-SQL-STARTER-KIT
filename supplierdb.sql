-- DB CREATION --
CREATE DATABASE IF NOT EXISTS supplier;
-- DB INITIALISED --
USE supplier;

-- TABLE CREATION --
-- INVENTORY TB--
CREATE TABLE inventory (
    prod_id INT PRIMARY KEY NOT NULL,
    prod_name VARCHAR(60) NOT NULL,
    prod_qty INT NOT NULL,
	prod_ucost INT NOT NULL,
    prod_ecost INT GENERATED ALWAYS AS (prod_qty * prod_ucost) STORED,
    -- prod_ecost alias below--
    prod_formatted_cost VARCHAR(20) GENERATED ALWAYS AS (CONCAT('₹', prod_ecost)) STORED,
    prod_mrp INT NOT NULL,
    sell_cost INT NOT NULL, 
    prod_mrp_formatted VARCHAR(20) GENERATED ALWAYS AS (CONCAT('₹', prod_mrp)) STORED,
    sell_cost_formatted VARCHAR(20) GENERATED ALWAYS AS (CONCAT('₹', sell_cost)) STORED,
    purch_date DATE NOT NULL
);
-- CASHFLOW TB--
CREATE TABLE cashflow(
	prod_id INT,
    units_sold INT NOT NULL,
    prod_profit INT NOT NULL,
    prod_loss INT NOT NULL,
    bk_even_stat BOOL NOT NULL,
    -- BELOW ESTABLISHED FOREIGN KEY & PRIMARY KEY RELATION --
    FOREIGN KEY (prod_id) REFERENCES inventory(prod_id)
);

-- SAMPLE DATA INSERTION --
-- INVENTORY SAMPLE DATA --
INSERT INTO inventory (prod_id, prod_name, prod_qty, prod_ucost, prod_mrp, sell_cost, purch_date)
VALUES
(1, 'Product A', 5, 2, 7, 3, '2024-08-01'),
(2, 'Product B', 3, 4, 9, 5, '2024-08-02'),
(3, 'Product C', 7, 1, 6, 2, '2024-08-03'),
(4, 'Product D', 2, 6, 10, 8, '2024-08-04'),
(5, 'Product E', 8, 3, 8, 4, '2024-08-05');



-- CASHFLOW SAMPLE DATA --
-- CURRENTLY WITH MANUAL CALCULATION--
INSERT INTO cashflow (prod_id, units_sold, prod_profit, prod_loss, bk_even_stat)
VALUES
(1, 5, (5 * (3 - 2)), 0, TRUE),    -- Product A: Units Sold = 5, Profit = (Selling Price - Unit Cost) * Units Sold, Loss = 0, Break-even = TRUE
(2, 3, (3 * (5 - 4)), 0, TRUE),    -- Product B: Units Sold = 3, Profit = (Selling Price - Unit Cost) * Units Sold, Loss = 0, Break-even = TRUE
(3, 7, (7 * (2 - 1)), 0, TRUE),    -- Product C: Units Sold = 7, Profit = (Selling Price - Unit Cost) * Units Sold, Loss = 0, Break-even = TRUE
(4, 2, (2 * (8 - 6)), 0, TRUE),    -- Product D: Units Sold = 2, Profit = (Selling Price - Unit Cost) * Units Sold, Loss = 0, Break-even = TRUE
(5, 8, (8 * (4 - 3)), 0, TRUE),
(1, 2, (5 * (3 - 2)), 0, TRUE);

-- DATA RETRIEVAL | ALL COLUMNS -- 
SELECT * FROM inventory;
SELECT * FROM cashflow;

-- TB DATA ONE SHOT DELETION | NO TB SCHEMA DELETION | STRUCTURE REMAINS--
-- TRUNCATE inventory; --
-- TRUNCATE cashflow;--

-- GROUP BY | DATA RETRIEVAL--
-- GROUP BY > IS A CUSTOM VIEW BY GROUPING COLUMN DATA--
SELECT i.prod_name, i.sell_cost, SUM(c.units_sold) AS total_units_sold
FROM cashflow c
JOIN inventory i ON c.prod_id = i.prod_id
GROUP BY i.prod_name, i.sell_cost;

-- ORDER BY | DATA RETRIEVAL--
-- ORDER BY > IS A CUSTOM VIEW BY ORDERING COLUMN DATA / BASED ON ASC OR DESC--
SELECT DISTINCT * FROM cashflow ORDER BY prod_id ASC ;
