-- 사용자목록조회
select * from mysql.user;

-- 사용자생성
-- 계정명 marketing,  % : 원격접속가능 ( or localhost : 원격접속차단 ),  identified by :비밀번호지정 
create user 'marketing'@'%' identified by 'test4321';

-- **테이블마다의 권한을 줄 수 있음
author - insert, update, delete, select etc..

-- 사용자에게 권한부여
grant select on board.author to 'marketing'@'%';
grant select, insert on board.* to 'marketing'@'%';
grant all privileges on board.* to 'marketing'@'%';

-- 사용자 권한 회수
revoke select on board.author from 'markeeting'@'%';

-- 사용자 권한 조회
show grants for 'marketing'@'%';

-- 사용자 계정 삭제
drop user 'marketing'@'%';

