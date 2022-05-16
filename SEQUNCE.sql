---------------------------- ������ (SEQUENCE) ----------------------------------

-- ��������?
-- - �ڵ� ��ȣ �߻��� ���ҷ� ����ڰ� ������ ���ڷκ��� ���� ���ڰ� �ڵ����� �����Ǵ� ��ü
-- - �ֻ��ó : ���, �ֹ���ȣ, �Խ��ǹ�ȣ ���� �Ϸù�ȣ
-- - ���� : �ڵ�ȭ �ؼ� Ȱ��� ex) 100xxxxxxx -> ������ǰ  200xxxxxxx -> ��ǰ


-- ����
-- CREATE SEQUENCE '������ ��'
-- [START WITH ����]        -- ó�� ���۵Ǵ� ����, default : 1
-- [INCREMENT BY ����]      -- �����Ǵ� ��,       default : 1
-- [MAXVALUE ���� | NOMAXVALUE] -- �ִ밪 default : 10^27
-- [MINVALUE ���� | NOMINVALUE] -- �ּҰ� default : -10^28
-- [CYCLE | NOCYCLE] -- ���� ��ȯ����. NO CYCLE�� ��� MAX�� ���ķ� �������� ���� -> ERROR �߻� -- Default : NO CYCLE
-- [CACHE <byte ũ��> | NOCACHE] -- �޸� �� ������ �� ���� ����, default : 20

-- �� ���� : SEQUENCE�� ���� ���� ���� �������� ������ ����Ҽ� ����. NEXTVAL ��� ��� �ʿ�

-- ����
-- '��������'.NEXTVAL : �����Ǵ� ���� ���� �������� ��ɾ�
-- '��������'.CURRVAL : ���� ���� �������� ��ɾ�

DROP SEQUENCE SEQ_TEST1;
CREATE SEQUENCE SEQ_TEST1; -- �Ϲ������� SEQ ���� ������ ǥ���� �ٿ��� ���;
SELECT SEQ_TEST1.NEXTVAL FROM DUAL; -- ���� ���
SELECT SEQ_TEST1.CURRVAL FROM DUAL; -- ���� 1ȸ ���� ���Ŀ� ��ȸ�� �����ϴ�.

-- ����ڰ� ������ ������ ��ȸ��
SELECT * FROM user_sequences;

-- ������ ����
-- 300���� �����ؼ� 5�� �����ϰ�, �ִ� 310�� ����ϰ�, NO CACHE, NO CYCLE
CREATE SEQUENCE SEQ_TEST2
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCACHE;

SELECT SEQ_TEST2.NEXTVAL FROM DUAL;
-- 310 �ʰ��ϸ� ERROR �߻�
-- ���������� ������ �������� ���� �Ұ���!! -> DROP ���� �����ʿ�.

-- �ʱ�ȭ ���
-- �Ϲ����� �ʱ�ȭ ���� �������� ����. DROP -> CREATE Ȱ��
DROP SEQUENCE SEQ_TEST2;
CREATE SEQUENCE SEQ_TEST2
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCACHE;

SELECT SEQ_TEST2.NEXTVAL FROM DUAL;

-- ������ �����ϴ� ���
DROP SEQUENCE SEQ_TEST2;

-- ������ ���� ���
-- ALTER SEQUENCE SEQ_TEST1
--  <�⺻ ������ �ɼǵ�>

-- ������ �ǻ�� ����
DROP TABLE TBL_KH_USER;
CREATE TABLE TBL_KH_USER(
    USER_NO NUMBER PRIMARY KEY, -- ������ ��ȣ�� �ڵ� ��� ����
    USER_ID VARCHAR2(30) NOT NULL UNIQUE,
    USER_NAME VARCHAR2(30) NOT NULL
);

DROP SEQUENCE SEQ_USER_NO;
-- CREATE SEQUENCE SEQ_USER_NO START WITH 10000;
CREATE SEQUENCE SEQ_USER_NO;

--SEQ_USER_NO.NEXTVAL; -- ����Ȯ���� ���� DUAL ��� �ǰ�
--SELECT SEQ_USER_NO.NEXTVAL FROM DUAL;

INSERT INTO TBL_KH_USER VALUES(SEQ_USER_NO.NEXTVAL, 'TEST1', 'ȫ�浿');
INSERT INTO TBL_KH_USER VALUES(SEQ_USER_NO.NEXTVAL, 'TEST2', '��浿');

SELECT * FROM TBL_KH_USER;

----------------------------------------------------------------------------------

--------------------------------INDEX --------------------------------------------

