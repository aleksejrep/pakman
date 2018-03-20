Prompt drop Package Body BS$_LOCK;
DROP PACKAGE BODY BS$_LOCK
/

Prompt Package Body BS$_LOCK;
--
-- BS$_LOCK  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        BS$_LOCK
AS
   /*****************************************************************************
   * $Header BS$_LOCK:BODY $
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
      GC_MODULE_NAME    CONSTANT RESNAME_ST := 'BS$_LOCK';

   /*****************************************************************************       
   * $PartHeader PACKAGE PRIVATE VARIABLES $
   *****************************************************************************/
   LResourceList LResourceTbl;
   
   /*****************************************************************************   
   * $PartHeader PRIVATE FUNCTIONS DECLARATIONS $
   *****************************************************************************/

   /*****************************************************************************
   * $Function BITOR $
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
    FUNCTION BITOR(LEFT IN PLS_INTEGER
                  ,RIGHT IN PLS_INTEGER)
    RETURN NUMBER IS
    BEGIN
        RETURN LEFT-BITAND(LEFT,RIGHT) + RIGHT;
    END;

   /*****************************************************************************
   * $Function BITXOR $
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
    FUNCTION BITXOR(LEFT IN PLS_INTEGER
                  ,RIGHT IN PLS_INTEGER)
    RETURN NUMBER
    IS
    BEGIN
        RETURN BITOR(LEFT,RIGHT)- BITAND(LEFT,RIGHT);
    END;

   /*****************************************************************************
   * $Function SETFLAGON $
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
    FUNCTION SETFLAGON(FLAGSET IN PLS_INTEGER
                      ,FLAG    IN PLS_INTEGER)
    RETURN PLS_INTEGER
    IS
    BEGIN
    RETURN BITOR(FLAGSET,FLAG);
    END;

   /*****************************************************************************
   * $Function SETFLAGOFF $
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
    FUNCTION SETFLAGOFF(FLAGSET IN PLS_INTEGER
                       ,FLAG    IN PLS_INTEGER)
    RETURN PLS_INTEGER
    IS
    L_MASK PLS_INTEGER := 2147483647;
    BEGIN
    RETURN BITAND(FLAGSET,BITXOR(L_MASK,FLAG));
    END;

   /*****************************************************************************
   * $Function ISFLAGON $
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
    FUNCTION ISFLAGON(FLAGSET IN PLS_INTEGER
                     ,FLAG    IN PLS_INTEGER)
    RETURN BOOLEAN
    IS
    IS_FLAGON BOOLEAN := FALSE;
    BEGIN
        IF BITAND(FLAGSET,FLAG) = FLAG THEN IS_FLAGON := TRUE; END IF;
        RETURN IS_FLAGON;
    END;

   /*****************************************************************************
   * $Function ISFLAGON $
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
    FUNCTION ISFLAGOFF(FLAGSET IN PLS_INTEGER
                     ,FLAG    IN PLS_INTEGER)
    RETURN BOOLEAN
    AS
    IS_FLAGOFF BOOLEAN := TRUE;
    BEGIN
        IF BITAND(FLAGSET,FLAG) = FLAG THEN IS_FLAGOFF := FALSE; END IF;
        RETURN IS_FLAGOFF;
    END;


   /*****************************************************************************
   * $Procedure AddLResource $
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
   PROCEDURE AddLResource(RESNAME in VARCHAR2)
   as
   l_resname RESNAME_ST := upper(RESNAME);
   l_resource LResource;
   begin
   
   --Проверяем что в таблицу нет ресурса с таким же именем
   if LResourceList.exists(l_resname) 
   then raise BS$_LOCK.resource_already_exists;
   end if;
   
   -- Инициализируем записи по ресурсу
   l_resource.RESNAME       := l_resname;
   l_resource.HANDLE        := null;
   l_resource.hid           := null;
   l_resource.lmode         := IDLE_MODE;
   l_resource.LTIMEOUT      := null;
   l_resource.LTSTAMP       := null;
   l_resource.HTSTAMP       := null;     
   LResourceList(l_resname) := l_resource;   
   end;

   /*****************************************************************************
   * $Procedure DelLResource $
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
   PROCEDURE DelLResource(RESNAME in VARCHAR2)
   as
   l_resname  RESNAME_ST := upper(RESNAME);
   l_resource LResource;
   begin

   --Проверяем что в таблице есть ресурс с указанным именем
   if not LResourceList.exists(l_resname) 
   then raise BS$_LOCK.resource_doesnot_exists;
   end if;

   -- Можно удалить тольок "неактивный"    ресурс 
   if LResourceList(l_resname).lmode > IDLE_MODE
   then raise bs$_lock.try_del_lcked_resource;
   end if;  
   
   LResourceList.delete(l_resname);
   
   end;

   /*****************************************************************************
   * $Procedure SetLResource $
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
   PROCEDURE SetLRMode(RESNAME in VARCHAR2
                         ,LMODE in INTEGER)
   as
   l_resname  RESNAME_ST := upper(RESNAME);
   l_resource LResource;
   begin

   --Проверяем что в таблице есть ресурс с указанным именем
   if not LResourceList.exists(l_resname) 
   then raise BS$_LOCK.resource_doesnot_exists;
   end if;
   
   LResourceList(l_resname).lmode   := LMODE;
   
   if LResourceList(l_resname).lmode > IDLE_MODE
   then LResourceList(l_resname).ltstamp := current_timestamp;
   else LResourceList(l_resname).ltstamp := null;
   end if;
      
   end;

   /*****************************************************************************
   * $Procedure SetLResource $
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
   PROCEDURE SetLRHandle(RESNAME in VARCHAR2
                        ,LHANDLE in VARCHAR2)
   as
   l_resname  RESNAME_ST := upper(RESNAME);
   begin

   --Проверяем что в таблице есть ресурс с указанным именем
   if not LResourceList.exists(l_resname) 
   then raise BS$_LOCK.resource_doesnot_exists;
   end if;
   
   -- Проверяем согласованность данных в записи
   if LResourceList(l_resname).lmode > IDLE_MODE
   then raise bs$_lock.resource_not_idle;
   end if;
   
   
   LResourceList(l_resname).handle  := LHANDLE;
   LResourceList(l_resname).HTSTAMP := CURRENT_TIMESTAMP;
   
   end;

   PROCEDURE AllLRHandle(RESNAME in VARCHAR2)
   as
   pragma autonomous_transaction;
   l_lhandle varchar2(128);
   l_resname RESNAME_ST := upper(RESNAME);
   begin
   DBMS_LOCK.ALLOCATE_UNIQUE(
                              LOCKNAME        => l_resname
                             ,LOCKHANDLE      => l_lhandle
                             ,EXPIRATION_SECS => BS$_LOCK.MAXEXPSECS
                              );
   SetLRHandle(l_resname,l_lhandle);
   exception
   when others
   then raise_application_error(unable_get_lhandle4res_errcd
                               ,'Error get handle'
                               ,true);
   end;

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
   RETURN INTEGER
   as
   l_rcode integer;
   l_resname RESNAME_ST := upper(RESNAME);
   l_request_res integer;
   begin
   
   -- Проверяем, если ресурс не был выделен 
   if not LResourceList.exists(l_resname)
   then AddLResource(RESNAME); -- Выделяем запись в таблице 
        AllLRHandle(RESNAME); -- Получем ссылку на блокировку
   end if;
   
   l_rcode := DBMS_LOCK.REQUEST(LOCKHANDLE        => LResourceList(l_resname).handle
                               ,LOCKMODE          => LOCKMODE 
                               ,TIMEOUT           => nvl(TIMEOUT,REQ_MAXWAIT)
                               ,RELEASE_ON_COMMIT => FALSE
                                );
    CASE 
    WHEN l_rcode = R_SUCCESS /* success */
    THEN SetLRMode(RESNAME,LOCKMODE);
    
    WHEN l_rcode = R_ALREADYOWN
    THEN if RAISERR then RAISE resource_already_lock_ss; end if;    
    
    WHEN l_rcode = R_TIMEOUT    /* timeout */
    THEN if RAISERR then RAISE bs$_lock.lresource_busy; end if;
    
    WHEN l_rcode = R_DEADLOCK   /* deadlock */
    THEN if RAISERR then RAISE bs$_lock.lresource_busy; end if;
    
    WHEN l_rcode = R_BADARGUMENT   /* parameter error */
    THEN RAISE bs$_lock.internal_eror;
        
    WHEN l_rcode = R_ILLHANDLE  /* illegal lockhandle */
    THEN  RAISE bs$_lock.internal_eror;
    
    ELSE NULL;
    END CASE;
    
   
   return l_rcode;
           
   end; 
   

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
                  )
   as
   l_rcode integer;
   l_resname RESNAME_ST := upper(RESNAME);
   l_request_res integer;
   l_ccode integer;
   begin
   
   -- Проверяем, если ресурс не был выделен 
   if not LResourceList.exists(l_resname)
   then AddLResource(RESNAME); -- Выделяем запись в таблице 
        AllLRHandle(RESNAME); -- Получем ссылку на блокировку
   end if;
   
   l_rcode := DBMS_LOCK.REQUEST(LOCKHANDLE        => LResourceList(l_resname).handle
                               ,LOCKMODE          => LOCKMODE 
                               ,TIMEOUT           => case ISNOWAIT when ISNOWAIT = true then 0 else  REQ_MAXWAIT end
                               ,RELEASE_ON_COMMIT => FALSE
                                );
    CASE 
    WHEN l_rcode = R_SUCCESS  /* success */
    THEN SetLRMode(RESNAME,LOCKMODE);

    WHEN l_rcode = R_ALREADYOWN
    THEN l_ccode := CONVERT(
                    RESNAME   => RESNAME
                   ,LOCKMODE  => LOCKMODE
                   ,TIMEOUT   => case ISNOWAIT when ISNOWAIT = true then null else  REQ_MAXWAIT end
                   ,RAISERR   => TRUE);
        
    WHEN l_rcode = R_TIMEOUT    /* timeout */
    THEN raise_application_error(lresource_busy_errcd,'timeout',true); --RAISE bs$_lock.lresource_busy;
    
    WHEN l_rcode = R_DEADLOCK   /* deadlock */
    THEN RAISE bs$_lock.lresource_busy;
    
    WHEN l_rcode = R_BADARGUMENT   /* parameter error */
    THEN RAISE bs$_lock.internal_eror;
        
    WHEN l_rcode = R_ILLHANDLE  /* illegal lockhandle */
    THEN  RAISE bs$_lock.internal_eror;
    
    ELSE NULL;
    END CASE;
 
   
   end; 



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
   RETURN INTEGER
   as
   l_resname RESNAME_ST := upper(RESNAME);
   l_rcode integer;
   begin
   -- Проверяем что в таблице есть ресурс с указанным именем
   if not LResourceList.exists(l_resname) 
   then raise BS$_LOCK.resource_doesnot_exists;
   end if;
   
   if LResourceList(l_resname).handle is not null
   then l_rcode := DBMS_LOCK.RELEASE(LOCKHANDLE => LResourceList(l_resname).handle);
   end if;
   
   SetLRMode(RESNAME,IDLE_MODE);
   if DROPHANDLE then DelLResource(RESNAME); end if;
   return l_rcode;
   end; 

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
   RETURN INTEGER
   as
   l_resname RESNAME_ST := upper(RESNAME);
   l_rcode integer;
   begin
   -- Проверяем, если ресурс не был выделен 
   if not LResourceList.exists(l_resname)
   then RAISE resource_doesnot_exists;
   end if;
   
   l_rcode := DBMS_LOCK.CONVERT(
                                LOCKHANDLE        => LResourceList(l_resname).handle
                               ,LOCKMODE          => LOCKMODE
                               ,TIMEOUT           => nvl(TIMEOUT, REQ_MAXWAIT )
                                );
    CASE 
    WHEN l_rcode = R_SUCCESS  /* success */
    THEN SetLRMode(RESNAME,LOCKMODE);

    WHEN l_rcode = R_NOTOWN
    THEN RAISE bs$_lock.internal_eror;
        
    WHEN l_rcode = R_TIMEOUT    /* timeout */
    THEN RAISE bs$_lock.lresource_busy;
    
    WHEN l_rcode = R_DEADLOCK   /* deadlock */
    THEN RAISE bs$_lock.lresource_busy;
    
    WHEN l_rcode = R_BADARGUMENT   /* parameter error */
    THEN RAISE bs$_lock.internal_eror;
        
    WHEN l_rcode = R_ILLHANDLE  /* illegal lockhandle */
    THEN  RAISE bs$_lock.internal_eror;
    
    ELSE NULL;
    END CASE;
    return l_rcode;
   end; 


BEGIN
INITIALIZE;   

END BS$_LOCK;
/
