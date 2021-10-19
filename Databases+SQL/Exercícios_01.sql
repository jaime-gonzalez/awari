/*Schema das tabelas utilizadas neste exercício */

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

CREATE TABLE "DM_Clientes" (
	"customer_id"	TEXT,
	"customer_unique_id"	TEXT,
	"customer_zip_code_prefix"	INTEGER,
	"customer_city"	TEXT,
	"customer_state"	TEXT,
	PRIMARY KEY("customer_id")
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

CREATE TABLE "FT_Pagamentos" (
	"order_id"	TEXT,
	"payment_sequential"	INTEGER,
	"payment_type"	TEXT,
	"payment_installments"	INTEGER,
	"payment_value"	REAL
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

CREATE TABLE "FT_Reviews" (
	"review_id"	TEXT,
	"order_id"	TEXT,
	"review_score"	INTEGER,
	"review_comment_title"	TEXT,
	"review_comment_message"	TEXT,
	"review_creation_date"	TEXT,
	"review_answer_timestamp"	TEXT
);


/*1 - Crie uma query em SQL que retorne os valores distintos de cidade. Utilize a tabela “olist_customers_dataset” e a 
função aliases para retornar o dado.*/

SELECT DISTINCT customer_city AS cidade_clientes FROM DM_Clientes;


/*2 - Crie uma query em SQL que retorne os valores distintos de cidade e estado, para os estados de são paulo, 
minas gerais e rio de janeiro. Utilize a tabela “olist_customers_dataset” e a função aliases para retornar o dado. */

SELECT DISTINCT 
  customer_city AS cidade_clientes,
  customer_state AS estado_clientes
FROM DM_Clientes
WHERE customer_state 
IN("SP","MG","RJ");


/*3 - Crie uma ou mais queries que retornem o preço, o frete, a data limite para envio,  e o identificador do pedido 
para os registros que tem o preço entre 50 e 250, e que tem ao mesmo tempo a data de de envio limite maior do que 08 de Fevereiro de 2018. 
Utilize a função aliases para retornar o dado. Utilize a tabela “olist_order_items_dataset” e a função aliases para retornar o dado.  
*/

SELECT 
  shipping_limit_date AS data_limite_envio,
  freight_value AS valor_frete,
  price AS preco
FROM DM_Pedidos_Itens
WHERE price BETWEEN 50 AND 250
AND date(shipping_limit_date)>date("2018-02-08")
ORDER BY shipping_limit_date;


/*4 - Crie uma ou mais queries que retornem o preço, o frete, a data limite para envio,  e o identificador do pedido 
para os registros que tem o preço do frete inferior a 149 ou que tem um preço entre 250 e 500. Utilize a função aliases 
para retornar o dado. Utilize a tabela “olist_order_items_dataset” e a função aliases para retornar o dado.  
*/

SELECT 
order_id AS identificador_pedido,
shipping_limit_date AS data_limite_envio,
freight_value AS valor_frete,
price AS preco
FROM DM_Pedidos_Itens
WHERE freight_value < 149 
AND
price BETWEEN 250 and 500;


/*5 - Crie uma query em SQL que retorne todos os tipos de pagamento. Utilize a tabela “olist_order_payments_dataset” 
e a função aliases para retornar o dado.  */

SELECT DISTINCT payment_type AS tipo_pagamento FROM FT_Pagamentos;


/*6 - Crie uma query em SQL que retorne o tipo de pagamento, e o valor do pagamento para as compras que foram parceladas 
de 12 a 24 vezes e que tiveram um valor superior a 245,99 . Utilize a tabela “olist_order_payments_dataset” e a função aliases para retornar o dado. */

SELECT 
  payment_type AS 'Tipo de Pagamento',
  payment_value AS 'Valor de Pagamento'
FROM FT_Pagamentos
WHERE payment_value > 245.99
AND payment_installments BETWEEN 12 AND 24;


/*7 - Crie uma query em SQL que retorne todas as pontuações de avaliação. Utilize a tabela “olist_order_reviews_dataset” e a função aliases para retornar o dado.*/

SELECT review_score AS 'Pontuações de avaliação' FROM FT_Reviews;


/*8 - Crie uma query em SQL que retorne todos os status de pedidos. Utilize a tabela “olist_orders_dataset” e a função aliases para retornar o dado.*/

SELECT order_status AS 'Status de Pedidos' FROM FT_Pedidos;


/*9 - Crie uma query em SQL que delete os registros para os pedidos que tenham o status é igual à “unavailable” e que tem uma data de aprovação 
igual ou anterior a 10 de Outubro de 2017. Utilize a tabela “olist_orders_dataset” e a função aliases para retornar o dado.*/

/*Checando os registros com status "unavailable"*/
SELECT * FROM FT_Pedidos WHERE order_status = 'unavailable' AND order_approved_at <='2017-10-10 23:59:59';

/*Deletando os registros com status "unavailable"*/
DELETE FROM FT_Pedidos WHERE order_status = 'unavailable' AND order_approved_at <='2017-10-10 23:59:59';

/*Checando novamente (irá retornar zero registros)*/
SELECT * FROM FT_Pedidos WHERE order_status = 'unavailable' AND order_approved_at <='2017-10-10 23:59:59';

/*10. [DESAFIO] Crie uma query em SQL que atualize os nomes de categorias de produto para uma versão de melhor leitura 
(Ex: moveis_decoracao > Movéis e Decoração), para os registros que tem a altura maior ou igual a 20 e que o tamanho 
do nome do produto esteja entre 10 e 200 . Para isso, voce precisa selecionar todos as categorias existentes na tabela 
que atendem aos critérios e depois criar seu comando para atualização de registros. Utilize a tabela “olist_products_dataset” 
e a função aliases para retornar o dado.*/

/* Selecionando o conjunto de registros nas condições solicitadas e criando uma coluna com os strings "Arrumados"*/
SELECT 
product_category_name,
UPPER(substr(product_category_name,1,1))||LOWER(substr(REPLACE(product_category_name, '_', ' '),2)) AS 'Categoria Arrumada'
FROM DM_Produtos
WHERE 
product_height_cm >=20 AND 
product_name_lenght BETWEEN 10 AND 200;

/* Realizando o update no conjunto de registros com os dados arrumados*/
UPDATE DM_Produtos 
SET product_category_name = UPPER(substr(product_category_name,1,1))||LOWER(substr(REPLACE(product_category_name, '_', ' '),2))
WHERE 
product_height_cm >=20 AND 
product_name_lenght BETWEEN 10 AND 200;

/* Checando os dados atualizados */
SELECT DISTINCT product_category_name FROM DM_Produtos;

