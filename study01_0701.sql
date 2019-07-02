/*
20190701 sql 1일차
*/

-- tbs(테이블스페이스) 생성하기
create tablespace tbs_study_01 datafile 'tbs_study01.dbf' size 20m autoextend on online;
create tablespace tbs_study_02 datafile 'tbs_study02.dbf' size 20m autoextend on online;
create tablespace tbs_study_03 datafile 'tbs_study03.dbf' size 1m autoextend on online;
select * from dba_tablespaces;

-- user 생성하기
create user study01 identified by study01 default tablespace tbs_study_01 quota unlimited on tbs_study_01 temporary tablespace temp;
create user study02 identified by study02 default tablespace tbs_study_02 quota unlimited on tbs_study_02 temporary tablespace temp;
select * from dba_users;

-- 로그인
connect study01/study01; --에러(권한없음)
grant connect to study01; --연결권한부여
connect study01/study01; --접속성공

-- 테이블 생성
create table t01 (id varchar2(10)); -- 테이블 생성

-- 롤 생성 및 부여
create role study; -- 롤 생성
grant connect, resource, dba to study; -- 롤에 권한 부여
grant study to study01; -- 롤 부여
connect study01/study01; -- 재접

-- sys로 재접속 필요
-- 보안해제
select * from all_users where username = 'SCOTT';
alter user scott identified by tiger account unlock;

-- scott 유저 디폴트 tbs 변경
select * from dba_tablespaces;
alter user scott identified by tiger default tablespace ts_study01;

-- 권한 부여
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
	아래는 study 01에서 작업 (테이블 생성 및 자료 삽입)
	SAMPLE DATA
*/

--사원
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
INSERT INTO TEMP VALUES (19970101,'김길동',TO_DATE('19740125','YYYYMMDD'),'AA0001','정규','Y','','등산',100000000,'부장');
INSERT INTO TEMP VALUES (19960101,'홍길동',TO_DATE('19730322','YYYYMMDD'),'AB0001','정규','Y','','낚시',72000000,'과장');
INSERT INTO TEMP VALUES (19970201,'박문수',TO_DATE('19750415','YYYYMMDD'),'AC0001','정규','Y','','바둑',50000000,'과장');
INSERT INTO TEMP VALUES (19930331,'정도령',TO_DATE('19760525','YYYYMMDD'),'BA0001','정규','Y','','노래',70000000,'차장');
INSERT INTO TEMP VALUES (19950303,'이순신',TO_DATE('19730615','YYYYMMDD'),'BB0001','정규','Y','','',56000000,'대리');
INSERT INTO TEMP VALUES (19966102,'지문덕',TO_DATE('19720705','YYYYMMDD'),'BC0001','정규','Y','','',45000000,'과장');
INSERT INTO TEMP VALUES (19930402,'강감찬',TO_DATE('19720815','YYYYMMDD'),'CA0001','정규','Y','','',64000000,'차장');
INSERT INTO TEMP VALUES (19960303,'설까치',TO_DATE('19710925','YYYYMMDD'),'CB0001','정규','Y','','',35000000,'사원');
INSERT INTO TEMP VALUES (19970112,'연흥부',TO_DATE('19761105','YYYYMMDD'),'CC0001','정규','Y','','',45000000,'대리');
INSERT INTO TEMP VALUES (19960212,'배뱅이',TO_DATE('19721215','YYYYMMDD'),'CD0001','정규','Y','','',39000000,'과장');

