Prompt drop Package BS$_LOCK;
DROP PACKAGE BS$_LOCK
/

Prompt Package BS$_LOCK;
--
-- BS$_LOCK  (Package) 
--
CREATE OR REPLACE PACKAGE        BS$_LOCK
AS
   /*****************************************************************************
   * $Header BS$_LOCK:HEADER $
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
   SUBTYPE RESNAME_ST IS VARCHAR2(128);
   
   TYPE LResource IS RECORD
   (RESNAME   RESNAME_ST
   ,HANDLE    RESNAME_ST
   ,HID       NUMBER
   ,STATE     INTEGER
   ,LMODE     INTEGER
   ,LTIMEOUT  INTEGER
   ,LTSTAMP   TIMESTAMP
   ,HTSTAMP   TIMESTAMP
   );
   
   TYPE LResourceTbl is table of LResource index by RESNAME_ST; 
   
   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC EXCEPTIONS $
   *****************************************************************************/
   --
   resource_already_exists    exception;
   --
   resource_already_lock_ss   exception;
   --
   resource_doesnot_exists    exception;
   --
   try_del_lcked_resource     exception;
   --
   data_inconsyst_in_lres     exception;
   --
   resource_not_idle          exception;
   -- unable_get_lhandle4res
   unable_get_lhandle4res     exception;
   unable_get_lhandle4res_errcd constant integer := -20001;
   pragma exception_init(unable_get_lhandle4res,-20001);
   ---
   lresource_busy             exception;
   lresource_busy_errcd constant integer := -20002;
   pragma exception_init(lresource_busy,-20002);

   --
   internal_eror              exception;
   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC CONSTANTS $
   *****************************************************************************/
    ------------------------------------------------------------------------
    -- Интерфейсные константы для работы спользоватальскими блокировками DBMS_LOCK.*
    ------------------------------------------------------------------------            
    IDLE_MODE CONSTANT INTEGER  := 0;
    NL_MODE   CONSTANT INTEGER  := DBMS_LOCK.NL_MODE;  
    SS_MODE   CONSTANT INTEGER  := DBMS_LOCK.SS_MODE;    
    SX_MODE   CONSTANT INTEGER  := DBMS_LOCK.SX_MODE;    
    S_MODE    CONSTANT INTEGER  := DBMS_LOCK.S_MODE;
    SSX_MODE  CONSTANT INTEGER  := DBMS_LOCK.SSX_MODE;
    X_MODE    CONSTANT INTEGER  := DBMS_LOCK.X_MODE;   
    --
    REQ_MAXWAIT CONSTANT INTEGER  := DBMS_LOCK.maxwait;
    MAXEXPSECS  CONSTANT INTEGER  := 864000;

    --
    --
    --  held  get->  NL   SS   SX   S    SSX  X
    --  NL           SUCC SUCC SUCC SUCC SUCC SUCC
    --  SS           SUCC SUCC SUCC SUCC SUCC fail
    --  SX           SUCC SUCC SUCC fail fail fail
    --  S            SUCC SUCC fail SUCC fail fail
    --  SSX          SUCC SUCC fail fail fail fail
    --  X            SUCC fail fail fail fail fail
    --
    -- Коды возврата для API DBMS_LOCK
    R_SUCCESS     CONSTANT INTEGER := 0;
    R_TIMEOUT     CONSTANT INTEGER := 1;
    R_DEADLOCK    CONSTANT INTEGER := 2;
    R_BADARGUMENT CONSTANT INTEGER := 3;
    R_ALREADYOWN  CONSTANT INTEGER := 4;
    R_NOTOWN      CONSTANT INTEGER := 4;
    R_ILLHANDLE   CONSTANT INTEGER := 5;
    ------------------------------------------------------------------------            
    -- Флаги состояния записи блокировки 
    S_INIT      CONSTANT PLS_INTEGER := 0;
    S_HANDLED   CONSTANT PLS_INTEGER := 1;
    S_LOCKED    CONSTANT PLS_INTEGER := 2;
    
    
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


   /*****************************************************************************
   * $Function REQUEST $
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
   FUNCTION REQUEST(
                    RESNAME   IN VARCHAR2
                   ,LOCKMODE  IN INTEGER DEFAULT X_MODE
                   ,TIMEOUT   IN INTEGER DEFAULT NULL
                   ,RAISERR   IN BOOLEAN DEFAULT FALSE
                   )
   RETURN INTEGER;

   /*****************************************************************************
   * $Function RLOCK $
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
   PROCEDURE LOCKRES(
                   RESNAME   IN VARCHAR2
                  ,LOCKMODE  IN INTEGER DEFAULT X_MODE
                  ,ISNOWAIT  IN BOOLEAN DEFAULT FALSE
                  );


   /*****************************************************************************
   * $Function RELEASE $
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
   FUNCTION RELEASE(
                    RESNAME    IN VARCHAR2
                   ,RAISERR    IN BOOLEAN DEFAULT FALSE
                   ,DROPHANDLE IN BOOLEAN DEFAULT FALSE
                   )
   RETURN INTEGER;

   /*****************************************************************************
   * $Function CONVERT $
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
   FUNCTION CONVERT(
                    RESNAME   IN VARCHAR2
                   ,LOCKMODE  IN INTEGER DEFAULT X_MODE
                   ,TIMEOUT   IN INTEGER DEFAULT NULL
                   ,RAISERR   IN BOOLEAN DEFAULT FALSE
                   )
   RETURN INTEGER;
   

--------------------------------------------------------------------------------


END BS$_LOCK;
/
