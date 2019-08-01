-- 4조 2교시 최재원

/*
8. 부서별로 부서원을 나열하고 모금금액을 알아내기위해 부서코드,부서명,사번,성명, 모금금액을 구하는 쿼리를 작성하고자합니다.
   각 부서별로 10만원을 모금하기 위해 개인이 부담해야하는 금액이 모금금액입니다.
   (예 : 부서원이 5명이면 각 2만원씩 4명이면 2만5천원씩 모금금액이 정해집니다)  (소숫점 아래는 올림처리)
*/
select d.dept_code, 
       d.dept_name, 
       e.emp_id, 
       e.emp_name, 
       ceil(100000 / count(e.emp_id) over (partition by d.dept_code)) as mogm
from temp e, tdept d
where e.dept_code = d.dept_code(+);

/*
9. TEMP에서 LEV가 '수습'인 직원 정보의 사번,성명, 급여, 취미, 부서코드, 전화번호를 보여주는 VIEW를 만들어 
   STUDY04 유저에게 제공할 예정입니다.
   이때 사번,성명, 급여는 READ ONLY로 UPDATE를 허용하지 않을 예정이며 HOBBY, DEPT_CODE, TEL
   세 컬럼은 업데이트를 허용할 예정입니다.
   VIEW만을 이용해 위 조건을 만족 시키려 할 때 필요한 VIEW들 만들기.
*/
create view temp_v1 as
    select emp_id, emp_name, salary
    from temp
    with read only;
create view temp_v2 as
    select emp_id, hobby, dept_code, tel
    from temp;
create view temp_v as
    select a.emp_id, a.emp_name, a.salary, b.hobby, b.dept_code, b.tel
    from temp_v1 a, temp_v2 b
    where a.emp_id = b.emp_id;

/*
10. TEMP의 컬럼들에 적절한 COMMENT를 붙이는 문장과 COMMENT를 붙인 결과를 DICTIONARY에서 조회하는 문장을 작성
*/
comment on column temp.emp_id is '사번';
comment on column temp.emp_name is '성명';
comment on column temp.birth_date is '생년월일';
comment on column temp.dept_code is '부서';
comment on column temp.emp_type is '고용형태';
comment on column temp.use_yn is '사용여부';
comment on column temp.tel is '연락처';
comment on column temp.hobby is '취미';
comment on column temp.salary is '연봉';
comment on column temp.lev is '직급';
comment on column temp.eval_yn is '평가여부';
select * from user_col_comments where table_name = 'TEMP';

/*
11. SEQ10  이라는 시퀀스를 생성하되 1에서 시작해 증분은 1씩 최대 1000까지 증가하다 다시 1로 순환 채번 되도록 생성하며 
    메모리에 CACHE 하지 않게 합니다.
*/
create sequence SEQ10
    increment by 1
    start with 1
    maxvalue 1000
    nocache
    cycle;

/*
12. SPEC, ITEM, QTY 를 컬럼으로 가지는 BOM 테이블이 있습니다.
    T1_DATA를 이용해 BOM에 우측과 같은 데이터를 자동으로 입력하고자 합니다. 
    (QTY 는  CEIL(DBMS_RANDOM.VALUE(0,3)) 을 이용해 랜덤값을 넣었습니다)
    해당 쿼리를 작성하세요
*/
create table bom ( spec varchar2(10), item varchar2(10), qty number );
insert into bom
    select 
        'S' || ceil(no/5),  -- spec
        'I' || lpad(mod(no - 1, 5) + 1, 2, 0),  --item
        CEIL(DBMS_RANDOM.VALUE(0,3))  --qty
    from t1_data
    where no <= 25;
    
/*
13. 테이블명, 시노님, 퍼블릭시노님 간의 명칭 경합이 벌어질 때 먼저 사용되는 순서로 기술하고 직접 확인 할 수 있도록 구현 하시오.
*/
-- 테이블명 > 시노님 > 퍼블릭시노님

-- table > public synonym 
create table semp as select * from dual;
create public synonym semp for scott.emp;
select * from semp; -- dual
-- synonym > public synonym (public synonym 생성한 계정 외 다른계정에서 해야함)
create synonym semp for dual;
select * from semp; -- dual
-- synonym과 같은 명칭의 table, table과 같은 명칭의 synonym은 생성 불가능
create synonym semp for dual; -- ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.

