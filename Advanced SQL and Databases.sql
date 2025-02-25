
1.1 QUERY

SELECT
  customer.CustomerID AS customerid,
  contact.Firstname,
  contact.LastName,
  CONCAT(contact.Firstname, ' ',contact.LastName) AS full_name,
 CONCAT(
  COALESCE(NULLIF(contact.Title, ''), 'Dear '),contact.LastName) AS addressing_title,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  IFNULL(address.AddressLine2,'') AS AddressLine2,
  MIN( stateprovince.name) AS state,
  MIN( countryregion.Name) AS country,
  COUNT(SalesOrderHeader.SalesOrderID) AS number_orders,
  ROUND(SUM(SalesOrderHeader.TotalDue),3) AS total_amount,
  MAX(SalesOrderHeader.OrderDate) AS date_last_order
FROM`adwentureworks_db.customer` AS customer
JOIN`adwentureworks_db.individual` AS individual -- TO connect tables
ON individual.CustomerID=customer.CustomerID
JOIN `adwentureworks_db.contact` AS contact
ON individual.ContactID=contact.ContactId
JOIN`adwentureworks_db.customeraddress` AS customeraddress --to connect tables
ON customer.CustomerID=customeraddress.CustomerID
JOIN `adwentureworks_db.address` AS address
ON customeraddress.AddressID=address.AddressID
JOIN `adwentureworks_db.salesorderheader` AS SalesOrderHeader
ON contact.contactid=SalesOrderHeader.ContactID
JOIN `adwentureworks_db.salesterritory` AS Salesterritory
ON SalesOrderHeader.TerritoryID=Salesterritory.TerritoryID
JOIN `adwentureworks_db.stateprovince` AS stateprovince
ON Salesterritory.TerritoryID=stateprovince.TerritoryID
  AND address.StateProvinceID=stateprovince.StateProvinceID
JOIN `adwentureworks_db.countryregion` AS countryregion
ON stateprovince.CountryRegionCode=countryregion.CountryRegionCode
WHERE
  address.AddressID = (
  SELECT
    MAX(AddressID)
  FROM  `adwentureworks_db.customeraddress` AS customeradd
  WHERE customeradd.CustomerID = customer.customerid)
GROUP BY
  customer.CustomerID,
  contact.Firstname,
  contact.LastName,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  address.AddressLine2,
  full_name,
  addressing_title
ORDER BY total_amount DESC
LIMIT 200

1.2 QUERY

SELECT
  customer.CustomerID AS customerid,
  contact.Firstname,
  contact.LastName,
  CONCAT(contact.Firstname, ' ',contact.LastName) AS full_name,
  CONCAT(
  COALESCE(NULLIF(contact.Title, ''), 'Dear '),contact.LastName) AS addressing_title,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  IFNULL(address.AddressLine2,'') AS AddressLine2,
  MIN( stateprovince.name) AS state,
  MIN( countryregion.Name) AS country,
  COUNT(SalesOrderHeader.SalesOrderID) AS number_orders,
  ROUND(SUM(SalesOrderHeader.TotalDue),3) AS total_amount,
  MAX(SalesOrderHeader.OrderDate) AS date_last_order
FROM`adwentureworks_db.customer` AS customer
JOIN`adwentureworks_db.individual` AS individual -- TO connect tables
ON individual.CustomerID=customer.CustomerID
JOIN `adwentureworks_db.contact` AS contact
ON individual.ContactID=contact.ContactId
JOIN`adwentureworks_db.customeraddress` AS customeraddress --to connect tables
ON customer.CustomerID=customeraddress.CustomerID
JOIN `adwentureworks_db.address` AS address
ON customeraddress.AddressID=address.AddressID
JOIN `adwentureworks_db.salesorderheader` AS SalesOrderHeader
ON contact.contactid=SalesOrderHeader.ContactID
JOIN `adwentureworks_db.salesterritory` AS Salesterritory
ON SalesOrderHeader.TerritoryID=Salesterritory.TerritoryID
JOIN `adwentureworks_db.stateprovince` AS stateprovince
ON Salesterritory.TerritoryID=stateprovince.TerritoryID
  AND address.StateProvinceID=stateprovince.StateProvinceID
JOIN `adwentureworks_db.countryregion` AS countryregion
ON stateprovince.CountryRegionCode=countryregion.CountryRegionCode
WHERE
  address.AddressID = (
  SELECT
    MAX(AddressID)
  FROM  `adwentureworks_db.customeraddress` AS customeradd
  WHERE customeradd.CustomerID = customer.customerid)
  AND COALESCE(SalesOrderHeader.OrderDate) <= TIMESTAMP_ADD((select max(OrderDate) from`adwentureworks_db.salesorderheader`), INTERVAL -365 DAY)
