/* 상품정보 조회 */
-- 조회 컬럼 상품코드, 상품명, 판매가격
-- 단, 판매 가격이 10000원 이상 500000원 이하인 상품에 대해서
SELECT prod_id AS 상품코드,
             prod_name AS 상품명,
             prod_sale AS 판매가격
  FROM prod
WHERE prod_sale >= 10000
     AND prod_sale <= 500000;

-- BETWEEN (최소값) AND (최대값) : 값의 비교를 할 때 사용하는 표준 명령어
-- 최소값 이상 ~ 최대값 이하 (값을 포함함)
SELECT prod_id AS 상품코드,
             prod_name AS 상품명,
             prod_sale AS 판매가격
  FROM prod
WHERE prod_sale BETWEEN 10000 AND 500000;


/* <검색명령 : LIKE>
- LIKE : 문자 또는 문자열이 포함되어 있으면 TRUE
- NOT LIKE : 문자 또는 문자열이 포함되어 있지 않으면 TRUE
- ** 검색하고자 하는 문자 또는 문자열의 왼쪽 오른쪽에 % 기호를 사용할 수 있음 (%의 의미는 "모든 것" 이라는 의미)
*/

/* 회원 이름 조회 */
-- 성씨가 이씨인 회원들 조회
SELECT mem_name
  FROM member
WHERE mem_name LIKE '이%';
 
/* 회원 이름 조회 */
-- 이름이 이로 끝나는 회원들 조회
SELECT mem_name
  FROM member
WHERE mem_name LIKE '%이';
 
/* 회원 이름 조회 */
-- 이름 처음 또는 마지막 또는 중간에 쁜이 있는 회원들 조회
SELECT mem_name
  FROM member
WHERE mem_name LIKE '%쁜%';

/* 회원 이름 조회 */
-- 이름의 두번째 단어가 "은"이 포함되어 있는 회원 이름 조회
SELECT mem_name
  FROM member
WHERE mem_name LIKE '_은%';
 
 
/* 75년생인 회원 정보 조회 */
-- 아이디, 이름, 주민번호 앞, 주민번호 뒤 조회
-- 주민등록번호를 이용해 조건처리
SELECT mem_id AS 회원아이디,
             mem_name AS 회원이름,
             mem_regno1 AS 주민번호앞자리,
             mem_regno2 AS 주민번호뒷자리
  FROM member
WHERE mem_regno1 LIKE '75%';
 
/* 회원의 성씨가 김씨인 회원들이 구매한 상품 중 상품명에 "삼성"이 포함된 상품을 구매한 회원 조회 */
-- 회원아이디, 회원 이름 조회
SELECT mem_id AS 회원아이디,
             mem_name AS 회원이름
  FROM member
WHERE mem_name LIKE '김%' 
     AND mem_id IN(SELECT cart_member
                                   FROM cart
                                 WHERE cart_prod IN (SELECT prod_id
                                                                       FROM prod
                                                                     WHERE prod_name LIKE '%삼성%'));
                                                                                 

/* 회원아이디, 회원이름, 상품코드, 주문번호, 주문수량 조회 */
-- 상품 판매 가격이 20만원 이상이고 100만원 이하인 상품
-- 거래처명에 "삼성"이 포함된 거래처
-- 상품분류명에 "컴퓨터"가 포함된 상품

SELECT cart_member AS 회원아이디,
             (SELECT mem_name FROM member WHERE mem_id =cart_member) AS 회원이름,
             cart_prod AS 상품코드,
             cart_no AS 주문번호,
             cart_qty AS 주문수량
  FROM cart
WHERE cart_prod IN(SELECT prod_id FROM prod WHERE prod_sale BETWEEN 200000 AND 1000000
                                                                                        AND prod_buyer IN(SELECT buyer_id FROM buyer WHERE buyer_name LIKE '%삼성%')
                                                                                        AND prod_lgu IN(SELECT lprod_gu FROM lprod WHERE lprod_nm LIKE '%컴퓨터%'));

