USE [Target.TesteDB];

-- 1.Crie uma consulta que obtenha a lista de produtos (ProductName), e a quantidade por unidade (QuantityPerUnit);

SELECT
    ProductName,
    QuantityPerUnit
FROM Products;

-- Como analista de dados iria fazer uma segmenta��o dos dados separando por categorias
-------------------------------------------------------------------------------------------------------
-- 2.Crie uma consulta que obteve a lista de produtos ativos (ProductID e ProductName);

SELECT
    ProductID,
    ProductName
FROM Products
WHERE Discontinued = 0;

-- Considerei que a regra de neg�cio Discontinued = 0 significa falso e o produto n�o foi descontinuado
--------------------------------------------------------------------------------------------------------

-- 3.Crie uma consulta que obtenha a lista de produtos descontinuados (ProductID e ProductName);

SELECT
    ProductID,
    ProductName
FROM Products
WHERE Discontinued = 1;
--------------------------------------------------------------------------------------------------------

-- 4.Crie uma consulta que obtenha uma lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos s�o menores que $20;

SELECT
    ProductID,
    ProductName,
    UnitPrice
	FROM Products
WHERE
    Discontinued = 0 AND UnitPrice < 20;

--------------------------------------------------------------------------------------------------------

-- 5.Crie uma consulta que obtenha uma lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos est� entre $15 e $25;

SELECT
    ProductID,
    ProductName,
    UnitPrice
	FROM Products
WHERE
    Discontinued = 0 AND UnitPrice BETWEEN 15 AND 25;

-----------------------------------------------------------------------------------------------------------

-- Calculo da m�dia dos produtos

/*SELECT
    AVG(UnitPrice) AS MediaPreco
FROM Products;*/ 

-----------------------------------------------------------------------------------------------------------
-- 6.Crie uma consulta que obtenha uma lista de produtos (ProductName, UnitPrice) que tenham pre�o acima da m�dia;

SELECT
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-----------------------------------------------------------------------------------------------------------
-- 7 
-----------------------------------------------------------------------------------------------------------

-- 8.Crie uma consulta que obteve a lista de empregados e seus l�deres, caso o empregado n�o possua lideran�a, informe 'N�o possui lideran�as'.
-- L = Lider & E = Empregado 
SELECT
    E.FirstName + ' ' + E.LastName AS Employee_Name,
    ISNULL(L.FirstName + ' ' + L.LastName, 'N�o possui lideran�as') AS Manager_Name
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

-- 10.Crie uma consulta que obteve a lista de pedidos dos funcion�rios da regi�o �Oeste�;

SELECT
    E.FirstName + ' ' + E.LastName AS Employee_Name,
    O.OrderID,
    O.OrderDate
	FROM Employees AS E
JOIN Orders AS O
    ON E.EmployeeID = O.EmployeeID
WHERE
    E.Region = 'WA';

-- Obs: Considerei que WA da tabela de Employees ser� a regi�o "Oeste" como regra de neg�cio. 
-----------------------------------------------------------------------------------------------------------------

-- 11.Crie uma consulta que obteve os n�meros de pedidos e a lista de clientes (CompanyName, ContactName, Address e Phone),
-- que possu�am 171 como c�digo de �rea do telefone e que o frete dos pedidos customizados entre $6,00 e $13,00;

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
-- total de cada produto j� aplicado o desconto % (se tiver algum);

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