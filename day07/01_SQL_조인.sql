/* 회원 전체에 대한 구매수량의 합을 조회 */
-- 조회컬럼 : 회원아이디, 회원이름, 구매수량의 합
-- 일반, 표준 모두 작성

-- 서브쿼리 이용
SELECT mem_id, mem_name, NVL((SELECT SUM(cart_qty) FROM cart WHERE mem_id = cart_member), 0) AS 구매수량의합
  FROM member
ORDER BY 구매수량의합 ASC;

-- INNER JOIN 오라클 일반방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
  FROM member, cart
WHERE mem_id = cart_member
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;

-- 표준방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
  FROM member INNER JOIN cart ON(mem_id = cart_member)
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;


/* <OUTER JOIN>
 - 어느 한쪽의 테이블을 기준으로 전체 조회
    - 전체 집계할 때 사용
 - LEFT OUTER JOIN : 왼쪽 테이블을 기준으로 전체 조회
                                        : 오른쪽 테이블과 같은 값은 그대로 조회
                                        : 오른쪽 테이블과 같은 값이 없으면 NULL
 - RIGHT OUTER JOIN : LEFT OUTER JOIN 과 반대 개념
 - OUTER JOIN은 값이 있으면 존재하는 값, 없으면 NULL 조회
 - OUTER JOIN을 사용하는 경우 -> 일반조건이 있는 경우는 무조건 국제표준 방식 사용
                                                          -> ON() 안에 일반조건 작성
 - 문법은 INNER JOIN을 만족하는 문법을 그대로 적용(관계조건 동일)
    (JOIN 명령만 다름)
*/

-- 오라클 사용 일반방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
  FROM member, cart
WHERE mem_id = cart_member(+)
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;

-- 표준방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
  FROM member LEFT OUTER JOIN cart ON(mem_id = cart_member)
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;


/* 회원 전체에 대한 구매수량의 합을 조회 */
-- 조회컬럼 : 회원아이디, 회원이름, 구매수량의 합
-- 마일리지 값이 3000이상인 회원들에 대해서 조회
-- 일반, 표준 모두 작성

-- 일반방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
FROM member, cart
WHERE mem_id = cart_member(+) AND mem_mileage >= 3000
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;

-- 표준방식
SELECT mem_id, mem_name, SUM(NVL(cart_qty, 0)) AS 구매수량의합
FROM member LEFT OUTER JOIN cart ON(mem_id = cart_member AND mem_mileage >= 3000)
GROUP BY mem_id, mem_name
ORDER BY 구매수량의합 ASC;


/* 상품 분류 전체에 대한 상품의 갯수를 조회 */
-- 조회컬럼 : 상품분류코드, 상품분류명, 상품정보의갯수
-- 상품명에 "삼성"이 포함된 경우만 조회

-- <일반>
SELECT lprod_gu, lprod_nm, COUNT(prod_id) AS 상품정보행의갯수
FROM lprod, prod 
WHERE lprod_gu = prod_lgu(+) AND prod_name LIKE '%삼성%'
GROUP BY lprod_gu, lprod_nm;

-- <표준>
SELECT lprod_gu, lprod_nm, COUNT(prod_id) AS 상품정보행의갯수
FROM lprod LEFT OUTER JOIN prod ON (lprod_gu = prod_lgu AND prod_name LIKE '%삼성%') 
GROUP BY lprod_gu, lprod_nm;


/* 전체 상품 대한 상품코드, 상품명, 매입수량의 합 조회하기 */
-- 입고일자가 2005년 1월에 대해 조회
SELECT prod_id, prod_name, NVL(SUM(buy_qty), 0) AS 매입수량의합
FROM prod LEFT OUTER JOIN buyprod ON(prod_id = buy_prod AND TO_CHAR(buy_date, 'yyyy-mm') = '2005-01')
GROUP BY prod_id, prod_name
ORDER BY 매입수량의합 DESC;


/* 아이디가 a001인 회원의 마일리지보다 큰(이상) 회원들 조회 */
-- 조회컬럼 : 회원아이디, 회원이름, 마일리지
-- 조인 없이 조회, 조인으로 조회
SELECT mem_id, mem_name, mem_mileage
FROM member
WHERE mem_mileage >= (SELECT mem_mileage FROM member WHERE mem_id = 'a001')
ORDER BY mem_mileage ASC;

SELECT m1.mem_id, m1.mem_name, m1.mem_mileage
FROM member m1, member m2
WHERE m2.mem_id = 'a001'
      AND m1.mem_mileage >= m2.mem_mileage
ORDER BY m1.mem_mileage ASC;


/* <SELF 조인 방식>
 - 자기 자신의 테이블을 여러개로 정의해서 사용하는 경우
 - 테이블은 별칭을 사용해서 정의
 - 조건이 있는 경우 : 특정 테이블 하나를 기준으로 조건 처리
 - 국제 표준 : INNER JOIN 사용, 관계조건 제외하고 사용
 - 표준보다는 일반방식을 주로 사용
*/


