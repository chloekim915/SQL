-- 제약조건 수정(추가)하기 (NOT NULL)
ALTER TABLE tbl_alter_test MODIFY user_name CONSTRAINT not_null_user_name NOT NULL; --뒤에가 제약사항
-- 이미 NULL 있으면 NULL 제약사항 걸 수 없음

-- NULL이 있는 컬럼을 NOT NULL 제약 변경하기 - 안됨
ALTER TABLE tbl_alter_test MODIFY user_pw CONSTRAINT user_pw NOT NULL;

-- 테이블 조회하는 명령어
DESC tbl_alter_test;

-- 제약 확인하는 법
SELECT * FROM user_constraints;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_ALTER_TEST';

-- DROP 명령어
--  - TABLE, 제약 사항등 오라클의 객체를 삭제하는 명령
DROP TABLE TBL_ALTER_TEST;

-- 제약 조건이 있는 경우 : CASCADE CONSTRAINT를 사용 
DROP TABLE TBL_ALTER_TEST CASCADE CONSTRAINTS;
