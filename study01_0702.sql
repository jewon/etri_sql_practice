/*
    0702 �پ��� ������ �Լ���
*/

--�ڷ� �߰�
INSERT INTO TEMP VALUES (20000101,'���¹�',TO_DATE('19800125','YYYYMMDD'),'AA0001','����','Y','123-4567','���', 30000000,'����');
INSERT INTO TEMP VALUES (20000102,'�輳��',TO_DATE('19800322','YYYYMMDD'),'AB0001','����','Y','234-5678','����', 30000000,'����');
INSERT INTO TEMP VALUES (20000203,'�ֿ���',TO_DATE('19800415','YYYYMMDD'),'AC0001','����','Y','345-6789','�ٵ�', 30000000,'����');
INSERT INTO TEMP VALUES (20000334,'������',TO_DATE('19800525','YYYYMMDD'),'BA0001','����','Y','456-7890','�뷡', 30000000,'����');
INSERT INTO TEMP VALUES (20000305,'���Ͼ�',TO_DATE('19800615','YYYYMMDD'),'BB0001','����','Y','567-8901','����', 30000000,'����');
INSERT INTO TEMP VALUES (20006106,'������',TO_DATE('19800705','YYYYMMDD'),'BC0001','����','Y','678-9012','��',   30000000,'����');
INSERT INTO TEMP VALUES (20000407,'���ֿ�',TO_DATE('19800815','YYYYMMDD'),'CA0001','����','Y','789-0123','����', 30000000,'����');
INSERT INTO TEMP VALUES (20000308,'������',TO_DATE('19800925','YYYYMMDD'),'CB0001','����','Y','890-1234','����', 30000000,'����');
INSERT INTO TEMP VALUES (20000119,'��ݰ�',TO_DATE('19801105','YYYYMMDD'),'CC0001','����','Y','901-2345','��',   30000000,'����');
INSERT INTO TEMP VALUES (20000210,'���Ѷ�',TO_DATE('19801215','YYYYMMDD'),'CD0001','����','Y','012-3456','����', 30000000,'����');
COMMIT;

/*

*/
--1.
select * from temp where dept_code not in ('AA0001', 'BA0001', 'CA0001');
--2.
select * from temp where hobby not in ('���', '����');
--3.
select * from temp where lev in ('����', '����') and (hobby is null or dept_code = 'AB0001');
--4.
select * from temp order by emp_id;
select * from temp order by emp_id desc;
--5.
select emp_id as ���, emp_name from temp order by ���;
--6.
select * from temp order by salary desc, birth_date;
--8.
select distinct lev from temp;
select a.dept_code, (select distinct lev from temp) from tdept as a, temp as b;


/*
    ������ �Լ� / ������(�׷�) �Լ�
*/
-- lower
desc employee;
select * from employee;
select empno, name from employee where lower(name) = 'king%';
select empno, name, instr(name, 'A'), length(name) from employee;

-- ���� �Լ�
select round(52.824, 2) a, round(52.824, 0) b, round(52.824, -1) c, round(52.824, 2) d, round(52.824) e, round(52.824, -2) f from dual;
select empno, salary, mod(salary, 3000) from employee;

-- ��¥ �Լ�
alter table employee add(hire_date DATE NULL);
update employee set hire_date = to_date(hiredate, 'yyyy-mm-dd');
-- date������ ���� ����(�� ��)
select empno, round((sysdate - hire_date) / 7) as WEEKS from employee;
-- last_day�� �� ���� ������ ��¥, next_day�� �� ���� �ش� ������ ��¥
select empno, hiredate, months_between(sysdate, hiredate), add_months(hire_date, 5), last_day(hire_date), next_day(hire_date, '�ݿ���') from employee;
-- ��¥ ������
select empno, to_char(hire_date, 'Month DD day YYYY') hiredate from employee;
select to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') from dual;
select to_date('20190601131211', 'YYYYMMDDHH24MISS') from dual;

-- �ݾ� ������
select to_char(salary, 'L99,999,00') salary from employee;
select to_number(to_char(salary, 'L99,999,00'), 'L99,999,00') salary from employee;

