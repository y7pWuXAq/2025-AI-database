/* 회원의 생일이 75년 1월 1일부터 75년 12월 31일에 태어난 회원 정보 조회 */
-- 조회컬럼 : 회원아이디, 회원이름, 생일
-- 생일 기준 오름차순
-- 참고로 날짜 포멧은 00000000, 0000-00-00, 0000/00/00, 0000.00.00, 00-00-00, 00/00/00

SELECT mem_id, mem_name, mem_bir
    FROM member
WHERE mem_bir BETWEEN '75/01/01' AND '76/12/31' 
ORDER BY mem_bir ASC;


/* REPLACE(원본값, 찾을값, 바꿀값) : 문자 치환 함수 */

SELECT 'database, 파이썬' AS org,
       REPLACE('database, 파이썬', '파이썬', 'python') AS change
FROM dual;

/* 회원의 성씨중에 "이" 씨를 "리" 씨로 바꿔 조회 */
-- 조회컬럼 : 기존회원이름, 바뀐회원이름
-- 성만 바뀌고, 성 뒤에 이름은 바뀌면X
SELECT mem_name AS 기존회원이름,
       REPLACE(mem_name, '이', '리') AS 확인컬럼,
       (REPLACE(SUBSTR(mem_name, 1, 1), '이', '리') || SUBSTR(mem_name, 2)) AS 바뀐회원이름
FROM member;


/* ROUND(원본값, 반올림자릿수) : 반올림 함수 */

/* 상품명, 원가율 조회 */
-- 원가율 = 매입가/판매가 * 100
-- 원가율은 소숫점 첫재짜리까지 표현
-- 단, 상품명에 "삼성"이라는 단어가 포함된 경우에만 조회
SELECT prod_name AS 제품이름,
                 ROUND(prod_cost/prod_sale *100,  1) AS 원가율
FROM prod
WHERE prod_name LIKE '%삼성%';


/* 나눈 나머지 값 : MOD(원래값, 나눌값) */

/* 회원이름, 성별(남자는 1, 여자는 0)으로 조회 */
-- 전제조건 : 1900년도와 2000년도에 태어난 모든 사람 기준
SELECT mem_name,
                (MOD(SUBSTR(mem_regno2, 1, 1), 2)) AS 성별
FROM member;


/* 김은대 회원이 구매한 상품 중 상품명에 모니터가 포함된 상품의 구매일자 확인 */
-- 회원아이디, 회원이름, 성별(숫자), 주문일자, 상품명
-- 회원아이디 기준 오름차순 정렬
-- 주문일자 0000-00-00 형식으로 조회(주문번호의 앞 8자리)
SELECT cart_member AS 회원아이디,
                 (SELECT mem_name FROM member WHERE mem_id = c.cart_member) AS 회원이름,
                 (SELECT (MOD(SUBSTR(mem_regno2, 1, 1), 2)) FROM member WHERE mem_id = c.cart_member) AS 성별,
                 (SUBSTR(cart_no, 1, 4) || '-' || SUBSTR(cart_no, 5, 2) || '-' || SUBSTR(cart_no, 7, 2)) AS 주문일자,
                 (SELECT prod_name FROM prod WHERE prod_id = c.cart_prod) AS 상품명
    FROM cart c
 WHERE cart_member IN(SELECT mem_id FROM member WHERE mem_name = '김은대')
       AND cart_prod IN(SELECT prod_id FROM prod WHERE prod_name LIKE '%모니터%');



/*
<날짜 관련 함수>
 - 날짜 포맷을 따릅니다.
 - 날짜 포멧은 00000000, 0000-00-00, 0000/00/00, 0000.00.00, 00-00-00, 00/00/00,  
 - 날짜 타입의 데이터는 년월일 뒤에 시분초가 함께 존재함
   --> 시간이 정의되지 않은 날짜 타입 데이터는 00:00:00으로 됨
 - 컬럼의 날짜 타입 : date 타입을 사용(DB마다 다름)
*/


/* 시스템 날자 조회하기 
 - SYSDATE : ORACLE에서만 사용가능한 키워드 : DB마다 다름 */
SELECT SYSDATE
FROM dual;

/* 날자 데이터는 연산이 가능함 : 일 단위로 연산됨 */
SELECT SYSDATE, SYSDATE + 1, SYSDATE - 1
FROM dual;

/* 월 단위로 더하고 빼고자 할 때는 함수를 사용함
 - ADD_MONTHS(원본 값, 연산할값) */
SELECT SYSDATE, Add_Months(SYSDATE, 1) AS m1,
        Add_Months(SYSDATE, -1) AS m2