--부서
CREATE TABLE TDEPT (
 DEPT_CODE   VARCHAR2(06) NOT NULL PRIMARY KEY,
 DEPT_NAME   VARCHAR2(20) NOT NULL,
 PARENT_DEPT VARCHAR2(06) NOT NULL,
 USE_YN      VARCHAR2(01) NOT NULL,
 AREA        VARCHAR2(10),
 BOSS_ID     NUMBER
);
INSERT INTO TDEPT VALUES ('AA0001','경영지원','AA0001','Y','서울',19940101);
INSERT INTO TDEPT VALUES ('AB0001','재무','AA0001','Y','서울',19960101);
INSERT INTO TDEPT VALUES ('AC0001','총무','AA0001','Y','서울',19970201);
INSERT INTO TDEPT VALUES ('BA0001','기술지원','BA0001','Y','인천',19930301);
INSERT INTO TDEPT VALUES ('BB0001','H/W지원','BA0001','Y','인천',19950303);
INSERT INTO TDEPT VALUES ('BC0001','S/W지원','BA0001','Y','인천',19966102);
INSERT INTO TDEPT VALUES ('CA0001','영업','CA0001','Y','본사',19930402);
INSERT INTO TDEPT VALUES ('CB0001','영업기획','CA0001','Y','본사',19950103);
INSERT INTO TDEPT VALUES ('CC0001','영업1','CA0001','Y','본사',19970112);
INSERT INTO TDEPT VALUES ('CD0001','영업2','CA0001','Y','본사',19960212);

COMMIT;

--확인용
select count(*) from temp;
select count(*) from tdept;

alter table temp add (constraint dept_r foreign key (dept_code) references tdept(dept_code)); -- dept코드 연결

COMMIT;

/*
	아래는 scott table에서 작업
	(연습용 데이터 삽입)
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
	연습
*/


desc employee;
select * from employee;
--select문에서 별칭 사용하기
select name, empno, salary * 12 "Annual Salary" from employee;
--연결문자 사용해보기
select name || deptno as employees from employee;
--중복 행 제거해보기
select distinct deptno from employee;
--where절
select empno, name from employee where deptno = 10;
--문자 및 날짜
select empno, job from employee where name = 'KING';
--비교연산
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
select empno, name, salary from employee order by 3 desc; -- order by기준으로 select문의 순서에 따른 번호 사용 가능

/*
    과제
    
    1. TEMP SALARY를 홀수:짝수달 비율 1:2로 나눠 받는다면 홀.짝수 달 급여는 
    2. TEMP ROW마다 SALARY를 12로 나눈 후 SALARY의 10% 더한 값 구하기
    3. 홀.짝수 달 각각 1번에서 구한 값을 기준으로 2번의 비율 구하기 
    4. 10에 NULL 더하기,빼기,곱하기,나누기 한 네 개 컬럼 SELECT
    5. nvl 실습
    6. 사번과 성명을 읽어오되 성명 뒤에 직급을 붙여서 한 컬럼처럼 가져오기 
    7. DUAL TABLE을 이용해 이름은 ‘아무개’ 입니다.  와 같은 결과 만들기
    8. TEMP의 모든 사원을 성명:'이태백', 채용형태:'인턴‘ 로 DISPLAY 하기   
    9. 직원들이 가진 취미를 중복 행 제거하고 종류별로 한 ROW씩만 읽어오기  
    10. 7번의 결과를 COUNT 해 ROW수 세기
    11. TEMP에서 직급이 과장인 자료만 읽어오기
    12. TEMP에서 취미가 입력되지 않은 자료 조회
    13. SALARY를 12개월로 나누어 월 급여를 받을 때 월급여가 400만원 이상인 자료 조회하기
    14. 현재일자 기준 만 45세 이상인 자료 조회하기  
    15. 취미가 등산인 사람 조회하기
    16. 부서코드가 BA0001인 사람 조회하기
    17. SALARY가 5천만원 보다 큰,작은,크거나같은,작거나같은,다른 경우 각각 조회
*/
desc temp;
/*
이름         널?       유형           
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
select '이름은 ''아무개'' 입니다.' from temp;
--8.
select '성명: ''' || emp_name || '''' as NAME, '채용형태: ''' || emp_type || '''' as TYPE from temp;
--9.
select distinct hobby as hobbys from temp order by hobby;
--10.
select count(distinct hobby) as n_hobby from temp;
--11.
select * from temp where lev = '과장';
--12.
select * from temp where hobby is null;
--13.
select * from temp where salary / 12 > 4000000;
--14.
select temp.*, floor((sysdate - birth_date) / 365) as age from temp where (sysdate - birth_date) / 365 >= 45;
--15.
select * from temp where hobby = '등산';
--16.
select * from temp where dept_code = 'BA0001';
--17.
select * from temp where salary > 50000000;
select * from temp where salary < 50000000;
select * from temp where salary >= 50000000;
select * from temp where salary >= 50000000;