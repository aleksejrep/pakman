CREATE OR REPLACE PACKAGE BODY        TEMPLATE_PKG
AS
   /*
   **  $Header TEMPLATE_PKG:BODY version[0.4] $
   */

   -------------------------------------------------------------------------------
   -- Private types 
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- Private exceptions
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- Private constants
   -------------------------------------------------------------------------------
      GC_MODULE_VERSION CONSTANT VARCHAR2(16) := '1.0.0.0';  
      GC_MODULE_NAME    CONSTANT VARCHAR2(32) := 'TEMPLATE_PKG';  

   -------------------------------------------------------------------------------
   -- Private variables
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- Private functions declarations
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- Functions/Procedure definitions
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   -- CHANGE HISTORY:
   --
   --   Modified by           (MM/DD/YYYY)       Note
   --
   -------------------------------------------------------------------------------
   PROCEDURE INITIALIZE
   AS
   BEGIN
    NULL;
   END;

   -------------------------------------------------------------------------------
   -- FUNCTION: GET_VERSION
   -- CHANGE HISTORY:
   --
   --   Modified by           (MM/DD/YYYY)       Note
   --
   -------------------------------------------------------------------------------
   FUNCTION GET_VERSION
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN GC_MODULE_VERSION;
   END;

   -------------------------------------------------------------------------------
   -- FUNCTION: GET_MNAME
   -- CHANGE HISTORY:
   --
   --   Modified by           (MM/DD/YYYY)       Note
   --
   -------------------------------------------------------------------------------
   FUNCTION GET_MNAME
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN GC_MODULE_NAME;
   END;

BEGIN
INITIALIZE;   

END TEMPLATE_PKG;
/
