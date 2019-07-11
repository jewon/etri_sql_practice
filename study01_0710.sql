/*
    0710: DML
*/
commit;
-- 다양한 Insert문
insert into departments(department_id, department_name, manager_id) values (1000, 'CRM', 100);
insert into departments(department_id, department_name) values (1150, 'Finance');
insert into employees(employee_id, first_name, last_name, email, job_id, hire_date) values(1000, 'test', 'lastname', 'email', 'AD_PRES', sysdate);
rollback;

-- 실습용 테이블 생성
create table sales_reps as
select employee_id id, last_name name, salary, commission_pct from employees where rownum < 1;
insert into sales_reps select employee_id, last_name, salary, commission_pct from employees;

-- 다양한 Update문
select department_id from employees where employee_id = 100; --아래 행에 해당되는 data에 대한 select문
update employees set department_id = 80 where employee_id = 100;
select department_id from employees where employee_id = 100; --변경된 것 확인
rollback;

-- 서브쿼리를 활용한 여러 컬럼값 update
update employees 
    set job_id = (
        select job_id from employees where employee_id = 102),
    department_id = (
        select department_id from employees where employee_id = 102)
    where employee_id = 101;
rollback;

-- 서브쿼리를 이용해 다른 테이블 기반으로 update
create table emp_copy as
select * from employees;
select * from emp_copy where employee_id = 102;
update employees 
    set job_id = (
        select job_id from emp_copy where employee_id = 102),
    department_id = (
        select department_id from emp_copy where employee_id = 102)
    where employee_id = 101;
select * from employees where employee_id = 101;
rollback;

-- 무결성 제약조건 에러(FK)
update employees set department_id = 55 where department_id = 100; -- department_

-- delete문 (행 단위 삭제기 때문에 컬럼 지정 필요 없다. from 생략 가능하다)
select * from emp_copy where employee_id = 100; -- 1건
delete emp_copy where employee_id = 100; --삭제
select * from emp_copy where employee_id = 100; --null
rollback;

select * from departments;

-- 다른 테이블 기반으로 delete
delete emp_copy where department_id =
    (select department_id from departments where department_name LIKE '%Finance%');

-- 무결성 제약조건 에러 (부서코드가 사원에서 쓰임)
delete departments where department_id = 60;
rollback;

-- merge = update + insert (update에 해당되는 레코드 없을 시 insert)
/*
MERGE INTO table_name alias
    USING (table | view | subquery) alias                -- 하나의 테이블만 이용한다면 DUAL 활용
         ON (join condition)                                     -- WHERE절에 조건 쓰듯이
    WHEN MATCHED THEN                                   -- ON 이하의 조건에 해당하는 데이터가 있는 경우 
             UPDATE SET col1 = val1[, ...]                -- UPDATE 실행
    WHEN NOT MATCHED THEN                           -- ON 이하의 조건에 해당하는 데이터가 없는 경우
             INSERT (column lists) VALUES (values);  -- INSERT 실행

    출처: https://unabated.tistory.com/entry/오라클-MERGE-INTO-한번에-INSERT-UPDATE-하기 [랄라라]
*/
select count(*) from emp_copy;
delete emp_copy where department_id = 50;
commit;

desc emp_copy;
merge into emp_copy c
    using employees e
    on (c.employee_id = e.employee_id)
    when matched then
        update set -- employees와 emp_copy에 동시에 있는 사원은 first_name만 '바보'로 바꿔줌
        c.first_name = '바보',
        c.last_name = e.last_name,
        c.email = e.email,
        c.job_id = e.job_id,
        c.hire_date = e.hire_date
    when not matched then -- employees에는 있는데 emp_copy에 없는 사원은 그대로 정보를 가져와 추가
        insert(c.employee_id, c.first_name, c.last_name, c.email, c.job_id, c.hire_date)
        values(e.employee_id, e.first_name, e.last_name, e.email, e.job_id, e.hire_date);
rollback;

