/*
    0725
*/
-- �����˻�
select employee_id, last_name, job_id, manager_id
from employees
start with employee_id = 101 -- ������ġ
connect by prior manager_id = employee_id; -- emp > man ����˻�

select employee_id, last_name, job_id, manager_id
from employees
start with employee_id = 101
connect by prior employee_id = manager_id; -- man > emp ����˻�

select lpad(last_name, length(last_name) + (level * 2) - 2, '-') as org_chart -- level(���� ���� ��) Ȱ�� ����
from employees
where last_name != 'Higgins' -- where���δ� ���� ��� ���� �ش� ���Ǹ� ������(higgins�� �ڽ��� �״�� ǥ��)
start with employee_id = 100 
connect by prior employee_id = manager_id; -- man > emp ����˻�

/*
    �ǽ��� ������ �����۾�
*/
alter table tdept modify (parent_dept null);
insert into tdept values('CEO001', '��ǥ�̻��', null, 'Y', null, null);
insert into tdept values('COO001', '��Ѱ���', 'CEO001', 'Y', null, null);
insert into tdept values('CTO001', '����Ѱ���', 'CEO001', 'Y', null, null);
insert into tdept values('CSO001', '�����Ѱ���', 'CEO001', 'Y', null, null);

insert into temp(
    EMP_ID,
    EMP_NAME,
    BIRTH_DATE,
    DEPT_CODE,
    EMP_TYPE,
    USE_YN,
    TEL,
    HOBBY,
    SALARY,
    LEV,
    EVAL_YN
) values (
    --20180101, '�����', add_months(sysdate, -45*12), 'CEO001', '����', 'Y', '01040404040', '���׼�', 500000000, 'ȸ��', 'N'
    20180109, '�ҿ', add_months(sysdate, -48*12), 'COO001', '����', 'Y', '01050505050', '���׼�', 300000000, '����', 'N'
);
update temp
set emp_id = 20180109
where emp_id = 20180809;

update tdept
set boss_id = 20190805
where dept_code = 'CSO001';

select * from temp;

select column_name || ',' 
from user_tab_columns
where table_name = 'TEMP';

update temp
set dept_code = 'CTO001'
where emp_id = '20190803';
select * from temp;
update temp
set dept_code = 'CSO001'
where emp_id = '20190805';
/*
    ���� ó�� �����ʿ�: tdept
    CEO001	��ǥ�̻��		Y	����	20180101
    COO001	��Ѱ���	CEO001	Y	����	20180809
    CTO001	����Ѱ���	CEO001	Y	��õ	20180803
    CSO001	�����Ѱ���	CEO001	Y	����	20190805
    AA0001	�濵����	COO001	Y	����	19970101
    AB0001	�繫	AA0001	Y	����	19960101
    AC0001	�ѹ�	AA0001	Y	����	19970201
    BA0001	�������	CTO001	Y	��õ	19930331
    BB0001	H/W����	BA0001	Y	��õ	19950303
    BC0001	S/W����	BA0001	Y	��õ	19966102
    CA0001	����	CSO001	Y	����	19930402
    CB0001	������ȹ	CA0001	Y	����	19960303
    CC0001	����1	CA0001	Y	����	19970112
    CD0001	����2	CA0001	Y	����	19960212
*/
commit;

/*
    1. DEPT �� �μ��ڵ�� �����μ��ڵ� ������ �̿��� CEO001���� ������ TOP-DOWN ����� ���� �˻�
    2. DEPT �� �μ��ڵ�� �����μ��ڵ� ������ �̿��� CD0001���� ������ bottom-UP ����� ���� �˻�
    3. CSO001���� �����ϴ� TOP-DOWN ����� �����˻�
    4. 1������ �濵����(AA0001) �� �������� ����
    5. 1������ �濵����(AA0001)�� ������ �������� ����
*/
--1
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept;
--2
select dept_code, dept_name
from tdept
start with dept_code = 'CD0001'
connect by prior parent_dept = dept_code;
--3
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CSO001'
connect by prior dept_code = parent_dept;
--4
select dept_code, dept_name
from tdept
where dept_name != '�濵����'
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept;
--5
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept and dept_name != '�濵����';

