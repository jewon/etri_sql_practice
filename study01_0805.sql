/*
    0805: PL/SQL입문
*/

declare
    v_fname varchar2(20);
begin
    select first_name
    into v_fname -- select into: 질의 실행 결과를 저장할 변수
    from employees
    where employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('The First Name of the Employee is: '||v_fname); -- DBMS출력창에 출력
end;

-- 1. 다음 PL/SQL 블록 중 성공적으로 실행되는 블록은 무엇입니까?
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

-- 2. "Hello World"를 출력하는 간단한 익명 블록을 생성하여 실행합니다
begin
DBMS_OUTPUT.PUT_LINE('Hello World');
END;

-- 3. 다음에 나열된 선언을 검토하여 그 중 잘못된 선언을 판별하고 그 이유를 설명합니다.
-- a. (X: 한 타입으로 동시에 두 변수 선언 불가)
DECLARE
name,dept VARCHAR2(14);
-- b. (O)
DECLARE
test NUMBER(5);
-- c. (X: =가 아닌 :=로 초기화 필요)
DECLARE
MAXSALARY NUMBER(7,2) := 5000;
-- d. (X: 잘못된 데이터 타입으로 초기화)
DECLARE
JOINDATE BOOLEAN := SYSDATE;

--3-1.자신의 이름과 국적을 같은 줄과 다른 줄에 출력하는 간단한 익명 블록 생성 하기
declare
    m_name varchar2(20);
begin
    select emp_name
    into m_name -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_id = '20190401';
    DBMS_OUTPUT.PUT_LINE(m_name || ' 대한민국');
end;

declare
    m_name varchar2(20);
begin
    select emp_name
    into m_name -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_id = '20190401';
    DBMS_OUTPUT.PUT_LINE(m_name || chr(10) || '대한민국');
end;

--4.익명 블록에서 V$ 와 V1 이라는 변수를 선언하고, V$는 선언절에서 초기화하고, V1은 초기화 없이 BEGIN에서 두 변수 값 출력하기
declare
    V$ varchar2(20) := 'Hello';
    V1 varchar2(20);
begin
    DBMS_OUTPUT.PUT_LINE('V$:' || V$ || '  V1:' || V1);
end;

--5. TEMP 에서 자기이름의 사번을 검색해 출력하기
declare
    m_eid number;
begin
    select emp_id
    into m_eid -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_name = '최재원';
    DBMS_OUTPUT.PUT_LINE(m_eid);
end;

--6. 5번에서 사번과, 급여를 함께 출력
--5. TEMP 에서 자기이름의 사번을 검색해 출력하기
declare
    m_eid number;
    m_sal number;
begin
    select emp_id, salary
    into m_eid, m_sal -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_name = '최재원';
    DBMS_OUTPUT.PUT_LINE(m_eid || ': ' || m_sal);
end;

--7. 5와 같은 방법으로 홍길동과 이순신의 사번을 출력시도
declare -- 
    m_eid number;
    m_sal number;
begin
    select emp_id, salary
    into m_eid, m_sal -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_name in ('홍길동', '이순신');
    DBMS_OUTPUT.PUT_LINE(m_eid || ': ' || m_sal);
end; -- ERR ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다

declare
    m_eid number;
begin
    select emp_id
    into m_eid -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_name = '홍길동';
    DBMS_OUTPUT.PUT_LINE('홍길동: ' || m_eid);
    
    select emp_id
    into m_eid -- select into: 질의 실행 결과를 저장할 변수
    from temp
    where emp_name = '이순신';
    DBMS_OUTPUT.PUT_LINE('이순신: ' || m_eid);
end;