GROUP BY
  customer.CustomerID,
  contact.Firstname,
  contact.LastName,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  address.AddressLine2,
  full_name,
  addressing_title
ORDER BY total_amount DESC
LIMIT 200

1.3 QUERY

SELECT
  customer.CustomerID AS customerid,
  contact.Firstname,
  contact.LastName,
  CONCAT(contact.Firstname, ' ',contact.LastName) AS full_name,
   CONCAT(
  COALESCE(NULLIF(contact.Title, ''), 'Dear '),contact.LastName) AS addressing_title,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  IFNULL(address.AddressLine2,'') AS AddressLine2,
  MIN( stateprovince.name) AS state,
  MIN( countryregion.Name) AS country,
  COUNT(SalesOrderHeader.SalesOrderID) AS number_orders,
  ROUND(SUM(SalesOrderHeader.TotalDue),3) AS total_amount,
  MAX(SalesOrderHeader.OrderDate) AS date_last_order,
  CASE
    WHEN (MAX(SalesOrderHeader.OrderDate)) >TIMESTAMP_ADD((select max(OrderDate) from`adwentureworks_db.salesorderheader`), INTERVAL -365 DAY) THEN 'active'
    ELSE 'Inactive'
    END AS Marks
FROM`adwentureworks_db.customer` AS customer
JOIN`adwentureworks_db.individual` AS individual -- TO connect tables
ON individual.CustomerID=customer.CustomerID
JOIN `adwentureworks_db.contact` AS contact
ON individual.ContactID=contact.ContactId
JOIN`adwentureworks_db.customeraddress` AS customeraddress --to connect tables
ON customer.CustomerID=customeraddress.CustomerID
JOIN `adwentureworks_db.address` AS address
ON customeraddress.AddressID=address.AddressID
JOIN `adwentureworks_db.salesorderheader` AS SalesOrderHeader
ON contact.contactid=SalesOrderHeader.ContactID
JOIN `adwentureworks_db.salesterritory` AS Salesterritory
ON SalesOrderHeader.TerritoryID=Salesterritory.TerritoryID
JOIN `adwentureworks_db.stateprovince` AS stateprovince
ON Salesterritory.TerritoryID=stateprovince.TerritoryID
  AND address.StateProvinceID=stateprovince.StateProvinceID
JOIN `adwentureworks_db.countryregion` AS countryregion
ON stateprovince.CountryRegionCode=countryregion.CountryRegionCode
WHERE
  address.AddressID = (
  SELECT
    MAX(AddressID)
  FROM  `adwentureworks_db.customeraddress` AS customeradd
  WHERE customeradd.CustomerID = customer.customerid)
GROUP BY
  customer.CustomerID,
  contact.Firstname,
  contact.LastName,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  address.AddressLine2,
  full_name,
  addressing_title
ORDER BY customerid DESC
LIMIT 500

1.4 QUERY

SELECT
  customer.CustomerID AS customerid,
  contact.Firstname,
  contact.LastName,
  CONCAT(contact.Firstname, ' ',contact.LastName) AS full_name,
  CONCAT(
  IF (contact.Title IS NOT NULL
      AND contact.Title <> '', CONCAT(contact.Title, ' '), 'Dear '),contact.LastName) AS addressing_title,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  IFNULL(address.AddressLine2,'') AS AddressLine2,
  REGEXP_EXTRACT(address.AddressLine1, r'^\d+') AS address_no,
  REGEXP_EXTRACT(address.AddressLine1, r'^\d+\s+(.*)') AS address_st,
  MIN( stateprovince.name) AS state,
  MIN( countryregion.Name) AS country,
  COUNT(SalesOrderHeader.SalesOrderID) AS number_orders,
  ROUND(SUM(SalesOrderHeader.TotalDue),3) AS total_amount,
  MAX(SalesOrderHeader.OrderDate) AS date_last_order,
  CASE
    WHEN DATE(MAX(SalesOrderHeader.OrderDate)) >=DATE_SUB('2004-07-31', INTERVAL 365 DAY) THEN 'active'
    ELSE 'Inactive'
    END AS Marks
FROM`adwentureworks_db.customer` AS customer
JOIN`adwentureworks_db.individual` AS individual -- TO connect tables
ON individual.CustomerID=customer.CustomerID
JOIN `adwentureworks_db.contact` AS contact
ON individual.ContactID=contact.ContactId
JOIN`adwentureworks_db.customeraddress` AS customeraddress --to connect tables
ON customer.CustomerID=customeraddress.CustomerID
JOIN `adwentureworks_db.address` AS address
ON customeraddress.AddressID=address.AddressID
JOIN `adwentureworks_db.salesorderheader` AS SalesOrderHeader
ON contact.contactid=SalesOrderHeader.ContactID
JOIN `adwentureworks_db.salesterritory` AS Salesterritory
ON SalesOrderHeader.TerritoryID=Salesterritory.TerritoryID
JOIN `adwentureworks_db.stateprovince` AS stateprovince
ON Salesterritory.TerritoryID=stateprovince.TerritoryID
  AND address.StateProvinceID=stateprovince.StateProvinceID
