/*
    0710: DML
*/
commit;
-- �پ��� Insert��
insert into departments(department_id, department_name, manager_id) values (1000, 'CRM', 100);
insert into departments(department_id, department_name) values (1150, 'Finance');
insert into employees(employee_id, first_name, last_name, email, job_id, hire_date) values(1000, 'test', 'lastname', 'email', 'AD_PRES', sysdate);
rollback;

-- �ǽ��� ���̺� ����
create table sales_reps as
select employee_id id, last_name name, salary, commission_pct from employees where rownum < 1;
insert into sales_reps select employee_id, last_name, salary, commission_pct from employees;

-- �پ��� Update��
select department_id from employees where employee_id = 100; --�Ʒ� �࿡ �ش�Ǵ� data�� ���� select��
update employees set department_id = 80 where employee_id = 100;
select department_id from employees where employee_id = 100; --����� �� Ȯ��
rollback;

-- ���������� Ȱ���� ���� �÷��� update
update employees 
    set job_id = (
        select job_id from employees where employee_id = 102),
    department_id = (
        select department_id from employees where employee_id = 102)
    where employee_id = 101;
rollback;

-- ���������� �̿��� �ٸ� ���̺� ������� update
create table emp_copy as
select * from employees;
select * from emp_copy where employee_id = 102;
update employees 
    set job_id = (
        select job_id from emp_copy where employee_id = 102),
    department_id = (
        select department_id from emp_copy where employee_id = 102)
    where employee_id = 101;
select * from employees where employee_id = 101;
rollback;

-- ���Ἲ �������� ����(FK)
update employees set department_id = 55 where department_id = 100; -- department_

-- delete�� (�� ���� ������ ������ �÷� ���� �ʿ� ����. from ���� �����ϴ�)
select * from emp_copy where employee_id = 100; -- 1��
delete emp_copy where employee_id = 100; --����
select * from emp_copy where employee_id = 100; --null
rollback;

select * from departments;

-- �ٸ� ���̺� ������� delete
delete emp_copy where department_id =
    (select department_id from departments where department_name LIKE '%Finance%');

-- ���Ἲ �������� ���� (�μ��ڵ尡 ������� ����)
delete departments where department_id = 60;
rollback;

-- merge = update + insert (update�� �ش�Ǵ� ���ڵ� ���� �� insert)
/*
MERGE INTO table_name alias
    USING (table | view | subquery) alias                -- �ϳ��� ���̺� �̿��Ѵٸ� DUAL Ȱ��
         ON (join condition)                                     -- WHERE���� ���� ������
    WHEN MATCHED THEN                                   -- ON ������ ���ǿ� �ش��ϴ� �����Ͱ� �ִ� ��� 
             UPDATE SET col1 = val1[, ...]                -- UPDATE ����
    WHEN NOT MATCHED THEN                           -- ON ������ ���ǿ� �ش��ϴ� �����Ͱ� ���� ���
             INSERT (column lists) VALUES (values);  -- INSERT ����

    ��ó: https://unabated.tistory.com/entry/����Ŭ-MERGE-INTO-�ѹ���-INSERT-UPDATE-�ϱ� [�����]
*/
select count(*) from emp_copy;
delete emp_copy where department_id = 50;
commit;

desc emp_copy;
merge into emp_copy c
    using employees e
    on (c.employee_id = e.employee_id)
    when matched then
        update set -- employees�� emp_copy�� ���ÿ� �ִ� ����� first_name�� '�ٺ�'�� �ٲ���
        c.first_name = '�ٺ�',
        c.last_name = e.last_name,
        c.email = e.email,
        c.job_id = e.job_id,
        c.hire_date = e.hire_date
    when not matched then -- employees���� �ִµ� emp_copy�� ���� ����� �״�� ������ ������ �߰�
        insert(c.employee_id, c.first_name, c.last_name, c.email, c.job_id, c.hire_date)
        values(e.employee_id, e.first_name, e.last_name, e.email, e.job_id, e.hire_date);
rollback;

