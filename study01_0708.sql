/*
    0708 Join
    
    pre-to-do
        employees 실습 자료 생성
        sqlplus: @hr_edit_main
*/

select * from employees;
select emp_id, emp_name, dept_code from temp order by 3;

select dept_code, dept_name from tdept order by 1;
--equijoin (=조건)
select temp.emp_id, temp.emp_name, temp.dept_code, tdept.dept_code, tdept.dept_name from temp, tdept where emp_id = 19970101 and temp.dept_code = tdept.dept_code;
--non-equijoin (기타 다른조건)
select temp.emp_id, temp.emp_name, temp.dept_code, tdept.dept_code, tdept.dept_name from temp, tdept where emp_id = 19970101 and temp.dept_code < tdept.dept_code;

select distinct dept_code from tdept; -- 10개
select dept_code from tdept order by 1;

-- 아래 두 개는 distinct하지만 서로 같지 않다
-- 그럼, join시에 서로 달라 한쪽에 없는 것들은?
select emp_id from temp;
select distinct boss_id from tdept order by 1;

-- inner join (한쪽에 없는 것 없어짐, default)
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id = tdept.boss_id order by 1;
-- outter join (반대쪽에 없어도 null로 표출), (+)를 펼칠 대상에 놓는다
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id = tdept.boss_id(+) order by 1;
select temp.emp_id, tdept.boss_id from temp, tdept where temp.emp_id(+) = tdept.boss_id order by 1;

-- self join 
select a.emp_id, a.emp_name, b.emp_id, b.emp_name from temp a, temp b where a.emp_id = b.emp_id;

-- equijoin (부서코드 안들어간 직원은 안나온다.)
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id
    order by 1;   
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id
    and e.last_name = 'King' -- King을 last_name으로 갖는 직원만 표출
    order by 1;

-- 3테이블 이상의 equijoin: 테이블 수 - 1개만큼의 조건 필요
desc locations;
desc departments;
select e.employee_id, e.last_name, e.department_id, d.department_id, d.location_id, l.city
    from employees e, departments d, locations l
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    order by 1;

/*
salarygrade 바꿔서 쓰려다가 타입안맞아서 걍 날려버림...ㅎㅎ
alter table salarygrade rename column grade to grade_level;
alter table salarygrade rename column losal to lowest_sal;
alter table salarygrade rename column hisal to highst_sal;
alter table salarygrade rename to job_grades;
truncate table job_grades;
drop table job_grades;


CREATE TABLE JOB_GRADES(
   GRADE_LEVEL VARCHAR2(10) NOT NULL PRIMARY KEY,
   LOWEST_SAL NUMBER,
   HIGHEST_SAL NUMBER
   );

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('A',1000,2999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('B',3000,5999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('C',6000,9999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('D',10000,14999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('E',15000,24999);

INSERT INTO JOB_GRADES(GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL)
VALUES('F',25000,40000);
*/

-- non-equijoin
select e.last_name, e.salary, j.grade
    from employees e, jobs j
    where 
;

-- outter join 
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id(+) -- (부서 없는 직원 표출)
    order by 1; 
select e.employee_id, e.last_name, e.department_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id -- (직원 없는 부서 표출)
    order by 1; 

--self join(하나의 테이블을 두 개 처럼, 별칭 사용 필수)
select e.employee_id, m.employee_id
    from employees e, employees m
    where e.manager_id = m.employee_id
    order by 1;

-- ANSI join senteces
-- cross join
select count(*) from employees cross join departments;
select count(*) from employees; --107
select count(*) from departments; --27
-- cross join --2889 = 107 * 27, join조건이 없는 경우 모든 경우의 수 다 나타냄
select count(*) from employees cross join departments; 

-- natural join (natural 생략가능): 컬럼명+데이터타입 같은 컬럼 찾아 join (하나만 같은 경우), equi조인
select last_name, department_name from employees natural join departments;
-- using절 (여러 개 컬럼 같은 경우 명시 필요, natural 안붙여야)
select last_name, department_name from employees join departments using (department_id);
-- on절 (같은 특성의 컬럼이 있지만 컬럼 이름이 다른 경우 명시 필요)
select e.last_name, d.department_name from employees e join departments d on (e.department_id = d.department_id);
select e.last_name ,d.department_name, l.city
    from employees e 
    join departments d 
    on (e.department_id = d.department_id)
    join locations l
    on (d.location_id = l.location_id);

