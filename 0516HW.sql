-- 1. 70���  ��(1970~1979)  ��  �����̸鼭  ������  �����  �̸���  �ֹι�ȣ,  �μ�  ��,  ����  ��ȸ
SELECT emp_name, emp_no, d.dept_title, j.job_name
FROM employee e, department d, job j
WHERE e.dept_code=d.dept_id AND e.job_code=j.job_code
AND (SUBSTR(e.emp_no,1,2) BETWEEN 70 AND 79)
AND SUBSTR(e.emp_no,8,1) = 2
AND emp_name LIKE '��%';

SELECT emp_name, emp_no, dept_title, job_name
FROM employee
JOIN department ON (dept_code=dept_id)
JOIN job USING (job_code)
WHERE(SUBSTR(emp_no, 1, 2) BETWEEN 70 AND 79)
        AND SUBSTR(emp_no, 8, 1) = 2
        AND emp_name LIKE '��%';

-- 2.  ����  ��  ����  ������  ���  �ڵ�,  ���  ��,  ����,  �μ�  ��,  ����  ��  ��ȸ 
SELECT emp_id, emp_name, 
((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) AS ����,dept_title, job_name
FROM employee E, department D, JOB J
WHERE e.dept_code = d.dept_id AND e.job_code = j.job_code
AND ((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no, 1, 2),'RR')))) FROM employee);

SELECT emp_id, emp_name,
((EXTRACT(YEAR FROM SYSDATE))-(EXTRACT(YEAR FROM(TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) AS ����, dept_title, job_name
FROM employee
JOIN department ON(dept_id=dept_code)
JOIN job USING(job_code)
WHERE ((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no, 1, 2),'RR')))) FROM employee);

-- 3.  �̸���  ��������  ����  �����  ���  �ڵ�,  ���  ��,  ����  ��ȸ
SELECT emp_id, emp_name, j.job_name
FROM employee e, job j
WHERE e.job_code=j.job_code
AND emp_name LIKE '%��%';

SELECT emp_id, emp_name, job_name
FROM employee
JOIN job USING(job_code)
WHERE emp_name LIKE '%��%';

-- 4.  �μ��ڵ尡  D5�̰ų�  D6��  �����  ���  ��,  ����  ��,  �μ�  �ڵ�,  �μ�  ��  ��ȸ
SELECT emp_name,job_name, dept_code, dept_title
FROM employee
JOIN job USING(job_code)
JOIN department ON (dept_code=dept_id)
WHERE dept_code IN ('D5','D6');

-- 5.  ���ʽ���  �޴�  �����  ���  ��,  �μ�  ��,  ����  ��  ��ȸ
SELECT e.emp_name, d.dept_title, l.local_name
FROM employee e, department d, location l
WHERE e.dept_code=d.dept_id
AND d.location_id=l.local_code
AND e.bonus IS NOT NULL;

SELECT emp_name, dept_title, local_name
FROM employee
JOIN department ON(dept_code=dept_id)
JOIN location ON (local_code = location_id)
JOIN national USING (national_code)
WHERE bonus IS NOT NULL; 

-- 6.  ���  ��,  ����  ��,  �μ�  ��,  ����  ��  ��ȸ
SELECT e.emp_name,d.dept_title,l.local_name
FROM employee e, department d, location l
WHERE e.dept_code=d.dept_id
AND d.location_id=l.local_code;

SELECT emp_name, job_name, dept_title, national_name
FROM employee
JOIN department ON (dept_id = dept_code)
JOIN job USING (job_code)
JOIN location ON (local_code = location_id)
JOIN national USING (national_code);
-- 7.  �ѱ��̳�  �Ϻ�����  �ٹ�  ����  �����  ���  ��,  �μ�  ��,  ����  ��,  ����  ��  ��ȸ
SELECT e.emp_name, d.dept_title, l.local_name, n.national_name
FROM employee e,department d, location l, national n
WHERE e.dept_code = d.dept_id
AND d.location_id = l.local_code
AND n.national_code = l.national_code
AND n.national_name IN('�ѱ�', '�Ϻ�');

