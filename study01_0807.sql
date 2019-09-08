/*
    0807
*/
declare
    
begin
    dbms_output.put_line(upper('hello'));
    dbms_output.put_line(lpad('hello', 10, '-'));
    dbms_output.put_line(ltrim('hello', 'h'));
    dbms_output.put_line(next_day(sysdate, 1));
    dbms_output.put_line(last_day(sysdate));
    
end;
/
DECLARE
    salary NUMBER(6):=6000;
    sal_hike VARCHAR2(5):='1000';
    total_salary temp.salary%TYPE;
BEGIN
    total_salary:=salary+sal_hike;
    dbms_output.put_line(total_salary);
    date_of_joining DATE:= TO_DATE('February 02,2000','Month DD, YYYY');
END;

DECLARE
    outer_variable VARCHAR2(20):='GLOBAL VARIABLE';
BEGIN
    DECLARE
        inner_variable VARCHAR2(20):='LOCAL VARIABLE';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(inner_variable);
        DBMS_OUTPUT.PUT_LINE(outer_variable);
    END;
    DBMS_OUTPUT.PUT_LINE(outer_variable);
END;
/

DECLARE
    father_name VARCHAR2(20):= 'Patrick';
    date_of_birth DATE:= to_date('20-Apr-1972', 'DD-MON-YYYY');
    BEGIN
    DECLARE
        child_name VARCHAR2(20):='Mike';
        date_of_birth DATE:= to_date('12-Dec-2002', 'DD-MON-YYYY');
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Father''s Name: '||father_name);
        DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth);
        DBMS_OUTPUT.PUT_LINE('Child''s Name: '||child_name);
    END;
    DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth);
END;
/


desc_size integer(5);
prod_description VARCHAR2(70):='You can use this
product with your radios for higher frequency';
-- get the length of the string in prod_description
desc_size:= length(prod_description);


<<outer>>
DECLARE
    sal NUMBER(7,2) := 60000;
    comm NUMBER(7,2) := sal * 0.20;
    message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DECLARE
        sal NUMBER(7,2) := 50000;
        comm NUMBER(7,2) := 0;
        total_comp NUMBER(7,2) := sal + comm;
    BEGIN
        message := 'CLERK not'||message;
        outer.comm := sal * 0.30;
    END;
        message := 'SALESMAN'||message;
END outer;


<<outer>>
DECLARE
    sal NUMBER(7,2) := 60000;
    comm NUMBER(7,2) := sal * 0.20;
    message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DECLARE
        sal NUMBER(7,2) := 50000;
        comm NUMBER(7,2) := 0;
        total_comp NUMBER(7,2) := sal + comm;
    BEGIN
        message := 'CLERK not'||message;
        outer.comm := sal * 0.30;
        dbms_output.put_line(message);
        dbms_output.put_line(total_comp);
        dbms_output.put_line(comm);
    END;
    message := 'SALESMAN'||message;
    dbms_output.put_line(message);
    dbms_output.put_line(comm);
END outer;
/

/*

1. PL/SQL ���
DECLARE
 weight NUMBER(3) := 600;
 message VARCHAR2(255) := 'Product 10012';
BEGIN
 DECLARE
  weight NUMBER(3) := 1;
  message VARCHAR2(255) := 'Product 11001';
  new_locn VARCHAR2(50) := 'Europe';
 BEGIN
  weight := weight + 1;
  new_locn := 'Western ' || new_locn;
  -- (1)��
 END;
 weight := weight + 1;
 message := message || ' is in stock';
 new_locn := 'Western ' || new_locn;
  -- (2)��
END;
/
1. ���� ���õ� PL/SQL ����� �����Ͽ� ���� ���� ��Ģ�� ���� ���� �� ������ ������ ����
�� ���� �Ǻ��մϴ�.
a. 1 ��ġ������ weight ��:
b. 1 ��ġ������ new_locn ��:
c. 2 ��ġ������ weight ��:
d. 2 ��ġ������ message ��:
e. 2 ��ġ������ new_locn ��:
*/

DECLARE
 weight NUMBER(3) := 600;
 message VARCHAR2(255) := 'Product 10012';
BEGIN 
 DECLARE
  weight NUMBER(3) := 1;
  message VARCHAR2(255) := 'Product 11001';
  new_locn VARCHAR2(50) := 'Europe';
 BEGIN
  weight := weight + 1;
  new_locn := 'Western ' || new_locn;
  dbms_output.put_line(weight);
  dbms_output.put_line(new_locn);
 END;
 weight := weight + 1;
 message := message || ' is in stock';
 new_locn := 'Western ' || new_locn;
 dbms_output.put_line(weight);
 dbms_output.put_line(new_locn);
 dbms_output.put_line(message);
END;

