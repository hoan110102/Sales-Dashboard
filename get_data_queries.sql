USE BikeStores
GO

-- Create Table-valued function to get net sales

CREATE OR ALTER FUNCTION sales.get_net_sales
(
    @list_price dec(10, 2),
    @quantity int,
    @discount dec(5, 2)
)
RETURNS TABLE
AS RETURN
	SELECT @list_price * (1 - @discount) * @quantity AS net_revenue
GO

-- Create Procedure to get data automatically
CREATE OR ALTER proc get_sales_data
(
    @start_year int = NULL,
    @end_year int = NULL
)
AS
BEGIN
    /*
	To update data automatically every time refresh data in Tableau, if use the command below, you don't need to pass procedure parameters.
	declare @current_year int = year(getdate());
	declare @previous_year int = @current_year-1;
	*/
    SELECT oi.order_id,
           order_date,
           DATEPART(MONTH, order_date) MONTH,
           Datepart(YEAR, order_date) YEAR,
           store_name,
           product_name,
           category_name,
           brand_name,
           oi.list_price,
           quantity,
           discount,
		   oi.list_price*quantity total_revenue,
           gns.net_revenue
    FROM sales.order_items oi
        CROSS apply sales.get_net_sales(oi.list_price, quantity, discount) AS gns
        INNER JOIN sales.orders o
            ON oi.order_id = o.order_id
        INNER JOIN sales.stores s
            ON s.store_id = o.store_id
        INNER JOIN production.products p
            ON p.product_id = oi.product_id
        INNER JOIN production.brands b
            ON b.brand_id = p.brand_id
        INNER JOIN production.categories c
            ON c.category_id = p.category_id
    WHERE 
		--Datepart(year, order_date) in (@previous_year, @current_year)
        Datepart(YEAR, order_date) IN ( @start_year, @end_year )
END
GO

--because the data here is only up to 2017, so it is not possible to pass the getdate function data directly but must use manual parameter filling
EXEC get_sales_data 2016, 2017
GO