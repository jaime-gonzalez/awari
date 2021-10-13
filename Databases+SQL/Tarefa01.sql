/*1 - selecione os dados da tabela de pagamentos onde só apareçam os tipos de pagamento “VOUCHER” e “BOLETO”.*/

CREATE TABLE "FT_Pagamentos" (
	"order_id"	TEXT,
	"payment_sequential"	INTEGER,
	"payment_type"	TEXT,
	"payment_installments"	INTEGER,
	"payment_value"	REAL
);

SELECT * FROM FT_Pagamentos WHERE upper(payment_type) = "VOUCHER" or upper(payment_type) = "BOLETO"



/*2 - retorne os campos da tabela de produtos e calcule o volume de cada produto em um novo campo. */

CREATE TABLE "DM_Produtos" (
	"product_id"	TEXT,
	"product_category_name"	TEXT,
	"product_name_lenght"	INTEGER,
	"product_description_lenght"	INTEGER,
	"product_photos_qty"	INTEGER,
	"product_weight_g"	INTEGER,
	"product_length_cm"	INTEGER,
	"product_height_cm"	INTEGER,
	"product_width_cm"	INTEGER
);

SELECT *,(SELECT product_length_cm * product_height_cm * product_width_cm) as volume FROM DM_Produtos



/*3 - retorne somente os reviews que não tem comentários. */

CREATE TABLE "FT_Reviews" (
	"review_id"	TEXT,
	"order_id"	TEXT,
	"review_score"	INTEGER,
	"review_comment_title"	TEXT,
	"review_comment_message"	TEXT,
	"review_creation_date"	TEXT,
	"review_answer_timestamp"	TEXT
);

SELECT * FROM FT_Reviews WHERE review_comment_title IS NULL AND review_comment_message IS NULL



/*4 - retorne pedidos que foram feitos somente no ano de 2017. */

CREATE TABLE "FT_Pedidos" (
	"order_id"	TEXT,
	"customer_id"	TEXT,
	"order_status"	TEXT,
	"order_purchase_timestamp"	TEXT,
	"order_approved_at"	TEXT,
	"order_delivered_carrier_date"	TEXT,
	"order_delivered_customer_date"	TEXT,
	"order_estimated_delivery_date"	TEXT
);

SELECT * FROM FT_Pedidos WHERE date(order_purchase_timestamp)>="2017-01-01" AND date(order_purchase_timestamp)<="2017-12-31"



/*5 - encontre os clientes do estado de SP e que não morem na cidade de São Paulo.*/

CREATE TABLE "DM_Clientes" (
	"customer_id"	TEXT,
	"customer_unique_id"	TEXT,
	"customer_zip_code_prefix"	INTEGER,
	"customer_city"	TEXT,
	"customer_state"	TEXT
);

SELECT * FROM DM_Clientes WHERE upper(customer_state)="SP" AND upper(customer_city)!="SAO PAULO"