-- 실습용 테이블
create table ttmcd(
    mcd varchar2(4) not null primary key,
    mnm varchar2(200),
    rmk varchar2(400)
);
create table ttcode(
    kno number not null primary key,
    mcd varchar2(4),
    dcd varchar2(4),
    dnm varchar2(100),
    drm varchar2(400)
);
alter table ttcode
add constraint fk_from_ttmcd foreign key (mcd) references ttmcd(mcd);
-- 실습
-- 1. tmcd 테이블에 메인 코드 입력
insert into ttmcd values('A001', '평가결과등급코드', '');
insert into ttmcd values('A002', '평가항목코드', '');
-- 2. tcode 테이블에 코드 입력
insert into ttcode values(101, 'A001', 'A', 'A등급', '90점 이상');
insert into ttcode values(102, 'A001', 'B', 'B등급', '80점 이상');
insert into ttcode values(103, 'A001', 'C', 'C등급', '70점 이상');
insert into ttcode values(104, 'A001', 'D', 'D등급', '60점 이상');
insert into ttcode values(105, 'A001', 'F', 'F등급', '60점 미만');
insert into ttcode values(111, 'A002', '0001', '업적', '업무업적을 평가하는 항목');
insert into ttcode values(112, 'A002', '0002', '자기계발', '직무관련 자기계발 실적을 평가하는 항목');
insert into ttcode values(113, 'A002', '0003', '협업', '동료에게 도움된 정도를 평가하는 항목');
insert into ttcode values(114,'A002', '0004', '태도', '근태, 약속이행 등 업무를 수행하는 전반적인 태도를 평가하는 항목');

--1. temp 테이블에 not null인 컬럼만 선택적으로 insert 문장 작성
insert into temp(emp_id, emp_name, dept_code, use_yn) values(20100101, 'test', 'AA001', 'N');
--2. temp와 동일 구조 테이블 만들고 temp에서 select해 insert
create table temp_copy as 
    (select * from temp where rownum < 1);
insert into temp_copy select * from temp where rownum < 10;

rollback;
drop table temp_copy;
/*
과제
1. 연흥부의 전화번호는 DBA_OBJECTS 의 ROW수로, SALARY는 현재 직급의 상한치로 변경  
     성공여부 확인 후 COMMIT;
2. TEMP의 DEPT_CODE에서 TDEPT의 DEPT_CODE를 참조하는 FOREIGN KEY 생성
3. EMP_ID = 19970112 사번의 DEPT_CODE 를 부서코드에 존재하지 않는 코드로 변경
    (무결성 에러확인)
4. TEMP 에서 EMP_ID = 19970112 사번 삭제
     삭제 여부 확인 후  ROLLBACK;
5.  부서위치가 인천인 부서에 속하는 직원 삭제
     삭제 여부 확인 후  ROLLBACK;
6. 부서테이블에서 부서코드가 ‘AA0001’ 인 부서 삭제 (에러확인)
7. TEMP 와 동일한 테이블을 TEMP에서 부서코드가 ‘AA0001’ 인 경우만 SELECT 해서
   CREATE. 다시 TEMP 전 ROW를 새로 만든 테이블에 없으면 INSERT 있으면 SALARY를 반으로 
*/
--1.
select * from temp where emp_name = '연흥부';
update temp 
    set 
        tel = (select count(*) from DBA_OBJECTS), 
        salary = (select max(salary) from temp where lev = (select lev from temp where emp_name = '연흥부')) -- 굳이??
    where emp_name = '연흥부';

update temp a
    set 
        tel = (select count(*) from DBA_OBJECTS), 
        salary = (select to_sal from emp_level where lev = a.lev)
    where emp_name = '연흥부';
commit;
--2.
alter table temp drop constraint dept_r;
alter table temp
add constraint fk_from_tdept foreign key (dept_code) references tdept(dept_code);
select * from tdept;
commit;
--3.
update temp
    set
        dept_code = 'HELLLO'
    where emp_id = '19970112';
--4.
delete temp where emp_id = '19970112';
rollback;
--5.
select * from tdept;
delete temp
    where (select area from tdept where temp.dept_code = tdept.dept_code) = '인천';
rollback;
--6.
delete tdept where dept_code = 'AA0001';
--7. TEMP 와 동일한 테이블을 TEMP에서 부서코드가 ‘AA0001’ 인 경우만 SELECT 해서 CREATE. 다시 TEMP 전 ROW를 새로 만든 테이블에 없으면 INSERT 있으면 SALARY를 반으로
create table temp_copy as (select * from temp where dept_code = 'AA0001');
desc temp;
merge into temp_copy c
    using temp e
    on (c.emp_id = e.emp_id)
    when matched then
        update set -- employees와 emp_copy에 동시에 있는 사원은 first_name만 '바보'로 바꿔줌
        c.emp_name = e.emp_name,
        c.dept_code = e.dept_code,
        c.use_yn = e.use_yn
    when not matched then -- employees에는 있는데 emp_copy에 없는 사원은 그대로 정보를 가져와 추가
        insert(c.emp_id, c.emp_name, c.dept_code, c.use_yn)
        values(e.emp_id, e.emp_name, e.dept_code, 'N');
        
