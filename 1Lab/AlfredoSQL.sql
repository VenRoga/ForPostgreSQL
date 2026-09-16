CREATE TYPE item_status_type AS ENUM (
    'принято', 
    'на_продаже', 
    'выкуплено', 
    'продано_с_витрины'
);

CREATE TABLE Item_type ( --глобальный справочник предметов
    item_type_id 		SERIAL 		 PRIMARY KEY,
    item_type_name 		TEXT 		 NOT NULL UNIQUE
);

CREATE TABLE Materials ( --глобальный справочник цен на материалы за вес
    materials_id 		SERIAL 			PRIMARY KEY, 
	materials_name		TEXT			NOT NULL UNIQUE,
    materials_price 	NUMERIC(12,2) 	NOT NULL CHECK (materials_price >= 0)
);

CREATE TABLE Item_type_materials (
	i_t_m_it_id		INT 	NOT NULL REFERENCES Item_type(item_type_id) ON DELETE CASCADE,
	i_t_m_m_id		INT		NOT NULL REFERENCES Materials(materials_id) ON DELETE RESTRICT,
	PRIMARY KEY (i_t_m_it_id, i_t_m_m_id)	
);

CREATE TABLE Client (
    client_id 				SERIAL 			PRIMARY KEY,
    client_last_name 		TEXT 			NOT NULL,
    client_first_name 		TEXT 			NOT NULL,
    client_middle_name 		TEXT,
    client_passport_seria 	CHAR(4) 		NOT NULL CHECK(client_passport_seria ~ '^[0-9]{4}$'),
    client_passport_number 	CHAR(6) 		NOT NULL CHECK(client_passport_number ~ '^[0-9]{6}$'),
    client_address 			TEXT 			NOT NULL,
    CONSTRAINT client_passport_uq 
		UNIQUE (client_passport_seria, client_passport_number)
);

CREATE TABLE Item (
    item_id 				SERIAL 				PRIMARY KEY,
    item_percent_wear 		INT 				NOT NULL CHECK(item_percent_wear BETWEEN 0 AND 100),
    item_summ 				NUMERIC(12,2) 		NOT NULL CHECK(item_summ > 0),
    item_status 			item_status_type 	NOT NULL DEFAULT 'принято',
    item_active_pawn_id 	INT 				UNIQUE,
    item_sale_price 		NUMERIC(12,2) 		CHECK(item_sale_price >= 0),
    item_sale_date 			DATE,
	CHECK (
    (item_sale_price IS NULL AND item_sale_date IS NULL) OR
    (item_sale_price IS NOT NULL AND item_sale_date IS NOT NULL))
);

CREATE TABLE Components (
    components_id 				SERIAL 			PRIMARY KEY,
    components_item_id 			INT 			NOT NULL REFERENCES Item(item_id) ON DELETE CASCADE,
    components_item_type_id 	INT 			NOT NULL REFERENCES Item_type(item_type_id) ON DELETE RESTRICT,
	CONSTRAINT components_item_type_uq		
		UNIQUE (components_item_id, components_item_type_id)
);

CREATE TABLE Components_Materials (  
    c_m_components_id 			INT 			NOT NULL REFERENCES Components(components_id) ON DELETE CASCADE,
    c_m_materials_id 			INT 			NOT NULL REFERENCES Materials(materials_id) ON DELETE RESTRICT,
    c_m_components_weight 		NUMERIC(5,2) 	NOT NULL CHECK (c_m_components_weight > 0),
    PRIMARY KEY (c_m_components_id, c_m_materials_id)
);

CREATE TABLE Pawn (
    pawn_id 				SERIAL 			PRIMARY KEY,
    pawn_client_id 			INT 			NOT NULL REFERENCES Client(client_id) ON DELETE RESTRICT,
    pawn_item_id 			INT 			NOT NULL REFERENCES Item(item_id) ON DELETE RESTRICT,
    pawn_sign_date 			DATE 			NOT NULL,
    pawn_summ 				NUMERIC(12,2) 	NOT NULL CHECK(pawn_summ > 0),
    pawn_comis 				INT 			NOT NULL CHECK(pawn_comis BETWEEN 0 AND 100),
    pawn_end_date 			DATE 			NOT NULL,
    pawn_redemption_date 	DATE,
    CONSTRAINT pawn_chkdate CHECK (
        pawn_end_date > pawn_sign_date AND 
        (pawn_redemption_date IS NULL OR pawn_redemption_date >= pawn_sign_date)
    )
);

ALTER TABLE Item 
    ADD CONSTRAINT item_active_pawn_fk 
    FOREIGN KEY (item_active_pawn_id) REFERENCES Pawn(pawn_id) ON DELETE SET NULL;

--внешние ключи
CREATE INDEX idx_itm_m_id            ON Item_type_materials(i_t_m_m_id);
CREATE INDEX idx_item_active_pawn_id ON Item(item_active_pawn_id);
CREATE INDEX idx_components_type_id  ON Components(components_item_type_id);
CREATE INDEX idx_cm_materials_id     ON Components_Materials(c_m_materials_id);
CREATE INDEX idx_pawn_client_id      ON Pawn(pawn_client_id);
CREATE INDEX idx_pawn_item_id        ON Pawn(pawn_item_id);
