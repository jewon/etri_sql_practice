/*
    0806: PL/SQL variables
*/
SET SERVEROUTPUT ON
declare
    event varchar2(15);
begin
    event := q'!Father's day!';
    DBMS_OUTPUT.PUT_LINE('3rd Sunday in June is : ' || event);
    event := q'[Mother's day]';
    DBMS_OUTPUT.PUT_LINE('2nd Sunday in May is : ' || event);
end;

declare
    bf_var binary_float;
    bd_var binary_double;
begin
    bf_var := 270/35f;
    bd_var := 140d/0.35;
    dbms_output.put_line('bf: '|| bf_var);
    dbms_output.put_line('bd: '|| bd_var);
end;

VARIABLE result NUMBER
BEGIN
    SELECT (SALARY*12) + NVL(COMMISSION_PCT,0) INTO :result
    FROM employees WHERE employee_id = 144;
END;
/
PRINT result;

VARIABLE emp_salary NUMBER
SET AUTOPRINT ON
BEGIN
    SELECT salary INTO :emp_salary
    FROM employees WHERE employee_id = 178;
END;
/

SET VERIFY OFF
VARIABLE emp_salary NUMBER
ACCEPT empno PROMPT 'Please enter a valid employee
number: '
SET AUTOPRINT ON
DECLARE
    empno NUMBER(6):= &empno;
BEGIN
    SELECT salary INTO :emp_salary FROM employees
    WHERE employee_id = empno;
END;
/

SET VERIFY OFF
DEFINE lname= Urman
DECLARE
    fname VARCHAR2(25);
BEGIN
    SELECT first_name INTO fname FROM employees
    WHERE last_name='&lname';
END;
/

/*
    1. ������ �ĺ��ڿ� �������� �ĺ��� �̸��� �����մϴ�.
     a. today
     b. last_name
     c. today��s_date
     d. Number_of_days_in_February_this_year
     e. Isleap$year
     f. #number
     g. NUMBER#
     h. number1to7
*/
declare
    today date;
begin
    dbms_output.put_line(today);
end;

/*
2. ���� ���� ���� �� �ʱ�ȭ�� �������� �ĺ��մϴ�.
 a. number_of_copies PLS_INTEGER; 
 b. printer_name constant VARCHAR2(10);
 c. deliver_to VARCHAR2(10):=Johnson; (X)
 d. by_when DATE:= SYSDATE+1;
*/
-- b.(X)
declare
    printer_name constant VARCHAR2(10); -- ORA-06550: �� 2, ��5:PLS-00322: 'PRINTER_NAME' ��� ���Ǵ� �ʱ� �Ҵ� ���� �����Ͽ��� �մϴ�
begin
    dbms_output.put_line(printer_name);
end;

/*
3. ���� �͸� ����� �����ϰ� �ùٸ� ������ �����մϴ�.
 SET SERVEROUTPUT ON
 DECLARE
  fname VARCHAR2(20);
  lname VARCHAR2(15) DEFAULT 'fernandez';
 BEGIN
  DBMS_OUTPUT.PUT_LINE( FNAME ||' ' ||lname);
 END;
 /
  a. ����� ���������� ����ǰ� "fernandez"�� ��µ˴ϴ�. (O)
  b. fname ������ �ʱ�ȭ���� �ʰ� ���Ǿ��� ������ ������ �߻��մϴ�.
  c. ����� ���������� ����ǰ� "null fernandez"�� ��µ˴ϴ�.
  d. VARCHAR2 ������ ������ �ʱ�ȭ�ϴ� �� DEFAULT Ű���带 ����� �� ���� ������
     ������ �߻��մϴ�.
  e. ��Ͽ��� FNAME ������ ������� �ʾұ� ������ ������ �߻��մϴ�.
*/

/*
4. �͸� ����� �����մϴ�. SQL Developer���� ���� 1�� 2�� �������� ������
   lab_01_02_soln.sql ��ũ��Ʈ�� ���ϴ�.
  a. �� PL/SQL ��Ͽ� ���� ������ �߰��մϴ�. ���� ���ǿ��� ���� ������ �����մϴ�.
    1. DATE ������ today ����. today�� SYSDATE�� �ʱ�ȭ�մϴ�.
    2. today ������ tomorrow ����. %TYPE �Ӽ��� ����Ͽ� �� ������
       �����մϴ�.
  b. ���� ���ǿ��� ���� ��¥�� ����ϴ� ǥ����(today ���� 1 �߰�)�� ����Ͽ�
     tomorrow ������ �ʱ�ȭ�մϴ�. "Hello World"�� ����� �� today�� tomorrow��
     ���� ����մϴ�.
  c. �� ��ũ��Ʈ�� �����ϰ� lab_02_04_soln.sql�� �����մϴ�.
*/
declare
    today date := sysdate;
    tomorrow today%TYPE;
