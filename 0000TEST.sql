-- �������� ����(�߰�)�ϱ� (NOT NULL)
ALTER TABLE tbl_alter_test MODIFY user_name CONSTRAINT not_null_user_name NOT NULL; --�ڿ��� �������
-- �̹� NULL ������ NULL ������� �� �� ����

-- NULL�� �ִ� �÷��� NOT NULL ���� �����ϱ� - �ȵ�
ALTER TABLE tbl_alter_test MODIFY user_pw CONSTRAINT user_pw NOT NULL;

-- ���̺� ��ȸ�ϴ� ��ɾ�
DESC tbl_alter_test;

-- ���� Ȯ���ϴ� ��
SELECT * FROM user_constraints;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_ALTER_TEST';

-- DROP ��ɾ�
--  - TABLE, ���� ���׵� ����Ŭ�� ��ü�� �����ϴ� ���
DROP TABLE TBL_ALTER_TEST;

-- ���� ������ �ִ� ��� : CASCADE CONSTRAINT�� ��� 
DROP TABLE TBL_ALTER_TEST CASCADE CONSTRAINTS;
