/*
    0718: sequence
    
*/
-- scott
-- 시퀀스: '순차적으로 부여하는 고유 번호'
-- 시퀀스 생성
create sequence dept_deptno
    increment by 1
    start with 91
    maxvalue 99
    nocache
    nocycle;
-- 사용자 시퀀스 딕셔너리
select * from user_sequences;
-- 시퀀스 사용
-- nextval: 다음 사용가능한 시퀀스 값, curval: 현재 시퀀스 값 반환
insert into dept values(dept_deptno.nextval, '영업부', '분당구 정자동');
-- 캐시 시퀀스
create sequence dept_deptno2
    increment by 1
    start with 91
    maxvalue 99
    cache 3
    nocycle;
-- 시퀀스 삭제
drop sequence dept_deptno;
drop sequence dept_deptno2;
/*
인덱스: 접근(탐색) 속도 향상
    where, join등에서 자주 사용되는 컬럼
    광범위한 값을 가지는 컬럼
    다수의 null값 포함하는 컬럼
    테이블이 크고, 질의 결과가 전체 행의 2~4% 이하일 때
    갱신시 인덱스도 갱신되어야 하므로 자주 갱신되는 테이블에 부적합
*/
-- PK, UK제약시 자동 생성 / 사용자 직접 생성
create index emp_ename_idx on emp(ename);
-- 인덱스 확인
select c.index_name, c.column_name, c.column_position, i.uniqueness
from user_indexes i, user_ind_columns c
where c.index_name = i.index_name
and c.table_name = 'EMP';
-- 사용자 지정 인덱스
create index upper_emp_ename_idx on emp(upper(ename));
create index upper_emp_salary_idx on emp(upper(sal));
drop index upper_emp_salary_idx;
drop index upper_emp_ename_idx;

-- study01
-- 시노님: 스키마 이름 명시안해도 접근 가능하게
-- 시노님 생성
create synonym gubun for scott.salgrade;
select * from gubun;
drop synonym gubun;

-- 실습
--1.
create sequence ext_no
    increment by 1
    start with 1
    maxvalue 1000
    nocache
    nocycle;
--2.
select * from user_sequences where sequence_name = 'EXT_NO';
--3.
select ext_no.currval from dual; -- ORA-08002: 시퀀스 EXT_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
--4.
select ext_no.nextval from dual;
select ext_no.currval from dual;
--5.
select ext_no.currval from dual;
--6.
-- 한 세션에서 새로운 번호를 채번하더라도 다른 세션에서 currval은 그대로이다.
--7.
alter table t1_data add (prod_am number);
--8
update t1_data
set prod_am = ext_no.nextval
where no < 10;
--9.
create table tseq1 as select ext_no.nextval from temp;
--10.
alter sequence ext_no
    cache 10;
select * from user_sequences where sequence_name = 'EXT_NO';
--11.
insert into tseq1 values(ext_no.nextval);
d

insert into t1_data (no)
select no + 10000
from t1_data;

insert into t1_data (no)
select a.no + 10000 * b.no
from t1_data a, t1_data b
where b.no < 21;

/*
1. USER_INDEXES 와 USER_IND_COLUMNS 를 이용 INDEX 를 조회하고 
   어떤 인덱스가 PRIMARY KEY 와 UNIQUE INDEX 이고 어느 것이 일반
   인덱스 인지 구별 
*/
select * from user_indexes where uniqueness = 'UNIQUE';
select * from user_ind_columns;

select a.index_name, a.table_name, a.uniqueness, b.constraint_type
from user_indexes a, user_constraints b
where b.constraint_name(+) = a.index_name;

create unique index uk_emp_name on temp(emp_name);

/*
2. SALARY의 천만 단위가 같으면 같은 값으로 간주하여 직급, 천만단위급여, 
   이름 순으로 정렬을 하되, INDEX를 이용한 정렬을 하고 싶은 경우 인덱스 생성
3. T1_DATA의 SALARY, TABLE_NAME 컬럼에 T1_INX1 이름으로 복합인덱스 생성
   (DICTIONARY VIEW 에서 개별 확인)
4. STUDY02에서 STUDY01의 TEMP 에 대한 PUBLIC SYNONYM 을 
   TEMP 라는 이름으로 생성
5. STUDY02에서 STUDY01의 TDEPT 에 대한 일반 SYNONYM 을 
   TDEPT 라는 이름으로 생성
6. STUDY03에서 SCHEMA 지정 없이 TEMP와 TDEPT에서 각각 SELECT 결과 확인
*/
--2.
select lev, trunc(salary / 10000000) as sal_10mil, emp_name, emp_id from temp order by 1, 2 desc, 3;
create index temp_sal10mil_idx on temp(trunc(salary / 10000000));

explain plan for
select /*+index_DESC(temp, temP-sal10mil_idx) */lev, trunc(salary / 10000000) as sal_10mil, emp_name, emp_id from temp order by 1, 2 desc, 3;

select plan_table_output from table(dbms_xplan.display());
--3.
create index t1_inx1 on t1_data(no, prod_am);
select * from user_indexes where index_name = 'T1_INX1';
--4.
-- study2
create public synonym temp for study01.temp;
--5.
create synonym tdept for study01.tdept; --ERR ORA-01471: 객체와 같은 이름의 동의어는 작성할 수 없습니다
create synonym tdepts for study01.tdept;
--6.
select * from temp;
select * from tdept; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--7. 8. 9.
create table tdept as
    select * from study01.tdept where area = '인천';
create synonym tdept for study01.tdept;-- ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.
select * from tdept; -- 테이블이 시노님보다 먼저
--10.
-- 테이블 > 시노님 > public
create table tdept2 as
    select * from study01.tdept where area = '인천';
create public synonym tdept for study01.tdept;
create synonym tdept for tdept2;
--11. 12.
drop synonym tdept;
drop public synonym tdept;



