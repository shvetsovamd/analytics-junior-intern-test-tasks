-- Создаю таблицу

DROP TABLE IF EXISTS shop;

CREATE TABLE shop (
  	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	city varchar(50),
	product varchar(255),
	cost integer,
	`date` date
);

-- Заполняю данными из примера

INSERT INTO shop (city, product, cost, `date`)
VALUES ('Москва', 'Банан', 55, '01.01.2024'),
	('Москва', 'Банан', 60, '02.01.2024'),
	('Москва', 'Банан', 58, '03.01.2024'),
	('Москва', 'Яблоко', 35, '01.01.2024'),
	('Москва', 'Яблоко', 35, '02.01.2024'),
	('Москва', 'Вода', 90, '01.01.2024'),
	('Москва', 'Вода', 90, '02.01.2024'),
	('Москва', 'Вода', 100, '03.01.2024'),
	('Самара', 'Банан', 50, '02.01.2024'),
	('Самара', 'Банан', 44, '03.01.2024'),
	('Самара', 'Хлеб', 40, '01.01.2024'),
	('Самара', 'Хлеб', 40, '02.01.2024'),
	('Самара', 'Хлеб', 40, '03.01.2024'),
	('Киров', 'Вода', 70, '01.01.2024'),
	('Киров', 'Вода', 69, '02.01.2024'),
	('Киров', 'Вода', 70, '03.01.2024'),
	('Киров', 'Мороженное', 90, '01.01.2024'),
	('Киров', 'Мороженное', 95, '02.01.2024'),
	('Киров', 'Мороженное', 92, '03.01.2024');

SELECT * FROM shop;

-- По каждому городу количество продуктов, продаваемых 02.01.2024

SELECT city, COUNT(product) count_product FROM shop 
WHERE `date`= '02.01.2024' GROUP BY city;

-- Минимальная стоимость каждого товара за все время работы сети магазинов

SELECT product, MIN(cost) min_cost FROM shop GROUP BY product;

-- Средняя цена всего ассортимента товаров по каждому городу на каждый день

SELECT city, `date`, AVG(cost) avg_cost FROM shop GROUP BY city, `date`;

-- Самый дорогой товар по каждому городу 03.01.2024

SELECT shop.city, product
FROM shop JOIN (
  SELECT city, MAX(cost) max_cost FROM shop 
  WHERE `date` = '03.01.2024' GROUP BY city
) t ON t.city = shop.city AND shop.cost = t.max_cost 
WHERE `date` = '03.01.2024' GROUP BY shop.city;

-- Товары, которые продавались в Кирове, но не продавались в Москве

SELECT DISTINCT product 
FROM shop LEFT JOIN (
  SELECT DISTINCT product 
  FROM shop WHERE city = 'Москва'
) m USING(product)
WHERE shop.city = 'Киров' AND m.product IS NULL;

-- Средняя цена каждого товара на каждый день в сети магазинов

SELECT product, `date`, AVG(cost) avg_cost FROM shop GROUP BY product, `date`;

-- Сколько товаров продается ежедневно в сети магазинов. И сколько уникальных.

SELECT `date`, COUNT(product) count_product, COUNT(DISTINCT product) count_distinct_product 
FROM shop GROUP BY `date`;

-- По каждому товару вывести город, в котором он был самым дорогим

SELECT shop.product, city
FROM shop JOIN (
  SELECT product, MAX(cost) max_cost FROM shop GROUP BY product
) t ON t.product = shop.product AND shop.cost = t.max_cost 
GROUP BY shop.product;

-- *Ежедневная динамика количества ассортимента сети магазинов

WITH daily_count AS (
  SELECT `date`, COUNT(DISTINCT product) cnt FROM shop GROUP BY `date`
)
SELECT `date`, cnt, cnt - LAG(cnt, 1, cnt) OVER (ORDER BY `date`) dynamics
FROM daily_count ORDER BY `date`;

-- **По каждому товару - средняя динамика изменения цены 
-- по каждому городу за все время работы сети магазинов

WITH dynamics AS (
  SELECT city, product, `date`, cost, LAG(cost) OVER (
    PARTITION BY city, product ORDER BY `date`
  ) prev_cost
  FROM shop
)
SELECT city, product, AVG(cost - prev_cost) avg_dynamics
FROM dynamics WHERE prev_cost IS NOT NULL
GROUP BY city, product ORDER BY city, product;
