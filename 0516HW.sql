-- 1. 70년대  생(1970~1979)  중  여자이면서  전씨인  사원의  이름과  주민번호,  부서  명,  직급  조회
SELECT emp_name, emp_no, d.dept_title, j.job_name
FROM employee e, department d, job j
WHERE e.dept_code=d.dept_id AND e.job_code=j.job_code
AND (SUBSTR(e.emp_no,1,2) BETWEEN 70 AND 79)
AND SUBSTR(e.emp_no,8,1) = 2
AND emp_name LIKE '전%';

SELECT emp_name, emp_no, dept_title, job_name
FROM employee
JOIN department ON (dept_code=dept_id)
JOIN job USING (job_code)
WHERE(SUBSTR(emp_no, 1, 2) BETWEEN 70 AND 79)
        AND SUBSTR(emp_no, 8, 1) = 2
        AND emp_name LIKE '전%';

-- 2.  나이  상  가장  막내의  사원  코드,  사원  명,  나이,  부서  명,  직급  명  조회 
SELECT emp_id, emp_name, 
((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) AS 나이,dept_title, job_name
FROM employee E, department D, JOB J
WHERE e.dept_code = d.dept_id AND e.job_code = j.job_code
AND ((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no, 1, 2),'RR')))) FROM employee);

SELECT emp_id, emp_name,
((EXTRACT(YEAR FROM SYSDATE))-(EXTRACT(YEAR FROM(TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) AS 나이, dept_title, job_name
FROM employee
JOIN department ON(dept_id=dept_code)
JOIN job USING(job_code)
WHERE ((EXTRACT(YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no,1,2),'RR'))))) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(emp_no, 1, 2),'RR')))) FROM employee);

-- 3.  이름에  ‘형’이  들어가는  사원의  사원  코드,  사원  명,  직급  조회
SELECT emp_id, emp_name, j.job_name
FROM employee e, job j
WHERE e.job_code=j.job_code
AND emp_name LIKE '%형%';

SELECT emp_id, emp_name, job_name
FROM employee
JOIN job USING(job_code)
WHERE emp_name LIKE '%형%';

-- 4.  부서코드가  D5이거나  D6인  사원의  사원  명,  직급  명,  부서  코드,  부서  명  조회
SELECT emp_name,job_name, dept_code, dept_title
FROM employee
JOIN job USING(job_code)
JOIN department ON (dept_code=dept_id)
WHERE dept_code IN ('D5','D6');

-- 5.  보너스를  받는  사원의  사원  명,  부서  명,  지역  명  조회
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

-- 6.  사원  명,  직급  명,  부서  명,  지역  명  조회
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
-- 7.  한국이나  일본에서  근무  중인  사원의  사원  명,  부서  명,  지역  명,  국가  명  조회
SELECT e.emp_name, d.dept_title, l.local_name, n.national_name
FROM employee e,department d, location l, national n
WHERE e.dept_code = d.dept_id
AND d.location_id = l.local_code
AND n.national_code = l.national_code
AND n.national_name IN('한국', '일본');

SELECT emp_name, DEPT_TITLE, NATIONAL_CODE, NATIONAL_NAME
FROM employee
JOIN department ON (dept_code = dept_id)
JOIN job USING(job_code)
JOIN location ON(location_id = local_code)
JOIN national USING(national_code)
WHERE national_name IN ('한국', '일본');

-- 8.  한  사원과  같은  부서에서  일하는  사원의  이름  조회
SELECT e.emp_name, e.dept_code, m.emp_name
FROM employee e, employee m
WHERE e.dept_code=m.dept_code
AND e.emp_name != m.emp_ame
ORDER BY 1;

-- 9.  보너스가  없고  직급  코드가  J4이거나  J7인  사원의  이름,  직급  명,  급여  조회(NVL  이용) 
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

-- 10.  보너스  포함한  연봉이  높은  5명의  사번,  이름,  부서  명,  직급,  입사일,  순위  조회
SELECT *
FROM (
SELECT e.emp_id, e.emp_name, d.dept_title, j.job_name,e.hire_date, 
RANK() OVER(ORDER BY((SALARY + (SALARY * NVL(BONUS,0))) * 12)DESC)as 순위
FROM employee e, department d, job j
WHERE e.dept_code=d.dept_id
AND e.job_code=j.job_code)
WHERE 순위 BETWEEN 1 AND 5;

SELECT *
FROM (SELECT emp_id, emp_name, dept_title, job_name, hire_date, salary,(salary + (salary * NVL(bonus,0))) * 12 AS 연봉,
      RANK() OVER(ORDER BY ((salary + (salary * NVL(bonus, 0))) * 12) DESC) 순위
      FROM employee e
      JOIN department d ON (e.dept_code = d.dept_id)
      JOIN job j ON (e.job_code = j.job_code))
WHERE 순위 BETWEEN 1 AND 5;

-- 11.  부서  별  급여  합계가  전체  급여  총  합의  20%보다  많은  부서의  부서  명,  부서  별  급여  합계  조회
-- 1) JOIN과 HAVING 사용
SELECT dept_title, SUM(salary)
FROM employee
JOIN department ON (dept_code=dept_id)
GROUP BY dept_title
HAVING SUM(salary) > (SELECT SUM(salary)*0.2 FROM employee);

-- 2) 인라인 뷰 사용
SELECT *
FROM (
SELECT d.dept_title, SUM(e.salary) as "부서별 급여합"
FROM employee e, department d
WHERE e.dept_code=d.dept_id
GROUP BY d.dept_title)
WHERE "부서별 급여합" > (SELECT SUM(salary)*0.2 FROM employee);

-- 3) WITH 사용
WITH TOTAL_SAL_DEPT AS (
    SELECT dept_title, SUM(salary) AS "부서별 급여합"
    FROM employee
        JOIN department ON (dept_code = dept_id)
    GROUP BY dept_title)
SELECT *
FROM TOTAL_SAL_DEPT
WHERE "부서별 급여합" > (SELECT SUM(SALARY) * 0.2 FROM employee);

-- 12.  부서  명과  부서  별  급여  합계  조회
SELECT dept_title, SUM(salary)
FROM employee 
JOIN department ON(dept_code = dept_id)
GROUP BY dept_title;

-- 13. WITH를  이용하여  급여  합과  급여  평균  조회
WITH SUM_AVG_SAL AS (SELECT SUM(salary), AVG(salary) FROM employee)
SELECT * FROM SUM_AVG_SAL;
