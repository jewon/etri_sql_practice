-- 4�� 2���� �����

/*
8. �μ����� �μ����� �����ϰ� ��ݱݾ��� �˾Ƴ������� �μ��ڵ�,�μ���,���,����, ��ݱݾ��� ���ϴ� ������ �ۼ��ϰ����մϴ�.
   �� �μ����� 10������ ����ϱ� ���� ������ �δ��ؾ��ϴ� �ݾ��� ��ݱݾ��Դϴ�.
   (�� : �μ����� 5���̸� �� 2������ 4���̸� 2��5õ���� ��ݱݾ��� �������ϴ�)  (�Ҽ��� �Ʒ��� �ø�ó��)
*/
select d.dept_code, 
       d.dept_name, 
       e.emp_id, 
       e.emp_name, 
       ceil(100000 / count(e.emp_id) over (partition by d.dept_code)) as mogm
from temp e, tdept d
where e.dept_code = d.dept_code(+);

/*
9. TEMP���� LEV�� '����'�� ���� ������ ���,����, �޿�, ���, �μ��ڵ�, ��ȭ��ȣ�� �����ִ� VIEW�� ����� 
   STUDY04 �������� ������ �����Դϴ�.
   �̶� ���,����, �޿��� READ ONLY�� UPDATE�� ������� ���� �����̸� HOBBY, DEPT_CODE, TEL
   �� �÷��� ������Ʈ�� ����� �����Դϴ�.
   VIEW���� �̿��� �� ������ ���� ��Ű�� �� �� �ʿ��� VIEW�� �����.
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
10. TEMP�� �÷��鿡 ������ COMMENT�� ���̴� ����� COMMENT�� ���� ����� DICTIONARY���� ��ȸ�ϴ� ������ �ۼ�
*/
comment on column temp.emp_id is '���';
comment on column temp.emp_name is '����';
comment on column temp.birth_date is '�������';
comment on column temp.dept_code is '�μ�';
comment on column temp.emp_type is '�������';
comment on column temp.use_yn is '��뿩��';
comment on column temp.tel is '����ó';
comment on column temp.hobby is '���';
comment on column temp.salary is '����';
comment on column temp.lev is '����';
comment on column temp.eval_yn is '�򰡿���';
select * from user_col_comments where table_name = 'TEMP';

/*
11. SEQ10  �̶�� �������� �����ϵ� 1���� ������ ������ 1�� �ִ� 1000���� �����ϴ� �ٽ� 1�� ��ȯ ä�� �ǵ��� �����ϸ� 
    �޸𸮿� CACHE ���� �ʰ� �մϴ�.
*/
create sequence SEQ10
    increment by 1
    start with 1
    maxvalue 1000
    nocache
    cycle;

/*
12. SPEC, ITEM, QTY �� �÷����� ������ BOM ���̺��� �ֽ��ϴ�.
    T1_DATA�� �̿��� BOM�� ������ ���� �����͸� �ڵ����� �Է��ϰ��� �մϴ�. 
    (QTY ��  CEIL(DBMS_RANDOM.VALUE(0,3)) �� �̿��� �������� �־����ϴ�)
    �ش� ������ �ۼ��ϼ���
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
13. ���̺��, �ó��, �ۺ��ó�� ���� ��Ī ������ ������ �� ���� ���Ǵ� ������ ����ϰ� ���� Ȯ�� �� �� �ֵ��� ���� �Ͻÿ�.
*/
-- ���̺�� > �ó�� > �ۺ��ó��

-- table > public synonym 
create table semp as select * from dual;
create public synonym semp for scott.emp;
select * from semp; -- dual
-- synonym > public synonym (public synonym ������ ���� �� �ٸ��������� �ؾ���)
create synonym semp for dual;
select * from semp; -- dual
-- synonym�� ���� ��Ī�� table, table�� ���� ��Ī�� synonym�� ���� �Ұ���
create synonym semp for dual; -- ORA-00955: ������ ��ü�� �̸��� ����ϰ� �ֽ��ϴ�.

/*
14. DAED LOCK �߻��ϴ� ��츦 �� ���� ���� ��� �����ϰ� �����մϴ�.
*/
/* �� ���ǿ��� ������ ���� �� Ŀ���̳� �ѹ� ���� Ʈ����� ���ᰡ �Ͼ�� ������ �ش� ������ ���Ͽ� ���� �ɸ���.
   �� ���¿��� �ٸ� ������ ���� ������ ������ ���� �õ��� ���� ������ ������ ��ٸ��� ���°� �ȴ�.
   �� ��Ȳ���� ��ٸ��� ������ ���� �� Ʈ������� ������� ���� ������ ������ ���� ���� ������ ������ �õ��ϸ�
   �� ������ ������ ���� �����Ǳ⸦ ��ٸ��� ���°� �Ǿ� ������ ����ϴ� �������°� �ȴ�.
*/
-- ��������
update temp set hobby = '��Ÿ��' where emp_name = '�̼���'; -- update
-- �ٸ�����
update temp set hobby = '��Ÿ��' where emp_name = 'ȫ�浿'; -- update
-- ��������
update temp set hobby = '��������' where emp_name = 'ȫ�浿'; -- waiting
-- �ٸ�����
update temp set hobby = '��������' where emp_name = '�̼���'; -- waiting

/*
15. �Ҽӵ� �μ��� ��� ���޺��� ���� ������ �޴� ������ �̸�, �޿�, �μ��ڵ� 
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
--���Ѻο�
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


-- �� ���ĺ��ʹ� study05���� ����
-- create table: study04���� �״�� ������ ����
create table bom_0401 as select * from study04.bom where rownum < 0;
create table line_0401 as select * from study04.line where rownum < 0;
create table item_0401 as select * from study04.item where rownum < 0;
create table spec_0401 as select * from study04.spec where rownum < 0;
create table input_plan_0401 as select * from study04.input_plan where rownum < 0;
create table jit_delivery_plan_0401 as select * from study04.jit_delivery_plan where rownum < 0;
alter table bom_0401 drop column line_no; -- study04�� �ٸ��� bom���� ���κ��� spec�� ������ item�� �����Ƿ� bom���� line���� �÷��� �ʿ䰡 ����

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
select owner, object_name, object_type, created,status from all_objects where owner = 'STUDY05'; --Ÿ�������� ����
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

--17. ������ 123451234512345�� 3�� �ټ������� item�� ������� �ΰ��� ����(9, 10�� ������ �̻��)
insert into bom
    select s.spec_code,
           'I' || lpad(ceil(rownum/ 2), 2, 0) item_code,
           CEIL(DBMS_RANDOM.VALUE(2,5)) item_qty
    from study01.t1_data x, spec s
    where x.no <= 3
    order by s.spec_code;
commit;

--18. ���� �Ȱ��� ���ư��� ����(line1�� S01 5��/S02 1��, line2�� S02 1��/S03 5��...)
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
           ceil(plan_seq / 5) jit_seq, -- 1�� 2ȸ(1~5/6~10)
           item_code, 
           sum(item_qty),
           '' -- ��ۿ���
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
