/*
    0708 Join
    
    pre-to-do
        employees �ǽ� �ڷ� ����
        sqlplus: @hr_edit_main
*/

select * from employees;
select emp_id, emp_name, dept_code from temp order by 3;

select dept_code, dept_name from tdept order by 1;
--equijoin (=����)
select temp.emp_id, temp.emp_name, temp.dept_code, tdept.dept_code, tdept.dept_name from temp, tdept where emp_id = 19970101 and temp.dept_code = tdept.dept_code;
--non-equijoin (��Ÿ �ٸ�����)
select temp.emp_id, temp.emp_name, temp.dept_code, tdept.dept_code, tdept.dept_name from temp, tdept where emp_id = 19970101 and temp.dept_code < tdept.dept_code;

select distinct dept_code from tdept; -- 10��
select dept_code from tdept order by 1;

-- �Ʒ� �� ���� distinct������ ���� ���� �ʴ�
-- �׷�, join�ÿ� ���� �޶� ���ʿ� ���� �͵���?
select emp_id from temp;
select distinct boss_id from tdept order by 1;

-- inner join (���ʿ� ���� �� ������, default)
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id = tdept.boss_id order by 1;
-- outter join (�ݴ��ʿ� ��� null�� ǥ��), (+)�� ��ĥ ��� ���´�
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id = tdept.boss_id(+) order by 1;
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id(+) = tdept.boss_id order by 1;

-- self join 
select a.emp_id, a.emp_name, b.emp_id, b.emp_name from temp a, temp b where a.emp_id = b.emp_id;

-- equijoin (�μ��ڵ� �ȵ� ������ �ȳ��´�.)
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id
    order by 1;   
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id
    and e.last_name = 'King' -- King�� last_name���� ���� ������ ǥ��
    order by 1;

-- 3���̺� �̻��� equijoin: ���̺� �� - 1����ŭ�� ���� �ʿ�
desc locations;
desc departments;
select e.employee_id, e.last_name, e.department_id, d.department_id, d.location_id, l.city
    from employees e, departments d, locations l
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    order by 1;

/*
salarygrade �ٲ㼭 �����ٰ� Ÿ�Ծȸ¾Ƽ� �� ��������...����
alter table salarygrade rename column grade to grade_level;
alter table salarygrade rename column losal to lowest_sal;
alter table salarygrade rename column hisal to highst_sal;
alter table salarygrade rename to job_grades;
truncate table job_grades;
drop table job_grades;


CREATE TABLE JOB_GRADES(
   GRADE_LEVEL VARCHAR2(10) NOT NULL PRIMARY KEY,
   LOWEST_SAL NUMBER,
   HIGHEST_SAL NUMBER
   );

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('A',1000,2999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('B',3000,5999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('C',6000,9999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('D',10000,14999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('E',15000,24999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('F',25000,40000);
*/

-- non-equijoin
select e.last_name, e.salary, j.grade
    from employees e, jobs j
    where 
;

-- outter join 
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id(+) -- (�μ� ���� ���� ǥ��)
    order by 1; 
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id -- (���� ���� �μ� ǥ��)
    order by 1; 

--self join(�ϳ��� ���̺��� �� �� ó��, ��Ī ��� �ʼ�)
select e.employee_id, m.employee_id
    from employees e, employees m
    where e.manager_id = m.employee_id
    order by 1;

-- ANSI join senteces
-- cross join
select count(*) from employees cross join departments;
select count(*) from employees; --107
select count(*) from departments; --27
-- cross join --2889 = 107 * 27, join������ ���� ��� ��� ����� �� �� ��Ÿ��
select count(*) from employees cross join departments; 

-- natural join (natural ��������): �÷���+������Ÿ�� ���� �÷� ã�� join (�ϳ��� ���� ���), equi����
select last_name, department_name from employees natural join departments;
-- using�� (���� �� �÷� ���� ��� ��� �ʿ�, natural �Ⱥٿ���)
select last_name, department_name from employees join departments using (department_id);
-- on�� (���� Ư���� �÷��� ������ �÷� �̸��� �ٸ� ��� ��� �ʿ�)
select e.last_name, d.department_name from employees e join departments d on (e.department_id = d.department_id);
select e.last_name ,d.department_name, l.city
    from employees e 
    join departments d 
    on (e.department_id = d.department_id)
    join locations l
    on (d.location_id = l.location_id);