/*
14. DAED LOCK 발생하는 경우를 한 가지 예를 들어 설명하고 구현합니다.
*/
/* 한 세션에서 데이터 변경 시 커밋이나 롤백 등의 트랜잭션 종료가 일어나기 전까지 해당 영역에 대하여 락이 걸린다.
   락 상태에서 다른 세션이 같은 영역의 데이터 변경 시도시 락이 해제될 때까지 기다리는 상태가 된다.
   이 상황에서 기다리는 세션이 변경 후 트랜잭션이 종료되지 않은 데이터 영역에 대해 원래 세션이 변경을 시도하면
   양 세션은 서로의 락이 해제되기를 기다리는 상태가 되어 무한정 대기하는 교착상태가 된다.
*/
-- 원래세션
update temp set hobby = '말타기' where emp_name = '이순신'; -- update
-- 다른세션
update temp set hobby = '말타기' where emp_name = '홍길동'; -- update
-- 원래세션
update temp set hobby = '제기차기' where emp_name = '홍길동'; -- waiting
-- 다른세션
update temp set hobby = '제기차기' where emp_name = '이순신'; -- waiting

/*
15. 소속된 부서의 평균 봉급보다 많은 봉급을 받는 직원의 이름, 급여, 부서코드 
*/
select emp_id, salary, dept_code
from (
    select emp_id, salary, dept_code, avg(salary) over (partition by dept_code) avgsal
    from temp
)
where salary > avgsal;

/*
16-20
*/
create user study05 identified by study05;
--권한부여
grant create session to study05;
grant create table to study05;
grant select on study04.bom to study05;
grant select on study04.line to study05;
grant select on study04.spec to study05;
grant select on study04.item to study05;
grant select on study04.input_plan to study05;
grant select on study04.jit_delivery_plan to study05;
grant create synonym to study05;
grant create session to study05;
grant create table to study05;
grant unlimited tablespace to study05;
grant select on study01.t1_data to study05;
grant create view to study05;


-- 이 이후부터는 study05에서 수행
-- create table: study04에서 그대로 가져와 변형
create table bom_0401 as select * from study04.bom where rownum < 0;
create table line_0401 as select * from study04.line where rownum < 0;
create table item_0401 as select * from study04.item where rownum < 0;
create table spec_0401 as select * from study04.spec where rownum < 0;
create table input_plan_0401 as select * from study04.input_plan where rownum < 0;
create table jit_delivery_plan_0401 as select * from study04.jit_delivery_plan where rownum < 0;
alter table bom_0401 drop column line_no; -- study04와 다르게 bom에서 라인별로 spec이 동일한 item을 가지므로 bom에서 line관련 컬럼이 필요가 없음

-- create synonym
create synonym bom for bom_0401;
create synonym line for line_0401;
create synonym item for item_0401;
create synonym spec for spec_0401;
create synonym input_plan for input_plan_0401;
create synonym jit_delivery_plan for jit_delivery_plan_0401;

-- insert base data
insert into line(line_no) values('L01');
insert into line(line_no) values('L02');
insert into line(line_no) values('L03');
insert into spec(spec_code) values('S01');
insert into spec(spec_code) values('S02');
insert into spec(spec_code) values('S03');
insert into spec(spec_code) values('S04');
insert into spec(spec_code) values('S05');
insert into item(item_code) values('I01');
insert into item(item_code) values('I02');
insert into item(item_code) values('I03');
insert into item(item_code) values('I04');
insert into item(item_code) values('I05');
insert into item(item_code) values('I06');
insert into item(item_code) values('I07');
insert into item(item_code) values('I08');
insert into item(item_code) values('I09');
insert into item(item_code) values('I10');

