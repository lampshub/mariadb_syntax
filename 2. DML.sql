-- insert : 테이블의 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values(데이터1, 데이터2, 데이터3);
-- 문자열은 일반적으로 작은따옴표 사용''
insert into author(id, name, email) values(4, 'hong2', 'hong2@naver.com');

-- update : 테이블의 데이터를 변경
update author set name='홍길동' , email='hong100@naver.com' where id=3;

-- delete : 데이터 삭제
delete from 테이블명 where 조건;
delete from author where id=4;

-- select : 조회
select 컬럼1, 컬럼2 from 테이블명;
select name email from author;
-- * 은 모든 컬럼을 의미
select * from author; 

-- select 조건절(where) 활용
select * from author where id = 1;
select * from author where name='홍길동';
select * from author where id >2 and name='honggildong';
select * from author where id in (1,3,5);
-- 이름이 '홍길동'인 글쓴이가 쓴 글목록을 조회하시오
select id from author where name='홍길동';
select * from post where id in(2,3);
select * from post where author_id in(select id from author where name='홍길동'); --서브 쿼리
-- 뒤에 조건절의 select문 안에는 pk 된 컬럼을 입력**

-- 중복제거 조회 : distinct
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순, desc : 내림차순, 안붙이면 오름차순(default)
-- 아무런 정렬조건 없이 조회할 경우에는 pk기준 오른차순
select * from author order by name desc;

-- 멀티컬럼 order by : 여러컬럼으로 정렬시, 먼저쓴 컬럼 우선정렬하고, 중복시 그다음 컬럼 정렬적용
select * from author order by name desc, email asc;

-- 결과값 개수 제한
-- 가장 최근에 가입한 회원 1명만 조회(순차적으로 id가 입력되었다고 가정했을시)
select * from author order by id desc limit 1;

-- 별칭(alias)를 이용한 select (테이블 컬럼 모두 alias 지정 가능)
select name as '이름' , email as '이메일' from author;
select a.name, a.email from author as a;    -- 여기서 as 는 생략가능 / 여러개 테이블을 엮어서 사용시
select a.name, a.email from author a;

-- null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null; 

-- 프로그래머스 sql 문제풀이
-- Q. 여러 기준으로 정렬하기
-- Q. 상위 n개 레코드
