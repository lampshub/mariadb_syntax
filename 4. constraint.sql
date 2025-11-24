-- not null 제약 조건 추가
-- name 컬럼에 not null 제약조건추가
alter table author modify column name varchar(255) not null;
-- name 컬럼에 not null 제약조건제거
alter table author modify column name varchar(255);
--not null, unique 동시에 추가
alter table author modify column email variables(255) not null unique;
-- unique 제거는 인덱스(index) 에서 제거 (안중요)

-- pk와 fk를 추가/제거
-- pk 제약조건 삭제
alter table post drop primary key;
-- fk 제약조건 삭제
alter table post drop foreign key fk명;
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) referensec author(id);

-- on delete/on update (부모의 값이 삭제되거나 변경될시 자식값 동작옵션)
alter table post add constraint post_fk foreign key(author_id) referensec author(id) on delete set null on update cascade;

-- 1. 기존 fk삭제
-- 2. 새로운 fk추가 (on update / on delete 변경)
-- 3. 새로운 fk에 맞는 테스트
-- 3-1) 삭제 테스트
-- 3-2) 수정 테스트


-- default옵션
-- 어떤 컬럼이든 default 지정이 가능하지만, 일반적으로 enum타입 및 현재시간에서 많이 사용 
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 숫자값을 입력 안했을때, 마지막에 입력된 가장 큰 값의 +1만큼 자동으로 증가된 숫자값 적용 
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입
alter table post add column user_id char(36) default (uuid());

-- # id -> 기본적으로 - bigint + auto_increment / 전세계적으로 - uuid() - 분산DB
-- 1) 서버 분산 -> 매우 흔함
-- 2) DB 분산 -> 흔치 않음