/*
    0717: View
*/
-- 데이터 있는 컬럼 삭제 가능?
select * from temp_c;
alter table temp_c drop column use_yn; -- 된다
drop table temp_c;


/*
    뷰?: 테이블이나 다른 뷰를 기초로 한 가상의 테이블, 스스로 데이터를 갖지 않음(질의만 저장)
*/
grant create view to scott;

--scott
--뷰 생성
create view emp_20
    as select * from emp where deptno = 20;
--생성시 별칭 지정하명 컬럼명이 됨
create view emp_30
    as select empno emp_no, ename name, sal salary from emp where deptno = 30;
--수정은 or replace로 (alter 등 불가)
create or replace view emp_10 (employee_no, employee_name, job_titile, salary)
    as select empno, ename, job, sal
    from emp
    where deptno = 10;
-- 복합 뷰
create view dept_sum(name, minsal, maxsal, avgsal)
    as select d.dname, min(e.sal), max(e.sal), avg(e.sal)
    from dept d, emp e
    where d.deptno = e.deptno
    group by d.dname;
-- 뷰를 통한 테이블 변경
-- 뷰 check option
create or replace view emp_20
    as select *
    from emp
    where deptno = 20
    with check option constraint emp_20_ck;
insert into emp_20 values(1023, 'test', 'CLERK', 7902, '80/10/21', 1000, '', 30); -- ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
update emp_20 set dept_no = 30 where emp_no = 7566; -- ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
create or replace view emp_20
    as select *
    from emp
    where deptno = 20;
update emp_20 set dept_no = 30 where emp_no = 7566; -- OK
rollback;
--뷰 삭제
drop view emp_10;

-- study01
--인라인 뷰
select a.last_name, a.salary, a.department_id, b.maxsal
from employees a,
    (select department_id, max(salary) maxsal
     from employees
     group by department_id) b
where a.department_id = b.department_id
and a.salary < b.maxsal;
-- top-n 분석: 인라인 뷰에서 order by후 상위에 있는 것 추출
select rownum as rank, last_name, salary
from (select last_name, salary
      from employees
      order by salary desc)
where rownum <= 3;
-- 그러나, 대량의 데이터에서 이 방법으로 top-n 분석은 매우 오래 걸림

create table temp1 as select * from temp;
/*

*/
-- 1.
select * from temp;
select * from emp_level;
select * from tcom;
create view vemp1
    as select * from temp1 where lev = '과장';
    
create view vemp2
    as select emp_id, emp_name, dept_code, use_yn, hobby, lev from temp1;

create view vemp3
    as select emp_id 사번, emp_name 성명, dept_code 부서코드, use_yn 근무여부, hobby 취미, lev 직급 from temp1;

select * from vemp3 where 취미 = '농구';

select * from user_views;

select sysdate - birth_date from temp;

create or replace view vemp4
    as select temp.emp_id, emp_name, use_yn, salary, nvl(comm, 0) comm, trunc((sysdate - birth_date) / 365) age, from_age, to_age
    from temp, emp_level, tcom
    where temp.emp_id = tcom.emp_id(+) and temp.lev = emp_level.lev(+)
    order by emp_name;

select * from vemp4;

