/* 
    0729: DML DDL Ȯ��
*/
-- �ǽ����̺� ����
create table mgr_history 
    as select
        employee_id empid,
        manager_id mgr,
        salary sal
    from employees
    where employee_id = -1;
create table sal_history
    as select
        department_id deptid,
        hire_date hiredate,
        salary sal
    from employees
    where employee_id = -1;
create table hiredate_history
    as select
        department_id deptid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table hiredate_history_00
    as select
        department_id deptid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table hiredate_history_99
    as select
        employee_id empid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table special_sal
    as select
        department_id deptid,
        salary sal
    from employees
    where employee_id = -1;
-- insert all
insert all
    into sal_history values(empid, hiredate, sal)
    into mgr_history values(empid, mgr, sal)
    select employee_id empid, hire_date hiredate, salary sal, manager_id mgr
    from employees
    where employee_id > 200;
-- conditional insert all (������ ��Ÿ������ ���� ���� ����, �պ���)
insert all
    when sal > 10000 then
        into sal_history values (empid, hiredate, sal)
    when mgr > 200 then
        into mgr_history values (empid, mgr, sal)
    select 
        employee_id empid,
        hire_date hiredate,
        salary sal,
        manager_id mgr
    from employees
    where employee_id > 200;
-- insert first
insert first
    when sal > 25000 then
        into special_sal values(deptid, sal)
    when hiredate like ('%00%') then
        into hiredate_history_00 values(deptid, hiredate)
    when hiredate like ('%99%') then
        into hiredate_history_99 values(deptid, hiredate)
    else
        into hiredate_history values(deptid, hiredate)
        select department_id deptid, sum(salary) sal,
            max(hire_date) hiredate
        from employees
        group by department_id;
-- �ǽ����̺� ����
create table sales_source_data
as select employee_id,
    no week_id,
    ceil(dbms_random.value(1000, 5000)) sales_mon,
    ceil(dbms_random.value(1000, 5000)) sales_tue,
    ceil(dbms_random.value(1000, 5000)) sales_wed,
    ceil(dbms_random.value(1000, 5000)) sales_thu,
    ceil(dbms_random.value(1000, 5000)) sales_fri
from employees,
     t1_data
where no < 6;
create table sales_info
    as select employee_id, week_id, sales_mon sales_day
    from sales_source_data
    where employee_id = -1;
-- �������̺� insert
insert all
    into sales_info values(employee_id, week_id, sales_MON)
    into sales_info values(employee_id, week_id, sales_TUE)
    into sales_info values(employee_id, week_id, sales_WED)
    into sales_info values(employee_id, week_id, sales_TUE)
    into sales_info values(employee_id, week_id, sales_FRI)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
    from sales_source_data;
-- �ܺ����̺�
select employee_id empno,
    first_name || ' ' || last_name
from employees;
-- 
create directory emp_dir as 'D:\ETRI�����ͱ��\';
create table oldemp(
    empno number,
    empname char(46))
    organization external(
        type oracle_loader
        default directory emp_dir
        access parameters(
            records delimited by newline
            badfile 'bad.emp'
            logfile 'log.emp'
            fields terminated by '\t' (
                empno char, empname char
            )
        )
        location('emp1.txt')
    )
    parallel 4
    reject limit 300;
-- PK������ �ε��� ����� ����
create table new_emp
(employee_id number(6)
    primary key using index
    (create index emp_id_idx on 
    new_emp(employee_id) ),
first_name varchar2(20),
last_name varchar2(25));

-- 1. TDEPT�� �μ� ������ csv�� �����ϰ� �ܺ����̺� ���� �� ��ȸ 
select * from tdept; -- �ܾ ������ �ٿ����� ��, ������ �и��� txt�� ����
create directory tdept_dir as 'D:\';
drop table oldtdept;
create table oldtdept (
    dept_code char(6),
    dept_name char(40),
    parent_dept char(6),
    use_yn char(1),
    area char(10),
    boss_id number)
    organization external(
        type oracle_loader
        default directory tdept_dir
        access parameters(
            records delimited by newline
            badfile 'bad.tdept'
            logfile 'log.tdept'
            fields terminated by ',' (
                dept_code char
                dept_name char,
                parent_dept char,
                use_yn char,
                area char,
                boss_id number
            )
        )
        location('tdept2.csv')
    )
    parallel 4
    reject limit 300;
select * from oldtdept;

