/*
    0725
*/
-- 계층검색
select employee_id, last_name, job_id, manager_id
from employees
start with employee_id = 101 -- 시작위치
connect by prior manager_id = employee_id; -- emp > man 상향검색

select employee_id, last_name, job_id, manager_id
from employees
start with employee_id = 101
connect by prior employee_id = manager_id; -- man > emp 하향검색

select lpad(last_name, length(last_name) + (level * 2) - 2, '-') as org_chart -- level(계층 차이 수) 활용 가능
from employees
where last_name != 'Higgins' -- where절로는 계층 상관 없이 해당 조건만 따진다(higgins의 자식은 그대로 표출)
start with employee_id = 100 
connect by prior employee_id = manager_id; -- man > emp 하향검색

/*
    실습용 데이터 사전작업
*/
alter table tdept modify (parent_dept null);
insert into tdept values('CEO001', '대표이사실', null, 'Y', null, null);
insert into tdept values('COO001', '운영총괄실', 'CEO001', 'Y', null, null);
insert into tdept values('CTO001', '기술총괄실', 'CEO001', 'Y', null, null);
insert into tdept values('CSO001', '영업총괄실', 'CEO001', 'Y', null, null);

insert into temp(
    EMP_ID,
    EMP_NAME,
    BIRTH_DATE,
    DEPT_CODE,
    EMP_TYPE,
    USE_YN,
    TEL,
    HOBBY,
    SALARY,
    LEV,
    EVAL_YN
) values (
    --20180101, '사장야', add_months(sysdate, -45*12), 'CEO001', '정규', 'Y', '01040404040', '갑액션', 500000000, '회장', 'N'
    20180109, '소운영', add_months(sysdate, -48*12), 'COO001', '정규', 'Y', '01050505050', '갑액션', 300000000, '사장', 'N'
);
update temp
set emp_id = 20180109
where emp_id = 20180809;

update tdept
set boss_id = 20190805
where dept_code = 'CSO001';

select * from temp;

select column_name || ',' 
from user_tab_columns
where table_name = 'TEMP';

update temp
set dept_code = 'CTO001'
where emp_id = '20190803';
select * from temp;
update temp
set dept_code = 'CSO001'
where emp_id = '20190805';
/*
    다음 처럼 수정필요: tdept
    CEO001	대표이사실		Y	본사	20180101
    COO001	운영총괄실	CEO001	Y	서울	20180809
    CTO001	기술총괄실	CEO001	Y	인천	20180803
    CSO001	영업총괄실	CEO001	Y	본사	20190805
    AA0001	경영지원	COO001	Y	서울	19970101
    AB0001	재무	AA0001	Y	서울	19960101
    AC0001	총무	AA0001	Y	서울	19970201
    BA0001	기술지원	CTO001	Y	인천	19930331
    BB0001	H/W지원	BA0001	Y	인천	19950303
    BC0001	S/W지원	BA0001	Y	인천	19966102
    CA0001	영업	CSO001	Y	본사	19930402
    CB0001	영업기획	CA0001	Y	본사	19960303
    CC0001	영업1	CA0001	Y	본사	19970112
    CD0001	영업2	CA0001	Y	본사	19960212
*/
commit;

/*
    1. DEPT 의 부서코드와 상위부서코드 정보를 이용해 CEO001에서 시작해 TOP-DOWN 방식의 계층 검색
    2. DEPT 의 부서코드와 상위부서코드 정보를 이용해 CD0001에서 시작해 bottom-UP 방식의 계층 검색
    3. CSO001에서 시작하는 TOP-DOWN 방식의 계층검색
    4. 1번에서 경영지원(AA0001) 만 조직에서 제외
    5. 1번에서 경영지원(AA0001)을 포함한 하위조직 제외
*/
--1
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept;
--2
select dept_code, dept_name
from tdept
start with dept_code = 'CD0001'
connect by prior parent_dept = dept_code;
--3
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CSO001'
connect by prior dept_code = parent_dept;
--4
select dept_code, dept_name
from tdept
where dept_name != '경영지원'
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept;
--5
select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept and dept_name != '경영지원';

/*
    실습 데이터 수정
*/
insert into tdept values('CB0002', '영업기획2', 'CA0001', 'Y', '본사', 19960303);
select * from tdept; -- 방금 넣은 데이터가 중간쯤

