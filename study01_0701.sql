/*
20190701 sql 1����
*/

-- tbs(���̺����̽�) �����ϱ�
create tablespace tbs_study_01 datafile 'tbs_study01.dbf' size 20m autoextend on online;
create tablespace tbs_study_02 datafile 'tbs_study02.dbf' size 20m autoextend on online;
create tablespace tbs_study_03 datafile 'tbs_study03.dbf' size 1m autoextend on online;
select * from dba_tablespaces;

-- user �����ϱ�
create user study01 identified by study01 default tablespace tbs_study_01 quota unlimited on tbs_study_01 temporary tablespace temp;
create user study02 identified by study02 default tablespace tbs_study_02 quota unlimited on tbs_study_02 temporary tablespace temp;
select * from dba_users;

-- �α���
connect study01/study01; --����(���Ѿ���)
grant connect to study01; --������Ѻο�
connect study01/study01; --���Ӽ���

-- ���̺� ����
create table t01 (id varchar2(10)); -- ���̺� ����

-- �� ���� �� �ο�
create role study; -- �� ����
grant connect, resource, dba to study; -- �ѿ� ���� �ο�
grant study to study01; -- �� �ο�
connect study01/study01; -- ����

-- sys�� ������ �ʿ�
-- ��������
select * from all_users where username = 'SCOTT';
alter user scott identified by tiger account unlock;

-- scott ���� ����Ʈ tbs ����
select * from dba_tablespaces;
alter user scott identified by tiger default tablespace ts_study01;

-- ���� �ο�
grant connect, resource to scott;


connect scott/tiger;



