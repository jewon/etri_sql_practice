/*
    0724 : Sub
*/
-- pairwise
select employee_id, manager_id, department_id
from employees
where (manager_id, department_id) in
    (select manager_id, department_id -- 직원의 관리자, 부서코드
     from employees
     where employee_id in (174, 178) -- id가 174, 178이고
)
and employee_id not in (174, 178); -- 관리자가 174, 178이 아닌
-- nonpairwise
select employee_id, manager_id, department_id
from employees
where manager_id in
    (select manager_id
     from employees
     where employee_id in (174, 178) -- id가 174, 178이고
)
and department_id in
    (select department_id
     from employees
     where employee_id in (174, 178))
and employee_id not in (174, 178);
-- 대부분 pairwise와 non-pairwise는 같은 결과

-- scalar subquery
select employee_id, last_name,
       (case
        when department_id =
            (select department_id
             from departments
             where location_id = 1800)
        then 'Canada' else 'USA' end) location
from employees;
-- scalar subquery with order by sentence
select employee_id, last_name
from employees e
order by (select department_name
          from departments d
          where e.department_id = d.department_id); -- 쿼리 결과 외부의 순서에 의해 정렬
        
-- corelated subquery
select last_name, salary, department_id
from employees outer
where salary >
      (select avg(salary)
       from employees
       where department_id = outer.department_id);

select e.employee_id, last_name, e.job_id
from employees e
where 2 <= (
            select count(*)
            from job_history
            where employee_id = e.employee_id);

alter table employees
add (department_name varchar2(30));
update employees e
set department_name = (
    select department_name
    from departments d
    where e.department_id = d.department_id);
commit;

-- with sentence
with
dept_costs as (
    select d.department_name, sum(e.salary) as dept_total
    from employees e, departments d
    where e.department_id = d.department_id
    group by d.department_name),
avg_cost as (
    select sum(dept_total) / count(*) as dept_avg
    from dept_costs)
select *
from dept_costs
where dept_total >
    (select dept_avg
     from avg_cost)
order by department_name;

