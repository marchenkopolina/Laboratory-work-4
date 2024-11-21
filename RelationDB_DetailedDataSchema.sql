-- Видалення існуючих таблиць (якщо вони є)
DROP TABLE IF EXISTS MediaMaterials CASCADE;
DROP TABLE IF EXISTS Atmosphere CASCADE;
DROP TABLE IF EXISTS SafetyMeasures CASCADE;
DROP TABLE IF EXISTS Dish CASCADE;
DROP TABLE IF EXISTS Menu CASCADE;
DROP TABLE IF EXISTS "Order" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;

-- Створення таблиці "User"
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT email_format CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
);

-- Створення таблиці "Order"
CREATE TABLE "Order" (
    order_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('нове', 'виконане')),
    user_id INT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES "User" (user_id) ON DELETE CASCADE
);

-- Створення таблиці "Menu"
CREATE TABLE "Menu" (
    menu_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('основне', 'напої', 'десерти'))
);

-- Створення таблиці "Dish"
CREATE TABLE "Dish" (
    dish_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DOUBLE PRECISION CHECK (price > 0),
    description TEXT,
    menu_id INT NOT NULL,
    order_id INT,
    CONSTRAINT fk_menu FOREIGN KEY (menu_id) REFERENCES "Menu" (menu_id) ON DELETE CASCADE,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES "Order" (order_id) ON DELETE SET NULL
);

-- Створення таблиці "SafetyMeasures"
CREATE TABLE "SafetyMeasures" (
    measure_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    last_updated DATE,
    order_id INT NOT NULL,
    CONSTRAINT fk_order_measures FOREIGN KEY (order_id) REFERENCES "Order" (order_id) ON DELETE CASCADE
);

-- Створення таблиці "Atmosphere"
CREATE TABLE "Atmosphere" (
    atmosphere_id SERIAL PRIMARY KEY,
    description TEXT,
    design TEXT,
    measure_id INT NOT NULL,
    CONSTRAINT fk_measure FOREIGN KEY (measure_id) REFERENCES "SafetyMeasures" (measure_id) ON DELETE CASCADE
);

-- Створення таблиці "MediaMaterials"
CREATE TABLE "MediaMaterials" (
    media_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL CHECK (type IN ('фото', 'відео')),
    name VARCHAR(100),
    url VARCHAR(255) NOT NULL,
    atmosphere_id INT NOT NULL,
    CONSTRAINT url_format CHECK (url ~ '^(https?|ftp)://[^\s/$.?#].[^\s]*$'),
    CONSTRAINT fk_atmosphere FOREIGN KEY (atmosphere_id) REFERENCES "Atmosphere" (atmosphere_id) ON DELETE CASCADE
);
