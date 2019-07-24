/*
    0723
*/
-- rollup, cube
select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by department_id, job_id;

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by rollup(job_id, department_id); -- job_id를 롤업하고(소계), job_id+dep_id를 롤업(합계)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by rollup(department_id, job_id); -- dep_id를 롤업(소계), dep_id+job_id를 롤업(합계)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by rollup(job_id), department_id; -- job_id를 롤업(소계)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by job_id, rollup(department_id); -- dep_id를 롤업(소계)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by cube(job_id, department_id); -- dep_id 롤업(소계), job_id 롤업(소계), dep_id+job_id롤업(합계)
-- cube안에 한 컬럼만 있을 경우 rollup과 차이 없음

-- grouping 함수: 롤업되는 것을 0, 1로 구분해줌
select department_id dept, job_id job, sum(salary),
    grouping(department_id) grp_dept,
    grouping(job_id) grp_job
from employees
where department_id < 50
group by rollup(department_id, job_id);

-- grouping sets
--(
select department_id, job_id, manager_id, avg(salary)
from employees
group by grouping sets -- 두 개의 group by절을 union all 한 것과 같음
((department_id, job_id), (job_id, manager_id));
--) minus (
select department_id, job_id, null as manager_id, avg(salary)
from employees
group by department_id, job_id
union all
select null as department_id, job_id, manager_id, avg(salary)
from employees
group by job_id, manager_id;
--)
-- minus 결과 null

-- 여러 가지 응용
select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by grouping sets(department_id, job_id, ()); -- dep_id별 소계, job_id별 소계, dep_id+job_id롤업(합계)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by grouping sets(department_id, rollup(department_id, job_id)); -- dep_id별 소계, dep_id, job_id별 소계, 합계

select department_id, job_id, manager_id, sum(salary)
from employees
group by rollup (department_id, (job_id, manager_id));

-- 연쇄grouping
select department_id, job_id, manager_id, sum(salary)
from employees
group by department_id, rollup(job_id), cube(manager_id);

/*
    Rank와 Dense_Rank: 쿼리 결과에 대한 함수들
    
    RANK(expr [, expr ]...) WITHIN GROUP
       (ORDER BY
        expr [ DESC | ASC ]
             [ NULLS { FIRST | LAST } ]
        [, expr [ DESC | ASC ]
                [ NULLS { FIRST | LAST } ]
        ]...
       )
*/
select emp_id, emp_name, salary,
    rank() over(order by salary) c1,
    rank() over(order by salary desc) c2, -- 사람 기준 위치(동순위시 다음 순위는 +동순위명수)
    dense_rank() over(order by salary desc) c3  -- salary기준 위치(동순위시 다음 순위는 다음 숫자)
from temp;

select dept_code, emp_id, emp_name, salary,
    rank() over( 
        partition by dept_code -- 부서별 
        order by salary desc -- sal 높은 순위
    ) c3
from temp;

select dept_code, emp_id, sum(salary), grouping(dept_code), grouping(emp_id),
    rank() over(
        partition by grouping(dept_code), -- dept_code가 롤업된 것과 아닌 것
                     grouping(emp_id) -- emp_id가 롤업된 것과 아닌 것 구분
                     -- 전체 롤업(합계) / dept_code롤업(emp_id별 소계) - 자료없음 / emp_id롤업(dept_code별 소계) / group by 상태
        order by sum(salary) desc
    ) c1                 
from temp
group by rollup(dept_code, emp_id); -- dept_code 롤업(emp_id별 소계) / dept_code, emp_id롤업 (합계)

/*
    실습

*/

--1 일자별 매출순위, 순위별 사업장, 품목
select sale_date, sale_site, sale_item, sale_amt,
    rank() over(
        partition by sale_date
        order by sale_amt desc
    ) c1                 
from sale_hist;

--2
select emp_id, emp_name, salary,
    rank() over(order by salary) c1,
    cume_dist() over(order by salary) c2, -- 꼴찌를 1로 끝 (rank기준)
    percent_rank() over(order by salary) c3 -- 1위를 0으로 시작 (rank-1 기준)
from temp;

--3
select emp_id, emp_name, salary,
    row_number() over (partition by substr(emp_id, 1, 4)
        order by salary desc) c4
from temp;

