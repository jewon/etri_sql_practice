-- 4조_1교시_최재원

/*
1. TDEPT의 부서코드와 상위부서코드 정보를 이용해 CEO001에서 시작해 TOP-DOWN 방식의 계층 검색을 수행하되
   결과가 부서명으로 정렬되도록 쿼리 구성
*/
select lpad(dept_code, length(dept_code) + level - 1, '*') as dept_code, dept_name 
from tdept 
start with dept_code = 'CEO001' 
connect by prior dept_code = parent_dept;

/*
2. TEMP1의 전화번호 15자리에서 스페이스(‘ ‘)와 대시바(‘-’)를 제거하고 우측정렬 시켜 앞의 빈자리를 모두 별문자(‘*’) 로 채우는 ONE 업데이트 문장 작성 및 실행 후 COMMIT (NULL인 자료도 모두 별문자(‘*’) 로 채워져야 함) 
*/
update temp
set tel = nvl(lpad(replace(replace(tel, '-'), ' '), 15, '*'), '***************');

/*
3. TEMP 에서 취미가 독서나 여행이 아닌 직원(입력 안된 직원 포함) 수 세는 QUERY
*/
select *
from temp
where not ((hobby = '독서') or (hobby = '여행'));

/*
4. 
   4.1 TEMP의 EMP_ID 컬럼을 제외한 모든 컬럼에 걸린 인덱스를 조회하는 쿼리 작성
   4.2 위의 쿼리 결과를 참고하여 EMP_ID를 제외한 컬럼에 걸린 모든 인덱스를 DROP 하는 문장을 결과로 반환하는 쿼리작성
   4.3 4.2의 결과를 실행 시켜 관련 인덱스를 DROP;
   4.4 SALARY 컬럼에 SALARY1 이라는 이름의 INDEX 만들고 생성된 인덱스의 테이블과 컬럼 확인하는 쿼리 작성
   4.5 생성된 인덱스를 이용하여 SALARY 내림차순으로 사번과 검색 쿼리 작성
*/
-- 4.1
select * 
from user_ind_columns
where table_name = 'TEMP' 
and column_name != 'EMP_ID';
-- 4.2`
select 'drop index ' || index_name
from user_ind_columns
where table_name = 'TEMP' and column_name != 'EMP_ID';
-- 4.3
drop index TEMP_SAL10MIL_IDX
drop index UK_EMP_NAME;
-- 4.4
create index salary1 on temp(salary);
select index_name, table_name, column_name from user_ind_columns
where index_name = 'SALARY1';
-- 4.5
select /*+ INDEX(TEMP SALARY1)*/emp_id, salary 
from temp 
order by salary desc;

/*
5. TEMP에서 박문수보다 급여를 적게받는 직원 검색하여 사번,성명,급여,박문수급여 함께 보여주기(단, ANALYTIC  FUNCTION 사용 금지)
*/
select e.emp_id, e.emp_name, e.salary, m.salary as munsu_sal
from temp e, temp m
where m.emp_name = '박문수'
and e.salary < m.salary;

/*
6. TEMP 와 EMP_LEVEL 을 이용해 EMP_LEVEL의 과장 직급의 연봉 상한/하한 범위 내에 드는 모든 직원의 사번,성명,직급,SALARY, 연봉 하한,연봉 상한 읽어 오기
*/
select e.*, l.from_sal mylev_from_sal, l.to_sal mylev_to_sal, kl.from_sal kwajang_from_sal, kl.to_sal kwajang_to_sal
from 
    (select from_sal, to_sal from emp_level where lev = '과장') kl,
    (select lev, from_sal, to_sal from emp_level) l,
    (select emp_id, emp_name, lev, salary from temp) e
where e.salary between kl.from_sal and kl.to_sal
      and e.lev = l.lev(+);

/*   
7. 16번에서 125번 까지 번호에 해당되는 ASCII 코드 값의 문자들을 1줄에 5개씩 컴마(,) 구분자로 보여주기
*/
select gr, c0 || ',' || c1 || ',' || c2 || ',' || c3 || ',' || c4 as ascii_result
from
(
    select gr, 
    max(decode(g, 0, c)) c0, 
    max(decode(g, 1, c)) c1, 
    max(decode(g, 2, c)) c2, 
    max(decode(g, 3, c)) c3, 
    max(decode(g, 4, c)) c4 
    from
    (
        select no, chr(no) c, mod(rownum - 1, 5) as g, ceil(rownum / 5) as gr
        from t1_data 
        where no between 16 and 125
    )
    group by gr
)
order by gr;