select lpad(dept_code, length(dept_code) + level * 2 - 2, '-') dept_cd, dept_name
from tdept
start with dept_code = 'CEO001'
connect by prior dept_code = parent_dept; -- dept_code로 정렬되어 나옴: full scan 후 sort

/*
    pemp_id
    부서장 아님 > 해당 부서장
    부서장 > 상위부서 부서장
*/
select temp.emp_id, temp.emp_name, temp.dept_code, boss_id, 
    decode(
        boss_id - emp_id, 0, (), boss_id
    )
from temp left join (select boss_id from tdept left join temp on tdept.parent_detp = temp.dept_code) on temp.dept_code = tdept.dept_code;


select temp.emp_id, temp.emp_name, temp.dept_code, boss_id, 
    decode(
        boss_id - emp_id, 0, (), boss_id
    );

select * from tdept;
update tdept
set boss_id = 20190803
where boss_id = 20180803;


select * from temp where emp_id = 20180109;
select * from temp where emp_id = 20190803;
select * from temp;
sele

select e.emp_id eid, e.emp_name en, d.dept_code d, d.boss_id dbid, db.emp_name dbnm, pd.dept_code pd, pd.boss_id pdbid, pdb.emp_name pdbn
from temp e, tdept d, temp db, tdept pd, temp pdb
where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) and pd.boss_id = pdb.emp_id(+) and d.boss_id = db.emp_id(+);

select eid, en, d, decode(eid - dbid, 0, pdbid, dbid) pid, decode(eid - dbid, 0, pdbn, dbnm) pn
from (
    select e.emp_id eid, e.emp_name en, d.dept_code d, d.boss_id dbid, db.emp_name dbnm, pd.dept_code pd, pd.boss_id pdbid, pdb.emp_name pdbn
    from temp e, tdept d, temp db, tdept pd, temp pdb
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) and pd.boss_id = pdb.emp_id(+) and d.boss_id = db.emp_id(+)
)
-- 4테이블
select e.*, pe.emp_name pn, pe.dept_code pd
from (
    select e.emp_id eid, e.emp_name en, e.dept_code d, decode(e.emp_id - d.boss_id, 0, pd.boss_id, d.boss_id) pid
    from temp e, tdept d, tdept pd
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) -- 무조건 left join 상태
) e, temp pe
where e.pid = pe.emp_id(+)
order by 1;

order by 1;

create or replace view vemp_boss as
select e.*, pe.emp_name pn, pe.dept_code pd
from (
    select e.emp_id eid, e.emp_name en, e.dept_code d, decode(e.emp_id - d.boss_id, 0, pd.boss_id, d.boss_id) pid
    from temp e, tdept d, tdept pd
    where e.dept_code = d.dept_code(+) and d.parent_dept = pd.dept_code(+) -- 무조건 left join 상태
) e, temp pe
where e.pid = pe.emp_id(+)
order by 1;

select * from vemp_boss;
/*
    6. 20180101에서 시작하는 직원의 TOP-DOWN 계층검색(밀어넣기 필수)
    7. 정북악에서 시작하는 상향 계층 검색
*/
--6.
select lpad(eid, length(eid) + (level * 2) - 2, '-') || ' ' || en id -- level(계층 차이 수) 활용 가능
from vemp_boss
start with eid = 20180101
connect by prior eid = pid;

--7.
select lpad(eid, length(eid) + (level * 2) - 2, '-') || ' ' || en id
from vemp_boss
start with eid = (select emp_id from temp where emp_name = '정북악')
connect by prior pid = eid;
--  아래 두 개 순서 비교해보기
select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd
from vemp_boss
start with eid = 20180101
connect by prior eid = pid; -- id순 정렬

select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd
from vemp_boss
start with eid = 20180101
connect by prior en = pn; -- 이름순 정렬

create table emp_boss as select * from vemp_boss;
alter table emp_boss add constraint emp_boss_pk primary key (eid);
create index inx_enm1 on emp_boss(en);

alter table emp_boss add salary number;
update emp_boss
set salary  = (select salary from temp where emp_id = eid);

select * from emp_boss;
select lpad(eid, length(eid) + (level * 2) - 2, '-')eid, en, pid, pn, d, pd, salary, 
    (select sum(salary) from emp_boss t start with t.eid = e.eid connect by prior t.eid = t.pid) ssal
from emp_boss e
start with eid = 20180101
connect by prior eid = pid -- 이름순 정렬