/*
8. 익명 블록에서 NUMBER(10), VARCHAR2(10) , CHAR(10), DATE 타입의 변수를
    각각 두 개씩 8개 선언한 뒤, 한 묶음(4가지 변수 종류별 1개씩)은 
   초기값 할당하고 나머지는 초기값 할당 없이 8개 변수 각각의 VALUE와 LENGTH 값을 출력하여 
   자신의 예상 치와 비교해보기 
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
        exit when lc >= 10; -- 종료조건
    end loop;
    DBMS_OUTPUT.PUT_LINE(lc);
end;

-- 9. temp에서 전체 인원의 사번,이름,salary 를 출력하는 pl/sql  block 구현
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
        exit when eid is null; -- 마지막 행에서 오류 ORA-01403: 데이터를 찾을 수 없습니다.
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
        exit when eid is null; -- 마지막 행에서 오류 ORA-01403: 데이터를 찾을 수 없습니다.
    end loop;
end;

-- 10. N1, N2이라는 NUMBER 타입 변수를 선언하되 N2를 두 번 선언하고 N1에만 초기값을 할당해 N1 값 출력하기
declare
    N1 number := 1;
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(N1);
end;


/*
11. 10번에서 N2도 추가로 출력하기 실행 후 오류 확인
12. 10번에서 N1 변수명칭을 1N 으로 바꾸고 실행 후 오류 확인 하기
13. CONS1 이라는 NUMBER형 상수를 선언하고 초기 값 할당 없이 출력 후 오류내용 확인하기
상수이름 CONSTANT VARCHAR2(10);
*/

--11.
declare
    N1 number := 1;
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(N1);
    DBMS_OUTPUT.PUT_LINE(N2);
end; -- ORA-06550: 줄 7, 열26:PLS-00371: N2'에 대해 최대 하나의 선언만 허용됩니다.

--12.
declare
    1N number := 1; -- ORA-06550: 줄 2, 열5:PLS-00103: 심볼 "1"를 만났습니다 다음 중 하나가 기대될 때: begin
    N2 number;
    N2 number;
begin
    DBMS_OUTPUT.PUT_LINE(1N);
end;

--13.

/*
    프로시저 생성 실습
*/
create or replace procedure p_test1 as
begin 
    insert into tdate(D1) values(sysdate);
end;

select * from tdate;
truncate table tdate;
execute p_test1;

/*
    펑션 생성 실습
*/
--생성
create or replace function f_test1 return number is
    res number := 0;
begin
    select count(*)
    into res
    from tdate;
    return res;
end;
--생성확인
select *
from user_objects
where object_type = 'FUNCTION'
and object_name = 'F_TEST1';
--작동확인
select f_test1 from dual;

/*
bonus
아래 내용 수행하는 익명블록 생성
1. TEMP1 DATA 모두 삭제
2. TEMP에서 취미가 NULL인 정보만 읽어서 TEMP1에 Insert ... Select
3. TEMP1에서 SALARY를 10%인상
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
end; -- ORA-06550: 줄 2, 열5:PLS-00103: 심볼 "CREATE"를 만났습니다 다음 중 하나가 기대될 때
-- 3.
begin
    drop table temp1;    
end; -- ORA-06550: 줄 2, 열5:PLS-00103: 심볼 "DROP"를 만났습니다 다음 중 하나가 기대될 때
-- 4.
begin
    grant select on tdept to cong;
end; -- ORA-06550: 줄 2, 열5:PLS-00103: 심볼 "GRANT"를 만났습니다 다음 중 하나가 기대될 때
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

--6. 익명블록에서 TDATE DATA 모두 삭제하고 P_TEST1을 호출 후 COMMIT;
--  익명블럭 실행 후 결과 확인 P_TEST1;
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
        DBMS_OUTPUT.PUT_LINE('1 에서 ' || end_v || '까지 더한 값은 '|| sum_v || '입니다');
        exit when end_v >= 10;
    end loop;
end;

/*
에러처리 관련 추가내용(중요)
begin...(begin...end)...end 에서
내부에서 에러 발생시 - 내부에서 exeption 처리: 외부에서는 그 다음 문장 그대로 실행
                   - exeption처리 후에 raise하면 내부 문장 실행하고 외부로 에러 전달
                   - exeption처리 안함: 외부로 에러 전달됨          
*/