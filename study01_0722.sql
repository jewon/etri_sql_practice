/*
    0722 SET �����ڿ� datetime
*/
-- UNION
select employee_id, job_id
from employees
union
select employee_id, job_id
from job_history;

-- UNION ALL
select employee_id, job_id
from employees
union all
select employee_id, job_id
from job_history
order by employee_id;

-- INTERSECT(������), MINUS(������)...
select employee_id, job_id
from employees
minus
select employee_id, job_id
from job_history;

-- select������ ��Ī(������� �Ǹ�, �÷� ���� Ÿ���� �ٸ��� ���� ��ȯ)
select department_id, to_number(null) location, hire_date
from employees
union
select department_id, location_id, to_date(null)
from departments;

select employee_id, job_id, salary
from employees
union
select employee_id, job_id, '0'
from job_history; -- ERR ORA-01790: �����ϴ� �İ� ���� ������ �����̾�� �մϴ�

select employee_id, job_id, salary
from employees
union
select employee_id, job_id, 0
from job_history;

-- noprint�� �̿��� �÷� ���� ����
column a_dummy noprint
select 'sing' as "My dream", 3 a_dummy
from dual
union
select 'I''d like to teach' As "My dream", 1
from dual
union
select 'I''d like to teach' As "My dream", 2
from dual
order by 2;

-- DATETIME, Ÿ����
select * from v$timezone_names; -- Ÿ���� ���
select tz_offset('ASIA/Seoul') from dual; -- Ÿ���� ������
select tz_offset('ROK') from dual; -- Ÿ���� ������

create table tdate (d1 date);
insert into tdate select '19970101' from dual;
alter session set NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
insert into tdate select '19970101' from dual; -- ERR ORA-01861: ���ͷ��� ���� ���ڿ��� ��ġ���� ����
select * from tdate; --01-1�� -1997 00:00:00
alter session set time_zone  = '-05:00';

select dbtimezone from dual;
select sessiontimezone from dual;

select extract(year from sysdate) from dual;
select to_timestamp('2004-03-28 08:00:00', 'YYYY-MM-DD HH:MI:SS') from dual;
select to_timestamp('2004-03-28 08:00:00', 'YYYY-MM-DD HH:MI:SS TZH:TZM') from dual;

select hire_date, hire_date + to_yminterval('01-02') -- ��, ���� ���ÿ� ����
from employees where department_id = 90;

/*

*/
--1
select emp_id, dept_code from temp
union
select boss_id, dept_code from tdept;
--2
select emp_id, dept_code from temp
union all
select boss_id, dept_code from tdept;
--3
select emp_id, dept_code from temp
union all
select boss_id, dept_code from tdept
order by 1;
--4
select emp_id, dept_code from temp
intersect
select boss_id, dept_code from tdept;
--5
select emp_id, dept_code from temp
minus
select boss_id, dept_code from tdept;
--6
select emp_id, dept_code, salary from temp where emp_id > 20000000 and salary > 30000000
union
select boss_id, dept_code, 0 from tdept where dept_code like 'A%';
--7
select a.emp_id, dept_code from (
select emp_id from temp1
intersect
select emp_id from temp 
minus
select emp_id from tcom) a, temp b
where a.emp_id = b.emp_id;

select emp_id, dept_code from temp1
intersect
select emp_id, dept_code from temp 
minus
select emp_id, dept_code from temp where emp_id in (select emp_id from tcom);

--1.
select emp_id, sum(sal) esal, sum(comm) ecomm
from
(select emp_id,0 sal, comm from tcom where work_year = 2019
union
select emp_id, salary, 0 from temp)
group by emp_id;

--3.
select emp_id, dept_code from temp
union
select emp_id, salary from temp1; -- err ORA-01790: �����ϴ� �İ� ���� ������ �����̾�� �մϴ�

/*
    1. �ѱ� ǥ�ؽð��� Ȯ��
    2. ���� ������ ǥ�ؽð��� Ȯ��
    3. �ð��뺯��
    4. �ѱ��� Ÿ���� Ȯ��
    5. DATE�� �÷� 1�� ¥�� TABLE ����
    6. ���� �������� T1�� INSERT
    7. Date FORMAT ����
    8. ������ FORMAT���� �Է� ���� Ȯ��
    9. ������ FORMAT���� �Է�
    10. SYSTIMESTAMP �� ���� 1/100�� Ȯ��
    11. DBTIMEZONE �� SESSIONTIMEZONE ��
    12. SESSIONTIMEZONE ���� 
    13. 11�� �ٽ� ����
    14. EXTRACT �̿�

*/
--1.
select tz_offset('ROK') from dual;
--2.
select sessiontimezone, current_date from dual;
--3.
alter session set time_zone = '+5:00';
alter session set time_zone = '+9:00';
--4.
select * from v$timezone_names where tzname like 'R%';
select * from v$timezone_names where tzname like '%Seoul%';
--5.
create table tdate(d1 date);
--6.
alter session set nls_date_format = 'DD-MON-YYYY';
--7.
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
--8.
INSERT INTO TDATE VALUES('19980101');
--9.
insert into tdate values('01-1��-1998');
--10.
select to_char(systimestamp, 'YYYYMMDD HH24MISS.FF2') from dual;
--11.
select dbtimezone, sessiontimezone from dual;
--12. 13.
alter session set time_zone = '+05:00';
select dbtimezone, sessiontimezone from dual;
alter session set time_zone = '+09:00';
--14.
select extract(year from sysdate) from dual;
select extract(month from sysdate) from dual;
select extract(day from sysdate) from dual;

