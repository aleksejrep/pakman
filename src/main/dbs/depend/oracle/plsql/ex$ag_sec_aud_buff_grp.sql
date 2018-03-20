Prompt drop TABLE EX$AG_SEC_AUD_BUFF_GRP;
ALTER TABLE EX$AG_SEC_AUD_BUFF_GRP
 DROP PRIMARY KEY CASCADE
/

DROP TABLE EX$AG_SEC_AUD_BUFF_GRP CASCADE CONSTRAINTS
/

Prompt Table EX$AG_SEC_AUD_BUFF_GRP;
--
-- EX$AG_SEC_AUD_BUFF_GRP  (Table) 
--
CREATE TABLE EX$AG_SEC_AUD_BUFF_GRP
(
  TP#       NUMBER(2),
  GROUP#    NUMBER(2),
  SPARE#    NUMBER(2),
  SFLAGS    BINARY_DOUBLE CONSTRAINT EX$SCAUDBGRP_CNN00 NOT NULL,
  FLAGS     BINARY_DOUBLE CONSTRAINT EX$SCAUDBGRP_CNN01 NOT NULL,
  OPS       NUMBER(2) CONSTRAINT EX$SCAUDBGRP_CNN02 NOT NULL,
  OPSREF    NUMBER CONSTRAINT EX$SCAUDBGRP_CNN03 NOT NULL,
  CURREF    NUMBER CONSTRAINT EX$SCAUDBGRP_CNN04 NOT NULL,
  PNAME     VARCHAR2(64 BYTE),
  LNAME     VARCHAR2(64 BYTE),
  LCURRENT  TIMESTAMP(6),
  LIDLE     TIMESTAMP(6),
  LCLEANED  TIMESTAMP(6),
  LACTIVE   TIMESTAMP(6)
)
TABLESPACE EXTDBA_NDC
LOGGING 
MONITORING
/

COMMENT ON TABLE EX$AG_SEC_AUD_BUFF_GRP IS 'Список буфферных групп аудита.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.TP# IS 'Тип данных буферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.GROUP# IS 'Уникальный номр буфферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.SPARE# IS 'Запасной номер буфферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.SFLAGS IS 'Флаги состояния'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.FLAGS IS 'Доп. аттрибуты:
x0 1  - Буфферная группы очищена
x1 2  - Буфферная группа сломана, требуется восстановление
x2 4  - Группа зарегестрирована
x3 8  - Группа создана. То есть привязана к партиции буфферной таблицы
x4 16 - Группа может использоваться локальными процессами
x5 32 - Группа может использоваться удаленными процессами
'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.OPS IS 'Кол-во активных операций по текущей группе'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.OPSREF IS 'Код для ссылочной целостности из таблицы операций. Обеспеивает ссылочную челостность при создании операции.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.CURREF IS 'Код для ссылочной целостности из таблицы доп. свойст буфферной группы. Обеспеивает ссылочную челостность при определении CURRENT текущей группы.'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.PNAME IS 'Назание партиции в буфферной таблице. '
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.LNAME IS 'Название пользовательской блокировки для данной буфферной группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.LCURRENT IS 'Последнее время переключения в режим ТЕКУЩИЙ (CURRENT)'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.LIDLE IS 'Последнее время переключения в режим СВОБОДЕН (IDLE)'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.LCLEANED IS 'Последнее время проставления аттрибута ОЧИЩЕН для буфферой группы'
/

COMMENT ON COLUMN EX$AG_SEC_AUD_BUFF_GRP.LACTIVE IS 'Последнее время запуска задачи по буфферной группе. Режим CURRENT на поле не действует.'
/


Prompt Index EX$SCAUDBG_UDX01;
--
-- EX$SCAUDBG_UDX01  (Index) 
--
CREATE UNIQUE INDEX EX$SCAUDBG_UDX01 ON EX$AG_SEC_AUD_BUFF_GRP
(TP#, GROUP#)
LOGGING
TABLESPACE EXTDBA_NDC
/

Prompt Index EX$SCAUDBG_UDX02;
--
-- EX$SCAUDBG_UDX02  (Index) 
--
CREATE UNIQUE INDEX EX$SCAUDBG_UDX02 ON EX$AG_SEC_AUD_BUFF_GRP
(TP#, GROUP#, OPSREF)
LOGGING
TABLESPACE EXTDBA_NDC
/

Prompt Index EX$SCAUDBG_UDX03;
--
-- EX$SCAUDBG_UDX03  (Index) 
--
CREATE UNIQUE INDEX EX$SCAUDBG_UDX03 ON EX$AG_SEC_AUD_BUFF_GRP
(TP#, GROUP#, CURREF)
LOGGING
TABLESPACE EXTDBA_NDC
/

-- 
-- Non Foreign Key Constraints for Table EX$AG_SEC_AUD_BUFF_GRP 
-- 
Prompt Non-Foreign Key Constraints on Table EX$AG_SEC_AUD_BUFF_GRP;
ALTER TABLE EX$AG_SEC_AUD_BUFF_GRP ADD (
  CONSTRAINT EX$SCAUDBG_CCH01
  CHECK (
          ("SFLAGS" > 0 AND BITAND("SFLAGS",16)!= 16 AND BITAND("SFLAGS",1) = 1  AND "OPSREF" > 0 AND CURREF =(-1) )
       OR ("SFLAGS" > 0 AND BITAND("SFLAGS",16) = 16 AND  "OPSREF" = (-1) AND CURREF > 0 )
       OR ("SFLAGS" > 0 AND BITAND("SFLAGS",16)!= 16 AND BITAND("SFLAGS",1) != 1  AND "OPSREF" = 0 AND CURREF = (-1)) 
       OR ("SFLAGS"=0 AND "OPSREF"=(-1) AND  CURREF = (-1))
         )
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_GRP ADD (
  CONSTRAINT EX$SCAUDBG_CPK
  PRIMARY KEY
  (TP#, GROUP#)
  USING INDEX EX$SCAUDBG_UDX01
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_GRP ADD (
  CONSTRAINT EX$SCAUDBG_CUQ01
  UNIQUE (TP#, GROUP#, OPSREF)
  USING INDEX EX$SCAUDBG_UDX02
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_GRP ADD (
  CONSTRAINT EX$SCAUDBG_CUQ02
  UNIQUE (TP#, GROUP#, CURREF)
  USING INDEX EX$SCAUDBG_UDX03
  ENABLE VALIDATE)
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_CURR ADD (
  CONSTRAINT EX$SCABGC_CFK01 
  FOREIGN KEY (TP#, GROUP#, CURREF) 
  REFERENCES EX$AG_SEC_AUD_BUFF_GRP (TP#,GROUP#,CURREF))
/

ALTER TABLE EX$AG_SEC_AUD_BUFF_OPS ADD (
  CONSTRAINT EX$SCAUDBO_CFK01 
  FOREIGN KEY (TP#, GROUP#, OPSREF) 
  REFERENCES EX$AG_SEC_AUD_BUFF_GRP (TP#,GROUP#,OPSREF))
/
