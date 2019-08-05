/*
    0805: PL/SQL�Թ�
*/

declare
    v_fname varchar2(20);
begin
    select first_name
    into v_fname -- select into: ���� ���� ����� ������ ����
    from employees
    where employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('The First Name of the Employee is: '||v_fname); -- DBMS���â�� ���
end;

-- 1. ���� PL/SQL ��� �� ���������� ����Ǵ� ����� �����Դϱ�?
-- a. 
BEGIN
END;
-- b. 
DECLARE
amount INTEGER(10);
END;
-- c. 
DECLARE
BEGIN;
END;
-- d. (O)
DECLARE
amount INTEGER(10);
BEGIN
DBMS_OUTPUT.PUT_LINE(amount);
END;

-- 2. "Hello World"�� ����ϴ� ������ �͸� ����� �����Ͽ� �����մϴ�
begin
DBMS_OUTPUT.PUT_LINE('Hello World');
END;

-- 3. ������ ������ ������ �����Ͽ� �� �� �߸��� ������ �Ǻ��ϰ� �� ������ �����մϴ�.
-- a. (X: �� Ÿ������ ���ÿ� �� ���� ���� �Ұ�)
DECLARE
name,dept VARCHAR2(14);
-- b. (O)
DECLARE
test NUMBER(5);
-- c. (X: =�� �ƴ� :=�� �ʱ�ȭ �ʿ�)
DECLARE
MAXSALARY NUMBER(7,2) := 5000;
-- d. (X: �߸��� ������ Ÿ������ �ʱ�ȭ)
DECLARE
JOINDATE BOOLEAN := SYSDATE;

--3-1.�ڽ��� �̸��� ������ ���� �ٰ� �ٸ� �ٿ� ����ϴ� ������ �͸� ��� ���� �ϱ�
declare
    m_name varchar2(20);
begin
    select emp_name
    into m_name -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_id = '20190401';
    DBMS_OUTPUT.PUT_LINE(m_name || ' ���ѹα�');
end;

declare
    m_name varchar2(20);
begin
    select emp_name
    into m_name -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_id = '20190401';
    DBMS_OUTPUT.PUT_LINE(m_name || chr(10) || '���ѹα�');
end;

--4.�͸� ��Ͽ��� V$ �� V1 �̶�� ������ �����ϰ�, V$�� ���������� �ʱ�ȭ�ϰ�, V1�� �ʱ�ȭ ���� BEGIN���� �� ���� �� ����ϱ�
declare
    V$ varchar2(20) := 'Hello';
    V1 varchar2(20);
begin
    DBMS_OUTPUT.PUT_LINE('V$:' || V$ || '  V1:' || V1);
end;

--5. TEMP ���� �ڱ��̸��� ����� �˻��� ����ϱ�
declare
    m_eid number;
begin
    select emp_id
    into m_eid -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_name = '�����';
    DBMS_OUTPUT.PUT_LINE(m_eid);
end;

--6. 5������ �����, �޿��� �Բ� ���
--5. TEMP ���� �ڱ��̸��� ����� �˻��� ����ϱ�
declare
    m_eid number;
    m_sal number;
begin
    select emp_id, salary
    into m_eid, m_sal -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_name = '�����';
    DBMS_OUTPUT.PUT_LINE(m_eid || ': ' || m_sal);
end;

--7. 5�� ���� ������� ȫ�浿�� �̼����� ����� ��½õ�
declare -- 
    m_eid number;
    m_sal number;
begin
    select emp_id, salary
    into m_eid, m_sal -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_name in ('ȫ�浿', '�̼���');
    DBMS_OUTPUT.PUT_LINE(m_eid || ': ' || m_sal);
end; -- ERR ORA-01422: ���� ������ �䱸�� �ͺ��� ���� ���� ���� �����մϴ�

declare
    m_eid number;
begin
    select emp_id
    into m_eid -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_name = 'ȫ�浿';
    DBMS_OUTPUT.PUT_LINE('ȫ�浿: ' || m_eid);
    
    select emp_id
    into m_eid -- select into: ���� ���� ����� ������ ����
    from temp
    where emp_name = '�̼���';
    DBMS_OUTPUT.PUT_LINE('�̼���: ' || m_eid);
end;

