-- Вставка тестовых данных
INSERT INTO users (username, email) VALUES 
('admin', 'admin@example.com'),
('user1', 'user1@example.com'),
('user2', 'user2@example.com')
ON CONFLICT (username) DO NOTHING;

INSERT INTO posts (title, content, user_id) VALUES 
('Добро пожаловать!', 'Это первый пост в нашей системе.', 1),
('Как использовать PostgreSQL', 'PostgreSQL - это мощная объектно-реляционная база данных.', 1),
('Пример поста пользователя', 'Это пример поста от обычного пользователя.', 2)
ON CONFLICT DO NOTHING;