JOIN `adwentureworks_db.countryregion` AS countryregion
ON stateprovince.CountryRegionCode=countryregion.CountryRegionCode
WHERE
  address.AddressID = (
  SELECT
    MAX(AddressID)
  FROM  `adwentureworks_db.customeraddress` AS customeradd
  WHERE customeradd.CustomerID = customer.customerid)
GROUP BY
  customer.CustomerID,
  contact.Firstname,
  contact.LastName,
  contact.Emailaddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  address.AddressLine2,
  address_no,
  address_st,
  full_name,
  addressing_title,
  Salesterritory.Group
HAVING (SUM(SalesOrderHeader.TotalDue) >=2500 OR COUNT(SalesOrderHeader.SalesOrderID) >=5) AND Salesterritory.Group = 'North America'
ORDER BY country

2.1 QUERY

SELECT
LAST_DAY(CAST(salesorderheader.OrderDate AS DATE)) AS order_month_end,
  salesterritory.CountryRegionCode,
  salesterritory.Name AS Region,
  COUNT(salesorderheader.SalesOrderID) AS number_orders,
  COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
  COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesperson,
  CAST(SUM(salesorderheader.TotalDue) AS int64) AS total_w_tax,
FROM `adwentureworks_db.salesorderheader` AS salesorderheader
JOIN `adwentureworks_db.salesterritory` AS salesterritory
ON salesorderheader.territoryid=salesterritory.TerritoryID
GROUP BY order_month_end,salesterritory.CountryRegionCode,salesterritory.Name

2,2 QUERY

