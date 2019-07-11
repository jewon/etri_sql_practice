/*
    0709 서브쿼리와 치환변수
*/
-- 실습데이터 수정
update tdept set boss_id = decode(dept_code, 'AA0001', 19970101, 'BA0001', 19930331) where dept_code in ('AA0001', 'BA0001');

-- 행/열 전환해보기 (직원별 12개 컬럼에 각각의 월급 > 직원 + 월을 키로 갖는 월급 테이블)
select a.emp_id, lpad(b.no, 2, '0') || '월' as pay_mon, 
        decode(b.no, 1, a.SAL01, 2, a.SAL02, 3, a.SAL03, 4, a.SAL04, 5, a.SAL05, 
            6, a.SAL06, 7, a.SAL07, 8, a.SAL08, 9, a.SAL09, 10, a.SAL10, 11, a.SAL11, a.SAL12) 
        as PAY_AMT 
    from t2_data a, t1_data b
    where b.no < 13
    order by emp_id, pay_mon;
    
/*
    서브쿼리
    단일행 서브쿼리: 결과값이 하나, 서브쿼리의 결과와 단일행 비교연산자 사용(=, <>, <, >, <=, >=)
    다중행 서브쿼리: 결과 값이 둘 이상, 서브쿼리 결과와 다중행 비교연산자 사용(IN, >ANY, <ANY, >ALL, <ALL)
*/
-- ex.
select last_name, salary, (select salary from employees where last_name = 'Kochhar') as KochharSal 
from employees where salary > (select salary from employees where last_name = 'Kochhar');

-- 단일행 서브쿼리
-- 조건에서의 서브쿼리: 101사원과 같은 부서에 있으면서 141사원보다 급여가 많은 사원
select last_name, department_id, salary 
from employees
where department_id = 
        (select department_id from employees where employee_id = 101) 
    and salary > 
        (select salary from employees where employee_id = 141);
-- Group함수와의 사용: 가장 많은 월급을 받는 직원의 이름과 월급
select last_name, salary from employees where salary = (select max(salary) from employees);
-- having절에서의 서브쿼리: 60부서 최소 봉급보다 최소 봉급이 적은 부서
select department_id, min(salary) 
from employees 
group by department_id 
having min(salary) > 
    (select min(salary) from employees where department_id = 60);

-- 다중행 서브쿼리
-- IN연산자 사용: 부서별 최대 봉급을 자신의 봉급으로 하는 사원(부서별 최고 봉급 사원과는 다르다)
select last_name, salary from employees
    where salary in (select max(salary) from employees group by department_id);
-- ANY연산자 사용: IT_PROG직무를 가진 사원의 봉급 중 어떤 하나보다 작은 봉급을 가진 IT_PROG외의 직무를 가진 사원
select last_name, job_id, salary from employees
    where salary <ANY (
        select salary
        from employees
        where job_id = 'IT_PROG')
    and job_id <> 'IT_PROG';
-- 서브쿼리 NULL값 반환: 서브쿼리 결과가 NULL일 경우 메인쿼리 결과도 NULL
select last_name, department_id
from employees
where department_id = (
    select department_id
    from employees
    where last_name = 'Hugo');
/*
    치환변수
*/
-- &: 실행시에 입력 받게 된다. 변수와는 다르게 단순히 &에 해당하는 부분을 치환하는 개념.(사용될 때 마다 지정)
select last_name, salary from employees where salary = &sal;
select last_name, salary from employees where last_name = '&name';
-- &&: 같은 치환변수가 여러 번 사용시 한번만 입력받음
select last_name, salary, &&col from employees order by &col;
-- DEFINE: 치환변수에 
define v_empid = 300;
select last_name from employees where employee_id = &v_empid;

-- 다중컬럼 쿼리와의 비교
select * from temp where (emp_type, hobby) = (select emp_type, hobby from temp where emp_id = 19970101);
select * from temp where (emp_type, hobby) = (select emp_type, hobby from temp where dept_code like 'C%'); -- ERR ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
select * from temp where (emp_type, hobby) in (select emp_type, hobby from temp where dept_code like 'C%');

/*
과제
    1. SALARY 가 강감찬보다 많은 직원의 이름,SALARY 가져오기
    2. 부서가 김길동과 같고 SALARY가 강감찬보다 많은 사번,성명,부서코드,SALARY 가져오기
    3. 가장 월급을 많이 받는 사람의 이름, SALARY 검색 (서브쿼리)
    4. 부서별 최저월급을 출력하되 BC0001부서의 최저월급보다는 큰 값만 가져오기
    5. 각 부서 최저 SALARY와 SALARY가 같은 직원 정보 검색
    6. 직급이 차장인 사람들 중 누구든 어느 한 사람보다는 급여를 많이 받는 사원 정보 가져오기 
    7. 직급이 사원인 어느 누구보다 급여를 많이 받는 사원 정보 가져오기 
    8. 19950303 직원의 취미와 취미가 같은 사원 정보 가져오기
*/
--1.
select emp_name, salary 
    from temp 
    where salary > 
        (select salary 
            from temp
            where emp_name = '강감찬');
--2.
select emp_id, emp_name, dept_code, salary
    from temp
    where dept_code =
        (select dept_code
            from temp
            where emp_name = '김길동')
    and salary >
        (select salary
            from temp
            where emp_name = '강감찬');
