/*
    0808 (����)
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
    WHERE employee_id = employee_id; -- ORA-01422: ���� ������ �䱸�� �ͺ��� ���� ���� ���� �����մϴ�
    -- ������ ��ġ�� �÷� �̸��� �켱���� ��
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
1. departments ���̺��� �ִ� �μ� ID�� �����Ͽ� max_deptno ������ �����ϴ�
PL/SQL ����� �����մϴ�. �ִ� �μ� ID�� ǥ���մϴ�.
    a. ���� ���ǿ��� NUMBER ������ max_deptno ������ �����մϴ�.
    b. BEGIN Ű����� ���� ������ �����ϰ� departments ���̺��� �ִ�
    department_id�� �˻��ϴ� SELECT ���� ���Խ�ŵ�ϴ�.
    c. max_deptno�� ǥ���ϰ� ���� ����� �����մϴ�.
    d. ��ũ��Ʈ�� �����ϰ� lab_04_01_soln.sql�� �����մϴ�. ������ ���
    ����� ������ �����ϴ�.
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
    2. ���� 1���� ������ PL/SQL ����� departments ���̺� �� �μ��� �����ϵ���
    �����մϴ�.
    a. ��ũ��Ʈ lab_04_01_soln.sql�� ���ϴ�.
    departments.department_name ������ dept_name �� NUMBER
    ������ dept_id��� �� ���� ������ �����մϴ�. ���� ���ǿ��� dept_name��
    "Education"�� �Ҵ��մϴ�.
    b. �տ��� �̹� departments ���̺��� ���� �ִ� �μ� ��ȣ�� �˻��߽��ϴ�.
    �� �μ� ��ȣ�� 10�� ���Ͽ� �ش� ����� dept_id�� �Ҵ��մϴ�.
    c. departments ���̺��� department_name, department_id ��
    location_id ���� �����͸� �����ϴ� INSERT ���� ���Խ�ŵ�ϴ�.
    department_name, department_id���� dept_name, dept_id�� ����
    ����ϰ� location_id���� NULL�� ����մϴ�.
    d. SQL �Ӽ� SQL%ROWCOUNT�� ����Ͽ� ����Ǵ� �� ���� ǥ���մϴ�.
    e. select ���� �����Ͽ� �� �μ��� ���ԵǾ����� Ȯ���մϴ�. "/"�� PL/SQL �����
    �����ϰ� ��ũ��Ʈ�� SELECT ���� ���Խ�ŵ�ϴ�.
    f. ��ũ��Ʈ�� �����ϰ� lab_04_02_soln.sql�� �����մϴ�. ������ ��� �����
    ������ �����ϴ�.
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