begin
    tomorrow := today + 1;
    dbms_output.put_line('Hello World    today: ' || today || '  tomorrow: ' || tomorrow);
end;

/*
5. lab_02_04_soln.sql ��ũ��Ʈ�� �����մϴ�.
  a. �� ���� ���ε� ������ �����ϴ� �ڵ带 �߰��մϴ�. NUMBER ������ ���ε� ����
     basic_percent �� pf_percent�� �����մϴ�.
  b. PL/SQL ����� ���� ���ǿ��� basic_percent�� pf_percent�� ���� �� 45��
     12�� �Ҵ��մϴ�.
  c. "/"�� PL/SQL ����� �����ϰ� PRINT ����� ����Ͽ� ���ε� ���� ���� ǥ���մϴ�.
  d. ��ũ��Ʈ ������ �����ϰ� lab_02_05_soln.sql�� �����մϴ�. 
*/

variable basic_percent number;
variable pf_percent number;
declare
    today date := sysdate;
    tomorrow today%TYPE;
begin    
    :basic_percent := 45;
    :pf_percent := 10;
    tomorrow := today + 1;
    dbms_output.put_line('Hello World    today: ' || today || '  tomorrow: ' || tomorrow);
end;
/
PRINT basic_percent;
PRINT pf_percent;

/*
6. N1, N2�̶�� NUMBER Ÿ�� ������ �����ϵ� N2�� �� �� �����ϰ� 
   N1���� �ʱⰪ�� �Ҵ��� N1 �� ����ϱ�

7. 6������ N2�� �߰��� ����ϱ� ���� �� ���� Ȯ��

8. 6������ N1 ������Ī�� 1N ���� �ٲٰ� ���� �� ���� Ȯ�� �ϱ�

9. CONS1 �̶�� NUMBER�� ����� �����ϰ� �ʱ� �� �Ҵ� ���� ��� �� 
   �������� Ȯ���ϱ�
*/
declare
    N1 number := 1;
    N2 number;
    N2 number;
    CONS1 constant number;
begin
    DBMS_OUTPUT.PUT_LINE(N1); --6: 1
    --DBMS_OUTPUT.PUT_LINE(N2); --7: ORA-06550: N2'�� ���� �ִ� �ϳ��� ���� ���˴ϴ�
    DBMS_OUTPUT.PUT_LINE(1N); --8: ORA-06502: PL/SQL: ��ġ �Ǵ� �� ����: ���ڸ� ���ڷ� ��ȯ�ϴµ� �����Դϴ�
    --DBMS_OUTPUT.PUT_LINE(CONS1); -- 9: ORA-06550: �� 5, ��5:PLS-00322: 'CONS1' ��� ���Ǵ� �ʱ� �Ҵ� ���� �����Ͽ��� �մϴ�
end;

/*
10. Pi ��� NUMBER�� ����� �����ϰ� �ʱ� �� 0 �Ҵ� �� 
    BEGIN SECTION���� �Ҵ� �� 3.14�� �� �Ҵ� �� ����Ͽ� �������� Ȯ���ϱ�

11. ���ͷ� ���ڿ� �����ڸ� �̿��Ͽ� ������ ����ǥ�� ���� �ۡ� �̶�� ���ڿ� ����ϱ� 

12. TIMESTAMP ���� �� ���� �����ϰ� INTERVAL DAY TO SECOND ���� �� �����ؼ� 
    SYSTIMESTAMP �� SYSTIMESTAMP���� 1�� �� ���� 
    INTERVAL DAY TO SECOND ������ �ְ� �� ���� ���� ����ϱ�
*/
-- 10.
declare
    Pi constant number := 0; -- ORA-06550: �� 4, ��5:PLS-00363: 'PI' ���� ���Ҵ��ڷ� ���� �� �����ϴ�
begin
    Pi := 3.14;
end;
-- 11.
begin
    dbms_output.put_line(q'!'���� ����ǥ�� ���� ��'!');
end;
-- 12.
declare
    a timestamp;
    b timestamp;
    c interval day to second;
begin
    a := systimestamp;
    b := systimestamp - 1;
    c := a - b;
    dbms_output.put_line('systime: ' || a || '      systime - 1: ' || b || '     interval: ' || c);