/*
2. 
���� ����
DECLARE
 customer VARCHAR2(50) := 'Womansport';
 credit_rating VARCHAR2(50) := 'EXCELLENT';
BEGIN
 DECLARE
  customer NUMBER(7) := 201;
  name VARCHAR2(25) := 'Unisports';
 BEGIN
  credit_rating :='GOOD';
  ��
 END;
��
END;
/
    2. ���� ���õ� PL/SQL ��Ͽ��� ���� �� ��쿡 �ش��ϴ� �� �� ������ ������ �Ǻ��մϴ�.
    a. ��ø ����� customer ��:
    b. ��ø�� ����� name ��:
    c. ��ø ����� credit_rating ��:
    d. �� ����� customer ��:
    e. �� ����� name ��:
    f. �� ����� credit_rating ��:
*/
DECLARE
 customer VARCHAR2(50) := 'Womansport';
 credit_rating VARCHAR2(50) := 'EXCELLENT';
BEGIN
 DECLARE
  customer NUMBER(7) := 201;
  name VARCHAR2(25) := 'Unisports';
 BEGIN
  credit_rating :='GOOD';
  dbms_output.put_line(customer); --201
  dbms_output.put_line(name); -- Uniposrts
  dbms_output.put_line(credit_rating); --GOOD

 END;
  dbms_output.put_line(customer); --Womansport
  --dbms_output.put_line(name); -err
END;

/*
3. 
    a. ������ ������ VARCHAR2�̰� ũ�Ⱑ 15�� fname �� ������ ������ NUMBER�̰�
    ũ�Ⱑ 10�� emp_sal�̶�� �� ������ �����մϴ�.
    b. ���� SQL ���� ���� ���ǿ� ���Խ�ŵ�ϴ�.
    SELECT first_name, salary
    INTO fname, emp_sal FROM employees
    WHERE employee_id=110;
    c. 'Hello'�� �̸��� ���. �ʿ��� ��� ��¥�� ǥ��
    d. ���� ���(PF)�� ���� ����� �δ���� ����մϴ�. PF�� �⺻ �޿��� 12%�̸� �⺻
    �޿��� �޿��� 45%�Դϴ�. ����� ���� ���ε� ������ ����մϴ�. ǥ������ �ϳ���
    ����Ͽ� PF�� ����մϴ�. ����� �޿� �� PF �δ���� ����մϴ�.
    e. ��ũ��Ʈ�� ����
*/
-- a.
variable pf number;
declare
    fname varchar2(15);
    emp_sal number(10);
--b.
begin
    SELECT first_name, salary
    INTO fname, emp_sal FROM employees
    WHERE employee_id=110;
    dbms_output.put_line('Hello ' || fname);
    :pf := emp_sal * 0.45 * 0.12;
    dbms_output.put_line(emp_sal || '  ' || :pf);
end;

/*
1.  ù ��° ������ ���ּ�: ����Ư���� ���ʱ� ���絿 XXX������ ���� �ʱ� �� �Ҵ�
    �� ��° ������ ù ��° ������ ���̸� �ʱ� ������ �Ҵ�
    �� ��° ������ ��:�� ���ڰ� ��Ÿ���� ��ġ �� �Ҵ�
    �� ��° ������ ù ��° �������� �ݷ�(:) ���� ���ں��� ������ ���ڱ��� �Ҵ�
    BEGIN SECTION���� �� ��° ���� �� ���
2.  VARCHAR2(02) ���� �� �� ���� ��3������ �ʱ�ȭ, NUMBER ���� 2�� ���� 20���� �ʱ�ȭ
    ����1 ������ ����1�� ����2 ���� �Ҵ��ϰ� ����1 ���� ���
    ����1 ������ ����1�� ����1 ���� �Ҵ��ϰ� ����1 ���� ���    
    ����1 ������ ����1�� ����2 ���� �Ҵ��ϰ� ����1 ���� ���
*/
declare
    adr varchar2(100) := '����� ���ʱ� ���絿 :100';
    n_adr number := length(adr);
    c_adr number := instr(adr, ':');
    bc_adr varchar2(100) := substr(adr, c_adr);
    c1 varchar2(2) := '3';
    c2 varchar2(2) := '3';
    n1 number := 20;
    n2 number := 20;
begin
    c1 := n1 + n2; -- 40
    dbms_output.put_line(c1);
    c1 := n1 + c1; -- 60
    dbms_output.put_line(c1);
    n1 := c1 + c2; -- 63
    dbms_output.put_line(n1);
end;

/*
5.
     ������ �޾Ƶ��̴� PL/SQL ����� �ۼ��ϰ� ������ �������� ���θ� Ȯ���մϴ�. ����
    ���, �Է��� ������ 1990 �̸� "1990 is not a leap year"�� ��µǾ�� �մϴ�.
    ��Ʈ: ������ 4�� ��Ȯ�� ������ �������� 100�� ����� �ƴմϴ�. �׷�����
    400�� ����� �����Դϴ�.
    ���� ������ �ַ���� �׽�Ʈ�մϴ�.
    1990 Not a leap year
    2000 Leap year
    1996 Leap year
    1886 Not a leap year
    1992 Leap year
    1824 Leap year
*/
declare
    d date;
    y number := &yy;
