/* 모든 회원에 대한 회원 수, 마일리지 총합 조회 */
-- 마일리지 평균, 마일리지 최소값, 마일리지 최대값 조회
-- 조회하고자 하는 컬럼에 일반컬럼이 없는 경우
SELECT count(*) AS COUNT,
                 SUM(mem_mileage) AS 마일리지총합,
                 ROUND(AVG(mem_mileage), 3) AS 마일리지평균,
                 MIN(mem_mileage) AS 마일리지최소값,
                 MAX(mem_mileage) AS 마일리지최대값
    FROM member;

/* 상품분류별로 상품의 갯수 확인 */
-- 상품분류코드, 상품갯수
SELECT prod_lgu, COUNT(prod_id) AS cnt
FROM prod
GROUP BY prod_lgu;
-- 조회할 컬럼 중 일반컬럼 또는 일반함수를 이용한 컬럼은
-- 원형 그대로를 GROUP BY절에 작성해야함

/* 상품분류별로 상품의 갯수 확인 */
SELECT prod_lgu, COUNT(prod_id) AS cnt
FROM prod
GROUP BY prod_lgu
HAVING COUNT(prod_id) >= 10;

/* <그룹규칙>
 - 1. SELECT 문 뒤에 조회하는 컬럼으로는 일반컬럼, 일반함수, 그룹함수가 동시에 사용될 수 있으며
        이때 일반 컬럼 및 일반 함수들은 모두 GROUP BY 뒤에 원형 그대로를 작성해야 함
 - 2. 그룹 조건이 발생하는 경우
      - GROUP BY 절 다음에 HAVING절에 그룹 조건을 작성
      - 그룹 조건은 그룹함수를 그대로 사용하여 비교연산자를 이용해 처리
 - 3. GROUP BY를 사용한 경우 정렬에 사용할 수 있는 컬럼들
      - SELECT문 뒤에 조회하는 모든 컬럼들 가능
      - GROUP BY절 뒤에 작성된 모든 컬럼들 가능
*/

/* 회원 취미 별로 회원수 조회 */
SELECT mem_like, COUNT(mem_id) AS cnt
FROM member
GROUP BY mem_like
ORDER BY mem_like ASC;

/* 회원지역별로 회원수 조회 */
-- 단 상품명에 "삼성"이 포함된 상품을 주문한 회원
-- 지역별 회원수가 2명 이상인 경우
-- 정렬은 회원수 기준 내림차순
-- 조회컬럼 : 지역, 회원수
SELECT mem_add1, COUNT(mem_id) AS 회원수
    FROM member
 WHERE mem_id IN(SELECT cart_member FROM cart WHERE cart_prod IN(SELECT prod_id FROM prod WHERE prod_name LIKE '%삼성%'))
  ORDER BY mem_add1;

/* 회원 전체 마일리지의 평균 이상인 회원정보를 조회 */
-- 조회컬럼 : 회원아이디, 이름, 마일리지 조회
SELECT mem_id, mem_name, mem_mileage
    FROM member
 WHERE mem_mileage >= (SELECT AVG(mem_mileage) FROM member);
 
 /* 회원이름, 회원지역(서울, 부산...), 회원생일(년도만) */
 -- 마일리지평균, 마일리지합을 조회
 -- 단, 회원의 성씨가 "이" 씨인 회원
 -- 정렬 : 회원지역을 기준으로 내림차순, 생일의 년도를 기준으로 오름차순
SELECT mem_name AS 회원이름,
                 SUBSTR(mem_add1, 1, 2) AS 거주지역,
                 EXTRACT(YEAR FROM mem_bir) AS 회원생년,
                 ROUND(AVG(mem_mileage), 3) AS 마일리지평균,
                 SUM(mem_mileage) AS 마일리지합
FROM member
WHERE SUBSTR(mem_name ,1 ,1) = '이'
GROUP BY mem_name, SUBSTR(mem_add1, 1, 2), EXTRACT(YEAR FROM mem_bir)
ORDER BY 거주지역 DESC, 회원생년 ASC;


/* 상품분류코드, 상품소비자가격의 평균 조회 */
-- 실수값은 소숫점 2자리까지 표현
SELECT prod_lgu, ROUND(AVG(prod_price), 2) AS 마일리지평균
    FROM prod
  GROUP BY prod_lgu;
  