/*
    �ǽ� ������ ����
*/
insert into tdept values('CB0002', '������ȹ2', 'CA0001', 'Y', '����', 19960303);
select * from tdept; -- ��� ���� �����Ͱ� �߰���

select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept; -- dept_code�� ���ĵǾ� ����: full scan �� sort

/*
    pemp_id
    �μ��� �ƴ� > �ش� �μ���
    �μ��� > �����μ� �μ���
*/
select temp.emp_id, temp.emp_name, temp.dept_code, boss_id, 
    decode(
        boss_id - emp_id, 0, (), boss_id
    )
from temp left join (select boss_id from tdept left join temp on tdept.parent_detp = temp.dept_code) on temp.dept_code = tdept.dept_code;


select temp.emp_id, temp.emp_name, temp.dept_code, boss_id, 
    decode(
        boss_id - emp_id, 0, (), boss_id
    );

select * from tdept;
update tdept
set boss_id = 20190803
where boss_id = 20180803;


select * from temp where emp_id = 20180109;
select * from temp where emp_id = 20190803;
select * from temp;
sele

select e.emp_id eid, e.emp_name en, d.dept_code d, d.boss_id dbid, db.emp_name dbnm, pd.dept_code pd, pd.boss_id pdbid, pdb.emp_name pdbn
from temp e, tdept d, temp db, tdept pd, temp pdb
where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) and pd.boss_id = pdb.emp_id(+) and d.boss_id = db.emp_id(+);

select eid, en, d, decode(eid - dbid, 0, pdbid, dbid) pid, decode(eid - dbid, 0, pdbn, dbnm) pn
from (
    select e.emp_id eid, e.emp_name en, d.dept_code d, d.boss_id dbid, db.emp_name dbnm, pd.dept_code pd, pd.boss_id pdbid, pdb.emp_name pdbn
    from temp e, tdept d, temp db, tdept pd, temp pdb
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) and pd.boss_id = pdb.emp_id(+) and d.boss_id = db.emp_id(+)
)
-- 4���̺�
select e.*, pe.emp_name pn, pe.dept_code pd
from (
    select e.emp_id eid, e.emp_name en, e.dept_code d, decode(e.emp_id - d.boss_id, 0, pd.boss_id, d.boss_id) pid
    from temp e, tdept d, tdept pd
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) -- ������ left join ����
) e, temp pe
where e.pid = pe.emp_id(+)
order by 1;

order by 1;

create or replace view vemp_boss as
select e.*, pe.emp_name pn, pe.dept_code pd
from (
    select e.emp_id eid, e.emp_name en, e.dept_code d, decode(e.emp_id - d.boss_id, 0, pd.boss_id, d.boss_id) pid
    from temp e, tdept d, tdept pd
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) -- ������ left join ����
) e, temp pe
where e.pid = pe.emp_id(+)
order by 1;

select * from vemp_boss;
/*
    6. 20180101���� �����ϴ� ������ TOP-DOWN �����˻�(�о�ֱ� �ʼ�)
    7. ���Ͼǿ��� �����ϴ� ���� ���� �˻�
*/
--6.
select lpad(eid, length(eid) + (level * 2) - 2, '-') || ' ' || en id -- level(���� ���� ��) Ȱ�� ����
from vemp_boss
start with eid = 20180101
connect by prior eid = pid;

--7.
select lpad(eid, length(eid) + (level * 2) - 2, '-') || ' ' || en id
from vemp_boss
start with eid = (select emp_id from temp where emp_name = '���Ͼ�')
connect by prior pid = eid;
--  �Ʒ� �� �� ���� ���غ���
select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd
from vemp_boss
start with eid = 20180101
connect by prior eid = pid; -- id�� ����

select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd
from vemp_boss
start with eid = 20180101
connect by prior en = pn; -- �̸��� ����

create table emp_boss as select * from vemp_boss;
alter table emp_boss add constraint emp_boss_pk primary key (eid);
create index inx_enm1 on emp_boss(en);

alter table emp_boss add salary number;
update emp_boss
set salary  = (select salary from temp where emp_id = eid);

select * from emp_boss;
select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd, salary, 
    (select sum(salary) from emp_boss t start with t.eid = e.eid connect by prior t.eid = t.pid) ssal
from emp_boss e
start with eid = 20180101
connect by prior eid = pid -- �̸��� ����
