# Используем официальный образ PostgreSQL
FROM postgres:15-alpine

# Устанавливаем рабочую директорию
WORKDIR /docker-entrypoint-initdb.d

# Копируем скрипты инициализации
COPY ./init-scripts/ /docker-entrypoint-initdb.d/

# Устанавливаем права на выполнение
RUN chmod +x /docker-entrypoint-initdb.d/*.sh

# Открываем порт PostgreSQL
EXPOSE 5432

# Используем стандартную команду запуска PostgreSQL
CMD ["postgres"]
