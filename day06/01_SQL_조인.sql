/*
<조인(Join)>
 - 관계되는 테이블들의 데이터를 PK 및 FK를 이용하여 
   조회하고자 할 때 사용하는 문법(join문 이라고 칭함)
 - 지금까지 사용한 서브쿼리는 대부분 조인(join)으로 처리 가능
 - 조인(join) 문법은 국제표준 문법과 DB 자체 문법이 있음
 
<문법 (국제표준)>
 SELECT 조회할 컬럼들...
    FROM 테이블1 조인명령 테이블2 
       ON(관계조건 pk = fk
         AND 일반조건들...
         AND 일반조건들..) 조인명령 테이블3
           ON(관계조건 pk = fk
          AND 일반조건들...
          AND 일반조건들..)
     GROUP BY 그룹 컬럼들..
    HAVING 그룹 조건들..
    ORDER BY 정렬 조건들...                   

<조인 조건>
 ** 국제표준 조인 : CROSS, INNER, OUTER, SELF 조인
 - 1. CROSS JOIN : 관계조건(pk=fk) 없이 사용됨
                 (사용되지 않습니다.)
 - 2. INNER JOIN : 관계조건(pk=fk)이 성립하는 경우
                 (가장 많이 사용됨, 국제표준을 따르지 안아도됨)
 3. OUTER JOIN : LEFT OUTER JOIN, RIGHT OUTER JOIN
                 FULL OUTER JOIN(사용되고 있지 않음)
    : Inner Join을 만족하면서, 
      관계조건이 성립하지 않는 경우에도 조회
    : 있으면 있는데로, 없으면 Null
    : 통계 처리시에 주로 사용됨 (국제표준을 무조건 따라야함)
 4. Self Join : 자기 자신의 테이블을 두개로 정의 후 사용
               : 테이블에 별명을 붙여서 사용해야 함
 5. 자연적인 Join : 각 테이블의 PK=FK가 정의되지 않았으나,
                   컬럼명이 같은 경우
 6. 값에 의한 Join : 각 테이블의 PK=FK가 정의되지 않았으나,
                    컬럼의 값들이 같은 경우
        
*/

/*
<Cross Join>
 - ** 관계조건 없이 모든 테이블의 행의 값들을 Cross해서 조회하는 방식
 - ** 조회건수 = 테이블행수 * 테이블행수 * ....
 - Cross Join은 잘 못 사용하게 되면 DB시스템에 부하가 발생할 수 있음
   --> 테이블 내에 데이터가 매우 많이 존재하는 경우에 시간 오래걸림
*/

-- [Cross Join 사용] --------------------------
/* 회원아이디, 회원이름, 주문번호, 주문수량 조회 */
-- [국제 표준 방식]
Select mem_id, mem_name, cart_no, cart_qty
From member Cross Join cart;

Select count(*)
From member Cross Join cart;

-- [일반 방식]
Select mem_id, mem_name, cart_no, cart_qty
From member, cart;

Select count(*)
From member, cart;

-- [Inner Join] --------------------
/*
 - 일반적으로 불리우는 Join을 Inner Join이라 칭함
 - Join 방식 중 가장 많이 사용되는 방식
 - Inner Join은 사용되는 테이블의 관계가 같은 값들에 대해서만 조회
   (같지 않은 값들은 조회하지 않음)
 - 관계 조건(PK = FK)을 필수적으로 정의해야함
 - 국제표준과 일반방식 모두 사용가능하며,
 - 일반방식도 모든 DB에서 사용가능(표준 처럼 사용함)
*/

/* 회원아이디, 회원이름, 주문번호, 주문수량 조회 */
-- 1. 테이블 찾기 : member, cart
-- 2. 관계조건 찾기 : mem_id = cart_member
--    * 관계조건 갯수 : (테이블 갯수 - 1)개 이상 있어야함
-- 3. 일반조건 찾기 : 없음
-- 4. 그룹조건 찾기 : 없음
-- 5. 조회할 컬럼 : mem_id, mem_name, cart_no, cart_qty
-- 6. 정렬 조건 찾기 : 없음(예의상 해주면 됩니다.)

--[일반 방식]
Select mem_id, mem_name, cart_no, cart_qty
From member, cart
Where mem_id = cart_member;

Select Count(*)
From member, cart
Where mem_id = cart_member;

