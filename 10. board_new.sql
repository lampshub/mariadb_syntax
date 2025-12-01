-- 회원 테이블 생성 
-- id(pk), email(unique,not null), name(not null), password(not null)
id(pk), email(unique, not null), name(not null), password(not null)
create table author(id bigint auto_increment primary key, email varchar(255) not null unique, name varchar(255), password varchar(255) not null);

-- 주소 테이블
-- id(pk), country(not null), city(not null), street(not null), author_id(kf, not null)
-- author_id unique ** 이건 1:1 이니까 넣는건데 생각해보기 
id, country(notnull), city(notnull), street(notnull), author_id(fk, notnull)
create table address(id bigint auto_increment primary key, country varchar(255) not null,  city varchar(255) not null,  street varchar(255) not null, author_id bigint not null unique, foreign key(author_id) references author(id));

-- post 테이블
-- id, title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000) );

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id) );

-- 복합키를 이용한 연결테이블 생성
create table author_post_list( author_id bigint not null, post_id bigint not null, primary key(author_id,post_id), foreign key(author_id) references author(id), foreign key(post_id) references post(id) );

-- 회원가입 및 주소생성
insert into author(email, name, password ) values('bbb@naver.com', 'fbd', '145');
insert into address(country, city, street, author_id) values('korea', 'seoul','gangdong',3);
insert into address(country, city, street, author_id) values('korea', 'seoul','gangdong',(select id from author order by id desc limit 1));

-- 글쓰기 
-- 최초 생성자
insert into post(title, contents) values('hello2','hello world2');
insert into author_post_list(author_id, post_id) values(1,2);
-- insert into author_post_list(author_id, post_id) values( (select id from apost order by id desc limit 1),2);
insert into author_post_list(author_id, post_id) values(2,2);
-- 추후 참여자
-- update....
-- insert into author_post_list values(1,2) 

-- 글전체목록 조회하기 : 제목, 내용, 글쓴이이름이 조회가 되도록 select 쿼리 생성
select p.id, p.title, p.contents, a.name from post p inner join author_post_list l on p.id=l.post_id inner join author a on l.author_id=a.id;



