/*
    0711 
*/
commit;

-- Rollback
delete from emp_copy;
rollback;

-- Rollback and Savepoint
update emp_copy set department_id = 60
where employee_id = 101;
savepoint A;
delete from emp_copy;
rollback to A; -- savepoint A�� �ѹ�

/*
��������� �ѹ�
- oracle������ �Ͻ������� ������� savepoint�� �����ϹǷ� ���� �߻��� �ش� �������� �ѹ��� �� ���� �۾��� ������
- ����, ������� �ѹ� ���� ����ڴ� �ݵ�� ��������� commit �Ǵ� rollback�� �����
*/

-- ����� ����
-- ����� ����(create user [id] identified by [pw])
create user user01 identified by pass;
-- ����� pw����
alter user user01 identified by pass01;
-- ���� �ο�
grant create session to user01; -- �ý��� ����
grant select on departments to user01, scott; -- ����� ����
grant update (location_id) on departments to user01; -- �÷��� ���� ���� ����
grant select on departments to user01 with grant option; -- �������� ����ڰ� �ش� ������ �ٸ� ����ڿ��� ��ο� ����
grant update on study01.departments to public; -- ��� ����ڿ��� ���� �ο�
-- ���� ����
revoke select, update on departments from user01;
-- ��: ���� ����
create role man_role; -- �� ����
grant create table, create view to man_role; -- �ѿ� ���� ����
grant man_role to user01; -- ����ڿ� �� �ο�
-- �ο��� ���� Ȯ��
select * from role_sys_privs; -- role�� �ο��� �ý��� ����
select * from role_tab_privs; -- role�� �ο��� ���̺� ����
select * from user_role_privs; -- ���� ������ �ο����� ��
select * from user_tab_privs_made; -- ���� ������ �ο��� ��ü ����
select * from user_tab_privs_recd; -- ���� ������ �ο����� ��ü ����
select * from user_col_privs_made; -- ���� ������ �ο��� �÷� ����
select * from user_col_privs_recd; -- ���� ������ �ο����� �÷� ����

/*
    1. �����ڿ� ���� ������ �� row lock�� �߻�
    2. row�� ������ ���� lock�� ȹ���� ������ row�� ���ÿ� �����Ϸ��� ���� ������ ����
    3. select�� ���� �ܼ��� �б⸸�� �ϴ� Ʈ������� ���� Ʈ������� �������� ���մϴ�.
    4. ���� Ʈ������� lock�� �ɴ��� �ٸ� Ʈ������� �б⸦ �������� ���մϴ�.
*/
-- lock �˾ƺ���
-- pre: ���� ���� �߰��� �ϳ��� ����ڷ� ���� ���� ������ ���� �����
update temp set hobby = 'Ȱ���' where emp_name = '�̼���'; -- update
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- lock�� �� �� ����
rollback;
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- �ѹ� �� lock ������
update temp set hobby = 'Ȱ���' where emp_name = '�̼���'; -- update
-- �ٸ� ����
select * from temp where emp_name = '�̼���'; -- ��ȭ ����(lock����)
-- ���� ����
rollback;
update temp set hobby = 'Ȱ���' where emp_name = '�̼���'; -- update
-- �ٸ� ����
update temp set lev = '�屺' where emp_name = '�̼���'; -- ���� �ȵǰ� ������ ����
-- ���� ����
commit; -- ���� Ǯ���鼭 �ٸ� ������ update���� ���� �����
update temp set lev = '�屺' where emp_name = '�̼���';
-- �ٸ� ����
commit;
-- ���� ����
select * from temp where emp_name = '�̼���'; -- hobby�� 'Ȱ���', lev�� '�屺'����

-- select�� update ���̿� �ٸ� ���ǿ��� ������ ����� ������ ���� �߻� ����
select * from temp where emp_name = '�̼���' for update nowait; -- select�ܰ迡�� lock�� �ɱ�
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- lock ���� Ȯ��
rollback;
-- ��������
update temp set lev = '�屺' where emp_name = '�̼���';
-- �ٸ�����
select * from temp where emp_name = '�̼���' for update nowait; -- err: lock������ nowait�Ұ���
rollback;

-- deadlock ��Ȳ �����
-- ��������
update temp set hobby = '��Ÿ��' where emp_name = '�̼���'; -- update
-- �ٸ�����
update temp set hobby = '��Ÿ��' where emp_name = 'ȫ�浿'; -- update
-- ��������
update temp set hobby = '��������' where emp_name = 'ȫ�浿'; -- waiting
-- �ٸ�����
update temp set hobby = '��������' where emp_name = '�̼���'; -- waiting
-- ��������
-- ORA-00060: �ڿ� ����� ���� ���°� ����Ǿ����ϴ� (����� ����)
-- �ٸ�����
-- ��� waiting

