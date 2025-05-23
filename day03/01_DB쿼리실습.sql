/* 상품 분류 코드와 거래처 코드 조회 */
-- 상품 분류 코드 기준 오름차순
-- 거래 처코드 기준 내림차순
SELECT prod_lgu, prod_buyer
  FROM prod
ORDER BY prod_lgu ASC, prod_buyer DESC;
  
/* 중복제거 DISTINCT */
-- 행단위 중복제거 수행
-- SELECT 다음에 정의
-- DISTINCT 다음에 조회할 컬럼 정의
SELECT DISTINCT prod_lgu, prod_buyer
  FROM prod
ORDER BY prod_lgu ASC, prod_buyer DESC;



/* 
<연산자>
 - *산술 연산자
   -- +, -, *, /
 - *조건(비교) 연산자
   -- >, <, >=, <=, != (<>), =
 - *논리 연산자
   -- AND, OR
*/


/* 상품의 판매가격이 17만원 이상인 데이터 조회 */
-- 조회 컬럼 : 상품코드, 상품명, 판매가격
-- 정렬 : 판매가격을 기준으로 내림차순
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale >= 170000
ORDER BY sale DESC;
  
/* 상품의 판매가격이 17만원 이상 20만원 이하인 데이터 조회 */
-- 조회 컬럼 : 상품코드, 상품명, 판매가격
-- 정렬 : 상품명 기준 오름차순, 판매가격 기준 내림차순
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale >= 170000 AND prod_sale <= 200000
ORDER BY name ASC, sale DESC;

/* 상품분류코드가 P201, 상품의 판매가격이 17만원 또는 20만원 이하인 데이터 조회 */
-- 조회 컬럼 : 상품코드, 상품명, 판매가격
-- 정렬 : 상품분류코드 기준 오름차순, 판매가격 기준 내림차순
SELECT prod_lgu AS LGU,
             prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_lgu = 'P201' AND (prod_sale = 170000 OR prod_sale <= 200000) -- AND 연산자가 OR 보다 먼저 실행 되기 때문에 괄호처리 필요
ORDER BY name ASC, sale DESC;
  
/* 상품판매가격이 15, 17, 33 만원인 상품 조회 */
-- 조회 컬럼 : 상품코드, 상품명, 판매가격
-- 정렬 : 상품명 기준 오름차순
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale = 150000
       OR prod_sale = 170000
       OR prod_sale = 330000
ORDER BY name ASC;

/*
논리연산자 OR인 경우에는 IN() 함수 사용 가능
 - 국제 표준에 따른 함수 모든 데이터베이스에서 사용 가능
 - 사용조건
    - 하나의 컬럼에서 값이 다른 조건으로 조회하고자 할 때 포함관계를 나타냄(포함되면 True)
*/
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale IN(150000, 170000, 330000) -- 포함관계를 나타내는 함수 IN()
ORDER BY name ASC; -- 위 쿼리문과 결과 동일


/* 정렬에 사용할 수 있는 컬럼 : FROM 테이블 내 모든 컬럼, SELECT 한 컬럼 사용 가능 */
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale IN(150000, 170000, 330000) -- 포함관계를 나타내는 함수 IN()
ORDER BY prod_lgu ASC;
  
/* 상품판매가격이 15, 17, 33 만원이 아닌 상품 조회 */
-- 조회 컬럼 : 상품코드, 상품명, 판매가격
-- 정렬 : 상품명 기준 오름차순
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale != 150000
     AND prod_sale != 170000
     AND prod_sale != 330000
ORDER BY name ASC;

/* 다른 방법 */
SELECT prod_id AS id,
             prod_name AS name,
             prod_sale AS sale
  FROM prod
WHERE prod_sale NOT IN(150000, 170000, 330000)
ORDER BY name ASC;

  
/* 현재까지 주문한 회원의 수를 확인하기 위해 주문 내역이 있는 회원 아이디만 조회 */
-- 오름차순 정정렬
SELECT DISTINCT cart_member AS member
  FROM cart
ORDER BY member ASC;
 
/* 행의 수 조회 COUNT() */
SELECT COUNT (DISTINCT cart_member) AS member
  FROM cart;

/* 전체 회원수 조회 */
SELECT COUNT(*) AS member
  FROM member;


/* 한 번도 주문한 적 없는 회원의 정보 조회  */
-- 회원아이디, 이름 조회
-- 정렬은 이름 기준 오름차순
SELECT mem_id AS id,
             mem_name AS name
  FROM member
WHERE mem_id NOT IN (SELECT cart_member FROM cart)
 ORDER BY name ASC;
/* 서브쿼리 방식 1 */
-- 서브쿼리의 SELECT 결과가 "단일컬럼"의 "다중행 결과" 방식 사용 가능


/* 주문한 내역이 있는 회원의 정보 조회  */
-- 회원아이디, 이름 조회
-- 단, 주문 수량이 10개 이상 주문한 회원들만 조회
-- 정렬은 이름 기준 오름차순
SELECT mem_id AS id,
             mem_name AS name
  FROM member
WHERE mem_id IN (SELECT cart_member FROM cart WHERE cart_qty  >= 10)
ORDER BY name ASC;
  
