CREATE TABLE kimia_farma.analisa (
  transaction_id STRING,
  date DATE,
  branch_id INT64,
  branch_name STRING,
  kota STRING,
  provinsi STRING,
  rating_cabang FLOAT64,
  customer_name STRING,
  product_id STRING,
  product_name STRING,
  price INT64,
  discount_percentage FLOAT64,
  persentase_gross_laba FLOAT64,
  nett_sales FLOAT64,
  nett_profit FLOAT64,
  rating_transaksi FLOAT64 
)
AS
SELECT
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    pr.product_id,
    pr.product_name,
    pr.price,
    ft.discount_percentage,
    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price <= 100000 THEN 0.15
        WHEN ft.price <= 300000 THEN 0.20
        WHEN ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    ft.price * (1 - ft.discount_percentage) AS nett_sales,
    (ft.price * (1 - ft.discount_percentage)) - (ft.price * (1 - 
    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price <= 100000 THEN 0.15
        WHEN ft.price <= 300000 THEN 0.20
        WHEN ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END)) AS nett_profit,
    ft.rating AS rating_transaksi
FROM
    kimia_farma.kf_final_transaction as ft
INNER JOIN
    kimia_farma.kf_kantor_cabang as kc ON ft.branch_id = kc.branch_id
INNER JOIN
    kimia_farma.kf_product as pr ON ft.product_id = pr.product_id;