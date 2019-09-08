/*
    0812
*/

/*
    입력받은 성명을 이용해 TEMP2를 읽어 WORK_YEAR = '2019'으로 하여 TCOM1에 해당 사번을 
    INSERT (COMM은 무조건 10%) 하고 , EMP_LEVEL1에도 INSERT합니다
    (최초는 FROM, TO 동일 값 이후 UPDATE는 범위확인해서 범위에 들지않는 경우만 범위확장),
    마지막으로 TEVAL에 YM_EV='201901',EMP_ID,EV_CD
    (TCODE에서 MAIN_CD = 'A002'인 4건, EV_EMP는 자신의 보스를 입력)
    TEVAL 입력단계에서 BOSS를 찾기 위해 TDEPT2에 접근할때 매칭코드가 없어
    부서를 찾지 못해 실패하는 경우라도 TCOM2와 EMP_LEVEL2 까지의 작업은 COMMIT 해야합니다
    SAVEPOINT를 사용하는 해당 PROCEDURE를 생성하세요 => 한글로 로직흐름 먼저 정의
    기능1 
    - TEMP1을 읽어 TCOM1에 INSERT
    -성공여부 출력
    기능2 
    - EMP_LEVEL1 UPDATE
    -대상이 없는 신규입력건은 UPDATE후 커서 속성 확인후 성공 여부 출력
    -커서 속성이 NOTFOUND인 경우는 INSERT 수행
    기능3
    -BOSS 찾기
    -INSERT 성공 실패여부 출력
    -부서 정보가 없어서 실패하 경우는 기능2까지의 수행결과만 저장 성공한 경우는 기능3까지 저장
*/
-- temp2
create table temp2 as select * from temp1;
-- tcode
 CREATE TABLE "TCODE" 
   (   "KNO" NUMBER, 
   "MCD" VARCHAR2(4), 
   "DCD" VARCHAR2(4), 
   "DNM" VARCHAR2(100), 
   "DRM" VARCHAR2(400)
   );
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (101,'A001','A','A등급','90점 이상');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (102,'A001','B','B등급','80점 이상');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (103,'A001','C','C등급','70점 이상');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (104,'A001','D','D등급','60점 이상');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (105,'A001','F','F등급','60점 이상');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (111,'A002','0001','업적','업무업적을 평가하는 항목');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (112,'A002','0002','자기계발','직무관련 자기계발 실적을 평가하는 항목');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (113,'A002','0003','협업','동료에게 도움된 정도를 평가하는 항목');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (114,'A002','0003','태도','근태, 약속이행 등 업무를 수행하는 전반적인 태도를 평가하는 항목');
-- tdeptd2
create table tdept2 as select * from tdept;
delete tdept2 where dept_code = 'AA0001';
-- tcom1
create table tcom1 as select * from tcom where rownum < 1;
-- emp_level1
create table emp_level1 as select * from emp_level where rownum < 1;
--PROCEDURE
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP (PNAME TEMP2.EMP_NAME%TYPE)
IS
 PSAL TEMP2.SALARY%TYPE;
 PLEV TEMP2.LEV%TYPE;
BEGIN
 SELECT SALARY, LEV
 INTO PSAL, PLEV
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--1
 INSERT INTO TCOM1 (WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
 SELECT '2019', EMP_ID, 1, SALARY*0.1 
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 성공');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 실패');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 실패');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 성공');
 END IF;
--SAVEPOINT
 SAVEPOINT P1;
--3
 INSERT INTO TEVAL (YM_EV, EMP_ID, EV_CD, EV_EMP)
 SELECT '201902', A.EMP_ID, B.KNO, 
        DECODE(A.EMP_ID, C.BOSS_ID, D.BOSS_ID, C.BOSS_ID)
 FROM TEMP2 A, TCODE B, TDEPT2 C, TDEPT2 D
 WHERE A.EMP_NAME = PNAME
 AND B.MCD = 'A002'
 AND A.DEPT_CODE = C.DEPT_CODE
 --A.EMP_ID = C.BOSS_ID 일 때
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 성공');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 실패');
  ROLLBACK TO P1;
 END IF;
--
 COMMIT;
END;
/--PROCEDURE
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP (PNAME TEMP2.EMP_NAME%TYPE)
IS
 PSAL TEMP2.SALARY%TYPE;
 PLEV TEMP2.LEV%TYPE;
BEGIN
 SELECT SALARY, LEV
 INTO PSAL, PLEV
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--1
 INSERT INTO TCOM1 (WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
 SELECT '2019', EMP_ID, 1, SALARY*0.1 
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 성공');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 실패');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 실패');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 성공');
 END IF;
--SAVEPOINT
--SAVEPOINT P1;
--3
 INSERT INTO TEVAL (YM_EV, EMP_ID, EV_CD, EV_EMP)
 SELECT '201902', A.EMP_ID, B.KNO, 
        DECODE(A.EMP_ID, C.BOSS_ID, D.BOSS_ID, C.BOSS_ID)
 FROM TEMP2 A, TCODE B, TDEPT2 C, TDEPT2 D
 WHERE A.EMP_NAME = PNAME
 AND B.MCD = 'A002'
 AND A.DEPT_CODE = C.DEPT_CODE
 --A.EMP_ID = C.BOSS_ID 일 때
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 성공');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 실패');
  ROLLBACK TO P1;
 END IF;
--
 COMMIT;
END;
/

--
select * from tcom1;
begin
    change_by_emp('강감찬');
end;
/
select * from teval;

/*
    
*/
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP (PNAME TEMP2.EMP_NAME%TYPE)
IS
 g_PSAL TEMP2.SALARY%TYPE;
 g_PLEV TEMP2.LEV%TYPE;
