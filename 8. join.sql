-- case1 : author inner join post
-- 글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 조회
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;  --alius별명 사용 
select a.*, p.* from author a inner join post p on a.id=p.author_id;
select a.* from author a inner join post p on a.id=p.author_id; -- 글쓴이만 조회
select p.* from author a inner join post p on a.id=p.author_id; -- 글목록만 조회

-- case2 : post inner join author
-- 글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on p.author_id=a.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on p.author_id=a.id;

-- case3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴 글이 있다면 글도 함께 조회
select * from author a left join post p on a.id=p.author_id;

-- case4 : post left join author
-- 글의 목록은 모두 조회하되, 만약 글쓴이가 있다면 글쓴이도 함께 조회 
select * from post p left join author a on p.author_id=a.id; 

-- 쿼리의 순서 (셀프조인왜글해요)
select from join on where 조건 group by having order by;

-- 실습)글쓴이가 있는 글 중에서 글의 제목과 저자의 email, 저자의 나이를 출력하되. 저자의 나이가 30세 이상인 글만 출력
select p.title, a.email, a.age from post p inner join author a on p.author_id=a.id where a.age >= 30;

-- 실습)글의 저자의 이름이 빈값(null)이 아닌 글 목록만을 출력.
select p.* from post p inner join author a on p.author_id=a.id where a.name is not null;

-- 프로그래머스 문제
-- 조건에 맞는 도서와 저자 리스트 출력
SELECT b.BOOK_ID, a.AUTHOR_NAME, date_format(b.PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE from BOOK b inner join AUTHOR a on b.AUTHOR_ID=a.AUTHOR_ID where b.CATEGORY='경제' order by PUBLISHED_DATE;
-- 없어진 기록찾기
SELECT o.ANIMAL_ID, o.NAME from ANIMAL_OUTS o left join ANIMAL_INS i on o.ANIMAL_ID=i.ANIMAL_ID where i.ANIMAL_ID is null order by o.ANIMAL_ID;

-- union : 두 테이블의 select 결과를 횡으로 결합
-- union 시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, contents from post;
-- 기본적으로 distinct 적용. 중복허용하려면 union all 사용.
select name, email from author union all select title, contents from post;

-- 서브쿼리 : select문 안에 또다른 select문
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록값 조회(중복제거)
select distinct a.* from author a inner join post p on a.id=p.author_id ; 
select * from author where id in (select author_id from post) ;
-- null값은 in조건절에서 자동으로 제외 
where p.author_id in (select p.) ...????

-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_count    -- 그 안쓴 사람의 개수도 출력(0으로 출력)
select a.email, (select count(*) from post p where p.author_id=a.id) as post_count from author a; -- join보다 서브쿼리는 성능이 떨어진다(n번의 쿼리를 생성)

-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여, 하나의 행(row)처럼 취급
select name from 테이블명 group by name;
이름의 종류를 출력
select name, count(*) from 테이블명 group by name;
이름의 종류별 수 출력

select author_id from post group by author_id;
select author_id, count(*) from post group by author_id;  -- 글 안쓴사람의 개수는 못 구함

-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_count (left join으로 풀이)
select a.email as post_count , count(p.id) from post p left join author a on p.author_id =a.id group by a.email;
-- count의 p.id를 조회한건 null값을 0으로 받음/ *로 조회하면 글수는 null 이지만 email수로 count됨
-- if((p.id) is null, 0, count())

-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
-- 소수점 3번째 자리까지 반올림
select round(avg(age),3) from author;

-- group by와 집계함수
-- 회원의 이름별 회원숫자를 출력하고, 이름별 나이의 평균값을 출력하라.
select name, count(*) as count, avg(age) as age from author group by name;

-- where와 group by
-- 날짜값이 null인 데이터는 제외하고, 날짜별 post 글의 개수 출력.
select date_format(created_time,'%Y-%m-%d') as date, count(*) from post where created_time is not null group by date_format(created_time,'%Y-%m-%d')  order by date;

-- 프로그래머스 문제풀이
-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE, count(*) CARS from CAR_RENTAL_COMPANY_CAR where OPTIONS like '%시트%' group by CAR_TYPE order by CAR_TYPE;
-- 입양 시각 구하기(1)
SELECT date_format(DATETIME,'%H') HOUR, count(*) count from ANIMAL_OUTS where date_format(DATETIME,'%H-%i') >= '09-00' and date_format(DATETIME,'%H-%i') < '20-00' group by date_format(DATETIME,'%H') order by HOUR;
select cast(date_format(DATETIME,'%H'))  -- cast 로 하면 9시 결과값이 09가 아니라 9로 나옴**


where 조건 : 전체 데이터에 대한 조건
having : group by 된 결과의 집계함수에 대한 조건

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 3번 이상 쓴 사람 author_id찾기
select author_id from post group by author_id having count(*) >= 3;

-- 프로그래머스 문제풀이
-- 동명 동물 수 찾기 -> having
SELECT name, count(*) count from ANIMAL_INS where name is not null group by NAME having count(*)>=2 order by NAME;
-- 카테고리 별 도서 판매량 집계하기 -> join까지
SELECT b.CATEGORY CATEGORY , sum(s.SALES) as TOTAL_SALES 
from BOOK_SALES s inner join BOOK b on b.BOOK_ID=s.BOOK_ID 
where date_format(s.SALES_DATE,'%Y-%m')='2022-01' 
group by b.CATEGORY 
order by CATEGORY ;
-- 조건에 맞는 사용자와 총 거래금액 조회하기 -> join까지
SELECT u.USER_ID, u.NICKNAME, sum(g.PRICE) TOTAL_SALES 
from USED_GOODS_BOARD g inner join USED_GOODS_USER u on g.WRITER_ID=u.USER_ID 
where g.STATUS='DONE' 
group by u.USER_ID
having sum(g.PRICE) >= 700000
order by TOTAL_SALES ;


--


정윤 — 오후 1:51
-- 다중열  group by byf
-- group by 첫번째컬럼, 두번째컬럼 : 첫번쨰컬럼으로 grouping 이후에 두번째컬럼으로 grouping
-- post 테이블에서 작성자별로 구분하여 같은 제목의 글의 개수를 출력하시오.
select author_id, title, count(*) from post group by author_id, title;

-- 재구매가 일어난 상품과 회원 리스트 구하기
