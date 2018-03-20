Prompt drop Package EX$SECAG_AUD_TYPE;
DROP PACKAGE EX$SECAG_AUD_TYPE
/

Prompt Package EX$SECAG_AUD_TYPE;
--
-- EX$SECAG_AUD_TYPE  (Package) 
--
CREATE OR REPLACE PACKAGE        EX$SECAG_AUD_TYPE
AS
   /*****************************************************************************
   * $Header EX$SECAG_AUD_TYPE:HEADER $
   *
   * $Component $
   *
   * $Module $
   * 
   * $Project$
   * 
   * $Folder$
   *
   * $Workfile$
   * 
   * $History$
   *
   * $Log[10]$
   *****************************************************************************/

   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC TYPES $
   *****************************************************************************/
   
   -- Запись для хранения контекста сессии
   TYPE CSession IS RECORD 
  (
  LOGON_TIME         DATE,
  CAT_UUID           VARCHAR2(12),
  USER_NAME          VARCHAR2(64 BYTE),
  USER_CODE          NUMBER,
  OSUSER             VARCHAR2(128 BYTE),
  CLIENT_HOST        VARCHAR2(128 BYTE),
  CLIENT_IP          VARCHAR2(64 BYTE),
  TERMINAL           VARCHAR2(128 BYTE),
  PROGRAM_SNAME      VARCHAR2(128 BYTE),
  MODULE_SNAME       VARCHAR2(128 BYTE),
  ACTION             VARCHAR2(128 BYTE),
  CLIENT_INFO        VARCHAR2(128 BYTE),
  CLIENT_IDENTIFIER  VARCHAR2(128 BYTE),
  SERVER_HOST        VARCHAR2(128 BYTE),
  SESS_ID            NUMBER,
  SESS_SERIAL#       NUMBER,
  SESS_AUDSID        NUMBER,
  SESS_SPID          VARCHAR2(12 BYTE),
  SERVICE_NAME       VARCHAR2(64 BYTE),
  DB_UNIQUE_NAME     VARCHAR2(64 BYTE),
  SQL_TRACE          CHAR(1 BYTE),
  SQL_TRACE_WAITS    CHAR(1 BYTE),
  SQL_TRACE_BINDS    CHAR(1 BYTE),
  PROXY_USER         VARCHAR2(64 BYTE),
  PROXY_USERID       NUMBER,
  ISDBA              CHAR(1 BYTE),
  FG_JOB_ID          NUMBER,
  DB_NAME            VARCHAR2(64 BYTE),
  DB_DOMAIN          VARCHAR2(64 BYTE),
  INSTANCE_NAME      VARCHAR2(64 BYTE),
  BG_JOB_ID          NUMBER,
  IS_JOB             CHAR(1),
  JOB_OWNER          VARCHAR2(64 BYTE),
  JOB_NAME           VARCHAR2(64 BYTE),
  JOB_SUBNAME        VARCHAR2(64 BYTE),
  SESS_TYPE          VARCHAR2(64 BYTE)
  );
  
  -- Буффер аудита
  TYPE AudBuffer IS RECORD
  (
    TYPE#       NUMBER,
    GROUP#      NUMBER,
    SPARE       NUMBER,
    STATE       VARCHAR2(64),
    IS_CURRENT  CHAR(1 BYTE),
    FLAGS       BINARY_DOUBLE,
    SFLAGS      BINARY_DOUBLE,
    LNAME       VARCHAR2(128 BYTE),    
    LHANDLE     VARCHAR2(128 BYTE),
    PNAME       VARCHAR2(64 BYTE),
    SESSID      VARCHAR2(64 BYTE),
    BMAN        VARCHAR2(3 BYTE),
    LCURRENT    TIMESTAMP(6),
    LCLEARED    TIMESTAMP(6),
    LLOGGED     TIMESTAMP(6),
    LBROKEN     TIMESTAMP(6),
    LINACTIVED  TIMESTAMP(6)       
  );  
  
  -- Тип запись аудита сессии
  TYPE SessAudLogRecord IS RECORD 
  (
   AUDSEQ    NUMBER,
   AUDTSTAMP TIMESTAMP(6),
   AUDSESS   CSession
   );


   
   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC EXCEPTIONS $
   *****************************************************************************/

   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC CONSTANTS $
   *****************************************************************************/

   -- Назначение записи аудита БУФФЕР:ЛОК.ЖУРНАЛ:ГЛОБ. ЖУРНАД 
   DEST_BUFFER CONSTANT PLS_INTEGER := 1;
   DEST_LOCAL  CONSTANT PLS_INTEGER := 2;
   DEST_GLOBAL CONSTANT PLS_INTEGER := 4;
   
   -- Поле SFLAGS для таблиц:
   -- EX$_SEC_AUD_SESS_BUFF
   -- EX$_SEC_AUD_SESS_LOG   
   -- EX$_SEC_AUD_DML_BUFF
   -- EX$_SEC_AUD_DML_LOG   
   -- Запись вставлена в EX$_SEC_AUD_*_BUFF (Default flags)
   LR_BUFFERED   CONSTANT PLS_INTEGER := 1;  
   -- Запись вставлена в EX$_SEC_AUD_*_LOG (Default flags)  
   LR_LOCAL     CONSTANT PLS_INTEGER  := 2;  
   
   LR_GLOBAL    CONSTANT PLS_INTEGER := 4;  
   -- Произошла ошиьбка во врем обработки записи EX$_SEC_AUD_*_LOG EX$_SEC_AUD_*_BUFF   
   LR_ERRORED    CONSTANT PLS_INTEGER := 8;  
   -- Маркер первой обработанной записи  при пакетной обрабоке
   LR_MRFIRST    CONSTANT PLS_INTEGER := 16;   
   -- Маркер последней обработанной записи  при пакетной обрабоке
   LR_MRLAST     CONSTANT PLS_INTEGER := 32;   
   -- Запись перенесена в глобальный журнал

   -----------------------------------------------------------------------------
   -- Поле SFLAGS Хранит Флаги состояния для сущностей таблиц 
   -- EX$_SEC_AUD_BUFF_OPS: Сущность "Операция на буфферной группе"
   -- EX$_SEC_AUD_BUFF_GRP  Сущность "Буфферная группа"
   -----------------------------------------------------------------------------   
   -- Первые четыре бита используются под режимы состояний
   -- эксклюзивный, shared и т.д.
   -----------------------------------------------------------------------------   
   IS_EXCLUSIVE   CONSTANT PLS_INTEGER := 1; -- X0   
   -- Запасные флаги режимов для возможного будущего использования
   -- IS_NEMODE1  CONSTANT PLS_INTEGER := 2; -- X1       
   -- IS_NEMODE2  CONSTANT PLS_INTEGER := 4; -- X2  
   -- IS_NEMODE3  CONSTANT PLS_INTEGER := 8; -- X3 

   -----------------------------------------------------------------------------
   -- Флаги активного состояния для буферных групп и операций
   -----------------------------------------------------------------------------   
   --  Исп-ся только в EX$_SEC_AUD_BUFF_GRP. Группа является текущей для записи данных
   IS_CURRENT        CONSTANT PLS_INTEGER := 17; --16 +1 
   --  Группа обрабатывается активной задачей из EX$_SEC_AUD_BUFF_OPS. Так же флаг активности задачи.
   IS_PROCESSING     CONSTANT PLS_INTEGER := 32;  
   --  Группа восстанавливается активной задачей из EX$_SEC_AUD_BUFF_OPS. Так же флаг активности задачи.
   IS_RECOVER        CONSTANT PLS_INTEGER := 65; --64 +1 
   --  Группа обслуживается активной задачей из EX$_SEC_AUD_BUFF_OPS. Так же флаг активности задачи.
   IS_MAINTENANCE    CONSTANT PLS_INTEGER := 129; --128 +1 
   -- -- Группа не имеет активных задач. Задача не активна. Для удобства.
   IS_IDLE           CONSTANT PLS_INTEGER := 0;
   -- -- Операция завершена
   IS_COMPLETE        CONSTANT PLS_INTEGER := 0;

   -- Запасные флаги состояний активности для возможного будущего использования
   -- IS_STATENAME1    CONSTANT PLS_INTEGER := 256;  --  Both GRP and OPS     
   -- IS_STATENAME2    CONSTANT PLS_INTEGER := 512;  --  Both GRP and OPS     
   -- IS_STATENAME3    CONSTANT PLS_INTEGER := 1024; --  Both GRP and OPS     
   -- IS_STATENAME3    CONSTANT PLS_INTEGER := 2048; --  Both GRP and OPS     

   -----------------------------------------------------------------------------
   -- FLAGS Свойства: Признаки буфферных групп            
   -- EX$_SEC_AUD_BUFF_GRP
   -----------------------------------------------------------------------------
   -- Признак того что буфферная группа очищена                                                              
   IS_CLEANED    CONSTANT PLS_INTEGER := 1;  
   -- Признак того что буфферная группа "сломана" требуется восстановление или пересоздание                                                              
   IS_BROKEN     CONSTANT PLS_INTEGER := 2;  
   -- Признак: Группа зарегестрована. Пока флаг не выставлен с ней нельзя вести никакую работу
   IS_REGISTERED CONSTANT PLS_INTEGER := 4; 
   -- Признак: Группа зарегистрирована. Пока флаг не выставлен с ней нельзя вести никакую работу
   IS_CREATED    CONSTANT PLS_INTEGER := 8; 
   -- Признак может ли группа использоваться локальными процессами
   IS_LOCAL      CONSTANT PLS_INTEGER := 16; 
   -- Признак может ли группа использоваться удалеными процессами
   IS_REMOTE     CONSTANT PLS_INTEGER := 32; 

   -- Поле OPCODE в:
   -- Таблице EX$_SEC_AUD_BUFF_OPS    -- Коды операций. 
   -- Возможные комбинации флагов смотрите  в таблице EX$_SEC_AUD_BUFF_OPS_OPMAP   
   OPS_MERGE      CONSTANT PLS_INTEGER  := 1; 
   OPS_DELETE     CONSTANT PLS_INTEGER  := 2; 
   OPS_TRANCATE   CONSTANT PLS_INTEGER  := 4;
   OPS_UPDATE     CONSTANT PLS_INTEGER  := 8; 
   OPS_INSERT     CONSTANT PLS_INTEGER  := 16; 
   OPS_MANUAL     CONSTANT PLS_INTEGER  := 32; 

   -- Коды для поля EX$_SEC_AUD_BUFF_OPS.UNITS
   OPS_UNT_ROWS  CONSTANT INTEGER := 1;
   OPS_UNT_BYTES CONSTANT INTEGER := 2;
   OPS_UNT_STEPS CONSTANT INTEGER := 3;   

    ------------------------------------------------------------------------
    -- Типы аудита. Коды журналируемых операций
    ------------------------------------------------------------------------    
    EVENT_LOGON     CONSTANT PLS_INTEGER := 1;
    EVENT_DDL       CONSTANT PLS_INTEGER := 2;
    --------------------------------------------------------------------------

   /*****************************************************************************       
   * $PartHeader PACKAGE PUBLIC VARIABLES $
   *****************************************************************************/

    
   /*****************************************************************************   
   * $PartHeader PUBLIC FUNCTIONS DECLARATIONS $
   *****************************************************************************/

   
   /*****************************************************************************
   * $Procedure INITIALIZE $
   *
   * $Purpose$
   *
   * $Note This function execution in package body pl/sql block $
   *
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   PROCEDURE INITIALIZE;

   /*****************************************************************************
   * $Function GET_VERSION $
   *
   * $Purpose$
   *
   * $Note This function execution in package body pl/sql block $
   *
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   FUNCTION GET_VERSION
      RETURN VARCHAR2;

   /*****************************************************************************
   * $Function GET_MNAME $
   *
   * $Purpose$
   *
   * $Note This function execution in package body pl/sql block $
   *
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   FUNCTION GET_MNAME
      RETURN VARCHAR2;

   

--------------------------------------------------------------------------------


END EX$SECAG_AUD_TYPE;
/
