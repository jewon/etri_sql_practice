/*
    0711 
*/
commit;

-- Rollback
delete from emp_copy;
rollback;

-- Rollback and Savepoint
update emp_copy set department_id = 60
where employee_id = 101;
savepoint A;
delete from emp_copy;
rollback to A; -- savepoint A로 롤백

/*
문장단위의 롤백
- oracle서버는 암시적으로 문장단위 savepoint를 실행하므로 문제 발생시 해당 지점으로 롤백해 그 이전 작업은 유지됨
- 따라서, 문장단위 롤백 이후 사용자는 반드시 명시적으로 commit 또는 rollback을 해줘야
*/

-- 사용자 관리
-- 사용자 생성(create user [id] identified by [pw])
create user user01 identified by pass;
-- 사용자 pw변경
alter user user01 identified by pass01;
-- 권한 부여
grant create session to user01; -- 시스템 권한
grant select on departments to user01, scott; -- 사용자 권한
grant update (location_id) on departments to user01; -- 컬럼별 권한 지정 가능
grant select on departments to user01 with grant option; -- 지정받은 사용자가 해당 권한을 다른 사용자에게 재부여 가능
grant update on study01.departments to public; -- 모든 사용자에게 권한 부여
-- 권한 해제
revoke select, update on departments from user01;
-- 롤: 권한 집합
create role man_role; -- 롤 생성
grant create table, create view to man_role; -- 롤에 권한 지정
grant man_role to user01; -- 사용자에 롤 부여
-- 부여된 권한 확인
select * from role_sys_privs; -- role에 부여된 시스템 권한
select * from role_tab_privs; -- role에 부여된 테이블 권한
select * from user_role_privs; -- 현재 유저가 부여받은 롤
select * from user_tab_privs_made; -- 현재 유저가 부여한 객체 권한
select * from user_tab_privs_recd; -- 현재 유저가 부여받은 객체 권한
select * from user_col_privs_made; -- 현재 유저가 부여한 컬럼 권한
select * from user_col_privs_recd; -- 현재 유저가 부여받은 컬럼 권한

/*
    1. 변경자에 의해 수정될 때 row lock이 발생
    2. row의 변경을 통한 lock의 획득은 동일한 row를 동시에 변경하려는 자의 변경을 제한
    3. select를 통해 단순히 읽기만을 하는 트랜잭션은 쓰기 트랜잭션을 제한하지 못합니다.
    4. 쓰기 트랜잭션은 lock을 걸더라도 다른 트랜잭션의 읽기를 제한하지 못합니다.
*/
-- lock 알아보기
-- pre: 접속 세션 추가해 하나의 사용자로 여러 세션 접속한 상태 만들기
update temp set hobby = '활쏘기' where emp_name = '이순신'; -- update
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- lock이 한 개 존재
rollback;
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- 롤백 후 lock 없어짐
update temp set hobby = '활쏘기' where emp_name = '이순신'; -- update
-- 다른 세션
select * from temp where emp_name = '이순신'; -- 변화 없음(lock상태)
-- 원래 세션
rollback;
update temp set hobby = '활쏘기' where emp_name = '이순신'; -- update
-- 다른 세션
update temp set lev = '장군' where emp_name = '이순신'; -- 실행 안되고 대기상태 유지
-- 원래 세션
commit; -- 락이 풀리면서 다른 세션의 update문도 같이 수행됨
update temp set lev = '장군' where emp_name = '이순신';
-- 다른 세션
commit;
-- 원래 세션
select * from temp where emp_name = '이순신'; -- hobby는 '활쏘기', lev는 '장군'으로

-- select와 update 사이에 다른 세션에서 데이터 변경시 잠재적 문제 발생 가능
select * from temp where emp_name = '이순신' for update nowait; -- select단계에서 lock을 걸기
select a.session_id, a.oracle_username, a.process, a.locked_mode, c.lock_type, c.mode_held, c.mode_requested, c.blocking_others
from v$locked_object a, dba_locks c
where a.session_id = userenv('SID')
and c.session_id = a.session_id
and c.lock_id1 = a.object_id; -- lock 존재 확인
rollback;
-- 원래세션
update temp set lev = '장군' where emp_name = '이순신';
-- 다른세션
select * from temp where emp_name = '이순신' for update nowait; -- err: lock때문에 nowait불가능
rollback;

-- deadlock 상황 만들기
-- 원래세션
update temp set hobby = '말타기' where emp_name = '이순신'; -- update
-- 다른세션
update temp set hobby = '말타기' where emp_name = '홍길동'; -- update
-- 원래세션
update temp set hobby = '제기차기' where emp_name = '홍길동'; -- waiting
-- 다른세션
update temp set hobby = '제기차기' where emp_name = '이순신'; -- waiting
-- 원래세션
-- ORA-00060: 자원 대기중 교착 상태가 검출되었습니다 (데드락 방지)
-- 다른세션
-- 계속 waiting

