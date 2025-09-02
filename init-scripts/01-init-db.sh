#!/bin/bash
set -e

# Скрипт инициализации базы данных
echo "Инициализация базы данных..."

# Создаем дополнительные базы данных если нужно
# createdb -U postgres test_db

# Создаем пользователей
# psql -U postgres -c "CREATE USER app_user WITH PASSWORD 'app_password';"
# psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO app_user;"

# Создаем таблицы
psql -U postgres -d mydatabase -c "
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создаем индексы для оптимизации
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at);
"

echo "База данных успешно инициализирована!"