/*
    평가 테이블 생성
*/
create table teval(
    ym_ev varchar2(6),
    emp_id number,
    ev_cd number,
    ev_res varchar(1),
    ev_emp  number
);
alter table teval add constraint teval_pk primary key (ym_ev, emp_id, ev_cd);
alter table teval add constraint fk_from_teval_to_temp foreign key (emp_id) references temp(emp_id);
alter table teval add constraint fk_from_teval_to_ttcode foreign key (ev_cd) references ttcode(kno);
alter table teval add constraint fk_from_teval_to_temp2 foreign key (ev_emp) references temp(emp_id);

-- 201902, 201906을 ym_ev로 갖도록 전 사원별 전 항목별로 2회 평가를 실시했다. pk부분을 완성해보자.
insert into teval(ym_ev, emp_id, ev_cd)
    select decode(m.rn, 1, '201906', '201912') as ev_ym, e.emp_id as emp_id, c.kno as ev_cd
    from(select emp_id from temp where lev in (select lev from emp_level)) e, 
        (select kno from ttcode where mcd = 'A002') c, 
        (select rownum as rn from temp where rownum <= 2) m
    order by 1, 2, 3;

-- select문
select decode(m.rn, 1, '201906', '201912') as ev_ym, e.emp_id as emp_id, c.kno as ev_cd
from(select emp_id from temp where lev in (select lev from emp_level)) e, 
    (select kno from ttcode where mcd = 'A002') c, 
    (select rownum as rn from temp where rownum <= 2) m
order by 1, 2, 3;
-- 강사님 select문
select  decode(no,1,'201906',2,'201912'), 
        a.emp_id,
        b.kno
from temp a, ttcode b, emp_level c, t1_data d
where a.lev = c.lev
and b.mcd = 'A002'
and d.no <=2
order by 1,2,3;

select * from tdept;
desc teval;

-- 실습 테이블 수정
update tdept
    set boss_id = '19960303'
    where dept_code = 'CB0001';
    
-- 부서장을 평가자로 update
update teval e -- update는 행 단위로 이루어 지므로, e를 통해 하나의 행에 대한 정보를 추출할 수 있따.
    set ev_emp = 
        (select boss_id from tdept where dept_code = 
            (select dept_code from temp where emp_id = e.emp_id));
-- 강사님 풀이
update teval e
    set ev_emp = 
        (select boss_id from temp a, tdept b where a.dept_code = b.dept_code and a.emp_id = e.emp_id);
/* ?? set from절?  oracle에서는 불가능       
update teval e
    set ev_emp = x.boss_id
    from (select a.emp_id, b.dept_code, b.boss_id
          from temp a, tdept b
          where a.dept_code = b.dept_code) x
    where e.emp_id = x.emp_id;
    

  select a.emp_id, b.dept_code, b.boss_id
          from temp a, tdept b
          where a.dept_code = b.dept_code  ;*/

-- 실습 데이터 추가 및 수정
insert into teval(ym_ev, emp_id, ev_cd) 
select '2019'||'01', a.emp_id, b.kno
from temp a, ttcode b
where b.mcd = 'A002';
update teval z
    set ev_emp = (select boss_id from temp a, tdept b where a.dept_code = b.dept_code and a.emp_id = z.emp_id)
    where ym_ev = '201901';
alter table temp add (eval_yn varchar2(1));

/*
과제
8. 2019년 6월 평가 자료를 읽어 평가대상자로 등록된 경우만 직원테이블 EVAL_YN을 
   Y로 변경 아니면 N 로 변경  후 COMMIT
*/
select * from teval;
update temp
    set eval_yn = decode(
        (select count(emp_id) from teval where ym_ev = '201906'),0, 'N','Y');
commit;

-- 추가문제
--1.
select * from temp;
select * from teval ev
    where (select eval_yn from temp e where ev.emp_id = e.emp_id) = 'N'
    and ym_ev = '201901';
--2.
create table temp1 as select * from temp where temp.hobby is null;