-- nulló��
select empno, name, NVL(salary, 0) from employee;
select empno, name, NVL2(salary, '��������', '���޾���') sal from employee;
select empno, name, comm, salary, coalesce(comm, salary, 0) income from employee; -- ���� ���ں��� null�ƴѰ� ǥ��

-- �Լ���ø
select empno, name, nvl(to_char(boss), '�����ھ���') from employee;

-- ����(���ڼ�����)
select lpad(name, 10, '!') from employee;
select rpad(name, 10, '#') from employee;

-- ���� ���� �ٷ��
select name, substr(name, 2, 1) from employee; -- ����° ���� �����ϸ� �� �� ��θ� ����Ѵ�
select name, ltrim(name, 'K') from employee; -- �տ� �پ� �ִ� K�� �� ���� (rtrim�� �ڿ� ����~)
select name, translate(name, 'A', '*') from employee; -- replace
select name, replace(name, 'A') from employee; -- replace(������ ���� ������ ����)

-- �ø�, ����(�ڸ��� ���� ���� �����θ�)
select ceil(21.003) from dual;
select floor(21.003) from dual;

-- ����
select power(3, 4) from dual;
select sqrt(81) from dual;
select sign(-100) from dual; -- ���� ���� �����ִ� �Լ�(-1, 0, 1 ����)
select abs(-10) from dual;
select mod(3, 2) from dual;
select decode(1, 1, 1, 2) from dual; -- �÷��� ���� ������ �ٸ���
select greatest(1, 2) from dual;
select greatest('10', '2', '3') from dual;
select least(1, 2) from dual;
select vsize('�ѱ�'), vsize('ABC'), lengthb('�ѱ�') from dual;
select substr('�������Ǿ�̴������Ͼ�ϴ�', 6) from dual;
select substrb('�������Ǿ�̴������Ͼ�ϴ�', 6) from dual; -- ����Ʈ �� ����substr
select instr('�������Ǿ�̴������Ͼ��Դϴ�', '��') from dual;
select instrb('�������� ��̴������Ͼ�ϴ�', '��') from dual;
select rownum no, chr(rownum) from dba_objects where rownum < 125; -- chr ASCII���� char��
select ascii('A'), ascii('a') from dual; -- �ƽ�Ű �ڵ� ã��

/*
1. DBA_TABLES���� ���̺���� �ҹ��ڷ� �� ���̺� ã�� 
2. DBA_OBJECTS���� NAME�� �ҹ��ڰ� ���Ե� ���̺� ã�� 
3. ����� �μ��ڵ带 �������� �μ��ڵ�� ù��° �ڸ��� �빮�ڰ� ��������
4. ����� ��̸� �������� ��̴� ���� ���� 10�ڸ��� ǥ���ϰ�  
   ���� ���ڸ��� ��*�� �� ä�� ��
5. ����� ��̸� �������� ��̴� ���� ���� 10�ڸ��� ǥ���ϰ� ���� 
   ���ڸ��� ��*�� �� ä�� ��
6. ���, �μ��ڵ� ���� �� �ڸ� ��������
7. ���, �μ��ڵ� ��° �ڸ� ���� ��� ��������
8. ���, �μ��ڵ� ��°���� 4�ڸ� ��������
9. ���, �μ��ڵ�, �μ��ڵ忡 0�� ���ʷ� ��Ÿ���� �ڸ� ��������
10. �μ� ���̺��� �ڵ�, ��Ī, ��Ī �� �������� �̶� ���ڴ� ��**�� �� 
   ġȯ�Ͽ� ��������   
*/
--1.
select * from dba_tables where table_name = lower(table_name);
--2.
select * from dba_objects where not (object_name = upper(object_name));
--3.
select emp_id, upper(substr(dept_code, 1, 1)) || substr(dept_code, 2) from temp;
--4.
select emp_id, lpad(nvl(hobby, '*'), 10, '*') from temp; 
--5.
select emp_id, rpad(nvl(hobby, '*'), 10, '*') from temp; 
--6.
select emp_id, substr(dept_code, 1, 2) from temp;
--7.
select emp_id, substr(dept_code, 3) from temp;
--8.
select emp_id, substr(dept_code, 1, 2) from temp;
--9.
select emp_id, dept_code, instr(dept_code, '0') from temp;
--10.
select dept_code, dept_name, replace(dept_name, '����', '**') from tdept;

