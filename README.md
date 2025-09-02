# PostgreSQL Docker Setup

Этот проект содержит полную настройку для развертывания PostgreSQL в Docker контейнере на сервере.

## Структура проекта

```
.
├── Dockerfile              # Docker образ для PostgreSQL
├── docker-compose.yml      # Конфигурация Docker Compose
├── env.example            # Пример файла конфигурации
├── init-scripts/          # Скрипты инициализации БД
│   ├── 01-init-db.sh      # Основной скрипт инициализации
│   └── 02-sample-data.sql # Тестовые данные
├── backups/               # Директория для бэкапов
└── README.md              # Этот файл
```

## Пошаговая инструкция по развертыванию

### 1. Подготовка сервера

Убедитесь, что на сервере установлены:

- Docker (версия 20.10+)
- Docker Compose (версия 2.0+)

```bash
# Проверка версий
docker --version
docker-compose --version
```

### 2. Клонирование проекта

```bash
# Клонируйте проект на сервер
git clone <your-repo-url>
cd YDLdocker
```

### 3. Настройка конфигурации

```bash
# Скопируйте пример конфигурации
cp env.example .env

# Отредактируйте файл .env с вашими настройками
nano .env
```

**Важные параметры для изменения:**

- `POSTGRES_PASSWORD` - пароль для пользователя postgres
- `PGADMIN_PASSWORD` - пароль для pgAdmin
- `POSTGRES_PORT` - порт для PostgreSQL (по умолчанию 5432)
- `PGADMIN_PORT` - порт для pgAdmin (по умолчанию 8080)

### 4. Запуск контейнеров

```bash
# Сборка и запуск контейнеров
docker-compose up -d

# Проверка статуса
docker-compose ps
```

### 5. Проверка работоспособности

```bash
# Проверка логов PostgreSQL
docker-compose logs postgres

# Проверка логов pgAdmin
docker-compose logs pgadmin

# Подключение к базе данных
docker-compose exec postgres psql -U postgres -d mydatabase
```

### 6. Доступ к сервисам

- **PostgreSQL**: `localhost:5432` (или ваш сервер:5432)
- **pgAdmin**: `http://localhost:8080` (или http://ваш-сервер:8080)

## Управление контейнерами

### Основные команды

```bash
# Запуск контейнеров
docker-compose up -d

# Остановка контейнеров
docker-compose down

# Перезапуск контейнеров
docker-compose restart

# Просмотр логов
docker-compose logs -f

# Обновление образов
docker-compose pull
docker-compose up -d
```

### Резервное копирование

```bash
# Создание бэкапа
docker-compose exec postgres pg_dump -U postgres mydatabase > backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Восстановление из бэкапа
docker-compose exec -T postgres psql -U postgres mydatabase < backups/backup_file.sql
```

### Мониторинг

```bash
# Статистика использования ресурсов
docker stats

# Проверка здоровья контейнеров
docker-compose ps
```

## Безопасность

### Рекомендации по безопасности:

1. **Измените пароли по умолчанию** в файле `.env`
2. **Используйте сильные пароли** (минимум 12 символов)
3. **Ограничьте доступ к портам** через файрвол
4. **Регулярно обновляйте** Docker образы
5. **Настройте SSL/TLS** для продакшн среды

### Настройка файрвола (Ubuntu/Debian):

```bash
# Разрешить только необходимые порты
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 5432/tcp  # PostgreSQL (только для внутренней сети)
sudo ufw allow 8080/tcp  # pgAdmin (только для админов)
sudo ufw enable
```

## Устранение неполадок

### Частые проблемы:

1. **Порт уже используется:**

   ```bash
   # Проверка занятых портов
   sudo netstat -tulpn | grep :5432

   # Изменение порта в .env файле
   POSTGRES_PORT=5433
   ```

2. **Проблемы с правами доступа:**

   ```bash
   # Проверка прав на директории
   ls -la

   # Установка правильных прав
   chmod 755 init-scripts/
   chmod 644 init-scripts/*.sh
   ```

3. **Контейнер не запускается:**

   ```bash
   # Просмотр подробных логов
   docker-compose logs postgres

   # Пересборка контейнера
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

## Дополнительные возможности

### Подключение внешних приложений

Пример строки подключения:

```
postgresql://postgres:your_password@your_server:5432/mydatabase
```

### Расширения PostgreSQL

Для добавления расширений создайте файл `init-scripts/03-extensions.sql`:

```sql
-- Создание расширений
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
```

## Поддержка

При возникновении проблем:

1. Проверьте логи: `docker-compose logs`
2. Убедитесь в правильности конфигурации в `.env`
3. Проверьте доступность портов
4. Обратитесь к документации PostgreSQL и Docker
