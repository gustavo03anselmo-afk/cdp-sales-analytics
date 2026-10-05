CREATE TABLE sales_clean (
	order_id	INTEGER,
	order_date	DATE,
	game	VARCHAR(60),
	franchise	VARCHAR(30),
	platform	VARCHAR(30),
	country	VARCHAR(40),
	region	VARCHAR(30),
	price_eur	NUMERIC(8,2),
	discount_pct	NUMERIC(4,2),
	refunded	CHAR(1),
	net_revenue_eur	NUMERIC(8,2)
);
-- Monthly revenue target set by finance (data/raw/targets.csv)
CREATE TABLE targets (
	month	DATE,
	target_eur	NUMERIC(10,2)
);
