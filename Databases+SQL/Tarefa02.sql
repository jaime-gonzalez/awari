/* 0 - Schemas das tabelas utilizadas: */

CREATE TABLE "DM_Clientes" (
	"customer_id"	TEXT,
	"customer_unique_id"	TEXT,
	"customer_zip_code_prefix"	INTEGER,
	"customer_city"	TEXT,
	"customer_state"	TEXT,
	PRIMARY KEY("customer_id")
);

CREATE TABLE "DM_Produtos" (
	"product_id"	TEXT,
	"product_category_name"	TEXT,
	"product_name_lenght"	INTEGER,
	"product_description_lenght"	INTEGER,
	"product_photos_qty"	INTEGER,
	"product_weight_g"	INTEGER,
	"product_length_cm"	INTEGER,
	"product_height_cm"	INTEGER,
	"product_width_cm"	INTEGER,
	PRIMARY KEY("product_id")
);

CREATE TABLE "FT_Pedidos" (
	"order_id"	TEXT,
	"customer_id"	TEXT,
	"order_status"	TEXT,
	"order_purchase_timestamp"	TEXT,
	"order_approved_at"	TEXT,
	"order_delivered_carrier_date"	TEXT,
	"order_delivered_customer_date"	TEXT,
	"order_estimated_delivery_date"	TEXT,
	PRIMARY KEY("order_id")
);

CREATE TABLE "DM_Pedidos_Itens" (
	"order_id"	TEXT,
	"order_item_id"	INTEGER,
	"product_id"	TEXT,
	"seller_id"	TEXT,
	"shipping_limit_date"	TEXT,
	"price"	REAL,
	"freight_value"	REAL
);



/* 1 - retorne a quantidade de itens vendidos em cada categoria por estado em que o cliente se encontra, 
mostrando somente categorias que tenham vendido uma quantidade de items acima de 1000. */

SELECT * FROM(
SELECT 
DM_Produtos.product_category_name AS product_category_name,
DM_Clientes.customer_state AS customer_state,
COUNT(DM_Pedidos_Itens.product_id) AS qtde_itens
FROM
DM_Pedidos_Itens
LEFT JOIN FT_Pedidos ON DM_Pedidos_Itens.order_id=FT_Pedidos.order_id
LEFT JOIN DM_Clientes ON DM_Clientes.customer_id=FT_Pedidos.customer_id
LEFT JOIN DM_Produtos ON DM_Produtos.product_id=DM_Pedidos_Itens.product_id
GROUP BY product_category_name,customer_state
) WHERE qtde_itens > 1000



/* 2 - mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras, qual foi o valor total de todas as compras deles, 
quantidade de compras, e valor médio gasto por compras. Ordene os mesmos por ordem decrescente pela média do valor de compra. */

SELECT * FROM(
SELECT 
DM_Clientes.customer_id AS cliente,
SUM(DM_Pedidos_Itens.price) AS valor_venda
FROM
DM_Pedidos_Itens
LEFT JOIN FT_Pedidos ON DM_Pedidos_Itens.order_id=FT_Pedidos.order_id
LEFT JOIN DM_Clientes ON DM_Clientes.customer_id=FT_Pedidos.customer_id
LEFT JOIN DM_Produtos ON DM_Produtos.product_id=DM_Pedidos_Itens.product_id
GROUP BY cliente
ORDER BY valor_venda DESC
)


/* 3 - mostre o valor vendido total de cada vendedor (seller_id) em cada uma das categorias de produtos, 
somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000. 
Desejamos ver a categoria do produto e os vendedores. 
Para cada uma dessas categorias, mostre seus valores de venda de forma decrescente. */


SELECT * FROM (
SELECT 
DM_Pedidos_Itens.seller_id AS seller_id,
DM_Produtos.product_category_name AS product_category_name,
SUM(DM_Pedidos_Itens.price) AS valor_venda
FROM
DM_Pedidos_Itens
LEFT JOIN FT_Pedidos ON DM_Pedidos_Itens.order_id=FT_Pedidos.order_id
LEFT JOIN DM_Clientes ON DM_Clientes.customer_id=FT_Pedidos.customer_id
LEFT JOIN DM_Produtos ON DM_Produtos.product_id=DM_Pedidos_Itens.product_id
GROUP BY seller_id,product_category_name
ORDER BY seller_id,product_category_name DESC
) WHERE valor_venda > 1000