CREATE TABLE BONUS
        (ENAME VARCHAR2(10),
         JOB   VARCHAR2(9),
         SAL   NUMBER,
         COMM  NUMBER);`

CREATE TABLE EMP
       (EMPNO NUMBER(4) NOT NULL,
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4),
        HIREDATE DATE,
        SAL NUMBER(7, 2),
        COMM NUMBER(7, 2),
        DEPTNO NUMBER(2));

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        TO_DATE('17-12-1980', 'DD-MM-YYYY'),  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        TO_DATE('20-02-1981', 'DD-MM-YYYY'), 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        TO_DATE('22-02-1981', 'DD-MM-YYYY'), 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        TO_DATE('2-04-1981', 'DD-MM-YYYY'),  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        TO_DATE('28-11-1981', 'DD-MM-YYYY'), 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        TO_DATE('1-05-1981', 'DD-MM-YYYY'),  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        TO_DATE('9-06-1981', 'DD-MM-YYYY'),  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        TO_DATE('09-12-1982', 'DD-MM-YYYY'), 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        TO_DATE('17-11-1981', 'DD-MM-YYYY'), 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        TO_DATE('8-09-1981', 'DD-MM-YYYY'),  1500, NULL, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        TO_DATE('12-01-1983', 'DD-MM-YYYY'), 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        TO_DATE('3-12-1981', 'DD-MM-YYYY'),   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        TO_DATE('3-12-1981', 'DD-MM-YYYY'),  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        TO_DATE('23-01-1982', 'DD-MM-YYYY'), 1300, NULL, 10);

CREATE TABLE DEPT
       (DEPTNO NUMBER(2),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE SALGRADE
        (GRADE NUMBER,
         LOSAL NUMBER,
         HISAL NUMBER);

INSERT INTO SALGRADE VALUES (1,  700, 1200);
INSERT INTO SALGRADE VALUES (2, 1201, 1400);
INSERT INTO SALGRADE VALUES (3, 1401, 2000);
INSERT INTO SALGRADE VALUES (4, 2001, 3000);
INSERT INTO SALGRADE VALUES (5, 3001, 9999);

COMMIT;

truncate table dept;

select count(*) from emp;
select count(*) from bonus;
select count(*) from salgrade;
select count(*) from dept;

alter user scott quota unlimitied on tb_study01;

select distinct object_type from dba_objects;

alter user study01 quota unlimited on tbs_study_01;
alter user study02 quota unlimited on tbs_study_02;

connect study01/study01;

/*
	�Ʒ��� study 01���� �۾� (���̺� ���� �� �ڷ� ����)
	SAMPLE DATA
*/

--���
CREATE TABLE TEMP (
 EMP_ID      NUMBER NOT NULL PRIMARY KEY,
 EMP_NAME    VARCHAR2(10) NOT NULL,
 BIRTH_DATE  DATE,
 DEPT_CODE   VARCHAR2(06) NOT NULL,
 EMP_TYPE    VARCHAR2(04),
 USE_YN      VARCHAR2(01) NOT NULL,
 TEL         VARCHAR2(15),
 HOBBY       VARCHAR2(30),
 SALARY      NUMBER,
 LEV         VARCHAR2(04)
);
alter table temp modify(emp_name varchar2(20), emp_type varchar2(12), lev varchar2(10));
INSERT INTO TEMP VALUES (19970101,'��浿',TO_DATE('19740125','YYYYMMDD'),'AA0001','����','Y','','���',100000000,'����');
INSERT INTO TEMP VALUES (19960101,'ȫ�浿',TO_DATE('19730322','YYYYMMDD'),'AB0001','����','Y','','����',72000000,'����');
INSERT INTO TEMP VALUES (19970201,'�ڹ���',TO_DATE('19750415','YYYYMMDD'),'AC0001','����','Y','','�ٵ�',50000000,'����');
INSERT INTO TEMP VALUES (19930331,'������',TO_DATE('19760525','YYYYMMDD'),'BA0001','����','Y','','�뷡',70000000,'����');
INSERT INTO TEMP VALUES (19950303,'�̼���',TO_DATE('19730615','YYYYMMDD'),'BB0001','����','Y','','',56000000,'�븮');
INSERT INTO TEMP VALUES (19966102,'������',TO_DATE('19720705','YYYYMMDD'),'BC0001','����','Y','','',45000000,'����');
INSERT INTO TEMP VALUES (19930402,'������',TO_DATE('19720815','YYYYMMDD'),'CA0001','����','Y','','',64000000,'����');
INSERT INTO TEMP VALUES (19960303,'����ġ',TO_DATE('19710925','YYYYMMDD'),'CB0001','����','Y','','',35000000,'���');
INSERT INTO TEMP VALUES (19970112,'�����',TO_DATE('19761105','YYYYMMDD'),'CC0001','����','Y','','',45000000,'�븮');
INSERT INTO TEMP VALUES (19960212,'�����',TO_DATE('19721215','YYYYMMDD'),'CD0001','����','Y','','',39000000,'����');

--�μ�
CREATE TABLE TDEPT (
 DEPT_CODE   VARCHAR2(06) NOT NULL PRIMARY KEY,
 DEPT_NAME   VARCHAR2(20) NOT NULL,
 PARENT_DEPT VARCHAR2(06) NOT NULL,
 USE_YN      VARCHAR2(01) NOT NULL,
 AREA        VARCHAR2(10),
 BOSS_ID     NUMBER
);
INSERT INTO TDEPT VALUES ('AA0001','�濵����','AA0001','Y','����',19940101);
INSERT INTO TDEPT VALUES ('AB0001','�繫','AA0001','Y','����',19960101);
INSERT INTO TDEPT VALUES ('AC0001','�ѹ�','AA0001','Y','����',19970201);
INSERT INTO TDEPT VALUES ('BA0001','�������','BA0001','Y','��õ',19930301);
INSERT INTO TDEPT VALUES ('BB0001','H/W����','BA0001','Y','��õ',19950303);
INSERT INTO TDEPT VALUES ('BC0001','S/W����','BA0001','Y','��õ',19966102);
INSERT INTO TDEPT VALUES ('CA0001','����','CA0001','Y','����',19930402);
INSERT INTO TDEPT VALUES ('CB0001','������ȹ','CA0001','Y','����',19950103);
INSERT INTO TDEPT VALUES ('CC0001','����1','CA0001','Y','����',19970112);
INSERT INTO TDEPT VALUES ('CD0001','����2','CA0001','Y','����',19960212);

COMMIT;

--Ȯ�ο�
select count(*) from temp;
select count(*) from tdept;

alter table temp add (constraint dept_r foreign key (dept_code) references tdept(dept_code)); -- dept�ڵ� ����

COMMIT;

/*
	�Ʒ��� scott table���� �۾�
	(������ ������ ����)
*/

CREATE TABLE EMPLOYEE(
   empno      INTEGER NOT NULL,
   name       VARCHAR(10),
   job        VARCHAR(9),
   boss       INTEGER,
   hiredate   VARCHAR(12),
   salary     DECIMAL(7, 2),
   comm       DECIMAL(7, 2),
   deptno     INTEGER
);
 
CREATE TABLE DEPARTMENT(
   deptno     INTEGER NOT NULL,
   name       VARCHAR(14),
   location   VARCHAR(13)
);

CREATE TABLE SALARYGRADE(
   grade      INTEGER NOT NULL,
   losal      INTEGER NOT NULL,
   hisal      INTEGER NOT NULL
);

CREATE TABLE BONUS (
   ename      VARCHAR(10) NOT NULL,
   job        VARCHAR(9) NOT NULL,
   sal        DECIMAL(7, 2),
   comm       DECIMAL(7, 2)
);

CREATE TABLE PROJECT(
   projectno    INTEGER NOT NULL,
   description  VARCHAR(100),
   start_date   VARCHAR(12),
   end_date     VARCHAR(12)
);

CREATE TABLE PROJECT_PARTICIPATION(
   projectno    INTEGER NOT NULL,
   empno        INTEGER NOT NULL,
   start_date   VARCHAR(12) NOT NULL,
   end_date     VARCHAR(12),
   role_id      INTEGER
);

CREATE TABLE ROLE(
   role_id      INTEGER NOT NULL,
   description  VARCHAR(100)
);

-- Primary Keys
ALTER TABLE EMPLOYEE
   ADD CONSTRAINT emp_pk
   PRIMARY KEY (empno);

ALTER TABLE DEPARTMENT
   ADD CONSTRAINT dept_pk
   PRIMARY KEY (deptno);

ALTER TABLE SALARYGRADE
   ADD CONSTRAINT salgrade_pk
   PRIMARY KEY (grade);

ALTER TABLE BONUS
   ADD CONSTRAINT bonus_pk
   PRIMARY KEY (ename, job);

ALTER TABLE PROJECT
   ADD CONSTRAINT project_pk
   PRIMARY KEY (projectno);
 
ALTER TABLE PROJECT_PARTICIPATION
   ADD CONSTRAINT participation_pk
   PRIMARY KEY (projectno, empno, start_date);

ALTER TABLE ROLE
   ADD CONSTRAINT role_pk
   PRIMARY KEY (role_id);

-- EMPLOYEE to DEPARTMENT
ALTER TABLE EMPLOYEE
   ADD CONSTRAINT department
   FOREIGN KEY (deptno)
   REFERENCES DEPARTMENT (deptno);

-- EMPLOYEE to EMPLOYEE
ALTER TABLE EMPLOYEE
   ADD CONSTRAINT boss
   FOREIGN KEY (boss)
   REFERENCES EMPLOYEE (empno);
 
-- EMPLOYEE to PROJECT_PARTICIPATION
ALTER TABLE PROJECT_PARTICIPATION
   ADD CONSTRAINT employee
   FOREIGN KEY (empno)
   REFERENCES EMPLOYEE (empno);

-- PROJECT to PROJECT_PARTICIPATION
ALTER TABLE PROJECT_PARTICIPATION
   ADD CONSTRAINT project
   FOREIGN KEY (projectno)
   REFERENCES PROJECT (projectno);

-- ROLE to PROJECT_PARTICIPATION
ALTER TABLE PROJECT_PARTICIPATION
   ADD CONSTRAINT role
   FOREIGN KEY (role_id)
   REFERENCES ROLE (role_id);

-- data
INSERT INTO DEPARTMENT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPARTMENT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPARTMENT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPARTMENT VALUES (40, 'OPERATIONS', 'BOSTON');
 
INSERT INTO EMPLOYEE VALUES (7839, 'KING',   'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10);
INSERT INTO EMPLOYEE VALUES (7566, 'JONES',  'MANAGER',   7839, '1981-04-02',  2975, NULL, 20);
INSERT INTO EMPLOYEE VALUES(7788, 'SCOTT',  'ANALYST',   7566, '1982-12-09', 3000, NULL, 20);
INSERT INTO EMPLOYEE VALUES(7876, 'ADAMS',  'CLERK',     7788, '1983-01-12', 1100, NULL, 20);
INSERT INTO EMPLOYEE VALUES(7902, 'FORD',   'ANALYST',   7566, '1981-12-03',  3000, NULL, 20);
INSERT INTO EMPLOYEE VALUES(7369, 'SMITH',  'CLERK',     7902, '1980-12-17',  800, NULL, 20);
INSERT INTO EMPLOYEE VALUES (7698, 'BLAKE',  'MANAGER',   7839, '1981-05-01',  2850, NULL, 30);
INSERT INTO EMPLOYEE VALUES(7499, 'ALLEN',  'SALESMAN',  7698, '1981-02-20', 1600,  300, 30);
INSERT INTO EMPLOYEE VALUES(7521, 'WARD',   'SALESMAN',  7698, '1981-02-22', 1250,  500, 30);
INSERT INTO EMPLOYEE VALUES(7654, 'MARTIN', 'SALESMAN',  7698, '1981-09-28', 1250, 1400, 30);
INSERT INTO EMPLOYEE VALUES(7844, 'TURNER', 'SALESMAN',  7698, '1981-09-08',  1500,    0, 30);
INSERT INTO EMPLOYEE VALUES(7900, 'JAMES',  'CLERK',     7698, '1981-12-03',   950, NULL, 30);
INSERT INTO EMPLOYEE VALUES(7782, 'CLARK',  'MANAGER',   7839, '1981-06-09',  2450, NULL, 10);
INSERT INTO EMPLOYEE VALUES(7934, 'MILLER', 'CLERK',     7782, '1982-01-23', 1300, NULL, 10);
 
INSERT INTO SALARYGRADE VALUES (1,  700, 1200);
INSERT INTO SALARYGRADE VALUES (2, 1201, 1400);
INSERT INTO SALARYGRADE VALUES (3, 1401, 2000);
INSERT INTO SALARYGRADE VALUES (4, 2001, 3000);
INSERT INTO SALARYGRADE VALUES (5, 3001, 9999);
 
INSERT INTO ROLE VALUES (100, 'Developer');
INSERT INTO ROLE VALUES (101, 'Researcher');
INSERT INTO ROLE VALUES (102, 'Project manager');

INSERT INTO PROJECT VALUES (1001, 'Development of Novel Magnetic Suspension System', '2006-01-01', '2007-08-13');
INSERT INTO PROJECT VALUES (1002, 'Research on thermofluid dynamics in Microdroplets', '2006-08-22', '2007-03-20');
INSERT INTO PROJECT VALUES (1003, 'Foundation of Quantum Technology', '2007-02-24', '2008-07-31');
INSERT INTO PROJECT VALUES (1004, 'High capacity optical network', '2008-01-01', null);
 
INSERT INTO PROJECT_PARTICIPATION VALUES (1001, 7902, '2006-01-01', '2006-12-30', 102);
INSERT INTO PROJECT_PARTICIPATION VALUES (1001, 7369, '2006-01-01', '2007-08-13', 100);
INSERT INTO PROJECT_PARTICIPATION VALUES (1001, 7788, '2006-05-15', '2006-11-01', 100);

INSERT INTO PROJECT_PARTICIPATION VALUES (1002, 7876, '2006-08-22', '2007-03-20', 102);
INSERT INTO PROJECT_PARTICIPATION VALUES (1002, 7782, '2006-08-22', '2007-03-20', 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1002, 7934, '2007-01-01', '2007-03-20', 101);

INSERT INTO PROJECT_PARTICIPATION VALUES (1003, 7566, '2007-02-24', '2008-07-31', 102);
INSERT INTO PROJECT_PARTICIPATION VALUES (1003, 7900, '2007-02-24', '2007-01-31', 101);

INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7499, '2008-01-01', null, 102);
INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7521, '2008-05-01', null, 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7654, '2008-04-15', null, 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7844, '2008-02-01', null, 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7900, '2008-03-01', '2008-04-01', 101);
INSERT INTO PROJECT_PARTICIPATION VALUES (1004, 7900, '2008-05-20', null, 101);

commit;



/*
	����
*/


desc employee;
select * from employee;
--select������ ��Ī ����ϱ�
select name, empno, salary * 12 "Annual Salary" from employee;
--���Ṯ�� ����غ���
select name || deptno as employees from employee;
--�ߺ� �� �����غ���
select distinct deptno from employee;
--where��
select empno, name from employee where deptno = 10;
--���� �� ��¥
select empno, job from employee where name = 'KING';
--�񱳿���
select empno, job from employee where salary > 2500;
select empno, job from employee where salary between 2000 and 3000;
select empno, job, salary from employee where salary in (2000, 2500, 3000);
select empno, name, job from employee where name like '_A%';

update employee set name = 'KING%' where name like 'KING%';
select * from employee where name = 'KING%';
select * from employee where name like 'KING$%' escape '$';

select empno, name from employee where boss is NULL;
select empno, name, salary from employee where salary > 2000 and name like '%K%';
select empno, name, salary from employee where salary > 2000 or name like '%K%';

select empno, name, salary from employee order by salary desc;
select empno, name, salary from employee order by 3 desc; -- order by�������� select���� ������ ���� ��ȣ ��� ����

/*
    ����
    
    1. TEMP SALARY�� Ȧ��:¦���� ���� 1:2�� ���� �޴´ٸ� Ȧ.¦�� �� �޿��� 
    2. TEMP ROW���� SALARY�� 12�� ���� �� SALARY�� 10% ���� �� ���ϱ�
    3. Ȧ.¦�� �� ���� 1������ ���� ���� �������� 2���� ���� ���ϱ� 
    4. 10�� NULL ���ϱ�,����,���ϱ�,������ �� �� �� �÷� SELECT
    5. nvl �ǽ�
    6. ����� ������ �о���� ���� �ڿ� ������ �ٿ��� �� �÷�ó�� �������� 
    7. DUAL TABLE�� �̿��� �̸��� ���ƹ����� �Դϴ�.  �� ���� ��� �����
    8. TEMP�� ��� ����� ����:'���¹�', ä������:'���ϡ� �� DISPLAY �ϱ�   
    9. �������� ���� ��̸� �ߺ� �� �����ϰ� �������� �� ROW���� �о����  
    10. 7���� ����� COUNT �� ROW�� ����
    11. TEMP���� ������ ������ �ڷḸ �о����
    12. TEMP���� ��̰� �Էµ��� ���� �ڷ� ��ȸ
    13. SALARY�� 12������ ������ �� �޿��� ���� �� ���޿��� 400���� �̻��� �ڷ� ��ȸ�ϱ�
    14. �������� ���� �� 45�� �̻��� �ڷ� ��ȸ�ϱ�  
    15. ��̰� ����� ��� ��ȸ�ϱ�
    16. �μ��ڵ尡 BA0001�� ��� ��ȸ�ϱ�
    17. SALARY�� 5õ���� ���� ū,����,ũ�ų�����,�۰ų�����,�ٸ� ��� ���� ��ȸ
*/
desc temp;
/*
�̸�         ��?       ����           
---------- -------- ------------ 
EMP_ID     NOT NULL NUMBER       
EMP_NAME   NOT NULL VARCHAR2(20) 
BIRTH_DATE          DATE         
DEPT_CODE  NOT NULL VARCHAR2(6)  
EMP_TYPE            VARCHAR2(12) 
USE_YN     NOT NULL VARCHAR2(1)  
TEL                 VARCHAR2(15) 
HOBBY               VARCHAR2(30) 
SALARY              NUMBER       
LEV                 VARCHAR2(10) 
*/

--1.
select emp_id, emp_name, round(salary / 18) as odd_sal, round(salary / 9) as even_sal from temp;
--2.
select emp_id, emp_name, round(salary / 12 + salary * 0.1) as real_get_pay_month from temp;
--3.
select emp_id, emp_name, round((salary / 12 + salary * 0.1) / (salary / 18), 3) as odd_sal_realget, round((salary / 12 + salary * 0.1) / (salary / 9), 3) as even_sal_realget from temp;
--4.
select 10 + NULL as plu, 10 - NULL as min, 10 * NULL as mul, 10 / NULL as div from temp;
--5. 
select 10 + nvl(NULL, 0) as nullp, 10 - nvl(NULL, 0) as nullm from temp;
--6.
select emp_id, emp_name || ' ' || lev as callname from temp;
--7. 
select '�̸��� ''�ƹ���'' �Դϴ�.' from temp;
--8.
select '����: ''' || emp_name || '''' as NAME, 'ä������: ''' || emp_type || '''' as TYPE from temp;
--9.
select distinct hobby as hobbys from temp order by hobby;
--10.
select count(distinct hobby) as n_hobby from temp;
--11.
select * from temp where lev = '����';
--12.
select * from temp where hobby is null;
--13.
select * from temp where salary / 12 > 4000000;
--14.
select temp.*, floor((sysdate - birth_date) / 365) as age from temp where (sysdate - birth_date) / 365 >= 45;
--15.
select * from temp where hobby = '���';
--16.
select * from temp where dept_code = 'BA0001';
--17.
select * from temp where salary > 50000000;
select * from temp where salary < 50000000;
select * from temp where salary >= 50000000;
select * from temp where salary >= 50000000;