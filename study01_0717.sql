/*
    0717: View
*/
-- ������ �ִ� �÷� ���� ����?
select * from temp_c;
alter table temp_c drop column use_yn; -- �ȴ�
drop table temp_c;


/*
    ��?: ���̺��̳� �ٸ� �並 ���ʷ� �� ������ ���̺�, ������ �����͸� ���� ����(���Ǹ� ����)
*/
grant create view to scott;

--scott
--�� ����
create view emp_20
    as select * from emp where deptno = 20;
--������ ��Ī �����ϸ� �÷����� ��
create view emp_30
    as select empno emp_no, ename name, sal salary from emp where deptno = 30;
--������ or replace�� (alter �� �Ұ�)
create or replace view emp_10 (employee_no, employee_name, job_titile, salary)
    as select empno, ename, job, sal
    from emp
    where deptno = 10;
-- ���� ��
create view dept_sum(name, minsal, maxsal, avgsal)
    as select d.dname, min(e.sal), max(e.sal), avg(e.sal)
    from dept d, emp e
    where d.deptno = e.deptno
    group by d.dname;
-- �並 ���� ���̺� ����
-- �� check option
create or replace view emp_20
    as select *
    from emp
    where deptno = 20
    with check option constraint emp_20_ck;
insert into emp_20 values(1023, 'test', 'CLERK', 7902, '80/10/21', 1000, '', 30); -- ORA-01402: ���� WITH CHECK OPTION�� ���ǿ� ���� �˴ϴ�
update emp_20 set dept_no = 30 where emp_no = 7566; -- ORA-01402: ���� WITH CHECK OPTION�� ���ǿ� ���� �˴ϴ�
create or replace view emp_20
    as select *
    from emp
    where deptno = 20;
update emp_20 set dept_no = 30 where emp_no = 7566; -- OK
rollback;
--�� ����
drop view emp_10;

-- study01
--�ζ��� ��
select a.last_name, a.salary, a.department_id, b.maxsal
from employees a,
    (select department_id, max(salary) maxsal
     from employees
     group by department_id) b
where a.department_id = b.department_id
and a.salary < b.maxsal;
-- top-n �м�: �ζ��� �信�� order by�� ������ �ִ� �� ����
select rownum as rank, last_name, salary
from (select last_name, salary
      from employees
      order by salary desc)
where rownum <= 3;
-- �׷���, �뷮�� �����Ϳ��� �� ������� top-n �м��� �ſ� ���� �ɸ�

create table temp1 as select * from temp;
/*

*/
-- 1.
select * from temp;
select * from emp_level;
select * from tcom;
create view vemp1
    as select * from temp1 where lev = '����';
    
create view vemp2
    as select emp_id, emp_name, dept_code, use_yn, hobby, lev from temp1;

create view vemp3
    as select emp_id ���, emp_name ����, dept_code �μ��ڵ�, use_yn �ٹ�����, hobby ���, lev ���� from temp1;

select * from vemp3 where ��� = '��';

select * from user_views;

select sysdate - birth_date from temp;

create or replace view vemp4
    as select temp.emp_id, emp_name, use_yn, salary, nvl(comm, 0) comm, trunc((sysdate - birth_date) / 365) age, from_age, to_age
    from temp, emp_level, tcom
    where temp.emp_id = tcom.emp_id(+) and temp.lev = emp_level.lev(+)
    order by emp_name;

select * from vemp4;