/*
    실습
*/
create table test09 (
    line varchar2(3),
    spec varchar2(10),
    item varchar2(8),
    qty number,
    constraint test09_pk primary key (line, spec, item)
);
create table test10 (
    idate varchar2(8) not null,
    in_seq varchar2(3) not null,
    line varchar2(3) not null,
    spec varchar2(10) not null,
    constraint test10_pk primary key (idate, in_seq, line)
);
INSERT INTO TEST09 VALUES('01','A001','P01',1);                                       
INSERT INTO TEST09 VALUES('01','A001','P03',1);                                       
INSERT INTO TEST09 VALUES('01','A001','P04',1);                                       
INSERT INTO TEST09 VALUES('01','A001','P07',1);                                       
INSERT INTO TEST09 VALUES('01','A001','P08',1);                                       
INSERT INTO TEST09 VALUES('01','A002','P02',4);                                       
INSERT INTO TEST09 VALUES('01','A002','P04',4);                                       
INSERT INTO TEST09 VALUES('01','A002','P05',4);                                       
INSERT INTO TEST09 VALUES('01','A002','P07',4);                                       
INSERT INTO TEST09 VALUES('01','A002','P08',4);                                       
INSERT INTO TEST09 VALUES('01','A003','P01',3);                                       
INSERT INTO TEST09 VALUES('01','A003','P03',3);                                       
INSERT INTO TEST09 VALUES('01','A003','P04',3);                                       
INSERT INTO TEST09 VALUES('01','A003','P06',3);                                       
INSERT INTO TEST09 VALUES('01','A003','P07',3);                                       
INSERT INTO TEST09 VALUES('01','A004','P02',2);                                       
INSERT INTO TEST09 VALUES('01','A004','P03',2);                                       
INSERT INTO TEST09 VALUES('01','A004','P05',2);                                       
INSERT INTO TEST09 VALUES('01','A004','P06',2);                                       
INSERT INTO TEST09 VALUES('01','A004','P07',2);                                       
INSERT INTO TEST09 VALUES('02','A001','P02',2);                                       
INSERT INTO TEST09 VALUES('02','A001','P05',2);                                       
INSERT INTO TEST09 VALUES('02','A001','P06',2);                                       
INSERT INTO TEST09 VALUES('02','A001','P09',2);                                       
INSERT INTO TEST09 VALUES('02','A001','P10',2);                                       
INSERT INTO TEST09 VALUES('02','A002','P01',1);                                       
INSERT INTO TEST09 VALUES('02','A002','P03',1);                                       
INSERT INTO TEST09 VALUES('02','A002','P06',1);                                       
INSERT INTO TEST09 VALUES('02','A002','P09',1);                                       
INSERT INTO TEST09 VALUES('02','A002','P10',1);                                       
INSERT INTO TEST09 VALUES('02','A003','P02',4);                                       
INSERT INTO TEST09 VALUES('02','A003','P05',4);                                       
INSERT INTO TEST09 VALUES('02','A003','P08',4);                                       
INSERT INTO TEST09 VALUES('02','A003','P09',4);                                       
INSERT INTO TEST09 VALUES('02','A003','P10',4);                                       
INSERT INTO TEST09 VALUES('02','A004','P01',3);                                       
INSERT INTO TEST09 VALUES('02','A004','P04',3);                                       
INSERT INTO TEST09 VALUES('02','A004','P08',3);                                       
INSERT INTO TEST09 VALUES('02','A004','P09',3);                                       
INSERT INTO TEST09 VALUES('02','A004','P10',3);                                       
INSERT INTO TEST09 VALUES('03','A001','P01',3);                                       
INSERT INTO TEST09 VALUES('03','A001','P03',3);                                       
INSERT INTO TEST09 VALUES('03','A001','P11',3);                                       
INSERT INTO TEST09 VALUES('03','A001','P13',3);                                       
INSERT INTO TEST09 VALUES('03','A001','P15',3);                                       
INSERT INTO TEST09 VALUES('03','A002','P01',2);                                       
INSERT INTO TEST09 VALUES('03','A002','P02',2);                                       
INSERT INTO TEST09 VALUES('03','A002','P13',2);                                       
INSERT INTO TEST09 VALUES('03','A002','P15',2);                                       
INSERT INTO TEST09 VALUES('03','A002','P16',2);                                       
INSERT INTO TEST09 VALUES('03','A003','P01',1);                                       
INSERT INTO TEST09 VALUES('03','A003','P08',1);                                       
INSERT INTO TEST09 VALUES('03','A003','P11',1);                                       
INSERT INTO TEST09 VALUES('03','A003','P12',1);                                       
INSERT INTO TEST09 VALUES('03','A003','P13',1);                                       
INSERT INTO TEST09 VALUES('03','A004','P01',4);                                       
INSERT INTO TEST09 VALUES('03','A004','P07',4);                                       
INSERT INTO TEST09 VALUES('03','A004','P09',4);                                       
INSERT INTO TEST09 VALUES('03','A004','P11',4);                                       
INSERT INTO TEST09 VALUES('03','A004','P12',4);
INSERT INTO TEST10 VALUES ('19990203','01','01','A001');        
INSERT INTO TEST10 VALUES ('19990203','01','03','A001');        
INSERT INTO TEST10 VALUES ('19990203','02','01','A002');        
INSERT INTO TEST10 VALUES ('19990203','01','02','A002');        
INSERT INTO TEST10 VALUES ('19990203','02','02','A003');        
INSERT INTO TEST10 VALUES ('19990203','02','03','A003');        
INSERT INTO TEST10 VALUES ('19990203','03','01','A001');        
INSERT INTO TEST10 VALUES ('19990203','03','03','A001');        
INSERT INTO TEST10 VALUES ('19990203','04','01','A002');        
INSERT INTO TEST10 VALUES ('19990203','03','02','A002');        
INSERT INTO TEST10 VALUES ('19990203','04','02','A003');        
INSERT INTO TEST10 VALUES ('19990203','04','03','A003');        
INSERT INTO TEST10 VALUES ('19990203','05','01','A001');        
INSERT INTO TEST10 VALUES ('19990203','05','03','A001');        
INSERT INTO TEST10 VALUES ('19990203','06','01','A002');        
INSERT INTO TEST10 VALUES ('19990203','05','02','A002');        
INSERT INTO TEST10 VALUES ('19990203','06','02','A003');        
INSERT INTO TEST10 VALUES ('19990203','06','03','A003');        
INSERT INTO TEST10 VALUES ('19990203','07','01','A001');        
INSERT INTO TEST10 VALUES ('19990203','07','03','A001');        
INSERT INTO TEST10 VALUES ('19990203','08','01','A002');        
INSERT INTO TEST10 VALUES ('19990203','07','02','A002');        
INSERT INTO TEST10 VALUES ('19990203','08','02','A003');        
INSERT INTO TEST10 VALUES ('19990203','08','03','A003');        
INSERT INTO TEST10 VALUES ('19990203','09','01','A001');        
INSERT INTO TEST10 VALUES ('19990203','09','03','A001');        
INSERT INTO TEST10 VALUES ('19990203','10','01','A002');        
INSERT INTO TEST10 VALUES ('19990203','09','02','A002');        
INSERT INTO TEST10 VALUES ('19990203','10','02','A003');        
INSERT INTO TEST10 VALUES ('19990203','10','03','A003');   
COMMIT;


