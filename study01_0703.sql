/*
    0704 ���� ��(�׷�) �Լ�
*/
-- �׷��Լ� ����� ��(��, ��¥)
select salary from employee where deptno = 30;
select avg(salary), sum(salary), max(salary), min(salary) from employee where deptno = 30;
select max(hire_date), min(hire_date) from employee; -- max, min�� null���� �����Ѵ�

-- �׷��Լ� ��� ��(ī��Ʈ)
select count(comm) from employee where deptno = 20; -- null������ �ȼ���
select count(*) from employee where deptno = 20; -- Ư�� �÷� null���� ������� ����

-- �׷��Լ��� null����
select avg(comm) from employee; -- null�� �������� �ʰ� avg
select avg(nvl(comm, 0)) from employee; -- null�� 0���� �Ͽ� avg

-- Group By���� ���: select���� ���õ� �÷����� �� group by���� �־�� ��
select job, avg(salary) from employee group by job;
select deptno, job, avg(salary) from employee group by deptno, job order by deptno, job;

-- where�� having�� ����
select job, avg(salary) from employee where avg(salary) > 4000 group by job; -- err: where�� select���� �����̱� ������ �׷��Լ� ���� �Ұ�
select job, avg(salary) from employee group by job having avg(salary) > 4000; -- having�� group by�� ������� ���������� ǥ��
select count(comm) from employee having deptno = 20; -- err: having�� group by ǥ���Ŀ����� ����Ѵ�(where�� ��ü �Ұ�)

-- having�� ���� ��
select job, min(salary) from employee group by job having min(salary) > 2000;
select job, min(salary) from employee where job not like '%MAN%' group by job having min(salary) > 2000 order by min(salary); -- order by���� select���� �÷��� ��밡��

-- �׷��Լ��� ��ø
select job, avg(salary) from employee group by job; -- job�� salary ���
select job, min(avg(salary)) from employee group by job; -- err: �׷��Լ��� ��÷�� 1ȸ�� �����ϴ�. (job�� ����� �ּڰ��� ��ü���� 1���� ������)
select min(aa) from (select job, avg(salary) as aa from employee group by job); -- �μ��� ����� �ּڰ��� ���ϴ� �ùٸ� �ڵ�

/*
    �ǽ�
    1. 
    2. 1���� ��� �� sal����� 5õ�� �̻��� �� ��ȸ
    3. ���亰 �ο�, sal���, sal����/�ο��� ��� ������ �� �÷��� ����� ������ ��
    4. ����, ��̺� group by ������
    5. hobby�� ��� salary
    6. 5�� ��� salary�� ��� ��
*/

--1.
desc temp;
select birth_date, salary from temp;
select to_char(birth_date, 'YYYY') as birth_year, count(*), avg(salary), max(salary), min(salary), sum(salary), variance(salary), stddev(salary) 
    from temp
    group by to_char(birth_date, 'YYYY')
    order by birth_year;
--2.
select to_char(birth_date, 'YYYY') as birth_year, count(*), avg(salary), max(salary), min(salary), sum(salary), variance(salary), stddev(salary) 
    from temp
    group by to_char(birth_date, 'YYYY')
    having avg(salary) > 50000000;
--3.
-- salary�� null�� ���� ��ձ��ϴ� �������� ������Ű�� ����, (*)�� ī���� �� ���� ���տ��� ���� ��� �ٸ���.
select to_char(birth_date, 'YYYY') as birt_year, count(*), avg(salary), sum(salary) / count(salary)
    from temp
    group by to_char(birth_date, 'YYYY'); -- �Ȱ���
select to_char(birth_date, 'YYYY') as birt_year, count(*), avg(salary), sum(salary) / count(salary)
    from temp
    group by to_char(birth_date, 'YYYY'); -- �ٸ�
--4.
select to_char(birth_date, 'YYYY') as birth_year, hobby, count(*), avg(salary)
    from temp
    group by to_char(birth_date, 'YYYY'), hobby
    order by 1, 2;
