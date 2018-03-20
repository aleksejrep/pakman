Prompt drop Package Body EX$SECAG_AUD_API;
DROP PACKAGE BODY EX$SECAG_AUD_API
/

Prompt Package Body EX$SECAG_AUD_API;
--
-- EX$SECAG_AUD_API  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        EX$SECAG_AUD_API
AS
   /*****************************************************************************
   * $Header EX$SECAG_AUD_API:BODY $
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
      GC_MODULE_NAME    CONSTANT VARCHAR2(64) := 'EX$SECAG_AUD_API';

   /*****************************************************************************       
   * $PartHeader PACKAGE PRIVATE VARIABLES $
   *****************************************************************************/

   /*****************************************************************************   
   * $PartHeader PRIVATE FUNCTIONS DECLARATIONS $
   *****************************************************************************/


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
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN GC_MODULE_NAME;
   END;

   /*****************************************************************************
   * $Function get_CSession $
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
   PROCEDURE get_CSession(p_csession  in out nocopy ex$secag_aud_type.CSession
                         ,p_sessionid in            number default null)
   as
   begin
      if p_sessionid <=0 
         then raise EX$SECAG_AUD_API.BAD_ARGUMENT; 
      end if; 
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
             ,IS_JOB
             ,JOB_OWNER
             ,JOB_NAME
             ,JOB_SUBNAME
             ,SESS_TYPE
   INTO 
              p_csession.LOGON_TIME
             ,p_csession.USER_NAME
             ,p_csession.USER_CODE
             ,p_csession.OSUSER
             ,p_csession.CLIENT_HOST
             ,p_csession.CLIENT_IP
             ,p_csession.TERMINAL
             ,p_csession.PROGRAM_SNAME
             ,p_csession.MODULE_SNAME
             ,p_csession.ACTION
             ,p_csession.CLIENT_INFO
             ,p_csession.CLIENT_IDENTIFIER
             ,p_csession.SERVER_HOST
             ,p_csession.SESS_ID
             ,p_csession.SESS_SERIAL#
             ,p_csession.SESS_AUDSID
             ,p_csession.SESS_SPID
             ,p_csession.SERVICE_NAME
             ,p_csession.DB_UNIQUE_NAME
             ,p_csession.SQL_TRACE
             ,p_csession.SQL_TRACE_WAITS
             ,p_csession.SQL_TRACE_BINDS
             ,p_csession.PROXY_USER
             ,p_csession.PROXY_USERID
             ,p_csession.ISDBA
             ,p_csession.DB_NAME
             ,p_csession.DB_DOMAIN
             ,p_csession.INSTANCE_NAME
             ,p_csession.IS_JOB
             ,p_csession.JOB_OWNER
             ,p_csession.JOB_NAME
             ,p_csession.JOB_SUBNAME
             ,p_csession.SESS_TYPE   
   FROM  EX$SECAG_CSESSION_ALL S
   WHERE S.SESS_AUDSID = NVL(p_sessionid,SYS_CONTEXT('USERENV','SESSIONID'))
   AND   S.SESS_TYPE = 'USR'; 
   exception 
   when no_data_found
   then raise EX$SECAG_AUD_API.SESS_DOES_NOT_EXISTS;
   when too_many_rows
   then raise EX$SECAG_AUD_API.SESS_TOO_MANY;
   end;
                         


BEGIN
INITIALIZE;   

END EX$SECAG_AUD_API;
/
