Prompt drop Package EX$AG_SEC_SYSUSER_MGMT;
DROP PACKAGE EX$AG_SEC_SYSUSER_MGMT
/

Prompt Package EX$AG_SEC_SYSUSER_MGMT;
--
-- EX$AG_SEC_SYSUSER_MGMT  (Package) 
--
CREATE OR REPLACE PACKAGE EX$AG_SEC_SYSUSER_MGMT
AS
   /*****************************************************************************
   * $Header EX$AG_SEC_SYSUSER_MGMT:HEADER $
   *
   * $Component EX$_SEC$
   *
   * $Module EXTDBA $
   * 
   * $Project EXTDBA $
   * 
   * $Folder EXTDBA$
   *
   * $Workfile EXTDBA $
   * 
   * $Description 
   * ����� ����������� �������� � DDL ��������: 
   * "CREATE USER..."
   * "ALTER USER..."
   * "DROP USER..." 
   * $
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
   -- �������� ��������� ��� ��������� ������� (���-�� ��� ��������)
   EX$SC_INVALID_ARGUMENT   EXCEPTION; 
   PRAGMA EXCEPTION_INIT(EX$SC_INVALID_ARGUMENT,-20001);
   
   -- ������������ SQL �������� � �������
   EX$SC_UNABLE_EXEC_DSQL   EXCEPTION;
   PRAGMA EXCEPTION_INIT(EX$SC_UNABLE_EXEC_DSQL,-20002);

   -- ��������� ������������ �� ������
   EX$SC_USER_WSN_DOESNOTEX EXCEPTION; 
   PRAGMA EXCEPTION_INIT(EX$SC_USER_WSN_DOESNOTEX,-20003);

   -- ��������� ���� �� �������
   EX$SC_ROLE_WSN_DOESNOTEX EXCEPTION; 
   PRAGMA EXCEPTION_INIT(EX$SC_ROLE_WSN_DOESNOTEX,-20004);


   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC CONSTANTS $
   *****************************************************************************/
   -- ����� �������� ������� ������ ������������ SYS.USER$.ASTATUS
   AST_OPEN     CONSTANT PLS_INTEGER := 0;
   AST_PASSWEXP CONSTANT PLS_INTEGER := 1;
   AST_LOCKED   CONSTANT PLS_INTEGER := 8;
   
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
   * $Procedure SET_ASTATUS $
   *
   * $Purpose
   * ��������� ��� ������
   * "ALTER USER <USER_NAME> ACCOUNT LOCK/UNLOCK" �����������/�������������� ������������
   * "ALTER USER <USER_NAME> PASSWORD EXPIRED"    �������� ������ ��� ������������
   * $
   * $Note  
   * ��������� �������� ��� 
   * ��������� P_STATUS:
   * 1) AST_OPEN     : �������������� ��. ������ ������������
   * 2) AST_PASSWEXP : �������� ������ ��� ������������.
   * 3) AST_LOCKED   : ������������� ��. ������
   * ��� �� �������� ����������:
   * 4) AST_OPEN + AST_PASSWEXP
   * 5) AST_LOCKED + AST_PASSWEXP
   * !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
   *
   * $
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * $
   *****************************************************************************/
   PROCEDURE SET_ASTATUS(P_UNAME  IN VARCHAR2
                        ,P_STATUS IN PLS_INTEGER
                         );

   /*****************************************************************************
   * $Procedure SET_PASSVALUE $
   *
   * $Purpose
   * ��������� ��� ������
   * "ALTER USER <USER_NAME> IDENTIFIED BY VALUES <PWD_HASH>"
   * ������������� ������� ���� ������
   *  !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
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
                           );

   

--------------------------------------------------------------------------------


END EX$AG_SEC_SYSUSER_MGMT;
/
