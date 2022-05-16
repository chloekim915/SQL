---------------------------- 시퀀스 (SEQUENCE) ----------------------------------

-- 시퀀스란?
-- - 자동 번호 발생기 역할로 사용자가 정해준 숫자로부터 일정 숫자가 자동으로 증감되는 객체
-- - 주사용처 : 사번, 주문번호, 게시판번호 등의 일련번호
-- - 응용 : 코드화 해서 활용됨 ex) 100xxxxxxx -> 전자제품  200xxxxxxx -> 식품


-- 문법
-- CREATE SEQUENCE '시퀀스 명'
-- [START WITH 숫자]        -- 처음 시작되는 숫자, default : 1
-- [INCREMENT BY 숫자]      -- 증감되는 수,       default : 1
-- [MAXVALUE 숫자 | NOMAXVALUE] -- 최대값 default : 10^27
-- [MINVALUE 숫자 | NOMINVALUE] -- 최소값 default : -10^28
-- [CYCLE | NOCYCLE] -- 값의 순환여부. NO CYCLE일 경우 MAX값 이후로 생성되지 않음 -> ERROR 발생 -- Default : NO CYCLE
-- [CACHE <byte 크기> | NOCACHE] -- 메모리 상에 시퀀스 값 관리 여부, default : 20

-- ※ 주의 : SEQUENCE는 최초 생성 이후 증감하지 않으면 사용할수 없음. NEXTVAL 명령 사용 필요

-- 사용법
-- '시퀀스명'.NEXTVAL : 증감되는 다음 값을 가져오는 명령어
-- '시퀀스명'.CURRVAL : 현재 값을 가져오는 명령어

DROP SEQUENCE SEQ_TEST1;
CREATE SEQUENCE SEQ_TEST1; -- 일반적으로 SEQ 같이 시퀀스 표식을 붙여서 사용;
SELECT SEQ_TEST1.NEXTVAL FROM DUAL; -- 증감 방법
SELECT SEQ_TEST1.CURRVAL FROM DUAL; -- 최초 1회 증감 이후에 조회가 가능하다.

-- 사용자가 생성한 시퀀스 조회법
SELECT * FROM user_sequences;

-- 시퀀스 응용
-- 300부터 시작해서 5씩 증가하고, 최대 310까 사용하고, NO CACHE, NO CYCLE
CREATE SEQUENCE SEQ_TEST2
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCACHE;

SELECT SEQ_TEST2.NEXTVAL FROM DUAL;
-- 310 초과하면 ERROR 발생
-- 최종적으로 증감된 시퀀스는 재사용 불가능!! -> DROP 이후 재사용필요.

-- 초기화 방법
-- 일반적인 초기화 문법 제공하지 않음. DROP -> CREATE 활용
DROP SEQUENCE SEQ_TEST2;
CREATE SEQUENCE SEQ_TEST2
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCACHE;

SELECT SEQ_TEST2.NEXTVAL FROM DUAL;

-- 시퀀스 삭제하는 방법
DROP SEQUENCE SEQ_TEST2;

-- 시퀀스 수정 방법
-- ALTER SEQUENCE SEQ_TEST1
--  <기본 시퀀스 옵션들>

-- 시퀀스 실사용 예시
DROP TABLE TBL_KH_USER;
CREATE TABLE TBL_KH_USER(
    USER_NO NUMBER PRIMARY KEY, -- 시퀀스 번호로 자동 사번 생성
    USER_ID VARCHAR2(30) NOT NULL UNIQUE,
    USER_NAME VARCHAR2(30) NOT NULL
);

DROP SEQUENCE SEQ_USER_NO;
-- CREATE SEQUENCE SEQ_USER_NO START WITH 10000;
CREATE SEQUENCE SEQ_USER_NO;

--SEQ_USER_NO.NEXTVAL; -- 숫자확인을 위해 DUAL 사용 권고
--SELECT SEQ_USER_NO.NEXTVAL FROM DUAL;

INSERT INTO TBL_KH_USER VALUES(SEQ_USER_NO.NEXTVAL, 'TEST1', '홍길동');
INSERT INTO TBL_KH_USER VALUES(SEQ_USER_NO.NEXTVAL, 'TEST2', '김길동');

SELECT * FROM TBL_KH_USER;

----------------------------------------------------------------------------------

--------------------------------INDEX --------------------------------------------