FROM dual;

/* 가장 빠른 요일의 일자 추출
 - NMEX_DAY(원본 값, 찾을 요일) */
SELECT SYSDATE, Next_day(SYSDATE, '일요일') AS d
FROM dual;

/* 해당 월의 마지막 일자 찾기
 - LAST_DAY(원본 날짜 값) */
SELECT SYSDATE, Last_day(SYSDATE) AS lday,
                              Last_day('2025-02-05') AS lday2
FROM dual;

/* 이번달이 몇일 남았는지 계산 */
SELECT Last_day(SYSDATE) - SYSDATE
FROM dual;

/* 년, 월, 일 각각 추출하기(많이 사용됨)
 - EXTRACT(추출할(년/월/일)중하나 FROM 원본값)
 - 추출할 (년/월/일) : 년(YEAR), 월(MONTH), 일(DAY) 영문 사용
*/
SELECT SYSDATE, 
        Extract(YEAR FROM SYSDATE) AS yyyy,
        Extract(MONTH FROM SYSDATE) AS mm,
        Extract(DAY FROM SYSDATE) AS dd
FROM dual;


/* 회원의 생일이 3월인 회원에 대한 아이디, 이름 생일 조회 */
SELECT mem_id, mem_name, mem_bir
FROM


/* <형변환(타입변환)>
 - CAST(원본값 AS 변환할타입)
   : 데이터의 타입을 변환해야하는 경우에 사용
 - TO_CHAR(원본값) : 문자 타입으로 변환
 - TO_NUMBER(원본값) : 숫자 타입으로 변환
 - TO_DATE(원본값) : 날자 타입으로 변환
*/

Select 
    -- 숫자를 문자 타입으로 변환
    cast(123 as char(10)) as c1, cast(123 as varchar2(10)) as vc1,
    -- 숫자만 있는 문자열을 숫자 타입으로 변환
    cast('123' as number(10)) as n1,
    -- 날자 포맷의 문자열을 날자 타입으로 변환
    cast('20250305' as date) as d1,
    cast('2025-03-05' as date) as d2,
    cast('2025/03/05' as date) as d3,
    cast('2025.03.05' as date) as d4,
    cast('250305' as date) as d5,
    -- 숫자는 사용할 수 없음
    -- cast(20250305 as date) as d6,
    To_char(123) as tc,
    To_number('12344') as tn,
    To_date('2025-03-05') as td1,
    To_date('20250305') as td2,
    To_char(sysdate) as td3
From dual;

/* 날자 포맷으로 추출하기 
 To_char(원본값, '포맷지정') 함수가 주로 사용됨 */
Select 
    To_char(sysdate) as tc1,
    To_char(sysdate, 'yyyy-mm-dd') as tc2,
    To_char(sysdate, 'yyyy.mm.dd') as tc3,
    To_char(sysdate, 'yyyy/mm/dd') as tc4,
    To_char(sysdate, 'yyyy-mm-dd (am)hh24:mi:ss') as tc5,
    To_char(sysdate, 'yyyy') as yyyy,
    To_char(sysdate, 'mm') as mm,
    To_char(sysdate, 'dd') as dd,
    To_char(sysdate, 'day') as day,
    -- 문자열을 원본값으로 사용할 수 없음(날자 타입만 가능함)
    To_char(To_date('2025-03-05'), 'yyyy-mm-dd') as tc6
From dual;



/* 주문정보에서 회원아이디, 주문일자(0000-00-00 형태) 주문수량 조회*/
SELECT cart_member, (TO_CHAR(TO_DATE(SUBSTR(cart_no, 1, 8)),
                 'yyyy-mm-dd')) AS cart_date
FROM cart;


/* 2005년 4월에 주문한 내역 중 주문 수량이 10개 이상을 주문한 회원 정보 조회 */
-- 회원이 생일이 1974년생인 회원이 주문한 내역
-- 조회컬럼 : 회원아이디, 회원이름, 회원생일(0000-00-00 형태)

SELECT mem_id, mem_name, TO_CHAR(mem_bir, 'yyyy-mm-dd') AS bir
FROM member
WHERE TO_CHAR(mem_bir, 'yyyy') = '1974'
     AND mem_id IN(SELECT cart_member
                                   FROM cart
                                 WHERE cart_qty >= 10
                                      AND Substr(cart_no, 1, 6) = '200504');


-------------- 위에는 오라클에서 제공하는 일반함수