-- outer join
-- left outer join(부서 없는 직원 표출)
select e.last_name, e.department_id, d.department_name from employees e left outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id(+);
-- right outer (직원 없는 부서 표출)
select e.last_name, e.department_id, d.department_name from employees e right outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id;
-- full outer join (둘다)
select e.last_name, e.department_id, d.department_name from employees e full outer join departments d on (e.department_id = d.department_id);
select e.employee_id, e.last_name, d.department_name 
    from employees e, departments d
    where e.department_id(+) = d.department_id(+); -- ERR - ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다(ANSI표준에서만 가능한 기능)

-- 실습: 10000건짜리 조인된 테이블을 만들어보기
select count(*) from temp cross join user_tables cross join test17;
select count(*) from temp, user_tables, test17;
create table t1_data as select rownum as NO from temp cross join user_tables cross join test17 where rownum <= 10000;
select * from t1_data;

-- 실습용 테이블 생성
create table tcom (
    work_year varchar2(04) not null,
    emp_id number not null,
    bonus_rate number,
    comm number,
    constraint com_pk primary key (work_year, emp_id)
);
insert into tcom
select '2018', EMP_ID, 1, salary * 0.01
from temp
where dept_code like 'C%';
commit;

--새로운 실습테이블 생성
create table emp_level (
    lev varchar2(10) primary key,
    from_sal number,
    to_sal number,
    from_age number,
    to_age number
);
INSERT INTO EMP_LEVEL VALUES ('사원',30000000,50000000,20,27);
INSERT INTO EMP_LEVEL VALUES ('대리',40000000,60000000,23,33);
INSERT INTO EMP_LEVEL VALUES ('과장',50000000,75000000,29,36);
INSERT INTO EMP_LEVEL VALUES ('차장',60000000,80000000,33,44);
INSERT INTO EMP_LEVEL VALUES ('부장',70000000,100000000,37,55);
INSERT INTO EMP_LEVEL VALUES ('임원',100000000,300000000,20,88);
commit;

/*
과제
1. TEMP와 TDEPT 를 부서코드로 조인하여 사번,성명,부서코드,부서명 가져오기 
   단, SALARY가 9천만원 보다 큰 직원에 대해서
2. 2019년에 커미션을 받는 직원의 사번,성명,부서코드,부서명, 커미션 가져오기   
3. TEMP에서 박문수보다 급여를 적게받는 직원 검색
4. EMP_LEVEL 에서 급여 산술평균을 구하고 TEMP 사원 중 자기 직급의 산술평균(상한과 하한 평균) 보다 급여가 작은 직원 가져오기
5. TEMP ,TCOM을 EMP_ID로 연결하여 모든 정보를 가져오되, TEMP에 존재하는 자료 기준 모두 
6. EMP_ID 마다 자신보다 SALARY가 높은 인원 COUNT
7. TEMP 와 TDEPT CARTESIAN PRODUCT 생성
8. TEMP 와 TDEPT NATURAL JOIN
9. TEMP 와 TDEPT USING절 사용 NATURAL JOIN
10. NATURAL JOIN ON 을 사용하여 사원,부서,EMP_LEV 정보 조인
11. 사번, 성명, TEMP.부서코드, TDEPT.부서코드 , 부서명을 가져오는 LEFT OUTER JOIN 수행
12. 11번을 FROM절에 오는 테이블과 outer JOIN절에 오는 테이블만 바꿔서 수행
13. 사번, 성명, TEMP.부서코드, TDEPT.부서코드 , 부서명을 가져오는 RIGHT OUTER JOIN 수행
*/
-- 1.
select e.emp_id, e.emp_name, d.dept_code, d.dept_name
    from temp e, tdept d 
    where e.dept_code = d.dept_code 
    and e.salary > 90000000;
-- 2.
select * from tcom;
select e.emp_id, e.emp_name, e.dept_code, d.dept_name, c.comm
    from temp e, tdept d, tcom c
    where e.dept_code = d.dept_code
        and e.emp_id = c.emp_id
        and c.work_year = '2019'
    order by e.emp_id;
-- 3. *****
select * from temp;
select a.emp_id, a.emp_name, a.salary
    from temp a, temp b -- 모든 조합 중 조건에 맞는 걸 어떻게 선택? (모든 조합 > 모두에 대한 모두의 대소비교 가능)
    where a.salary < b.salary
        and b.emp_name = '박문수'; -- 박문수보다 급여가 작다: 한쪽이 급여가 작다 + 다른쪽의 이름은 박문수다
    -- 혹은 박문수만 있는 1행짜리 테이블과 전체 테이블을 salary기준으로 조인한다고 생각할수도 있다.
