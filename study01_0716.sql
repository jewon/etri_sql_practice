/*
    0716: SQL �߰� Review
*/

-- �ǽ����̺� �����
CREATE TABLE TCRUD(
CRUD_CD VARCHAR2(01),
CONSTRAINT R_CRUD_PRIV_1 PRIMARY KEY (CRUD_CD)
);
CREATE TABLE TOBJECT(
OBJ_NM VARCHAR2(30),
CONSTRAINT R_OBJ_PRIV_1 PRIMARY KEY (OBJ_NM)
);
CREATE TABLE TROL_PRIV(
PRIV_ID NUMBER,
ROLE_CD VARCHAR2(30),
CONSTRAINT R_PRIV_PRIV_1 PRIMARY KEY(PRIV_ID,ROLE_CD)
);
CREATE TABLE TUSER(
USER_NM VARCHAR2(20),
CONSTRAINT R_USER_ROLE_1 PRIMARY KEY (USER_NM)
);
CREATE TABLE TROLE(
ROLE_CD VARCHAR2(30),
ROLE_EXP VARCHAR2(200),
CONSTRAINT R_ROLE_PRIV_1 PRIMARY KEY (ROLE_CD)
);
CREATE TABLE TPRIVS(
PRIV_ID NUMBER,
OBJ_NM VARCHAR2(30),
CRUD_CD VARCHAR2(03),
CONSTRAINT R_TPRIVS_PRIV_1 PRIMARY KEY (PRIV_ID)
);
CREATE TABLE TROL_USER(
USER_NM VARCHAR2(20),
ROLE_CD VARCHAR2(30),
CONSTRAINT R_USER_PRIV_1 PRIMARY KEY(USER_NM,ROLE_CD)
);
ALTER TABLE TPRIVS
ADD CONSTRAINT RR_CRUD_PRIV_1 FOREIGN KEY (CRUD_CD) REFERENCES TCRUD(CRUD_CD);
ALTER TABLE TPRIVS
ADD CONSTRAINT RR_OBJ_PRIV_1 FOREIGN KEY (OBJ_NM) REFERENCES TOBJECT(OBJ_NM);

ALTER TABLE TROL_PRIV
ADD CONSTRAINT RR_PRIV_ROLE_1 FOREIGN KEY (PRIV_ID) REFERENCES TPRIVS(PRIV_ID);
ALTER TABLE TROL_PRIV
ADD CONSTRAINT RR_ROLE_PRIV_1 FOREIGN KEY (ROLE_CD) REFERENCES TROLE(ROLE_CD);

ALTER TABLE TROL_USER
ADD CONSTRAINT RR_ROLE_USER_1 FOREIGN KEY (ROLE_CD) REFERENCES TROLE(ROLE_CD);
ALTER TABLE TROL_USER
ADD CONSTRAINT RR_USER_ROLE_1 FOREIGN KEY (USER_NM) REFERENCES TUSER(USER_NM);

ALTER TABLE TCRUD
ADD CONSTRAINT TCRUD_IN CHECK (CRUD_CD IN('I','S','U','D'));

-- �ڷ� ����
insert into tcrud(crud_cd) values('I');
insert into tcrud(crud_cd) values('S');
insert into tcrud(crud_cd) values('D');
insert into tcrud(crud_cd) values('U');
insert into tobject(obj_nm) select object_name from user_objects where object_type in ('TABLE', 'VIEW', 'PROCEDURE');
insert into tuser(user_nm) select username from all_users where created > to_date('190101', 'YYMMDD');
insert into tprivs(priv_id, obj_nm, crud_cd) select rownum, tobject.obj_nm, tcrud.crud_cd from tobject, tcrud;

desc trole;
insert into trole values('DEPT_SUI', '�μ���������(����,����)');
insert into trole values('DEPT_SUID', '�μ���������(����)');
insert into trole values('DEPT_S', '�μ�������ȸ(��ȸ)');
insert into trole values('DEPT_SUI', '�μ���������(����,����)');
insert into trole values('DEPT_SUI', '�μ���������(����,����)');
insert into trole values('EMP_SUI', '������������(����,����)');
insert into trole values('EMP_SUID', '������������(����)');
insert into trole values('EMP_S', '����������ȸ(��ȸ)');
insert into trole values('DE_SUI', '�����μ���κ���');
insert into trole values('DE_SUID', '�����μ���λ���');
insert into trole values('DE_S', '�����μ������ȸ');
insert into trole values('ALL_S', 'study01 ������ ��� ���̺� ���� ��ȸ');
insert into trole values('ALL_SUI','study01 ������ ��� ���̺� ���� ����');
insert into trole values('ALL_SUID', 'study01 ������ ��� ���̺� ���� ��� ����');


select substr(role_cd, 0, instr(role_cd, '_') - 1) from trole;
select substr(role_cd, instr(role_cd, '_') + 3, 1) from trole;

-- ALL + Select
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'ALL'
    and substr(t.role_cd, instr(t.role_cd, '_') + 1, 1) = 'S'
    --and p.obj_nm in ('TDEPT, TEMP, ')
    and p.crud_cd = 'S';

-- ALL + update
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'ALL'
    and substr(t.role_cd, instr(t.role_cd, '_') + 2, 1) = 'U'
    --and p.obj_nm in ('TDEPT, TEMP, ')
    and p.crud_cd = 'U';

-- ALL + insert
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'ALL'
    and substr(t.role_cd, instr(t.role_cd, '_') + 3, 1) = 'I'
    --and p.obj_nm in ('TDEPT, TEMP, ')
    and p.crud_cd = 'I';
    
-- ALL + delete
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'ALL'
    and substr(t.role_cd, instr(t.role_cd, '_') + 4, 1) = 'D'
    --and p.obj_nm in ('TDEPT, TEMP, ')
    and p.crud_cd = 'D';

