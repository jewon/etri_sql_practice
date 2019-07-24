/*
    0718: sequence
    
*/
-- scott
-- ������: '���������� �ο��ϴ� ���� ��ȣ'
-- ������ ����
create sequence dept_deptno
    increment by 1
    start with 91
    maxvalue 99
    nocache
    nocycle;
-- ����� ������ ��ųʸ�
select * from user_sequences;
-- ������ ���
-- nextval: ���� ��밡���� ������ ��, curval: ���� ������ �� ��ȯ
insert into dept values(dept_deptno.nextval, '������', '�д籸 ���ڵ�');
-- ĳ�� ������
create sequence dept_deptno2
    increment by 1
    start with 91
    maxvalue 99
    cache 3
    nocycle;
-- ������ ����
drop sequence dept_deptno;
drop sequence dept_deptno2;
/*
�ε���: ����(Ž��) �ӵ� ���
    where, join��� ���� ���Ǵ� �÷�
    �������� ���� ������ �÷�
    �ټ��� null�� �����ϴ� �÷�
    ���̺��� ũ��, ���� ����� ��ü ���� 2~4% ������ ��
    ���Ž� �ε����� ���ŵǾ�� �ϹǷ� ���� ���ŵǴ� ���̺� ������
*/
-- PK, UK����� �ڵ� ���� / ����� ���� ����
create index emp_ename_idx on emp(ename);
-- �ε��� Ȯ��
select c.index_name, c.column_name, c.column_position, i.uniqueness
from user_indexes i, user_ind_columns c
where c.index_name = i.index_name
and c.table_name = 'EMP';
-- ����� ���� �ε���
create index upper_emp_ename_idx on emp(upper(ename));
create index upper_emp_salary_idx on emp(upper(sal));
drop index upper_emp_salary_idx;
drop index upper_emp_ename_idx;

-- study01
-- �ó��: ��Ű�� �̸� ��þ��ص� ���� �����ϰ�
-- �ó�� ����
create synonym gubun for scott.salgrade;
select * from gubun;
drop synonym gubun;

-- �ǽ�
--1.
create sequence ext_no
    increment by 1
    start with 1
    maxvalue 1000
    nocache
    nocycle;
--2.
select * from user_sequences where sequence_name = 'EXT_NO';
--3.
select ext_no.currval from dual; -- ORA-08002: ������ EXT_NO.CURRVAL�� �� ���ǿ����� ���� �Ǿ� ���� �ʽ��ϴ�
--4.
select ext_no.nextval from dual;
select ext_no.currval from dual;
--5.
select ext_no.currval from dual;
--6.
-- �� ���ǿ��� ���ο� ��ȣ�� ä���ϴ��� �ٸ� ���ǿ��� currval�� �״���̴�.
--7.
alter table t1_data add (prod_am number);
--8
update t1_data
set prod_am = ext_no.nextval
where no < 10;
--9.
create table tseq1 as select ext_no.nextval from temp;
--10.
alter sequence ext_no
    cache 10;
select * from user_sequences where sequence_name = 'EXT_NO';
--11.
insert into tseq1 values(ext_no.nextval);
d

insert into t1_data (no)
select no + 10000
from t1_data;

insert into t1_data (no)
select a.no + 10000 * b.no
from t1_data a, t1_data b
where b.no < 21;

/*
1. USER_INDEXES �� USER_IND_COLUMNS �� �̿� INDEX �� ��ȸ�ϰ� 
   � �ε����� PRIMARY KEY �� UNIQUE INDEX �̰� ��� ���� �Ϲ�
   �ε��� ���� ���� 
*/
select * from user_indexes where uniqueness = 'UNIQUE';
select * from user_ind_columns;

select a.index_name, a.table_name, a.uniqueness, b.constraint_type
from user_indexes a, user_constraints b
where b.constraint_name(+) = a.index_name;

create unique index uk_emp_name on temp(emp_name);

/*
2. SALARY�� õ�� ������ ������ ���� ������ �����Ͽ� ����, õ�������޿�, 
   �̸� ������ ������ �ϵ�, INDEX�� �̿��� ������ �ϰ� ���� ��� �ε��� ����
3. T1_DATA�� SALARY, TABLE_NAME �÷��� T1_INX1 �̸����� �����ε��� ����
   (DICTIONARY VIEW ���� ���� Ȯ��)
4. STUDY02���� STUDY01�� TEMP �� ���� PUBLIC SYNONYM �� 
   TEMP ��� �̸����� ����
5. STUDY02���� STUDY01�� TDEPT �� ���� �Ϲ� SYNONYM �� 
   TDEPT ��� �̸����� ����
6. STUDY03���� SCHEMA ���� ���� TEMP�� TDEPT���� ���� SELECT ��� Ȯ��
*/
--2.
select lev, trunc(salary / 10000000) as sal_10mil, emp_name, emp_id from temp order by 1, 2 desc, 3;
create index temp_sal10mil_idx on temp(trunc(salary / 10000000));

explain plan for
select /*+index_DESC(temp, temP-sal10mil_idx) */lev, trunc(salary / 10000000) as sal_10mil, emp_name, emp_id from temp order by 1, 2 desc, 3;

select plan_table_output from table(dbms_xplan.display());
--3.
create index t1_inx1 on t1_data(no, prod_am);
select * from user_indexes where index_name = 'T1_INX1';
--4.
-- study2
create public synonym temp for study01.temp;
--5.
create synonym tdept for study01.tdept; --ERR ORA-01471: ��ü�� ���� �̸��� ���Ǿ�� �ۼ��� �� �����ϴ�
create synonym tdepts for study01.tdept;
--6.
select * from temp;
select * from tdept; -- ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�
--7. 8. 9.
create table tdept as
    select * from study01.tdept where area = '��õ';
create synonym tdept for study01.tdept;-- ORA-00955: ������ ��ü�� �̸��� ����ϰ� �ֽ��ϴ�.
select * from tdept; -- ���̺��� �ó�Ժ��� ����
--10.
-- ���̺� > �ó�� > public
create table tdept2 as
    select * from study01.tdept where area = '��õ';
create public synonym tdept for study01.tdept;
create synonym tdept for tdept2;
--11. 12.
drop synonym tdept;
drop public synonym tdept;



