-- view : 실제 데이터를 참조만 하는 가상의 테이블. SELECT만 가능 
-- 사용목적 : 1)권한분리 2)복잡한쿼리를 사전생성

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email from post p inner join author a on p.author_id=a.id;

-- view 조회(table조회와 동일)
select * from author_view;

-- view에 대한 권한부여
grant select on board.author_view to 'marketing'@'%';

-- view 삭제
drop view author_view;

-- 프로시저 생성
delimiter //
create procedure hello_procedure()
begin
    select "hello world";
end
// delimiter ; -- delimiter 앞뒤로 한칸띄움

-- 프로시저 호출
call hello_procedure;

-- 프로시저 삭제
drop procedure hello_procedure;

-- 회원목록조회 프로시저생성 -> 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;

-- 회원상세조회 -> input(매개변수)값 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력
delimiter //
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id=idInput;
end
// delimiter ;

-- 전체회원수조회 -> 변수사용
delimiter //
create procedure 전체회원수조회()
begin
    -- 변수선언
    declare authorCount bigint;
    -- into를 통해 변수에 값 할당 
    select count(*) into authorCount from author;
    -- 변수값 사용
    select authorCount; 
end
// delimiter ;

-- 글쓰기
delimiter //
-- 사용자가 title, contents, 본인의 email값을 입력
create procedure 글쓰기(in titleInput varchar(255), in contentsInput varchar(3000), in emailInput varchar(255))
begin
    -- begin 밑에 declare를 통해 변수 선언
    declare authorID bigint;
    declare postID bigint;
    -- email로 회원DI찾기
    select id into authorID from author where email=emailInput;
    -- post테이블에 insert
    insert into post(title, contents) values(titleInput, contentsInput) ;
    -- post테이블에 insert된 id값 구하기 
    select ID into postID from post order by id desc limit 1;
    -- author_post_list테이블에 insert하기(author_id, post_id 필요)
     insert into author_post_list(author_id, post_id) values(authorID, postId);
end
// delimiter ;
-- 트랜잭션 처리해야함

delimiter //
create procedure 글쓰기(in titleInput varchar(255), in contentsInput varchar(3000), in emailInput varchar(255))
begin
    declare authorID bigint;
    declare postID bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외관련 특수문법
    declare exit handler for SQLEXCPTION
    begin
        rollback;
    end;
    start TRANSACTION;
        select id into authorID from author where email=emailInput;
        insert into post(title, contents) values(titleInput, contentsInput) ;
        select ID into postID from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(100, postId);  -- 여기서 에러시 전체 rollback되어야함
    commit;
end
// delimiter ;

-- 위에거 다시 해보기 
-- 글쓰기
delimiter //
-- 사용자가 title, contents, 본인의 email값을 입력
create procedure 글쓰기()
begin
    -- email로 회원DI찾기

    -- post테이블에 insert

    -- post테이블에 insert된 id값 구하기 

    -- author_post_list테이블에 insert하기(author_id, post_id 필요)

end
// delimiter ;
-- 트랙잭션도 걸어줘야함


-- 글삭제 -> if else문
-- 글쓴 참여자가 2명 이상이면 리스트에서 본인만 삭제 ,혼자면 글은 두고 글이랑 리스트랑 둘다 삭제.
delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    -- 참여자의 수를 조회 
    select count(*) into authorCount from author_post_list where post_id=postIdInput;
    if authorCount =1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id = postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

-- 대량글쓰기 -> while문을 통한 반복문
delimiter //
create procedure 글쓰기(in count bigint, in emailInput varchar(255))
begin
    declare authorID bigint;
    declare postID bigint;
    declare countValue bigint default 0;
    while countValue < count do
        select id into authorID from author where email=emailInput;
        insert into post(title) values("안녕하세요") ;
        select ID into postID from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(authorId, postId);  
        set countValue = countValue + 1 ;
    end while;
end
// delimiter ;