--[국제 표준]
Select mem_id, mem_name, cart_no, cart_qty
From member Inner Join cart
              On(mem_id = cart_member);
-- Where 일반조건 허용됨;

/*
회원아이디, 회원이름, 주문번호, 주문수량, 상품코드, 상품명 조회하기
 - 정렬 : 회원이름 기준 오름차순, 주문번호 내림차순
 - 일반방식과 국제표준 방식 모두 작성
 - 사용 테이블 : member, cart, prod
 - 관계조건 : mem_id = cart_member
           : prod_id = cart_prod
 - 조회컬럼 : mem_id, mem_name, cart_no, cart_qty
             prod_id, prod_name
 - 정렬조건 : mem_name ASC, cart_no DESC
*/
-- [일반방식]
Select mem_id, mem_name, cart_no, cart_qty,
       prod_id, prod_name
From member, cart, prod
Where mem_id = cart_member
  And prod_id = cart_prod
Order By mem_name ASC, cart_no DESC;

Select count(*)
From member, cart, prod
Where mem_id = cart_member
  And prod_id = cart_prod
Order By mem_name ASC, cart_no DESC;

-- [국제표준방식]
Select mem_id, mem_name, cart_no, cart_qty,
       prod_id, prod_name
From member Inner Join cart
              On(mem_id = cart_member)
            Inner Join prod
              On(prod_id = cart_prod)
Order By mem_name ASC, cart_no DESC;

/* <테이블에 별칭 붙이기>
   - 테이블 2개 이상을 사용하는 경우에는
     사용되는 컬럼들이 어느 테이블에 소속됐는지 모르기 때문에
     --> 테이블 별칭을 이용해서 소속을 알려주는 것이
         코드 이해하는데 명확합니다.
   - 테이블 별칭 작성법 : 테이블 이름 뒤에 스페이스(한칸띄우고) 
                        별칭으로 사용할 이름 작성
                      : 테이블 이름이 긴경우에 주로 사용됨
                      : 별칭은 압축된 이름 또는 하나의 단어를
                        주로 사용
*/
Select M.mem_id, M.mem_name, C.cart_no, C.cart_qty,
       P.prod_id, P.prod_name
From member M Inner Join cart C
              On(M.mem_id = C.cart_member)
            Inner Join prod P
              On(P.prod_id = C.cart_prod)
Order By M.mem_name ASC, C.cart_no DESC;

/*
주문 내역이 있는 회원정보 조회하기
 - 조회컬럼 : 회원아이디, 회원이름, 주문수량, 상품명
 - 단, 회원의 성씨가 "이"씨인 회원에 대해서
 - 일반방식, 국제표준방식 모두 작성
*/
-- [일반방식]
Select Distinct mem_id, mem_name,  cart_qty, prod_name
From member, cart, prod
Where Substr(mem_name, 1, 1) = '이'
  And mem_id = cart_member
  And prod_id = cart_prod;
  
Select count(*)
From member, cart, prod
Where Substr(mem_name, 1, 1) = '이'
  And mem_id = cart_member
  And prod_id = cart_prod;

-- [국제표준 방식]
Select Distinct mem_id, mem_name,  cart_qty, prod_name
From member Inner Join cart
              On(Substr(mem_name, 1, 1) = '이'
                 And mem_id = cart_member)
            Inner Join prod
              On(prod_id = cart_prod);

-- 일반조건을 where절로 분리 가능 : Inner join인 경우만              
Select Distinct mem_id, mem_name,  cart_qty, prod_name
From member Inner Join cart
              On(mem_id = cart_member)
            Inner Join prod
              On(prod_id = cart_prod)
Where Substr(mem_name, 1, 1) = '이';


/*
주문 내역이 있는 회원정보 조회하기
 - 조회컬럼 : 회원아이디, 회원이름, 주문수량, 상품명
 - 단, 회원의 성씨가 "이"씨인 회원에 대해서
   그리고, 상품명에 "셔츠"가 포함된 경우 조회
 - 일반방식, 국제표준방식 모두 작성
*/
-- [일반방식]
Select Distinct mem_id, mem_name,  cart_qty, prod_name
From member, cart, prod
Where Substr(mem_name, 1, 1) = '이'
  And mem_id = cart_member
  And prod_name Like '%셔츠%'
  And prod_id = cart_prod;
  
Select count(*)
From member, cart, prod
Where Substr(mem_name, 1, 1) = '이'
  And mem_id = cart_member
  And prod_name Like '%셔츠%'
  And prod_id = cart_prod;

