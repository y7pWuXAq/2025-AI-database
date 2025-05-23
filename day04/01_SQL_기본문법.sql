/* <조회 기본문법>
-----(필수 사용)------
SELECT 조회할 컬럼1, 컬럼2
  FROM 조회할 테이블들

-----(선택 사용)------
WHERE 관계조건 or 일반조건
     AND 논리연산 조건들
       OR 논리연산 조건들
GROUP BY 그룹화할 컬럼들
HAVING 그룹 조건들
ORDER BY 정렬기준들
*/


/* <입력 기본문법>
-----(필수 사용)-----
INSERT INTO 입력할 테이블 (입력할 컬럼1, 컬럼2)
VALUES(입력할 값1, 값2)

- 테이블 내에 모든 컬럼들에게 입력 시
INSERT INTO 입력할 테이블 (컬럼제시X)
VALUES(입력할 값1, 값2)
*/


/* <수정 기본문법>
-----(필수 사용)-----
UPDATE 수정할 테이블 (수정할 컬럼1, 컬럼2)
        SET 수정 할 컬럼1 = 수정할 값1
                           컬럼2 = 수정할 값2
-----(선택 사용)-----
 WHERE 관계조건 or 일반조건
     AND 논리연산 조건들
        OR 논리연산 조건들
*/


/* <삭제 기본문법>
- 삭제는 행단위 삭제 (열 삭제는 없음)
-----(필수 사용)-----
DELETE 삭제할 테이블
-----(선택 사용)-----
WHERE 관계조건 or 일반조건
     AND 논리연산 조건들
        OR 논리연산 조건들
*/


/* <SQL 구문의 구분>
 - 문과 절로 이루어져 있음
 - 문 : SELECT, INSERT, UPDATE, DELETE
 - 절
    * SELECT에 사용하는 절
        FROM, WHERE, GROUP BY,
        HAVING, ORDER BY
    * INSERT에 사용하는 절
        WHERE
    * UPDATE에 사용하는 절
        Set, Where
    * DELETE에 사용하는 절
        FROM, WHERE
*/


/* <서브쿼리 (SubQuery)>
- 서브쿼리를 사용할 수 있는 위치
  - SELECT 문 뒤에 컬럼명 대신 사용 가능
     - *규칙 : 단일컬럼의 단일행 결과값일 것
  - WHERE 절 뒤에 비교연산 시 사용 가능
     - *규칙 : 단일컬럼의 단일행 결과값일 것
  - WHERE 절 뒤에 IN() 함수에 사용 가능
     - *규칙 : 단일컬럼의 단일 or 다중행 결과값일 것
  - WHERE 절 뒤에 EXISTS() 함수에 사용 가능
     - EXISTS(서브쿼리) 함수 : 서브쿼리의 결과값이 존재하면 True
     - *단일 or 다중컬럼의 단일 or 다중행 결과값일 것
  - FROM 절 뒤에 테이블 대신 사용 가능(단, 이 경우 별칭 사용 필수)
     - *단일 or 다중컬럼의 단일 or 다중행 결과값일 것
*/


/* 김은대 회원이 주문한 상품의 상품분류코드와 상품분류명 조회 */
-- 조회컬럼 회원아이디, 회원이름, 상품분류코드, 상품분류명, 거래처명
-- 정렬은 상품분류코드 오름차순
SELECT DISTINCT cart_member AS 회원아이디,
                             (SELECT mem_name FROM member WHERE c.cart_member = mem_id) AS 회원이름,
                             (SELECT lprod_gu FROM lprod WHERE lprod_gu = (SELECT prod_lgu FROM prod WHERE prod_id = c.cart_prod)) AS 상품분류코드,
                             (SELECT lprod_nm FROM lprod WHERE lprod_gu = (SELECT prod_lgu FROM prod WHERE prod_id = c.cart_prod)) AS 상품분류명,
                             (SELECT buyer_name FROM buyer WHERE buyer_id = (SELECT prod_buyer FROM prod WHERE prod_id = c.cart_prod)) AS 거래처명
  FROM cart c
WHERE cart_member IN (SELECT mem_id FROM member WHERE mem_name = '김은대') -- "동명이인이 있다는 가정"
ORDER BY 상품분류코드 ASC;