/*
11. ASCII �� 89���� �ش�Ǵ� ���ڴ�? 
12. ��!��, SPACE, ��~�� �� �ش��ϴ� ASCII �ڵ� �� �о����
13. ���, SALARY/12 �� �Ҽ����Ʒ� �� ��°, 1�� �ڸ�, 100�� �ڸ��� �ݿø� �� �� ��������
14. ���, SALARY/12 �� �Ҽ����Ʒ� �� ��°, 1�� �ڸ�, 100�� �ڸ� ���� ����� ���� 
15. ROW��ȣ, EMP_ID, EMP_NAME, ROW ��ȣ�� 3���� ���� ��, 
   3���� ���� �� ���� ū ���� ���� ����, 3���� ���� ������ ���� ���� ū ������ ��������
16. 11�� ������ ��, 4������ ��, 556�� ������ �˾Ƴ���
17. -100, 100�� �Լ� �ΰ��� ��ø���� ����Ͽ� ��� 1�� �ٲٱ�
18. ���, SALARY, SALARY�� õ������ ���� ������ �������� 
19. TEMP ���̺��� ���ڵ带 ������� �� ���� ���� ��ȣ ���� ��, ���, ���� ��������
*/
--11.
select chr(89) from dual;
--12.
select ascii('!'), ascii(' '), ascii('~') from dual;
--13.
select emp_id, round(salary/12, 2), round(salary/12), round(salary/12, -2) from temp;
--14.
select emp_id, floor(salary/12 * 100)/100, floor(salary/12), floor(salary/1200) * 100 from temp;
--15.
select rownum, emp_id, emp_name, rownum / 3, ceil(rownum / 3), floor(rownum / 3) from temp;
--16.
select power(11, 2), power(11, 4), sqrt(556) from temp;
--17.
select abs(sign(-100)), abs(sign(100)) from dual;
--18.
select emp_id, salary, salary % 10000000;
--19.
select ceil(rownum / 3), emp_id, emp_name from temp;
 
 /*
    ����
    1. ���, ����, �����, ����Ͽ� 55������ ���� ��¥, ����Ͽ� 55������ �� ��¥ ��������
    2. ���ƿ��� �Ͽ��ϰ� ����� ��¥�� ã�Ƴ���
    3. EMP_ID, EMP_NAME, ����Ͽ� �ش�Ǵ� ����� ������ ���� ã��
    4. ����ð��� '1980-01-25 00:00:00', '1980-JAN-25 000000'�� ���� ������ ���ڷ� �����ֱ�
    5. EMP_ID, EMP_NAME, SALARY/12, SALARY/12�� �Ҽ��� �Ʒ� �� �ڸ����� �����ֱ�
    6. EMP_ID, EMP_NAME, HOBBY, HOBBY�� NULL�̸� '0', �ƴϸ� '1' �� ���
    7. EMP_ID, EMP_NAME, TEL, HOBBY, EMP_TYPE, TEL ������ TEL, ������ HOBBY, �׵������� EMP_TYPE�� �����ֱ�
 */

desc temp;
--1.
select emp_id, emp_name, birth_date, birth_date, add_months(birth_date, -55) from temp;
--2.
select next_day(sysdate, '�Ͽ���'), next_day(sysdate, '�����') from dual;
--3.
select emp_id, emp_name, last_day(birth_date) from temp;
--4.
select to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS'), to_char(sysdate, 'YYYY-MON-DD HH24MISS', 'NLS_DATE_LANGUAGE=ENGLISH') from dual;
--5.
select emp_id, emp_name, salary/12, floor(salary/12 * 100) / 100 from temp;
--6.
select emp_id, emp_name, hobby, decode(hobby, null, 0, 1) from temp;
--7.
select emp_id, emp_name, tel, hobby, emp_type, tel, decode(tel, null, decode(hobby, null, emp_type, hobby), tel) from temp;

/*
rownum
rownum�� �׻� <, <=�� ���Ǹ� ��� ������ �� ����(�� ù �ุ =1�� ���ð���)
*/
select * from temp where rownum = 10; -- ��� ����
select * from temp where rownum > 1; -- ��� ����

