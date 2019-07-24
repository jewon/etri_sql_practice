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

insert into line (line_no, line_name) values ('L01', '1�� ���� ����');
insert into line (line_no, line_name) values ('L02', '2�� ���� ����');
insert into line (line_no, line_name) values ('L03', '3�� ���� ����');

insert into spec (spec_code, spec_name) values ('S01', '�ҹ���');
insert into spec (spec_code, spec_name) values ('S02', '������');
insert into spec (spec_code, spec_name) values ('S03', '������');
insert into spec (spec_code, spec_name) values ('S04', '������ī');
insert into spec (spec_code, spec_name) values ('S05', '�尩��');

insert into item (item_code, item_name) values ('I01', '�ҹ��� �ٵ�');
insert into item (item_code, item_name) values ('I02', '������ �ٵ�');
insert into item (item_code, item_name) values ('I03', '������ �ٵ�');
insert into item (item_code, item_name) values ('I04', '������ī �ٵ�');
insert into item (item_code, item_name) values ('I05', '�尩�� �ٴ�');
insert into item (item_code, item_name) values ('I06', '������ ����');
insert into item (item_code, item_name) values ('I07', '������ ����');
insert into item (item_code, item_name) values ('I08', '�尩�� ����');
insert into item (item_code, item_name) values ('I09', '�ҹ��� ��¦');
insert into item (item_code, item_name) values ('I10', '������ ��¦');
insert into item (item_code, item_name) values ('I11', '������ ��¦');
insert into item (item_code, item_name) values ('I12', '������ī ��¦');
insert into item (item_code, item_name) values ('I13', '�尩�� ��¦');
insert into item (item_code, item_name) values ('I14', '�汤��');
insert into item (item_code, item_name) values ('I15', '�ҹ��� ��ƼĿ');
insert into item (item_code, item_name) values ('I16', '������ ��ƼĿ');
insert into item (item_code, item_name) values ('I17', '������ ��ƼĿ');
insert into item (item_code, item_name) values ('I18', '�尩�� ��ƼĿ');
insert into item (item_code, item_name) values ('I19', '������ī ��ƼĿ');
