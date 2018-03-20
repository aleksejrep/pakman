Prompt drop TABLE EX$AG_SEC_AUD_BUFF_OPS;
ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS
 DROP PRIMARY KEY CASCADE
/

DROP TABLE EX$AG_SEC_AUD_BUFF_OPS CASCADE CONSTRAINTS
/

Prompt Table EX$AG_SEC_AUD_BUFF_OPS;
--
-- EX$AG_SEC_AUD_BUFF_OPS  (Table) 
--
CREATE TABLE EX$AG_SEC_AUD_BUFF_OPS
(
  OUID     NUMBER(38),
  TP#      NUMBER(2) CONSTRAINT EX$SCAUDBO_CNN01 NOT NULL,
  GROUP#   NUMBER(2) CONSTRAINT EX$SCAUDBO_CNN02 NOT NULL,
  ROUID    NUMBER(38),
  SID      NUMBER CONSTRAINT EX$SCAUDBO_CNN03   NOT NULL,
  SERIAL#  NUMBER CONSTRAINT EX$SCAUDBO_CNN04   NOT NULL,
  SLTIME   DATE CONSTRAINT EX$SCAUDBO_CNN05     NOT NULL,
  OPSREF   NUMBER,
  SFLAGS   BINARY_DOUBLE CONSTRAINT EX$SCAUDBO_CNN06 NOT NULL,
  FLAGS    BINARY_DOUBLE CONSTRAINT EX$SCAUDBO_CNN07 NOT NULL,
  OSOURCE  VARCHAR2(64 BYTE),
  OTARGET  VARCHAR2(64 BYTE),
  OPCODE   BINARY_DOUBLE CONSTRAINT EX$SCAUDBO_CNN08 NOT NULL,
  OPMSG    VARCHAR2(2000 BYTE),
  SOFAR    NUMBER,
  TWORKS   NUMBER,
  UNITS    NUMBER,
  STSTAMP  TIMESTAMP(6),
  CTSTAMP  TIMESTAMP(6),
  FROWID   ROWID,
  LROWID   ROWID,
  FROWN    NUMBER,
  LROWN    NUMBER,
  FROWT    TIMESTAMP(6),
  LROWT    TIMESTAMP(6),
  LUPDATE  TIMESTAMP(6),
  ERR      NUMBER,
  WRNG     NUMBER
)
TABLESPACE EXTDBA_NDC
LOGGING 
MONITORING
/

COMMENT ON TABLE EX$AG_SEC_AUD_BUFF_OPS IS '������ ������� (�����������) � ����������� ������� �� ��������� �������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OUID IS 'ID ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.TP# IS '������� ����. ��� ��������� ������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.GROUP# IS '������� ����. ����� ��������� ������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.ROUID IS 'ID �������� ��� �������������� �������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SID IS '������������� ����������� ������: V$SESSION.SID'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SERIAL# IS '������������� ����������� ������: V$SESSION.SERIAL#'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SLTIME IS '������������� ����������� ������: V$SESSION.LOGON_TME'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPSREF IS '������� ���� �� ���� ��������� ������. ��� ����������� ��������� ����������� ��� ������ �������� � ������ EXCLUSIVE'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SFLAGS IS '����� ��������� ��������. ������� ����'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FLAGS IS '���. ���������:
x6  64   - ���� ������� ���������� ��������: ��������. ��.���.�������.
x7  128  - ���� ������� ���������� ��������: ��������������. ��.���.�������.
x8  256  - ���� ������� ���������� ��������: ������. ��.���.�������.
x9  512  - ������ �� �������� ���������� ������ ���������
x10 1024 - ������ ������ � ��������. �� ���� ������� �� ��� �� ���������.
x11 2048 - �������� ������ ������ ��������, ���� ������ ���������� � �������. 
'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OSOURCE IS '�������� ��������� ��� ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OTARGET IS '�������� ��������� ��� ���� ��� ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPCODE IS '��� (�����) ��������. ������� ����.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPMSG IS '������� ��������� ��������. ��� �������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SOFAR IS '����������� ������ � �������� ���. �������� �� ������ ������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.TWORKS IS '����� ����-�� ����� � �������� ���. ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.UNITS IS '������� ���. ������ ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.STSTAMP IS '����� ��������/������ ��������.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.CTSTAMP IS '����� ���������� ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWID IS '�����. ����� ��������:������ ������������ ������: ROWD'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWID IS '�����. ����� ��������:��������� ������������ ������: ROWID'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWN IS '�����. ����� ��������:������ ������������ ������: �����'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWN IS '�����. ����� ��������:��������� ������������ ������: �����'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWT IS '�����. ����� ��������:������ ������������ ������: �����'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWT IS '�����. ����� ��������:��������� ������������ ������: �����'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LUPDATE IS '�����: ����� ����.���.������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.ERR IS '������� ���-�� ������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.WRNG IS '������� ���-�� ��������������'
/


