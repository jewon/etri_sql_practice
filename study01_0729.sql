/* 
    0729: DML DDL 확장
*/
-- 실습테이블 생성
create table mgr_history 
    as select
        employee_id empid,
        manager_id mgr,
        salary sal
    from employees
    where employee_id = -1;
create table sal_history
    as select
        department_id deptid,
        hire_date hiredate,
        salary sal
    from employees
    where employee_id = -1;
create table hiredate_history
    as select
        department_id deptid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table hiredate_history_00
    as select
        department_id deptid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table hiredate_history_99
    as select
        employee_id empid,
        hire_date hiredate
    from employees
    where employee_id = -1;
create table special_sal
    as select
        department_id deptid,
        salary sal
    from employees
    where employee_id = -1;
-- insert all
insert all
    into sal_history values(empid, hiredate, sal)
    into mgr_history values(empid, mgr, sal)
    select employee_id empid, hire_date hiredate, salary sal, manager_id mgr
    from employees
    where employee_id > 200;
-- conditional insert all (조건이 배타적이지 않을 수도 있음, 앞부터)
insert all
    when sal > 10000 then
        into sal_history values (empid, hiredate, sal)
    when mgr > 200 then
        into mgr_history values (empid, mgr, sal)
    select 
        employee_id empid,
        hire_date hiredate,
        salary sal,
        manager_id mgr
    from employees
    where employee_id > 200;
-- insert first
insert first
    when sal > 25000 then
        into special_sal values(deptid, sal)
    when hiredate like ('%00%') then
        into hiredate_history_00 values(deptid, hiredate)
    when hiredate like ('%99%') then
        into hiredate_history_99 values(deptid, hiredate)
    else
        into hiredate_history values(deptid, hiredate)
        select department_id deptid, sum(salary) sal,
            max(hire_date) hiredate
        from employees
        group by department_id;
-- 실습테이블 생성
create table sales_source_data
as select employee_id,
    no week_id,
    ceil(dbms_random.value(1000, 5000)) sales_mon,
    ceil(dbms_random.value(1000, 5000)) sales_tue,
    ceil(dbms_random.value(1000, 5000)) sales_wed,
    ceil(dbms_random.value(1000, 5000)) sales_thu,
    ceil(dbms_random.value(1000, 5000)) sales_fri
from employees,
     t1_data
where no < 6;
create table sales_info
    as select employee_id, week_id, sales_mon sales_day
    from sales_source_data
    where employee_id = -1;
-- 다중테이블 insert
insert all
    into sales_info values(employee_id, week_id, sales_MON)
    into sales_info values(employee_id, week_id, sales_TUE)
    into sales_info values(employee_id, week_id, sales_WED)
    into sales_info values(employee_id, week_id, sales_TUE)
    into sales_info values(employee_id, week_id, sales_FRI)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
    from sales_source_data;
-- 외부테이블
select employee_id empno,
    first_name || ' ' || last_name
from employees;
-- 
create directory emp_dir as 'D:\ETRI데이터기반\';
create table oldemp(
    empno number,
    empname char(46))
    organization external(
        type oracle_loader
        default directory emp_dir
        access parameters(
            records delimited by newline
            badfile 'bad.emp'
            logfile 'log.emp'
            fields terminated by '\t' (
                empno char, empname char
            )
        )
        location('emp1.txt')
    )
    parallel 4
    reject limit 300;
-- PK생성시 인덱스 명시적 지정
create table new_emp
(employee_id number(6)
    primary key using index
    (create index emp_id_idx on 
    new_emp(employee_id) ),
first_name varchar2(20),
last_name varchar2(25));

-- 1. TDEPT의 부서 정보를 csv로 저장하고 외부테이블 생성 후 조회 
select * from tdept; -- 긁어서 엑셀에 붙여넣은 후, 탭으로 분리된 txt로 저장
create directory tdept_dir as 'D:\';
drop table oldtdept;
create table oldtdept (
    dept_code char(6),
    dept_name char(40),
    parent_dept char(6),
    use_yn char(1),
    area char(10),
    boss_id number)
    organization external(
        type oracle_loader
        default directory tdept_dir
        access parameters(
            records delimited by newline
            badfile 'bad.tdept'
            logfile 'log.tdept'
            fields terminated by ',' (
                dept_code char
                dept_name char,
                parent_dept char,
                use_yn char,
                area char,
                boss_id number
            )
        )
        location('tdept2.csv')
    )
    parallel 4
    reject limit 300;
select * from oldtdept;

