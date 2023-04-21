CREATE DATABASE IF NOT EXISTS `test`;
create table if not exists users (id int, points int)
create table if not exists products (id int, price int, stock int)
create table if not exists orders (user_id int, product_id int, count int)
