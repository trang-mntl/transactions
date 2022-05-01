alter table transactions
add CONSTRAINT fk_user_trans
      FOREIGN KEY (buyerID) REFERENCES customers(userID);

alter table contests
add CONSTRAINT fk_user_contest
      FOREIGN KEY (winner_user) REFERENCES customers(userID);

alter table customers
add CONSTRAINT fk_user_city
      FOREIGN KEY (city) REFERENCES location(cityID);

--list all the customers in Ha Noi
SELECT name FROM customers c
WHERE c.city = (SELECT cityID FROM location WHERE city = 'Ha Noi');

--list the year-month with the most orders
SELECT TOP 1 CONCAT(YEAR(date),'-',MONTH(date)) AS order_date,
	COUNT(buyerID) AS number_order
FROM transactions
GROUP BY CONCAT(YEAR(date),'-',MONTH(date))
ORDER BY COUNT(buyerID) DESC;

--list the city name with the second-most number of customers
SELECT TOP 1 top2.city FROM
	(SELECT TOP 2 l.city, COUNT(c.userID) as user_num
	FROM location l, customers c
	WHERE l.cityID = c.city
	GROUP BY l.city
	ORDER BY COUNT(c.userID) DESC) AS top2
ORDER BY top2.user_num ASC

--list the customers who do not have a refID of 2
SELECT name
FROM customers
WHERE refID <> 2;

--list the customers who win at least 1 contest
SELECT cu.name
FROM customers cu, contests co
WHERE cu.userID = co.winner_user
GROUP BY cu.name
HAVING COUNT(contestID) > 1;

--query the name of the first customer in HCM who bought an iPhone and the date of purchase
SELECT TOP 1 c.name, t.date
FROM customers c
INNER JOIN transactions t ON c.userID = t.buyerID
INNER JOIN location l ON c.city = l.cityID 
WHERE l.city = 'Ho Chi Minh'
AND t.product like 'iPhone%'
ORDER BY t.date

--list name of all customers that have bought at least 2 products in a single month
SELECT c.name
FROM customers c
INNER JOIN transactions t ON c.userID = t.buyerID
GROUP BY c.name, MONTH(t.date)
HAVING COUNT(t.product) > 1;

--calculate 2 values from the 'customers' table : the total of all positive  values of refID, and the total of all negative values of refID
SELECT l.city, SUM(CASE WHEN c.refID > 0 then refID END) as po_num,
		SUM(CASE WHEN c.refID < 0 then refID END) as ne_num
FROM customers c, location l
WHERE c.city = l.cityID
GROUP BY l.city;