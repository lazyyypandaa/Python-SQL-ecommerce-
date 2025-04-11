SELECT * FROM ecommerce.customers;

Use ecommerce;

# List all unique cities where customers are located.
Select distinct(customer_city)
From customers;

#Find the average number of products per order, grouped by customer city.
SELECT customers.customer_city, AVG(order_item_count.oc) AS average_items_per_order
FROM customers
JOIN (
    SELECT orders.customer_id, COUNT(order_items.order_id) AS oc
    FROM orders
    JOIN order_items ON orders.order_id = order_items.order_id
    GROUP BY orders.order_id, orders.customer_id
) AS order_item_count
ON customers.customer_id = order_item_count.customer_id
GROUP BY customers.customer_city;

# Count the number of customers from each state.
Select  customer_state, count(customer_id)
From customers
group by customer_state;

# Count the number of orders placed in 2017.
Select count(order_id)
From orders
Where year(order_purchase_timestamp) = 2017;

#Calculate the number of orders per month in 2018.
Select count(order_id) as orders, monthname(order_purchase_timestamp) as months
From orders
Where year(order_purchase_timestamp) = 2018
group by months;

# Calculate the percentage of orders that were paid in installments.
Select (sum(case when payment_installments >=1 then 1 else 0 end))/count(*) *100
From payments;

# Calculate the percentage of total revenue contributed by each product category.
Select 	products.product_category as category, round(sum(payments.payment_value)/(select sum(payment_value)
from payments) * 100,2)as percentage_of_total_revenue
from products
join order_items on products.product_id = order_items.product_id
join payments on payments.order_id = order_items.order_id
Group by category;

# Find the total sales per category.
Select 	products.product_category as category, round(sum(payments.payment_value)) as total_sales
from products
join order_items on products.product_id = order_items.product_id
join payments on payments.order_id = order_items.order_id
Group by category;
