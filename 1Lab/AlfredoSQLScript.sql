SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
SELECT typname FROM pg_type WHERE typtype = 'e';

INSERT INTO Item_type (Item_type_name, is_component) VALUES
('Кольцо',        FALSE),
('Серьга',        FALSE),
('Цепочка',       FALSE),
('Браслет',       FALSE),
('Подвеска',      FALSE),
('Кулон',         TRUE),
('Замок',         TRUE),
('карточка покемона',FALSE),
('Сапфир',       	TRUE),
('Рубин',			TRUE);


INSERT INTO Materials (materials_name, materials_price) VALUES
('Золото 585',   4500.00),
('Золото 750',   5800.00),
('Серебро 925',    80.00),
('Платина 950',  3200.00),
('Палладий 500', 2500.00),
('Медь',           50.00),
('Латунь',         40.00),
('Титан',        1500.00),
('Сапфир',      12000.00),
('Рубин',       3000.00);

INSERT INTO Client (client_last_name, client_first_name, client_middle_name,
                    client_passport_seria, client_passport_number, client_address) VALUES
('Иванов',   'Иван',    'Иванович',  '1234','567890','г. Москва, ул. Ленина, д.1, кв.10'),
('Петров',   'Пётр',    'Петрович',  '1234','567891','г. Москва, ул. Мира, д.5, кв.22'),
('Сидорова', 'Анна',    'Сергеевна', '2345','111222','г. Санкт-Петербург, Невский пр., д.10'),
('Кузнецов', 'Олег',    'Андреевич', '3456','333444','г. Казань, ул. Баумана, д.7'),
('Смирнова', 'Елена',   'Викторовна','4567','555666','г. Екатеринбург, ул. Ленина, д.3'),
('Попов',    'Дмитрий', 'Олегович',  '5678','777888','г. Новосибирск, ул. Кирова, д.15'),
('Волкова',  'Мария',   'Игоревна',  '6789','999000','г. Москва, ул. Тверская, д.20'),
('Соколов',  'Артём',   NULL,        '7890','121212','г. Сочи, ул. Морская, д.8'),
('Морозова', 'Ольга',   'Павловна',  '8901','343434','г. Владивосток, ул. Светланская, д.12'),
('Лебедев',  'Николай', 'Николаевич','9012','565656','г. Самара, ул. Ленинградская, д.4');

INSERT INTO Item (item_type_id, item_percent_wear, item_status, item_kind) VALUES
(1, 10, 'принято',      'простой'),   -- 1: кольцо
(2, 5,  'на_продаже',   'простой'),   
(3, 20, 'принято',      'простой'),   
(4, 15, 'на_продаже',   'простой'),   
(5, 0,  'выкуплено',    'простой'),   
(1, 30, 'принято',      'простой'),   
(2, 25, 'продано_с_витрины', 'простой'), 
(1, 10, 'принято',      'составной'), 
(4, 5,  'на_продаже',   'составной'), 
(3, 0,  'принято',      'составной'); 

UPDATE Item
   SET item_sale_price = 15000.00,
       item_sale_date  = DATE '2025-09-15'
 WHERE item_id = 7;

INSERT INTO Item_Materials (i_m_item_id, i_m_item_kind, i_m_materials_id, i_m_weight) VALUES
(1, 'простой', 1, 5.20),   -- кольцо: золото 585
(2, 'простой', 3, 3.10),   
(3, 'простой', 1, 12.50),  
(4, 'простой', 4, 8.70),   
(5, 'простой', 1, 2.40),   
(6, 'простой', 2, 4.90),   
(7, 'простой', 3, 3.00);   

INSERT INTO Components (components_item_id, components_item_kind, components_item_type_id) VALUES
(8,  'составной', 6),  
(8,  'составной', 7), 
(9,  'составной', 8), 
(9,  'составной', 9),  
(10, 'составной', 7),  
(10, 'составной', 9);  

INSERT INTO Pawn (pawn_client_id, pawn_item_id, pawn_sign_date, pawn_summ, pawn_comis, pawn_end_date, pawn_redemption_date) VALUES

(1, 1, DATE '2025-06-01', 25000.00, 15, DATE '2025-09-01', NULL),
(1, 3, DATE '2025-07-10', 40000.00, 12, DATE '2025-10-10', NULL),

(2, 2, DATE '2025-05-20', 18000.00, 10, DATE '2025-08-20', DATE '2025-08-15'),
(2, 5, DATE '2025-06-15', 12000.00, 15, DATE '2025-09-15', DATE '2025-09-10'),

(3, 4, DATE '2025-08-01', 35000.00, 14, DATE '2025-11-01', NULL),
(3, 7, DATE '2025-08-10', 10000.00, 20, DATE '2025-11-10', DATE '2025-09-15'),

(4, 6,  DATE '2025-07-01', 22000.00, 13, DATE '2025-10-01', NULL),
(5, 8,  DATE '2025-06-20', 55000.00, 10, DATE '2025-09-20', NULL),
(6, 9,  DATE '2025-08-05', 48000.00, 12, DATE '2025-11-05', NULL),
(7, 10, DATE '2025-07-15', 30000.00, 15, DATE '2025-10-15', NULL);

UPDATE Item SET item_active_pawn_id = 1 WHERE item_id = 1;
UPDATE Item SET item_active_pawn_id = 2 WHERE item_id = 3;
UPDATE Item SET item_active_pawn_id = 5 WHERE item_id = 4;
UPDATE Item SET item_active_pawn_id = 7 WHERE item_id = 6;
UPDATE Item SET item_active_pawn_id = 8 WHERE item_id = 8;
UPDATE Item SET item_active_pawn_id = 9 WHERE item_id = 9;
UPDATE Item SET item_active_pawn_id = 10 WHERE item_id = 10;


SELECT c.client_last_name, COUNT(p.pawn_id) AS cnt
FROM Client c
JOIN Pawn p ON p.pawn_client_id = c.client_id
GROUP BY c.client_last_name
ORDER BY cnt DESC;