-- INDEX란? 
-- DB에서 데이터 검색의 성능향상을 위해 별도의 INDEX를 활성화 하여 빠르게 검색이 가능하도록 돕는 기능
-- 사전에 색인과 같이 File의 위치, Block의 위치와 같은 실제 물리주소를 저장하는 원리
-- 조회 할 시 Key 값으로 조회하는 경우 일반값을 조회하는 것보다 10배 이상 빠르게 탐색 가능 ★★★★★

-- INDEX 종류
-- 1. 고유 인덱스 (UNIQUE INDEX): 고유한 값으로만 이뤄진 INDEX, ※ PK 선언시 기본적으로 같이 선언됨(DEFAULT) ★★★★★ 
-- 2. 비고유 인덱스 (NOUNIQUE INDEX): 중복값을 허용하고, 일반적으로 사용자가 활용하는 인덱스 ★★★
-- 3. 단일 인덱스 (SINGLE INDEX): INDEX로만 구성된 테이블(한개의 컬럼) -> 순서를 기준으로 탐색할 때 활용
-- 4. 결합 인덱스 (COMPOSITE INDEX) : 두개 이상의 컬럼을 INDEX로 활용 할 때
-- 5. 함수기반 인덱스 (FUNCTION BASED INDEX): SELECT절이나 WHERE 절에 산술계산/ 함수식이 사용되는 경우 -> 날짜 이외에 활용 거의 없음

-- 인덱스 조회 방법
SELECT * FROM user_ind_columns;

-- 인덱스 ID 조회 ※ ROWID를 활용하면
SELECT ROWID, EMP_ID, EMP_NAME FROM employee;

-- 인덱스 생성하는 문법
-- CREATE [UNIQUE] INDEX '인덱스명' ON '테이블명' (컬럼명|함수명|함수 계산식);

-- 고유 인덱스 생성하기 (유니크한 값만 가능, PK)
CREATE UNIQUE INDEX IDX_EMP_NO ON EMPLOYEE(EMP_NO);
-- 유니크 하지 않은경우 생성되지 않음을 주의할것!

SELECT * FROM EMPLOYEE;
DELETE FROM EMPLOYEE WHERE EMP_ID = 231;
ROLLBACK;

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE';
SELECT * FROM EMPLOYEE WHERE EMP_NO = '861015-1356452';
-- 현재는 체감불가능하나 속도가 비약적으로 상승함.

-- 비고유 인덱스 생성 (값이 고유하지 않아도 생성가능, 일반적으로 활용됨)
CREATE INDEX IDX_DEPT_CODE ON EMPLOYEE(DEPT_CODE);
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

-- 결합 인덱스
CREATE INDEX IDX_NAME_PHONE ON EMPLOYEE(EMP_NAME, PHONE);
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '이%' AND PHONE LIKE '%5%';

-- 함수기반 인덱스 
CREATE INDEX IDX_SALARY ON EMPLOYEE( (SALARY +  SALARY * NVL(BONUS,0)) * 12); -- 연봉

SELECT EMP_NAME, ((SALARY + SALARY * NVL(BONUS,0)) * 12) as 연봉 FROM EMPLOYEE
WHERE ((SALARY +  SALARY * NVL(BONUS,0)) * 12) > 7000000;
-- ※ 주의 선언한 함수 그대로 활용해야한다.

-- 인덱스 재생성법
-- 사용 이유 : 주기적으로 최적화 할때 사용 --> DB 운영중에는 트리 최적화가 되지 않으므로 주기적 필요.
ALTER INDEX IDX_DEPT_CODE REBUILD;

-- 인덱스 삭제
DROP INDEX IDX_SALARY;

----------------------------------------------------------------------------------------------


-------------------------------- SYNONYM 동의어 -----------------------------------
-- 동의어란?
-- 사용자의 별칭, 별명으로 보통 줄임말로 사용할때 활용
-- 비공개 동의어 : 객체에 대한 별명을 사용자 개별적으로만 활용할때
-- 공개 동의어 : 객체에 대한 별명을 DB 사용자 모두 활용할때 ※ 주의 : 관리자 권한 필요

-- 시스템 계정으로 권한 부여 필요
GRANT CREATE SYNONYM TO KH;

-- 생성법
CREATE SYNONYM EMP FOR EMPLOYEE; 

-- 조회방법 
SELECT * FROM ALL_SYNONYMS WHERE TABLE_OWNER = 'KH';

-- 사용법
SELECT * FROM EMP;

-- 삭제 
DROP SYNONYM EMP;

--------------------------------------------------------------------------------