INSERT INTO TEST10 VALUES ('19990204','10','04','A003');  

select * from test09;
select * from test10;
order by line;

-- 1.



select * from test09 where item = 'P16';
select * from test10 where line = '03' and spec = 'A002';
select distinct spec from test10 where line = '03';
select distinct line from test10 where spec = 'A002';
select * from test10;

-- pairwise
select distinct item
from test09
where (line, spec) in
    (select line, spec -- 직원의 관리자, 부서코드
     from test10 -- id가 174, 178이고
)
order by 1;
-- nonpairwise
select distinct item
from test09
where line in
    (select line -- 직원의 관리자, 부서코드
     from test10
) and spec in
    (select spec
     from test10
) order by 1;


(
    select *
    from test09
    where line in
        (select line -- 직원의 관리자, 부서코드
         from test10
    ) and spec in
        (select spec
         from test10
    )
) minus (
    select *
    from test09
    where (line, spec) in
        (select line, spec
         from test10
    )
);

select * from test10;
select * from test09;

--2. 소요예상 부품의 부품별 개수를 파악해 발주, 전체 공정에 투입될 부품 리스트와 부품별 발주 수량 파악
select * from test10;
select item, sum(qty)
from test10 a, test09 b
where a.line = b.line
    and a.spec = b.spec
group by item
order by 1;

--3. 1999년 2월 3일 생산을 지원하기 위해 생산 전에 해당 생산 라인마다 필요한 부품을 정확히 공급해야 합니다.
--3.1 생산라인마다 필요한 부품별 소요갯수 파악
select a.line, item, sum(qty)
from test10 a, test09 b
where a.line = b.line
    and a.spec = b.spec
group by (a.line, item)
order by 1, 2;

--3.2 JUST IN TIME 생상을 위해 하루 2시간마다 5번 투입이 이루어진다면 투입 순번에 두 시간 마다 라인별로 투입되어야 할 부품의 개수를 구하시오
select t, a.line, item, sum(qty)
from (select b.*, ceil(in_seq / 2) as t from test10 b) a, test09 b -- with inline view
where a.line = b.line
    and a.spec = b.spec
group by t, a.line, item
order by 1, 2, 3;

select ceil(a.in_seq / 2) t, a.line, item, sum(qty)
from test10 a, test09 b
where a.line = b.line
    and a.spec = b.spec
group by ceil(a.in_seq / 2), a.line, item
order by 1, 2, 3;

/*
    1. 사번,성명, 부서코드를 구해오되 부서장 사번이 빠른 순으로 정렬 (JOIN 없이 서브쿼리 사용)
    2. 소속된 부서의 평균 봉급보다 많은 봉급을 받는 직원의 이름, 급여, 부서코드 
    3. 부서가 3개보다 많이 위치해 있는 지역에 위치한 부서에 근무하는 사원의 사번,이름,부서코드  
    4. 이순신의 SALARY를 현재 직급의 상하한 평균으로 변경하는 쿼리 작성 후 COMMIT;
    5. 근무지가 인천이면 10%, 서울이면 7%, 나머지는 5% 인상하여 UPDATE
    6. 자신을 제외하고 자신과 직급이 같은 직원 누구보다도 더 많은 급여를 받는 직원 삭제
*/
--1.
select emp_id, emp_name, dept_code
from temp e
order by (select boss_id from tdept where e.dept_code = dept_code);
--2.
select emp_name, salary, dept_code
from temp e
where salary > (select avg(salary) from temp where e.dept_code = dept_code);
--3.
select emp_id, emp_name, dept_code
from temp e
where 3 < (select count(dept_code) from tdept where area = (select area from tdept where dept_code = e.dept_code));
--4.
update temp e
set salary = (select (from_sal + to_sal) / 2 from emp_level where lev = (e.lev))
where emp_name = '이순신';
select * from temp where emp_name = '이순신';
commit;
--5.
update temp e
set salary = e.salary * decode((select area from tdept where dept_code = e.dept_code), '인천', 1.1, '서울', 1.07, 1.05);
--6.
select *
from temp e
where salary = (select max(salary) from temp where lev = e.lev)
    and 1 = (select count(salary) from temp where lev = e.lev and salary = (select max(salary) from temp where lev = e.lev));

select *
from temp a
where salary > all (
    select salary from temp b
    where b.lev = a.lev
    and a.emp_id <> b.emp_id);
    

