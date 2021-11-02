/* Tarefa feita utilizando Google Big Query */


/*1 - Crie uma tabela analítica de todos os itens que foram vendidos, mostrando somente pedidos interestaduais. 
Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não no prazo. */

SELECT 
Itens.product_id,
Vendedores.seller_state AS estadoVendedor,
date_diff(Pedidos.order_estimated_delivery_date, Pedidos.order_delivered_customer_date, day) AS tempoEntrega,
CASE WHEN date_diff(Pedidos.order_estimated_delivery_date, Pedidos.order_delivered_customer_date, day) >=0 THEN 'on time'
ELSE 'delayed'
END as Status
FROM 
`jgonzalezds01.olist.DM_Pedidos_Itens` AS Itens
INNER JOIN `jgonzalezds01.olist.DM_Vendedores` AS Vendedores ON Itens.seller_id = Vendedores.seller_id
INNER JOIN `jgonzalezds01.olist.FT_Pedidos` AS Pedidos on Pedidos.order_id = Itens.order_id
INNER JOIN `jgonzalezds01.olist.DM_Clientes` AS Clientes on Clientes.customer_id = Pedidos.customer_id
WHERE Pedidos.customer_id is not null AND Clientes.customer_state<>Vendedores.seller_state




/*2 - retorne todos os pagamentos do cliente, com suas datas de aprovação, valor da compra e o valor total que o cliente 
já gastou em todas as suas compras, mostrando somente os clientes onde o valor da compra é diferente do valor total já gasto.*/

SELECT*FROM(
    SELECT 
Pedidos.customer_id AS Cliente,
Pagamentos.payment_value AS ValorPagamento,
Pedidos.order_approved_at AS DataAprovacao,
SUM(Pagamentos.payment_value) OVER (partition by Pedidos.customer_id) AS TotalPagoCliente
FROM `jgonzalezds01.olist.FT_Pagamentos` AS Pagamentos
INNER JOIN `jgonzalezds01.olist.FT_Pedidos` AS Pedidos ON Pagamentos.order_id = Pedidos.order_id
)
WHERE ValorPagamento != TotalPagoCliente



/*3 - retorne as categorias válidas, suas somas totais dos valores de vendas, um ranqueamento de maior 
valor para  menor valor junto com o somatório acumulado dos valores pela mesma regra do ranqueamento.*/

SELECT*,
RANK() OVER (ORDER BY valorVenda DESC) AS rankingCategoria,
SUM(valorVenda) OVER (ORDER BY valorVenda DESC) AS somaAcumulada
FROM
(
    SELECT 
CategoriasItens.product_category_name AS categoria,
SUM(price) AS valorVenda
FROM `jgonzalezds01.olist.DM_Pedidos_Itens` PedidosItens
INNER JOIN `jgonzalezds01.olist.DM_Produtos` AS CategoriasItens ON PedidosItens.product_id=CategoriasItens.product_id
WHERE CategoriasItens.product_category_name IS NOT NULL
GROUP BY categoria
ORDER BY valorVenda DESC
) AS categoriasRankeadas
ORDER BY valorVenda DESC