-- DE + SUID
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'DE'
    and substr(t.role_cd, instr(t.role_cd, '_') + 1, 1) = 'S'
    and p.obj_nm in ('TDEPT', 'TEMP')
    and p.crud_cd = 'S';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'DE'
    and substr(t.role_cd, instr(t.role_cd, '_') + 2, 1) = 'U'
    and p.obj_nm in ('TDEPT', 'TEMP')
    and p.crud_cd = 'U';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'DE'
    and substr(t.role_cd, instr(t.role_cd, '_') + 3, 1) = 'I'
    and p.obj_nm in ('TDEPT', 'TEMP')
    and p.crud_cd = 'I';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) = 'DE'
    and substr(t.role_cd, instr(t.role_cd, '_') + 4, 1) = 'D'
    and p.obj_nm in ('TDEPT', 'TEMP')
    and p.crud_cd = 'D';

-- tdept, temp SUID
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) in ('EMP', 'DEPT')
    and substr(t.role_cd, instr(t.role_cd, '_') + 1, 1) = 'S'
    and p.obj_nm = 'T' || substr(t.role_cd, 0, instr(t.role_cd, '_') - 1)
    and p.crud_cd = 'S';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) in ('EMP', 'DEPT')
    and substr(t.role_cd, instr(t.role_cd, '_') + 2, 1) = 'U'
    and p.obj_nm = 'T' || substr(t.role_cd, 0, instr(t.role_cd, '_') - 1)
    and p.crud_cd = 'U';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) in ('EMP', 'DEPT')
    and substr(t.role_cd, instr(t.role_cd, '_') + 3, 1) = 'I'
    and p.obj_nm = 'T' || substr(t.role_cd, 0, instr(t.role_cd, '_') - 1)
    and p.crud_cd = 'I';
insert into trol_priv 
    select p.priv_id, t.role_cd
    from tprivs p, trole t
    where substr(t.role_cd, 0, instr(t.role_cd, '_') - 1) in ('EMP', 'DEPT')
    and substr(t.role_cd, instr(t.role_cd, '_') + 4, 1) = 'D'
    and p.obj_nm = 'T' || substr(t.role_cd, 0, instr(t.role_cd, '_') - 1)
    and p.crud_cd = 'D';
    
insert into tuser values('scott');
insert into trol_user values('scott', 'DE_S');
insert into trol_user values('scott', 'EMP_SUI');
insert into trol_user values('st01', 'ALL_S');
insert into trol_user values('st01', 'EMP_SUID');
insert into trol_user values('CONG', 'DE_SUID');
insert into trol_user values('DM01', 'ALL_S');
insert into trol_user values('STUDY02', 'DEPT_SUID');
insert into trol_user values('STUDY02', 'DE_S');
insert into trol_user values('STUDY03', 'DE_S');
insert into trole values('EMP_I', '�����Է�');
insert into trol_priv values(78, 'EMP_I');
insert into trol_user values('STUDY03', 'EMP_I');

/*
    1.  ROLE CREATE ���� ���� ����
    2.  ROLE �� ���� �ο��ϴ� ���� ���� ����
    3.  ������ ROLE �ο��ϴ� ����
    4.  STUDY03�� � ���̺� ���� � ������ �������� Ȯ���ϴ� ����
*/
-- 1.
select 'create role '|| role_cd || ';' from trole;

-- �ش� ���� ����

-- 2.
select a.role_cd, b.obj_nm, b.crud_cd from trol_priv a, tprivs b where a.priv_id = b.priv_id;
-- grant select on departments to user01 with grant option; -- �������� ����ڰ� �ش� ������ �ٸ� ����ڿ��� ��ο� ����
-- grant create table, create view to man_role; -- �ѿ� ���� ����
select 'grant ' || decode(b.crud_cd, 'S', 'select', 'U', 'update', 'I', 'insert', 'D', 'delete') || ' on ' || b.obj_nm || ' to ' || a.role_cd || ';'
from trol_priv a, tprivs b 
where a.priv_id = b.priv_id;

-- �ش� ���� ����

-- 3.
select * from trol_user;
select 'grant ' || role_cd || ' to ' || user_nm || ';' from trol_user;

-- �ش� ���� ����

-- 4.
select u.user_nm, r.role_cd, p.obj_nm, p.crud_cd
from trol_user u, trol_priv r, tprivs p
where r.priv_id = p.priv_id and u.role_cd = r.role_cd
and u.user_nm = 'STUDY03'
order by 1, 2, 3;
--test��
select * from trol_priv;
select u.*, r.*, p.*
from trol_user u, trol_priv r, tprivs p
where r.priv_id = p.priv_id and u.role_cd = r.role_cd
order by 1;
select * from role_tab_privs;

-- 5.
select u.grantee, p.role, p.table_name, p.privilege
from role_tab_privs p, dba_role_privs u
where p.role = u.granted_role
and p.owner = 'STUDY01'
and u.grantee = 'STUDY03'
order by 1, 2, 3;
-- test��
select u.*, r.*, p.*
from role_tab_privs r, user_tab_privs_made p, dba_role_privs u
where r.role = p.grantee and u.granted_role = r.role and r.owner = 'STUDY01'
order by 1, 2, 3;

-- bonus
-- 0.
select distinct role_cd from trol_priv r, tprivs p where r.priv_id = p.priv_id and p.crud_cd = 'D'; 
select 'revoke ' || r.role_cd || ' from ' || u.user_nm || ';'
from trol_user u, trol_priv r, tprivs p 
where u.role_cd = r.role_cd 
and r.priv_id = p.priv_id 
and crud_cd = 'D';

-- 1.
select * from trol_user where role_cd like '%D';
revoke 