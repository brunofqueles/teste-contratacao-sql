USE [Target.TesteDB];

-- 1.Crie uma consulta que obtenha a lista de produtos (ProductName), e a quantidade por unidade (QuantityPerUnit);

SELECT
    ProductName,
    QuantityPerUnit
FROM Products;

-- Como analista de dados iria fazer uma segmentação dos dados separando por categorias
-------------------------------------------------------------------------------------------------------
-- 2.Crie uma consulta que obteve a lista de produtos ativos (ProductID e ProductName);

SELECT
    ProductID,
    ProductName
FROM Products
WHERE Discontinued = 0;

-- Considerei que a regra de negócio Discontinued = 0 significa falso e o produto não foi descontinuado
--------------------------------------------------------------------------------------------------------

-- 3.Crie uma consulta que obtenha a lista de produtos descontinuados (ProductID e ProductName);

SELECT
    ProductID,
    ProductName
FROM Products
WHERE Discontinued = 1;
--------------------------------------------------------------------------------------------------------

-- 4.Crie uma consulta que obtenha uma lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos são menores que $20;

SELECT
    ProductID,
    ProductName,
    UnitPrice
	FROM Products
WHERE
    Discontinued = 0 AND UnitPrice < 20;

--------------------------------------------------------------------------------------------------------

-- 5.Crie uma consulta que obtenha uma lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos está entre $15 e $25;

SELECT
    ProductID,
    ProductName,
    UnitPrice
	FROM Products
WHERE
    Discontinued = 0 AND UnitPrice BETWEEN 15 AND 25;

-----------------------------------------------------------------------------------------------------------

-- Calculo da média dos produtos

/*SELECT
    AVG(UnitPrice) AS MediaPreco
FROM Products;*/ 

-----------------------------------------------------------------------------------------------------------
-- 6.Crie uma consulta que obtenha uma lista de produtos (ProductName, UnitPrice) que tenham preço acima da média;

SELECT
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-----------------------------------------------------------------------------------------------------------
-- 7.Crie um procedimento que retorne cada produto e seu preço;
--   o Adicione ao procedimento, criado na questão anterior, os parâmetros 'Codigo_Fornecedor' (permitindo escolher 1 ou mais)
--   e'Codigo_Categoria' (permitindo escolher 1 ou mais) e altere-a para atender a passagem dessas sessões;
--   o Adicione ao procedimento, criado na questão anterior, o parâmetro 'Codigo_Transportadora' (permitindo escolher 1 ou mais) e um outro
--   parâmetro 'Tipo_Saida' para se optar por uma saída OLTP (Transacional) ou OLAP (Pivot).


-----  Prefiro pensar melhor antes de responder ------

-----------------------------------------------------------------------------------------------------------

-- 8.Crie uma consulta que obteve a lista de empregados e seus líderes, caso o empregado não possua liderança, informe 'Não possui lideranças'.
-- L = Lider & E = Empregado 
SELECT
    E.FirstName + ' ' + E.LastName AS Employee_Name,
    ISNULL(L.FirstName + ' ' + L.LastName, 'Não possui lideranças') AS Manager_Name
FROM Employees AS E
LEFT JOIN Employees AS L
    ON E.ReportsTo = L.EmployeeID;

-------------------------------------------------------------------------------------------------------------

-- 9.Crie uma consulta que obtenha o(s) produto(s) mais caro(s) e o(s) mais barato(s) da lista (ProductName e UnitPrice);

SELECT
    ProductName,
    UnitPrice
FROM Products
WHERE
    UnitPrice = (SELECT MAX(UnitPrice) FROM Products)
    OR UnitPrice = (SELECT MIN(UnitPrice) FROM Products);

--------------------------------------------------------------------------------------------------------------

-- 10.Crie uma consulta que obteve a lista de pedidos dos funcionários da região ‘Oeste’;

SELECT
    E.FirstName + ' ' + E.LastName AS Employee_Name,
    O.OrderID,
    O.OrderDate
	FROM Employees AS E