-- outer join
-- left outer join(�μ� ���� ���� ǥ��)
select e.last_name, e.department_id, d.department_name from employees e left outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id(+);
-- right outer (���� ���� �μ� ǥ��)
select e.last_name, e.department_id, d.department_name from employees e right outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id;
-- full outer join (�Ѵ�)
select e.last_name, e.department_id, d.department_name from employees e full outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id(+); -- ERR - ORA-01468: outer-join�� ���̺��� 1���� ������ �� �ֽ��ϴ�(ANSIǥ�ؿ����� ������ ���)

-- �ǽ�: 10000��¥�� ���ε� ���̺��� ������
select count(*) from temp cross join user_tables cross join test17;
select count(*) from temp, user_tables, test17;
create table t1_data as select rownum as NO from temp cross join user_tables cross join test17 where rownum <= 10000;
select * from t1_data;

-- �ǽ��� ���̺� ����
create table tcom (
    work_year varchar2(04) not null,
    emp_id number not null,
    bonus_rate number,
    comm number,
    constraint com_pk primary key (work_year, emp_id)
);
insert into tcom
select '2018', EMP_ID, 1, salary * 0.01
from temp
where dept_code like 'C%';
commit;

--���ο� �ǽ����̺� ����
create table emp_level (
    lev varchar2(10) primary key,
    from_sal number,
    to_sal number,
    from_age number,
    to_age number
);
INSERT INTO EMP_LEVEL VALUES ('���',30000000,50000000,20,27);
INSERT INTO EMP_LEVEL VALUES ('�븮',40000000,60000000,23,33);
INSERT INTO EMP_LEVEL VALUES ('����',50000000,75000000,29,36);
INSERT INTO EMP_LEVEL VALUES ('����',60000000,80000000,33,44);
INSERT INTO EMP_LEVEL VALUES ('����',70000000,100000000,37,55);
INSERT INTO EMP_LEVEL VALUES ('�ӿ�',100000000,300000000,20,88);
commit;

/*
����
1. TEMP�� TDEPT �� �μ��ڵ�� �����Ͽ� ���,����,�μ��ڵ�,�μ��� �������� 
   ��, SALARY�� 9õ���� ���� ū ������ ���ؼ�
2. 2019�⿡ Ŀ�̼��� �޴� ������ ���,����,�μ��ڵ�,�μ���, Ŀ�̼� ��������   
3. TEMP���� �ڹ������� �޿��� ���Թ޴� ���� �˻�
4. EMP_LEVEL ���� �޿� �������� ���ϰ� TEMP ��� �� �ڱ� ������ ������(���Ѱ� ���� ���) ���� �޿��� ���� ���� ��������
5. TEMP ,TCOM�� EMP_ID�� �����Ͽ� ��� ������ ��������, TEMP�� �����ϴ� �ڷ� ���� ��� 
6. EMP_ID ���� �ڽź��� SALARY�� ���� �ο� COUNT
7. TEMP �� TDEPT CARTESIAN PRODUCT ����
8. TEMP �� TDEPT NATURAL JOIN
9. TEMP �� TDEPT USING�� ��� NATURAL JOIN
10. NATURAL JOIN ON �� ����Ͽ� ���,�μ�,EMP_LEV ���� ����
11. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� LEFT OUTER JOIN ����
12. 11���� FROM���� ���� ���̺�� outer JOIN���� ���� ���̺� �ٲ㼭 ����
13. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� RIGHT OUTER JOIN ����
*/
-- 1.
select e.emp_id, e.emp_name, d.dept_code, d.dept_name
    from temp e, tdept d 
    where e.dept_code = d.dept_code 
    and e.salary > 90000000;
-- 2.
select * from tcom;
select e.emp_id, e.emp_name, e.dept_code, d.dept_name, c.comm
    from temp e, tdept d, tcom c
    where e.dept_code = d.dept_code
        and e.emp_id = c.emp_id
        and c.work_year = '2019'
    order by e.emp_id;
-- 3. *****
select * from temp;
select a.emp_id, a.emp_name, a.salary
    from temp a, temp b -- ��� ���� �� ���ǿ� �´� �� ��� ����? (��� ���� > ��ο� ���� ����� ��Һ� ����)
    where a.salary < b.salary
        and b.emp_name = '�ڹ���'; -- �ڹ������� �޿��� �۴�: ������ �޿��� �۴� + �ٸ����� �̸��� �ڹ�����
    -- Ȥ�� �ڹ����� �ִ� 1��¥�� ���̺�� ��ü ���̺��� salary�������� �����Ѵٰ� �����Ҽ��� �ִ�.
