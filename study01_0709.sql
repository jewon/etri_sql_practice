/*
    0709 ���������� ġȯ����
*/
-- �ǽ������� ����
update tdept set boss_id = decode(dept_code, 'AA0001', 19970101, 'BA0001', 19930331) where dept_code in ('AA0001', 'BA0001');

-- ��/�� ��ȯ�غ��� (������ 12�� �÷��� ������ ���� > ���� + ���� Ű�� ���� ���� ���̺�)
select a.emp_id, lpad(b.no, 2, '0') || '��' as pay_mon, 
        decode(b.no, 1, a.SAL01, 2, a.SAL02, 3, a.SAL03, 4, a.SAL04, 5, a.SAL05, 
            6, a.SAL06, 7, a.SAL07, 8, a.SAL08, 9, a.SAL09, 10, a.SAL10, 11, a.SAL11, a.SAL12) 
        as PAY_AMT 
    from t2_data a, t1_data b
    where b.no < 13
    order by emp_id, pay_mon;
    
/*
    ��������
    ������ ��������: ������� �ϳ�, ���������� ����� ������ �񱳿����� ���(=, <>, <, >, <=, >=)
    ������ ��������: ��� ���� �� �̻�, �������� ����� ������ �񱳿����� ���(IN, >ANY, <ANY, >ALL, <ALL)
*/
-- ex.
select last_name, salary, (select salary from employees where last_name = 'Kochhar') as KochharSal 
from employees where salary > (select salary from employees where last_name = 'Kochhar');

-- ������ ��������
-- ���ǿ����� ��������: 101����� ���� �μ��� �����鼭 141������� �޿��� ���� ���
select last_name, department_id, salary 
from employees
where department_id = 
        (select department_id from employees where employee_id = 101) 
    and salary > 
        (select salary from employees where employee_id = 141);
-- Group�Լ����� ���: ���� ���� ������ �޴� ������ �̸��� ����
select last_name, salary from employees where salary = (select max(salary) from employees);
-- having�������� ��������: 60�μ� �ּ� ���޺��� �ּ� ������ ���� �μ�
select department_id, min(salary) 
from employees 
group by department_id 
having min(salary) > 
    (select min(salary) from employees where department_id = 60);

-- ������ ��������
-- IN������ ���: �μ��� �ִ� ������ �ڽ��� �������� �ϴ� ���(�μ��� �ְ� ���� ������� �ٸ���)
select last_name, salary from employees
    where salary in (select max(salary) from employees group by department_id);
-- ANY������ ���: IT_PROG������ ���� ����� ���� �� � �ϳ����� ���� ������ ���� IT_PROG���� ������ ���� ���
select last_name, job_id, salary from employees
    where salary <ANY (
        select salary
        from employees
        where job_id = 'IT_PROG')
    and job_id <> 'IT_PROG';
-- �������� NULL�� ��ȯ: �������� ����� NULL�� ��� �������� ����� NULL
select last_name, department_id
from employees
where department_id = (
    select department_id
    from employees
    where last_name = 'Hugo');
/*
    ġȯ����
*/
-- &: ����ÿ� �Է� �ް� �ȴ�. �����ʹ� �ٸ��� �ܼ��� &�� �ش��ϴ� �κ��� ġȯ�ϴ� ����.(���� �� ���� ����)
select last_name, salary from employees where salary = &sal;
select last_name, salary from employees where last_name = '&name';
-- &&: ���� ġȯ������ ���� �� ���� �ѹ��� �Է¹���
select last_name, salary, &&col from employees order by &col;
-- DEFINE: ġȯ������ 
define v_empid = 300;
select last_name from employees where employee_id = &v_empid;

-- �����÷� �������� ��
select * from temp where (emp_type, hobby) = (select emp_type, hobby from temp where emp_id = 19970101);
select * from temp where (emp_type, hobby) = (select emp_type, hobby from temp where dept_code like 'C%'); -- ERR ORA-01427: ���� �� ���� ���ǿ� 2�� �̻��� ���� ���ϵǾ����ϴ�.
select * from temp where (emp_type, hobby) in (select emp_type, hobby from temp where dept_code like 'C%');

/*
����
    1. SALARY �� ���������� ���� ������ �̸�,SALARY ��������
    2. �μ��� ��浿�� ���� SALARY�� ���������� ���� ���,����,�μ��ڵ�,SALARY ��������
    3. ���� ������ ���� �޴� ����� �̸�, SALARY �˻� (��������)
    4. �μ��� ���������� ����ϵ� BC0001�μ��� �������޺��ٴ� ū ���� ��������
    5. �� �μ� ���� SALARY�� SALARY�� ���� ���� ���� �˻�
    6. ������ ������ ����� �� ������ ��� �� ������ٴ� �޿��� ���� �޴� ��� ���� �������� 
    7. ������ ����� ��� �������� �޿��� ���� �޴� ��� ���� �������� 
    8. 19950303 ������ ��̿� ��̰� ���� ��� ���� ��������
*/
--1.
select emp_name, salary 
    from temp 
    where salary > 
        (select salary 
            from temp
            where emp_name = '������');
--2.
select emp_id, emp_name, dept_code, salary
    from temp
    where dept_code =
        (select dept_code
            from temp
            where emp_name = '��浿')
    and salary >
        (select salary
            from temp
            where emp_name = '������');
--3.
select emp_name, salary
from temp
where salary = (
    select max(salary) from temp);
