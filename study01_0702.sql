/*
    0702 다양한 단일행 함수들
*/

--자료 추가
INSERT INTO TEMP VALUES (20000101,'이태백',TO_DATE('19800125','YYYYMMDD'),'AA0001','인턴','Y','123-4567','등산', 30000000,'수습');
INSERT INTO TEMP VALUES (20000102,'김설악',TO_DATE('19800322','YYYYMMDD'),'AB0001','인턴','Y','234-5678','낚시', 30000000,'수습');
INSERT INTO TEMP VALUES (20000203,'최오대',TO_DATE('19800415','YYYYMMDD'),'AC0001','인턴','Y','345-6789','바둑', 30000000,'수습');
INSERT INTO TEMP VALUES (20000334,'박지리',TO_DATE('19800525','YYYYMMDD'),'BA0001','인턴','Y','456-7890','노래', 30000000,'수습');
INSERT INTO TEMP VALUES (20000305,'정북악',TO_DATE('19800615','YYYYMMDD'),'BB0001','인턴','Y','567-8901','독서', 30000000,'수습');
INSERT INTO TEMP VALUES (20006106,'유도봉',TO_DATE('19800705','YYYYMMDD'),'BC0001','인턴','Y','678-9012','술',   30000000,'수습');
INSERT INTO TEMP VALUES (20000407,'윤주왕',TO_DATE('19800815','YYYYMMDD'),'CA0001','인턴','Y','789-0123','오락', 30000000,'수습');
INSERT INTO TEMP VALUES (20000308,'강월악',TO_DATE('19800925','YYYYMMDD'),'CB0001','인턴','Y','890-1234','골프', 30000000,'수습');
INSERT INTO TEMP VALUES (20000119,'장금강',TO_DATE('19801105','YYYYMMDD'),'CC0001','인턴','Y','901-2345','술',   30000000,'수습');
INSERT INTO TEMP VALUES (20000210,'나한라',TO_DATE('19801215','YYYYMMDD'),'CD0001','인턴','Y','012-3456','독서', 30000000,'수습');
COMMIT;

/*

*/
--1.
select * from temp where dept_code not in ('AA0001', 'BA0001', 'CA0001');
--2.
select * from temp where hobby not in ('등산', '낚시');
--3.
select * from temp where lev in ('과장', '차장') and (hobby is null or dept_code = 'AB0001');
--4.
select * from temp order by emp_id;
select * from temp order by emp_id desc;
--5.
select emp_id as 사번, emp_name from temp order by 사번;
--6.
select * from temp order by salary desc, birth_date;
--8.
select distinct lev from temp;
select a.dept_code, (select distinct lev from temp) from tdept as a, temp as b;


/*
    단일행 함수 / 다중행(그룹) 함수
*/
-- lower
desc employee;
select * from employee;
select empno, name from employee where lower(name) = 'king%';
select empno, name, instr(name, 'A'), length(name) from employee;

-- 숫자 함수
select round(52.824, 2) a, round(52.824, 0) b, round(52.824, -1) c, round(52.824, 2) d, round(52.824) e, round(52.824, -2) f from dual;
select empno, salary, mod(salary, 3000) from employee;

-- 날짜 함수
alter table employee add(hire_date DATE NULL);
update employee set hire_date = to_date(hiredate, 'yyyy-mm-dd');
-- date끼리는 연산 가능(일 수)
select empno, round((sysdate - hire_date) / 7) as WEEKS from employee;
-- last_day는 그 달의 마지막 날짜, next_day는 그 다음 해당 요일의 날짜
select empno, hiredate, months_between(sysdate, hiredate), add_months(hire_date, 5), last_day(hire_date), next_day(hire_date, '금요일') from employee;
-- 날짜 포맷팅
select empno, to_char(hire_date, 'Month DD day YYYY') hiredate from employee;
select to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') from dual;
select to_date('20190601131211', 'YYYYMMDDHH24MISS') from dual;

-- 금액 포맷팅
select to_char(salary, 'L99,999,00') salary from employee;
select to_number(to_char(salary, 'L99,999,00'), 'L99,999,00') salary from employee;

-- null처리
select empno, name, NVL(salary, 0) from employee;
select empno, name, NVL2(salary, '봉급있음', '봉급없음') sal from employee;
select empno, name, comm, salary, coalesce(comm, salary, 0) income from employee; -- 앞의 인자부터 null아닌거 표출

-- 함수중첩
select empno, name, nvl(to_char(boss), '관리자없음') from employee;

-- 정렬(글자수맞춤)
select lpad(name, 10, '!') from employee;
select rpad(name, 10, '#') from employee;

