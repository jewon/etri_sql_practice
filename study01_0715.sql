/*
    0715: 테이블 생성 및 관리
    
    테이블: 물리적으로 존재하는 '면적을 가진' 데이터
    뷰: Select문으로 만들어지는 가상의 테이블
    시퀀스: 고유한 번호(주로 PK값)를 자동으로 발생시키는 객체
    인덱스: 질의 성능 향상을 위해 사용하는 물리적 저장 구조
    시노님: 객체에 대한 이름 부여
*/

-- 테이블 생성과 제약조건 생성
create table test_tab2(
    id number(2),
    name varchar2(10),
    constraint id_pk primary key (id) -- pk
);
create table emp_tab(
    empno number(4),
    ename varchar2(10),
    deptno number(2) not null,
    constraint emp_deptno_fk foreign key(deptno) -- fk
    references department(deptno)
);
create table uni_tab2(
    deptno number(2),
    dame char(14),
    constraint uni_tab_deptno_uk unique (deptno) -- uk
);
create table nn_tab1(
    deptno number(2) not null, -- not null
    dname char(14),
    loc char(13)
);
create table ch_tab2(
    deptno number(2),
    dname char(14),
    loc char(13),
    constraint uni_tab_deptno_ck check -- check
    (deptno IN (10, 20, 30, 40, 50))
);
alter table emp_tab -- 제약추가
add constraint emp_ename_uk unique (ename);
alter table emp_tab -- 제약삭제
drop constraint emp_ename_uk;
alter table emp_tab -- 제약 비활성화
disable constraint emp_deptno_fk;
alter table emp_tab -- 제약 활성화
enable constraint emp_deptno_fk;
-- 테이블 제약 조회
select constraint_name, constraint_type, search_condition
from user_constraints
where table_name = '';
-- 컬럼 제약 조회
select constraint_name, column_name
from user_cons_columns
where table_name = '';
select * from temp;

-- select문으로부터 테이블 생성
create table emp_30 as
    select emp_id, emp_name, emp_type, birth_date, salary
    from temp
    where dept_code = 'AA0001';
-- 컬럼 조작
alter table bonus -- 추가
    add (etc varchar2(16));
alter table emp_30 -- 타입변경
    modify (emp_name varchar2(15));
alter table bonus -- 삭제
    drop (etc);

-- 테이블 조작
drop table emp_30; -- 삭제
rename emp_tab to emp_tab2; -- 이름변경

-- 기타
truncate table emp_tab2; -- 모든행 삭제 (유의: delete와 다르게 롤백 불가)
comment on table emp_tab2 is 'employee information'; -- 주석

/*
    롤 관리 테이블 만들기

    1. role, table, priv관계는 create문에
    2. 컬럼 제약은 alter문으로
    3. comment에 Logical name
    4. default 값
*/
-- 테이블 및 제약
create table obj (
    objcd number not null,
    obj_name varchar2(30),
    constraint obj_pk primary key (objcd) -- pk
);
create table priv (
    privcd number not null,
    priv_name varchar2(30),
    constraint priv_pk primary key (privcd) -- pk
);
create table obj_priv (
    objcd number,
    privcd number
);
alter table obj_priv add constraint obj_priv_obj_fk foreign key (objcd) references obj(objcd);
alter table obj_priv add constraint obj_priv_priv_fk foreign key (privcd) references priv(privcd);
alter table obj_priv add constraint obj_priv_pk primary key (objcd, privcd);
create table usr (
    user_name varchar2(30) not null,
    constraint usr_pk primary key (user_name) -- pk
);
create table rol (
    rolecd number not null,
    role_name varchar2(30),
    constraint rol_pk primary key (rolecd) -- pk
);
create table usr_role (
    user_name varchar2(30),
    rolecd number
);
alter table usr_role add constraint usr_role_usr_fk foreign key (user_name) references usr(user_name);
alter table usr_role add constraint usr_role_role_fk foreign key (rolecd) references rol(rolecd);
alter table usr_role add constraint usr_role_pk primary key (user_name, rolecd);
create table role_priv (
    rolecd number,
    objcd number,
    privcd number
);
alter table role_priv add constraint role_priv_role_fk foreign key (rolecd) references rol(rolecd);
alter table role_priv add constraint role_priv_obj_priv_fk foreign key (objcd, privcd) references obj_priv(objcd, privcd);
alter table role_priv add constraint role_priv_pk primary key (rolecd, objcd, privcd);

-- 주석
comment on table obj is '오브젝트'; 
comment on table priv is '권한'; 
comment on table obj_priv is '오브젝트별권한'; 
comment on table role_priv is '롤별권한'; 
comment on table rol is '롤'; 
comment on table usr_role is '사용자별롤'; 
comment on table usr is '사용자';
comment on column obj.objcd is '오브젝트코드';
comment on column obj.obj_name is '오브젝트명';
comment on column priv.privcd is '권한코드';
comment on column priv.priv_name is '권한명';
comment on column obj_priv.objcd is '오브젝트코드';
comment on column obj_priv.privcd is '권한코드';
comment on column role_priv.objcd is '오브젝트코드';   
comment on column role_priv.privcd is '권한코드';
comment on column role_priv.rolecd is '롤코드';
comment on column rol.rolecd is '롤코드';
comment on column rol.role_name is '롤이름';
comment on column usr_role.rolecd is '롤코드';
comment on column usr_role.user_name is '사용자명';
comment on column usr.user_name is '사용자명';

-- check
alter table priv add constraint priv_name_ck check (priv_name in ('insert', 'delete', 'update', 'select'));
alter table usr modify (user_name default 'newuser');

-- 0. 테이블, 컬럼 확인
select a.table_name, b.column_name
from user_tables a, user_tab_columns b
where a.table_name = b.table_name
    and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'ROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- PK 확인
select a.constraint_name, b.column_name from user_constraints a, user_cons_columns b
where constraint_type = 'P' and a.constraint_name = b.constraint_name and a.constraint_type = 'P'
and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'ROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- 참조 제약 확인
select a.constraint_name, a.table_name, c.column_name as colname, a.r_constraint_name as fk_pk_name,b.table_name as fk_table, b.column_name as fk_col 
from user_constraints a, user_cons_columns b , user_cons_columns c
where a.constraint_type = 'R'
and a.r_constraint_name = b.constraint_name and a.constraint_name = c.constraint_name
and a.table_name in ('OBJ', 'PRIV', 'OBJ_PRIV', 'TROLE', 'USR', 'USR_ROLE', 'ROLE_PRIV');

-- rename, alter 실습
rename obj to tobject;
rename usr to tuser;
rename rol to trole;
rename priv to tcurd;
rename obj_priv to tprivs;
rename role_priv to trol_priv;
rename usr_role to trol_user;

-- 컬럼 타입 변경 실습
alter table tcurd modify priv_name varchar2(50);