/*
   과제1. UPDATE DML로 TRANSACTION을 시작하고
   TRANSATION을 종료할 수 있는 방법을 모두 기술하고
   각 방법에 대해 트랜잭션 종료 상황을 구현하고 확인문장 작성.
   
*/
--하나의 dml
update temp set lev = '장군' where emp_name = '이순신';
--commit;
commit;
--rollback
rollback;
-- DDL = commit
create table test(
    test_id number
);
-- DCL = commit
grant create session to user01;
-- 접속 해제 = commit
update temp set lev = '임시' where emp_name = '이순신';
connect scott / tiger;
connect study01/study01;
select * from temp where emp_name = '이순신';
-- 접속 즉시 종료 = commit
update temp set lev = '말타기' where emp_name = '이순신';
exit;
-- sqlplus 강제종료(창닫기) = rollback과 같음, 락풀림
update temp set lev = 'ttt' where emp_name = '이순신';
rollback;

/*
    2. SAVEPOINT
   2.1 STUDY01에서 TI_DATA의 MAX(NO) 확인 
   2.2 확인된 NO보다 1  작은 값을 조건으로 T1_DATA에서 DELETE 수행    
   2.3 삭제 여부 확인 후 SAVEPOINT T1_1 수행
   2.4 1.1에서 확인한 NO 값으로 DELETE 수행
   2.5 삭제여부 확인
   2.6 T1_1 SAVEPOINT로 ROLLABCK 수행 
   2.7 T1_1 SAVEPOINT 실행 이전 데이터는 아직 삭제 상태고 이후 데이터는 ROLLABACK으로 복구확인
   2.8 ROLLBACK 수행으로 원상 복구
*/
select max(no) from t1_data; -- 2.1, 10000
delete t1_data where no = (select max(no) from t1_data) - 1; -- 2.2
savepoint t1_1; --2.3
delete t1_data where no = (select max(no) from t1_data); -- 2.4
select no from t1_data where no = 9999; -- null, 2.5
rollback to t1_1; -- 2.6
select no from t1_data where no > 9997; -- 2.7, 9998 9999
rollback; --2.8

/*
3.STUDY01로 로그인해 STUDY03 유저 생성 ? PASSWORD는 ‘PASS01’
4. STUDY03의 PASSWORD를 USER명과 동일하게 변경
5. STUDY03에게 세션생성, 테이블생성, 뷰생성 권한을 부여
5-1 STUDY03에 CONNECT 후 간단한 테이블과 뷰 생성 확인
6. STUDY03에게 T1_DATA INSERT, UPDATE 권한 부여
7. STUDY03에게 T2_DATA SELECT, UPDATE 권한 부여 (WITH GRANT OPTION 으로);
8. STUDY03에서 STUDY02에게 T1_DATA 와 T2_DATA의 UPDATE 권한 부여 
9. PUBLIC에 TEMP SELECT 권한 부여
*/
create user study03 identified by pass01; --3
alter user study03 identified by study03; --4
grant create session, create table, create view to study03; --5
connect study03/study03;
create table test_study03(test_id number); --5-1
create view test_view as select * from test_study03;
connect study01/study01;
grant insert, update on t1_data to study03; --6
grant select, update on t2_data to study03 with grant option; --6
connect study03/study03;
grant update on t1_data to study02; --8 ORA-01031: 권한이 불충분합니다
grant update on t2_data to study02; --8
grant select on temp to public; --9
connect study03/study03;
select * from study01.temp; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

/*
    추가문제
study01은 인사시스템 user이며, study03은 재무 시스템 user입니다.
재무 시스템에서 인사 시스템에 직원정보, 부서정보에 대한 조회 권한과 직원정보에 대한 입력권한을 요청합니다.
하지만 향 후 다른 시스템에서 발생할 수 있는 비슷한 유형의 요청에 대응하기 위해,
인사시스템 관리자는 인사정보들을 이용할 수 있는 권한을 테이블 별로
1. 단순 읽기 권한, 2. 변경권한, 3. 입력권한, 4. 삭제권한으로 나누어 관리하고자 합니다.
이후 시스템별 요청에 따라 적절한 권한을 4가지 권한의 조합으로 부여하고자 합니다.
(권한 관리는 테이블 레벨에서만 합니다.)
단, 인사정보에서 부여된 권한을 임으로 부여 받은 시스템이 다른 시스템에 재부여할 수 없게 할 예정이며,
정의된 role권한을 통하지 않은 유저에 직접적은 grant는 허용하지 않을 예정입니다.
이에 대한 대응 방안을 수립한 후 재무 시스템에 선 적용하고자 합니다.
따라서 인사정보에서 현재 권한이 부여된 상태를 조회할 수 있어야 합니다.
또한 관련된 권한 부여 정책을 별도의 테이블에 데이터로 관리하여 현재 부여상태와 수시로 비교하고자 합니다.
관련된 내용의 테이블을 설계해 구현하고, 권한 정책을 입력하며,
관련된 권한 정책이 실제 적용되고 있는지 확인하는 쿼리를 작성하시오.
*/