--16.
--16-1.
select table_name from user_tables;
/*
BOM_0401
LINE_0401
SPEC_0401
INPUT_PLAN_0401
JIT_DELIVERY_PLAN_0401
ITEM_0401
*/
--16-2.
select synonym_name, table_name from user_synonyms;
/*
BOM	                BOM_0401
LINE	            LINE_0401
SPEC	            SPEC_0401
INPUT_PLAN	        INPUT_PLAN_0401
JIT_DELIVERY_PLAN	JIT_DELIVERY_PLAN_0401
ITEM	            ITEM_0401
*/
--16-3.
select * from user_tab_privs;
/*
STUDY05	STUDY04	BOM	                STUDY04	SELECT	NO	NO
STUDY05	STUDY04	INPUT_PLAN	        STUDY04	SELECT	NO	NO
STUDY05	STUDY04	ITEM	            STUDY04	SELECT	NO	NO
STUDY05	STUDY04	JIT_DELIVERY_PLAN	STUDY04	SELECT	NO	NO
STUDY05	STUDY04	LINE	            STUDY04	SELECT	NO	NO
STUDY05	STUDY04	SPEC	            STUDY04	SELECT	NO	NO
STUDY05	STUDY01	T1_DATA	            STUDY01	SELECT	NO	NO
*/
--16-4.
select owner, object_name, object_type, created,status from all_objects where owner = 'STUDY05'; --타유저에서 실행
/*
STUDY05	JIT_DELIVERY_PLAN   	SYNONYM	19/07/30	VALID
STUDY05	ITEM_0401	            TABLE	19/07/30	VALID
STUDY05	ITEM	                SYNONYM	19/07/30	VALID
STUDY05	BOM_0401	            TABLE	19/07/30	VALID
STUDY05	LINE_0401	            TABLE	19/07/30	VALID
STUDY05	SPEC_0401	            TABLE	19/07/30	VALID
STUDY05	INPUT_PLAN_0401 	    TABLE	19/07/30	VALID
STUDY05	JIT_DELIVERY_PLAN_0401	TABLE	19/07/30	VALID
STUDY05	BOM	                    SYNONYM	19/07/30	VALID
STUDY05	LINE	                SYNONYM	19/07/30	VALID
STUDY05	SPEC	                SYNONYM	19/07/30	VALID
STUDY05	INPUT_PLAN	            SYNONYM	19/07/30	VALID
*/

--17. 스펙을 123451234512345로 3번 줄세워놓고 item을 순서대로 두개씩 넣음(9, 10번 아이템 미사용)
insert into bom
    select s.spec_code,
           'I' || lpad(ceil(rownum/ 2), 2, 0) item_code,
           CEIL(DBMS_RANDOM.VALUE(2,5)) item_qty
    from study01.t1_data x, spec s
    where x.no <= 3
    order by s.spec_code;
commit;

--18. 매일 똑같이 돌아가는 공장(line1은 S01 5개/S02 1개, line2는 S02 1개/S03 5개...)
insert into input_plan
    select s.no plan_seq, 
           '20191001' plan_date, 
           l.line_no,
           'S' || lpad(ceil(rownum / 5), 2, 0) spec_code
    from study01.t1_data s, line l
    where s.no <= 10;

insert into input_plan
    select s.no plan_seq, 
           '20191002' plan_date, 
           l.line_no,
           'S' || lpad(ceil(rownum / 5), 2, 0) spec_code
    from study01.t1_data s, line l
    where s.no <= 10;
    
insert into input_plan
    select s.no plan_seq, 
           '20191003' plan_date, 
           l.line_no,
           'S' || lpad(ceil(rownum / 5), 2, 0) spec_code
    from study01.t1_data s, line l
    where s.no <= 10;
  
insert into input_plan
    select s.no plan_seq, 
           '20191004' plan_date, 
           l.line_no,
           'S' || lpad(ceil(rownum / 5), 2, 0) spec_code
    from study01.t1_data s, line l
    where s.no <= 10;
    
insert into input_plan
    select s.no plan_seq, 
           '20191005' plan_date, 
           l.line_no,
           'S' || lpad(ceil(rownum / 5), 2, 0) spec_code
    from study01.t1_data s, line l
    where s.no <= 10;
commit;

--19.
insert into jit_delivery_plan
    select input_plan_date, 
           line_no, 
           ceil(plan_seq / 5) jit_seq, -- 1일 2회(1~5/6~10)
           item_code, 
           sum(item_qty),
           '' -- 배송여부
    from input_plan i, bom b
    where i.spec_code = b.spec_code
    group by (input_plan_date, line_no, ceil(plan_seq / 5), item_code)
    order by 1, 2, 3, 4;
commit;

--20.
create or replace view vprod as
    select input_plan_date, 
           line_no, 
           spec_code, 
           count(spec_code) n_spec
    from input_plan 
    group by (input_plan_date, line_no, spec_code)
    order by 1, 2, 4;