BEGIN
 SELECT SALARY, LEV
 INTO g_PSAL, g_PLEV
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--1
 declare
    psal := g_psal;
    plev := g_plev;
 BEGIN
     INSERT INTO TCOM1 (WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
     SELECT '2019', EMP_ID, 1, SALARY*0.1 
     FROM TEMP2
     WHERE EMP_NAME = PNAME;
    --
     IF SQL%FOUND
     THEN
      DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 성공');
     ELSE
      DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 실패');
     END IF;
 END;
 declare
    psal := g_psal;
    plev := g_plev;
 BEGIN
--2
     UPDATE EMP_LEVEL1
     SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
     WHERE LEV = PLEV;
--
     IF SQL%NOTFOUND
     THEN
      DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 실패');
      INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
     ELSE
      DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 성공');
     END IF;
--SAVEPOINT
--SAVEPOINT P1;
--3
 END;
  declare
    psal := g_psal;
    plev := g_plev;
 BEGIN
     INSERT INTO TEVAL (YM_EV, EMP_ID, EV_CD, EV_EMP)
     SELECT '201902', A.EMP_ID, B.KNO, 
            DECODE(A.EMP_ID, C.BOSS_ID, D.BOSS_ID, C.BOSS_ID)
     FROM TEMP2 A, TCODE B, TDEPT2 C, TDEPT2 D
     WHERE A.EMP_NAME = PNAME
     AND B.MCD = 'A002'
     AND A.DEPT_CODE = C.DEPT_CODE
     --A.EMP_ID = C.BOSS_ID 일 때
     AND C.PARENT_DEPT = D.DEPT_CODE;
    --
     IF SQL%FOUND
     THEN
      DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 성공');
     ELSE 
      DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 실패');
      ROLLBACK TO P1;
     END IF;
    --
 END;
 COMMIT;
END;
/--PROCEDURE
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP (PNAME TEMP2.EMP_NAME%TYPE)
IS
 PSAL TEMP2.SALARY%TYPE;
 PLEV TEMP2.LEV%TYPE;
BEGIN
 SELECT SALARY, LEV
 INTO PSAL, PLEV
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--1
 INSERT INTO TCOM1 (WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
 SELECT '2019', EMP_ID, 1, SALARY*0.1 
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 성공');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 데이터 삽입 실패');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 실패');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 데이터 갱신 성공');
 END IF;
--SAVEPOINT
--SAVEPOINT P1;
--3
 INSERT INTO TEVAL (YM_EV, EMP_ID, EV_CD, EV_EMP)
 SELECT '201902', A.EMP_ID, B.KNO, 
        DECODE(A.EMP_ID, C.BOSS_ID, D.BOSS_ID, C.BOSS_ID)
 FROM TEMP2 A, TCODE B, TDEPT2 C, TDEPT2 D
 WHERE A.EMP_NAME = PNAME
 AND B.MCD = 'A002'
 AND A.DEPT_CODE = C.DEPT_CODE
 --A.EMP_ID = C.BOSS_ID 일 때
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 성공');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL 데이터 삽입 실패');
  ROLLBACK TO P1;
 END IF;
--
 COMMIT;
END;
/


/*
    2.
*/
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP (PNAME TEMP2.EMP_NAME%TYPE)
IS
 g_PSAL TEMP2.SALARY%TYPE;
 g_PLEV TEMP2.LEV%TYPE;
BEGIN
 SELECT SALARY, LEV
 INTO g_PSAL, g_PLEV
 FROM TEMP2
 WHERE EMP_NAME = PNAME;
END;

/
select emp_name, birth_date, sysdate - birth_date, to_char(sysdate, 'YYYY') - to_char(birth_date, 'YYYY') from temp;

/*
    bonus
    --보너스
--1. 인사팀에서 다음과 같은 요청을 했습니다.
--  3개월의 해외 봉사활동을 위해 직원 1명을 파견해야 합니다.
--  직원들의 동의를 얻어 다음과 같은 조건으로 선발하기로 했습니다.
--  나이가 어릭수록, 연봉이 적을수록, 직급이 높을수록(부장,차장,과장,대리,사원만) 적합하며
--  정규직 만을 대상으로 선발합니다.
--  어느 조건에 가중치를 등수 없어 나이, 연봉, 직급 각항목에 순위를 매겨 순위 합이 가장 낮은
--  5명을 선발하기로 했으며, 이 5명을 대상으로 랜덤 뽑기로 한 명을 선발 할 예정입니다.
-- VALUE는 동일 순위이며 예를 들어 두명이 동일 순위 1위는 다음 순위는 3위입니다.
-- 해당 프로그램 작성해 선발자 사번, 성명, 총 점수, 나이, 급여, 직급, 선발순위를 출력하세요
--  1에서 5까지 랜덤값 생성은 다음 함수를 이용: DBMS_RANDOM.
*/
select * from temp;

select * from (
    select emp_id, emp_name, points, rank () over (order by points) r_p
    from (
        select emp_id, emp_name,
               rank() over (order by sysdate - birth_date) r_y, 
               rank() over (order by salary) r_s, 
               decode(lev, '부장', 1, '차장', 2, '과장', 3, '대리', 4, '사원', 5, 100) r_l,
               rank() over (order by sysdate - birth_date) +
               rank() over (order by salary) +
               decode(lev, '부장', 1, '차장', 2, '과장', 3, '대리', 4, '사원', 5, 100) points
        from temp)
    where rownum <= 5
    order by dbms_random.value())
where rownum = 1;


select ceil(dbms_random.value(0, 5)) from dual;