select sale_date, sale_site, sale_item, sale_amt,
    sum(sale_amt) over (
        partition by sale_item
        order by sale_item
        rows unbounded preceding) as c1 -- 자신보다 상위에 있는 row들의 sal_amt를 sum(누적)
from sale_hist
where sale_site = '01';

-- 일자별 사업장별 매출액 합과 매출3일 이동평균
select to_date(sale_date, 'yyyymmdd'), sale_site, sum(sale_amt),
    avg(sum(sale_amt)) over (
        partition by sale_site
        order by to_date(sale_date, 'yyyymmdd')
        range interval '2' day preceding) as s_sum
from sale_hist
group by sale_date, sale_site;

select emp_id, salary, sum(salary) over (order by emp_id rows 3 preceding) sum_sal, 
    count(salary) over (order by emp_id rows 3 preceding) cnt,
    avg(salary) over (order by emp_id rows 3 preceding) avg
from temp;

-- 각 row의 판매액, 동일일자/동일품목의 최대판매
select sale_date, sale_item, sale_site, sale_amt,
       first_value(sale_amt) over (
          partition by sale_date, sale_item
          order by sale_amt
          rows between unbounded preceding
          and unbounded following
        ) first_amt, 
        first_value(sale_site) over (
          partition by sale_date, sale_item
          order by sale_amt
          rows between unbounded preceding
          and unbounded following
        ) first_site
from sale_hist;

-- 각 row의 판매액, 동일일자/동일품목의 최대판매액, 최대판매액사업장, 최소판매액, 최소판매액사업장
select sale_date, sale_item, sale_site, sale_amt, 
       first_value(sale_amt) over (
          partition by sale_date, sale_item
          order by sale_amt
          rows between unbounded preceding
          and unbounded following
        ) first_amt, first_value(sale_site) over (
          partition by sale_date, sale_item
          order by sale_amt
          rows between unbounded preceding
          and unbounded following
        ) first_site, first_value(sale_amt) over (
          partition by sale_date, sale_item
          order by sale_amt desc
          rows between unbounded preceding
          and unbounded following
        ) last_amt, first_value(sale_site) over (
          partition by sale_date, sale_item
          order by sale_amt desc
          rows between unbounded preceding
          and unbounded following
        ) last_site
from sale_hist;

-- ratio_to_report
select sale_date, sum(sale_amt) smat,
    sum(sum(sale_amt)) over() as tot1, -- over에 조건 안줘서 총합 구함
    ratio_to_report(sum(sale_amt)) over() as rat1 -- total에서 smat의 비율
from sale_hist
group by sale_date;

-- lag, lead
select sale_date, sale_site, sale_item, sale_amt, 
    lag(sale_amt, 1) over( -- 이전 레코드 가져옴 (밀림)
            partition by sale_site, sale_item
            order by sale_date, sale_site, sale_item
        ) lag_amt,
    lead(sale_amt, 1) over( -- 다음 레코드 가져옴 (땡김)
            partition by sale_site, sale_item
            order by sale_date, sale_site, sale_item
        ) lead_amt
from sale_hist;

--sale_hist의 자료를 이용해 '01'사업장 'PENCIL' 품목의 일자별 누적 판매금액을 구하라
select sale_date,
    sum(sale_amt) over (order by sale_date rows unbounded preceding) cum_sum
from sale_hist
where sale_site = '01' and sale_item = 'PENCIL';

--품목별/일자별로 과거판매액을 모두 이용하는 이동편균값
select sale_date, sale_item, sum(sale_amt),
    round(avg(sum(sale_amt)) over (partition by sale_item order by sale_date rows unbounded preceding)) mw_avg
from sale_hist
group by sale_date, sale_item;