-- [국제표준 방식]
Select Distinct mem_id, mem_name,  cart_qty, prod_name
From member Inner Join cart
              On(Substr(mem_name, 1, 1) = '이'
                 And mem_id = cart_member)
            Inner Join prod
              On(prod_name Like '%셔츠%'
                 And  prod_id = cart_prod);

/*
회원이름, 주문번호, 상품명, 상품분류명, 거래처명 조회하기
*/
-- [일반방식]
Select mem_name, cart_no, prod_name, 
       lprod_nm, buyer_name
From member, cart, prod, lprod, buyer
Where mem_id = cart_member
  And prod_id = cart_prod
  And lprod_gu = prod_lgu
  And buyer_id = prod_buyer;

-- [표준방식]
Select mem_name, cart_no, prod_name, 
       lprod_nm, buyer_name
From member Inner Join cart
              On(mem_id = cart_member)
            Inner Join prod
              On(prod_id = cart_prod)
            Inner Join lprod
              On(lprod_gu = prod_lgu)
            Inner Join buyer
              On(buyer_id = prod_buyer);

/*
상품분류별로 상품의 갯수를 집계하고자 합니다.
 - 조회컬럼 : 상품분류코드, 상품분류명, 상품의갯수
 - 정렬은 상품의 갯수를 기준으로 내림차순
 - 일반, 표준 방식 모두 사용
*/
Select lprod_gu, lprod_nm, Count(prod_id) as cnt
From lprod, prod
Where lprod_gu = prod_lgu
Group By lprod_gu, lprod_nm
Order By cnt Desc;


Select lprod_gu, lprod_nm, Count(prod_id) as cnt
From lprod Inner Join prod
             On(lprod_gu = prod_lgu)
Group By lprod_gu, lprod_nm
Order By cnt Desc;

/*
서울 또는 대전 지역에 거주하는 회원이 구매한 상품정보 조회하기
 - 상품명에는 "삼성"이 포함되어 있어야함
 - 조회컬럼 : 회원이름, 거주지역(서울 or 대전), 상품명
             상품분류명, 거래처명
 - 정렬 : 회원지역 기준 오름차순, 상품명 기준 내림차순
*/
Select Distinct mem_name, Substr(mem_add1, 1, 2) as area,
       prod_name, lprod_nm, buyer_name
From member, cart, prod, lprod, buyer
Where mem_id = cart_member
  And Substr(mem_add1, 1, 2) In('서울', '대전')
  And prod_id = cart_prod
  And prod_name like '%삼성%'
  And lprod_gu = prod_lgu
  And buyer_id = prod_buyer
Order By area Asc, prod_name Desc;


Select Distinct mem_name, Substr(mem_add1, 1, 2) as area,
       prod_name, lprod_nm, buyer_name
From member Inner Join cart
              On(mem_id = cart_member
                  And Substr(mem_add1, 1, 2) In('서울', '대전'))
            Inner Join prod
              On(prod_id = cart_prod
                  And prod_name like '%삼성%')
            Inner Join lprod
              On(lprod_gu = prod_lgu)
            Inner Join buyer
              On(buyer_id = prod_buyer)
Order By area Asc, prod_name Desc;

/*
상품분류명, 상품코드, 상품판매가, 회원아이디, 주문수량 조회
 - 상품분류코드가 P101인 것
 - 정렬 : 거래처담당자 기준 오름차순, 주문수량 기준 내림차순
*/
Select lprod_nm, prod_id, prod_sale, 
        cart_member, cart_qty
From lprod, prod, buyer, cart
Where lprod_gu = 'P101'
  And lprod_gu = prod_lgu
  And buyer_id = prod_buyer
  And prod_id = cart_prod
Order By buyer_charger Asc, cart_qty Desc;

Select lprod_nm, prod_id, prod_sale, 
        cart_member, cart_qty
From lprod Inner Join prod
             On(lprod_gu = 'P101'
                And lprod_gu = prod_lgu)
           Inner Join buyer
             On(buyer_id = prod_buyer)
           Inner Join cart
             On(prod_id = cart_prod)
Order By buyer_charger Asc, cart_qty Desc;


/* 회원 전체의 마일리지 평균 이상인 회원들의 정보를 조회 */
-- 취미별 회원의 수
-- 단, 회원 전체 마일리지 평균 이상인 회원들에 대해서만
-- 평균은 NULL 처리 해서 평균을 산정
SELECT mem_like, COUNT(mem_id) AS cnt
  FROM member