/* <그룹함수>
 - 집계함수, 그룹함수, 통계함수..여러 이름으로 사용됨
 - 국제 표준에 따름 (모든 DB에서 사용가능)
 - 5개 함수
    * count() : 행의 갯수
    * sum() : 열 데이터의 합산값 (null이 나올 수 있음)
    * avg() : 열 데이터의 평균값 (null이 나올 수 있음)
    * min() : 열 데이터의 최소값
    * max() : 열 데이터의 최대값
 - 그룹에 대한 조건 : Having 절 사용
 
 (문법)
  Select 조회할 컬럼들, 그룹함수들.....
  From 조회할 테이블들..
  Where 일반조건..
    And 일반조건들..
  Group By 그룹화할 컬럼들...
    Having 그룹함수를 이용한 조건
       And 그룹 조건들...
  Order By 정렬할 컬럼들...
*/

/* 모든 회원에 대한 회원수, 마일리지총합,
   마일리지 평균, 마일리지 최소값, 최대값 조회
   ** 조회하고자 하는 컬럼에 일반컬럼이 없는 경우
      (그룹 함수만 사용하는 경우)
*/
Select count(*) as cnt, sum(mem_mileage) as mem_sum,
        Round(avg(mem_mileage), 3) as mem_avg, 
        min(mem_mileage) as mem_min,
        max(mem_mileage) as mem_max
From member;

/*
상품분류별로 상품의 갯수 확인하기
 - 단, 상품의 갯수가 10개 이상인 것에 대해서만 조회..
 - 조회컬럼 : 상품분류코드, 상품갯수
 - 오류메시지 : 단일 그룹의 그룹 함수가 아닙니다
    --> Group By를 사용하라는 의미
*/
Select 
    prod_lgu, Count(prod_id) as cnt
From prod
-- 조회할 컬럼 중 일반컬럼 또는 일반함수를 이용한 컬럼들은
-- 원형 그대로를 Group By절에 작성해야함 (그룹 규칙)
Group By prod_lgu
  Having Count(prod_id) >= 10;

/*
<그룹 규칙>
 1. Select문 뒤에 조회하는 컬럼으로는 일반컬럼, 일반함수, 그룹함수가
    동시에 사용될 수 있으며, 이때, 일반컬럼 및 일반함수들은
    모두 Group By 뒤에 원형 그대로를 작성해야함
 2. 그룹 조건이 발생하는 경우
    - Group By절 다음에 Having절에 그룹 조건을 작성
    - 그룹 조건은 그룹함수를 그대로 사용하여 비교연산자를 이용하여 처리
 3. Group By를 사용한 경우, 정렬에 사용할 수 있는 컬럼들
    - Select문 뒤에 조회하는 모든 컬럼들 가능
    - Group By절 뒤에 작성된 모든 컬럼들 가능
*/

/*
회원 취미별로 회원수를 조회해 주세요.
 - 조회컬럼 : 취미, 회원수
 - 정렬 : 취미 기준 오름차순
*/
Select mem_like, Count(mem_id) as mem_cnt
From member
Group By mem_like
Order By mem_like ASC;

/*
회원 지역별(서울, 대전, 부산....)로 회원수 조회하기
 - 단, 상품명에 "삼성"이 포함된 상품을 주문한 회원과
 - 지역별 회원수가 2명 이상인 경우에만 조회
 - 정렬은 회원수 기준 내림차순
 - 조회컬럼 : 지역, 회원수
*/
Select Substr(mem_add1, 1, 2) as mem_add,
        Count(mem_id) as mem_cnt
From member
Where mem_id In(
    Select cart_member
    From cart
    Where cart_prod In(
        Select prod_id
        From prod
        Where prod_name like '%삼성%'
    ))
Group By Substr(mem_add1, 1, 2)
  Having Count(mem_id) >= 2
Order By mem_cnt DESC;

/*
회원 전체 마일리지의 평균 이상인 회원정보를 조회하기 
 - 조회컬럼 : 회원아이디, 이름, 마일리지 조회하기
*/
Select mem_id, mem_name, mem_mileage
From member
Where mem_mileage >= (
    Select Avg(mem_mileage)
    From member
);

/*
회원이름, 회원지역(서울, 부산..), 회원생일(년도만), 
마일리지평균, 마일리지합을 조회하기.
 - 단, 회원의 성씨가 "이"씨인 회원
 - 정렬 : 회원지역을 기준으로 내림차순, 
         생일의 년도를 기준으로 오름차순
*/
Select mem_name, Substr(mem_add1, 1, 2) as mem_area,
        Extract(year from mem_bir) as mem_yyyy,
        Round(Avg(mem_mileage), 3) as mem_avb,
        Sum(mem_mileage) as mem_sum
