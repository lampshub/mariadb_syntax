-- # SQL 은 조건문, 반복문이 어렵다. 부분적으로 조건문 사용이 가능

-- 흐름제어 : if, ifnull, case when
-- if(a,b,c) : a조건이 참이면 b반환, 그렇지 않으면 c반환
select id, if(name is null, '익명사용자', name) as name from author;
select id, if(name is not null, name, '익명사용자') from author;

-- ifnull(a,b) : a가 null이면 b반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자') as name from author;

-- case when .. end
select id, 
case
 when name is null then '익명사용자'
 when name = 'hong1' then '홍길동1'
 when name = 'hong2' then '홍길동2'
 else name
end as name
from author;

-- 프로그래머스 문제풀이
-- 경기도에 위치한 식품창고 목록 출력하기
SELECT 
WAREHOUSE_ID , WAREHOUSE_NAME, ADDRESS,
IF(FREEZER_YN is null, 'N', FREEZER_YN ) AS FREEZER_YN  
FROM FOOD_WAREHOUSE
WHERE ADDRESS like '경기%' 
order by WAREHOUSE_ID asc  
;
-- 조건에 부합하는 중고거래 상태 조회하기
SELECT
BOARD_ID, WRITER_ID, TITLE, PRICE, 
CASE
WHEN STATUS='SALE' then '판매중'
WHEN STATUS='RESERVED' then '예약중'
ELSE '거래완료'
END as STATUS 
FROM USED_GOODS_BOARD
WHERE CREATED_DATE='2022-10-05'
order by BOARD_ID DESC
;
-- 12세 이하인 여자 환자 목록 출력하기
SELECT
PT_NAME, PT_NO, GEND_CD , AGE, IF(TLNO is null, 'NONE', TLNO)
FROM PATIENT
where GEND_CD ='W' and AGE <= 12 
order by AGE desc, PT_NAME
;

-- 순서
SELECT 컬럼명 FROM 테이블명 WHERE 조건 ORDER BY

-- bd 기본
DDL  -> 
DML문 -> select 초점