WHERE mem_mileage >= (SELECT AVG(nvl(mem_mileage, 0)) FROM member)
 GROUP BY mem_like;


/* 회원의 성씨가 이씨이고 서울, 대전, 부산, 광주에 거주하는 회원들의 평균 마일리지이상인 회원이 구매한 상품정보 조회 */
-- 상품코드, 상품명, 주문일자(0000-00-00), 주문수량, 회원아이디, 회원지역(서울, 대전...), 마일리지
-- 단, 상품명에 "삼성"이 포함 되어 있어야 함
-- 주문일자 기준 내림차순, 마일리지 기준 오름차순 정렬
-- 일반방식, 표준방식 둘다 사용
SELECT prod_id,
                 prod_name,
                 (SUBSTR(cart_no, 1, 4) || '-' || SUBSTR(cart_no, 5, 2) || '-' || SUBSTR(cart_no, 7, 2)) AS prod_date,
                 cart_qty,
                 cart_member,
                 SUBSTR(mem_add1, 1, 2) AS add1,
                 mem_mileage
  FROM member m, cart c, prod p
WHERE cart_member = mem_id
       AND cart_prod = prod_id
       AND prod_name LIKE '%삼성%'
       AND mem_mileage >= (SELECT AVG(nvl(mem_mileage, 0)) FROM member WHERE mem_name LIKE '이%' AND SUBSTR(mem_add1, 1, 2) IN('서울', '대전', '부산', '광주'));



/* 상품분류명, 거래처명 조회 */
-- 상품분류코드가 P101, P201, P301이고
-- 매입수량이 15개 이상이고
-- 서울에 거주하는 회원이며
-- 생년이 74년도인 회원에 대해 조회
-- 상품 분류명 기준 오름차순, 거래처명 기준 오름차순
-- 일반, 표준 모두 작성
SELECT DISTINCT lprod_nm, buyer_name
FROM member, cart, buyer, prod, buyprod, lprod
WHERE cart_member = mem_id
    AND cart_prod = prod_id
    AND prod_id = buy_prod
    AND buyer_id = prod_buyer
    AND lprod_gu = prod_lgu
    AND SUBSTR(cart_prod, 1, 4) IN ('P101', 'P201', 'P301')
    AND prod_id IN (SELECT buy_prod FROM buyprod WHERE buy_qty >= 15)
    AND SUBSTR(mem_add1, 1, 2) = '서울'
    AND EXTRACT(YEAR FROM mem_bir)= 1974
ORDER BY lprod_nm ASC, buyer_name ASC;


/* 상품분류명, 거래처명, 매입수량의합 조회 */
-- 상품분류코드가 P101, P201, P301이고
-- 매입수량이 15개 이상이고
-- 서울에 거주하는 회원이며
-- 생년이 74년도인 회원에 대해 조회
-- 상품 분류명 기준 오름차순, 거래처명 기준 오름차순
SELECT lprod_nm, buyer_name, SUM(nvl(buy_qty, 0)) AS 매입수량의합
FROM member, cart, buyer, prod, buyprod, lprod
WHERE cart_member = mem_id
    AND cart_prod = prod_id
    AND prod_id = buy_prod
    AND buyer_id = prod_buyer
    AND lprod_gu = prod_lgu
    AND SUBSTR(cart_prod, 1, 4) IN ('P101', 'P201', 'P301')
    AND buy_qty >= 15
    AND SUBSTR(mem_add1, 1, 2) = '서울'
    AND EXTRACT(YEAR FROM mem_bir)= 1974
GROUP BY lprod_nm, buyer_name
ORDER BY lprod_nm ASC, buyer_name ASC;



/* 거래처코드, 거래처명, 매입금액의 합 조회 */
-- 입고일자가 2005년 1월
-- 매입금액 = 매입수량 * 매입단가
-- 매입금액의 합은 NULL 확인
SELECT buyer_id, buyer_name, SUM(buy_qty * buy_cost) AS 매입금액합
FROM buyprod, buyer, prod 
WHERE prod_buyer = buyer_id
AND prod_id = buy_prod
AND TO_CHAR(buy_date, 'yyyy-mm') = '2005-01'
GROUP BY buyer_id, buyer_name;

SELECT buy_date
FROM buyprod;