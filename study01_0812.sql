/*
    0812
*/

/*
    �Է¹��� ������ �̿��� TEMP2�� �о� WORK_YEAR = '2019'���� �Ͽ� TCOM1�� �ش� ����� 
    INSERT (COMM�� ������ 10%) �ϰ� , EMP_LEVEL1���� INSERT�մϴ�
    (���ʴ� FROM, TO ���� �� ���� UPDATE�� ����Ȯ���ؼ� ������ �����ʴ� ��츸 ����Ȯ��),
    ���������� TEVAL�� YM_EV='201901',EMP_ID,EV_CD
    (TCODE���� MAIN_CD = 'A002'�� 4��, EV_EMP�� �ڽ��� ������ �Է�)
    TEVAL �Է´ܰ迡�� BOSS�� ã�� ���� TDEPT2�� �����Ҷ� ��Ī�ڵ尡 ����
    �μ��� ã�� ���� �����ϴ� ���� TCOM2�� EMP_LEVEL2 ������ �۾��� COMMIT �ؾ��մϴ�
    SAVEPOINT�� ����ϴ� �ش� PROCEDURE�� �����ϼ��� => �ѱ۷� �����帧 ���� ����
    ���1 
    - TEMP1�� �о� TCOM1�� INSERT
    -�������� ���
    ���2 
    - EMP_LEVEL1 UPDATE
    -����� ���� �ű��Է°��� UPDATE�� Ŀ�� �Ӽ� Ȯ���� ���� ���� ���
    -Ŀ�� �Ӽ��� NOTFOUND�� ���� INSERT ����
    ���3
    -BOSS ã��
    -INSERT ���� ���п��� ���
    -�μ� ������ ��� ������ ���� ���2������ �������� ���� ������ ���� ���3���� ����
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
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (101,'A001','A','A���','90�� �̻�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (102,'A001','B','B���','80�� �̻�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (103,'A001','C','C���','70�� �̻�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (104,'A001','D','D���','60�� �̻�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (105,'A001','F','F���','60�� �̻�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (111,'A002','0001','����','���������� ���ϴ� �׸�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (112,'A002','0002','�ڱ���','�������� �ڱ��� ������ ���ϴ� �׸�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (113,'A002','0003','����','���ῡ�� ����� ������ ���ϴ� �׸�');
Insert into TCODE (KNO,MCD,DCD,DNM,DRM) values (114,'A002','0003','�µ�','����, ������� �� ������ �����ϴ� �������� �µ��� ���ϴ� �׸�');
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
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
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
 --A.EMP_ID = C.BOSS_ID �� ��
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
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
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
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
 --A.EMP_ID = C.BOSS_ID �� ��
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
  ROLLBACK TO P1;
 END IF;
--
 COMMIT;
END;
/

--
select * from tcom1;
begin
    change_by_emp('������');
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
      DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
     ELSE
      DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
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
      DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
      INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
     ELSE
      DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
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
     --A.EMP_ID = C.BOSS_ID �� ��
     AND C.PARENT_DEPT = D.DEPT_CODE;
    --
     IF SQL%FOUND
     THEN
      DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
     ELSE 
      DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
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
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 ELSE
  DBMS_OUTPUT.PUT_LINE('TCOM1 ������ ���� ����');
 END IF;
--2
 UPDATE EMP_LEVEL1
 SET FROM_SAL = LEAST(FROM_SAL, PSAL), TO_SAL = GREATEST(PSAL, TO_SAL)
 WHERE LEV = PLEV;
--
 IF SQL%NOTFOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
  INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL) VALUES (PLEV, PSAL, PSAL);
 ELSE
  DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 ������ ���� ����');
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
 --A.EMP_ID = C.BOSS_ID �� ��
 AND C.PARENT_DEPT = D.DEPT_CODE;
--
 IF SQL%FOUND
 THEN
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('TEVAL ������ ���� ����');
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
    --���ʽ�
--1. �λ������� ������ ���� ��û�� �߽��ϴ�.
--  3������ �ؿ� ����Ȱ���� ���� ���� 1���� �İ��ؾ� �մϴ�.
--  �������� ���Ǹ� ��� ������ ���� �������� �����ϱ�� �߽��ϴ�.
--  ���̰� �����, ������ ��������, ������ ��������(����,����,����,�븮,�����) �����ϸ�
--  ������ ���� ������� �����մϴ�.
--  ��� ���ǿ� ����ġ�� ��� ���� ����, ����, ���� ���׸� ������ �Ű� ���� ���� ���� ����
--  5���� �����ϱ�� ������, �� 5���� ������� ���� �̱�� �� ���� ���� �� �����Դϴ�.
-- VALUE�� ���� �����̸� ���� ��� �θ��� ���� ���� 1���� ���� ������ 3���Դϴ�.
-- �ش� ���α׷� �ۼ��� ������ ���, ����, �� ����, ����, �޿�, ����, ���߼����� ����ϼ���
--  1���� 5���� ������ ������ ���� �Լ��� �̿�: DBMS_RANDOM.
*/
select * from temp;

select * from (
    select emp_id, emp_name, points, rank () over (order by points) r_p
    from (
        select emp_id, emp_name,
               rank() over (order by sysdate - birth_date) r_y, 
               rank() over (order by salary) r_s, 
               decode(lev, '����', 1, '����', 2, '����', 3, '�븮', 4, '���', 5, 100) r_l,
               rank() over (order by sysdate - birth_date) +
               rank() over (order by salary) +
               decode(lev, '����', 1, '����', 2, '����', 3, '�븮', 4, '���', 5, 100) points
        from temp)
    where rownum <= 5
    order by dbms_random.value())
where rownum = 1;


select ceil(dbms_random.value(0, 5)) from dual;