-- �ǽ��� ���̺�
create table ttmcd(
    mcd varchar2(4) not null primary key,
    mnm varchar2(200),
    rmk varchar2(400)
);
create table ttcode(
    kno number not null primary key,
    mcd varchar2(4),
    dcd varchar2(4),
    dnm varchar2(100),
    drm varchar2(400)
);
alter table ttcode
add constraint fk_from_ttmcd foreign key (mcd) references ttmcd(mcd);
-- �ǽ�
-- 1. tmcd ���̺� ���� �ڵ� �Է�
insert into ttmcd values('A001', '�򰡰������ڵ�', '');
insert into ttmcd values('A002', '���׸��ڵ�', '');
-- 2. tcode ���̺� �ڵ� �Է�
insert into ttcode values(101, 'A001', 'A', 'A���', '90�� �̻�');
insert into ttcode values(102, 'A001', 'B', 'B���', '80�� �̻�');
insert into ttcode values(103, 'A001', 'C', 'C���', '70�� �̻�');
insert into ttcode values(104, 'A001', 'D', 'D���', '60�� �̻�');
insert into ttcode values(105, 'A001', 'F', 'F���', '60�� �̸�');
insert into ttcode values(111, 'A002', '0001', '����', '���������� ���ϴ� �׸�');
insert into ttcode values(112, 'A002', '0002', '�ڱ���', '�������� �ڱ��� ������ ���ϴ� �׸�');
insert into ttcode values(113, 'A002', '0003', '����', '���ῡ�� ����� ������ ���ϴ� �׸�');
insert into ttcode values(114,'A002', '0004', '�µ�', '����, ������� �� ������ �����ϴ� �������� �µ��� ���ϴ� �׸�');

--1. temp ���̺� not null�� �÷��� ���������� insert ���� �ۼ�
insert into temp(emp_id, emp_name, dept_code, use_yn) values(20100101, 'test', 'AA001', 'N');
--2. temp�� ���� ���� ���̺� ����� temp���� select�� insert
create table temp_copy as 
    (select * from temp where rownum < 1);
insert into temp_copy select * from temp where rownum < 10;

rollback;
drop table temp_copy;
/*
����
1. ������� ��ȭ��ȣ�� DBA_OBJECTS �� ROW����, SALARY�� ���� ������ ����ġ�� ����  
     �������� Ȯ�� �� COMMIT;
2. TEMP�� DEPT_CODE���� TDEPT�� DEPT_CODE�� �����ϴ� FOREIGN KEY ����
3. EMP_ID = 19970112 ����� DEPT_CODE �� �μ��ڵ忡 �������� �ʴ� �ڵ�� ����
    (���Ἲ ����Ȯ��)
4. TEMP ���� EMP_ID = 19970112 ��� ����
     ���� ���� Ȯ�� ��  ROLLBACK;
5.  �μ���ġ�� ��õ�� �μ��� ���ϴ� ���� ����
     ���� ���� Ȯ�� ��  ROLLBACK;
6. �μ����̺��� �μ��ڵ尡 ��AA0001�� �� �μ� ���� (����Ȯ��)
7. TEMP �� ������ ���̺��� TEMP���� �μ��ڵ尡 ��AA0001�� �� ��츸 SELECT �ؼ�
   CREATE. �ٽ� TEMP �� ROW�� ���� ���� ���̺� ������ INSERT ������ SALARY�� ������ 
*/
--1.
select * from temp where emp_name = '�����';
update temp 
    set 
        tel = (select count(*) from DBA_OBJECTS), 
        salary = (select max(salary) from temp where lev = (select lev from temp where emp_name = '�����')) -- ����??
    where emp_name = '�����';

update temp a
    set 
        tel = (select count(*) from DBA_OBJECTS), 
        salary = (select to_sal from emp_level where lev = a.lev)
    where emp_name = '�����';
commit;
--2.
alter table temp drop constraint dept_r;
alter table temp
add constraint fk_from_tdept foreign key (dept_code) references tdept(dept_code);
select * from tdept;
commit;
--3.
update temp
    set
        dept_code = 'HELLLO'
    where emp_id = '19970112';
--4.
delete temp where emp_id = '19970112';
rollback;
--5.
select * from tdept;
delete temp
    where (select area from tdept where temp.dept_code = tdept.dept_code) = '��õ';
rollback;
--6.
delete tdept where dept_code = 'AA0001';
--7. TEMP �� ������ ���̺��� TEMP���� �μ��ڵ尡 ��AA0001�� �� ��츸 SELECT �ؼ� CREATE. �ٽ� TEMP �� ROW�� ���� ���� ���̺� ������ INSERT ������ SALARY�� ������
create table temp_copy as (select * from temp where dept_code = 'AA0001');
desc temp;
merge into temp_copy c
    using temp e
    on (c.emp_id = e.emp_id)
    when matched then
        update set -- employees�� emp_copy�� ���ÿ� �ִ� ����� first_name�� '�ٺ�'�� �ٲ���
        c.emp_name = e.emp_name,
        c.dept_code = e.dept_code,
        c.use_yn = e.use_yn
    when not matched then -- employees���� �ִµ� emp_copy�� ���� ����� �״�� ������ ������ �߰�
        insert(c.emp_id, c.emp_name, c.dept_code, c.use_yn)
        values(e.emp_id, e.emp_name, e.dept_code, 'N');
        
