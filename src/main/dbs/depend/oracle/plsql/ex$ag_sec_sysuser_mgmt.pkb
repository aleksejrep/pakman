Prompt drop Package Body EX$AG_SEC_SYSUSER_MGMT;
DROP PACKAGE BODY EX$AG_SEC_SYSUSER_MGMT
/

Prompt Package Body EX$AG_SEC_SYSUSER_MGMT;
--
-- EX$AG_SEC_SYSUSER_MGMT  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EX$AG_SEC_SYSUSER_MGMT
AS
   /*****************************************************************************
   * $Header EX$AG_SEC_SYSUSER_MGMT:BODY $
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
      GC_MODULE_VERSION CONSTANT VARCHAR2(16) := '1.2.0.0';  
      GC_MODULE_NAME    CONSTANT VARCHAR2(64) := 'EX$_SEC_USER_MGMT';  

   /*****************************************************************************       
   * $PartHeader PACKAGE PRIVATE VARIABLES $
   *****************************************************************************/

   /*****************************************************************************   
   * $PartHeader PRIVATE FUNCTIONS DECLARATIONS $
   *****************************************************************************/

   /*****************************************************************************
   * $Function USER_IS_EXISTS $
   *
   * $Purpose$
   *
   * $Note  
   * Проверяет присутвует или нет в БД пользователь переданый в аргументах
   *
   * $
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
   FUNCTION USER_IS_EXISTS(P_UNAME IN VARCHAR2) RETURN BOOLEAN
   AS
   l_usr_cnt integer := 0;
   l_ret     boolean := false;
   BEGIN
   
   SELECT COUNT(1)  INTO l_usr_cnt FROM DBA_USERS WHERE USERNAME = P_UNAME;
   IF l_usr_cnt > 0 THEN l_ret := TRUE; END IF;
   
   RETURN l_ret;
   END;

   /*****************************************************************************
   * $Function DSQL_EXECUTE $
   *
   * $Purpose
   * Выполняет динамический SQL переданный в параметрах
   * $
   *
   * $Note Выполняется в атономной транзакции 
   * !!!НИКОГДА НЕ ДЕЛАЙТЕ ЭТУ ФУНКЦИЮ public НЕ ДОБАВЛЯЙТЕ ЕЁ В ЗАГОЛОВОК ПАКЕТА
   * $
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
   PROCEDURE DSQL_EXECUTE(P_SQL_TXT IN VARCHAR2) 
   AS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_sql_cursor integer;
   l_sql_ret integer;
   --
   l_errcode   number;
   l_errmsg    varchar2(2000);   
   l_errexmsg  varchar2(512);
   BEGIN
   
   l_sql_cursor := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(l_sql_cursor, P_SQL_TXT , DBMS_SQL.NATIVE);
   l_sql_ret := DBMS_SQL.EXECUTE(l_sql_cursor);
   DBMS_SQL.CLOSE_CURSOR(l_sql_cursor);     
   EXCEPTION   
    WHEN OTHERS
    THEN 
         IF DBMS_SQL.IS_OPEN(l_sql_cursor) THEN  DBMS_SQL.CLOSE_CURSOR(l_sql_cursor); END IF;
         l_errcode  := SQLCODE;
         l_errmsg   := SUBSTR(SQLERRM, 1 , 1024);
         l_errexmsg := 'Unable execute dynamic sql.';
         RAISE_APPLICATION_ERROR(-20002,l_errexmsg 
                                || chr(10) ||'SQL_TXT:'  || P_SQL_TXT
                                || chr(10) ||'CODE:' || to_char(l_errcode)
                                || chr(10) ||'MSG:'  || l_errmsg );
                                 
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
   * $Function SET_ACCOUNT_STATUS $
   *
   * $Purpose
   * Интерфейс для команд
   * "ALTER USER <USER_NAME> ACCOUNT LOCK/UNLOCK"
   * "ALTER USER <USER_NAME> PASSWORD EXPIRED"
   * $
   * $Note This function execution in package body pl/sql block $
   *
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   PROCEDURE SET_ASTATUS(P_UNAME  IN VARCHAR2
                        ,P_STATUS IN PLS_INTEGER
                         )
   AS
   
   -- Возможные команды для процедуры
   l_sql_open VARCHAR2(4000) := 'ALTER USER "<USERNAME>" ACCOUNT UNLOCK';
   l_sql_pexp VARCHAR2(4000) := 'ALTER USER "<USERNAME>" PASSWORD EXPIRE';
   l_sql_lock VARCHAR2(4000) := 'ALTER USER "<USERNAME>" ACCOUNT LOCK';
   l_sql_txt  VARCHAR2(4000) := ' ';
   -- Коллекция таблица с возможными комбинациями комманд
   TYPE l_sql_tt is table of varchar2(2000) index by PLS_INTEGER;
   l_sql_list l_sql_tt;
   -- Переменные для обработки ошибок
   l_errcode   number;
   l_errmsg    varchar2(2000); 
   l_errexmsg  varchar2(2000);   
   BEGIN
   -- Заполянем таблицу возможных комбинаций команд
   l_sql_list(AST_OPEN)     := l_sql_open;
   l_sql_list(AST_PASSWEXP) := l_sql_pexp;
   l_sql_list(AST_LOCKED)   := l_sql_lock;

   -- Проверяем входной параметр ФЛАГ СТАТУСА P_STATUS
   IF not l_sql_list.EXISTS(P_STATUS)
      THEN l_errexmsg := 'Invalid argument P_STATUS:' || P_STATUS;
           RAISE EX$SC_INVALID_ARGUMENT;
   END IF;

   -- Проверяем существует ли пользователь указанный в парамтерах
   IF NOT USER_IS_EXISTS(P_UNAME) 
      THEN l_errexmsg := 'User does not exist P_UMANE:' || P_UNAME;
           RAISE EX$SC_USER_WSN_DOESNOTEX; END IF;   
   
   -- Формируем строку для выполнения подставляя имя пользователя в команду
   l_sql_txt := replace(l_sql_list(P_STATUS),'<USERNAME>',UPPER(P_UNAME));
   
   -- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
   -- При ошибке процедура генерирует EX$SC_UNABLE_EXEC_DSQL,-20002
   DSQL_EXECUTE(P_SQL_TXT => l_sql_txt);  
   
   EXCEPTION
   WHEN EX$SC_UNABLE_EXEC_DSQL OR EX$SC_INVALID_ARGUMENT OR EX$SC_USER_WSN_DOESNOTEX
   THEN 
   l_errexmsg := 'Error execute dynamic SQL';
   RAISE_APPLICATION_ERROR(-20000,'EX$SEC-0001: Unable set status for user.' || l_errexmsg,FALSE);
   WHEN OTHERS
   THEN
       l_errexmsg := 'Unhandled:CODE='||SQLCODE||'MSG:'||SUBSTR(SQLERRM,1,1024);
       RAISE_APPLICATION_ERROR(-20000,'EX$SEC-0001: Unable set status for user.' || l_errexmsg
                               ,TRUE);
   
   END;

   /*****************************************************************************
   * $Function SET_PASSVALUE $
   *
   * $Purpose
   * Интерфейс для команд
   * "ALTER USER <USER_NAME> IDENTIFIED BY VALUES <PWD_HASH>"
   * 
   * $
   * $Note This function execution in package body pl/sql block $
   *
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   PROCEDURE SET_PASSVALUE(P_UNAME     IN VARCHAR2
                          ,P_PASSVALUE IN VARCHAR2   
                          ,P_ISEXPIRE  IN BOOLEAN DEFAULT FALSE
                           )
   AS

   l_sql_ident VARCHAR2(4000) := 'ALTER USER "<USERNAME>" IDENTIFIED BY VALUES ''<PASSWORD>''';
   l_sql_txt   VARCHAR2(4000) := ' ';
   --
   l_errcode   number;
   l_errmsg    varchar2(2000);  
   l_errexmsg  varchar2(2000);   
   BEGIN
   
   -- Проверяем существует ли пользователь указанный в параметрах
   IF NOT USER_IS_EXISTS(P_UNAME) 
      THEN l_errexmsg := 'User does not exist P_UMANE:' || P_UNAME;
           RAISE EX$SC_USER_WSN_DOESNOTEX; END IF;   
   
   -- Формируем строку для выполнения подставляя имя пользователя в командуb и хеш значние пароля
   l_sql_txt := replace(replace(l_sql_ident,'<USERNAME>',UPPER(P_UNAME))
                       ,'<PASSWORD>'
                       ,P_PASSVALUE);
   
   -- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
   -- При ошибке процедура генерирует EX$SC_UNABLE_EXEC_DSQL,-20002
   DSQL_EXECUTE(P_SQL_TXT => l_sql_txt);  
   
   -- Ставим флаг смены пароля "PASSWORD EXPIRED"
   IF P_ISEXPIRE
      THEN SET_ASTATUS(P_UNAME => P_UNAME
                      ,P_STATUS => AST_PASSWEXP);
      END IF;
   
   EXCEPTION
   WHEN EX$SC_UNABLE_EXEC_DSQL OR EX$SC_INVALID_ARGUMENT OR EX$SC_USER_WSN_DOESNOTEX
   THEN 
   IF l_errexmsg IS NULL THEN
   l_errexmsg := 'Unhandled:CODE='||SQLCODE||'MSG:'||SUBSTR(SQLERRM,1,1024);
   END IF;
   RAISE_APPLICATION_ERROR(-20000,'EX$SEC-0001: Unable set password value for user.' || l_errexmsg,TRUE);
   WHEN OTHERS
   THEN
       l_errexmsg := 'Unhandled:CODE='||SQLCODE||'MSG:'||SUBSTR(SQLERRM,1,1024);
       RAISE_APPLICATION_ERROR(-20000,'EX$SEC-0001: Unable set password value for user.' || l_errexmsg
                               ,TRUE);
   
   END SET_PASSVALUE;


BEGIN
INITIALIZE;   

END EX$AG_SEC_SYSUSER_MGMT;
/