--5.
select hobby, count(*), avg(salary)
    from temp
    group by hobby
    order by avg(salary);

--6.
select min(avg(salary)) from temp group by hobby; 
-- hobby�� �ּ���� salary�� �������� ���� hobby�� �ּ����sal�� �������� �˼����� ����

select *
from (select hobby, avg(salary) as avgsal
        from temp
        group by hobby
        order by avgsal)
    where rownum = 1;
-- inline view�� ���� �ذ��

select hobby, avg(salary)
    from temp 
    group by hobby 
    having avg(salary) = (select min(avg(salary)) from temp group by hobby);
-- ���������� ���� �ذ��


/*
    ����
    1. ���⺰ �ְ� SALARY, MAX(EMP_ID) �� �о� ���� 
*/
select * from temp;
select to_char(birth_date, 'YYYY') birth_year, salary, emp_id from temp order by 1;
select to_char(birth_date, 'YYYY') birth_year, max(salary), max(emp_id) from temp group by to_char(birth_date, 'YYYY') order by 1;

select rownum, to_char(birth_date, 'YYYY') birth_year, salary, emp_id from temp;
select yyyy, msal, (select salary from temp where emp_id = t1.mid) id
    from (
        select to_char(birth_date, 'yyyy') yyyy, max(salary) msal, max(emp_id) mid
        from temp
        group by to_char(birth_date, 'yyyy')
    ) t1; --id�� max(emp_id)�� salary: msal�� �ٸ�
    
-- ���⺰ �ְ� ���� �޴� ��� ���ϱ� 
-- ���������� �̿��� ����� ������ �Ʒ��� ����� �� ������ ����ȴ�.
-- numberŸ������ ��ġ��
select * from temp;
select to_char(birth_date, 'yyyy') yyyy, salary + to_char(salary + emp_id / power(10, 8) ) from temp; -- ������ ������� �� �÷��� ��ħ
select yyyy, trunc(msal) sal, (msal - trunc(msal)) * power(10, 8) emp_id -- ��ģ �÷� �̿��ؼ� ���ϱ�
    from (
        select to_char(birth_date, 'yyyy') yyyy, 
            max(salary + emp_id / power(10, 8) ) msal
        from temp
        group by to_char(birth_date, 'yyyy')
    );
    
select to_char(birth_date, 'yyyy') yyyy, salary, emp_id;

-- charŸ������ ��ġ�� > �񱳴�� ������ �ڸ��� ���� ���ʿ� �θ� ��Һ񱳰� ������
select to_char(birth_date, 'yyyy') yyyy,
    lpad(to_char(salary), 10, '!') || to_char(emp_id) msal
from temp
order by msal;

/*
    2. ���⺰ �ְ� SALARY ID, �ְ�ݾ�, ����SALARY ID, �����ݾ� ��������
*/
--numberŸ�� �÷�����
select yyyy, trunc(maxsal) max_sal, (maxsal - trunc(maxsal)) * power(10, 8) max_sal_id, -- max
             trunc(minsal) min_sal, (minsal - trunc(minsal)) * power(10, 8) min_sal_id -- min
    from (
        select to_char(birth_date, 'yyyy') yyyy, 
            max(salary + emp_id / power(10, 8) ) maxsal,
            min(salary + emp_id / power(10, 8) ) minsal
        from temp
        group by to_char(birth_date, 'yyyy')
    );
    
--charŸ�� �÷�����
select ����,
        to_number(substr(fst,14)) xid,
        to_number(ltrim(substr(fst,1,12), '!')) xsal
from(
    select to_char(birth_date,'yyyy') ����,
            max(lpad(to_char(salary),12,'!')||'*'|| to_char(emp_id)) fst,
            min(lpad(to_char(salary),12,'!')||'*'|| to_char(emp_id)) lst
    from temp
    group by to_char(birth_Date,'yyyy')
);

