Prompt drop Package EX$SECAG_AUD_API;
DROP PACKAGE EX$SECAG_AUD_API
/

Prompt Package EX$SECAG_AUD_API;
--
-- EX$SECAG_AUD_API  (Package) 
--
CREATE OR REPLACE PACKAGE        EX$SECAG_AUD_API
AS
   /*****************************************************************************
   * $Header EX$SECAG_AUD_API:HEADER $
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

   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC EXCEPTIONS $
   *****************************************************************************/
   BAD_ARGUMENT           EXCEPTION;  -- При вызове API метода используютс неверные аргументы
   SESS_DOES_NOT_EXISTS   EXCEPTION;  -- Сессия с указанным ID не существует
   SESS_TOO_MANY          EXCEPTION;  -- Найдено более одной сесии с указанным ID 

   --
   BAD_ARGUMENT_ERRCODE           CONSTANT PLS_INTEGER:= -29260;
   SESS_DOES_NOT_EXISTS_ERRCODE   CONSTANT PLS_INTEGER:= -29261;
   SESS_TOO_MANY_ERRCODE          CONSTANT PLS_INTEGER:= -29262;
   PRAGMA EXCEPTION_INIT(BAD_ARGUMENT,          -29260);
   PRAGMA EXCEPTION_INIT(SESS_DOES_NOT_EXISTS,  -29261);   
   PRAGMA EXCEPTION_INIT(SESS_TOO_MANY,         -29262);
   
   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC CONSTANTS $
   *****************************************************************************/

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
                         ,p_sessionid in            number default null);




--------------------------------------------------------------------------------


END EX$SECAG_AUD_API;
/
