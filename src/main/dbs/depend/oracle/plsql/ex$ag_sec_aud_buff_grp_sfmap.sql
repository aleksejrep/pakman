Prompt drop TABLE EX$AG_SEC_AUD_BUFF_GRP_SFMAP;
DROP TABLE EX$AG_SEC_AUD_BUFF_GRP_SFMAP CASCADE CONSTRAINTS
/

Prompt Table EX$AG_SEC_AUD_BUFF_GRP_SFMAP;
--
-- EX$AG_SEC_AUD_BUFF_GRP_SFMAP  (Table) 
--
CREATE TABLE EX$AG_SEC_AUD_BUFF_GRP_SFMAP
(
  SFLAGS  BINARY_DOUBLE,
  NAME    VARCHAR2(128 BYTE)
)
TABLESPACE EXTDBA_NDC
LOGGING 
MONITORING
/

COMMENT ON TABLE EX$AG_SEC_AUD_BUFF_GRP_SFMAP IS '��������� ���������� ������ ��������� ��� EX$_SEC_AUD_BUFF_GRP'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP_SFMAP.SFLAGS IS '���������� ������ ��������'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP_SFMAP.NAME IS '�������� ���������'
/