/*
    �� ���̺� ����
*/
create table teval(
    ym_ev varchar2(6),
    emp_id number,
    ev_cd number,
    ev_res varchar(1),
    ev_emp  number
);
alter table teval add constraint teval_pk primary key (ym_ev, emp_id, ev_cd);
alter table teval add constraint fk_from_teval_to_temp foreign key (emp_id) references temp(emp_id);
alter table teval add constraint fk_from_teval_to_ttcode foreign key (ev_cd) references ttcode(kno);
alter table teval add constraint fk_from_teval_to_temp2 foreign key (ev_emp) references temp(emp_id);

-- 201902, 201906�� ym_ev�� ������ �� ����� �� �׸񺰷� 2ȸ �򰡸� �ǽ��ߴ�. pk�κ��� �ϼ��غ���.
insert into teval(ym_ev, emp_id, ev_cd)
    select decode(m.rn, 1, '201906', '201912') as ev_ym, e.emp_id as emp_id, c.kno as ev_cd
    from(select emp_id from temp where lev in (select lev from emp_level)) e, 
        (select kno from ttcode where mcd = 'A002') c, 
        (select rownum as rn from temp where rownum <= 2) m
    order by 1, 2, 3;

-- select��
select decode(m.rn, 1, '201906', '201912') as ev_ym, e.emp_id as emp_id, c.kno as ev_cd
from(select emp_id from temp where lev in (select lev from emp_level)) e, 
    (select kno from ttcode where mcd = 'A002') c, 
    (select rownum as rn from temp where rownum <= 2) m
order by 1, 2, 3;
-- ����� select��
select  decode(no,1,'201906',2,'201912'), 
        a.emp_id,
        b.kno
from temp a, ttcode b, emp_level c, t1_data d
where a.lev = c.lev
and b.mcd = 'A002'
and d.no <=2
order by 1,2,3;

select * from tdept;
desc teval;

-- �ǽ� ���̺� ����
update tdept
    set boss_id = '19960303'
    where dept_code = 'CB0001';
    
-- �μ����� ���ڷ� update
update teval e -- update�� �� ������ �̷�� ���Ƿ�, e�� ���� �ϳ��� �࿡ ���� ������ ������ �� �ֵ�.
    set ev_emp = 
        (select boss_id from tdept where dept_code = 
            (select dept_code from temp where emp_id = e.emp_id));
-- ����� Ǯ��
update teval e
    set ev_emp = 
        (select boss_id from temp a, tdept b where a.dept_code = b.dept_code and a.emp_id = e.emp_id);
/* ?? set from��?  oracle������ �Ұ���       
update teval e
    set ev_emp = x.boss_id
    from (select a.emp_id, b.dept_code, b.boss_id
          from temp a, tdept b
          where a.dept_code = b.dept_code) x
    where e.emp_id = x.emp_id;
    

  select a.emp_id, b.dept_code, b.boss_id
          from temp a, tdept b
          where a.dept_code = b.dept_code  ;*/

-- �ǽ� ������ �߰� �� ����
insert into teval(ym_ev, emp_id, ev_cd) 
select '2019'||'01', a.emp_id, b.kno
from temp a, ttcode b
where b.mcd = 'A002';
update teval z
    set ev_emp = (select boss_id from temp a, tdept b where a.dept_code = b.dept_code and a.emp_id = z.emp_id)
    where ym_ev = '201901';
alter table temp add (eval_yn varchar2(1));

/*
����
8. 2019�� 6�� �� �ڷḦ �о� �򰡴���ڷ� ��ϵ� ��츸 �������̺� EVAL_YN�� 
   Y�� ���� �ƴϸ� N �� ����  �� COMMIT
*/
select * from teval;
update temp
    set eval_yn = decode(
        (select count(emp_id) from teval where ym_ev = '201906'),0, 'N','Y');
commit;

-- �߰�����
--1.
select * from temp;
select * from teval ev
    where (select eval_yn from temp e where ev.emp_id = e.emp_id) = 'N'
    and ym_ev = '201901';
--2.
create table temp1 as select * from temp where temp.hobby is null;
