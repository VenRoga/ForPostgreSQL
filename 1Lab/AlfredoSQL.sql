CREATE TYPE item_status_type AS ENUM (
    'принято', 
    'на_продаже', 
    'выкуплено', 
    'продано_с_витрины'
);

Create Table Item_type (
	item_type_id	SERIAL	PRIMARY KEY,
	item_type_name	TEXT	NOT NULL
);

Create Table Materials (
	materials_id		SERIAL	PRIMARY KEY,
	materials_type		TEXT	NOT NULL,
	materials_purity	INT		NOT NULL
);

Create Table Item (
	item_id				SERIAL 			PRIMARY KEY,
	item_type_id		INT 			NOT NULL REFERENCES Item_type(item_type_id),
	item_percent_wear	INT 			NOT NULL CHECK(item_percent_wear BETWEEN 0 AND 100),
	item_summ			NUMERIC(12,2) 	NOT NULL CHECK(item_summ > 0),
	item_status			item_status_type NOT NULL ,
	item_active_pawn_id INT            	UNIQUE,
	item_sale_price     NUMERIC(12,2)   CHECK(item_sale_price >= 0), 
    item_sale_date      DATE
);

Create Table Composition(
	composition_id				INT 			NOT NULL REFERENCES Item(item_id) ON DELETE CASCADE,
	composition_materials_id	INT 			NOT NULL REFERENCES	Materials(materials_id) ON DELETE RESTRICT,
	composition_weight			NUMERIC(5,2) 	NOT NULL CHECK(composition_weight > 0),
	PRIMARY KEY(composition_id, composition_materials_id)
);

Create Table Client (
	client_id				SERIAL		PRIMARY KEY,
	client_last_name		TEXT  		NOT NULL,
	client_first_name		TEXT		NOT NULL,
	client_middle_name		TEXT,
	client_passport_seria	CHAR(4)		NOT NULL CHECK(client_passport_seria ~ '[0-9]{4}$'),
	client_passport_number	CHAR(6)		NOT NULL CHECK(client_passport_number ~ '[0-9]{6}$'),
	client_address			TEXT		NOT NULL,
	CONSTRAINT	
		client_passport_uq UNIQUE (client_passport_seria,client_passport_number)
);

Create Table Pawn (
	pawn_id					SERIAL 				PRIMARY KEY,
	pawn_client_id			INT 				NOT NULL REFERENCES Client(client_id),
	pawn_item_id			INT					NOT NULL UNIQUE REFERENCES Item(item_id),
	pawn_sign_date			DATE				NOT NULL,
	pawn_summ				NUMERIC(12,2)		NOT NULL CHECK(pawn_summ > 0),
	pawn_comis				INT					NOT NULL CHECK(pawn_comis BETWEEN 0 AND 100),
	pawn_end_date			DATE				NOT NULL,
	pawn_redemption_date	DATE,				
	CONSTRAINT pawn_chkdate CHECK (
        pawn_end_date > pawn_sign_date AND 
        (pawn_redemption_date IS NULL OR pawn_redemption_date >= pawn_sign_date)
    )
);

ALTER TABLE Item 
	ADD CONSTRAINT item_active_pawn_fk 
	FOREIGN KEY (item_active_pawn_id) REFERENCES Pawn(pawn_id) ON DELETE SET NULL
