Prompt drop TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP;
ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP
 DROP PRIMARY KEY CASCADE
/

DROP TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP CASCADE CONSTRAINTS
/

Prompt Table EX$AG_SEC_AUD_BUFF_OPS_SFMAP;
--
-- EX$AG_SEC_AUD_BUFF_OPS_SFMAP  (Table) 
--
CREATE TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP
(
  SFLAGS  BINARY_DOUBLE,
  NAME    VARCHAR2(128 BYTE)
)
TABLESPACE EXTDBA_NDC
LOGGING 
MONITORING
/

COMMENT ON TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP IS '��������� ���������� ������ ��������� ��� EX$_SEC_AUD_BUFF_OPS'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS_SFMAP.SFLAGS IS '���������� ������� ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS_SFMAP.NAME IS '�������� ���������'
/


Prompt Index EX$SCAUDBOFM_UDX01;
--
-- EX$SCAUDBOFM_UDX01  (Index) 
--
CREATE UNIQUE INDEX EX$SCAUDBOFM_UDX01 ON EX$AG_SEC_AUD_BUFF_OPS_SFMAP
(SFLAGS)
LOGGING
TABLESPACE EXTDBA_NDC
/

-- 
-- Non Foreign Key Constraints for Table EX$AG_SEC_AUD_BUFF_OPS_SFMAP 
-- 
Prompt Non-Foreign Key Constraints on Table EX$AG_SEC_AUD_BUFF_OPS_SFMAP;
ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS_SFMAP ADD (
  CONSTRAINT EX$SCAUDBOFM_CPK
  PRIMARY KEY
  (SFLAGS)
  USING INDEX EX$SCAUDBOFM_UDX01
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK02 
  FOREIGN KEY (SFLAGS) 
  REFERENCES EX$AG_SEC_AUD_BUFF_OPS_SFMAP (SFLAGS))
/