-- INDEX��? 
-- DB���� ������ �˻��� ��������� ���� ������ INDEX�� Ȱ��ȭ �Ͽ� ������ �˻��� �����ϵ��� ���� ���
-- ������ ���ΰ� ���� File�� ��ġ, Block�� ��ġ�� ���� ���� �����ּҸ� �����ϴ� ����
-- ��ȸ �� �� Key ������ ��ȸ�ϴ� ��� �Ϲݰ��� ��ȸ�ϴ� �ͺ��� 10�� �̻� ������ Ž�� ���� �ڡڡڡڡ�

-- INDEX ����
-- 1. ���� �ε��� (UNIQUE INDEX): ������ �����θ� �̷��� INDEX, �� PK ����� �⺻������ ���� �����(DEFAULT) �ڡڡڡڡ� 
-- 2. ����� �ε��� (NOUNIQUE INDEX): �ߺ����� ����ϰ�, �Ϲ������� ����ڰ� Ȱ���ϴ� �ε��� �ڡڡ�
-- 3. ���� �ε��� (SINGLE INDEX): INDEX�θ� ������ ���̺�(�Ѱ��� �÷�) -> ������ �������� Ž���� �� Ȱ��
-- 4. ���� �ε��� (COMPOSITE INDEX) : �ΰ� �̻��� �÷��� INDEX�� Ȱ�� �� ��
-- 5. �Լ���� �ε��� (FUNCTION BASED INDEX): SELECT���̳� WHERE ���� ������/ �Լ����� ���Ǵ� ��� -> ��¥ �̿ܿ� Ȱ�� ���� ����

-- �ε��� ��ȸ ���
SELECT * FROM user_ind_columns;

-- �ε��� ID ��ȸ �� ROWID�� Ȱ���ϸ�
SELECT ROWID, EMP_ID, EMP_NAME FROM employee;

-- �ε��� �����ϴ� ����
-- CREATE [UNIQUE] INDEX '�ε�����' ON '���̺��' (�÷���|�Լ���|�Լ� ����);

-- ���� �ε��� �����ϱ� (����ũ�� ���� ����, PK)
CREATE UNIQUE INDEX IDX_EMP_NO ON EMPLOYEE(EMP_NO);
-- ����ũ ���� ������� �������� ������ �����Ұ�!

SELECT * FROM EMPLOYEE;
DELETE FROM EMPLOYEE WHERE EMP_ID = 231;
ROLLBACK;

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE';
SELECT * FROM EMPLOYEE WHERE EMP_NO = '861015-1356452';
-- ����� ü���Ұ����ϳ� �ӵ��� ��������� �����.

-- ����� �ε��� ���� (���� �������� �ʾƵ� ��������, �Ϲ������� Ȱ���)
CREATE INDEX IDX_DEPT_CODE ON EMPLOYEE(DEPT_CODE);
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

-- ���� �ε���
CREATE INDEX IDX_NAME_PHONE ON EMPLOYEE(EMP_NAME, PHONE);
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '��%' AND PHONE LIKE '%5%';

-- �Լ���� �ε��� 
CREATE INDEX IDX_SALARY ON EMPLOYEE( (SALARY +  SALARY * NVL(BONUS,0)) * 12); -- ����

SELECT EMP_NAME, ((SALARY + SALARY * NVL(BONUS,0)) * 12) as ���� FROM EMPLOYEE
WHERE ((SALARY +  SALARY * NVL(BONUS,0)) * 12) > 7000000;
-- �� ���� ������ �Լ� �״�� Ȱ���ؾ��Ѵ�.

-- �ε��� �������
-- ��� ���� : �ֱ������� ����ȭ �Ҷ� ��� --> DB ��߿��� Ʈ�� ����ȭ�� ���� �����Ƿ� �ֱ��� �ʿ�.
ALTER INDEX IDX_DEPT_CODE REBUILD;

-- �ε��� ����
DROP INDEX IDX_SALARY;

----------------------------------------------------------------------------------------------


-------------------------------- SYNONYM ���Ǿ� -----------------------------------
-- ���Ǿ��?
-- ������� ��Ī, �������� ���� ���Ӹ��� ����Ҷ� Ȱ��
-- ����� ���Ǿ� : ��ü�� ���� ������ ����� ���������θ� Ȱ���Ҷ�
-- ���� ���Ǿ� : ��ü�� ���� ������ DB ����� ��� Ȱ���Ҷ� �� ���� : ������ ���� �ʿ�

-- �ý��� �������� ���� �ο� �ʿ�
GRANT CREATE SYNONYM TO KH;

-- ������
CREATE SYNONYM EMP FOR EMPLOYEE; 

-- ��ȸ��� 
SELECT * FROM ALL_SYNONYMS WHERE TABLE_OWNER = 'KH';

-- ����
SELECT * FROM EMP;

-- ���� 
DROP SYNONYM EMP;

--------------------------------------------------------------------------------