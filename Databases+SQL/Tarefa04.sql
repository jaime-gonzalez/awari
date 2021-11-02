/*Exercícios realizados utilizando o Google Big Query*/


/*1 - Crie uma view (SELLER_STATS) para mostrar por fornecedor, a quantidade de itens enviados, o 
tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor, 
note que trabalharemos na mesma query com 2 granularidades diferentes.*/

CREATE VIEW `jgonzalezds01.olist.VW_SELLER_STATS` AS
SELECT 
DISTINCT 
    fornecedor,
    SUM(quantidadeItens) OVER(partition by fornecedor) AS totalItens,
    AVG(tempoAprovacaoCompra) OVER(partition by fornecedor) tempoMedioPostagem
FROM(
SELECT
    PedidosItens.seller_id AS fornecedor,
    Pedidos.order_id AS pedido,
    COUNT(PedidosItens.product_id) AS quantidadeItens,
    DATE_DIFF(Pedidos.order_delivered_carrier_date, Pedidos.order_approved_at, day) AS tempoAprovacaoCompra,
    Pedidos.order_delivered_carrier_date AS dataPostagem,
    Pedidos.order_approved_at AS dataAprovacao
FROM `jgonzalezds01.olist.FT_Pedidos` AS Pedidos
INNER JOIN `jgonzalezds01.olist.DM_Pedidos_Itens` AS PedidosItens ON Pedidos.order_id=PedidosItens.order_id
WHERE Pedidos.order_approved_at IS NOT NULL
GROUP BY fornecedor,pedido, dataPostagem, dataAprovacao, tempoAprovacaoCompra
)



/*2 - Queremos dar um cupom de 10% do valor da última compra do cliente. Porém os clientes elegíveis a este cupom devem ter 
feito uma compra anterior a última (a partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última 
compra. Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis.*/