/* <NULL 처리하기>
 - NULL은 메모리가 존재하지 않는 것을 의미
*/

/* NULL 데이터 만들기 */
-- 거래처 담당자의 성씨가 "이" 씨인 거래처만 조회
-- 거래처코드, 거래처담당자 조회
SELECT buyer_id, buyer_charger
FROM buyer
WHERE SUBSTR(buyer_charger, 1, 1) = '이';

-- 거래처 담당자의 성씨가 "이" 씨인 거래처 담당자의 이름을 NULL로 수정
UPDATE buyer
SET buyer_charger = NULL
WHERE SUBSTR(buyer_charger, 1, 1) = '이';


/* <NULL 확인 명령어(국제표준)>
 - 결측치 조회 : IS NULL
 - 결측치가 없는 경우만 조회 : IS NOT NULL
*/

/* 거래처 담당자에 결측치가 있는 경우만 조회 */
SELECT buyer_id, buyer_charger
FROM buyer
WHERE buyer_charger IS NULL;

SELECT buyer_id, buyer_charger
FROM buyer
WHERE buyer_charger IS NOT NULL;


/* <결측치 처리 함수> -- 국제표준 아님
 - NVL(원본값, 결측값이 있는 경우 대체할 값) -- 주로 사용
 - NVL2(원본값, 결측치가 없는 경우 대체값, 결측치가 있는경우 대체값)
*/

SELECT buyer_id, buyer_charger, NVL(buyer_charger, '빈칸') AS NVL_val
FROM buyer;


/* 회원중에 "이"씨가 구매한 상품정보의 소비자가격을 NULL 처리 */
-- 검증을 위해 해당 조건의 값을 먼저 조회
-- 이후 소비자 가격 수정 진행
SELECT prod_name, prod_price
    FROM prod
 WHERE prod_id IN(SELECT cart_prod FROM cart WHERE cart_member IN(SELECT mem_id FROM member WHERE SUBSTR(mem_name, 1, 1) = '이'));

UPDATE prod
         SET prod_price = NULL
  WHERE prod_id IN(SELECT cart_prod FROM cart WHERE cart_member IN(SELECT mem_id FROM member WHERE SUBSTR(mem_name, 1, 1) = '이'));
-- 소비자 가격의 컬럼 제약조건으로 NULL값 치환 안됨


SELECT COUNT(prod_id), COUNT(prod_size) AS cnt1, COUNT(NVL(prod_size, 0)) AS cnt2
FROM prod;


/* <조건문 사용하기> -- 국제표준X 
 - DECODE(조건값, 비교값1, 출력값1, 비교값2, 출력값2, 무조건출력값)
 - CASE()
    CASE WHEN 조건 THEN 츨력값1 THEN 출력값2, .... ELSE 무조건 END
*/


/* DECODE() 함수 사용 */
/* 회원이름, 회원성별(남성, 여성으로 조회) */
SELECT mem_name, DECODE(MOD(SUBSTR(mem_regno2, 1, 1), 2), 0, '여성', 1, '남성') AS 성별
FROM member;

SELECT mem_name,
                 DECODE(MOD(SUBSTR(mem_regno2, 1, 1), 2), 0, '여자', 1, '남자', '빈칸') AS 성별,
                 (CASE WHEN MOD(SUBSTR(mem_regno2, 1, 1), 2) = 0 THEN '여자'
                              WHEN MOD(SUBSTR(mem_regno2, 1, 1), 2) = 1 THEN '남자' ELSE '빈칸' END) AS 성별2
FROM member;

/* 조건으로 사용되는 서브쿼리 함수 : EXISTS(서브쿼리) 
 - 서브쿼리 결과규칙 : 다중컬럼에 다중행 모두 가능
 - 행이 1개라도 존재하면 참
 - 행이 0개면 거짓
*/

-- 주문 내역이 있는 회원 조회
SELECT mem_id, mem_name
FROM member
WHERE EXISTS(SELECT * FROM cart WHERE cart_member = mem_id);

-- 주문내역이 없는 회원 조회
SELECT mem_id, mem_name
FROM member
WHERE NOT EXISTS(
    SELECT *
    FROM cart
    Where cart_member = mem_id
);