begin
    d := y || '0201';
    case substr(last_day(d), 7 , 2)
        when 28
        then dbms_output.put_line(y || ' is not a leap year');
        else dbms_output.put_line(y || ' is a leap year');
    end case;
end;

/*
6. PL_C VARCHAR2(02) �������� ��3�� ���� �ʱ�ȭ,  PL_N NUMBER�� ���� ���� 20���� �ʱ�ȭ
    ����ο��� PL_N�� TO_CHAR�� ��ȯ �� PL_C�� IF ������ �� �Ͽ� ū �� Ȯ�� 
7.  6�� ����� ����ȯ ���� ���Ͽ� ��� ����(IF ������ �� ������ �񱳼��� �ٲ㰡�� Ȯ��)
8.  7�� IF������ GREATEST�� �־� �� (�� ������ ���� �ٲ㰡�� ��) ��� ����
9.  HINT�̿� SALARY INDEX�̿� ��ȸ�ϱ�
  (���ǿ��� 0���� ũ��, ��0������ ũ��, TO_CHAR(SALARY) > ��0�� ���� ����)
*/
declare
    pl_c varchar2(02) := '3';
    pl_n number(20) := 20;
begin
    dbms_output.put_line('Q6. to_char(pn_n) > pl_c?');
    if to_char(pl_n) > pl_c
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
    dbms_output.put_line('Q7. pl_n < pl_c?');
    if pl_n < pl_c -- ������ ���� �ٸ���
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
    dbms_output.put_line('Q7. pl_c < pl_n?');
    if pl_c < pl_n -- �� ������ number�� ��
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
    dbms_output.put_line('Q8. greatest(pl_c, pl_n) = pl_c');
    if greatest(pl_c, pl_n) = pl_c
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
    dbms_output.put_line('Q8. greatest(pl_n, pl_c) = pl_c');
    if greatest(pl_n, pl_c) = pl_c
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
end;

create index sal_ind on temp(salary);
select /*+ INDEX(TEMP SAL_IND) */* from temp where salary > 0;
select /*+ INDEX(TEMP SAL_IND) */* from temp where salary > '0';
select /*+ INDEX(TEMP SAL_IND) */* from temp where to_char(salary) > '0'; -- ����ȯ �� ���ϱ� ������sal_ind ��Ž

-- bonus
--1. 2. 3.
declare
    pl_out varchar2(10) := 'Global';
begin
    declare
        pl_in varchar2(10) := 'Local';
        pl_out varchar2(10) := 'Local';
    begin
        dbms_output.put_line(pl_out); -- local
        dbms_output.put_line(pl_in); -- local
    end;
    dbms_output.put_line(pl_out); -- global
end;
--4. 5.
declare
    pl_g varchar2(40) := 'Global';
begin
    declare
        pl_l1 varchar2(40) := 'Local begin 1st Block';
    begin
        dbms_output.put_line(pl_g);  
        dbms_output.put_line(pl_l1);
    end;
    declare
        pl_l2 varchar2(40) := 'Local begin 2nd Block';
    begin
        dbms_output.put_line(pl_g);  
        dbms_output.put_line(pl_l1); --err ORA-06550
        dbms_output.put_line(pl_l2);
    end;
end;
--6. 7.
<<outter>>
declare
    v varchar2(40) := 'Outter';
begin
    <<inner>>
    declare
        v varchar2(40) := 'Inner';
    begin
        dbms_output.put_line(v); --inner
        dbms_output.put_line(outter.v); --inner
    end;
    dbms_output.put_line(inner.v); --err ORA-06550: �� 12, ��32:PLS-00219: 'INNER' ���̺� ������ ���� ���Դϴ�
end;
--8.
/

create or replace procedure sal_range_change(enm varchar2(30))
is
    l varchar2(10);
    s number;
begin
    select lev , salary
    into l, s
    from temp
    where emp_name = enm;
end;
/
declare
    e_l varchar2(10);
    e_s number;
begin
    select emp_name, salary, from_sal, to_sal
    from temp e left outer join emp_level l
    on (e.lev = l.lev);
    
end;

begin
    begin
        select b.dept_code
        into pl_dept
        from temp a, tdept2 b
        where a.emp_name = p1
        and b.dept_code = a.dept_code
        exception
            when no_data_found then
            dbms_output.put_line(p1 || '������ �μ��� �μ������� ��ϵ��� �ʾҽ��ϴ�.');
        end;
    select a.lev, a.salary, b.from_sal
/
declare
    l varchar2(10);
begin
    select lev 
    into l
    from emp_level 
    where lev = (select lev from temp where emp_name = 'ȫ�浿');
    case l
        when null then dbms_output.put_line('null');
        else dbms_output.put_line(l);
    end case;
end;
select * from temp;

desc emp_level;
INSERT INTO TEMP (EMP_ID, EMP_NAME, DEPT_CODE, EMP_TYPE, USE_YN, TEL, HOBBY, SALARY, LEV,EVAL_YN) 
VALUES (19800101,'���ǵ�', 'AB0001', '����','Y',12341234,'TV',0,'����','Y');
commit;

select * from temp;