select rownum, emp_id, emp_name, lev from temp order by emp_name;
select rownum, emp_id, emp_name from temp where lev = '����' and rownum < 10 order by emp_name;

/*
rowid
rowid�� db�� Ư�� row�� ���� ������ �ĺ���(db, ���̺�, ��ü � ���� ���� ����)
*/
select rowid, rownum, emp_id, emp_name from temp;

/*
decode
�Ϲ� ���α׷��� ����� if�� ������ ���ش�(select�� from ���� ��� ������ ��� ����)

decod(a, b, 'T', 'F')�� �Ʒ��� ���� �ǹ�
if(a == b)
    return 'T';
else
    return 'F';
    
decode(a, b, 'T', c, 'F', 'X')�� �Ʒ��� ���� �ǹ�
if(a == b)
    return 'T';
else if (a == c)
    return 'F'
else
    return 'X'

else if�κ��� ���� �������� ��� ��� ���� decode(a, b, 'B', c, 'C', d, 'D' ...)

+
��ø if���� decode�� ��ø���Ѽ� ��� ����
��Һ񱳴� sign(a-b)�� ��ø���Ѽ� ��� ����(�ſ� ���� ���̴� ����)

*/

/*
1.���ȣ, ���, ���� �������� 
2.1�� �� ���� 5�Ǹ� ��������
3.��̰� ���� �ڷ��� ���ȣ, ���, ������ EMP ID ������ SORT�� ���� 3�Ǹ� �б� 
4.EMP ID,LEV, lev�� ���� ����0, ���1, �븮2, ����3, ����4, ����5, ������6)���� ������ �÷� 
5.EMP ID, ��̰� NULL�̸� 0 �ƴϸ� 1 �� ������ �·� 
6.EMP ID, 4õ������ SALARYǾ ���ؼ� 4õ���� ���ϸ� ������' �ƴϸ� ������' �� ������ �÷�
7.NULL �� �ƴ� �ڷḸ EMP ID, HOBBY, HOBBY �� ������ �ٵ��̸� �����!' �ƴϸ� ����?' ���� 
8.�������ڿ��� 1�⿡ 12������ 40���� �� ������ BIRTH DATE�� Ÿ�� ��� �� EMP ID, DEPT CODE, HOBBY, 
  ��̰� �����鼭 �μ��ڵ� ù�ڸ��� ��C' �̸� �����ܴ��' �������� ���׳ɳ���' ) �÷�
*/
--1.
select rownum, emp_id, emp_name from temp;
--2.
select rownum, emp_id, emp_name from temp where rownum <= 5;
--3.
select rownum, temp.* from temp where hobby is null order by emp_id;
select * from (select rownum as rn, emp_id, emp_name from temp where hobby is null order by emp_id) where rownum < 4; -- inline view

--explain�� �ϸ� cost���� ������ �� �� ����(SCAN��� � ���´�)
--SCAN����� ���� rownum�� �޶����� ������ rownum�� �������� ������ �ƴϱ⵵ �ϴ�
explain plan for
select * from temp where hobby is null and rownum < 4 order by emp_id;
select * from table(dbms_xplan.display); -- FULL SCAN (ȯ����� �ٸ�)
explain plan for
select * from temp where emp_id > 0 and hobby is null and rownum < 4;
select * from table(dbms_xplan.display); -- FULL SCAN (ȯ����� �ٸ�)

alter session set optimizer_mode = 'RULE'; -- ���� INDEX SCAN (cost��X)
select * from temp where emp_id > 0 and hobby is null and rownum < 4; -- ���ϴ� ����� ����

--4.
select emp_id, lev, decode(lev, '����', 0, '���', 1, '�븮', 2, '����', 3, '����', 4, '����', 5, 6) as levcd from temp;
--5.
select emp_id, decode(hobby, null, 0, 1) as hobbyisnull from temp;
--6.
select emp_id, decode(sign(salary - 40000000), -1, '����', '����') from temp;
--7.
select emp_id, hobby, decode(hobby, '����', '���', '�ٵ�', '���', '��') from temp where hobby is not null;
--8.
select emp_id, dept_code, hobby, decode(substr(dept_code, 1, 1), 'C', '���ܴ��', '�׳ɳ���')
from temp 
where add_months(sysdate, -12 * 40) > birth_date;