/*
    1. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오는 쿼리
    2. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오되 부서별 중간 소계와
       전체 합계를 함께 보여주는 쿼리
    3. 직원정보에서 부서별,채용 구분 별로 SALARY의 합계, 대상건수, 평균을 구해오되 
       부서별 중간 소계, 채용 구분별 소계, 합계를 함께 보여주는 쿼리   
    4. 3번쿼리에서 2번 쿼리를 집합연산자 MINUS를 이용하여 차이 나는 DATA 알아보기    
    5. 2번과 3번 쿼리에서 부서코드와 채용구분에 각각 GROUPING 함수를 적용할 경우 어떤 값들을 리턴 되는지 확인 
*/
--1.
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary))
from temp
group by dept_code, emp_type;
--2.
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary))
from temp
group by rollup(dept_code, emp_type);
--3.
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary))
from temp
group by cube(dept_code, emp_type);
--4.
(select dept_code, emp_type, sum(salary), count(salary), round(avg(salary))
from temp
group by cube(dept_code, emp_type)
) minus (
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary))
from temp
group by rollup(dept_code, emp_type)); -- dept_code가 롤업되어 emp_type별 소계가 rollup에는 없다
--5.
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary)), grouping(dept_code), grouping(emp_type)
from temp
group by cube(dept_code, emp_type);

/*
6. TEMP 의 자료를 SALARY로 분류 하여 30000000 이하는 'D',
                      30000000 초과 50000000 이하는 'C'
                      50000000 초과 70000000 이하는 'B' 
                      70000000 초과는 'A'
    라고 등급을 분류하여 등급별 인원수 확인
*/
select
    case 
        when salary <= 30000000 then 'D'
        when salary between 30000001 and 50000000 then 'C'
        when salary between 50000001 and 70000000 then'B'
        when salary > 70000000 then 'A' end as grade, 
    count(*)
from temp
group by
    case 
        when salary <= 30000000 then 'D'
        when salary between 30000001 and 50000000 then 'C'
        when salary between 50000001 and 70000000 then'B'
        when salary > 70000000 then 'A' end
order by 1;

/*
7. 직원정보에서 부서코드, 채용구분, 직급과 SALARY 평균을 가져오되 
   1).부서,채용구분 2).채용구분,직급 3).부서,직급 의 세 가지 조합으로 
      GROUP BY 결과가 나올 수 있도록 GROUPING SETS 적용
8. 직원정보에서 부서코가 A로 시작하는 부서 소속 직원의 부서코드, 채용구분, 직급과 SALARY 평균을 가져오되 
   1).부서,채용구분 2).채용구분,직급 의 두 가지 조합으로 
      GROUP BY 결과가 나올 수 있도록 GROUPING SETS 적용
9. 8번과 같은 결과가 나오는 집합연산자를 이용한 GROUP BY 쿼리 작성
*/
--7
select dept_code, emp_type, lev, round(avg(salary)) avg_sal
from temp
group by grouping sets((dept_code, emp_type), (emp_type, lev), (dept_code, lev));

--8
select dept_code, emp_type, lev, round(avg(salary))
from temp
where dept_code like 'A%'
group by grouping sets((dept_code, emp_type), (emp_type, lev));

--9
(select dept_code, emp_type, null lev, round(avg(salary))
from temp
where dept_code like 'A%'
group by (dept_code, emp_type)
) union all (
select null dept_code, emp_type, lev, round(avg(salary))
from temp
where dept_code like 'A%' 
group by (emp_type, lev));


--Bonus문제
-- 1. 사번, 이름 5개를 한 행해 표출
select max(id1), max(nm1), max(id2), max(nm2), max(id3), max(nm3), max(id4), max(nm4), max(id5), max(nm5)
from
(select decode(x, 0, emp_id) id1, decode(x, 0, emp_name) nm1, 
       decode(x, 1, emp_id) id2, decode(x, 1, emp_name) nm2, 
       decode(x, 2, emp_id) id3, decode(x, 2, emp_name) nm3, 
       decode(x, 3, emp_id) id4, decode(x, 3, emp_name) nm4, 
       decode(x, 4, emp_id) id5, decode(x, 4, emp_name) nm5,
       ceil(rownum / 5) r
from (
    select emp_id, emp_name, mod(rownum - 1, 5) x
    from temp
))
group by r
order by r;

--2. 사번별 정렬을 수행한 사번, 급여, 누적급여를 구하기
-- 1)조인 이용
select a.emp_id, a.salary sal, sum(b.salary) cum_sum
from temp a, temp b
where a.emp_id >= b.emp_id
group by a.emp_id, a.salary
order by a.emp_id;
--2) over절 이용
select emp_id, salary, 
    sum(salary) over (
        order by emp_id
        rows unbounded preceding) cum_sum
from temp;