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
    1. 적합한 식별자와 부적합한 식별자 이름을 구분합니다.
     a. today
     b. last_name
     c. today’s_date
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
2. 다음 변수 선언 및 초기화가 적합한지 식별합니다.
 a. number_of_copies PLS_INTEGER; 
 b. printer_name constant VARCHAR2(10);
 c. deliver_to VARCHAR2(10):=Johnson; (X)
 d. by_when DATE:= SYSDATE+1;
*/
-- b.(X)
declare
    printer_name constant VARCHAR2(10); -- ORA-06550: 줄 2, 열5:PLS-00322: 'PRINTER_NAME' 상수 정의는 초기 할당 문을 포함하여야 합니다
begin
    dbms_output.put_line(printer_name);
end;

/*
3. 다음 익명 블록을 검토하고 올바른 문장을 선택합니다.
 SET SERVEROUTPUT ON
 DECLARE
  fname VARCHAR2(20);
  lname VARCHAR2(15) DEFAULT 'fernandez';
 BEGIN
  DBMS_OUTPUT.PUT_LINE( FNAME ||' ' ||lname);
 END;
 /
  a. 블록이 성공적으로 실행되고 "fernandez"가 출력됩니다. (O)
  b. fname 변수가 초기화하지 않고 사용되었기 때문에 오류가 발생합니다.
  c. 블록이 성공적으로 실행되고 "null fernandez"가 출력됩니다.
  d. VARCHAR2 유형의 변수를 초기화하는 데 DEFAULT 키워드를 사용할 수 없기 때문에
     오류가 발생합니다.
  e. 블록에서 FNAME 변수가 선언되지 않았기 때문에 오류가 발생합니다.
*/

/*
4. 익명 블록을 생성합니다. SQL Developer에서 연습 1의 2번 문제에서 생성한
   lab_01_02_soln.sql 스크립트를 엽니다.
  a. 이 PL/SQL 블록에 선언 섹션을 추가합니다. 선언 섹션에서 다음 변수를 선언합니다.
    1. DATE 유형의 today 변수. today를 SYSDATE로 초기화합니다.
    2. today 유형의 tomorrow 변수. %TYPE 속성을 사용하여 이 변수를
       선언합니다.
  b. 실행 섹션에서 내일 날짜를 계산하는 표현식(today 값에 1 추가)을 사용하여
     tomorrow 변수를 초기화합니다. "Hello World"를 출력한 후 today와 tomorrow의
     값을 출력합니다.
  c. 이 스크립트를 실행하고 lab_02_04_soln.sql로 저장합니다.
*/
declare
    today date := sysdate;
    tomorrow today%TYPE;
begin
    tomorrow := today + 1;
    dbms_output.put_line('Hello World    today: ' || today || '  tomorrow: ' || tomorrow);
end;

/*
5. lab_02_04_soln.sql 스크립트를 편집합니다.
  a. 두 개의 바인드 변수를 생성하는 코드를 추가합니다. NUMBER 유형의 바인드 변수
     basic_percent 및 pf_percent를 생성합니다.
  b. PL/SQL 블록의 실행 섹션에서 basic_percent와 pf_percent에 각각 값 45와
     12를 할당합니다.
  c. "/"로 PL/SQL 블록을 종료하고 PRINT 명령을 사용하여 바인드 변수 값을 표시합니다.
  d. 스크립트 파일을 실행하고 lab_02_05_soln.sql로 저장합니다. 
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
6. N1, N2이라는 NUMBER 타입 변수를 선언하되 N2를 두 번 선언하고 
   N1에만 초기값을 할당해 N1 값 출력하기

7. 6번에서 N2도 추가로 출력하기 실행 후 오류 확인

8. 6번에서 N1 변수명칭을 1N 으로 바꾸고 실행 후 오류 확인 하기

9. CONS1 이라는 NUMBER형 상수를 선언하고 초기 값 할당 없이 출력 후 
   오류내용 확인하기
*/
declare
    N1 number := 1;
    N2 number;
    N2 number;
    CONS1 constant number;
begin
    DBMS_OUTPUT.PUT_LINE(N1); --6: 1
    --DBMS_OUTPUT.PUT_LINE(N2); --7: ORA-06550: N2'에 대해 최대 하나의 선언만 허용됩니다
    DBMS_OUTPUT.PUT_LINE(1N); --8: ORA-06502: PL/SQL: 수치 또는 값 오류: 문자를 숫자로 변환하는데 오류입니다
    --DBMS_OUTPUT.PUT_LINE(CONS1); -- 9: ORA-06550: 줄 5, 열5:PLS-00322: 'CONS1' 상수 정의는 초기 할당 문을 포함하여야 합니다
end;

/*
10. Pi 라는 NUMBER형 상수를 선언하고 초기 값 0 할당 후 
    BEGIN SECTION에서 할당 값 3.14로 재 할당 후 출력하여 오류내용 확인하기

11. 리터럴 문자열 구분자를 이용하여 ‘작은 따옴표로 묶인 글’ 이라는 문자열 출력하기 

12. TIMESTAMP 변수 두 개를 선언하고 INTERVAL DAY TO SECOND 변수 한 선언해서 
    SYSTIMESTAMP 와 SYSTIMESTAMP에서 1을 뺀 값을 
    INTERVAL DAY TO SECOND 변수에 넣고 세 변수 각각 출력하기
*/
-- 10.
declare
    Pi constant number := 0; -- ORA-06550: 줄 4, 열5:PLS-00363: 'PI' 식은 피할당자로 사용될 수 없습니다
begin
    Pi := 3.14;
end;
-- 11.
begin
    dbms_output.put_line(q'!'작은 따옴표로 묶인 글'!');
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
    13. V_IS_TRUE 라는 BOOLEAN 타입의 변수를 선언하고 TRUE로 초기화한 후 
        BEGIN SECTION 에서 CASE 문을 사용해 V_IS_TRUE 가 TRUE 인 경우 ‘참입니다’ 를 
        출력하고 FALSE 인 경우 ‘거짓입니다’ 를 출력
    
    14. 13번의 BOOLEAN 변수에 3-2 > 10 이라는 값을 초기 값으로 할당하고 실행 후 
    출력 결과 확인
*/
-- 13.
declare
    V_IS_TRUE boolean := TRUE;
begin
    case V_IS_TRUE
        when TRUE then dbms_output.put_line('참입니다');
        else dbms_output.put_line('거짓입니다');
    end case;
end; -- 참입니다
-- 14.
declare
    V_IS_TRUE boolean := 3-2 > 10;
begin
    case V_IS_TRUE
        when TRUE then dbms_output.put_line('참입니다');
        else dbms_output.put_line('거짓입니다');
    end case;
end; -- 거짓입니다

/*
15. TEMP1의 EMP_NAME을 %TYPE 변수로 선언하고, 
    TEMP1에서 한 건을 읽어 변수에 넣는 TYPE_CHANGE 라는 PROCEDURE 생성.
16. USER_OBJECTS 를 통해 생성된 프로시져 확인 (VALID인지 여부도 함께)
17. TEMP1의 EMP_NAME을 30자리로 확장
18. USER_OBJECTS를 통해 TYPE_CHANGE 프로시져 재 확인 (VALID인지)
19. EXECUTE TYPE_CHANGE; 로 프로시져 실행 여부 확인
20. 18번 재 수행
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
    ename varchar2(20) := '홍길동';
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