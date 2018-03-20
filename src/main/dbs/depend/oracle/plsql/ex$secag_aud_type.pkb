Prompt drop Package Body EX$SECAG_AUD_TYPE;
DROP PACKAGE BODY EX$SECAG_AUD_TYPE
/

Prompt Package Body EX$SECAG_AUD_TYPE;
--
-- EX$SECAG_AUD_TYPE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY        EX$SECAG_AUD_TYPE
AS
   /*****************************************************************************
   * $Header EX$SECAG_AUD_TYPE:BODY $
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
      GC_MODULE_NAME    CONSTANT VARCHAR2(64) := 'EX$SECAG_AUD_TYPE';

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


BEGIN
INITIALIZE;   

END EX$SECAG_AUD_TYPE;
/
