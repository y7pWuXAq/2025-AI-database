/*
당신이 근무하는 쇼핑몰 회사에 김은대 씨에게 문의가 왔습니다.
최근에 구매한 15인치 컴퓨터 1대가 고장으로 인한 제품 교환 요청입니다.
김은대 씨에게 제품을 교환해주기 전 상사에게 보고를 하기위한 서류를 작성해야 하는데
서류에는 회원이름, 전화번호, 주소, 회원아이디, 주문번호, 상품코드, 상품이름, 고객구매가가 필요합니다.
필요한 내용을 확인할 수 있게 정리해주세요.
단, 회원 전화번호는 핸드폰으로 선택
주소는 한 컬럼으로 정리
힌트 ROWNUM = N : 위에서부터 N개의 컬럼 추출할 수 있음 
*/

SELECT (SELECT mem_name FROM member WHERE mem_id = cart_member) AS 회원이름,
             (SELECT mem_hp FROM member WHERE mem_id = cart_member) AS 회원전화번호,
             (SELECT (mem_add1 || ' ' || mem_add2) FROM member WHERE mem_id = cart_member) AS 주소,
             (SELECT mem_id FROM member WHERE mem_id = cart_member) AS 회원아이디,
             cart_no AS 주문번호,
             cart_prod AS 상품코드,
             (SELECT prod_name FROM prod WHERE prod_id = cart_prod) AS 상품명,
             (SELECT prod_sale FROM prod WHERE prod_id = cart_prod) AS 판매가
  FROM cart
WHERE cart_member IN(SELECT mem_id FROM member WHERE mem_name = '김은대')
     AND cart_prod IN(SELECT prod_id FROM prod WHERE prod_name = '모니터 삼성전자15인치칼라')
     AND ROWNUM = 1
ORDER BY cart_no DESC;