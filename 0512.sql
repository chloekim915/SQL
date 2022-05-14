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