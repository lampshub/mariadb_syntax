-- not null 제약 조건 추가
-- name 컬럼에 not null 제약조건추가
alter table author modify column name varchar(255) not null;
-- name 컬럼에 not null 제약조건제거
alter table author modify column name varchar(255);
--not null, unique 동시에 추가
alter table author modify column email variables(255) not null unique;

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

