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



/* 회원 전체의 마일리지값의 평균을 조회 */
-- 조회한 결과를 리턴하는 함수 정의
-- 함수명 : udf_getMemMileageAvg

-- SQL 구문으로 평균 구하기
SELECT ROUND(AVG(NVL(mem_mileage, 0)), 3)
FROM member;


-- 함수 정의
-- 1. 리턴타입 : 숫자
-- 2. 리턴 할 변수명 : rtn_mileage_avg
-- 3. SELECT 구문 정의
-- 4. 반환(리턴)

CREATE OR REPLACE FUNCTION udf_getMemMileageAvg
    (p_mem_mileage IN member.mem_mileage%type)
     -- 최종 결과값을 반환(return)할 타입 정의
     RETURN NUMBER
  -- <정의 영역> 정의하고 세미콜론 (;)
IS 
       -- 반환(RETURN)에 사용할 변수 정의
       rtn_mileage_avg NUMBER;
  -- <처리영역> 정의하고 세미콜론 (;)
BEGIN
    SELECT ROUND(AVG(NVL(mem_mileage, 0)), 3) INTO rtn_mileage_avg
    FROM member;
    -- 호출한 곳으로 반환하기 정의하고 세미콜론 (;)
    RETURN rtn_mileage_avg;
END;
-- 아래 슬래시를 넣어야 전체 문장의 끝을 알려줄 수 있음
/


/* 정의한 함수 사용 */
/* 회원 전체 평균 마일리지 이상인 회원들의 정보 확인 */
-- 조회 컬럼 : 회원아이디, 회원이름, 마일리지 조회
SELECT mem_id, mem_name, mem_mileage
FROM member
WHERE mem_mileage >= udf_getMemMileageAvg(mem_mileage);



/* <저장 프로시저(Stored Procedure)>
 - 기존의 직접 SQL 실행 방식
     -> SQL 구문작성 >> 실행 >> DB 서버가 해석 >> 결과 반환

 - 저장프로시저를 이용하는 방식
     -> SQL 구문의 결과를 DB서버의 캐시 메모리에 올려둠 >> 결과반환
*/



/* 아이디 'a001'에 대한 회원아이디, 회원이름, 주소1, 지역(서울, 부산...) */
-- 조회하기
SELECT mem_id, mem_name, mem_add1, udf_getarea(mem_add1) AS area
FROM member
WHERE mem_id = 'a001';


/* 저장프로시저 정의하기 */
-- 이름 : SP_getMemberView
CREATE OR REPLACE PROCEDURE SP_getMemberView
    -- 매개변수 및 리턴변수 정의
    (
        -- 받아오는 매개변수 정의
        -- IN 사용
        p_mem_id IN member.mem_id%TYPE, -- 멤버 테이블의 아이디 타입을 따라한다는 의미
        
        -- 결과를 리턴할 변수 정의
        -- OUT 사용 : 최종 결과값을 반환하겠다는 의미
        -- SYS_REFCURSOR 타입 : 조회 결과를 행/열 단위로 담고자 할 때 사용하는 타입
        rs_row OUT SYS_REFCURSOR
    )
IS
BEGIN
    -- < 처리 영역 >
    -- 전달받은 매개변수(회원아이디)에 대한 회원상세조회 후 
    -- 결과를 rs_row 변수에 담는 기능 수행
    
    -- OPEN rs_row FOR : 조회결과의 행 하나씩을 변수에 담기
    --    -> OPEN 명령을 통해 rs_row의 메모리 만들기
    --    -> FOR : SELECT의 행의 결과 갯수만큼 반복
    OPEN rs_row FOR
        SELECT mem_id, mem_name, mem_add1, udf_getarea(mem_add1) AS area
        FROM member
        WHERE mem_id = p_mem_id ;
END;
/


/* 프로시저 호출하기
 - 방법은 호출 시점의 프로그램에 따라 다름
    (Java, C, Python, 기타 Tool들 모두 다름)
    
 - SQL Developer 방식
 - 프로시저로부터 받아올 변수 정의
 - VARIABLE : 변수 선언
 - REFCURSOR : 행/열을 담을 수 있는 주소 개념의 타입
*/

VARIABLE rs_data REFCURSOR;

-- 프로시저 호출
-- EXECUTE : 실행 명령어(SQL 실행 시 사용)
EXECUTE SP_getMemberView('a001', :rs_data);

-- 조회결과 출력
PRINT rs_data;