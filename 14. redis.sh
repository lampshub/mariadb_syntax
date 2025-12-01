# window에서는 redis가 직접 설치가 안됨 -> dockerㄹ르 통한 redis 설치
docker run --name 컨테이너명 -d(백그라운드옵션) -p(포트번호 설정 6379가 기본. 다른걸로 변경 가능)
docker run --name my-redis-container -d -p 6379:6379

# redis 접속 명령어(터미널)
redis-cli

# docker에 설치된 redis 접속 명령어
# redis 컨테이너 안으로 들어가겠다 /  + redis cli 접속 
docker exec -it 컨테이너ID redis-cli

# redis 는 0~15번까지의 db로 구성(defautl 0번)
# db번호 선택
select db번호

# db내 모든 키값 조회
keys *

# String자료구조
# set key:value 형식으로 값 세팅
set user:email:1 hong@naver.com
set user:email:2 hong2@naver.com
# 이미 존재하는 key를 set 하면 덮어쓰기
set user:email:1 hong2@naver.com
# key값이 이미 존재하면 pass시키고 없을때만 set하기 위해서는 nx옵션 사용
set user:email:1 hong3@naver.com nx
# 만료시간(ttl:time to live) 설정은 ex옵션 사용(초단위)
set user:email:2 hong2@naver.com ex 30
# get key 를 통해 value값 구함
get user:email:1
# 특정 key값 삭제
del 키값
# 현재 DB내 모든 key값 삭제
flushdb

# redis string 자료구조 실전활용 
# 사례1 : 좋아요기능 구현 -> 동시성이슈 해결
set likes:posting:1 0   # redis는 기본적으로 모든 key:valuer가 문자열. 그래서 0으로 세팅해도 내부적으로 "0"으로 저장
incr likes:posting:1    #특정 key값의 value를 1만큼 증가
decr likes:posting:1    #특정 key값의 value를 1만큼 감소
# 누가 like를 눌렀는지 기록이 없어서 중복으로 like 할 수 있음. 그래서 이 예시는 문제있음

# 사례2 : 재고관리 -> 동시성이슈 해결
set stock:poduct:1 100
incr stock:poduct:1 
decr stock:poduct:1 

# 사례3 : 로그인 성공시 토큰 저장 -> 빠른 성능
set user:1:refresh_token abcdexxxxxx ex 1800    # 1800초가 지나면 토큰값이 지워짐

# 사례4 : 데이터 캐싱 -> 빠른 성능
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000
-> map형식{} ? X 제이슨형식임 -> hashed? X -> 그냥 하나의 문자열임 

# list자료구조
# redis의 list는 deque와 같은 자료구조. 즉, double-ended-dueue구조
lpush students kim1
lpush students lee1
rpush students park1
# [lee1, kim1, park1]

# list조회
lrange students 0 2   # 0번쨰부터 2번째 까지
lrange students 0 -1    # 0부터 끝까지 조회
lrange students 0 0     # 0번째값만 조회
lrange students -1 -1   # 마지막값만 조회
lrange students -2 -1   # 끝에서 2번쨰값부터 마지막값까지 조회
# list값 꺼내기(꺼내면서 삭제)
rpop students 
lpop students 
# A리스트에서 rpop 하여 B리스트에 lpush : 잘 안쓰임 #향후 없어질 문법 / deprecated -> 공식적으로 더이상 사용하지 않는다 
rpoplpush A리스트 B리스트
rpoplpush  students students    
# list의 데이터 개수 조회
llen students 
# expire, ttl 문법 모두 사용가능 
expire students 10
ttl students
# redis LIST 자료구조 실전활용
# 사례1 : 최근 조회한 상품목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근 본 상품목록 3개 조회
lrange user:1:recent:product -3 -1

# set자료구조 : 중복없음, 순서없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3
# set 조회
smembers memberlist
# set의 멤버개수 조회
scard memberlist    # cardinality 종류
# redis SET 자료구조 실전활용
# 사례1 : 좋아요 구현
# 게시글 상세보기에 들어가면 
scard likes:posting:1   #좋아요 개수
sismember likes:posting:1 abc@naver.com #내가 좋아요를 눌렀는지 안눌렀는지 표시
sadd likes:posting:1 abc@naver.com  #좋아요를 누른경우
srem likes:posting:1 abc@naver.com  #좋아요 취소
scard likes:posting:1

# zset자료구조 : sorted set
# zset 활용 사례1 : 최근 본 상품 목록
# zset도 set이므로 같은 상품을 add할 경우 중복이 제거되고, score(시간)값만 업데이트
zadd user:1:recent:product 151400 apple
zadd user:1:recent:product 151401 banana
zadd user:1:recent:product 151402 orange
zadd user:1:recent:product 151403 melon
zadd user:1:recent:product 151404 mango
zadd user:1:recent:product 151405 melon #151403값은 없어진다
#  zset 조회 : zrange(score기준 오름차순 정렬), zrevrange(내림차순 정렬)
zrange user:1:recent:product -3 -1
zrevrange user:1:recent:product 0 2 
zrevrange user:1:recent:product 0 2 withscores

# hashes자료구조 : value 가 map형태의 자료구조 (key:value, key:value, .... 형태의 구조)
# set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" 과의 비교
hset member:info:1 name hong email hong@daum.net age 30
# 특정값 조회
hget member:info:1 name
# 특정값 수정
hset member:info:1 name hong2
# 빈번하게 변경되는 객체값을 저장시에는 hashes가 성능 효율적