/*
    1. 부서코드,부서명, 최고SALARY를 받는 사번, 최고SALARY, 최소SALARY를 받는 사번, 최소SALARY 를 보여주는 VEMP5 VIEW를 만듭니다. 
    2. TEMP1 EMP_ID 에 ALTER TABLE 명령으로 RPRIMARY KEY 생성
    3. VEMP1에 ‘차장’ INSERT 문장 1개 수행 후 TEMP1에 실제 INSERT 되었는지 확인 후 ROLLBACK;
*/
select * from temp1;
select * from tdept;
create view vemp5
    as select e.dept_code, d.dept_name, s.maxsal, maxsal_e, s.minsal, minsal_e
    from (select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code) s,
         (select dept_code, 
;
-- 1-1 inline view
select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code;
select s.dept_code, d.dept_name, s.maxsal, s.minsal, emax.emp_id max_sal_emp, emin.emp_id min_sal_emp
    from (select dept_code, max(salary) maxsal, min(salary) minsal from temp1 group by dept_code) s,
         temp emax,
         temp emin,
         tdept d
    where (s.dept_code = emax.dept_code and emax.salary = s.maxsal)
      and (s.dept_code = emin.dept_code and emin.salary = s.minsal)
      and d.dept_code = s.dept_code
    order by 1;
-- 1-2 subquery
 select a.dept_code, a.emp_id, a.salary, c.emp_id, c.salary
 from temp a, temp c
 where a.salary = ( select max(salary)
                            from temp b
                            where a.dept_code = b.dept_code)
and c.salary = (select min(salary)
                        from temp d
                        where c.dept_code = d.dept_code)
    and a.dept_code = c.dept_code;
-- 1-3. 
select dept_code, trunc(max(e.es) / 100000000) as max_sal, max(e.es) - round(max(e.es), -8) as max_emp,
       trunc(min(e.es) / 100000000) as min_sal, min(e.es) - round(min(e.es), -8) as min_emp
  from (select salary * 100000000 + emp_id as es, dept_code from temp) e
group by dept_code;

-- 2.
alter table temp1 add constraint temp1_pk primary key (emp_id);

select * from vemp1;
-- 3.
insert into vemp1 values(20190108, '안녕', '93/04/01', 'AB0001', '정규', 'N', '', '', 1000, '과장', 'N');
rollback;

/*
    4. VEMP2에 있는 컬럼은 모두 값 부여하여 VEMP2를 이용한 INSERT 후 TEMP1 확인 후 ROLLBACK;
    5. 4번에 SALARY 추가하여 INSERT 문장 작성 후 실행하여 오류 확인 
    6. VEMP3를 통한 INSERT 수행 성공여부 확인 후 ROLLBACK;
*/

-- 4.
insert into vemp2 values(20190108, '테스트', 'AB0001', 'N', '사진', '과장');
select * from temp1 where emp_name = '테스트';
rollback;

--5.
select * from vemp2;
insert into vemp2(emp_id, emp_name, dept_code, use_yn, hobby, lev, salary) values(20190108, '테스트', 'AB0001', 'N', '사진', '과장', 1000);
-- ORA-00904: "SALARY": 부적합한 식별자

--6.
select * from vemp3;
insert into vemp3 values(20190108, '테스트', 'AB0001', 'N', '사진', '과장');
rollback;

/*
    7. 권한관리 모델에서 
        롤, 롤별 부여받은 권한수, 롤이부여된 유저수 VPRIV3 VIEW   
    8. GRANT 결과에서 
        롤, 롤별 부여받은 권한수, 롤이부여된 유저수 : VPRIV4 VIEW   
    9. 권한관리 모델의 롤별, 부여받은권한 수, 부여한 유저수, 
        GRANT롤, GRANT받은 권한수(테이블+권한), GRANT한 유저수를 보여주는 VPRIV5 VIEW 생성
*/
select role_cd, count(priv_id) n_priv from trol_priv group by role_cd;
--7.
select * from tprivs;
select * from trol_priv;
select * from trole;
select * from trol_user;
create view vpriv3 as
    select r.role_cd rcd, r.n_priv n_privs, count(user_nm) n_users
      from (select role_cd, count(priv_id) n_priv from trol_priv group by role_cd) r, trol_user u
     where r.role_cd = u.role_cd(+)
     group by (r.role_cd, r.n_priv)
     order by 1;


--8.
select * from user_tab_privs_made;
select * from role_tab_privs where owner = 'STUDY01';
select * from dba_role_privs;

create view vpriv4 as
select p.role rcd, count(distinct u.grantee) n_users, count(distinct p.table_name || p.privilege) n_privs
  from dba_role_privs u, role_tab_privs p
  where p.owner = 'STUDY01'
    and u.grantee(+) <> 'STUDY01'
    and u.granted_role(+) = p.role
  group by p.role;
  
 select *
  from dba_role_privs u, role_tab_privs p
  where p.owner = 'STUDY01'
    and u.granted_role = p.role
    order by grantee;

    select *
      from trol_priv r, trol_user u
     where r.role_cd = u.role_cd
     order by 1;
--9.
/*
    9. 권한관리 모델의 롤별, 부여받은권한 수, 부여한 유저수, 
        GRANT롤, GRANT받은 권한수(테이블+권한), GRANT한 유저수를 보여주는 VPRIV5 VIEW 생성
*/
create view vpriv5 as
select d.*, m.*
from (
select r.role_cd rcd, count(distinct priv_id) n_privs, count(distinct user_nm) n_users
    from trol_priv r, trol_user u
    where r.role_cd = u.role_cd(+)
    group by r.role_cd
    order by 1
 ) m, (
select p.role rcd, count(distinct p.table_name || p.privilege) n_privs, count(distinct u.grantee) n_users
    from dba_role_privs u, role_tab_privs p
    where p.owner = 'STUDY01'
    and u.grantee(+) <> 'STUDY01'
    and u.granted_role(+) = p.role
    group by p.role) d
where m.rcd(+) = d.rcd;
select * from temp;
/*
    +
*/
-- 조인 뷰는 하나의 테이블을 대상으로 하는 변경만 가능하다.
create view vemp6 as
    select emp_id, e.dept_code, dept_name
    from temp e, tdept d
    where e.dept_code = d.dept_code(+);
insert into vemp6 values(20190111, 'AB0001', '테스트'); --  ORA-01776: 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.

-- with read only로 뷰를 생성하면 뷰를 통한 데이터 변경이 불가능하다
create or replace view vemp1
    as select * from temp1 where lev = '과장'
    with read only;
insert into vemp1 values(20190108, '안녕', '93/04/01', 'AB0001', '정규', 'N', '', '', 1000, '과장', 'N'); -- ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

