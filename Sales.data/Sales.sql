-- Profit and Profit Margin
SELECT *,(Revenue-Cost) as Profit, ((Revenue-Cost)/Revenue)*100 as ProfitMargin
FROM portfolio.sales2;

-- Profit and Sales By Year
SELECT Year,sum(Quantity) as TotalSales, sum(Revenue-Cost) as Profit ,sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin
FROM portfolio.sales2
GROUP BY Year
ORDER BY Year;


-- Profit and Sales by Month
SELECT Year, Month,sum(Quantity) as TotalSales, sum(Revenue-Cost) as Profit, sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin
FROM portfolio.sales2
GROUP BY Year, Month
ORDER BY Year ASC, 
field(Month, "January","February","March","April",
"May","June","July","August","September",
"October","November","December");

 -- Highest Selling Product per Month
SELECT Month,`Sub Category`, TotalSales, GrossProfitMargin
FROM 
	(SELECT Month, `Sub Category`, sum(Quantity) as TotalSales, sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin,
    rank() OVER(PARTITION BY Month ORDER BY sum(Quantity) DESC) as rnk
	FROM portfolio.sales2
    GROUP BY Month, `Sub Category`
    ORDER BY Month ASC) as sub
WHERE rnk = 1
ORDER BY field(Month, "January","February","March","April",
"May","June","July","August","September",
"October","November","December");

-- Products Women purchase
SELECT `Customer Gender`,`Product Category`,`Sub Category`, sum(Quantity) as TotalSales, sum(Revenue-Cost) as Profit
FROM portfolio.sales2
WHERE `Customer Gender` = "F"
GROUP BY `Product Category`, `Sub Category`
ORDER BY `Product Category`;

-- Products Men purchase
SELECT `Customer Gender`,`Product Category`,`Sub Category`, sum(Quantity) as Sales, sum(Revenue-Cost) as Profit
FROM portfolio.sales2
WHERE `Customer Gender` = "M"
GROUP BY `Product Category`, `Sub Category`
ORDER BY `Product Category`;


-- Sales and Profit by Country
SELECT Year, Country, sum(Quantity) as TotalSales, sum(Revenue-Cost) as Profit, sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin
FROM portfolio.sales2
GROUP BY Country, Year
ORDER BY GrossProfitMargin DESC;

-- Sales and Profit by State in the United States
SELECT Year, Country, State, sum(Quantity) as TotalSales, sum(Revenue-Cost) as Profit, sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin
FROM portfolio.sales2
WHERE Country = "United States"
GROUP BY Year, State
ORDER BY Year, GrossProfitMargin DESC;

-- Check Amount of Customers per Age group
SELECT `Customer Age`, count(`Customer Age`)
FROM portfolio.sales2
GROUP BY `Customer Age`
ORDER BY `Customer Age`;

-- Sales and Profit by Age Range
SELECT 
	CASE 
		WHEN `Customer Age` BETWEEN 17 and 24 THEN "17-24"
		WHEN `Customer Age` BETWEEN 25 and 34 THEN "25-34"
		WHEN `Customer Age` BETWEEN 35 and 44 THEN "35-44"
		WHEN `Customer Age` BETWEEN 45 and 54 THEN "45-54"
		WHEN `Customer Age` BETWEEN 55 and 64 THEN "55-64"
		ELSE "65+" 
	END AS `Age Range`,
	count(CASE 
		WHEN `Customer Age` BETWEEN 17 and 24 THEN "17-24"
		WHEN `Customer Age` BETWEEN 25 and 34 THEN "25-34"
		WHEN `Customer Age` BETWEEN 35 and 44 THEN "35-44"
		WHEN `Customer Age` BETWEEN 45 and 54 THEN "45-54"
		WHEN `Customer Age` BETWEEN 55 and 64 THEN "55-64"
		ELSE "65+" 
	END) AS `TotalPeople`,
    sum(Quantity) as TotalSales, sum((Revenue-Cost)) as Profit,
    avg((Revenue-Cost)) as AvgProfit, sum(Revenue-Cost)/sum(Revenue)*100 as GrossProfitMargin
FROM portfolio.sales2
GROUP BY CASE 
		WHEN `Customer Age` BETWEEN 17 and 24 THEN "17-24"
		WHEN `Customer Age` BETWEEN 25 and 34 THEN "25-34"
		WHEN `Customer Age` BETWEEN 35 and 44 THEN "35-44"
		WHEN `Customer Age` BETWEEN 45 and 54 THEN "45-54"
		WHEN `Customer Age` BETWEEN 55 and 64 THEN "55-64"
		ELSE "65+" 
	END
    ORDER BY `Age Range` ASC;
    

    