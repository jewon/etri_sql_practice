 CREATE TABLE SPEC
(
	SPEC_CODE             VARCHAR2(20)  NOT NULL ,
	SPEC_NAME             VARCHAR2(20)  NULL ,
CONSTRAINT  XPKSPEC PRIMARY KEY (SPEC_CODE)
);

CREATE TABLE LINE
(
	LINE_NO               VARCHAR2(20)  NOT NULL ,
	LINE_NAME             VARCHAR2(20)  NULL ,
CONSTRAINT  XPKLINE PRIMARY KEY (LINE_NO)
);

CREATE TABLE INPUT_PLAN
(
	PLAN_SEQ              NUMBER  NOT NULL ,
	INPUT_PLAN_DATE       VARCHAR2(8)  NOT NULL ,
	LINE_NO               VARCHAR2(20)  NOT NULL ,
	SPEC_CODE             VARCHAR2(20)  NULL ,
CONSTRAINT  XPKINPUT_PLAN PRIMARY KEY (PLAN_SEQ,INPUT_PLAN_DATE,LINE_NO),
CONSTRAINT  R_4 FOREIGN KEY (SPEC_CODE) REFERENCES SPEC(SPEC_CODE) ON DELETE SET NULL,
CONSTRAINT  R_5 FOREIGN KEY (LINE_NO) REFERENCES LINE(LINE_NO)
);

CREATE TABLE ITEM
(
	ITEM_CODE             VARCHAR2(20)  NOT NULL ,
	ITEM_NAME             VARCHAR2(20)  NULL ,
CONSTRAINT  XPKITEM PRIMARY KEY (ITEM_CODE)
);



CREATE TABLE BOM
(
	LINE_NO               VARCHAR2(20)  NOT NULL ,
	SPEC_CODE             VARCHAR2(20)  NOT NULL ,
	ITEM_CODE             VARCHAR2(20)  NOT NULL ,
	ITEM_QTY              NUMBER  NULL ,
CONSTRAINT  XPKBOM PRIMARY KEY (LINE_NO,SPEC_CODE,ITEM_CODE),
CONSTRAINT  R_1 FOREIGN KEY (ITEM_CODE) REFERENCES ITEM(ITEM_CODE),
CONSTRAINT  R_2 FOREIGN KEY (LINE_NO) REFERENCES LINE(LINE_NO),
CONSTRAINT  R_3 FOREIGN KEY (SPEC_CODE) REFERENCES SPEC(SPEC_CODE)
);

insert into line (line_no, line_name) values ('L01', '1번 제조 라인');
insert into line (line_no, line_name) values ('L02', '2번 제조 라인');
insert into line (line_no, line_name) values ('L03', '3번 제조 라인');

insert into spec (spec_code, spec_name) values ('S01', '소방차');
insert into spec (spec_code, spec_name) values ('S02', '경찰차');
insert into spec (spec_code, spec_name) values ('S03', '구급차');
insert into spec (spec_code, spec_name) values ('S04', '스포츠카');
insert into spec (spec_code, spec_name) values ('S05', '장갑차');

insert into item (item_code, item_name) values ('I01', '소방차 바디');
insert into item (item_code, item_name) values ('I02', '경찰차 바디');
insert into item (item_code, item_name) values ('I03', '구급차 바디');
insert into item (item_code, item_name) values ('I04', '스포츠카 바디');
insert into item (item_code, item_name) values ('I05', '장갑차 바닥');
insert into item (item_code, item_name) values ('I06', '소형차 바퀴');
insert into item (item_code, item_name) values ('I07', '중형차 바퀴');
insert into item (item_code, item_name) values ('I08', '장갑차 바퀴');
insert into item (item_code, item_name) values ('I09', '소방차 문짝');
insert into item (item_code, item_name) values ('I10', '경찰차 문짝');
insert into item (item_code, item_name) values ('I11', '구급차 문짝');
insert into item (item_code, item_name) values ('I12', '스포츠카 문짝');
insert into item (item_code, item_name) values ('I13', '장갑차 문짝');
insert into item (item_code, item_name) values ('I14', '경광등');
insert into item (item_code, item_name) values ('I15', '소방차 스티커');
insert into item (item_code, item_name) values ('I16', '경찰차 스티커');
insert into item (item_code, item_name) values ('I17', '구급차 스티커');
insert into item (item_code, item_name) values ('I18', '장갑차 스티커');
insert into item (item_code, item_name) values ('I19', '스포츠카 스티커');
