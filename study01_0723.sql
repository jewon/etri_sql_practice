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
group by rollup(job_id, department_id); -- job_id�� �Ѿ��ϰ�(�Ұ�), job_id+dep_id�� �Ѿ�(�հ�)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by rollup(department_id, job_id); -- dep_id�� �Ѿ�(�Ұ�), dep_id+job_id�� �Ѿ�(�հ�)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by rollup(job_id), department_id; -- job_id�� �Ѿ�(�Ұ�)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by job_id, rollup(department_id); -- dep_id�� �Ѿ�(�Ұ�)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by cube(job_id, department_id); -- dep_id �Ѿ�(�Ұ�), job_id �Ѿ�(�Ұ�), dep_id+job_id�Ѿ�(�հ�)
-- cube�ȿ� �� �÷��� ���� ��� rollup�� ���� ����

-- grouping �Լ�: �Ѿ��Ǵ� ���� 0, 1�� ��������
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
group by grouping sets -- �� ���� group by���� union all �� �Ͱ� ����
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
-- minus ��� null

-- ���� ���� ����
select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by grouping sets(department_id, job_id, ()); -- dep_id�� �Ұ�, job_id�� �Ұ�, dep_id+job_id�Ѿ�(�հ�)

select department_id, job_id, sum(salary)
from employees
where department_id < 90
group by grouping sets(department_id, rollup(department_id, job_id)); -- dep_id�� �Ұ�, dep_id, job_id�� �Ұ�, �հ�

select department_id, job_id, manager_id, sum(salary)
from employees
group by rollup (department_id, (job_id, manager_id));

-- ����grouping
select department_id, job_id, manager_id, sum(salary)
from employees
group by department_id, rollup(job_id), cube(manager_id);

/*
    Rank�� Dense_Rank: ���� ����� ���� �Լ���
    
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
    rank() over(order by salary desc) c2, -- ��� ���� ��ġ(�������� ���� ������ +���������)
    dense_rank() over(order by salary desc) c3  -- salary���� ��ġ(�������� ���� ������ ���� ����)
from temp;

select dept_code, emp_id, emp_name, salary,
    rank() over( 
        partition by dept_code -- �μ��� 
        order by salary desc -- sal ���� ����
    ) c3
from temp;

select dept_code, emp_id, sum(salary), grouping(dept_code), grouping(emp_id),
    rank() over(
        partition by grouping(dept_code), -- dept_code�� �Ѿ��� �Ͱ� �ƴ� ��
                     grouping(emp_id) -- emp_id�� �Ѿ��� �Ͱ� �ƴ� �� ����
                     -- ��ü �Ѿ�(�հ�) / dept_code�Ѿ�(emp_id�� �Ұ�) - �ڷ���� / emp_id�Ѿ�(dept_code�� �Ұ�) / group by ����
        order by sum(salary) desc
    ) c1                 
from temp
group by rollup(dept_code, emp_id); -- dept_code �Ѿ�(emp_id�� �Ұ�) / dept_code, emp_id�Ѿ� (�հ�)

/*
    �ǽ�

*/

--1 ���ں� �������, ������ �����, ǰ��
select sale_date, sale_site, sale_item, sale_amt,
    rank() over(
        partition by sale_date
        order by sale_amt desc
    ) c1                 
from sale_hist;

--2
select emp_id, emp_name, salary,
    rank() over(order by salary) c1,
    cume_dist() over(order by salary) c2, -- ��� 1�� �� (rank����)
    percent_rank() over(order by salary) c3 -- 1���� 0���� ���� (rank-1 ����)
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
        rows unbounded preceding) as c1 -- �ڽź��� ������ �ִ� row���� sal_amt�� sum(����)
from sale_hist
where sale_site = '01';

-- ���ں� ����庰 ����� �հ� ����3�� �̵����
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

-- �� row�� �Ǹž�, ��������/����ǰ���� �ִ��Ǹ�
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

-- �� row�� �Ǹž�, ��������/����ǰ���� �ִ��Ǹž�, �ִ��Ǹž׻����, �ּ��Ǹž�, �ּ��Ǹž׻����
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
    sum(sum(sale_amt)) over() as tot1, -- over�� ���� ���༭ ���� ����
    ratio_to_report(sum(sale_amt)) over() as rat1 -- total���� smat�� ����
from sale_hist
group by sale_date;

-- lag, lead
select sale_date, sale_site, sale_item, sale_amt, 
    lag(sale_amt, 1) over( -- ���� ���ڵ� ������ (�и�)
            partition by sale_site, sale_item
            order by sale_date, sale_site, sale_item
        ) lag_amt,
    lead(sale_amt, 1) over( -- ���� ���ڵ� ������ (����)
            partition by sale_site, sale_item
            order by sale_date, sale_site, sale_item
        ) lead_amt
from sale_hist;

--sale_hist�� �ڷḦ �̿��� '01'����� 'PENCIL' ǰ���� ���ں� ���� �Ǹűݾ��� ���϶�
select sale_date,
    sum(sale_amt) over (order by sale_date rows unbounded preceding) cum_sum
from sale_hist
where sale_site = '01' and sale_item = 'PENCIL';

--ǰ��/���ں��� �����Ǹž��� ��� �̿��ϴ� �̵���հ�
select sale_date, sale_item, sum(sale_amt),
    round(avg(sum(sale_amt)) over (partition by sale_item order by sale_date rows unbounded preceding)) mw_avg
from sale_hist
group by sale_date, sale_item;

/*
    1. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� ����
    2. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� �μ��� �߰� �Ұ��
       ��ü �հ踦 �Բ� �����ִ� ����
    3. ������������ �μ���,ä�� ���� ���� SALARY�� �հ�, ���Ǽ�, ����� ���ؿ��� 
       �μ��� �߰� �Ұ�, ä�� ���к� �Ұ�, �հ踦 �Բ� �����ִ� ����   
    4. 3���������� 2�� ������ ���տ����� MINUS�� �̿��Ͽ� ���� ���� DATA �˾ƺ���    
    5. 2���� 3�� �������� �μ��ڵ�� ä�뱸�п� ���� GROUPING �Լ��� ������ ��� � ������ ���� �Ǵ��� Ȯ�� 
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
group by rollup(dept_code, emp_type)); -- dept_code�� �Ѿ��Ǿ� emp_type�� �Ұ谡 rollup���� ����
--5.
select dept_code, emp_type, sum(salary), count(salary), round(avg(salary)), grouping(dept_code), grouping(emp_type)
from temp
group by cube(dept_code, emp_type);

/*
6. TEMP �� �ڷḦ SALARY�� �з� �Ͽ� 30000000 ���ϴ� 'D',
                      30000000 �ʰ� 50000000 ���ϴ� 'C'
                      50000000 �ʰ� 70000000 ���ϴ� 'B' 
                      70000000 �ʰ��� 'A'
    ��� ����� �з��Ͽ� ��޺� �ο��� Ȯ��
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
7. ������������ �μ��ڵ�, ä�뱸��, ���ް� SALARY ����� �������� 
   1).�μ�,ä�뱸�� 2).ä�뱸��,���� 3).�μ�,���� �� �� ���� �������� 
      GROUP BY ����� ���� �� �ֵ��� GROUPING SETS ����
8. ������������ �μ��ڰ� A�� �����ϴ� �μ� �Ҽ� ������ �μ��ڵ�, ä�뱸��, ���ް� SALARY ����� �������� 
   1).�μ�,ä�뱸�� 2).ä�뱸��,���� �� �� ���� �������� 
      GROUP BY ����� ���� �� �ֵ��� GROUPING SETS ����
9. 8���� ���� ����� ������ ���տ����ڸ� �̿��� GROUP BY ���� �ۼ�
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


--Bonus����
-- 1. ���, �̸� 5���� �� ���� ǥ��
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

--2. ����� ������ ������ ���, �޿�, �����޿��� ���ϱ�
-- 1)���� �̿�
select a.emp_id, a.salary sal, sum(b.salary) cum_sum
from temp a, temp b
where a.emp_id >= b.emp_id
group by a.emp_id, a.salary
order by a.emp_id;
--2) over�� �̿�
select emp_id, salary, 
    sum(salary) over (
        order by emp_id
        rows unbounded preceding) cum_sum
from temp;