/*
15. �������� �ʴ� ���̺� ������� SELECT ���� �� ���� �޽��� Ȯ��
16. SESSION LANGUAGE AMERICAN���� ���� ���� �� 1�� ����
17. SESSION LANGUAGE �� JAPANESE, GERMAN, ITALIAN, AMERICAN, RUSSIAN �� �ٲ㰡�� Ȯ��
18. SESSION TERRITORY ���� �� �� SELECT TO_CHAR(SALARY,'L999999999') SALARY FROM TEMP;
19. SESSION �� ��ȭ�� �޷��� ����
20. ���� ��¥�� 1�� 3������ ���� ��¥ (TO_YMINTERVAL �̿�)
21. ���ڸ� TIMESTAMP WITH ZONE �������� ��ȯ ���
*/
--15.
select * from a; -- err ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�
--16.
alter session set nls_language = 'AMERICAN'; 
select * from a; -- err ORA-00942: table or view does not exist
--17.
alter session set nls_language = 'RUSSIAN';
select * from a; -- err ORA-00942: ��ѬҬݬڬ�� �ڬݬ� ���֬լ��ѬӬݬ֬߬ڬ� ���ݬ�٬�ӬѬ�֬ݬ� �߬� ����֬��Ӭ�֬�
--18.
select to_char(salary, 'L999999999') salary from temp;
--19.
alter session set nls_currency = '$';
select to_char(salary, 'L999999999') salary from temp;
--20
select sysdate+to_yminterval('01-03') from dual;
--21
select to_timestamp_tz('20190722 14:40:00 =9:00', 'YYYYMMDD HH24:MI:SS TZH:TZM') from dual;
alter session set nls_language = 'korean';

/*
    ���� �ǽ�1
*/
create table test35 (
    key1 varchar2(05),
    key2 varchar2(05),
    amt number,
    constraint test35_pk primary key (key1, key2)
);
INSERT INTO TEST35 VALUES ('0001','A', 500);
INSERT INTO TEST35 VALUES ('0001','B', 400);
INSERT INTO TEST35 VALUES ('0002','A', 400);
INSERT INTO TEST35 VALUES ('0002','B', 300);
INSERT INTO TEST35 VALUES ('0003','A', 600);
INSERT INTO TEST35 VALUES ('0003','B', 400);
INSERT INTO TEST35 VALUES ('0004','A', 700);
INSERT INTO TEST35 VALUES ('0004','B', 300);
INSERT INTO TEST35 VALUES ('0005','A', 800);
INSERT INTO TEST35 VALUES ('0005','B', 200);
INSERT INTO TEST35 VALUES ('0006','A', 700);
INSERT INTO TEST35 VALUES ('0006','B', 600);
COMMIT;
select key1 || key2 || amt from test35;
(select * from test35 where key2 = 'A') a;
(select * from test35 where key2 = 'B') b;
select * from test35;

-- A, B, C(A-B), per(100 * C / A) �հ� ���̺� �����
select key1, sum(a) a, sum(b) b, sum(a) - sum(b) c, round(100 * sum(c) / sum(a)) per
from (
    select
        decode(no, 1, key1, '�հ�') key1,
        sum(decode(key2, 'A', amt, 0)) a, 
        sum(decode(key2, 'B', amt, 0)) b, 
        sum(decode(key2, 'A', amt, 0)) - sum(decode(key2, 'B', amt, 0)) c,
        round(100 * (sum(decode(key2, 'A', amt, 0)) - sum(decode(key2, 'B', amt, 0))) / sum(decode(key2, 'A', amt, 0))) per
    from test35, (select no from t1_data where no < 3)
    group by key1, no
    order by key1
)
group by key1
order by key1;

/*
    ���� �ǽ�2
*/
create table test04(
    ymd varchar2(08) not null,
    us_amount number not null,
    constraint test04_pk primary key(ymd)
);
create table test05(
    ymd varchar2(08) not null,
    exc_rate number not null,
    constraint test05_pk primary key(ymd)
);
INSERT INTO TEST04 VALUES ('19980102', 3171);
INSERT INTO TEST04 VALUES ('19980203', 3142);
INSERT INTO TEST04 VALUES ('19980304', 3113);
INSERT INTO TEST04 VALUES ('19980405', 3084);
INSERT INTO TEST04 VALUES ('19980701', 3055);
INSERT INTO TEST04 VALUES ('19980802', 3026);
INSERT INTO TEST04 VALUES ('19980903', 2997);
INSERT INTO TEST04 VALUES ('19981004', 2968);
INSERT INTO TEST04 VALUES ('19981102', 2939);
INSERT INTO TEST05 VALUES ('19971231', 1800);
INSERT INTO TEST05 VALUES ('19980630', 1300);
INSERT INTO TEST05 VALUES ('19970630',  800);
INSERT INTO TEST05 VALUES ('19961231',  780);
INSERT INTO TEST05 VALUES ('19980331', 1500);
COMMIT;
-- subquery
select a.YMD YMD, r.YMD RATE_YMD, US_AMOUNT, EXC_RATE, US_AMOUNT * EXC_RATE rated_price
from test04 a, test05 r
where r.YMD = (select max(YMD) from test05 where a.YMD > YMD)
order by 1;
-- inline view
select a.YMD, r.YMD RATE_YMD, US_AMOUNT, EXC_RATE, US_AMOUNT * EXC_RATE rated_price
from (select a.YMD AYMD, max(r.YMD) RYMD from test04 a, test05 r where r.YMD < a.YMD group by a.YMD) x, test04 a, test05 r
where x.AYMD = a.YMD and x.RYMD = r.YMD
order by 1;

