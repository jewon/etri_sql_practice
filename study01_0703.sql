/*
    0704 다중 행(그룹) 함수
*/
-- 그룹함수 사용의 예(수, 날짜)
select salary from employee where deptno = 30;
select avg(salary), sum(salary), max(salary), min(salary) from employee where deptno = 30;
select max(hire_date), min(hire_date) from employee; -- max, min은 null값을 무시한다

-- 그룹함수 사용 예(카운트)
select count(comm) from employee where deptno = 20; -- null있으면 안센다
select count(*) from employee where deptno = 20; -- 특정 컬럼 null여부 상관없이 센다

-- 그룹함수에 null적용
select avg(comm) from employee; -- null을 포함하지 않고 avg
select avg(nvl(comm, 0)) from employee; -- null을 0으로 하여 avg

-- Group By절의 사용: select절에 제시된 컬럼명은 꼭 group by절에 있어야 함
select job, avg(salary) from employee group by job;
select deptno, job, avg(salary) from employee group by deptno, job order by deptno, job;

-- where과 having의 차이
select job, avg(salary) from employee where avg(salary) > 4000 group by job; -- err: where는 select시의 제약이기 때문에 그룹함수 샤용 불가
select job, avg(salary) from employee group by job having avg(salary) > 4000; -- having은 group by의 결과에서 선택적으로 표출
select count(comm) from employee having deptno = 20; -- err: having은 group by 표현식에서만 사용한다(where의 대체 불가)

-- having절 적용 예
select job, min(salary) from employee group by job having min(salary) > 2000;
select job, min(salary) from employee where job not like '%MAN%' group by job having min(salary) > 2000 order by min(salary); -- order by에는 select절의 컬럼만 사용가능

-- 그룹함수의 중첩
select job, avg(salary) from employee group by job; -- job별 salary 평균
select job, min(avg(salary)) from employee group by job; -- err: 그룹함수의 중첨은 1회만 가능하다. (job별 평균의 최솟값은 전체에서 1개만 존재함)
select min(aa) from (select job, avg(salary) as aa from employee group by job); -- 부서별 평균의 최솟값을 구하는 올바른 코드

/*
    실습
    1. 
    2. 1번의 결과 중 sal평균이 5천만 이상인 것 조회
    3. 생념별 인원, sal평균, sal총합/인원수 결과 관찰해 두 컬럼의 결과값 같은지 비교
    4. 생년, 취미별 group by 적용해
    5. hobby별 평균 salary
    6. 5번 평균 salary의 평균 값
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
-- salary가 null인 것은 평균구하는 과정에서 생략시키면 같다, (*)로 카운팅 한 수를 총합에서 나눌 경우 다르다.
select to_char(birth_date, 'YYYY') as birt_year, count(*), avg(salary), sum(salary) / count(salary)
    from temp
    group by to_char(birth_date, 'YYYY'); -- 똑같음
select to_char(birth_date, 'YYYY') as birt_year, count(*), avg(salary), sum(salary) / count(salary)
    from temp
    group by to_char(birth_date, 'YYYY'); -- 다름
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
-- hobby별 최소평균 salary는 구했으나 무슨 hobby가 최소평균sal을 갖는지는 알수없는 문제

select *
from (select hobby, avg(salary) as avgsal
        from temp
        group by hobby
        order by avgsal)
    where rownum = 1;
-- inline view를 통한 해결법

select hobby, avg(salary)
    from temp 
    group by hobby 
    having avg(salary) = (select min(avg(salary)) from temp group by hobby);
-- 다중쿼리를 통한 해결법


/*
    과제
    1. 생년별 최고 SALARY, MAX(EMP_ID) 를 읽어 오기 
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
    ) t1; --id는 max(emp_id)의 salary: msal과 다름
    
-- 생년별 최고 연봉 받는 사원 구하기 
-- 다중쿼리를 이용한 방법도 있지만 아래의 방법이 더 빠르게 수행된다.
-- number타입으로 합치기
select * from temp;
select to_char(birth_date, 'yyyy') yyyy, salary + to_char(salary + emp_id / power(10, 8) ) from temp; -- 연봉과 사번정보 한 컬럼에 합침
select yyyy, trunc(msal) sal, (msal - trunc(msal)) * power(10, 8) emp_id -- 합친 컬럼 이용해서 구하기
    from (
        select to_char(birth_date, 'yyyy') yyyy, 
            max(salary + emp_id / power(10, 8) ) msal
        from temp
        group by to_char(birth_date, 'yyyy')
    );
    
select to_char(birth_date, 'yyyy') yyyy, salary, emp_id;

-- char타입으로 합치기 > 비교대상 숫자을 자릿수 맞춰 앞쪽에 두면 대소비교가 가능함
select to_char(birth_date, 'yyyy') yyyy,
    lpad(to_char(salary), 10, '!') || to_char(emp_id) msal
from temp
order by msal;

/*
    2. 생년별 최고 SALARY ID, 최고금액, 최저SALARY ID, 최저금액 가져오기
*/
--number타입 컬럼병합
select yyyy, trunc(maxsal) max_sal, (maxsal - trunc(maxsal)) * power(10, 8) max_sal_id, -- max
             trunc(minsal) min_sal, (minsal - trunc(minsal)) * power(10, 8) min_sal_id -- min
    from (
        select to_char(birth_date, 'yyyy') yyyy, 
            max(salary + emp_id / power(10, 8) ) maxsal,
            min(salary + emp_id / power(10, 8) ) minsal
        from temp
        group by to_char(birth_date, 'yyyy')
    );
    