WITH cumulative_data AS
  (SELECT DISTINCT sales.OrderDate AS order_date,
  territory.countryregioncode AS country_region,
  territory.name AS territory_Name,
  CAST(FLOOR(SUM(sales.TotalDue) OVER (PARTITION BY territory.countryregioncode,territory.name ORDER BY sales.OrderDate))AS INT64) AS cumulative_sum
FROM `adwentureworks_db.salesorderheader` AS sales
JOIN `adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID=territory.TerritoryID) -- CTE table
  SELECT
    LAST_DAY(CAST(salesorderheader.OrderDate AS DATE)) AS order_month_end,
    salesterritory.CountryRegionCode,
    salesterritory.Name AS Region,
    COUNT(salesorderheader.SalesOrderID) AS number_orders,
    COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesperson,
    CAST(FLOOR(SUM(salesorderheader.TotalDue))AS INT64) AS total_w_tax,
    MAX(cumulative_sum) AS cumulative_sum --CTE
  FROM `adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN `adwentureworks_db.salesterritory` AS salesterritory
  ON salesorderheader.territoryid=salesterritory.TerritoryID
  JOIN cumulative_data --CTE
  ON salesorderheader.OrderDate = cumulative_data.Order_Date --CTE
  AND salesterritory.CountryRegionCode=cumulative_data.country_region -- CTE
  AND salesterritory.Name=cumulative_data.territory_Name -- CTE
  GROUP BY 
    order_month_end,
    salesterritory.CountryRegionCode,
    salesterritory.Name
  ORDER BY order_month_end

2,3 QUERY

WITH cumulative_data AS
  (SELECT DISTINCT sales.OrderDate AS order_date,
  territory.countryregioncode AS country_region,
  territory.name AS territory_Name,
  CAST(FLOOR(SUM(sales.TotalDue) OVER (PARTITION BY territory.countryregioncode,territory.name ORDER BY sales.OrderDate))AS INT64) AS cumulative_sum
FROM `adwentureworks_db.salesorderheader` AS sales
JOIN `adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID=territory.TerritoryID) -- CTE table
  SELECT
    LAST_DAY(CAST(salesorderheader.OrderDate AS DATE)) AS order_month_end,
    salesterritory.CountryRegionCode,
    salesterritory.Name AS Region,
    COUNT(salesorderheader.SalesOrderID) AS number_orders,
    COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesperson,
    CAST(FLOOR(SUM(salesorderheader.TotalDue))AS INT64) AS total_w_tax,
    RANK() OVER (PARTITION BY salesterritory.CountryRegionCode,salesterritory.Name ORDER BY SUM(salesorderheader.TotalDue)DESC) AS country_sales_rank,
    MAX(cumulative_sum) AS cumulative_sum --CTE
  FROM `adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN `adwentureworks_db.salesterritory` AS salesterritory
  ON salesorderheader.territoryid=salesterritory.TerritoryID
  JOIN cumulative_data --CTE
  ON salesorderheader.OrderDate = cumulative_data.Order_Date --CTE
  AND salesterritory.CountryRegionCode=cumulative_data.country_region -- CTE
  AND salesterritory.Name=cumulative_data.territory_Name -- CTE
  GROUP BY 
    order_month_end,
    salesterritory.CountryRegionCode,
    salesterritory.Name
HAVING salesterritory.Name='France'
 


 
 
2,4 QUERY

WITH cumulative_data AS(
SELECT DISTINCT sales.OrderDate AS order_date,
territory.countryregioncode AS country_region,
territory.name AS territory_Name,
CAST(FLOOR(SUM(sales.TotalDue) OVER (PARTITION BY territory.countryregioncode,territory.name ORDER BY sales.OrderDate))AS INT64) AS cumulative_sum
FROM `adwentureworks_db.salesorderheader` AS sales
JOIN `adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID=territory.TerritoryID
), -- CTE1 table
  max_tax_per_state AS (
  SELECT
  stateprovince.CountryRegionCode AS country,
  stateprovince.Name AS state,
  MAX(salestaxrate.TaxRate) AS max_tax_rate
  FROM `adwentureworks_db.stateprovince` AS stateprovince
  JOIN `adwentureworks_db.salestaxrate` AS salestaxrate
  ON stateprovince.StateProvinceID = salestaxrate.StateProvinceID
  GROUP BY stateprovince.CountryRegionCode, stateprovince.Name
  ),--CTE2 table
    mean_tax_rate_per_country AS (
    SELECT
    country,
    AVG(max_tax_rate) AS tax_rate
    FROM max_tax_per_state
    GROUP BY country
    ),--CTE3 table
      tax_rates_for_each_country AS (
      SELECT stateprovince.CountryRegionCode AS Alais,
      COUNT(DISTINCT salestaxrate.salestaxrateID) AS sales_for_each_country
      FROM `adwentureworks_db.stateprovince` AS stateprovince
      JOIN `adwentureworks_db.salestaxrate` AS salestaxrate
      ON stateprovince.StateProvinceID=salestaxrate.StateProvinceID
      GROUP BY stateprovince.CountryRegionCode
      ), -- CTE 4
      number_of_provinces AS (
      SELECT stateprovince.CountryRegionCode AS Alais,
      COUNT(stateprovince.StateProvinceID) AS Provinces_number
      FROM `adwentureworks_db.stateprovince` AS stateprovince
      GROUP BY stateprovince.CountryRegionCode
      ) --CTE5
SELECT
LAST_DAY(CAST(salesorderheader.OrderDate AS DATE)) AS order_month_end,
salesterritory.CountryRegionCode,
salesterritory.Name AS Region,
COUNT(salesorderheader.SalesOrderID) AS number_orders,
COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesperson,
CAST(FLOOR(SUM(salesorderheader.TotalDue))AS INT64) AS total_w_tax,
RANK() OVER (PARTITION BY salesterritory.CountryRegionCode,salesterritory.Name ORDER BY SUM(salesorderheader.TotalDue)DESC) AS country_sales_rank,
MAX(cumulative_sum) AS cumulative_sum, --CTE1
ROUND(AVG(mean_tax_rate_per_country.tax_rate),1) AS mean_tax_rate, --CTE2
ROUND(AVG(tax_rates_for_each_country.sales_for_each_country)/AVG(number_of_provinces.Provinces_number),2) AS perc_provinces_w_tax

  FROM `adwentureworks_db.salesorderheader` AS salesorderheader
  JOIN `adwentureworks_db.salesterritory` AS salesterritory
  ON salesorderheader.territoryid=salesterritory.TerritoryID
  JOIN `adwentureworks_db.stateprovince` AS stateprovince
  ON salesterritory.TerritoryID = stateprovince.TerritoryID
  JOIN cumulative_data --CTE1
  ON salesorderheader.OrderDate = cumulative_data.Order_Date --CTE1
  AND salesterritory.CountryRegionCode=cumulative_data.country_region --CTE1
  AND salesterritory.Name=cumulative_data.territory_Name --CTE1
  JOIN mean_tax_rate_per_country --CTE2
  ON stateprovince.CountryRegionCode = mean_tax_rate_per_country.country --MAIN TABLE+CTE3
  JOIN tax_rates_for_each_country --CTE4
  ON stateprovince.CountryRegionCode=tax_rates_for_each_country.Alais --MAIN TABLE+CTE4
  JOIN number_of_provinces --CTE5
  ON tax_rates_for_each_country.alais=number_of_provinces.Alais --CT4+CTE 5
GROUP BY ALL
HAVING salesterritory.Name='Southwest'