From member
Where substr(mem_name, 1, 1) = '이'
Group By mem_name, Substr(mem_add1, 1, 2),
         Extract(year from mem_bir)
Order By mem_area Desc, mem_yyyy Asc;


/*
상품분류코드, 상품소비자가격의 평균 조회하기
 - 실수값은 소숫점 2자리까지 표현
*/
Select prod_lgu, Round(Avg(prod_price),2) as price_avg
From prod
Group By prod_lgu;

/*
<Null 처리하기>
 - Null은 메모리가 존재하지 않는 것을 의미함
*/
/* Null 데이터 만들기 */
-- 거래처 담당자의 성씨가 "이"씨인 거래처만 조회하기
--  조회컬럼 : 거래처코드, 거래처담당자
Select buyer_id, buyer_charger
From buyer
Where substr(buyer_charger, 1, 1) = '이';

-- 거래처 담당자의 성씨가 "이"씨인 거래처담당자의 이름을
-- null로 수정해 주세요..
Update buyer
    Set buyer_charger = null
Where substr(buyer_charger, 1, 1) = '이';

/*
거래처 담당자에 결측치가 있는 경우만 조회하기
 <null 확인 명령어(국제 표준)>
 - 결측치 조회 : is null 
 - 결측치가 없는 경우만 조회 : is not null
*/
Select buyer_id, buyer_charger
From buyer
Where buyer_charger is null;

Select buyer_id, buyer_charger
From buyer
Where buyer_charger is not null;

/* 결측치 처리 함수 (nvl()함수를 주로 사용함)
  ** 국제표준 아님.. DB마다 다를 수 있음
  - nvl(원본값, 결측값이 있는 경우 대체할 값)
  - nvl2(원본값, 
         결측치가 없는 경우 대체할값, 
         결측값이 있는 경우 대체할 값)
*/
Select buyer_id, buyer_charger,
        nvl(buyer_charger, '넌 누구?') as nvl_val,
        nvl2(buyer_charger, '있음', '없음') as nvl2_val
From buyer;

/*
회원 중에 "이"씨가 구매한 상품정보의
소비자가격을 null로 처리해 주세요.
 - 1. 먼저 해당 조건의 값을 조회 먼저 합니다.(검증용)
 - 2. 1번에서 사용한 조건을 이용하여 소비자 가격 수정 진행 합니다.
 --> 소비자가격의 컬럼 제약조건(Not Null)으로 수정 불가..
*/

/* null과 숫자의 연산 */
Select null+10, null-10, null*10, null/10,
       count(*), count(null), sum(null), avg(null),
       min(null), max(null)
From dual;

Select count(prod_id), count(prod_size) as cnt1,
        count(nvl(prod_size, 0)) as cnt2
From prod;

/*
<조건문 사용하기(국제표준 아님)>
 - Decode() 함수
   : Decode(조건값, 비교값1, 출력값1, 비교값2, 출력값2,.. 무조건출력값)
 - Case 문 : Case When Then Else End
   : Case When 조건 Then 출력값1 Then 출력값2,... else 무조건 End
*/
/* Decode() 함수 사용 */
Select Decode('홍길동10', '홍길동', '출력값', 
                        '홍길동1', '출력값1',
                        '홍길동2', '출력값2',
                        '출력값3')
From dual;

/*
회원이름, 회원성별(남성, 여성으로) 조회하기
*/
Select mem_name,
        Decode(Mod(substr(mem_regno2, 1, 1), 2),
                0, '여성',
                1, '남성',
                '신고하세요!')as mem_sex
From member;


-- case문
Select mem_name,
        Decode(Mod(substr(mem_regno2, 1, 1), 2),
                0, '여성',
                1, '남성',
                '신고하세요!')as mem_sex_decode,
        (Case
            When Mod(substr(mem_regno2, 1, 1), 2) = 0
                Then '여자'
            When Mod(substr(mem_regno2, 1, 1), 2) = 1
                Then '남자'
            Else        
                '신고하세요!!'
         End) as mem_sex_case
From member;

/*
조건으로 사용되는 서브쿼리 함수 : Exists(서브쿼리)
 - 서브쿼리 결과 규칙 : 다중컬럼에 다중행 모두 가능
 - 행이 1개라도 존재하면 조건이 참(true),
 - 행이 0이면 조건은 거짓(false)
*/
-- 주문 내역이 있는 회원 조회하기
Select mem_id, mem_name
From member
Where Exists(
    Select *
    From cart
    Where cart_member = mem_id
);

-- 주문내역이 없는 회원 조회
Select mem_id, mem_name
From member
Where Not Exists(
    Select *
    From cart
    Where cart_member = mem_id
);