/*
2.  직원의 소속부서가 변경될 때 마다 현재상태 관리자 정보를 별도로 보관하기 위한 
     HISTORY 테이블 생성  
     TMAN_HISTORY(CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, 
     DEPT_CODE VARCHAR(20), BOSS_ID NUMBER, IS_NOW VARCHAR2(01) ); 
3.  직원의  연봉 정보가 변경될 때 마다 연봉 변경일자와 변경 전.후 금액을 보관하는 HISTORY
     테이블 생성  
     TSAL_HISTORY(CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, BEF_SALARY NUMBER, AFT_SALARY NUMBER)
4.  현재 직원정보를 읽어 직급이 사원인 경우 HISTORY 테이블 두 곳에 현재 상태 정보 입력
     (변경일자:현재일자,  IS_NOW:‘Y’,  BEF_SALARY:0,  AFT_SALARY:현재SALARY)
5.  현재 직원정보를 읽어 직급이 대리인 경우 HISTORY 테이블 두 곳에 현재 상태 정보 입력하되
    TMAN_HISTORY에는 AA0001 부서만을 대상으로 TSAL_HISTORY에는 
    SALARY가 5천만원 이상인 경우만을 대상으로 동시 인서트 수행
*/
--2. 3.
create table TMAN_HISTORY(
     CHANGE_DATE VARCHAR2(08), 
     EMP_ID NUMBER, 
     DEPT_CODE VARCHAR(20), 
     BOSS_ID NUMBER, 
     IS_NOW VARCHAR2(01)
);
create table TSAL_HISTORY(
    CHANGE_DATE VARCHAR2(08), 
    EMP_ID NUMBER, 
    BEF_SALARY NUMBER,
    AFT_SALARY NUMBER
);
--4.
insert all
    into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '사원';
select * from temp;
select * from tsal_history;
--5.
insert all
    when dcd = 'AA0001' then
        into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    when sal >= 50000000 then
        into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '대리';
/*
6. 현재 직원정보를 읽어 직급이 과장인 경우 HISTORY 테이블 두 곳에 현재 상태 정보를 입력하되
    TMAN_HISTORY에는 AA0001 부서만을 대상으로 
    TSAL_HISTORY에는 SALARY가 5천만원 이상인 경우만을 대상으로 동시 인서트 수행 
    (단, 첫 번째  TMAN에 입력된 경우 TSAL 입력 안함)
7. T2_DATA를 ROW형식으로 관리하기 위한 테이블 생성 
    T2_TRAN (EMP_ID NUMBER, YM VARCHAR2(06), MSAL NUMBER)
8. T2_DATA를 INSERT ALL 문장이용 T2_TRAN 으로 INSERT
*/
--6.
insert first
    when dcd = 'AA0001' then
        into tman_history values (to_char(sysdate, 'YYYYMMDD'), eid, dcd, bid, 'Y')
    when sal >= 50000000 then
        into tsal_history values (to_char(sysdate, 'YYYYMMDD'), eid, 0, sal)
    select 
        e.emp_id eid,
        e.dept_code dcd,
        e.salary sal,
        d.boss_id bid
    from temp e, tdept d
    where e.dept_code = d.dept_code(+) and e.lev = '과장';
--7.
create table t2_tran (EMP_ID NUMBER, YM VARCHAR2(06), MSAL NUMBER);
--8.
insert all
    into t2_tran values(emp_id, '201901', sal01)
    into t2_tran values(emp_id, '201902', sal02)
    into t2_tran values(emp_id, '201903', sal03)
    into t2_tran values(emp_id, '201904', sal04)
    into t2_tran values(emp_id, '201905', sal05)
    into t2_tran values(emp_id, '201906', sal06)
    into t2_tran values(emp_id, '201907', sal07)
    into t2_tran values(emp_id, '201908', sal08)
    into t2_tran values(emp_id, '201909', sal09)
    into t2_tran values(emp_id, '201910', sal10)
    into t2_tran values(emp_id, '201911', sal11)
    into t2_tran values(emp_id, '201912', sal12)
    select *
    from t2_data;
select * from t2_tran;
/*
quiz: A는 1+2타입 amt합계, B는 1+3타입 amt합계일 때,
A	340
B	310
와 같은 테이블 만들기
*/
create table test34(
    key1 varchar2(03),
    key_type varchar2(01),
    amt number,
    constraint test34_PK primary key (key1)
);
insert into test34 values('A01', '1', 10);
insert into test34 values('A02', '2', 20);
insert into test34 values('A03', '1', 30);
insert into test34 values('A04', '2', 40);
insert into test34 values('A05', '3', 50);
insert into test34 values('A06', '3', 60);
insert into test34 values('A07', '1', 70);
insert into test34 values('A08', '2', 80);
insert into test34 values('A09', '1', 90);
commit;
select * from test34 order by 2;
-- A: 1,2 B: 1, 3
-- 집합연산자
select 'A' as type, sum(amt) as value from test34 where key_type in (1, 2)
union 
select 'B' as type, sum(amt) as value from test34 where key_type in (1, 3);
-- Join(1회 접근)
select decode(d.no, 1, 'A', 'B') as type, sum(amt) as value
from test34 t, t1_data d
where (d.no = 1 and t.key_type in (1, 2)) or (d.no = 2 and t.key_type in (1, 3))
group by decode(d.no, 1, 'A', 'B')
order by type;
-- Window Function
select decode(key_type, 2, 'A', 3, 'B') type, decode(key_type, 2, lag1, 3, lag2) value from (
    select key_type, 
           sum(amt) samt, -- 자신 타입의 합계
           sum(amt) + lag(sum(amt)) over (order by key_type) lag1,  -- 자신 타입과 -1번 타입과의 합계( 2 + 1: A)
           sum(amt) + lag(sum(amt), 2) over (order by key_type) lag2 -- 자신 타입과 -2번 타입과의 합계( 3 + 1: B)
    from test34
    group by key_type
)
where key_type in (2, 3)
order by type;