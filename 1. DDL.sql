-- mariabd 서버에 터미널창에서 접속(db gui 툴로 접속시에는 커넥션 객체 생성하여 연결)
mariabd -u root -p -- 엔터 후 비밀번호 별도 입력

-- 스키마(database) 생성
create database board;  
-- 스키마 삭제
drop database board;

-- 스키마 목록 조회
show databases;

-- 스키마 선택
use 스키마명;   -- 스키마 = database

-- 문자인코딩 세팅 조회 (암기할건아님)
show variables like 'character_set_server'  

-- 문자인코딩 변경
alter database board default character set = utf8mb4;

-- 테이블 목록조회
show tables;

-- (파란색으로 보이는) sql문은 대문자로 쓰는게 관례이고, 시스템에서 대소문자를 구분하지는 않음
-- 테이블명/컬럼명 은 소문자가 관례, 대소문자가 차이가 있음

-- 테이블 생성 
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));

-- 테이블 컬럼정보 조회
describe author;

-- 테이블 데이터 전체 조회 ( * 부분은 컬럼을 의미, id,name처럼 컬럼만 선택해서 조회할수있음-DML select 조회문)
select * from author; 

-- 테이블 생성명령문 조회(안중요)
show create table author;

-- posts테이블 신규 생성 (id, title, contents, author_id)
create table posts (id int , title varchar(255), contents varchar(255), author_id int, primary key(id), foreign key(author_id) references author(id));

-- 테이블 제약조건 조회 (constraint) (pk,fk 조회됨/describe에서는 조회안됨)
select * from information_schema.key_column_usage where table_name="posts";

-- 테이블 index 조회 (빈번하게 조회될만한 목록(중요한데이터대상) ex) PK,fk )
show index from posts;  

-- alter : 테이블의 구조를 변경
-- 테이블의 이름 변경
alter table posts rename post;

-- 테이블의 컬럼 추가
alter table post add column 컬럼명 컬럼타입 제약조건
alter table post add column age int;

-- 테이블의 컬럼 삭제
alter table post drop column age;

-- 테이블의 컬럼명 변경
alter table post change column contents content varchar(255); --타입 필수로 입력

-- 테이블 컬럼의 타입과 제약조건 변경
alter table post modify column content varchar(3000);
alter table author modify column email varchar(255) not null unique; --타입은 변경을 안해도 필수로 입력 

-- 실습1. author테이블에 address컬럼을 추가 (varchar255). name은 not null로 변경.
alter table author add column address varchar(255);
alter table author modify column name varchar(255) not null;

-- 실습2. post테이블에 title을 not null로 변경. content는 contents로 이름 변경.
alter table post modify column  title varchar(255) not null;
alter table post change column content contents varchar(3000);


-- 테이블 삭제
drop table abc;             --없으면 에러 

-- 일련의 쿼리를 실행시킬때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용.
drop table if exists abc;   --조건문으로, 없어도 에러가 생기지 않음