/*
2.  ������ �ҼӺμ��� ����� �� ���� ������� ������ ������ ������ �����ϱ� ���� 
     HISTORY ���̺� ����  
     TMAN_HISTORY(CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, 
     DEPT_CODE VARCHAR(20), BOSS_ID NUMBER, IS_NOW VARCHAR2(01) ); 
3.  ������  ���� ������ ����� �� ���� ���� �������ڿ� ���� ��.�� �ݾ��� �����ϴ� HISTORY
     ���̺� ����  
     TSAL_HISTORY(CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, BEF_SALARY NUMBER, AFT_SALARY NUMBER)
4.  ���� ���������� �о� ������ ����� ��� HISTORY ���̺� �� ���� ���� ���� ���� �Է�
     (��������:��������,  IS_NOW:��Y��,  BEF_SALARY:0,  AFT_SALARY:����SALARY)
5.  ���� ���������� �о� ������ �븮�� ��� HISTORY ���̺� �� ���� ���� ���� ���� �Է��ϵ�
    TMAN_HISTORY���� AA0001 �μ����� ������� TSAL_HISTORY���� 
    SALARY�� 5õ���� �̻��� ��츸�� ������� ���� �μ�Ʈ ����
*/
--2. 3.
create table TMAN_HISTORY(
     CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, 
     DEPT_CODE VARCHAR(20), 
     BOSS_ID NUMBER, 
     IS_NOW VARCHAR2(01)
);
create table TSAL_HISTORY(
    CHANGE_DATE VARCHAR2(08), 
    EMP_ID NUMBER, 
    BEF_SALARY NUMBER,
    AFT_SALARY NUMBER
);
--4.
insert all
    into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '���';
select * from temp;
select * from tsal_history;
--5.
insert all
    when dcd = 'AA0001' then
        into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    when sal >= 50000000 then
        into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '�븮';
/*
6. ���� ���������� �о� ������ ������ ��� HISTORY ���̺� �� ���� ���� ���� ������ �Է��ϵ�
    TMAN_HISTORY���� AA0001 �μ����� ������� 
    TSAL_HISTORY���� SALARY�� 5õ���� �̻��� ��츸�� ������� ���� �μ�Ʈ ���� 
    (��, ù ��°  TMAN�� �Էµ� ��� TSAL �Է� ����)
7. T2_DATA�� ROW�������� �����ϱ� ���� ���̺� ���� 
    T2_TRAN (EMP_ID NUMBER, YM VARCHAR2(06), MSAL NUMBER)
8. T2_DATA�� INSERT ALL �����̿� T2_TRAN ���� INSERT
*/
--6.
insert first
    when dcd = 'AA0001' then
        into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    when sal >= 50000000 then
        into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '����';
--7.
create table t2_tran (EMP_ID NUMBER, YM VARCHAR2(06), MSAL NUMBER);
--8.
insert all
    into t2_tran values(emp_id, '201901', sal01)
    into t2_tran values(emp_id, '201902', sal02)
    into t2_tran values(emp_id, '201903', sal03)
    into t2_tran values(emp_id, '201904', sal04)
    into t2_tran values(emp_id, '201905', sal05)
    into t2_tran values(emp_id, '201906', sal06)
    into t2_tran values(emp_id, '201907', sal07)
    into t2_tran values(emp_id, '201908', sal08)
    into t2_tran values(emp_id, '201909', sal09)
    into t2_tran values(emp_id, '201910', sal10)
    into t2_tran values(emp_id, '201911', sal11)
    into t2_tran values(emp_id, '201912', sal12)
    select *
    from t2_data;
select * from t2_tran;
/*
quiz: A�� 1+2Ÿ�� amt�հ�, B�� 1+3Ÿ�� amt�հ��� ��,
A	340
B	310
�� ���� ���̺� �����
*/
create table test34(
    key1 varchar2(03),
    key_type varchar2(01),
    amt number,
    constraint test34_PK primary key (key1)
);
insert into test34 values('A01', '1', 10);
insert into test34 values('A02', '2', 20);
insert into test34 values('A03', '1', 30);
insert into test34 values('A04', '2', 40);
insert into test34 values('A05', '3', 50);
insert into test34 values('A06', '3', 60);
insert into test34 values('A07', '1', 70);
insert into test34 values('A08', '2', 80);
insert into test34 values('A09', '1', 90);
commit;
select * from test34 order by 2;
-- A: 1,2 B: 1, 3
-- ���տ�����
select 'A' as type, sum(amt) as value from test34 where key_type in (1, 2)
union 
select 'B' as type, sum(amt) as value from test34 where key_type in (1, 3);
-- Join(1ȸ ����)
select decode(d.no, 1, 'A', 'B') as type, sum(amt) as value
from test34 t, t1_data d
where (d.no = 1 and t.key_type in (1, 2)) or (d.no = 2 and t.key_type in (1, 3))
group by decode(d.no, 1, 'A', 'B')
order by type;
-- Window Function
select decode(key_type, 2, 'A', 3, 'B') type, decode(key_type, 2, lag1, 3, lag2) value from (
    select key_type, 
           sum(amt) samt, -- �ڽ� Ÿ���� �հ�
           sum(amt) + lag(sum(amt)) over (order by key_type) lag1,  -- �ڽ� Ÿ�԰� -1�� Ÿ�԰��� �հ�( 2 + 1: A)
           sum(amt) + lag(sum(amt), 2) over (order by key_type) lag2 -- �ڽ� Ÿ�԰� -2�� Ÿ�԰��� �հ�( 3 + 1: B)
    from test34
    group by key_type
)
where key_type in (2, 3)
order by type;