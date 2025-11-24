-- 1. post에 글생성. insert
-- 2. 글쓴이의 쓴글의 개수를 update
-- => transaction 처리 (1번 2번 순서가 의미가 없다)
-- => 둘중 1작업이 성공 && 둘중 1작업이 실패
-- => 전체 rollback;

-- 트랜잭션 테스트를 위한 컬럼추가
alter table author add column post_count int default 0;

-- 트랜잭션 실습
-- post에 글쓰기(insert). author의 post_count에 +1을 update하는 작업. 2개를 한 트랙잭션으로 처리.
-- start transaction은 실질적인 의미는 없고, 트랜잭션의 시작이라는 상징적인 의미만 있는 코드.
start transaction;
update author set post_count=post_count +1 where id = 6;
insert into post(title,contents,auther_id) values('hello8','hello world...',100);
commit;

-- 위 트랜잭션은 실패시 자동으로 rollback이 어려움
-- stored 프로시저를 활용하여 성공시에는 commmit, 실패시에는 rollback 등 동적인 프로그래밍
DELIMITER //    --프로시저 시작 구문
create procedure transaction_test()
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update author set post_count=post_count+1 where id = 6;
    insert into post(title, contents, author_id) values("hello8", "hello ...", 6);
    commit;
end //
DELIMITER ;     --프로시저 끝 구문
-- 프로시저 호출
call transaction_test();


isolatioin 고립성
datebase 는 멀티스레드(작업) 프로그램으로 동시 요청 작업이 가능하다 => 사용자의 트랜잭션이 동시에 발생할 수 있음
=>  '동시성 문제'가 발생할 수 있음 => 
