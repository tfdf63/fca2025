#!/bin/bash

# Скрипт автоматического развертывания PostgreSQL в Docker
# Использование: ./deploy.sh

set -e

echo "🚀 Начинаем развертывание PostgreSQL в Docker..."

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker и повторите попытку."
    exit 1
fi

# Проверка наличия Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Установите Docker Compose и повторите попытку."
    exit 1
fi

# Создание .env файла если его нет
if [ ! -f .env ]; then
    echo "📝 Создаем файл конфигурации .env..."
    cp env.example .env
    echo "⚠️  ВАЖНО: Отредактируйте файл .env и измените пароли по умолчанию!"
    echo "   nano .env"
    read -p "Нажмите Enter после изменения паролей..."
fi

# Создание необходимых директорий
echo "📁 Создаем необходимые директории..."
mkdir -p init-scripts backups

# Установка прав на выполнение для скриптов
chmod +x init-scripts/*.sh 2>/dev/null || true

# Остановка существующих контейнеров
echo "🛑 Останавливаем существующие контейнеры..."
docker-compose down 2>/dev/null || true

# Сборка и запуск контейнеров
echo "🔨 Собираем и запускаем контейнеры..."
docker-compose up -d --build

# Ожидание запуска PostgreSQL
echo "⏳ Ожидаем запуска PostgreSQL..."
sleep 10

# Проверка статуса контейнеров
echo "📊 Проверяем статус контейнеров..."
docker-compose ps

# Проверка подключения к базе данных
echo "🔍 Проверяем подключение к базе данных..."
if docker-compose exec postgres pg_isready -U postgres -d mydatabase; then
    echo "✅ PostgreSQL успешно запущен и готов к работе!"
else
    echo "❌ Ошибка при подключении к PostgreSQL"
    echo "Проверьте логи: docker-compose logs postgres"
    exit 1
fi

echo ""
echo "🎉 Развертывание завершено успешно!"
echo ""
echo "📋 Информация о сервисах:"
echo "   PostgreSQL: localhost:5432"
echo "   pgAdmin: http://localhost:8080"
echo ""
echo "🔑 Данные для подключения:"
echo "   База данных: mydatabase"
echo "   Пользователь: postgres"
echo "   Пароль: (см. в файле .env)"
echo ""
echo "📚 Полезные команды:"
echo "   Просмотр логов: docker-compose logs -f"
echo "   Остановка: docker-compose down"
echo "   Перезапуск: docker-compose restart"
echo "   Подключение к БД: docker-compose exec postgres psql -U postgres -d mydatabase"
