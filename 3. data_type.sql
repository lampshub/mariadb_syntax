-- tinyint : 1바이트 사용. -128~127까지의 정수표현 가능 (unsigned 시에 0~255 / 음수안씀)
-- author테이블에 age컬럼 추가
alter table author add column age tinyint unsigned;
insert into author(id, name, email, age) values( 6, '홍길동2', 'aakd@naver.com', 200);

-- int : 4바이트 사용. 대략 40억 숫자범위 표현 가능

-- bigint : 8바이트 사용.
-- author, post테이블의 id값을 bigint로 변경
alter table author modify column id bigint;  --fk 가 걸려있어서 변경 안됨
alter table author modify column author_id bigint;  -- 위와 같음 => 제약조건을 삭제후 해야함
alter table author modify column id bigint;
-- 제약조건이 걸려있어서 변경이 안될시, 처리 방법
-- 1. 제약조건 변경 (제약조건 조회해서 제약조건 삭제)
select * from information_schema.key_column_usage where table_name="post";
alter table post drop foreign key post_ibfk_1;
-- 2. 
alter table author modify column id bigint; 
alter table author modify column author_id bigint; 
-- 3. 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);


-- decimal(총자리수, 소수부자리수)
alter table author add column height decimal(4,1);
--정상적으로 insert
insert into author(id, name, email, height) values(7, 'hong3', 'sss2@naver.com', 175.5);
--데이터가 잘리도록 insert (소수점이 반올림 됨)
insert into author(id, name, email, height) values(8, 'hong4', 'sss4@naver.com', 175.46);

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column id_number char(16) ;
alter table author add column self_introduction text ; 

-- blob(바이너리데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지 경로를 varchar로 저장.
alter table author add column profile_image longblob;
insert into author(id, name, email, profile_image) values(9, 'asfg','ajdfh@naverc.com', LOAD_FILE('C:\\hamburg.jpg'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼 추가( not null 설정 안하면, null 값까지 3개 입력값 )
alter table author add column role enum('admin', 'user') not null default 'user';
-- enum에서 지정된 role을 insert
insert into author(id, name, email, role) values(11, 'sddd', 'dkdfj@naver.com', 'admin');
-- enum에서 지정되지 않은 값을 insert
insert into author(id, name, email, role) values(12, 'dffd', 'dfddfj@naver.com', 'superadmin');
-- role을 지정하지 않고 insert
insert into author(id, name, email) values(13, 'dffd', 'dfddfj@naver.com');

-- date(연월일)와 datetime(연원일시분초)
-- 날짜타입의 입력, 수정, 조회시에는 문자열 형식을 사용
alter table author add colume birthday date;
alter table post add column created_time datetime;
insert into post(id, title, contents, author_id, created_time) values(4, 'hello4','he dkdifjkalks', 1, '2019-01-10 14:03:20');
-- datetime과 default 현재시간 입력은 많이 사용되는 패턴 (current_timestamp() : 현재시간 입력함수)
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, contents, author_id) values(5, 'hello4','he dkdifjkalks', 1);

-- 비교연산자
select * from author where id >= 2 and id <= 4; -- 제일 확실한 방법 !
select * from author where id in (2,3,4);       --정적
select * from author where id in (또다른쿼리);    --동적 / 서브쿼리
select * from author where id in between 2 and 4;


-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp : 정규표현식을 활용한 조회
select * from author where name regexp '[a-z]'; -- 이름에 소문자 알파벳이 포함된 경우
select * from author where name regexp '[가-힣]'; -- 이름에 한글이 포함된 경우

-- 타입변환 - cast
-- 문자 -> 숫자
select cast('12' as unsigned)   -- 양의 문자로 된 값은 as unsigned 사용이 관례(음의 문자는 못씀) / from 없이 쓰면 그냥 숫자값이 출력됨. 
-- 숫자 -> 날짜
select cast(20251121 as date);  -- 2025-11-21
-- 문자 -> 날짜
select cast('20251121' as date);  -- 2025-11-21

-- 날짜타입변환 - date_format(Y, m, d, H, i, s) / 날짜 -> 문자
select created_time from post;
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%Y') ='2025';
select * from post where date_format(created_time, '%m') = '11';
select * from post where date_format(created_time, '%m') = '01';
select * from post where cast(date_format(created_time, '%m') as unsigned)= 1 ; --문자열'01'로 조회하지않고 cast로 숫자 1로 형변환해서 조회

-- 실습 : 2025-11 에 등록된 게시글 조회
select * from post where date_format(created_time, '%Y-%m') = '2025-11';
select * from post where created_time like '2025-11%';      -- 이렇게 like 사용으로 더 간단히 조회 가능!

-- 실습 : 2025-11-01부터 2025-11-19까지의 데이터를 조회
select * from post where created_time >='2025-11-01' && created_time < '2025-11-20';    --> 2025-11-01 00:00:00 부터 2025-11-19 23:59:59 까지 조회 / between은 min max를 포함하므로 안맞음




