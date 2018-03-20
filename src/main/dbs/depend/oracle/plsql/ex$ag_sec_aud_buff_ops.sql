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

COMMENT ON TABLE EX$AG_SEC_AUD_BUFF_OPS IS 'Список текущих (выполняемых) и выполненных операци по буфферным группам'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OUID IS 'ID операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.TP# IS 'Внешний ключ. Тип буфферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.GROUP# IS 'Внешний ключ. Номер буфферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.ROUID IS 'ID операции для восстановления текущей'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SID IS 'Идентификатор исполняющей сессии: V$SESSION.SID'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SERIAL# IS 'Идентификатор исполняющей сессии: V$SESSION.SERIAL#'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SLTIME IS 'Идентификатор исполняющей сессии: V$SESSION.LOGON_TME'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPSREF IS 'Внешний ключ на поле буфферную группы. Для обеспечения ссылочной целостности при запуск операций в режиме EXCLUSIVE'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SFLAGS IS 'Флаги состояния операций. Внешний ключ'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FLAGS IS 'Доп. аттрибуты:
x6  64   - Флаг статуса завершения операции: Отменена. См.Док.дляПодр.
x7  128  - Флаг статуса завершения операции: Предупреждения. См.Док.дляПодр.
x8  256  - Флаг статуса завершения операции: Ошибки. См.Док.дляПодр.
x9  512  - Ошибки по операции исправлены другой операцией
x10 1024 - Группа готова к удалению. То есть история по ней не требуется.
x11 2048 - Запрещен запуск других операций, если данная отработает с ошибкой. 
'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OSOURCE IS 'Название источника для операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OTARGET IS 'Название приемника или цели для операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPCODE IS 'Код (флаги) операции. Внешний ключ.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.OPMSG IS 'Текущее сообщение операции. Для отладки'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.SOFAR IS 'Выполненная работа в единицах изм. операции на данный момент'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.TWORKS IS 'Общее колв-во работ в единицах изм. операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.UNITS IS 'Единицы изм. работы операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.STSTAMP IS 'Время создания/старта операции.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.CTSTAMP IS 'Время завершения операции'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWID IS 'Контр. точка операции:Первая обработанная строка: ROWD'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWID IS 'Контр. точка операции:Последняя обработанная строка: ROWID'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWN IS 'Контр. точка операции:Первая обработанная строка: Номер'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWN IS 'Контр. точка операции:Последняя обработанная строка: Номер'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.FROWT IS 'Контр. точка операции:Первая обработанная строка: Время'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LROWT IS 'Контр. точка операции:Последняя обработанная строка: Время'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.LUPDATE IS 'Аудит: Время посл.изм.строки'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.ERR IS 'Текущее кол-во ошибок'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_OPS.WRNG IS 'Текущее кол-во предупреждений'
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