SELECT mem_id, mem_name, mem_mileage
FROM member, (SELECT mem_mileage AS mileage FROM member WHERE mem_id = 'a001') m2
WHERE mem_mileage >= m2.mileage
ORDER BY mem_mileage ASC;



/* 상품정보 전체에 대한 컬럼 조회 */
-- 조회 컬럼 : 상품코드, 매입수량의합, 구매수량의합 조회
-- 입고일자가 2005년 4월 16일, 구매일자가 2005년 4월 16일인 경우
-- 정렬 : 매입수량의합 기준 오름차순, 구매수량의 합 기준 내림차순
SELECT p.prod_id,
                 SUM(b.buy_qty) AS 매입수량합, 
                 SUM(c.cart_qty) AS 구매수량합
FROM prod p 
             LEFT OUTER JOIN cart c ON (p.prod_id = c.cart_prod AND SUBSTR(c.cart_no, 1, 8) = '20050416')
             LEFT OUTER JOIN buyprod b ON (p.prod_id = b.buy_prod AND TO_CHAR(b.buy_date, 'yyyy-mm-dd') = '2005-04-16')
GROUP BY p.prod_id
ORDER BY 매입수량합 ASC, 구매수량합 DESC;


/* 매입 월별 매입수량의합, 매입금액의합 조회 */
-- 매입 년도가 2005년도에 해당
-- 매입금액 = 매입수랑 * 매입단가
SELECT EXTRACT(MONTH FROM buy_date) AS 매입월, SUM(buy_qty) AS 매입수량의합, SUM(buy_qty * buy_cost) AS 매입금액의합
FROM buyprod
WHERE EXTRACT(YEAR FROM buy_date) = 2005
GROUP BY EXTRACT(MONTH FROM buy_date)
ORDER BY 매입월;


/* 모든 거래처에 대한 매출금액의 합계 조회 */
-- 조회컬럼 : 거래처코드, 거래처명, 매출금액의합
-- 매출금액 = 구매수량 * 판매가격
-- 구매년도가 2005년도에 해당
-- 매출금액의합 기준 오름차순 정렬
SELECT buyer_id, buyer_name, NVL(SUM(cart_qty * prod_sale), 0) AS 매출금액합
FROM buyer LEFT OUTER JOIN prod ON(buyer_id = prod_buyer)
                        LEFT OUTER JOIN cart ON(prod_id = cart_prod AND SUBSTR(cart_no, 1, 4) = '2005')
GROUP BY buyer_id, buyer_name
ORDER BY 매출금액합 ASC;


/* 모든 거래처에 대한 매입금액의 합계 조회 */
-- 조회컬럼 : 거래처코드, 거래처명, 매입금액의합
-- 매입금액 = 매입수랑 * 매입단가
-- 매입년도가 2005년도에 해당
-- 매입금액의합 기준 오름차순 정렬
SELECT buyer_id, buyer_name, NVL(SUM(buy_qty * buy_cost), 0) AS 매입금액의합
FROM buyer LEFT OUTER JOIN prod ON(buyer_id =prod_buyer)
                        LEFT OUTER JOIN buyprod ON(buy_prod = prod_id AND TO_CHAR(buy_date, 'yyyy') = '2005')
GROUP BY buyer_id, buyer_name
ORDER BY 매입금액의합 ASC;


/* 모든 거래처에 대한 매출금액과 매입금액의 합계 조회 */
-- 조회컬럼 : 거래처코드, 거래처명, 매출금액의합, 매입금액의합
-- 매출금액 = 구매수량 * 판매가격
-- 매입금액 = 매입수랑 * 매입단가
-- 매입과 매출은 2005년도에 해당하는 것
-- 거래처코드 기준 오름차순 정렬
SELECT t1.buyer_id, 
                 t1.buyer_name, 
                 NVL(t1.매입금액의합, 0) AS 매입금액의합, 
                 NVL(t2.매출금액합, 0) AS 매출금액합
FROM (SELECT buyer_id, buyer_name, NVL(SUM(buy_qty * buy_cost), 0) AS 매입금액의합
                 FROM buyer LEFT OUTER JOIN prod ON(buyer_id =prod_buyer)
                                         LEFT OUTER JOIN buyprod ON(buy_prod = prod_id AND TO_CHAR(buy_date, 'yyyy') = '2005')
               GROUP BY buyer_id, buyer_name
               ORDER BY 매입금액의합 ASC) t1,
             (SELECT buyer_id, buyer_name, NVL(SUM(cart_qty * prod_sale), 0) AS 매출금액합
                  FROM buyer LEFT OUTER JOIN prod ON(buyer_id = prod_buyer)
                                          LEFT OUTER JOIN cart ON(prod_id = cart_prod AND SUBSTR(cart_no, 1, 4) = '2005')
               GROUP BY buyer_id, buyer_name
               ORDER BY 매출금액합 ASC) t2