-- �� ���⿡ ���� ����� �ְ����� �������� ���� �ذ�: �������� �̿�
select to_char(birth_date, 'yyyy') yyyy, salary, emp_id
    from temp a
    where salary = (
        select max(salary)
        from temp b
        where to_char(b.birth_date, 'yyyy') =
            to_char(a.birth_date, 'yyyy')
    )
    order by 1, 2;
    
/* 
    ���ο� �ǽ� �ڷ� +_+
*/
create table sale_hist(sale_no number primary key, 
    sale_date varchar2(08) not null,
    sale_site number not null,
    sale_item varchar2(10) not null,
    sale_amt number,
    sale_emp number
);
INSERT INTO SALE_HIST VALUES(1,'20010501',   1,   'PENCIL',   5000,   19970112);
INSERT INTO SALE_HIST VALUES(2,'20010501',   1,   'NOTEBOOK',   9000,   20000119);
INSERT INTO SALE_HIST VALUES(3,'20010501',   1,   'ERASER',   4500,   19970112);
INSERT INTO SALE_HIST VALUES(4,'20010501',   2,   'PENCIL',   2500,   20000210);
INSERT INTO SALE_HIST VALUES(5,'20010501',   2,   'NOTEBOOK',   7000,   20000210);
INSERT INTO SALE_HIST VALUES(6,'20010501',   2,   'ERASER',   3000,   20000210);
INSERT INTO SALE_HIST VALUES(7,'20010501',   3,   'PENCIL',   2500,   19960212);
INSERT INTO SALE_HIST VALUES(8,'20010501',   3,   'NOTEBOOK',   7000,   19960212);
INSERT INTO SALE_HIST VALUES(9,'20010501',   3,   'ERASER',   6000,   19960212);
INSERT INTO SALE_HIST VALUES(10,'20010502',   1,   'PENCIL',   6000,   19970112);
INSERT INTO SALE_HIST VALUES(11,'20010502',   1,   'NOTEBOOK',   5000,   20000119);
INSERT INTO SALE_HIST VALUES(12,'20010502',   1,   'ERASER',   5500,   19970112);
INSERT INTO SALE_HIST VALUES(13,'20010502',   2,   'PENCIL',   3500,   20000210);
INSERT INTO SALE_HIST VALUES(14,'20010502',   2,   'NOTEBOOK',   7000,   20000210);
INSERT INTO SALE_HIST VALUES(15,'20010502',   2,   'ERASER',   4000,   20000210);
INSERT INTO SALE_HIST VALUES(16,'20010502',   3,   'PENCIL',   5500,   19960212);
INSERT INTO SALE_HIST VALUES(17,'20010502',   3,   'NOTEBOOK',   4500,   19960212);
INSERT INTO SALE_HIST VALUES(18,'20010502',   3,   'ERASER',   5000,   19960212);
INSERT INTO SALE_HIST VALUES(19,'20010503',   1,   'PENCIL',   7000,   20000119);
INSERT INTO SALE_HIST VALUES(20,'20010503',   1,   'NOTEBOOK',   6000,   19970112);
INSERT INTO SALE_HIST VALUES(21,'20010503',   1,   'ERASER',   6500,   20000119);
INSERT INTO SALE_HIST VALUES(22,'20010503',   2,   'PENCIL',   3500,   20000210);
INSERT INTO SALE_HIST VALUES(23,'20010503',   2,   'NOTEBOOK',   5000,   20000210);
INSERT INTO SALE_HIST VALUES(24,'20010503',   2,   'ERASER',   5000,   20000210);
INSERT INTO SALE_HIST VALUES(25,'20010503',   3,   'PENCIL',   6500,   19960212);
INSERT INTO SALE_HIST VALUES(26,'20010503',   3,   'NOTEBOOK',   3500,   19960212);
INSERT INTO SALE_HIST VALUES(27,'20010503',   3,   'ERASER',   7000,   19960212);
INSERT INTO SALE_HIST VALUES(28,'20010504',   1,   'PENCIL',   5500,   20000119);
INSERT INTO SALE_HIST VALUES(29,'20010504',   1,   'NOTEBOOK',   6500,   19970112);
INSERT INTO SALE_HIST VALUES(30,'20010504',   1,   'ERASER',   3500,   20000119);
INSERT INTO SALE_HIST VALUES(31,'20010504',   2,   'PENCIL',   7500,   20000210);
INSERT INTO SALE_HIST VALUES(32,'20010504',   2,   'NOTEBOOK',   5000,   20000210);
INSERT INTO SALE_HIST VALUES(33,'20010504',   2,   'ERASER',   4000,   20000210);
INSERT INTO SALE_HIST VALUES(34,'20010504',   3,   'PENCIL',   3500,   19960212);
INSERT INTO SALE_HIST VALUES(35,'20010504',   3,   'NOTEBOOK',   5500,   19960212);
INSERT INTO SALE_HIST VALUES(36,'20010504',   3,   'ERASER',   3000,   19960212);
commit;