-- 각종 글자 다루기
select name, substr(name, 2, 1) from employee; -- 세번째 인자 생략하면 그 뒤 모두를 출력한다
select name, ltrim(name, 'K') from employee; -- 앞에 붙어 있는 K를 다 뗀다 (rtrim은 뒤에 붙은~)
select name, translate(name, 'A', '*') from employee; -- replace
select name, replace(name, 'A') from employee; -- replace(마지막 인자 생략시 삭제)

-- 올림, 내림(자릿수 지정 없이 정수로만)
select ceil(21.003) from dual;
select floor(21.003) from dual;

-- 수학
select power(3, 4) from dual;
select sqrt(81) from dual;
select sign(-100) from dual; -- 수의 양음 구해주는 함수(-1, 0, 1 리턴)
select abs(-10) from dual;
select mod(3, 2) from dual;
select decode(1, 1, 1, 2) from dual; -- 컬럼명 조건 같으면 다르면
select greatest(1, 2) from dual;
select greatest('10', '2', '3') from dual;
select least(1, 2) from dual;
select vsize('한글'), vsize('ABC'), lengthb('한글') from dual;
select substr('새나라의어린이는일찍일어납니다', 6) from dual;
select substrb('새나라의어린이는일찍일어납니다', 6) from dual; -- 바이트 수 기준substr
select instr('새나라의어린이는일찍일어입니다', '일') from dual;
select instrb('새나라의 어린이는일찍일어납니다', '일') from dual;
select rownum no, chr(rownum) from dba_objects where rownum < 125; -- chr ASCII에서 char로
select ascii('A'), ascii('a') from dual; -- 아스키 코드 찾기

/*
1. DBA_TABLES에서 테이블명이 소문자로 된 테이블 찾기 
2. DBA_OBJECTS에서 NAME에 소문자가 포함된 테이블 찾기 
3. 사번과 부서코드를 가져오되 부서코드는 첫번째 자리만 대문자가 나오도록
4. 사번과 취미를 가져오되 취미는 우측 정렬 10자리로 표시하고  
   앞의 빈자리는 ‘*’ 로 채울 것
5. 사번과 취미를 가져오되 취미는 좌측 정렬 10자리로 표시하고 뒤의 
   빈자리는 ‘*’ 로 채울 것
6. 사번, 부서코드 앞의 두 자리 가져오기
7. 사번, 부서코드 셋째 자리 이후 모두 가져오기
8. 사번, 부서코드 셋째부터 4자리 가져오기
9. 사번, 부서코드, 부서코드에 0이 최초로 나타나는 자리 가져오기
10. 부서 테이블에서 코드, 명칭, 명칭 중 ‘지원’ 이란 글자는 ‘**’ 로 
   치환하여 가져오기   
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
select dept_code, dept_name, replace(dept_name, '지원', '**') from tdept;

/*
11. ASCII 값 89번에 해당되는 문자는? 
12. ‘!’, SPACE, ’~’ 에 해당하는 ASCII 코드 값 읽어오기
13. 사번, SALARY/12 를 소수점아래 두 번째, 1의 자리, 100의 자리로 반올림 한 값 가져오기
14. 사번, SALARY/12 를 소수점아래 두 번째, 1의 자리, 100의 자리 까지 남기고 절사 
15. ROW번호, EMP_ID, EMP_NAME, ROW 번호를 3으로 나눈 값, 
   3으로 나눈 값 보다 큰 가장 작은 정수, 3으로 나눈 값보다 작은 가장 큰 정수를 가져오기
16. 11을 제곱한 값, 4제곱한 값, 556의 제곱근 알아내기
17. -100, 100을 함수 두개를 중첩으로 사용하여 모두 1로 바꾸기
18. 사번, SALARY, SALARY를 천만으로 나눈 나머지 가져오기 
19. TEMP 테이블의 레코드를 순서대로 세 개씩 같은 번호 붙인 값, 사번, 성명 가져오기
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
    연습
    1. 사번, 성명, 출생일, 출생일에 55개월을 더한 날짜, 출생일에 55개월을 뺀 날짜 가져오기
    2. 돌아오는 일요일과 목요일 날짜로 찾아내기
    3. EMP_ID, EMP_NAME, 출생일에 해당되는 년월의 마지막 일자 찾기
    4. 현재시간을 '1980-01-25 00:00:00', '1980-JAN-25 000000'와 같은 형식의 문자로 보여주기
    5. EMP_ID, EMP_NAME, SALARY/12, SALARY/12를 소수점 아래 두 자리까지 보여주기
    6. EMP_ID, EMP_NAME, HOBBY, HOBBY가 NULL이면 '0', 아니면 '1' 을 출력
    7. EMP_ID, EMP_NAME, TEL, HOBBY, EMP_TYPE, TEL 있으면 TEL, 없으면 HOBBY, 그도없으면 EMP_TYPE을 보여주기
 */