--4.
select dept_code, min(salary)
from temp
group by dept_code
having min(salary) > 
    (select min(salary) 
        from temp
        group by dept_code
        having dept_code = 'BC0001');
--5.
select e.emp_name, e.salary
from temp e, 
    (select dept_code, min(salary) as minsal
        from temp
        group by dept_code) s
where e.dept_code = s.dept_code
and e.salary = s.minsal;

select emp_name, salary
from temp e
where salary = 
    (select min(salary)
        from temp s
        where e.dept_code = s.dept_code);
--6.
select emp_name, salary
from temp
where salary >ANY
    (select salary
        from temp
        where lev = '����');
--7.
select emp_name, salary
from temp
where salary >ALL
    (select salary
        from temp
        where lev = '���');
--8.
select emp_name, hobby
from temp
where nvl(hobby, 'N') = 
    nvl((select hobby
        from temp
        where emp_id = '19950303'), 'N');
/*
9. &SAL �̶�� ġȯ������ �Է¹޾� �������� SALARY�� ���� ��� �˻� ���� �ۼ� �� 
   (���� ���� 50000000, ��50000000��, ��5õ������ �� �־� ���� �����غ��� 
10. 9�� ġȯ������ �յڷ� ���� ����ǥ �ٿ� �����
   (���� ���� 50000000, ��50000000�� �� �־� ���� �����)
11. HOBBY�� &HOBBY�� ���� �Է¹޾�  HOBBY�� �Է°��� ���� ���� �˻� ���� �ۼ� ��
   (���� ���� ���, ����ꡯ �� �־� ���� �����)
12. 11�� ġȯ������ �յڷ� ���� ����ǥ �ٿ� �����
   (���� ���� ���, ����ꡯ �� �־� ���� �����)
13. �ڱ� ������ ��� �������� �޿��� ���� �������� �������� 
14. ��õ�� �ٹ��ϴ� ���� �������� (�������� �̿�)  
*/
--9.
select emp_name, salary
from temp
where salary = &sal;

--10.
select emp_name, salary
from temp
where salary = '&sal';

--11.
select emp_name, hobby
from temp
where hobby = &hobby;

--12.
select emp_name, hobby
from temp
where hobby = '&hobby';

--13.
select emp_name, lev, salary,
    round((select avg(salary) from temp where lev = e.lev)) as lev_avgsal
from temp e
where salary < 
    (select avg(salary) as avgsal
     from temp s
     where e.lev = s.lev)
order by lev, emp_name;

--14.
select e.emp_name, e.dept_code
from temp e
where (select area 
        from tdept
        where dept_code = e.dept_code) = '��õ';
        
/*
1. TCOM�� ���� �ܿ� commission�� �޴� ������ ����� �����Ǿ� �ִ�. �� ������ sub query�� select�Ͽ� �μ� ��Ī���� commission�� �޴� �ο����� ���� ������ �����.
2. ġȯ������ ���ڸ� �� ���� �Է¹޾� �Է°�, �Է°� +10, �Է°� * 10 �� ���ϴ� ����
3. �ԷµǴ� parameter ���� ���� group by �� �ϰ� ���� ��� query �ۼ�
    ����1: �ԷµǴ� grouping ������ �� �� ���� ������ (��: ��̺� �μ���)
            �ϳ��� ���� ���� ���� (��:���޺�)
    ����2: ���� �ڷ�� �׷캰 salary ���, �ش��ο���, �׷캰 salary ����
    ����3: �Է� ������ group ������ ������ ����. �μ��ڵ�, �μ���, ���, ����, ä������     
*/
select * from temp;
-- 1.
-- �׳� Ŀ�̼� �޴� �μ���
select dept_code, count(*) as cnt
        from temp
        where emp_id in (select distinct emp_id from tcom)
        group by dept_code;
-- ��� �μ����� Ŀ�̼� �޴� ��� ��
select b.dept_name, nvl(a.cnt, 0) as comm_emp_count
    from tdept b left outer join
        (select dept_code, count(*) as cnt
            from temp
            where emp_id in (select distinct emp_id from tcom)
            group by dept_code) a 
        on (a.dept_code = b.dept_code)
    order by 1; -- ���� �ٱ� inline view�� nulló�� ����
-- oracle
select dept_name, count(commyn)
from (
    select b.dept_name, (Select distinct(c.emp_id) from tcom c where c.emp_id = a.emp_id) commyn
    from temp a, tdept b
    where b.dept_code = a.dept_code)
group by dept_name
order by 1;

-- 2.
select &&test + 10, &test - 10 from dual;
-- 3.
select decode('&grou1', '�μ��ڵ�', temp.dept_code, '�μ���', dept_name, '����', lev, '���', hobby, 'ä������', emp_type, emp_id) as group1, 
    decode('&grou2', '�μ��ڵ�', temp.dept_code, '�μ���', dept_name, '����', lev, '���', hobby, 'ä������', emp_type, null) as group2,
    round(avg(salary)) as avgsal, count(*) as count, sum(salary) as sumsal
from temp left outer join tdept on (temp.dept_code = tdept.dept_code)
group by decode('&grou1', '�μ��ڵ�', temp.dept_code, '�μ���', dept_name, '����', lev, '���', hobby, 'ä������', emp_type, emp_id),
    decode('&grou2', '�μ��ڵ�', temp.dept_code, '�μ���', dept_name, '����', lev, '���', hobby, 'ä������', emp_type, null)
order by 1;