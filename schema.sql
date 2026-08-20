/* =========================================================================
   ROAST & ROWS  —  Coffee Chain Analytics
   Schema for a fictional 6-location specialty coffee chain.

   ENTITIES
     stores        — physical locations
     employees     — staff, each tied to one home store
     customers     — people who place orders / leave reviews
     menu_items    — sellable products (drinks, food)
     orders        — one checkout event (header)
     order_items   — line items on an order (associative/junction entity
                     that resolves the orders <-> menu_items many-to-many)
     reviews       — a customer's rating of a store, optionally tied to
                     a specific order

   RELATIONSHIPS
     stores        1 ────< employees      (a store employs many staff)
     stores        1 ────< orders         (a store rings up many orders)
     stores        1 ────< reviews        (a store receives many reviews)
     employees     1 ────< orders         (an employee rings up many orders)
     customers     1 ────< orders         (a customer places many orders)
     customers     1 ────< reviews        (a customer leaves many reviews)
     orders        1 ────< order_items    (an order has many line items)
     menu_items    1 ────< order_items    (an item appears on many orders)
     orders        1 ────0..1 reviews     (a review may reference the order
                                            that prompted it)

     orders <───────> menu_items  is a many-to-many relationship, resolved
     by the order_items junction table, which also carries its own
     attributes (quantity, unit_price at time of sale).
   ========================================================================= */

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS stores;

-- ---------------------------------------------------------------------
-- STORES  (strong entity)
-- ---------------------------------------------------------------------
CREATE TABLE stores (
    store_id            INTEGER PRIMARY KEY,
    name                TEXT    NOT NULL,
    city                TEXT    NOT NULL,
    neighborhood        TEXT    NOT NULL,
    opened_date         TEXT    NOT NULL,          -- ISO date
    seating_capacity    INTEGER NOT NULL
);

-- ---------------------------------------------------------------------
-- EMPLOYEES  (strong entity, FK to stores)
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    employee_id         INTEGER PRIMARY KEY,
    store_id            INTEGER NOT NULL REFERENCES stores(store_id),
    name                TEXT    NOT NULL,
    role                TEXT    NOT NULL CHECK (role IN
                             ('Barista','Shift Lead','Store Manager')),
    hire_date           TEXT    NOT NULL,
    hourly_rate         REAL    NOT NULL
);

-- ---------------------------------------------------------------------
-- CUSTOMERS  (strong entity)
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id         INTEGER PRIMARY KEY,
    name                TEXT    NOT NULL,
    email               TEXT    NOT NULL UNIQUE,
    signup_date         TEXT    NOT NULL,
    home_city           TEXT    NOT NULL
);

-- ---------------------------------------------------------------------
-- MENU_ITEMS  (strong entity)
-- ---------------------------------------------------------------------
CREATE TABLE menu_items (
    item_id             INTEGER PRIMARY KEY,
    name                TEXT    NOT NULL,
    category            TEXT    NOT NULL CHECK (category IN
                             ('Espresso','Brewed Coffee','Tea','Pastry',
                              'Food','Cold Drinks','Other')),
    price               REAL    NOT NULL,           -- current menu price
    cost                REAL    NOT NULL,           -- cost of goods sold
    is_seasonal         INTEGER NOT NULL DEFAULT 0  -- 0/1 boolean
);

-- ---------------------------------------------------------------------
-- ORDERS  (order header — FK to stores, employees, customers)
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id            INTEGER PRIMARY KEY,
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    store_id            INTEGER NOT NULL REFERENCES stores(store_id),
    employee_id         INTEGER NOT NULL REFERENCES employees(employee_id),
    order_ts            TEXT    NOT NULL,           -- ISO datetime
    channel             TEXT    NOT NULL CHECK (channel IN
                             ('In-Store','Mobile','Drive-Thru'))
);

-- ---------------------------------------------------------------------
-- ORDER_ITEMS  (associative entity — resolves orders <-> menu_items M:N)
-- unit_price is captured at time of sale so historical revenue is
-- unaffected by later menu price changes.
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id       INTEGER PRIMARY KEY,
    order_id            INTEGER NOT NULL REFERENCES orders(order_id),
    item_id             INTEGER NOT NULL REFERENCES menu_items(item_id),
    quantity            INTEGER NOT NULL CHECK (quantity > 0),
    unit_price          REAL    NOT NULL
);

-- ---------------------------------------------------------------------
-- REVIEWS  (FK to customers, stores; optional FK to orders)
-- ---------------------------------------------------------------------
CREATE TABLE reviews (
    review_id           INTEGER PRIMARY KEY,
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    store_id            INTEGER NOT NULL REFERENCES stores(store_id),
    order_id            INTEGER REFERENCES orders(order_id),
    rating              INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date         TEXT    NOT NULL
);

-- ---------------------------------------------------------------------
-- Indexes to support the analytics queries in queries.sql
-- ---------------------------------------------------------------------
CREATE INDEX idx_orders_store    ON orders(store_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_orders_ts       ON orders(order_ts);
CREATE INDEX idx_oi_order        ON order_items(order_id);
CREATE INDEX idx_oi_item         ON order_items(item_id);
CREATE INDEX idx_reviews_store   ON reviews(store_id);
