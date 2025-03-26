-- 한줄 주석 달기

/*
여러 행 주석 달기
행단위 주석
*/

/*
- system 계정은 절대 관리자 계정으로 관리자만 알고 있어야 함
- 개발이나 사용자들에게는 별도로 사용자 계정을 생성하여 제공
- Oracle 17 버전 이상부터는 최초에 한 번 아래 구문 실행
    > 아래 문구 실행하지 않으면 표준 SQL 구문 작성 시에 @ or #을 사용해야 함(불편함)
- Alter session set "_ORACLE_SCRIPT"=true;
*/
Alter session set "_ORACLE_SCRIPT"=true;

/* 
** 사용자 생성은 system 절대 관리자 계정으로 접속해야 생성이 가능함
*/

/* 사용자 객체 생성 */
-- 계정명 : busan
-- 패스워드 : dbdb
-- 생성(create), 사용자(USER), 패스워드(IDENTIFIED BY)
CREATE USER busan
IDENTIFIED BY dbdb;
    
/* 사용자 수정 */
-- 사용자 수정은 패스워드만 수정 가능
-- 객체 수정(ALTER), 사용자(USER)
ALTER USER busan
IDENTIFIED BY dbdb2;
    
/* 사용자 삭제하기 */
-- 객체삭제(DROP)
DROP USER busan;

/* 객체(사용자, 테이블, 등등) 컨트롤 문 */
-- 생성(CREATE), 수정(ALTER), 삭제(DROP)

/* 
<사용자 생성 순서>
1. CREATE를 통해 사용자  생성
2. 생성된 사용자에게 권한을 부여해야 DB접속 가능
*/

/* 생성된 사용자에게 권한 부여하기 */
-- 권한부여(GRANT)
-- 접속권한(CONNECT), 자원접근권한(RESOURCE),
-- 데이터베이스 관리자 권한(DBA)
GRANT CONNECT, RESOURCE, DBA TO busan;

/* 생성된 권한 회수(제거) 하기 */
-- 권환회수(REVOKE)
REVOKE CONNECT, RESOURCE, DBA FROM busan;