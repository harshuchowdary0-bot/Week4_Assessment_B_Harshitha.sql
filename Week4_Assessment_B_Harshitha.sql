-- WEEK 4 ASSESSMENT
-- NAME :B HARSHITHA 
 -- SECTION A
 Q1. INNER JOIN versus LEFT JOIN
 Inner join this  gives the rows which will be appear in both the tables and where as in the left 
left jointhis will give all therows from the table and also even when there is no match in the right table 

Q2. What is PARTITION BY?
PARTITION
The partition is the rows into the groups for the window function and the rows in this stay 
themselfs as visible

Q3. What is JOIN?
Natural join is nothing but it joins tables by coloumns and share the name 

Q4. UNION versus UNION ALL
The UNION merges the results and Removes duplicate rows

Q5. Why can NOT IN behave unexpectedly with NULL?
If a subquery gives a value then comparisons 
which  can produce an unknown result and  it will not exict in its choice

Q6. What is a correlated subquery?
The  correlated subquery will refers to the value from  query and it is evaluated 
for the each outer row

Q7. Why can a window-function result not normally be filtered in WHERE?
The WHERE is evaluated before the window functionsand it will  Use a 
 Subquery to calculate the window result and then filter the results first.
 
 -- SECTION B 
 -- QUESTION AND ANSWERS
 Now predicting the out puts for the section A 
 Q8. JOIN OUTPUT
 I Understood which coloumns  will connect the tables  counting the matching the rows and cchecking 
 weather the duplicate will matches the created the addtional rows.
  
Q9. LEFT JOIN with IS NULL
This pattern will find the rows from the left table that have no matching row in the right table and
 checks the join conditin care fully.
 
Q10. SELF-JOIN
 a self-join will connects a table to itselfs and use the table aliases distingushing
 the two copies and will understand what realationship the query is finding.
 
Q11. UNION 
It will read both select statements and will combine their results  and also remember that union 
will remove the duplicate rows.

Q12. AVERAGE PRICE
It will identify which rows are included in the average and will remember that avg() ignores
NULL values ,and a WHERE the condition can change the result. 

Q13. NOT EXISTS 
it will check the each row in the outer query to see wheather the subquery that finds a matching 
the records not exists keeps the rows for which no match is found.
 
 Q14. TOP-SELLIND BOOK 
 It will identify how sales are counted  or totally and checks how the results are grouped and then determine which 
 book ranks highest and checks how it is handled.
Q15. RANK
The rank will assigns positions based on the ordering experience and tied rows 
will recieve the same rank and next rank will be skipped 
 
 -- SECTION C
 APPLIED SQL
 -- Section C: Applied SQL
-- Student: B Harshitha

-- C1: Select columns from joined tables
SELECT b.title, a.name
FROM books b
JOIN authors a
    ON b.author_id = a.author_id;

-- C2: Keep all authors, including those without books
SELECT a.name, b.title, b.genre, b.price
FROM authors a
LEFT JOIN books b
    ON a.author_id = b.author_id;

-- C3: Calculate revenue by genre
SELECT b.genre,
       SUM(s.quantity * b.price) AS total_revenue
FROM sales s
JOIN books b
    ON s.book_id = b.book_id
GROUP BY b.genre
ORDER BY total_revenue DESC;

-- C4 Check the missing JOIN
SELECT s.city, SUM(s.quantity * b.price) AS total_revenue
FROM sales s
JOIN books b ON s.book_id = b.book_id
GROUP BY s.city
ORDER BY total_revenue DESC
LIMIT 1;

-- C5 Fix the missing comma
SELECT b.title, a.name
FROM authors a
JOIN books b ON a.author_id = b.author_id;

 -- C6
 SELECT a.name, b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
UNION

SELECT a.name, b.title
FROM authors a
RIGHT JOIN books b ON a.author_id = b.author_id;
 
-- C7 Self-Join (Author and Mentor)
SELECT a.name AS author, m.name AS mentor
FROM authors a
JOIN authors m
    ON a.mentor_id = m.author_id;
 
 -- C8 CROSS JOIN (City and Customer Type)