/*
8. �͸� ��Ͽ��� NUMBER(10), VARCHAR2(10) , CHAR(10), DATE Ÿ���� ������
    ���� �� ���� 8�� ������ ��, �� ����(4���� ���� ������ 1����)�� 
   �ʱⰪ �Ҵ��ϰ� �������� �ʱⰪ �Ҵ� ���� 8�� ���� ������ VALUE�� LENGTH ���� ����Ͽ� 
   �ڽ��� ���� ġ�� ���غ��� 
*/
declare -- 
    n1 number(10) := 13;
    n2 number(10);
    v1 varchar2(10) := 'jewon';
    v2 varchar2(10);
    c1 char(10) := 'j';
    c2 char(10);
    d1 date := SYSDATE;
    d2 date;
begin
    DBMS_OUTPUT.PUT_LINE('n1:'||n1||'('||length(n1)||')');
    DBMS_OUTPUT.PUT_LINE('n2:'||n2||'('||length(n2)||')');
    DBMS_OUTPUT.PUT_LINE('v1:'||v1||'('||length(v1)||')');
    DBMS_OUTPUT.PUT_LINE('v2:'||v2||'('||length(v2)||')');
    DBMS_OUTPUT.PUT_LINE('c1:'||c1||'('||length(c1)||')');
    DBMS_OUTPUT.PUT_LINE('c2:'||c2||'('||length(c2)||')');
    DBMS_OUTPUT.PUT_LINE('d1:'||d1||'('||length(d1)||')');
    DBMS_OUTPUT.PUT_LINE('d2:'||d2||'('||length(d2)||')');
end;

-- loop
declare
    lc number := 0;
begin
    loop
        lc := lc + 1;
        exit when lc >= 10; -- ��������
    end loop;
    DBMS_OUTPUT.PUT_LINE(lc);
end;

-- 9. temp���� ��ü �ο��� ���,�̸�,salary �� ����ϴ� pl/sql  block ����
declare
    eid number;
    enm varchar(20);
    esal number;
    e_i number := 0;
    e_n number;
begin
    select count(emp_id) 
    into e_n
    from temp;
    loop
        e_i := e_i + 1;
        select emp_id, emp_name, salary
        into   eid,    enm     , esal
        from (select rownum as eno, e.* from temp e order by emp_id)
        where eno = e_i;
        DBMS_OUTPUT.PUT_LINE(rpad(e_i, 5, ' ') || eid || '(' || rpad(enm, 6, ' ') || '): ' || esal);
        exit when e_i >= e_n;
    end loop;
end;

declare
    eid number;
    enm varchar(20);
    esal number;
    e_i number := 0;
    e_n number;
begin
    select count(emp_id) 
    into e_n
    from temp;
    loop
        e_i := e_i + 1;
        select emp_id, emp_name, salary
        into   eid,    enm     , esal
        from (select rownum as eno, e.* from temp e order by emp_id)
        where eno = e_i;
        DBMS_OUTPUT.PUT_LINE(rpad(e_i, 5, ' ') || eid || '(' || rpad(enm, 6, ' ') || '): ' || esal);
        exit when eid is null; -- ������ �࿡�� ���� ORA-01403: �����͸� ã�� �� �����ϴ�.
    end loop;
end;


declare
    eid number;
    enm varchar(20);
    esal number;
    e_i number := 0;
    e_n number;
begin
    select count(emp_id) 
    into e_n
    from temp;
    loop
        e_i := e_i + 1;
        select emp_id, emp_name, salary
        into   eid,    enm     , esal
        from (select rownum as eno, e.* from temp e order by emp_id)
        where eno = e_i;
        DBMS_OUTPUT.PUT_LINE(rpad(e_i, 5, ' ') || eid || '(' || rpad(enm, 6, ' ') || '): ' || esal);
        exit when eid is null; -- ������ �࿡�� ���� ORA-01403: �����͸� ã�� �� �����ϴ�.
    end loop;
end;

-- 10. N1, N2�̶�� NUMBER Ÿ�� ������ �����ϵ� N2�� �� �� �����ϰ� N1���� �ʱⰪ�� �Ҵ��� N1 �� ����ϱ�
declare
    N1 number := 1;
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(N1);
end;


