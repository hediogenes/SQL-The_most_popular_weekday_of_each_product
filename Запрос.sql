SELECT
	product_id, -- product_id является товаром
	MODE() WITHIN GROUP (ORDER BY
	CASE EXTRACT(DOW FROM order_purchase_timestamp)
		WHEN 0 THEN 'Sunday'
	    WHEN 1 THEN 'Monday'
	    WHEN 2 THEN 'Tuesday'
	    WHEN 3 THEN 'Wednsday'
	    WHEN 4 THEN 'Thursday'
	    WHEN 5 THEN 'Friday'
	    WHEN 6 THEN 'Saturday'
    END) AS order_purchase_weekday,
/*
 * Для поиска популярнейшего дня недели для каждого товара я использовал функцию MODE(), которая определяет наиболее часто встречающееся значение в колонке.
 * Мода считается по колонке с датами покупки каждого заказа - order_purchase_timestamp.
 * Однако меня интересуют не даты, а дни недели. Поэтому я использовал выражение CASE и функцию EXTRACT.
 * EXTRACT вычислила DOW (Day Of Week - День Недели) из order_purchase_timestamp в виде чисел, где Воскресение = 0, Понедельник = 1 и т.д.
 * CASE поменяла числовые значения дней недели на буквенные, превратив 0 в Воскресение и т.д.
 * 
 * Итоговый столбец получил название 'order_purchase_weekday'.
 */
    MAX(CASE EXTRACT(DOW FROM order_purchase_timestamp)
		WHEN 0 THEN 'Sunday'
	    WHEN 1 THEN 'Monday'
	    WHEN 2 THEN 'Tuesday'
	    WHEN 3 THEN 'Wednsday'
	    WHEN 4 THEN 'Thursday'
	    WHEN 5 THEN 'Friday'
	    WHEN 6 THEN 'Saturday'
    END) AS last_sale
/*
 * Для поиска последнего дня недели, в который покупался каждый товар, я использовал функцию MAX(), которая определяет максимальное/последнее значение в колонке.
 * Функцию MAX() я применил к order_purchase_timestamp.
 * Комбинацию CASE EXTRACT я использовал в том же виде, как и в прошлый раз.
 * 
 * Итоговый столбец получил название 'last_sale'.
 */
FROM e_shop.olist_order_items_dataset a LEFT JOIN e_shop.olist_orders_dataset b ON (a.order_id = b.order_id) -- Соеденил оба датасета, сохранив данные о всех купленных товарах.
GROUP BY product_id -- Сделал группировку по product_id.
ORDER BY product_id ASC
LIMIT 10
