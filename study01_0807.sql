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

1. PL/SQL 블록
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
  -- (1)번
 END;
 weight := weight + 1;
 message := message || ' is in stock';
 new_locn := 'Western ' || new_locn;
  -- (2)번
END;
/
1. 위에 제시된 PL/SQL 블록을 검토하여 범위 지정 규칙에 따라 다음 각 변수의 데이터 유형
및 값을 판별합니다.
a. 1 위치에서의 weight 값:
b. 1 위치에서의 new_locn 값:
c. 2 위치에서의 weight 값:
d. 2 위치에서의 message 값:
e. 2 위치에서의 new_locn 값:
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
범위 예제
DECLARE
 customer VARCHAR2(50) := 'Womansport';
 credit_rating VARCHAR2(50) := 'EXCELLENT';
BEGIN
 DECLARE
  customer NUMBER(7) := 201;
  name VARCHAR2(25) := 'Unisports';
 BEGIN
  credit_rating :='GOOD';
  …
 END;
…
END;
/
    2. 위에 제시된 PL/SQL 블록에서 다음 각 경우에 해당하는 값 및 데이터 유형을 판별합니다.
    a. 중첩 블록의 customer 값:
    b. 중첩된 블록의 name 값:
    c. 중첩 블록의 credit_rating 값:
    d. 주 블록의 customer 값:
    e. 주 블록의 name 값:
    f. 주 블록의 credit_rating 값:
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
    a. 데이터 유형이 VARCHAR2이고 크기가 15인 fname 및 데이터 유형이 NUMBER이고
    크기가 10인 emp_sal이라는 두 변수를 선언합니다.
    b. 다음 SQL 문을 실행 섹션에 포함시킵니다.
    SELECT first_name, salary
    INTO fname, emp_sal FROM employees
    WHERE employee_id=110;
    c. 'Hello'와 이름을 출력. 필요한 경우 날짜를 표시
    d. 적립 기금(PF)에 대한 사원의 부담금을 계산합니다. PF는 기본 급여의 12%이며 기본
    급여는 급여의 45%입니다. 계산할 때는 바인드 변수를 사용합니다. 표현식을 하나만
    사용하여 PF를 계산합니다. 사원의 급여 및 PF 부담금을 출력합니다.
    e. 스크립트를 실행
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
1.  첫 번째 변수는 ‘주소: 서울특별시 서초구 양재동 XXX번지’ 문자 초기 값 할당
    두 번째 변수는 첫 번째 변수의 길이를 초기 값으로 할당
    세 번째 변수는 ‘:’ 문자가 나타나는 위치 값 할당
    네 번째 변수는 첫 번째 변수에서 콜론(:) 다음 문자부터 마지막 문자까지 할당
    BEGIN SECTION에서 네 번째 변수 값 출력
2.  VARCHAR2(02) 변수 두 개 선언 ‘3’으로 초기화, NUMBER 변수 2개 선언 20으로 초기화
    문자1 변수에 숫자1과 숫자2 더해 할당하고 문자1 변수 출력
    문자1 변수에 숫자1과 문자1 더해 할당하고 문자1 변수 출력    
    숫자1 변수에 문자1과 문자2 더해 할당하고 숫자1 변수 출력
*/
declare
    adr varchar2(100) := '서울시 서초구 양재동 :100';
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
     연도를 받아들이는 PL/SQL 블록을 작성하고 연도가 윤년인지 여부를 확인합니다. 예를
    들어, 입력한 연도가 1990 이면 "1990 is not a leap year"가 출력되어야 합니다.
    힌트: 윤년은 4로 정확히 나누어 떨어지며 100의 배수는 아닙니다. 그렇지만
    400의 배수는 윤년입니다.
    다음 연도로 솔루션을 테스트합니다.
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
6. PL_C VARCHAR2(02) 변수선언 ‘3’ 으로 초기화,  PL_N NUMBER형 변수 선언 20으로 초기화
    실행부에서 PL_N을 TO_CHAR로 변환 후 PL_C와 IF 문으로 비교 하여 큰 값 확인 
7.  6을 명시적 형변환 없이 비교하여 결과 보기(IF 문에서 두 변수의 비교순서 바꿔가며 확인)
8.  7를 IF문에서 GREATEST에 넣어 비교 (두 변수의 순서 바꿔가며 비교) 결과 보기
9.  HINT이용 SALARY INDEX이용 조회하기
  (조건에서 0보다 크다, ‘0’보다 크다, TO_CHAR(SALARY) > ‘0’ 각각 적용)
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
    if pl_n < pl_c -- 버전에 따라 다르다
        then dbms_output.put_line('yes');
        else dbms_output.put_line('no');
    end if;
    dbms_output.put_line('Q7. pl_c < pl_n?');
    if pl_c < pl_n -- 구 버전은 number로 비교
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
select /*+ INDEX(TEMP SAL_IND) */* from temp where to_char(salary) > '0'; -- 형변환 후 비교하기 때문에sal_ind 안탐

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
    dbms_output.put_line(inner.v); --err ORA-06550: 줄 12, 열32:PLS-00219: 'INNER' 레이블 참조는 범위 밖입니다
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
            dbms_output.put_line(p1 || '직원의 부서가 부서정보에 등록되지 않았습니다.');
        end;
    select a.lev, a.salary, b.from_sal
/
declare
    l varchar2(10);
begin
    select lev 
    into l
    from emp_level 
    where lev = (select lev from temp where emp_name = '홍길동');
    case l
        when null then dbms_output.put_line('null');
        else dbms_output.put_line(l);
    end case;
end;
select * from temp;

desc emp_level;
INSERT INTO TEMP (EMP_ID, EMP_NAME, DEPT_CODE, EMP_TYPE, USE_YN, TEL, HOBBY, SALARY, LEV,EVAL_YN) 
VALUES (19800101,'김피디', 'AB0001', '정규','Y',12341234,'TV',0,'과장','Y');
commit;

select * from temp;