Prompt drop Package Body EX$AG_SEC_AUDIT_MGMT;
DROP PACKAGE BODY EX$AG_SEC_AUDIT_MGMT
/

Prompt Package Body EX$AG_SEC_AUDIT_MGMT;
--
-- EX$AG_SEC_AUDIT_MGMT  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        EX$AG_SEC_AUDIT_MGMT
AS
   /*****************************************************************************
   * $Header EX$AG_SEC_AUDIT_MGMT:BODY $
   *
   * $Component  $
   *
   * $Module  $
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
   * $PartHeader PACKAGE PRIVATE TYPES $
   *****************************************************************************/

   /*****************************************************************************
   * $PartHeader PACKAGE PRIVATE EXCEPTIONS $
   *****************************************************************************/

   /*****************************************************************************
   * $PartHeader PACKAGE PRIVATE CONSTRAINTS $
   *****************************************************************************/
      GC_MODULE_VERSION CONSTANT VARCHAR2(16) := '1.0.0.0';  
      BTP_SESSION CONSTANT PLS_INTEGER := 1;
      BTP_DDL     CONSTANT PLS_INTEGER := 2;
   /*****************************************************************************       
   * $PartHeader PACKAGE PRIVATE VARIABLES $
   *****************************************************************************/
   GL_CAT_UUID VARCHAR2(12) := 'RSVDGRE';
   
   /*****************************************************************************   
   * $PartHeader PRIVATE FUNCTIONS DECLARATIONS $
   *****************************************************************************/
   FUNCTION GET_SESSCTX(P_AUDSID IN NUMBER DEFAULT NULL)
   RETURN SESSCTX_RTYPE
   AS
   l_sessctx_ret SESSCTX_RTYPE;
   l_errcode     NUMBER;
   l_errmsg      VARCHAR2(1024);   
   BEGIN
   SELECT   /* (EX$SCAUD001)*/  
              LOGON_TIME
             ,USER_NAME
             ,USER_CODE
             ,OSUSER
             ,CLIENT_HOST
             ,CLIENT_IP
             ,TERMINAL
             ,PROGRAM_SNAME
             ,MODULE_SNAME
             ,ACTION
             ,CLIENT_INFO
             ,CLIENT_IDENTIFIER
             ,SERVER_HOST
             ,SESS_ID
             ,SESS_SERIAL#
             ,SESS_AUDSID
             ,SESS_SPID
             ,SERVICE_NAME
             ,DB_UNIQUE_NAME
             ,SQL_TRACE
             ,SQL_TRACE_WAITS
             ,SQL_TRACE_BINDS
             ,PROXY_USER
             ,PROXY_USERID
             ,ISDBA
             ,DB_NAME
             ,DB_DOMAIN
             ,INSTANCE_NAME
             ,JOB_OWNER
             ,JOB_NAME
             ,JOB_SUBNAME
             ,SESS_TYPE
   INTO 
              l_sessctx_ret.LOGON_TIME
             ,l_sessctx_ret.USER_NAME
             ,l_sessctx_ret.USER_CODE
             ,l_sessctx_ret.OSUSER
             ,l_sessctx_ret.CLIENT_HOST
             ,l_sessctx_ret.CLIENT_IP
             ,l_sessctx_ret.TERMINAL
             ,l_sessctx_ret.PROGRAM_SNAME
             ,l_sessctx_ret.MODULE_SNAME
             ,l_sessctx_ret.ACTION
             ,l_sessctx_ret.CLIENT_INFO
             ,l_sessctx_ret.CLIENT_IDENTIFIER
             ,l_sessctx_ret.SERVER_HOST
             ,l_sessctx_ret.SESS_ID
             ,l_sessctx_ret.SESS_SERIAL#
             ,l_sessctx_ret.SESS_AUDSID
             ,l_sessctx_ret.SESS_SPID
             ,l_sessctx_ret.SERVICE_NAME
             ,l_sessctx_ret.DB_UNIQUE_NAME
             ,l_sessctx_ret.SQL_TRACE
             ,l_sessctx_ret.SQL_TRACE_WAITS
             ,l_sessctx_ret.SQL_TRACE_BINDS
             ,l_sessctx_ret.PROXY_USER
             ,l_sessctx_ret.PROXY_USERID
             ,l_sessctx_ret.ISDBA
             ,l_sessctx_ret.DB_NAME
             ,l_sessctx_ret.DB_DOMAIN
             ,l_sessctx_ret.INSTANCE_NAME
             ,l_sessctx_ret.JOB_OWNER
             ,l_sessctx_ret.JOB_NAME
             ,l_sessctx_ret.JOB_SUBNAME
             ,l_sessctx_ret.SESS_TYPE   
   FROM  EX$AG_SEC_SESS_CTX_ALL S
   WHERE S.SESS_AUDSID = NVL(P_AUDSID,SYS_CONTEXT('USERENV','SESSIONID'))
   AND   S.SESS_TYPE = 'USER'  
   AND ROWNUM = 1;
   RETURN l_sessctx_ret;
   EXCEPTION 
   WHEN NO_DATA_FOUND
   THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_SESS_DOES_NOT_EXISTS;
   WHEN OTHERS
   THEN 
        l_errcode := SQLCODE;
        l_errmsg  := SUBSTR(SQLERRM, 1, 1024);
        RAISE_APPLICATION_ERROR(-20000
                                ,'EX$SEC-001: Error get session context'
                                || chr(10)
                                || 'CODE:' || TO_CHAR(l_errcode)
                                || chr(10)
                                || 'MSG:'  || l_errmsg                                
                                ,TRUE);
   END;

   FUNCTION LCK_BY_LNAME(P_LNAME   IN VARCHAR2
                        ,P_LHANDLE OUT VARCHAR2
                        ,P_MODE    IN INTEGER
                        ,P_WAIT    IN INTEGER)
                        
   RETURN PLS_INTEGER
   AS
   l_req_ret integer;
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
    
    DBMS_LOCK.ALLOCATE_UNIQUE(
                                  LOCKNAME        => P_LNAME
                                 ,LOCKHANDLE      => P_LHANDLE
                                 ,EXPIRATION_SECS => EX$AG_SEC_AUDIT_MGMT.LOCK_MAXEXPSECS
                                  );
    
    l_req_ret := DBMS_LOCK.REQUEST(
                                      LOCKHANDLE        => P_LHANDLE
                                     ,LOCKMODE          => P_MODE
                                     ,TIMEOUT           => P_WAIT
                                     ,RELEASE_ON_COMMIT => FALSE
                                   );
    
    RETURN   l_req_ret;                    
 
   NULL;
   END;
   

   FUNCTION GET_BUFFER_CURR(P_TYPE   IN PLS_INTEGER
                           ,P_ISLOCK IN BOOLEAN DEFAULT FALSE
                           ,P_MODE   IN INTEGER
                           ,P_WAIT   IN INTEGER DEFAULT 60)
   RETURN BGROUP_RTYPE
   AS
   l_grp_r BGROUP_RTYPE;
   l_lck_code integer;
   BEGIN
   SELECT B.TP#
         ,B.GROUP#
         ,B.PNAME
         ,B.LNAME
   INTO  l_grp_r.TYPE#
        ,l_grp_r.GROUP#
        ,l_grp_r.PNAME
        ,l_grp_r.LNAME
   FROM EX$AG_SEC_AUD_BUFF_CURR B
   WHERE B.TP# = P_TYPE
   AND  BITAND(B.SFLAGS,16)=16;
   
   IF P_ISLOCK 
      THEN
   l_lck_code := LCK_BY_LNAME(P_LNAME   => l_grp_r.lname
                             ,P_LHANDLE => l_grp_r.lhandle
                             ,P_MODE    => P_MODE
                             ,P_WAIT    => 0);
   
    ELSE l_lck_code := -1;
    
    END IF;
    CASE l_lck_code
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_SUCCESS   /* success */
    THEN NULL;
    
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_TIMEOUT    /* timeout */
    THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY;
    
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_DEADLOCK   /* deadlock */
    THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY;
    
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_PARERROR   /* parameter error */
    THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY;
    
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_ALREADYOWN /* already own lock specified by 'id' or 'lockhandle' */
    THEN NULL;
    
    WHEN EX$AG_SEC_AUDIT_MGMT.LOCK_REQC_ILLHANDLE  /* illegal lockhandle */
    THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY;
    
    ELSE NULL;
    END CASE;

   
   RETURN l_grp_r;
   END;


   PROCEDURE INS_AUD_SESS2LOG(P_SESS_CTX IN OUT NOCOPY SESSCTX_RTYPE
                              ,P_AUDSEQ     IN OUT NOCOPY NUMBER
                              ,P_AUDTSTAMP  IN OUT NOCOPY TIMESTAMP                            
                             )
   AS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_audseq_ret NUMBER;
   l_errcode    NUMBER;
   l_errmsg     VARCHAR2(1024);      
   BEGIN
    
    SAVEPOINT svbfr_ins_aud_sess_log_loc;
    
    LOCK TABLE EX$AG_SEC_AUD_SESS_LOG_LOC IN ROW SHARE MODE NOWAIT; 
    
    INSERT INTO EX$AG_SEC_AUD_SESS_LOG_LOC /* (EX$SCAUD002)*/
      (
       LOGON_TIME
      ,AUDSEQ
      ,AUDTSTAMP
      ,SFLAGS
      ,FLAGS
      ,CAT_UUID
      ,USER_NAME
      ,USER_CODE
      ,OSUSER
      ,CLIENT_HOST
      ,CLIENT_IP
      ,TERMINAL
      ,PROGRAM_SNAME
      ,MODULE_SNAME
      ,ACTION
      ,CLIENT_INFO
      ,CLIENT_IDENTIFIER
      ,SERVER_HOST
      ,SESS_ID
      ,SESS_SERIAL#
      ,SESS_AUDSID
      ,SESS_SPID
      ,SERVICE_NAME
      ,DB_UNIQUE_NAME
      ,AUD_LOGON_CODE
      ,AUDIT_LOGON_MSG
      ,SQL_TRACE
      ,SQL_TRACE_WAITS
      ,SQL_TRACE_BINDS
      ,PROXY_USER
      ,PROXY_USERID
      ,ISDBA
      ,FG_JOB_ID
      ,DB_NAME
      ,DB_DOMAIN
      ,BG_JOB_ID
      ,SESS_ATTRIBUTE01
      ,SESS_ATTRIBUTE02
      ,SESS_ATTRIBUTE03
      ,SESS_ATTRIBUTE04
      ,SESS_ATTRIBUTE05
      ,SESS_ATTRIBUTE06
      ,SESS_ATTRIBUTE07
      ,SESS_ATTRIBUTE08
      ,SESS_ATTRIBUTE09
      ,SESS_ATTRIBUTE10
      )
    VALUES
      (
       P_SESS_CTX.LOGON_TIME
      ,NVL(P_AUDSEQ,EX$AGSCAUDSEQ_S.NEXTVAL)
      ,NVL(P_AUDTSTAMP,CURRENT_TIMESTAMP)
      ,EX$AG_SEC_AUDIT_MGMT.RW_LOCAL
      ,EX$AG_SEC_AUDIT_MGMT.RWF_INIT
      ,EX$AG_SEC_AUDIT_MGMT.GL_CAT_UUID
      ,P_SESS_CTX.USER_NAME
      ,P_SESS_CTX.USER_CODE
      ,P_SESS_CTX.OSUSER
      ,P_SESS_CTX.CLIENT_HOST
      ,P_SESS_CTX.CLIENT_IP
      ,P_SESS_CTX.TERMINAL
      ,P_SESS_CTX.PROGRAM_SNAME
      ,P_SESS_CTX.MODULE_SNAME
      ,P_SESS_CTX.ACTION
      ,P_SESS_CTX.CLIENT_INFO
      ,P_SESS_CTX.CLIENT_IDENTIFIER
      ,P_SESS_CTX.SERVER_HOST
      ,P_SESS_CTX.SESS_ID
      ,P_SESS_CTX.SESS_SERIAL#
      ,P_SESS_CTX.SESS_AUDSID
      ,P_SESS_CTX.SESS_SPID
      ,P_SESS_CTX.SERVICE_NAME
      ,P_SESS_CTX.DB_UNIQUE_NAME
      ,null
      ,null
      ,P_SESS_CTX.SQL_TRACE
      ,P_SESS_CTX.SQL_TRACE_WAITS
      ,P_SESS_CTX.SQL_TRACE_BINDS
      ,P_SESS_CTX.PROXY_USER
      ,P_SESS_CTX.PROXY_USERID
      ,P_SESS_CTX.ISDBA
      ,null
      ,P_SESS_CTX.DB_NAME
      ,P_SESS_CTX.DB_DOMAIN
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      )
        RETURNING AUDSEQ,AUDTSTAMP
             INTO P_AUDSEQ,P_AUDTSTAMP;
   
   COMMIT;
   EXCEPTION 
   WHEN EX_RESOURCE_BUSY
   THEN 
        ROLLBACK TO svbfr_ins_aud_sess_log_loc;
        RAISE_APPLICATION_ERROR(-20000
                                ,'EX$SEC-002: Error insert session context into EX$AG_SEC_AUD_SESS_LOG_LOC'
                                || chr(10)
                                || 'CODE:' || TO_CHAR(-20000)
                                || chr(10)
                                || 'MSG:'  || 'Unable Lock table EX$AG_SEC_AUD_SESS_LOG_LOC in ROW SHARE mode'                                
                                ,TRUE);
   WHEN OTHERS
   THEN 
        ROLLBACK TO svbfr_ins_aud_sess_log_loc;
        l_errcode := SQLCODE;
        l_errmsg  := SUBSTR(SQLERRM, 1, 1024);
        RAISE_APPLICATION_ERROR(-20000
                                ,'EX$SEC-002: Error insert session context into EX$AG_SEC_AUD_SESS_LOG_LOC'
                                || chr(10)
                                || 'CODE:' || TO_CHAR(l_errcode)
                                || chr(10)
                                || 'MSG:'  || l_errmsg                                
                                ,TRUE);
   END;

   PROCEDURE INS_AUD_SESS2BUFF(P_SESS_CTX   IN OUT NOCOPY SESSCTX_RTYPE
                              ,P_AUDSEQ     IN OUT NOCOPY NUMBER
                              ,P_AUDTSTAMP  IN OUT NOCOPY TIMESTAMP)
   AS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_bgrp_r     BGROUP_RTYPE; 
   l_audseq_ret number;
   l_errcode    number;
   l_errmsg     varchar2(1024);
   l_lck_max_try integer := 3;
   l_rel_ret     integer;
   
   BEGIN
    SAVEPOINT svbfr_ins_aud_sess_buff;
    -- 1.0 Определяем текущую группу и блокируем её в SX режиме
    -- При блокировке выполняем несколько попыток дляисключения "невзятия"
    -- блокировки во время переключения буфферной группы
    for i in 1..l_lck_max_try + 1
    loop
    BEGIN
    l_bgrp_r := GET_BUFFER_CURR(P_TYPE   => EVENT_LOGON
                               ,P_ISLOCK => TRUE
                               ,P_MODE   => EX$AG_SEC_AUDIT_MGMT.LOCK_SX_MODE 
                               ,P_WAIT   => 0);  
    EXIT;
    EXCEPTION
    WHEN EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY
    THEN NULL; -- Игнорируем ошибки при получении блокировки
    END;
    end loop;
    
    -- Если CURRENT так и не была получена генерируем исключение
    IF l_bgrp_r.GROUP# IS NULL
    THEN RAISE EX$AG_SEC_AUDIT_MGMT.EX_RESOURCE_BUSY;
    END IF; 
                           
    EXECUTE IMMEDIATE 'LOCK TABLE EX$AG_SEC_AUD_SESS_BUFF PARTITION(:PNAME) IN ROW SHARE MODE NOWAIT'
    USING l_bgrp_r.PNAME; 
    
    INSERT INTO EX$AG_SEC_AUD_SESS_BUFF /* (EX$SCAUD003)*/
      (
       GROUP# 
      ,LOGON_TIME
      ,AUDSEQ
      ,AUDTSTAMP
      ,SFLAGS
      ,FLAGS
      ,CAT_UUID
      ,USER_NAME
      ,USER_CODE
      ,OSUSER
      ,CLIENT_HOST
      ,CLIENT_IP
      ,TERMINAL
      ,PROGRAM_SNAME
      ,MODULE_SNAME
      ,ACTION
      ,CLIENT_INFO
      ,CLIENT_IDENTIFIER
      ,SERVER_HOST
      ,SESS_ID
      ,SESS_SERIAL#
      ,SESS_AUDSID
      ,SESS_SPID
      ,SERVICE_NAME
      ,DB_UNIQUE_NAME
      ,AUD_LOGON_CODE
      ,AUDIT_LOGON_MSG
      ,SQL_TRACE
      ,SQL_TRACE_WAITS
      ,SQL_TRACE_BINDS
      ,PROXY_USER
      ,PROXY_USERID
      ,ISDBA
      ,FG_JOB_ID
      ,DB_NAME
      ,DB_DOMAIN
      ,BG_JOB_ID
      ,SESS_ATTRIBUTE01
      ,SESS_ATTRIBUTE02
      ,SESS_ATTRIBUTE03
      ,SESS_ATTRIBUTE04
      ,SESS_ATTRIBUTE05
      ,SESS_ATTRIBUTE06
      ,SESS_ATTRIBUTE07
      ,SESS_ATTRIBUTE08
      ,SESS_ATTRIBUTE09
      ,SESS_ATTRIBUTE10
      )
    VALUES
      (
       l_bgrp_r.group#
      ,P_SESS_CTX.LOGON_TIME
      ,NVL(P_AUDSEQ,EX$AGSCAUDSEQ_S.NEXTVAL)
      ,NVL(P_AUDTSTAMP,CURRENT_TIMESTAMP)
      ,EX$AG_SEC_AUDIT_MGMT.RW_BUFFERED
      ,EX$AG_SEC_AUDIT_MGMT.RWF_INIT
      ,EX$AG_SEC_AUDIT_MGMT.GL_CAT_UUID
      ,P_SESS_CTX.USER_NAME
      ,P_SESS_CTX.USER_CODE
      ,P_SESS_CTX.OSUSER
      ,P_SESS_CTX.CLIENT_HOST
      ,P_SESS_CTX.CLIENT_IP
      ,P_SESS_CTX.TERMINAL
      ,P_SESS_CTX.PROGRAM_SNAME
      ,P_SESS_CTX.MODULE_SNAME
      ,P_SESS_CTX.ACTION
      ,P_SESS_CTX.CLIENT_INFO
      ,P_SESS_CTX.CLIENT_IDENTIFIER
      ,P_SESS_CTX.SERVER_HOST
      ,P_SESS_CTX.SESS_ID
      ,P_SESS_CTX.SESS_SERIAL#
      ,P_SESS_CTX.SESS_AUDSID
      ,P_SESS_CTX.SESS_SPID
      ,P_SESS_CTX.SERVICE_NAME
      ,P_SESS_CTX.DB_UNIQUE_NAME
      ,null
      ,null
      ,P_SESS_CTX.SQL_TRACE
      ,P_SESS_CTX.SQL_TRACE_WAITS
      ,P_SESS_CTX.SQL_TRACE_BINDS
      ,P_SESS_CTX.PROXY_USER
      ,P_SESS_CTX.PROXY_USERID
      ,P_SESS_CTX.ISDBA
      ,null
      ,P_SESS_CTX.DB_NAME
      ,P_SESS_CTX.DB_DOMAIN
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      )
        RETURNING AUDSEQ,AUDTSTAMP
             INTO P_AUDSEQ,P_AUDTSTAMP;

   COMMIT;
   l_rel_ret := DBMS_LOCK.RELEASE(LOCKHANDLE =>l_bgrp_r.LHANDLE);
   EXCEPTION 
   WHEN EX_RESOURCE_BUSY
   THEN 
            
            IF l_bgrp_r.GROUP# IS NOT NULL
            THEN l_rel_ret:= DBMS_LOCK.RELEASE(LOCKHANDLE =>l_bgrp_r.LHANDLE);
            END IF; 
            
            ROLLBACK TO svbfr_ins_aud_sess_buff;
        RAISE_APPLICATION_ERROR(-20000
                                ,'EX$SEC-002: Error insert session context into EX$AG_SEC_AUD_SESS_BUFF'
                                || chr(10)
                                || 'CODE:' || TO_CHAR(-20000)
                                || chr(10)
                                || 'MSG:'  || 'Unable Lock table EX$AG_SEC_AUD_SESS_BUFF in ROW SHARE mode'                                
                                ,TRUE);
   WHEN OTHERS
   THEN 
            IF l_bgrp_r.GROUP# IS NOT NULL
            THEN l_rel_ret := DBMS_LOCK.RELEASE(LOCKHANDLE =>l_bgrp_r.LHANDLE);
            END IF; 
        ROLLBACK TO svbfr_ins_aud_sess_buff;
        l_errcode := SQLCODE;
        l_errmsg  := SUBSTR(SQLERRM, 1, 1024);
        RAISE_APPLICATION_ERROR(-20000
                                ,'EX$SEC-002: Error insert session context into EX$AG_SEC_AUD_SESS_BUFF'
                                || chr(10)
                                || 'CODE:' || TO_CHAR(l_errcode)
                                || chr(10)
                                || 'MSG:'  || l_errmsg                                
                                ,TRUE);
   
   END;

   /*****************************************************************************   
   * $PartHeader PACKAGE FUNCTIONS DEFINITIONS $
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
   *
   * $FuncHistory
   *
   *          MODIFIED           (MM/DD/YYYY)       ACTION
   *
   * $
   *****************************************************************************/
   PROCEDURE INITIALIZE
   AS
   BEGIN
    NULL;
   END;

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
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN GC_MODULE_VERSION;
   END;

   /*****************************************************************************
   * $Function SESS_LOG $
   *
   * $Purpose
   * Создает запись аудита сессии в таблице аудита: буфферной или локальной
   * В качестве сессии берет текущую сессию.
   * Может использоваться в DATABASE AFTER LOGON триггере
   * 
   * $
   * $Note  
   * !!! ВНИМАНИЕ: Запускается в автономной транзакции. 
   * !!! ВНИМАНИЕ: Во время своей работы отключает режим RESUMABLE для сесии
   * 
   * 
   * При невозможности создать запись аудита в буфферной таблице выполняет попытку
   * записи в лог
   * $
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * DEST_TYPE                                  AUDLOG_BUFFER или AUDLOG_LOG
   * AUDSEQ                                     Уникальный идентификатор запсии аудита для данной БД
   * ERR_CALL_BACK                              Генерировать исключение при невозможности записи аудита
   * $
   *****************************************************************************/
   PROCEDURE SESS_LOG(DEST_TYPE     IN PLS_INTEGER DEFAULT DEST_BUFFER
                     ,AUDSEQ        OUT NUMBER
                     ,AUDTSTAMP     OUT TIMESTAMP
                     ,ERR_CALL_BACK IN BOOLEAN     DEFAULT TRUE
                      )
   AS
   l_sessctx   SESSCTX_RTYPE;
   l_audseq    number;
   l_audtstamp timestamp;
   BEGIN
   -- Получаем аттрибуты контекста текущей сесии сессии.
   l_sessctx := GET_SESSCTX;
   -- Создаем запись в таблицах аудита
   IF BITAND(DEST_TYPE,DEST_BUFFER) = DEST_BUFFER
      THEN 
         INS_AUD_SESS2BUFF(P_SESS_CTX  => l_sessctx
                          ,P_AUDSEQ    => l_audseq
                          ,P_AUDTSTAMP =>l_audtstamp);
   END IF;

   IF BITAND(DEST_TYPE,DEST_BUFFER) = DEST_LOCAL
      THEN 
         INS_AUD_SESS2LOG(P_SESS_CTX  => l_sessctx
                          ,P_AUDSEQ    => l_audseq
                          ,P_AUDTSTAMP => l_audtstamp);
   END IF;
   
   AUDSEQ    := l_audseq;    
   AUDTSTAMP := l_audtstamp;
   
   END;


BEGIN
INITIALIZE;   

END EX$AG_SEC_AUDIT_MGMT;
/
