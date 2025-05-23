/*
<구문 작성시 순서> -- 권장
  - 1. 조회하고자 하는 컬럼(데이터)들이 속한 테이블 찾기
  - 2. 해당 컬럼의 영문명 찾기
  - 3. 관계조건(PK=FK)이 있는지 찾기
  - 4. 일반조건이 있는지 찾기
  - 5. 정렬조건(오름차순, 내림차순 등) 있는지 찾기(보통 예의상 정렬)
*/

/* 회원정보에서 회원아이디, 이름, 직업, 취미 조회 */
SELECT mem_id, mem_name, mem_job, mem_like
  FROM member;

/* 상품정보 전체 모든 컬럼 조회 */
SELECT *
  FROM prod;

/* 상품분류정보 전체 모든 컬럼 조회 */
SELECT *
  FROM lprod;

/* 거래처정보 전체 모든 컬럼 조회 */
SELECT *
  FROM buyer;

/* 구매정보 전체 모든 컬럼 조회 */
SELECT *
  FROM cart;
   
/* 상품명, 매입가격, 소비자가격, 판매가격 조회 */
SELECT prod_name, prod_cost, prod_price, prod_sale
  FROM prod
ORDER BY prod_name ASC; -- 정렬 (ASC : 오름차순, DESC : 내림차순)

/* 정렬 할 컬럼을 SELECT에서 선택한 컬럼 순서로 선택 */
SELECT prod_name, prod_cost, prod_price, prod_sale
  FROM prod
ORDER BY 1 ASC; -- 1번째 컬럼 기준으로 오름차순
 
/* 정렬할 컬럼의 별칭 사용 */
SELECT prod_name as pnm, -- 가장 많이 사용하는 방법
             prod_cost pct,
             prod_price "ppc",
             prod_sale as "ps"
  FROM prod
ORDER BY pnm ASC; 
 

/* 상품아이디, 상품명 조회 */
-- 상품명 : "남성 겨울 라운드 셔츠1" 
-- 별칭 : 아이디는 id, 상품명은 name
-- 정렬은 상품명을 기준으로 내림차순
SELECT prod_id as id,
             prod_name as name
  FROM prod
WHERE prod_name = '남성 겨울 라운드 셔츠 1'
 ORDER BY name DESC;
  
/*
<조회 구문을 Oracle이 해석하는 순서>
 - 1. SELECT
 - 2. FROM 테이블
 - 3. WHERE -- SELECT에서 정의한 별칭 사용 X
 - 4. 조회할 컬럼 -- 해당 순서부터 SELECT에서 정의한 별칭 사용 O
 - 5. 정렬
*/


/* 회원아이디, 마일리지, 마일리지를 12로 나눈 값을 조회 */
-- 별칭 id, mileage, mileage12
-- 정렬 mileage12를 기준으로 내림차순
SELECT mem_id as id,
             mem_mileage as mileage,
             mem_mileage/12 as mileage12 -- 컬럼에 연산이 있으면 무조건 별칭 사용
  FROM member
ORDER BY mileage12 DESC;
  
/* 별칭을 사용해야하는 경우 */
-- 컬럼을 이용하여 연산 또는 함수를 이용한 경우

/* 상품코드, 상품명, 판매금액 조회 */
-- 단, 판매금액 = 판매가격 * 55 한 값을 사용
-- 별칭이 필요한 경우 자유롭게 사용
-- 조회 시 판매금액이 1000 이상인 경우만 조회
-- 정렬은 판매금액 기준으로 오름차순
SELECT prod_id as id,
             prod_name as name,
             prod_sale * 55 as sale55
  FROM prod
WHERE prod_sale >= 1000
ORDER BY sale55 ASC;