/* <일반 함수 사용하기>
- 데이터 베이스 시스템마다 자체적으로 만들어 놓은 함수가 존재
- 국제 표준을 따르지 않기 때문에 다른 데이터 베이스 시스템에 해당하는 함수들을 찾아서 사용
- 일반적으로 모든 데이터베이스 시스템에서 사용하는 함수는 동일한 개념으로 대부분 존재함
- 함수이름(철자)만 차이가 있음
*/


/* 문자열 합치기 */
-- 테스트용 테이블 : dual
-- 문자열 합치는 함수 : CONCAT(값1, 값2) or || (오라클에서만 사용 가능)
SELECT ('test1 ' || 'test2 ' || 'test3 ') AS 이름1, 
             CONCAT('test4 ', 'test5 ') AS 이름2,
             CONCAT('test6 ', CONCAT('test7 ', 'test8 ')) AS 이름3
  FROM dual;
    
    
/* 문자열 합치기 실습 */
-- 회원 주민등록번호를 "주민번호앞자리-주민번호뒷자리" 표현
-- 회원이름, 회원주민번호앞, 회원주민번호뒤, 주민번호합친것 조회
SELECT mem_name AS 회원이름,
             mem_regno1 AS 주민번호앞,
             mem_regno2 AS 주민번호뒤,
             (mem_regno1 || '-' || mem_regno2) AS 함수주민등록번호,
             CONCAT(mem_regno1, CONCAT ('-',  mem_regno2)) AS 콘캣주민등록번호                 
  FROM member;


/* <대소문자 변환>
- 영문자를 모두 대문자로 변환 : UPPER()
- 영문자를 모두 소문자로 변환 : LOWER()
- 영문자 단어의 첫글자만 대문자로 나머지는 소문자 : INITCAP()
- 주로 사용되는 함수 : UPPER(), LOWER()
*/


/* <공간을 다른 문자로 채우기>
- LPAD(원본값, 전체자리수, 채울값)
   - 전체자리수(메모리공간)을 기준으로 오른쪽부터 원본값 채워넣고 남은 공간을 채울값으로
- RPAD(원본값, 전체자리수, 채울값)
   - 전체자리수(메모리공간)을 기준으로 왼쪽부터 원본값 채워넣고 남은 공간을 채울값으로
*/

SELECT mem_regno1,
                 LPAD(mem_regno1, 13, '*') AS lpad1,
                 RPAD(mem_regno1, 13, '*') AS rpad1
    FROM member;

/* 주민번호1 을 이용해서 "주민번호앞자리-*******" 표현 */
-- 회원주민번호1, 변경된주민번호 조회
SELECT mem_regno1 AS 회원주민번호앞자리,
                 RPAD(CONCAT(mem_regno1, '-'), 14, '*') AS 변경된주민번호
    FROM member;


/* <공백(Trim) 제거>
- LTRIM(원본값) : 왼쪽 첫번째 공백 제거
- RTRIM(원본값) : 오른쪽 첫번째 공백 제거
- TRIM(원본값) : 양쪽 첫번째 공백 제거
*/

/* <문자열 추출 함수> !! 매우 중요!
SUBSTR(원본값, 추출할 시작위치, 추출할 갯수)
*/

/*주민번호 모두 이용해서 "주민번호앞자리-0******" 표현*/
-- 회원주민번호1, 변경된주민번호 조회
SELECT mem_regno1 AS 회원주민번호앞자리,
                 RPAD(CONCAT(CONCAT(mem_regno1, '-'), SUBSTR(mem_regno2, 0, 1)), 14, '*') AS 변경된주민번호
    FROM member;
    
/* CART 테이블에서 주문번호 앞 8자리 조회, 상품코드 앞 4자리 조회 */
SELECT SUBSTR(cart_no, 1, 8) AS 주문번호,
                 SUBSTR(cart_prod, 1, 4) AS 상품코드
    FROM cart;

/* 김씨 성을 가진 회원이 구매한 상품이 속한 상품분류정보를 조회 */
-- 상품분류코드, 상품분류명 조회
-- 단 상품정보 테이블 사용X
SELECT lprod_gu, lprod_nm
    FROM lprod
 WHERE lprod_gu IN(SELECT SUBSTR(cart_prod, 1, 4) FROM cart WHERE cart_member IN(SELECT mem_id FROM member WHERE mem_name LIKE '김%'));