end;
/*
    13. V_IS_TRUE ��� BOOLEAN Ÿ���� ������ �����ϰ� TRUE�� �ʱ�ȭ�� �� 
        BEGIN SECTION ���� CASE ���� ����� V_IS_TRUE �� TRUE �� ��� �����Դϴ١� �� 
        ����ϰ� FALSE �� ��� �������Դϴ١� �� ���
    
    14. 13���� BOOLEAN ������ 3-2 > 10 �̶�� ���� �ʱ� ������ �Ҵ��ϰ� ���� �� 
    ��� ��� Ȯ��
*/
-- 13.
declare
    V_IS_TRUE boolean := TRUE;
begin
    case V_IS_TRUE
        when TRUE then dbms_output.put_line('���Դϴ�');
        else dbms_output.put_line('�����Դϴ�');
    end case;
end; -- ���Դϴ�
-- 14.
declare
    V_IS_TRUE boolean := 3-2 > 10;
begin
    case V_IS_TRUE
        when TRUE then dbms_output.put_line('���Դϴ�');
        else dbms_output.put_line('�����Դϴ�');
    end case;
end; -- �����Դϴ�

/*
15. TEMP1�� EMP_NAME�� %TYPE ������ �����ϰ�, 
    TEMP1���� �� ���� �о� ������ �ִ� TYPE_CHANGE ��� PROCEDURE ����.
16. USER_OBJECTS �� ���� ������ ���ν��� Ȯ�� (VALID���� ���ε� �Բ�)
17. TEMP1�� EMP_NAME�� 30�ڸ��� Ȯ��
18. USER_OBJECTS�� ���� TYPE_CHANGE ���ν��� �� Ȯ�� (VALID����)
19. EXECUTE TYPE_CHANGE; �� ���ν��� ���� ���� Ȯ��
20. 18�� �� ����
*/
--15.
create or replace procedure type_change 
is
    enm temp1.emp_name%TYPE;
begin
    select emp_name into enm from temp1 where rownum = 1;
end;
/
--16.
select * from user_objects where object_name = 'TYPE_CHANGE'; -- valid
--17.
alter table temp1 modify (emp_name varchar(30));
--18.
select * from user_objects where object_name = 'TYPE_CHANGE'; -- invalid
--19.
execute type_change;
--20.
select * from user_objects where object_name = 'TYPE_CHANGE'; -- valid

/*
    bonus
*/
--1.
variable is_boss varchar2(1);
variable emp_id number;
declare
    ename varchar2(20) := 'ȫ�浿';
begin
    select emp_id, decode(boss_id, emp_id, 'T', 'F') 
    into :emp_id, :is_boss
    from temp e, tdept d 
    where e.dept_code = d.dept_code(+) 
    and emp_name = ename;
    
    select emp_id, decode(boss_id, emp_name, 'T', 'F') 
    into :emp_id, :is_boss
    from temp e, tdept d 
    where e.dept_code = d.dept_code(+) 
    and emp_name = ename;
end;
print emp_id;
print is_boss;
--2.
variable is_boss varchar2(1);
variable emp_id number;
declare
    &&ename varchar2(20);
begin
    select emp_id, decode(boss_id, emp_id, 'T', 'F') 
    into :emp_id, :is_boss
    from temp e, tdept d 
    where e.dept_code = d.dept_code(+) 
    and emp_name = &ename;
    
    select emp_id, decode(boss_id, emp_name, 'T', 'F') 
    into :emp_id, :is_boss
    from temp e, tdept d 
    where e.dept_code = d.dept_code(+) 
    and emp_name = &ename;
end;
print emp_id;
print is_boss;
/
--3.
commit;
select * from bom;
delete bom;
declare
    s number := 0;
    i number := 0;
begin
    loop
    i := 0;
    s := s + 1;
        loop
            i := i + 1;
            insert into bom(spec, item, qty)
                values('S' || s, 'I' || i, CEIL(DBMS_RANDOM.VALUE(2,5)));
            dbms_output.put_line(s || i);
        exit when ((s <= 3 and i >= 7) or (s > 3 and i >= 5));
        end loop;
    exit when s >= 5;
    end loop;
end;
select * from bom;

--4.
declare
    s number := 0;
    i number := 0;
    procedure sub1(i_s number, i_i number) is
    begin
        insert into bom(spec, item, qty)
        values('S' || i_s, 'I' || i_i, CEIL(DBMS_RANDOM.VALUE(2,5)));
    end sub1;
begin
    loop
    i := 0;
    s := s + 1;
        loop
            i := i + 1;
            sub1(s, i);
            dbms_output.put_line(s || i);
        exit when ((s <= 3 and i >= 7) or (s > 3 and i >= 5));
        end loop;
    exit when s >= 5;
    end loop;
end;
rollback;