--3.
select emp_name, salary
from temp
where salary = (
    select max(salary) from temp);
--4.
select dept_code, min(salary)
from temp
group by dept_code
having min(salary) > 
    (select min(salary) 
        from temp
        group by dept_code
        having dept_code = 'BC0001');
--5.
select e.emp_name, e.salary
from temp e, 
    (select dept_code, min(salary) as minsal
        from temp
        group by dept_code) s
where e.dept_code = s.dept_code
and e.salary = s.minsal;

select emp_name, salary
from temp e
where salary = 
    (select min(salary)
        from temp s
        where e.dept_code = s.dept_code);
--6.
select emp_name, salary
from temp
where salary >ANY
    (select salary
        from temp
        where lev = '차장');
--7.
select emp_name, salary
from temp
where salary >ALL
    (select salary
        from temp
        where lev = '사원');
--8.
select emp_name, hobby
from temp
where nvl(hobby, 'N') = 
    nvl((select hobby
        from temp
        where emp_id = '19950303'), 'N');
/*
9. &SAL 이라는 치환변수를 입력받아 변수값과 SALARY가 같은 사원 검색 쿼리 작성 후 
   (변수 값에 50000000, ‘50000000’, ‘5천만원’ 을 넣어 각각 실행해보기 
10. 9번 치환변수를 앞뒤로 작은 따옴표 붙여 재실행
   (변수 값에 50000000, ‘50000000’ 을 넣어 각각 재실행)
11. HOBBY를 &HOBBY를 통해 입력받아  HOBBY와 입력값이 같은 정보 검색 쿼리 작성 후
   (변수 값에 등산, ‘등산’ 을 넣어 각각 재실행)
12. 11번 치환변수를 앞뒤로 작은 따옴표 붙여 재실행
   (변수 값에 등산, ‘등산’ 을 넣어 각각 재실행)
13. 자기 직급의 평균 연봉보다 급여가 적은 직원정보 가져오기 
14. 인천에 근무하는 직원 가져오기 (서브쿼리 이용)  
*/
--9.
select emp_name, salary
from temp
where salary = &sal;

--10.
select emp_name, salary
from temp
where salary = '&sal';

--11.
select emp_name, hobby
from temp
where hobby = &hobby;

--12.
select emp_name, hobby
from temp
where hobby = '&hobby';

--13.
select emp_name, lev, salary,
    round((select avg(salary) from temp where lev = e.lev)) as lev_avgsal
from temp e
where salary < 
    (select avg(salary) as avgsal
     from temp s
     where e.lev = s.lev)
order by lev, emp_name;

--14.
select e.emp_name, e.dept_code
from temp e
where (select area 
        from tdept
        where dept_code = e.dept_code) = '인천';
        
/*
1. TCOM에 연봉 외에 commission을 받는 직원의 사번이 보관되어 있다. 이 정보를 sub query로 select하여 부서 명칭별로 commission을 받는 인원수를 세는 문장을 만들기.
2. 치환변수로 숫자를 한 번만 입력받아 입력값, 입력값 +10, 입력값 * 10 을 구하는 쿼리
3. 입력되는 parameter 값에 따라 group by 를 하고 싶은 경우 query 작성
    조건1: 입력되는 grouping 단위는 두 개 까지 가능함 (예: 취미별 부서명별)
            하나만 들어올 수도 있음 (예:직급별)
    조건2: 집계 자료는 그룹별 salary 평균, 해당인원수, 그룹별 salary 총합
    조건3: 입력 가능한 group 단위는 다음과 같음. 부서코드, 부서명, 취미, 직급, 채용형태     
*/
select * from temp;
-- 1.
-- 그냥 커미션 받는 부서만
select dept_code, count(*) as cnt
        from temp
        where emp_id in (select distinct emp_id from tcom)
        group by dept_code;
-- 모든 부서에서 커미션 받는 사원 수
select b.dept_name, nvl(a.cnt, 0) as comm_emp_count
    from tdept b left outer join
        (select dept_code, count(*) as cnt
            from temp
            where emp_id in (select distinct emp_id from tcom)
            group by dept_code) a 
        on (a.dept_code = b.dept_code)
    order by 1; -- 가장 바깥 inline view는 null처리 위함
-- oracle
select dept_name, count(commyn)
from (
    select b.dept_name, (Select distinct(c.emp_id) from tcom c where c.emp_id = a.emp_id) commyn
    from temp a, tdept b
    where b.dept_code = a.dept_code)
group by dept_name
order by 1;

-- 2.
select &&test + 10, &test - 10 from dual;
-- 3.
select decode('&grou1', '부서코드', temp.dept_code, '부서명', dept_name, '직급', lev, '취미', hobby, '채용형태', emp_type, emp_id) as group1, 
    decode('&grou2', '부서코드', temp.dept_code, '부서명', dept_name, '직급', lev, '취미', hobby, '채용형태', emp_type, null) as group2,
    round(avg(salary)) as avgsal, count(*) as count, sum(salary) as sumsal
from temp left outer join tdept on (temp.dept_code = tdept.dept_code)
group by decode('&grou1', '부서코드', temp.dept_code, '부서명', dept_name, '직급', lev, '취미', hobby, '채용형태', emp_type, emp_id),
    decode('&grou2', '부서코드', temp.dept_code, '부서명', dept_name, '직급', lev, '취미', hobby, '채용형태', emp_type, null)
order by 1;