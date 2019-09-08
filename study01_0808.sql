/*
    0808 (오전)
*/
SET SERVEROUTPUT ON
DECLARE
    sum_sal NUMBER(10,2);
    deptno NUMBER NOT NULL := 60;
BEGIN
    SELECT SUM(salary) -- group function
    INTO sum_sal FROM employees
    WHERE department_id = deptno;
        DBMS_OUTPUT.PUT_LINE ('The sum of salary is '
        || sum_sal);
END;
/

DECLARE
    hire_date employees.hire_date%TYPE;
    sysdate hire_date%TYPE;
    employee_id employees.employee_id%TYPE := 176;
BEGIN
    SELECT hire_date, sysdate
    INTO hire_date, sysdate
    FROM employees
    WHERE employee_id = employee_id; -- ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
    -- 변수와 겹치면 컬럼 이름을 우선으로 함
END;
/

CREATE TABLE COPY_EMP AS
SELECT * FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (
100,
101,
102,
103,
104,
105,
106,
107,
108,
109,
110,
111,
112,
113,
114,
115,
116,
117,
118,
119,
145,
146,
147,
148,
149,
150,
151,
152,
153,
154,
155,
156,
157,
158,
159,
160,
161,
162,
163,
164,
165,
166,
167,
168,
169,
170,
171,
172,
173,
174,
175,
176,
177,
178,
179,
200,
201,
202,
203,
204,
205,
206);

update copy_emp
set salary = 0;

commit;

select * from employees;
select * from copy_emp;
DECLARE
emp_id employees.employee_id%TYPE := 100;
BEGIN
MERGE INTO copy_emp c
USING employees e
ON (e.employee_id = c.employee_id)
WHEN MATCHED THEN
UPDATE SET
c.first_name = e.first_name,
c.last_name = e.last_name,
c.email = e.email,
c.phone_number = e.phone_number,
c.hire_date = e.hire_date,
c.job_id = e.job_id,
c.salary = e.salary,
c.commission_pct = e.commission_pct,
c.manager_id = e.manager_id,
c.department_id = e.department_id
WHEN NOT MATCHED THEN
INSERT VALUES(e.employee_id, e.first_name, e.last_name,
e.email, e.phone_number, e.hire_date, e.job_id,
e.salary, e.commission_pct, e.manager_id,
e.department_id, e.department_name);
END;
/
select * from copy_emp;
commit;

VARIABLE rows_deleted VARCHAR2(30)
DECLARE
    empno copy_emp.employee_id%TYPE := 176;
BEGIN
    DELETE FROM copy_emp
    WHERE employee_id = empno;
    :rows_deleted := (SQL%ROWCOUNT ||
    ' row deleted.');
END;
/
PRINT rows_deleted
rollback;

/*
1. departments 테이블에서 최대 부서 ID를 선택하여 max_deptno 변수에 저장하는
PL/SQL 블록을 생성합니다. 최대 부서 ID를 표시합니다.
    a. 선언 섹션에서 NUMBER 유형의 max_deptno 변수를 선언합니다.
    b. BEGIN 키워드로 실행 섹션을 시작하고 departments 테이블에서 최대
    department_id를 검색하는 SELECT 문을 포함시킵니다.
    c. max_deptno를 표시하고 실행 블록을 종료합니다.
    d. 스크립트를 실행하고 lab_04_01_soln.sql로 저장합니다. 예제의 출력
    결과는 다음과 같습니다.
*/
select * from departments;
declare
    max_deptno number;
begin
    select max(department_id) 
    into max_deptno
    from departments;
    dbms_output.put_line(max_deptno);
end;
/
/*
    2. 연습 1에서 생성한 PL/SQL 블록을 departments 테이블에 새 부서를 삽입하도록
    수정합니다.
    a. 스크립트 lab_04_01_soln.sql을 엽니다.
    departments.department_name 유형의 dept_name 및 NUMBER
    유형의 dept_id라는 두 개의 변수를 선언합니다. 선언 섹션에서 dept_name에
    "Education"을 할당합니다.
    b. 앞에서 이미 departments 테이블에서 현재 최대 부서 번호를 검색했습니다.
    이 부서 번호에 10을 더하여 해당 결과를 dept_id에 할당합니다.
    c. departments 테이블의 department_name, department_id 및
    location_id 열에 데이터를 삽입하는 INSERT 문을 포함시킵니다.
    department_name, department_id에는 dept_name, dept_id의 값을
    사용하고 location_id에는 NULL을 사용합니다.
    d. SQL 속성 SQL%ROWCOUNT를 사용하여 적용되는 행 수를 표시합니다.
    e. select 문을 실행하여 새 부서가 삽입되었는지 확인합니다. "/"로 PL/SQL 블록을
    종료하고 스크립트에 SELECT 문을 포함시킵니다.
    f. 스크립트를 실행하고 lab_04_02_soln.sql로 저장합니다. 예제의 출력 결과는
    다음과 같습니다.
*/
VARIABLE rows_inserted VARCHAR2(30)
declare
    max_deptno number;
    dept_name departments.department_name%TYPE := 'Education';
    dept_id number;

begin
    select max(department_id) + 10
    into max_deptno
    from departments;
    dbms_output.put_line(max_deptno);
    
    insert into departments(department_id, department_name, location_id)
    values(max_deptno, 'test', null);
    :rows_inserted := (SQL%ROWCOUNT ||
        ' row inserted.');
end;
/
select * from departments;
PRINT rows_inserted;