JOIN Orders AS O
    ON E.EmployeeID = O.EmployeeID
WHERE
    E.Region = 'WA';

-- Obs: Considerei que WA da tabela de Employees será a região "Oeste" como regra de negócio. 
-----------------------------------------------------------------------------------------------------------------

-- 11.Crie uma consulta que obteve os números de pedidos e a lista de clientes (CompanyName, ContactName, Address e Phone),
-- que possuíam 171 como código de área do telefone e que o frete dos pedidos customizados entre $6,00 e $13,00;

SELECT
    C.CompanyName,
    C.ContactName,
    C.Address,
    C.Phone
    FROM Orders AS O
JOIN Customers AS C
    ON O.CustomerID = C.CustomerID
WHERE
    C.Phone LIKE '(171)%' AND O.Freight BETWEEN 6.00 AND 13.00;

--------------------------------------------------------------------------------------------------------------------------

-- 12.Crie uma consulta que obtenha todos os dados de pedidos (Orders) que envolvem os fornecedores da cidade 'Manchester' e foram enviados
-- pela empresa 'Speedy Express';

SELECT
    DISTINCT O.*
FROM Orders AS O
JOIN Shippers AS SH
    ON O.ShipVia = SH.ShipperID
JOIN [Order Details] AS OD
    ON O.OrderID = OD.OrderID
JOIN Products AS P
    ON OD.ProductID = P.ProductID
JOIN Suppliers AS S
    ON P.SupplierID = S.SupplierID
WHERE
    S.City = 'Manchester' AND SH.CompanyName = 'Speedy Express';

---------------------------------------------------------------------------------------------------------------------------
-- 13.Crie uma consulta que obtenha a lista de Produtos (ProductName) constantes nos Detalhe dos Pedidos (Order Details), calculando o valor
-- total de cada produto já aplicado o desconto % (se tiver algum);

SELECT
    P.ProductName,
    ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) AS ValorTotalComDesconto
FROM [Order Details] AS OD
JOIN Products AS P
    ON OD.ProductID = P.ProductID
GROUP BY
    P.ProductName
ORDER BY
    ValorTotalComDesconto DESC;

----------------------------------------------------------------------------------------------------------------------------

-- Perguntas complementares:

-- 1.Tem conhecimento em processos e ferramentas de ETL? Quantos anos de experiência? Quais casos foram aplicados?
-- Possuo solido conhecimento em processo de ETL sejam feitos no Power BI, SQL ou Python agora estou explorando o Databricks a titulo de evolução
-- possuo mais de 8 anos atuando com Engenharia/Analise de dados. Neste case foram aplicadas diversas funções em conjunto como Where e joins e em
-- especial a questão 7 com um grau de complexidade maior eu usaria funções de agregação para resolver.

-- 2.Você tem experiência com a ferramenta Azure Data Factory?
-- Atualmente trabalho com o AWS e cito aqui 5 acões que são similares entre as 2 plataformas CLOUD:
-- Ingestão de dados - Com AWS Glue + AWS S3 para puxar dados de fontes externas (bancos, APIs, arquivos) e armazenar no Data Lake.
-- ETL em escala - Usando o AWS Glue (Spark) para limpeza, padronização e enriquecimento de dados.
-- Pipelines completos - Usando o AWS Step Functions ou Amazon Managed Workflows.
-- Carga em Data Warehouse - Usar o Amazon Redshift como destino para análises.
-- Integração com BI - Usando Amazon Athena (SQL sobre S3) ou Redshift para consumo direto no Power BI.

-- 3.Pode responder em um fluxograma (ou escrito em tópicos) um caso de ETL onde:

-- Parte dos dados de origem estão no banco de dados Oracle e outra em CSV no Storage Bucket da AWS

-- O dado final deverá estar na base de dados SQL Server.

-- Deverá ser verificada a entrada dos dados de origem.

-- Validação dos dados finais que foram processados.

-- Cálculos dos dados de origem, para geração de indicadores (que serão os dados finais).