/*
   ����1. UPDATE DML�� TRANSACTION�� �����ϰ�
   TRANSATION�� ������ �� �ִ� ����� ��� ����ϰ�
   �� ����� ���� Ʈ����� ���� ��Ȳ�� �����ϰ� Ȯ�ι��� �ۼ�.
   
*/
--�ϳ��� dml
update temp set lev = '�屺' where emp_name = '�̼���';
--commit;
commit;
--rollback
rollback;
-- DDL = commit
create table test(
    test_id number
);
-- DCL = commit
grant create session to user01;
-- ���� ���� = commit
update temp set lev = '�ӽ�' where emp_name = '�̼���';
connect scott / tiger;
connect study01/study01;
select * from temp where emp_name = '�̼���';
-- ���� ��� ���� = commit
update temp set lev = '��Ÿ��' where emp_name = '�̼���';
exit;
-- sqlplus ��������(â�ݱ�) = rollback�� ����, ��Ǯ��
update temp set lev = 'ttt' where emp_name = '�̼���';
rollback;

/*
    2. SAVEPOINT
   2.1 STUDY01���� TI_DATA�� MAX(NO) Ȯ�� 
   2.2 Ȯ�ε� NO���� 1  ���� ���� �������� T1_DATA���� DELETE ����    
   2.3 ���� ���� Ȯ�� �� SAVEPOINT T1_1 ����
   2.4 1.1���� Ȯ���� NO ������ DELETE ����
   2.5 �������� Ȯ��
   2.6 T1_1 SAVEPOINT�� ROLLABCK ���� 
   2.7 T1_1 SAVEPOINT ���� ���� �����ʹ� ���� ���� ���°� ���� �����ʹ� ROLLABACK���� ����Ȯ��
   2.8 ROLLBACK �������� ���� ����
*/
select max(no) from t1_data; -- 2.1, 10000
delete t1_data where no = (select max(no) from t1_data) - 1; -- 2.2
savepoint t1_1; --2.3
delete t1_data where no = (select max(no) from t1_data); -- 2.4
select no from t1_data where no = 9999; -- null, 2.5
rollback to t1_1; -- 2.6
select no from t1_data where no > 9997; -- 2.7, 9998 9999
rollback; --2.8

/*
3.STUDY01�� �α����� STUDY03 ���� ���� ? PASSWORD�� ��PASS01��
4. STUDY03�� PASSWORD�� USER��� �����ϰ� ����
5. STUDY03���� ���ǻ���, ���̺����, ����� ������ �ο�
5-1 STUDY03�� CONNECT �� ������ ���̺�� �� ���� Ȯ��
6. STUDY03���� T1_DATA INSERT, UPDATE ���� �ο�
7. STUDY03���� T2_DATA SELECT, UPDATE ���� �ο� (WITH GRANT OPTION ����);
8. STUDY03���� STUDY02���� T1_DATA �� T2_DATA�� UPDATE ���� �ο� 
9. PUBLIC�� TEMP SELECT ���� �ο�
*/
create user study03 identified by pass01; --3
alter user study03 identified by study03; --4
grant create session, create table, create view to study03; --5
connect study03/study03;
create table test_study03(test_id number); --5-1
create view test_view as select * from test_study03;
connect study01/study01;
grant insert, update on t1_data to study03; --6
grant select, update on t2_data to study03 with grant option; --6
connect study03/study03;
grant update on t1_data to study02; --8 ORA-01031: ������ ������մϴ�
grant update on t2_data to study02; --8
grant select on temp to public; --9
connect study03/study03;
select * from study01.temp; -- ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�

/*
    �߰�����
study01�� �λ�ý��� user�̸�, study03�� �繫 �ý��� user�Դϴ�.
�繫 �ý��ۿ��� �λ� �ý��ۿ� ��������, �μ������� ���� ��ȸ ���Ѱ� ���������� ���� �Է±����� ��û�մϴ�.
������ �� �� �ٸ� �ý��ۿ��� �߻��� �� �ִ� ����� ������ ��û�� �����ϱ� ����,
�λ�ý��� �����ڴ� �λ��������� �̿��� �� �ִ� ������ ���̺� ����
1. �ܼ� �б� ����, 2. �������, 3. �Է±���, 4. ������������ ������ �����ϰ��� �մϴ�.
���� �ý��ۺ� ��û�� ���� ������ ������ 4���� ������ �������� �ο��ϰ��� �մϴ�.
(���� ������ ���̺� ���������� �մϴ�.)
��, �λ��������� �ο��� ������ ������ �ο� ���� �ý����� �ٸ� �ý��ۿ� ��ο��� �� ���� �� �����̸�,
���ǵ� role������ ������ ���� ������ �������� grant�� ������� ���� �����Դϴ�.
�̿� ���� ���� ����� ������ �� �繫 �ý��ۿ� �� �����ϰ��� �մϴ�.
���� �λ��������� ���� ������ �ο��� ���¸� ��ȸ�� �� �־�� �մϴ�.
���� ���õ� ���� �ο� ��å�� ������ ���̺� �����ͷ� �����Ͽ� ���� �ο����¿� ���÷� ���ϰ��� �մϴ�.
���õ� ������ ���̺��� ������ �����ϰ�, ���� ��å�� �Է��ϸ�,
���õ� ���� ��å�� ���� ����ǰ� �ִ��� Ȯ���ϴ� ������ �ۼ��Ͻÿ�.
*/