/*
11. 10������ N2�� �߰��� ����ϱ� ���� �� ���� Ȯ��
12. 10������ N1 ������Ī�� 1N ���� �ٲٰ� ���� �� ���� Ȯ�� �ϱ�
13. CONS1 �̶�� NUMBER�� ����� �����ϰ� �ʱ� �� �Ҵ� ���� ��� �� �������� Ȯ���ϱ�
����̸� CONSTANT VARCHAR2(10);
*/

--11.
declare
    N1 number := 1;
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(N1);
    DBMS_OUTPUT.PUT_LINE(N2);
end; -- ORA-06550: �� 7, ��26:PLS-00371: N2'�� ���� �ִ� �ϳ��� ���� ���˴ϴ�.

--12.
declare
    1N number := 1; -- ORA-06550: �� 2, ��5:PLS-00103: �ɺ� "1"�� �������ϴ� ���� �� �ϳ��� ���� ��: begin
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(1N);
end;

--13.

/*
    ���ν��� ���� �ǽ�
*/
create or replace procedure p_test1 as
begin 
    insert into tdate(D1) values(sysdate);
end;

select * from tdate;
truncate table tdate;
execute p_test1;

/*
    ��� ���� �ǽ�
*/
--����
create or replace function f_test1 return number is
    res number := 0;
begin
    select count(*)
    into res
    from tdate;
    return res;
end;
--����Ȯ��
select *
from user_objects
where object_type = 'FUNCTION'
and object_name = 'F_TEST1';
--�۵�Ȯ��
select f_test1 from dual;

/*
bonus
�Ʒ� ���� �����ϴ� �͸��� ����
1. TEMP1 DATA ��� ����
2. TEMP���� ��̰� NULL�� ������ �о TEMP1�� Insert ... Select
3. TEMP1���� SALARY�� 10%�λ�
*/
-- 1.
begin
    delete temp1;
    insert into temp1
    select * from temp
    where hobby is null;
    update temp1
    set salary = round(salary * 1.1);
end;
-- 2.
begin
    create table temp2 as
    select * from temp1;
end; -- ORA-06550: �� 2, ��5:PLS-00103: �ɺ� "CREATE"�� �������ϴ� ���� �� �ϳ��� ���� ��
-- 3.
begin
    drop table temp1;    
end; -- ORA-06550: �� 2, ��5:PLS-00103: �ɺ� "DROP"�� �������ϴ� ���� �� �ϳ��� ���� ��
-- 4.
begin
    grant select on tdept to cong;
end; -- ORA-06550: �� 2, ��5:PLS-00103: �ɺ� "GRANT"�� �������ϴ� ���� �� �ϳ��� ���� ��
-- 5.
begin
    insert into study05.input_plan
        select plan_seq, '20191101', 'L01', spec_code
        from study05.input_plan
        where input_plan_date = '20191001'
        and line_no = 'L01';
    delete study05.input_plan
        where input_plan_date = '20191001'
        and line_no = 'L01';
end;
select * from study05.input_plan;
rollback;

--6. �͸��Ͽ��� TDATE DATA ��� �����ϰ� P_TEST1�� ȣ�� �� COMMIT;
--  �͸�� ���� �� ��� Ȯ�� P_TEST1;
begin
    delete tdate;    
    p_test1;
end;

--7.
declare
    end_v number := 0;
    now_v number := 0;
    sum_v number := 0;
begin
    loop
        sum_v := 0;
        now_v := 0;
        end_v := end_v + 1;
        loop
            now_v := now_v + 1;
            sum_v := sum_v + now_v;
            exit when now_v >= end_v;
        end loop;
        DBMS_OUTPUT.PUT_LINE('1 ���� ' || end_v || '���� ���� ���� '|| sum_v || '�Դϴ�');
        exit when end_v >= 10;
    end loop;
end;

/*
����ó�� ���� �߰�����(�߿�)
begin...(begin...end)...end ����
���ο��� ���� �߻��� - ���ο��� exeption ó��: �ܺο����� �� ���� ���� �״�� ����
                   - exeptionó�� �Ŀ� raise�ϸ� ���� ���� �����ϰ� �ܺη� ���� ����
                   - exeptionó�� ����: �ܺη� ���� ���޵�          
*/