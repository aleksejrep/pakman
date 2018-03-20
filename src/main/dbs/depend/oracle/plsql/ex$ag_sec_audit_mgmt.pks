Prompt drop Package EX$AG_SEC_AUDIT_MGMT;
DROP PACKAGE EX$AG_SEC_AUDIT_MGMT
/

Prompt Package EX$AG_SEC_AUDIT_MGMT;
--
-- EX$AG_SEC_AUDIT_MGMT  (Package) 
--
CREATE OR REPLACE PACKAGE        EX$AG_SEC_AUDIT_MGMT
AS
   /*****************************************************************************
   * $Header EX$AG_SEC_AUDIT_MGMT:HEADER $
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
   TYPE SESSCTX_RTYPE IS RECORD
  (
  LOGON_TIME         DATE,
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
  JOB_OWNER          VARCHAR2(64 BYTE),
  JOB_NAME           VARCHAR2(64 BYTE),
  JOB_SUBNAME        VARCHAR2(64 BYTE),
  SESS_TYPE          VARCHAR2(64 BYTE)
  );

   TYPE BGROUP_RTYPE IS RECORD(
    TYPE#       BINARY_DOUBLE,
    GROUP#      NUMBER(2),
    GROUPSPARE  NUMBER,
    STATE       VARCHAR2(64),
    IS_CURRENT  CHAR(1 BYTE),
    FLAGS       BINARY_DOUBLE,
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


   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC EXCEPTIONS $
   *****************************************************************************/
   EX_SESS_DOES_NOT_EXISTS EXCEPTION;
   
   EX_RESOURCE_BUSY EXCEPTION;
   PRAGMA EXCEPTION_INIT(EX_RESOURCE_BUSY,-54);
   
   /*****************************************************************************
   * $PartHeader PACKAGE PUBLIC CONSTANTS $
   *****************************************************************************/
   -----------------------------------------------------------------------------
   -- ���� ���� ���������� ��� ������ ������ ������
   -----------------------------------------------------------------------------
   
   -- ���������� ������ ������ ������:���.������:����. ������ 
   DEST_BUFFER CONSTANT PLS_INTEGER := 1;
   DEST_LOCAL  CONSTANT PLS_INTEGER := 2;
   DEST_GLOBAL CONSTANT PLS_INTEGER := 4;
   
   -- ���� SFLAGS ��� ������:
   -- EX$_SEC_AUD_SESS_BUFF
   -- EX$_SEC_AUD_SESS_LOG   
   -- EX$_SEC_AUD_DML_BUFF
   -- EX$_SEC_AUD_DML_LOG   
   -- ������ ��������� � EX$_SEC_AUD_*_BUFF (Default flags)
   RW_BUFFERED   CONSTANT PLS_INTEGER := 1;  
   -- ������ ��������� � EX$_SEC_AUD_*_LOG (Default flags)  
   RW_LOCAL     CONSTANT PLS_INTEGER := 2;  
   RW_GLOBAL    CONSTANT PLS_INTEGER := 4;  
   -- ��������� ������� �� ���� ��������� ������ EX$_SEC_AUD_*_LOG EX$_SEC_AUD_*_BUFF   
   RW_ERRORED    CONSTANT PLS_INTEGER := 8;  
   -- ������ ������ ������������ ������  ��� �������� ��������
   RW_MRFIRST    CONSTANT PLS_INTEGER := 16;   
   -- ������ ��������� ������������ ������  ��� �������� ��������
   RW_MRLAST     CONSTANT PLS_INTEGER := 32;   
   -- ������ ���������� � ���������� ������
   
   --flag
   RWF_INIT CONSTANT PLS_INTEGER := 0;
   
   -----------------------------------------------------------------------------
   -- ���� SFLAGS ������ ����� ��������� ��� ��������� ������ 
   -- EX$_SEC_AUD_BUFF_OPS: �������� "�������� �� ��������� ������"
   -- EX$_SEC_AUD_BUFF_GRP  �������� "��������� ������"
   -----------------------------------------------------------------------------   
   -- ������ ������ ���� ������������ ��� ������ ���������
   -- ������������, shared � �.�.
   -----------------------------------------------------------------------------   
   IS_EXCLUSIVE   CONSTANT PLS_INTEGER := 1; -- X0   
   -- �������� ����� ������� ��� ���������� �������� �������������
   -- IS_NEMODE1  CONSTANT PLS_INTEGER := 2; -- X1       
   -- IS_NEMODE2  CONSTANT PLS_INTEGER := 4; -- X2  
   -- IS_NEMODE3  CONSTANT PLS_INTEGER := 8; -- X3 

   -----------------------------------------------------------------------------
   -- ����� ��������� ��������� ��� �������� ����� � ��������
   -----------------------------------------------------------------------------   
   --  ���-�� ������ � EX$_SEC_AUD_BUFF_GRP. ������ �������� ������� ��� ������ ������
   IS_CURRENT        CONSTANT PLS_INTEGER := 17; --16 +1 
   --  ������ �������������� �������� ������� �� EX$_SEC_AUD_BUFF_OPS. ��� �� ���� ���������� ������.
   IS_PROCESSING     CONSTANT PLS_INTEGER := 32;  
   --  ������ ����������������� �������� ������� �� EX$_SEC_AUD_BUFF_OPS. ��� �� ���� ���������� ������.
   IS_RECOVER        CONSTANT PLS_INTEGER := 65; --64 +1 
   --  ������ ������������� �������� ������� �� EX$_SEC_AUD_BUFF_OPS. ��� �� ���� ���������� ������.
   IS_MAINTENANCE    CONSTANT PLS_INTEGER := 129; --128 +1 
   -- -- ������ �� ����� �������� �����. ������ �� �������. ��� ��������.
   IS_IDLE           CONSTANT PLS_INTEGER := 0;
   -- -- �������� ���������
   IS_COMPLETE           CONSTANT PLS_INTEGER := 0;

   -- �������� ����� ��������� ���������� ��� ���������� �������� �������������
   -- IS_STATENAME1    CONSTANT PLS_INTEGER := 256;  --  Both GRP and OPS     
   -- IS_STATENAME2    CONSTANT PLS_INTEGER := 512;  --  Both GRP and OPS     
   -- IS_STATENAME3    CONSTANT PLS_INTEGER := 1024; --  Both GRP and OPS     
   -- IS_STATENAME3    CONSTANT PLS_INTEGER := 2048; --  Both GRP and OPS     

   -----------------------------------------------------------------------------
   -- FLAGS ��������: �������� ��������� �����            
   -- EX$_SEC_AUD_BUFF_GRP
   -----------------------------------------------------------------------------
   -- ������� ���� ��� ��������� ������ �������                                                              
   IS_CLEANED    CONSTANT PLS_INTEGER := 1;  
   -- ������� ���� ��� ��������� ������ "�������" ��������� �������������� ��� ������������                                                              
   IS_BROKEN     CONSTANT PLS_INTEGER := 2;  
   -- �������: ������ ��������������. ���� ���� �� ��������� � ��� ������ ����� ������� ������
   IS_REGISTERED CONSTANT PLS_INTEGER := 4; 
   -- �������: ������ ����������������. ���� ���� �� ��������� � ��� ������ ����� ������� ������
   IS_CREATED    CONSTANT PLS_INTEGER := 8; 
   -- ������� ����� �� ������ �������������� ���������� ����������
   IS_LOCAL      CONSTANT PLS_INTEGER := 16; 
   -- ������� ����� �� ������ �������������� ��������� ����������
   IS_REMOTE     CONSTANT PLS_INTEGER := 32; 

   -- ���� OPCODE �:
   -- ������� EX$_SEC_AUD_BUFF_OPS    -- ���� ��������. 
   -- ��������� ���������� ������ ��������  � ������� EX$_SEC_AUD_BUFF_OPS_OPMAP   
   OPS_MERGE      CONSTANT PLS_INTEGER  := 1; 
   OPS_DELETE     CONSTANT PLS_INTEGER  := 2; 
   OPS_TRANCATE   CONSTANT PLS_INTEGER  := 4;
   OPS_UPDATE     CONSTANT PLS_INTEGER  := 8; 
   OPS_INSERT     CONSTANT PLS_INTEGER  := 16; 
   OPS_MANUAL     CONSTANT PLS_INTEGER  := 32; 

   -- ���� ��� ���� EX$_SEC_AUD_BUFF_OPS.UNITS
   OPS_UNT_ROWS  CONSTANT INTEGER := 1;
   OPS_UNT_BYTES CONSTANT INTEGER := 2;
   OPS_UNT_STEPS CONSTANT INTEGER := 3;   

    ------------------------------------------------------------------------
    -- ���� ������. ���� ������������� ��������
    ------------------------------------------------------------------------    
    EVENT_LOGON     CONSTANT PLS_INTEGER := 1;
    EVENT_DDL       CONSTANT PLS_INTEGER := 2;
    --------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- ������������ ��������� ��� ������ ������������������ ������������ DBMS_LOCK.*
    ------------------------------------------------------------------------            
    LOCK_NL_MODE  CONSTANT INTEGER := 1;
    LOCK_SS_MODE  CONSTANT INTEGER := 2;    
    LOCK_SX_MODE  CONSTANT INTEGER := 3;    
    LOCK_S_MODE   CONSTANT INTEGER := 4;
    LOCK_SSX_MODE CONSTANT INTEGER := 5;
    LOCK_X_MODE   CONSTANT INTEGER := 6;
    --
    LOCK_MAXWAIT    CONSTANT INTEGER  := 300;
    --
    LOCK_MAXEXPSECS CONSTANT INTEGER  := 43200;
    --
    --  held  get->  NL   SS   SX   S    SSX  X
    --  NL           SUCC SUCC SUCC SUCC SUCC SUCC
    --  SS           SUCC SUCC SUCC SUCC SUCC fail
    --  SX           SUCC SUCC SUCC fail fail fail
    --  S            SUCC SUCC fail SUCC fail fail
    --  SSX          SUCC SUCC fail fail fail fail
    --  X            SUCC fail fail fail fail fail
    --
    -- Lock request ���� ��������
    LOCK_REQC_SUCCESS    CONSTANT INTEGER := 0;
    LOCK_REQC_TIMEOUT    CONSTANT INTEGER := 1;
    LOCK_REQC_DEADLOCK   CONSTANT INTEGER := 2;
    LOCK_REQC_PARERROR   CONSTANT INTEGER := 3;
    LOCK_REQC_ALREADYOWN CONSTANT INTEGER := 4;
    LOCK_REQC_ILLHANDLE  CONSTANT INTEGER := 5;
    ------------------------------------------------------------------------            

   
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
   * $Function SESS_LOG $
   *
   * $Purpose
   * ������� ������ ������ ������ � ������� ������: ��������� ��� ���������
   * � �������� ������ ����� ������� ������.
   * ����� �������������� � DATABASE AFTER LOGON ��������
   * 
   * $
   * $Note  
   * !!! ��������: ����������� � ���������� ����������. 
   * !!! ��������: �� ����� ����� ������ ��������� ����� RESUMABLE ��� �����
   * 
   * 
   * ��� ������������� ������� ������ ������ � ��������� ������� ��������� �������
   * ������ � ���
   * $
   * $Parameter
   *
   * NAME   TYPE  IN/OUT    RETURN    DEFAULT   DESCRIPTION
   * DEST_TYPE                                  AUDLOG_BUFFER ��� AUDLOG_LOG
   * AUDSEQ                                     ��������� ������������� ������ ������ ��� ������ ��
   * ERR_CALL_BACK                              ������������ ���������� ��� ������������� ������ ������
   * $
   *****************************************************************************/
   PROCEDURE SESS_LOG(DEST_TYPE     IN PLS_INTEGER DEFAULT DEST_BUFFER
                     ,AUDSEQ        OUT NUMBER
                     ,AUDTSTAMP     OUT TIMESTAMP
                     ,ERR_CALL_BACK IN BOOLEAN     DEFAULT TRUE
                      );
      
END;
/
