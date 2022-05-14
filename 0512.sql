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