-- 4.
select * from emp_level;
select * from temp;
select lev, (from_sal + to_sal) / 2 as avg_sal from emp_level;
select e.emp_id, e.emp_name, e.salary, e.lev, (s.from_sal + s.to_sal) / 2 as lev_avg_sal
    from temp e, emp_level s
    where e.lev = s.lev
        and e.salary < (s.from_sal + s.to_sal) / 2
    order by e.lev, e.emp_id;    

--5. TEMP ,TCOM을 EMP_ID로 연결하여 모든 정보를 가져오되, TEMP에 존재하는 자료 기준 모두 *****
select * -- oracle
    from temp t, tcom c
    where t.emp_id = c.emp_id(+)
        and c.work_year(+) = to_char(sysdate, 'YYYY'); -- oracle에서는 (+)를 모든 조건에 붙여줘야 outer join가능
select * -- ANSI
    from temp a
    left outer join tcom b
    on (a.emp_id = b.emp_id)
    and b.work_year = to_char(sysdate, 'YYYY');

--6. EMP_ID 마다 자신보다 SALARY가 높은 인원 COUNT
select a.emp_id, count(b.salary) as higher_than_me
    from temp a, temp b
    where a.salary < b.salary(+)
    group by a.emp_id
    order by higher_than_me;
--아래 활용    
select a.*, b.emp_id as t
from temp a, temp b
where a.salary < b.salary(+);

--7. TEMP 와 TDEPT CARTESIAN PRODUCT 생성
select * from temp e, tdept d;

--8. TEMP 와 TDEPT NATURAL JOIN
select * from temp natural join tdept;

--9. TEMP 와 TDEPT USING절 사용 NATURAL JOIN
select * from temp join tdept using (dept_code);

--10. NATURAL JOIN ON 을 사용하여 사원,부서,EMP_LEV 정보 조인
select * from temp join tdept on (temp.dept_code = tdept.dept_code) join emp_level on (temp.lev = emp_level.lev);

select * from temp;

--11. 사번, 성명, TEMP.부서코드, TDEPT.부서코드 , 부서명을 가져오는 LEFT OUTER JOIN 수행
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e left outer join tdept d
    on e.dept_code = d.dept_code;

--12. 11번을 FROM절에 오는 테이블과 outer JOIN절에 오는 테이블만 바꿔서 수행
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from tdept d left outer join  temp e 
    on e.dept_code = d.dept_code;

--13. 사번, 성명, TEMP.부서코드, TDEPT.부서코드 , 부서명을 가져오는 RIGHT OUTER JOIN 수행
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e right outer join tdept d
    on e.dept_code = d.dept_code;
/*
    추가문제
    1. outer 조인
    2. outer 조인하되 19사번만
    3. 홀짝월 1:2 비율로 연봉을 나눠 지급하되 매달 커미션 추가지급시 1~12월 컬럼별로 실수령 연봉 테이블 만들기
    4. 과장 직급을 가질만한 나이에 포함되는 사람이 누군지 현재 직급 관련 없이 가져오기
*/
--1
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e full outer join tdept d
    on e.dept_code = d.dept_code;
--2
select e.emp_id, e.emp_name, e.dept_code, d.dept_code, d.dept_name
    from temp e full outer join tdept d
    on e.dept_code = d.dept_code
    where emp_id like '2019%';
--3
create table t2_data as
select emp_id, 
    sal_odd as SAL01, sal_even as SAL02, sal_odd as SAL03, sal_even as SAL04,
    sal_odd as SAL05, sal_even as SAL06, sal_odd as SAL07, sal_even as SAL08,
    sal_odd as SAL09, sal_even as SAL010, sal_odd as SAL011, sal_even as SAL012
from (
    select e.emp_id, ceil(salary / 18 + nvl(c.comm, 0)) as sal_odd, ceil(salary / 9 + nvl(c.comm, 0)) as sal_even
    from temp e, tcom c
    where e.emp_id = c.emp_id(+)
        and c.work_year(+) = to_char(sysdate, 'YYYY')
)
order by emp_id;
--4
select * from emp_level;
select e.*, l.lev as to_lev
    from temp e, emp_level l
    where (sysdate - birth_date) / 365 >= l.from_age and (sysdate - birth_date) / 365 < l.to_age
        and l.lev = '과장';
select e.*, l.lev as to_lev, trunc((sysdate - birth_date) / 365) as age
    from temp e, emp_level l
    where e.birth_date
        between add_months(sysdate, - l.to_age * 12)
        and add_months(sysdate, - l.from_age * 12)
        and l.lev = '과장';
        