Prompt Index EX$SCAUDBO_IDX01;
--
-- EX$SCAUDBO_IDX01  (Index) 
--
CREATE INDEX EX$SCAUDBO_IDX01 ON EX$AG_SEC_AUD_BUFF_OPS
(TP#, GROUP#, SFLAGS)
LOGGING
TABLESPACE EXTDBA_NDC
/

Prompt Index EX$SCAUDBO_IDX02;
--
-- EX$SCAUDBO_IDX02  (Index) 
--
CREATE INDEX EX$SCAUDBO_IDX02 ON EX$AG_SEC_AUD_BUFF_OPS
(TP#, GROUP#)
LOGGING
TABLESPACE EXTDBA_NDC
/

Prompt Index EX$SCAUDBO_IDX03;
--
-- EX$SCAUDBO_IDX03  (Index) 
--
CREATE UNIQUE INDEX EX$SCAUDBO_IDX03 ON EX$AG_SEC_AUD_BUFF_OPS
(OUID)
LOGGING
TABLESPACE EXTDBA_NDC
/

-- 
-- Non Foreign Key Constraints for Table EX$AG_SEC_AUD_BUFF_OPS 
-- 
Prompt Non-Foreign Key Constraints on Table EX$AG_SEC_AUD_BUFF_OPS;
ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CCH01
  CHECK ("SFLAGS">0 AND (BITAND("SFLAGS",1)=1 AND NVL("OPSREF",(-999))="OUID" OR BITAND("SFLAGS",1)<>1 AND NVL("OPSREF",(-999))=0) OR "SFLAGS"=0 AND "OPSREF" IS NULL)
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CPK
  PRIMARY KEY
  (OUID)
  USING INDEX EX$SCAUDBO_IDX03
  ENABLE VALIDATE)
/


-- 
-- Foreign Key Constraints for Table EX$AG_SEC_AUD_BUFF_OPS 
-- 
Prompt Foreign Key Constraints on Table EX$AG_SEC_AUD_BUFF_OPS;
ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK01 
  FOREIGN KEY (TP#, GROUP#, OPSREF) 
  REFERENCES EX$AG_SEC_AUD_BUFF_GRP (TP#,GROUP#,OPSREF)
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK02 
  FOREIGN KEY (SFLAGS) 
  REFERENCES EX$AG_SEC_AUD_BUFF_OPS_SFMAP (SFLAGS)
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK03 
  FOREIGN KEY (ROUID) 
  REFERENCES EX$AG_SEC_AUD_BUFF_OPS (OUID)
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK05 
  FOREIGN KEY (OPCODE) 
  REFERENCES EX$AG_SEC_AUD_BUFF_OPS_OPMAP (OPCODE)
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_SESS_ERRORS ADD (
  CONSTRAINT EX$SCAUDBERR_CFK01 
  FOREIGN KEY (OPS_UID) 
  REFERENCES EX$AG_SEC_AUD_BUFF_OPS (OUID))
/