/*
    3. SALEHIST �ڷḦ �̿��� ���� ���̺� �����͸� INSERT �ϰ��� �մϴ� 
       �� ���� CASE�� ���� SQL �� �ۼ��մϴ�.
       INSERT ���� �ʿ���� SELECT�� �ۼ�
*/
select * from sale_hist;

--sale1
select sale_date, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by sale_date order by sale_date;
--sale2
select sale_site, sale_item, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by sale_site, sale_item order by 1, 2;
--sale3
select substr(sale_date, 5, 2) as sale_mon, sale_item, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by substr(sale_date, 5, 2), sale_item order by sale_mon;

/*
    ���ο� �ǽ� ���̺� +_+
    
    ���, ��ǰ, �׸�, �ݾ����� ������ {���, ��ǰ���� �׸�(62099011: �������, 62099101: �ѿ���)}�� ���� �ݾ��� �����ϰ� �ִ� ���̺�
*/
create table test17 (
    yymm_ym varchar2(6) not null,
    item_cd varchar2(20) not null,
    budget_cd varchar2(8) not null,
    prod_amt number,
    constraint test17_pk primary key (yymm_ym, item_cd, budget_cd)
);
INSERT INTO TEST17 VALUES('199711', 'C2-', '62099011',  197557081);
INSERT INTO TEST17 VALUES('199711', 'C2-', '62099101',  19755808148914);
INSERT INTO TEST17 VALUES('199711', 'C3-', '62099011',  216227309);
INSERT INTO TEST17 VALUES('199711', 'C3-', '62099101',  21622730934624);
INSERT INTO TEST17 VALUES('199711', 'MC4', '62099011',  334920377);
INSERT INTO TEST17 VALUES('199711', 'MC4', '62099101',  33492037724575);
INSERT INTO TEST17 VALUES('199712', 'C1' , '62099011',  528.04224);
INSERT INTO TEST17 VALUES('199712', 'C1' , '62099101',  52804224);
INSERT INTO TEST17 VALUES('199712', 'C2-', '62099011',  1185.0948);
INSERT INTO TEST17 VALUES('199712', 'C2-', '62099101',  118509480);
INSERT INTO TEST17 VALUES('199712', 'C3-', '62099011',  2486.8656);
INSERT INTO TEST17 VALUES('199712', 'C3-', '62099101',  248686560);
INSERT INTO TEST17 VALUES('199712', 'MC4', '62099011',  3837.30696);
INSERT INTO TEST17 VALUES('199712', 'MC4', '62099101',  383730696);
INSERT INTO TEST17 VALUES('199801', 'C1' , '62099011',  528.04224);
INSERT INTO TEST17 VALUES('199801', 'C1' , '62099101',  52804224);
INSERT INTO TEST17 VALUES('199801', 'C2-', '62099011',  1185.0948);
INSERT INTO TEST17 VALUES('199801', 'C2-', '62099101',  118509480);
INSERT INTO TEST17 VALUES('199801', 'C3-', '62099011',  2486.8656);
INSERT INTO TEST17 VALUES('199801', 'C3-', '62099101',  248686560);
INSERT INTO TEST17 VALUES('199801', 'MC4', '62099011',  3837.30696);
INSERT INTO TEST17 VALUES('199801', 'MC4', '62099101',  383730696);
INSERT INTO TEST17 VALUES('199802', 'C2-', '62099011',  197557081);
INSERT INTO TEST17 VALUES('199802', 'C2-', '62099101',  19755708100124);
INSERT INTO TEST17 VALUES('199802', 'C3-', '62099011',  216227309);
INSERT INTO TEST17 VALUES('199802', 'C3-', '62099101',  21622730901455);
INSERT INTO TEST17 VALUES('199802', 'MC4', '62099011',  334920377);
INSERT INTO TEST17 VALUES('199802', 'MC4', '62099101',  33492037701010);
update test17 set prod_amt = trunc(prod_amt);
commit;

