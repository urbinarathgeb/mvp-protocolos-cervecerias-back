CREATE TABLE users (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE, 
    firebase_uid VARCHAR(128) NOT NULL UNIQUE, 
    name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE, 
    role VARCHAR(10) NOT NULL DEFAULT 'user', 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('admin_dev_uid_12345', 'admin@mail.com', 'Admin', 'admin');

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('user_dev_uid_12345', 'user@mail.com', 'User Cervecero', 'user');

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('D9EOG4uUJFUej5hnKMVOKHzciQB2', 'user_2@mail.com', 'User 2', 'user');


INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('kqlXXM4a7YPorAarZj72N5k79pF2', 'user_3@mail.com', 'User 3', 'user');