-- 4.
select * from emp_level;
select * from temp;
select lev, (from_sal + to_sal) / 2 as avg_sal from emp_level;
select e.emp_id, e.emp_name, e.salary, e.lev, (s.from_sal + s.to_sal) / 2 as lev_avg_sal
    from temp e, emp_level s
    where e.lev = s.lev
        and e.salary < (s.from_sal + s.to_sal) / 2
    order by e.lev, e.emp_id;    

--5. TEMP ,TCOM�� EMP_ID�� �����Ͽ� ��� ������ ��������, TEMP�� �����ϴ� �ڷ� ���� ��� *****
select * -- oracle
    from temp t, tcom c
    where t.emp_id = c.emp_id(+)
        and c.work_year(+) = to_char(sysdate, 'YYYY'); -- oracle������ (+)�� ��� ���ǿ� �ٿ���� outer join����
select * -- ANSI
    from temp a
    left outer join tcom b
    on (a.emp_id = b.emp_id)
    and b.work_year = to_char(sysdate, 'YYYY');

--6. EMP_ID ���� �ڽź��� SALARY�� ���� �ο� COUNT
select a.emp_id, count(b.salary) as higher_than_me
    from temp a, temp b
    where a.salary < b.salary(+)
    group by a.emp_id
    order by higher_than_me;
--�Ʒ� Ȱ��    
select a.*, b.emp_id as t
from temp a, temp b
where a.salary < b.salary(+);

--7. TEMP �� TDEPT CARTESIAN PRODUCT ����
select * from temp e, tdept d;

--8. TEMP �� TDEPT NATURAL JOIN
select * from temp natural join tdept;

--9. TEMP �� TDEPT USING�� ��� NATURAL JOIN
select * from temp join tdept using (dept_code);

--10. NATURAL JOIN ON �� ����Ͽ� ���,�μ�,EMP_LEV ���� ����
select * from temp join tdept on (temp.dept_code = tdept.dept_code) join emp_level on (temp.lev = emp_level.lev);

select * from temp;

--11. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� LEFT OUTER JOIN ����
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e left outer join tdept d
    on e.dept_code = d.dept_code;

--12. 11���� FROM���� ���� ���̺�� outer JOIN���� ���� ���̺� �ٲ㼭 ����
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from tdept d left outer join  temp e 
    on e.dept_code = d.dept_code;

--13. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� RIGHT OUTER JOIN ����
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e right outer join tdept d
    on e.dept_code = d.dept_code;
/*
    �߰�����
    1. outer ����
    2. outer �����ϵ� 19�����
    3. Ȧ¦�� 1:2 ������ ������ ���� �����ϵ� �Ŵ� Ŀ�̼� �߰����޽� 1~12�� �÷����� �Ǽ��� ���� ���̺� �����
    4. ���� ������ �������� ���̿� ���ԵǴ� ����� ������ ���� ���� ���� ���� ��������
*/
--1
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e full outer join tdept d
    on e.dept_code = d.dept_code;
--2
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e full outer join tdept d
    on e.dept_code = d.dept_code
    where emp_id like '2019%';
--3
create table t2_data as
select emp_id, 
    sal_odd as SAL01, sal_even as SAL02, sal_odd as SAL03, sal_even as SAL04,
    sal_odd as SAL05, sal_even as SAL06, sal_odd as SAL07, sal_even as SAL08,
    sal_odd as SAL09, sal_even as SAL010, sal_odd as SAL011, sal_even as SAL012
from (
    select e.emp_id, ceil(salary / 18 + nvl(c.comm, 0)) as sal_odd, ceil(salary / 9 + nvl(c.comm, 0)) as sal_even
    from temp e, tcom c
    where e.emp_id = c.emp_id(+)
        and c.work_year(+) = to_char(sysdate, 'YYYY')
)
order by emp_id;
--4
select * from emp_level;
select e.*, l.lev as to_lev
    from temp e, emp_level l
    where (sysdate - birth_date) / 365 >= l.from_age and (sysdate - birth_date) / 365 < l.to_age
        and l.lev = '����';
select e.*, l.lev as to_lev, trunc((sysdate - birth_date) / 365) as age
    from temp e, emp_level l
    where e.birth_date
        between add_months(sysdate, - l.to_age * 12)
        and add_months(sysdate, - l.from_age * 12)
        and l.lev = '����';
        