/*
    0715: ���̺� ���� �� ����
    
    ���̺�: ���������� �����ϴ� '������ ����' ������
    ��: Select������ ��������� ������ ���̺�
    ������: ������ ��ȣ(�ַ� PK��)�� �ڵ����� �߻���Ű�� ��ü
    �ε���: ���� ���� ����� ���� ����ϴ� ������ ���� ����
    �ó��: ��ü�� ���� �̸� �ο�
*/

-- ���̺� ������ �������� ����
create table test_tab2(
    id number(2),
    name varchar2(10),
    constraint id_pk primary key (id) -- pk
);
create table emp_tab(
    empno number(4),
    ename varchar2(10),
    deptno number(2) not null,
    constraint emp_deptno_fk foreign key(deptno) -- fk
    references department(deptno)
);
create table uni_tab2(
    deptno number(2),
    dame char(14),
    constraint uni_tab_deptno_uk unique (deptno) -- uk
);
create table nn_tab1(
    deptno number(2) not null, -- not null
    dname char(14),
    loc char(13)
);
create table ch_tab2(
    deptno number(2),
    dname char(14),
    loc char(13),
    constraint uni_tab_deptno_ck check -- check
    (deptno IN (10, 20, 30, 40, 50))
);
alter table emp_tab -- �����߰�
add constraint emp_ename_uk unique (ename);
alter table emp_tab -- �������
drop constraint emp_ename_uk;
alter table emp_tab -- ���� ��Ȱ��ȭ
disable constraint emp_deptno_fk;
alter table emp_tab -- ���� Ȱ��ȭ
enable constraint emp_deptno_fk;
-- ���̺� ���� ��ȸ
select constraint_name, constraint_type, search_condition
from user_constraints
where table_name = '';
-- �÷� ���� ��ȸ
select constraint_name, column_name
from user_cons_columns
where table_name = '';
select * from temp;

-- select�����κ��� ���̺� ����
create table emp_30 as
    select emp_id, emp_name, emp_type, birth_date, salary
    from temp
    where dept_code = 'AA0001';
-- �÷� ����
alter table bonus -- �߰�
    add (etc varchar2(16));
alter table emp_30 -- Ÿ�Ժ���
    modify (emp_name varchar2(15));
alter table bonus -- ����
    drop (etc);

-- ���̺� ����
drop table emp_30; -- ����
rename emp_tab to emp_tab2; -- �̸�����

-- ��Ÿ
truncate table emp_tab2; -- ����� ���� (����: delete�� �ٸ��� �ѹ� �Ұ�)
comment on table emp_tab2 is 'employee information'; -- �ּ�

/*
    �� ���� ���̺� �����

    1. role, table, priv����� create����
    2. �÷� ������ alter������
    3. comment�� Logical name
    4. default ��
*/
-- ���̺� �� ����
create table obj (
    objcd number not null,
    obj_name varchar2(30),
    constraint obj_pk primary key (objcd) -- pk
);
create table priv (
    privcd number not null,
    priv_name varchar2(30),
    constraint priv_pk primary key (privcd) -- pk
);
create table obj_priv (
    objcd number,
    privcd number
);
alter table obj_priv add constraint obj_priv_obj_fk foreign key (objcd) references obj(objcd);
alter table obj_priv add constraint obj_priv_priv_fk foreign key (privcd) references priv(privcd);
alter table obj_priv add constraint obj_priv_pk primary key (objcd, privcd);
create table usr (
    user_name varchar2(30) not null,
    constraint usr_pk primary key (user_name) -- pk
);
create table rol (
    rolecd number not null,
    role_name varchar2(30),
    constraint rol_pk primary key (rolecd) -- pk
);
create table usr_role (
    user_name varchar2(30),
    rolecd number
);
alter table usr_role add constraint usr_role_usr_fk foreign key (user_name) references usr(user_name);
alter table usr_role add constraint usr_role_role_fk foreign key (rolecd) references rol(rolecd);
alter table usr_role add constraint usr_role_pk primary key (user_name, rolecd);
create table role_priv (
    rolecd number,
    objcd number,
    privcd number
);
alter table role_priv add constraint role_priv_role_fk foreign key (rolecd) references rol(rolecd);
alter table role_priv add constraint role_priv_obj_priv_fk foreign key (objcd, privcd) references obj_priv(objcd, privcd);
alter table role_priv add constraint role_priv_pk primary key (rolecd, objcd, privcd);

-- �ּ�
comment on table obj is '������Ʈ'; 
comment on table priv is '����'; 
comment on table obj_priv is '������Ʈ������'; 
comment on table role_priv is '�Ѻ�����'; 
comment on table rol is '��'; 
comment on table usr_role is '����ں���'; 
comment on table usr is '�����';
comment on column obj.objcd is '������Ʈ�ڵ�';
comment on column obj.obj_name is '������Ʈ��';
comment on column priv.privcd is '�����ڵ�';
comment on column priv.priv_name is '���Ѹ�';
comment on column obj_priv.objcd is '������Ʈ�ڵ�';
comment on column obj_priv.privcd is '�����ڵ�';
comment on column role_priv.objcd is '������Ʈ�ڵ�';   
comment on column role_priv.privcd is '�����ڵ�';
comment on column role_priv.rolecd is '���ڵ�';
comment on column rol.rolecd is '���ڵ�';
comment on column rol.role_name is '���̸�';
comment on column usr_role.rolecd is '���ڵ�';
comment on column usr_role.user_name is '����ڸ�';
comment on column usr.user_name is '����ڸ�';

-- check
alter table priv add constraint priv_name_ck check (priv_name in ('insert', 'delete', 'update', 'select'));
alter table usr modify (user_name default 'newuser');

-- 0. ���̺�, �÷� Ȯ��
select a.table_name, b.column_name
from user_tables a, user_tab_columns b
where a.table_name = b.table_name
    and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'ROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- PK Ȯ��
select a.constraint_name, b.column_name from user_constraints a, user_cons_columns b
where constraint_type = 'P' and a.constraint_name = b.constraint_name and a.constraint_type = 'P'
and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'ROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- ���� ���� Ȯ��
select a.constraint_name, a.table_name, c.column_name as colname, a.r_constraint_name as fk_pk_name,b.table_name as fk_table, b.column_name as fk_col 
from user_constraints a, user_cons_columns b , user_cons_columns c
where a.constraint_type = 'R'
and a.r_constraint_name = b.constraint_name and a.constraint_name = c.constraint_name
and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'TROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- rename, alter �ǽ�
rename obj to tobject;
rename usr to tuser;
rename rol to trole;
rename priv to tcurd;
rename obj_priv to tprivs;
rename role_priv to trol_priv;
rename usr_role to trol_user;

-- �÷� Ÿ�� ���� �ǽ�
alter table tcurd modify priv_name varchar2(50);