desc temp;
--1.
select emp_id, emp_name, birth_date, birth_date, add_months(birth_date, -55) from temp;
--2.
select next_day(sysdate, '일요일'), next_day(sysdate, '목요일') from dual;
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
rownum은 항상 <, <=의 조건만 사용 가능한 것 유의(단 첫 행만 =1로 선택가능)
*/
select * from temp where rownum = 10; -- 결과 없음
select * from temp where rownum > 1; -- 결과 없음

select rownum, emp_id, emp_name, lev from temp order by emp_name;
select rownum, emp_id, emp_name from temp where lev = '과장' and rownum < 10 order by emp_name;

/*
rowid
rowid는 db내 특정 row에 대한 유일한 식별자(db, 테이블, 객체 등에 대한 정보 포함)
*/
select rowid, rownum, emp_id, emp_name from temp;

/*
decode
일반 프로그래밍 언어의 if문 역할을 해준다(select의 from 외의 모든 절에서 사용 가능)

decod(a, b, 'T', 'F')는 아래와 같은 의미
if(a == b)
    return 'T';
else
    return 'F';
    
decode(a, b, 'T', c, 'F', 'X')는 아래와 같은 의미
if(a == b)
    return 'T';
else if (a == c)
    return 'F'
else
    return 'X'

else if부분은 같은 패턴으로 계속 사용 가능 decode(a, b, 'B', c, 'C', d, 'D' ...)

+
중첩 if문은 decode를 중첩시켜서 사용 가능
대소비교는 sign(a-b)를 중첩시켜서 사용 가능(매우 자주 쓰이는 패턴)

*/

/*
1.행번호, 사번, 성명 가져오기 
2.1번 중 상위 5건만 가져오기
3.취미가 없는 자료의 행번호, 사번, 성명을 EMP ID 순으로 SORT해 상위 3건만 읽기 
4.EMP ID,LEV, lev에 따라 수습0, 사원1, 대리2, 과장3, 차장4, 부장5, 나머지6)으로 나오는 컬럼 
5.EMP ID, 취미가 NULL이면 0 아니면 1 로 나오는 컫럼 
6.EMP ID, 4천만원과 SALARY퓸 비교해서 4천만원 이하면 ‘적게' 아니면 ‘많이' 로 나오는 컬럼
7.NULL 이 아닌 자료만 EMP ID, HOBBY, HOBBY 가 독서나 바둑이면 ‘우와!' 아니면 ‘왜?' 리턴 
8.현재일자에서 1년에 12개웜씩 40년을 뻔 값보다 BIRTH DATE가 타른 사람 중 EMP ID, DEPT CODE, HOBBY, 
  취미가 없으면서 부서코드 첫자리가 ‘C' 이면 ‘섭외대상' 나머지는 ‘그냥놔둬' ) 컬럼
*/
--1.
select rownum, emp_id, emp_name from temp;
--2.
select rownum, emp_id, emp_name from temp where rownum <= 5;
--3.
select rownum, temp.* from temp where hobby is null order by emp_id;
select * from (select rownum as rn, emp_id, emp_name from temp where hobby is null order by emp_id) where rownum < 4; -- inline view

--explain을 하면 cost관련 정보들 볼 수 있음(SCAN방법 등도 나온다)
--SCAN방법에 따라 rownum이 달라지기 때문에 rownum은 절대적인 기준이 아니기도 하다
explain plan for
select * from temp where hobby is null and rownum < 4 order by emp_id;
select * from table(dbms_xplan.display); -- FULL SCAN (환경따라 다름)
explain plan for
select * from temp where emp_id > 0 and hobby is null and rownum < 4;
select * from table(dbms_xplan.display); -- FULL SCAN (환경따라 다름)

alter session set optimizer_mode = 'RULE'; -- 강제 INDEX SCAN (cost비교X)
select * from temp where emp_id > 0 and hobby is null and rownum < 4; -- 원하는 결과로 나옴

--4.
select emp_id, lev, decode(lev, '수습', 0, '사원', 1, '대리', 2, '과장', 3, '차장', 4, '부장', 5, 6) as levcd from temp;
--5.
select emp_id, decode(hobby, null, 0, 1) as hobbyisnull from temp;
--6.
select emp_id, decode(sign(salary - 40000000), -1, '적게', '많이') from temp;
--7.
select emp_id, hobby, decode(hobby, '독서', '우와', '바둑', '우와', '왜') from temp where hobby is not null;
--8.
select emp_id, dept_code, hobby, decode(substr(dept_code, 1, 1), 'C', '섭외대상', '그냥놔둬')
from temp 
where add_months(sysdate, -12 * 40) > birth_date;