--char타입 컬럼병합
select 생년,
        to_number(substr(fst,14)) xid,
        to_number(ltrim(substr(fst,1,12), '!')) xsal
from(
    select to_char(birth_date,'yyyy') 생년,
            max(lpad(to_char(salary),12,'!')||'*'|| to_char(emp_id)) fst,
            min(lpad(to_char(salary),12,'!')||'*'|| to_char(emp_id)) lst
    from temp
    group by to_char(birth_Date,'yyyy')
);

-- 한 생년에 여러 사람이 최고연봉을 가질때의 문제 해결: 다중쿼리 이용
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
    새로운 실습 자료 +_+
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
    3. SALEHIST 자료를 이용해 집계 테이블에 데이터를 INSERT 하고자 합니다 
       세 가지 CASE에 대해 SQL 을 작성합니다.
       INSERT 문은 필요없고 SELECT만 작성
*/
select * from sale_hist;

--sale1
select sale_date, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by sale_date order by sale_date;
--sale2
select sale_site, sale_item, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by sale_site, sale_item order by 1, 2;
--sale3
select substr(sale_date, 5, 2) as sale_mon, sale_item, sum(sale_amt) as sale_amt, count(*) as sale_cnt from sale_hist group by substr(sale_date, 5, 2), sale_item order by sale_mon;

/*
    새로운 실습 테이블 +_+
    
    년월, 제품, 항목, 금액으로 구성된 {년월, 제품별로 항목(62099011: 매출수량, 62099101: 총원가)}에 대한 금액을 관리하고 있는 테이블
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
    제품별로 1998년 3월보다 작은 월의 12개월치 DATA를 이용해서 1998년 3월의 매출수량별 총원가를 구하기 위한 제품별 단위당변동원가와 고정원가를 구하라
    단위당변동원가 = (최고판매량의 원가 - 최저판매량의 원가) / (최고판매량 - 최저판매량)
    고정원가 = 최고판매량원가 - (단위당변동원가 * 최고판매량)
    최고판매량의 원가는 12개월 중 해당제품의 판매량이 최고인 월의 총원가를 의미한다.
*/

select * from test17;
select yymm_ym, item_cd, prod_amt as qty from test17 where budget_cd = 62099011; -- 수량
select yymm_ym, item_cd, prod_amt as amt from test17 where budget_cd = 62099101; -- 총원가
select yymm_ym, item_cd, prod_amt as qty, prod_amt as amt from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'; -- 한꺼번에 표출하는 틀 작성
select yymm_ym, item_cd, decode(budget_cd, '62099011', prod_amt), decode(budget_cd, '62099101', prod_amt) 
    from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'; -- 컬럼 분리
select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
    from test17 
    where yymm_ym >= '199703' and yymm_ym < '199803'
    group by yymm_ym, item_cd; -- 분리된 컬럼 바탕으로 group by 가능
select item_cd, 
    min(qty) as qty_min,(min(qty + amt/power(10, 15)) - min(qty)) * power(10, 15) as qty_min_amt, -- amt와 qty컬럼을 합쳐서 min, max구해서 다시 분리
    max(qty) as qty_max,(max(qty + amt/power(10, 15)) - max(qty)) * power(10, 15) as qty_max_amt
    from (
        select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
        from test17 
        where yymm_ym >= '199703' and yymm_ym < '199803'
        group by yymm_ym, item_cd -- 분리된 컬럼 바탕으로 group by 가능
    )
    group by item_cd;

-- 위 테이블 바탕으로 구하려는 값 만들기
select item_cd, 
        decode(qty_max - qty_min, 0, null,(qty_max_amt - qty_min_amt) / (qty_max - qty_min)) as 단위당변동원가,
        qty_max_amt - (decode(qty_max - qty_min, 0, null,(qty_max_amt - qty_min_amt) / (qty_max - qty_min)) * qty_max) as 고정원가
    from (
        select item_cd, 
            min(qty) as qty_min,(min(qty + amt/power(10, 15)) - min(qty)) * power(10, 15) as qty_min_amt, -- amt와 qty컬럼을 합쳐서 min, max구해서 다시 분리
            max(qty) as qty_max,(max(qty + amt/power(10, 15)) - max(qty)) * power(10, 15) as qty_max_amt
            from (
                select yymm_ym, item_cd, sum(decode(budget_cd, '62099011', prod_amt)) as qty, sum(decode(budget_cd, '62099101', prod_amt)) as amt 
                from test17 
                where yymm_ym >= '199703' and yymm_ym < '199803'
                group by yymm_ym, item_cd -- 분리된 컬럼 바탕으로 group by 가능
            )
            group by item_cd
    );
commit;