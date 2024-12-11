-- Cleansed DIM_Products Table --

SELECT
	p.[ProductKey],
    p.[ProductAlternateKey] AS ProductItemCode,
    --  ,[ProductSubcategoryKey]
    --  ,[WeightUnitMeasureCode]
    --  ,[SizeUnitMeasureCode]
    p.[EnglishProductName] AS [Product Name],
    ps.[EnglishProductSubcategoryName] AS [Sub Category], -- Joined in from Sub Category Table
	pc.[EnglishProductCategoryName] AS [Product Category], -- Joined in from Category Table
	--  ,[SpanishProductName]
    --  ,[FrenchProductName]
    --  ,[StandardCost]
    --  ,[FinishedGoodsFlag]
    p.[Color] AS [Product Color],
    --  ,[SafetyStockLevel]
    --  ,[ReorderPoint]
    --  ,[ListPrice]
    p.[Size] AS [Product size],
    --  ,[SizeRange]
    --  ,[Weight]
    --  ,[DaysToManufacture]
    p.[ProductLine] AS [Product Line],
    --  ,[DealerPrice]
    --  ,[Class]
    --  ,[Style]
    p.[ModelName] AS [Product Model Name],
    --  ,[LargePhoto]
    p.[EnglishDescription] AS [Product Description],
    --  ,[FrenchDescription]
    --  ,[ChineseDescription]
    --  ,[ArabicDescription]
    --  ,[HebrewDescription]
    --  ,[ThaiDescription]
    --  ,[GermanDescription]
    --  ,[JapaneseDescription]
    --  ,[TurkishDescription]
    --  ,[StartDate]
    --  ,[EndDate]
    --  ,[Status]
	ISNULL (p.Status, 'Outdated') AS [Product Status] -- Change Null to 'Outdated'
FROM [AdventureWorksDW2022].[dbo].[DimProduct] AS p
LEFT JOIN [AdventureWorksDW2022].dbo.Dimproductsubcategory AS ps
	ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN [AdventureWorksDW2022].dbo.DimProductCategory AS pc
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY p.ProductKey ASC