WHERE t1.buyer_id = t2.buyer_id
ORDER BY t1.buyer_id;



/* 회원아이디, 회원이름, 회원지역, 회원성별(남자 or 여자) 조회 */
-- 아이디 오름차순 정렬
SELECT mem_id,
                 mem_name,
                 SUBSTR(mem_add1, 1, 2) AS mem_area,
                 DECODE(MOD(SUBSTR(mem_regno2, 1, 1), 2), 0, '여성', 1, '남성') AS mem_sex
FROM member
ORDER BY mem_id;

-- 조회한 결과 (가공한 데이터)를 임의 테이블로 생성 및 저장
CREATE TABLE mem_area_sex
AS -- 가공을 위해 조회한 결과에 대해 SQL 구문을 아래 작성
    SELECT mem_id,
                     mem_name,
                     SUBSTR(mem_add1, 1, 2) AS mem_area,
                     DECODE(MOD(SUBSTR(mem_regno2, 1, 1), 2), 0, '여성', 1, '남성') AS mem_sex
    FROM member
    ORDER BY mem_id;




/* <뷰(VIEW)>
 - 가상테이블
 - 외부 TABLE에 대한 모든 정보를 공개하지 않고 임의 정보만 제공하고자 할 때 사용
 - SQL 구문이 매우 긴 경우로 자주 사용되어야 하는 SQL 구문인 경우에 미리 가공하여 조회 결과를 사용할 수 있도록 함
 - 사용방법 : 테이블 사용방법과 SQL 구문이 동일하게 사용됨
     SELECT 조회할 컬럼
     FROM 가상테이블 이름
     WHERE 조건들 .. 이하 동일
 - 가상테이블도 테이블과 동일한 객체임
*/

/* CREATE OR REPLACE : 뷰 이름이 존재 한다면 수정, 없다면 새로 생성한다는 의미 */
CREATE OR REPLACE VIEW view_in_out_price
AS SELECT t1.buyer_id, 
                      t1.buyer_name, 
                      NVL(t1.매입금액의합, 0) AS 매입금액의합, 
                      NVL(t2.매출금액합, 0) AS 매출금액합
         FROM (SELECT buyer_id, buyer_name, NVL(SUM(buy_qty * buy_cost), 0) AS 매입금액의합
                           FROM buyer LEFT OUTER JOIN prod ON(buyer_id =prod_buyer)
                                                   LEFT OUTER JOIN buyprod ON(buy_prod = prod_id AND TO_CHAR(buy_date, 'yyyy') = '2005')
                         GROUP BY buyer_id, buyer_name
                         ORDER BY 매입금액의합 ASC) t1,
                     (SELECT buyer_id, buyer_name, NVL(SUM(cart_qty * prod_sale), 0) AS 매출금액합
                         FROM buyer LEFT OUTER JOIN prod ON(buyer_id = prod_buyer)
                                                 LEFT OUTER JOIN cart ON(prod_id = cart_prod AND SUBSTR(cart_no, 1, 4) = '2005')
                       GROUP BY buyer_id, buyer_name
                       ORDER BY 매출금액합 ASC) t2
       WHERE t1.buyer_id = t2.buyer_id
       ORDER BY t1.buyer_id;

-- VIEW를 이용하여 조회
SELECT *
 FROM view_in_out_price
ORDER BY buyer_id ASC;



/* 사용자 정의 함수 (UDF : User Define Function)
 - 구문 조회 시 일반 함수들을 이용해서 데이터 변경이 자주 일어나는 경우 사용
    (예시 : 성별 추출, 지역 추출 등)
*/


/* 지역을 추출하는 함수 정의하기*/
CREATE OR REPLACE FUNCTION udf_getArea
  -- <매개변수 정의 영역> 세미콜론(;) 사용X
    -- IN : 외부에서 값을 넘겨받는 변수(매개변수)라는 의미
    -- %type : 해당 테이블의 컬럼에 대한 타입을 그대로 따르겠다는 의미
    (p_mem_add1 IN member.mem_add1%type)
     -- 최종 결과값을 반환(return)할 타입 정의
     RETURN VARCHAR2
  -- <정의 영역> 정의하고 세미콜론 (;)
IS 
       -- 반환(RETURN)에 사용할 변수 정의
       rtn_mem_area VARCHAR2(30);
  -- <처리영역> 정의하고 세미콜론 (;)
BEGIN
    -- 전달받은 주소값에서 지역만 추출하는 기능 수행
    rtn_mem_area := SUBSTR(p_mem_add1, 1, 2);
    
    -- 호출한 곳으로 반환하기 정의하고 세미콜론 (;)
    RETURN rtn_mem_area;
END;
-- 아래 슬래시를 넣어야 전체 문장의 끝을 알려줄 수 있음
/


/* 함수 사용하기 */
SELECT mem_id, mem_add1, udf_getarea(mem_add1) AS area
FROM member;