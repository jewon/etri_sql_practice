-- 4��_1����_�����

/*
1. TDEPT�� �μ��ڵ�� �����μ��ڵ� ������ �̿��� CEO001���� ������ TOP-DOWN ����� ���� �˻��� �����ϵ�
   ����� �μ������� ���ĵǵ��� ���� ����
*/
select lpad(dept_code, length(dept_code) + level - 1, '*') as dept_code, dept_name 
from tdept 
start with dept_code = 'CEO001' 
connect by prior dept_code = parent_dept;

/*
2. TEMP1�� ��ȭ��ȣ 15�ڸ����� �����̽�(�� ��)�� ��ù�(��-��)�� �����ϰ� �������� ���� ���� ���ڸ��� ��� ������(��*��) �� ä��� ONE ������Ʈ ���� �ۼ� �� ���� �� COMMIT (NULL�� �ڷᵵ ��� ������(��*��) �� ä������ ��) 
*/
update temp
set tel = nvl(lpad(replace(replace(tel, '-'), ' '), 15, '*'), '***************');

/*
3. TEMP ���� ��̰� ������ ������ �ƴ� ����(�Է� �ȵ� ���� ����) �� ���� QUERY
*/
select *
from temp
where not ((hobby = '����') or (hobby = '����'));

/*
4. 
   4.1 TEMP�� EMP_ID �÷��� ������ ��� �÷��� �ɸ� �ε����� ��ȸ�ϴ� ���� �ۼ�
   4.2 ���� ���� ����� �����Ͽ� EMP_ID�� ������ �÷��� �ɸ� ��� �ε����� DROP �ϴ� ������ ����� ��ȯ�ϴ� �����ۼ�
   4.3 4.2�� ����� ���� ���� ���� �ε����� DROP;
   4.4 SALARY �÷��� SALARY1 �̶�� �̸��� INDEX ����� ������ �ε����� ���̺�� �÷� Ȯ���ϴ� ���� �ۼ�
   4.5 ������ �ε����� �̿��Ͽ� SALARY ������������ ����� �˻� ���� �ۼ�
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
5. TEMP���� �ڹ������� �޿��� ���Թ޴� ���� �˻��Ͽ� ���,����,�޿�,�ڹ����޿� �Բ� �����ֱ�(��, ANALYTIC  FUNCTION ��� ����)
*/
select e.emp_id, e.emp_name, e.salary, m.salary as munsu_sal
from temp e, temp m
where m.emp_name = '�ڹ���'
and e.salary < m.salary;

/*
6. TEMP �� EMP_LEVEL �� �̿��� EMP_LEVEL�� ���� ������ ���� ����/���� ���� ���� ��� ��� ������ ���,����,����,SALARY, ���� ����,���� ���� �о� ����
*/
select e.*, l.from_sal mylev_from_sal, l.to_sal mylev_to_sal, kl.from_sal kwajang_from_sal, kl.to_sal kwajang_to_sal
from 
    (select from_sal, to_sal from emp_level where lev = '����') kl,
    (select lev, from_sal, to_sal from emp_level) l,
    (select emp_id, emp_name, lev, salary from temp) e
where e.salary between kl.from_sal and kl.to_sal
      and e.lev = l.lev(+);

/*   
7. 16������ 125�� ���� ��ȣ�� �ش�Ǵ� ASCII �ڵ� ���� ���ڵ��� 1�ٿ� 5���� �ĸ�(,) �����ڷ� �����ֱ�
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