/*
    ��ǰ���� 1998�� 3������ ���� ���� 12����ġ DATA�� �̿��ؼ� 1998�� 3���� ��������� �ѿ����� ���ϱ� ���� ��ǰ�� �����纯�������� ���������� ���϶�
    �����纯������ = (�ְ��Ǹŷ��� ���� - �����Ǹŷ��� ����) / (�ְ��Ǹŷ� - �����Ǹŷ�)
    �������� = �ְ��Ǹŷ����� - (�����纯������ * �ְ��Ǹŷ�)
    �ְ��Ǹŷ��� ������ 12���� �� �ش���ǰ�� �Ǹŷ��� �ְ��� ���� �ѿ����� �ǹ��Ѵ�.
*/

select * from test17;
select yymm_ym, item_cd, prod_amt as qty from test17 where budget_cd = 62099011; -- ����
select yymm_ym, item_cd, prod_amt as amt from test17 where budget_cd = 62099101; -- �ѿ���
select yymm_ym, item_cd, prod_amt as qty, prod_amt as amt from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'; -- �Ѳ����� ǥ���ϴ� Ʋ �ۼ�
select yymm_ym, item_cd, decode(budget_cd, '62099011', prod_amt), decode(budget_cd, '62099101', prod_amt) 
    from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'; -- �÷� �и�
select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
    from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'
    group by yymm_ym, item_cd; -- �и��� �÷� �������� group by ����
select item_cd, 
    min(qty) as qty_min,(min(qty + amt/power(10, 15)) - min(qty)) * power(10, 15) as qty_min_amt, -- amt�� qty�÷��� ���ļ� min, max���ؼ� �ٽ� �и�
    max(qty) as qty_max,(max(qty + amt/power(10, 15)) - max(qty)) * power(10, 15) as qty_max_amt
    from (
        select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
        from test17 
        where yymm_ym >= '199703' and yymm_ym < '199803'
        group by yymm_ym, item_cd -- �и��� �÷� �������� group by ����
    )
    group by item_cd;

-- �� ���̺� �������� ���Ϸ��� �� �����
select item_cd, 
        decode(qty_max - qty_min, 0, null,(qty_max_amt - qty_min_amt) / (qty_max - qty_min)) as �����纯������,
        qty_max_amt - (decode(qty_max - qty_min, 0, null,(qty_max_amt - qty_min_amt) / (qty_max - qty_min)) * qty_max) as ��������
    from (
        select item_cd, 
            min(qty) as qty_min,(min(qty + amt/power(10, 15)) - min(qty)) * power(10, 15) as qty_min_amt, -- amt�� qty�÷��� ���ļ� min, max���ؼ� �ٽ� �и�
            max(qty) as qty_max,(max(qty + amt/power(10, 15)) - max(qty)) * power(10, 15) as qty_max_amt
            from (
                select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
                from test17 
                where yymm_ym >= '199703' and yymm_ym < '199803'
                group by yymm_ym, item_cd -- �и��� �÷� �������� group by ����
            )
            group by item_cd
    );
commit;