SELECT c.city, t.customer_type
FROM (SELECT DISTINCT city FROM sales) c
CROSS JOIN
     (SELECT DISTINCT customer_type FROM sales) t;

-- C9 UNION (Authors by Country or Birth Year)
SELECT name
FROM authors
WHERE country = 'India'
UNION
SELECT name
FROM authors
WHERE born_year > 1970;

-- C10 Books Without Sales
SELECT b.book_id, b.title
FROM books b
LEFT JOIN sales s
    ON b.book_id = s.book_id
WHERE s.sale_id IS NULL;

-- C11 Books Priced Above the Average
SELECT title, price
FROM books
WHERE price > (
    SELECT AVG(price)
    FROM books
);

-- C12 Check your IN subquery
SELECT book_id, title
FROM books
WHERE genre IN ('History', 'Mythology');

-- C13 Books Priced Higher Than All Fiction Books
SELECT title, price
FROM books
WHERE price > ALL (
    SELECT price
    FROM books
    WHERE genre = 'Fiction'
);

-- C14 Books Priced Higher Than Their Genre Average
SELECT b1.title, b1.genre, b1.price
FROM books b1
WHERE b1.price > (
    SELECT AVG(b2.price)
    FROM books b2
    WHERE b2.genre = b1.genre
);

-- C15 Authors With Books Published After 2018
SELECT a.author_id, a.name
FROM authors a
WHERE EXISTS (
    SELECT 1
    FROM books b
    WHERE b.author_id = a.author_id
      AND b.published_year > 2018
);

-- C16 Authors Without Business Books
SELECT a.author_id, a.name
FROM authors a
WHERE NOT EXISTS (
    SELECT 1
    FROM books b
    WHERE b.author_id = a.author_id
      AND b.genre = 'Business'
);

-- C17 Sales of Books Written by Indian Authors
SELECT *
FROM sales
WHERE book_id IN (
    SELECT b.book_id
    FROM books b
    JOIN authors a
      ON b.author_id = a.author_id
    WHERE a.country = 'India'
);

-- C18 Average Book Price Within Each Genre
SELECT title, genre, price,
       AVG(price) OVER (
           PARTITION BY genre
       ) AS genre_avg_price
FROM books;

-- C19 Top Two Highest-Priced Books in Each Genre
WITH ranked_books AS (
    SELECT title, genre, price,
           ROW_NUMBER() OVER (
               PARTITION BY genre
               ORDER BY price DESC
           ) AS rn
    FROM books
)
SELECT title, genre, price
FROM ranked_books
WHERE rn <= 2;

-- C20 Previous Sale Quantity Using LAG()
SELECT sale_id, book_id, quantity, sale_date,
       LAG(quantity) OVER (
           ORDER BY sale_date
       ) AS previous_quantity
FROM sales
WHERE book_id = 115;

-- C21 Running Total of Sales Quantity
SELECT sale_id, sale_date, quantity,
       SUM(quantity) OVER (
           ORDER BY sale_date
       ) AS running_total_qty
FROM sales;

-- C22 Total Quantity Sold for Each Book
WITH book_totals AS (
    SELECT book_id, SUM(quantity) AS total_qty
    FROM sales
    GROUP BY book_id
)
SELECT b.title,
       COALESCE(bt.total_qty, 0) AS total_qty
FROM books b
LEFT JOIN book_totals bt
    ON b.book_id = bt.book_id;
    
-- C23 Rank Genres by Total Revenue
-- Practice: Rank genres by average book price

WITH genre_price AS (
    SELECT genre, AVG(price) AS avg_price
    FROM books
    GROUP BY genre
)
SELECT genre, avg_price,
       RANK() OVER (ORDER BY avg_price DESC) AS genre_rank
FROM genre_price;

-- C24 Top-Selling Book in Each Genre
 WITH book_qty AS (
    SELECT book_id, SUM(quantity) AS total_qty
    FROM sales
    GROUP BY book_id
)
SELECT b.title, b.genre, q.total_qty
FROM book_qty q
JOIN books b ON q.book_id = b.book_id
ORDER BY q.total_qty DESC;

---- THANK YOU ----