/* 상품분류 코드와 상품분류명 조회 */
-- 상품정보(상품정보테이블)가 없는 상품분류정보를 조회
-- 정렬은 상품분류코드를 기준으로 오름차순
SELECT lprod_gu AS GU,
             lprod_nm AS name
  FROM lprod
WHERE lprod_gu NOT IN(SELECT prod_lgu FROM prod)
ORDER BY lprod_gu ASC;


/* 회원 아이디와 마일리지 조회 */
-- 회원 아이디가 a001인 회원의 마일리지값 이상인 회원들만 조회
-- 정렬은 아이디 기준 오름차순
SELECT mem_id AS id,
             mem_name AS name
  FROM member
WHERE mem_mileage >= (SELECT mem_mileage FROM member WHERE mem_id = 'a001')
ORDER BY mem_id ASC;
/* 서브쿼리 방식 2 */
-- 비교연산자 뒤에 서브쿼리를 사용하는 경우 "단일컬럼"의 "단일행 결과"값만 허용


/* 상품명 "모니터 삼성전자15인치칼라" 인 상품을 구매한 회원의 아이디, 이름 조회 */
-- 정렬은 이름 기준 오름차순
SELECT mem_id AS id,
             mem_name AS name
  FROM member
WHERE mem_id IN (SELECT cart_member FROM cart WHERE cart_prod 
                            IN (SELECT prod_id FROM prod WHERE prod_name = '모니터 삼성전자15인치칼라' ))
ORDER BY mem_name ASC;


/* 구매정보 조회 */
-- 조회컬럼 회원아이디, 회원이름, 주문번호, 구매상품코드, 구매수량
-- 정렬은 회원이름 기준 오름차순, 주문번호 내림차순
SELECT cart_member AS id, 
            (SELECT mem_name FROM member WHERE c.cart_member = mem_id) AS name,
            cart_no AS no,
            cart_prod AS prod,
            cart_qty AS qty
  FROM cart c
ORDER BY name ASC, cart_no DESC;
 /* 서브쿼리 3 */
 -- SELECT 뒤에 조회할 컬럼명 대신 사용하는 서브쿼리는 "단일컬럼" "단일행 결과"만 조회되는 방식으로 사용



/* 회원이 주문한 내역 조회 */
-- 조회컬럼 회원아이디, 회원이름, 상품명, 주문번호, 주문수량
-- 단, 상품의 판매가격이 1만원 이상인 제품을 구매한 회원에 대해서
-- 정렬 없음
SELECT cart_member AS 아이디,
             (SELECT mem_name FROM member WHERE c.cart_member = mem_id) AS 이름,
             (SELECT prod_name FROM prod WHERE c.cart_prod = prod_id) AS 상품명,
             cart_no AS 주문번호, 
             cart_qty AS 주문수량
  FROM cart c
WHERE cart_prod IN (SELECT prod_id FROM prod WHERE prod_sale >= 10000);
 
/* WHERE 조건 튜닝 */
SELECT cart_member AS 아이디,
             (SELECT mem_name FROM member WHERE c.cart_member = mem_id) AS 이름,
             (SELECT prod_name FROM prod WHERE c.cart_prod = prod_id) AS 상품명,
             cart_no AS 주문번호, 
             cart_qty AS 주문수량
  FROM cart c
WHERE (SELECT prod_sale FROM prod WHERE prod_id = cart_prod) >= 10000;
 
 
 
/* 회원 이름, 취미 조회 */
-- 단 회원의 취미가 수영이고 상품분류명이 컴퓨터, 거래처명이 삼성컴퓨터인 제품을 구매한 회원에 대해서만 조회
SELECT mem_name AS 이름,
             mem_like AS 취미
  FROM member
WHERE mem_like = '수영'
     AND mem_id IN (SELECT cart_member
                                    FROM cart
                                  WHERE cart_prod IN (SELECT prod_id
                                                                        FROM prod
                                                                      WHERE prod_buyer = (SELECT buyer_id FROM buyer WHERE buyer_name = '삼성컴퓨터'
                                                                                                                                                                   AND prod_lgu = (SELECT lprod_gu
                                                                                                                                                                                                  FROM lprod
                                                                                                                                                                                                WHERE lprod_nm = '컴퓨터제품'))));


/* 김은대 회원이 주문한 상품의 상품분류코드와 상품분류명 조회 */
-- 조회컬럼 회원아이디, 회원이름, 상품분류코드, 상품분류명, 거래처명
-- 정렬은 상품분류코드 오름차순
SELECT DISTINCT cart_member AS 회원아이디,
                            (SELECT mem_name FROM member WHERE c.cart_member = mem_id) AS 회원이름,
                            (SELECT lprod_gu FROM lprod WHERE lprod_gu = (SELECT prod_lgu FROM prod WHERE prod_id = c.cart_prod)) AS 상품분류코드,
                            (SELECT lprod_nm FROM lprod WHERE lprod_gu = (SELECT prod_lgu FROM prod WHERE prod_id = c.cart_prod)) AS 상품분류명,
                            (SELECT buyer_name FROM buyer WHERE buyer_id = (SELECT prod_buyer FROM prod WHERE prod_id = c.cart_prod)) AS 거래처명
  FROM cart c
WHERE cart_member = (SELECT mem_id FROM member WHERE mem_name = '김은대')
ORDER BY 상품분류코드 ASC;