/*
    1. �μ��ڵ�,�μ���, �ְ�SALARY�� �޴� ���, �ְ�SALARY, �ּ�SALARY�� �޴� ���, �ּ�SALARY �� �����ִ� VEMP5 VIEW�� ����ϴ�. 
    2. TEMP1 EMP_ID �� ALTER TABLE ������� RPRIMARY KEY ����
    3. VEMP1�� �����塯 INSERT ���� 1�� ���� �� TEMP1�� ���� INSERT �Ǿ����� Ȯ�� �� ROLLBACK;
*/
select * from temp1;
select * from tdept;
create view vemp5
    as select e.dept_code, d.dept_name, s.maxsal, maxsal_e, s.minsal, minsal_e
    from (select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code) s,
         (select dept_code, 
;
-- 1-1 inline view
select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code;
select s.dept_code, d.dept_name, s.maxsal, s.minsal, emax.emp_id max_sal_emp, emin.emp_id min_sal_emp
    from (select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code) s,
         temp emax,
         temp emin,
         tdept d
    where (s.dept_code = emax.dept_code and emax.salary = s.maxsal)
      and (s.dept_code = emin.dept_code and emin.salary = s.minsal)
      and d.dept_code = s.dept_code
    order by 1;
-- 1-2 subquery
 select a.dept_code, a.emp_id, a.salary, c.emp_id, c.salary
 from temp a, temp c
 where a.salary = ( select max(salary)
                            from temp b
                            where a.dept_code = b.dept_code)
and c.salary = (select min(salary)
                        from temp d
                        where c.dept_code = d.dept_code)
    and a.dept_code = c.dept_code;
-- 1-3. 
select dept_code, trunc(max(e.es) / 100000000) as max_sal, max(e.es) - round(max(e.es), -8) as max_emp,
       trunc(min(e.es) / 100000000) as min_sal, min(e.es) - round(min(e.es), -8) as min_emp
  from (select salary * 100000000 + emp_id as es, dept_code from temp) e
group by dept_code;

-- 2.
alter table temp1 add constraint temp1_pk primary key (emp_id);

select * from vemp1;
-- 3.
insert into vemp1 values(20190108, '�ȳ�', '93/04/01', 'AB0001', '����', 'N', '', '', 1000, '����', 'N');
rollback;

/*
    4. VEMP2�� �ִ� �÷��� ��� �� �ο��Ͽ� VEMP2�� �̿��� INSERT �� TEMP1 Ȯ�� �� ROLLBACK;
    5. 4���� SALARY �߰��Ͽ� INSERT ���� �ۼ� �� �����Ͽ� ���� Ȯ�� 
    6. VEMP3�� ���� INSERT ���� �������� Ȯ�� �� ROLLBACK;
*/

-- 4.
insert into vemp2 values(20190108, '�׽�Ʈ', 'AB0001', 'N', '����', '����');
select * from temp1 where emp_name = '�׽�Ʈ';
rollback;

--5.
select * from vemp2;
insert into vemp2(emp_id, emp_name, dept_code, use_yn, hobby, lev, salary) values(20190108, '�׽�Ʈ', 'AB0001', 'N', '����', '����', 1000);
-- ORA-00904: "SALARY": �������� �ĺ���

--6.
select * from vemp3;
insert into vemp3 values(20190108, '�׽�Ʈ', 'AB0001', 'N', '����', '����');
rollback;

/*
    7. ���Ѱ��� �𵨿��� 
        ��, �Ѻ� �ο����� ���Ѽ�, ���̺ο��� ������ VPRIV3 VIEW   
    8. GRANT ������� 
        ��, �Ѻ� �ο����� ���Ѽ�, ���̺ο��� ������ : VPRIV4 VIEW   
    9. ���Ѱ��� ���� �Ѻ�, �ο��������� ��, �ο��� ������, 
        GRANT��, GRANT���� ���Ѽ�(���̺�+����), GRANT�� �������� �����ִ� VPRIV5 VIEW ����
*/
select role_cd, count(priv_id) n_priv from trol_priv group by role_cd;
--7.
select * from tprivs;
select * from trol_priv;
select * from trole;
select * from trol_user;
create view vpriv3 as
    select r.role_cd rcd, r.n_priv n_privs, count(user_nm) n_users
      from (select role_cd, count(priv_id) n_priv from trol_priv group by role_cd) r, trol_user u
     where r.role_cd = u.role_cd(+)
     group by (r.role_cd, r.n_priv)
     order by 1;


--8.
select * from user_tab_privs_made;
select * from role_tab_privs where owner = 'STUDY01';
select * from dba_role_privs;

create view vpriv4 as
select p.role rcd, count(distinct u.grantee) n_users, count(distinct p.table_name || p.privilege) n_privs
  from dba_role_privs u, role_tab_privs p
  where p.owner = 'STUDY01'
    and u.grantee(+) <> 'STUDY01'
    and u.granted_role(+) = p.role
  group by p.role;
  
 select *
  from dba_role_privs u, role_tab_privs p
  where p.owner = 'STUDY01'
    and u.granted_role = p.role
    order by grantee;

    select *
      from trol_priv r, trol_user u
     where r.role_cd = u.role_cd
     order by 1;
--9.
/*
    9. ���Ѱ��� ���� �Ѻ�, �ο��������� ��, �ο��� ������, 
        GRANT��, GRANT���� ���Ѽ�(���̺�+����), GRANT�� �������� �����ִ� VPRIV5 VIEW ����
*/
create view vpriv5 as
select d.*, m.*
from (
select r.role_cd rcd, count(distinct priv_id) n_privs, count(distinct user_nm) n_users
    from trol_priv r, trol_user u
    where r.role_cd = u.role_cd(+)
    group by r.role_cd
    order by 1
 ) m, (
select p.role rcd, count(distinct p.table_name || p.privilege) n_privs, count(distinct u.grantee) n_users
    from dba_role_privs u, role_tab_privs p
    where p.owner = 'STUDY01'
    and u.grantee(+) <> 'STUDY01'
    and u.granted_role(+) = p.role
    group by p.role) d
where m.rcd(+) = d.rcd;
select * from temp;
/*
    +
*/
-- ���� ��� �ϳ��� ���̺��� ������� �ϴ� ���游 �����ϴ�.
create view vemp6 as
    select emp_id, e.dept_code, dept_name
    from temp e, tdept d
    where e.dept_code = d.dept_code(+);
insert into vemp6 values(20190111, 'AB0001', '�׽�Ʈ'); --  ORA-01776: ���� �信 ���Ͽ� �ϳ� �̻��� �⺻ ���̺��� ������ �� �����ϴ�.

-- with read only�� �並 �����ϸ� �並 ���� ������ ������ �Ұ����ϴ�
create or replace view vemp1
    as select * from temp1 where lev = '����'
    with read only;
insert into vemp1 values(20190108, '�ȳ�', '93/04/01', 'AB0001', '����', 'N', '', '', 1000, '����', 'N'); -- ORA-42399: �б� ���� �信���� DML �۾��� ������ �� �����ϴ�.