SELECT emp_name, DEPT_TITLE, NATIONAL_CODE, NATIONAL_NAME
FROM employee
JOIN department ON (dept_code = dept_id)
JOIN job USING(job_code)
JOIN location ON(location_id = local_code)
JOIN national USING(national_code)
WHERE national_name IN ('�ѱ�', '�Ϻ�');

-- 8.  ��  �����  ����  �μ�����  ���ϴ�  �����  �̸�  ��ȸ
SELECT e.emp_name, e.dept_code, m.emp_name
FROM employee e, employee m
WHERE e.dept_code=m.dept_code
AND e.emp_name != m.emp_ame
ORDER BY 1;

-- 9.  ���ʽ���  ����  ����  �ڵ尡  J4�̰ų�  J7��  �����  �̸�,  ����  ��,  �޿�  ��ȸ(NVL  �̿�) 
SELECT e.emp_name,j.job_name, salary
FROM employee e, job j
WHERE e.job_code=j.job_code
AND e.job_code IN ('J4','J7')
AND NVL(e.bonus,0)=0;

SELECT emp_name, job_name, salary
FROM employee
JOIN job USING(job_code)
WHERE NVL(bonus,0)=0
AND job_code IN ('J4', 'J7');

-- 10.  ���ʽ�  ������  ������  ����  5����  ���,  �̸�,  �μ�  ��,  ����,  �Ի���,  ����  ��ȸ
SELECT *
FROM (
SELECT e.emp_id, e.emp_name, d.dept_title, j.job_name,e.hire_date, 
RANK() OVER(ORDER BY((SALARY + (SALARY * NVL(BONUS,0))) * 12)DESC)as ����
FROM employee e, department d, job j
WHERE e.dept_code=d.dept_id
AND e.job_code=j.job_code)
WHERE ���� BETWEEN 1 AND 5;

SELECT *
FROM (SELECT emp_id, emp_name, dept_title, job_name, hire_date, salary,(salary + (salary * NVL(bonus,0))) * 12 AS ����,
      RANK() OVER(ORDER BY ((salary + (salary * NVL(bonus, 0))) * 12) DESC) ����
      FROM employee e
      JOIN department d ON (e.dept_code = d.dept_id)
      JOIN job j ON (e.job_code = j.job_code))
WHERE ���� BETWEEN 1 AND 5;

-- 11.  �μ�  ��  �޿�  �հ谡  ��ü  �޿�  ��  ����  20%����  ����  �μ���  �μ�  ��,  �μ�  ��  �޿�  �հ�  ��ȸ
-- 1) JOIN�� HAVING ���
SELECT dept_title, SUM(salary)
FROM employee
JOIN department ON (dept_code=dept_id)
GROUP BY dept_title
HAVING SUM(salary) > (SELECT SUM(salary)*0.2 FROM employee);

-- 2) �ζ��� �� ���
SELECT *
FROM (
SELECT d.dept_title, SUM(e.salary) as "�μ��� �޿���"
FROM employee e, department d
WHERE e.dept_code=d.dept_id
GROUP BY d.dept_title)
WHERE "�μ��� �޿���" > (SELECT SUM(salary)*0.2 FROM employee);

-- 3) WITH ���
WITH TOTAL_SAL_DEPT AS (
    SELECT dept_title, SUM(salary) AS "�μ��� �޿���"
    FROM employee
        JOIN department ON (dept_code = dept_id)
    GROUP BY dept_title)
SELECT *
FROM TOTAL_SAL_DEPT
WHERE "�μ��� �޿���" > (SELECT SUM(SALARY) * 0.2 FROM employee);

-- 12.  �μ�  ���  �μ�  ��  �޿�  �հ�  ��ȸ
SELECT dept_title, SUM(salary)
FROM employee 
JOIN department ON(dept_code = dept_id)
GROUP BY dept_title;

-- 13. WITH��  �̿��Ͽ�  �޿�  �հ�  �޿�  ���  ��ȸ
WITH SUM_AVG_SAL AS (SELECT SUM(salary), AVG(salary) FROM employee)
SELECT * FROM SUM_AVG_SAL;
