PROMPT  --------------------------------------------------------------------#
PROMPT  -- file ex$sec_agent_drv_ora.pks
PROMPT  -- EX$SEC_AGENT_DRV_ORA (ORACLE PACKAGE HEADER)
PROMPT  -- NOTE:  
PROMPT  --------------------------------------------------------------------#

CREATE OR REPLACE PACKAGE EX$SEC_AGENT_DRV_ORA
AS

   /*
   **  $Header EX$SEC_AGENT_DRV_ORA:HEADER version[0.4] $
   **  $Documentation View developer manual 
   **  ����� ����������� �������� � DDL ��������:
   **  "CREATE USER..."
   **  "ALTER USER..."
   **  "DROP USER..." $
   */


   -------------------------------------------------------------------------------
   -- Public types
   -------------------------------------------------------------------------------
	TYPE UsrNameTbl IS TABLE OF VARCHAR2 ( 64 ) INDEX BY PLS_INTEGER;

   ---------------------------------------------------------------------------------------------------------------------
   -- Public exceptions
   ---------------------------------------------------------------------------------------------------------------------
	-- �������� ��������� ��� ��������� ������� (���-�� ��� ��������)
	invalid_argument exception;
	invalid_argument_err integer := -20001;
	pragma exception_init (invalid_argument,-20001 );

	-- ������������ SQL �������� � �������
	unable_exec_dsql exception;
	unable_exec_dsql_err integer := -20002;
	pragma exception_init (unable_exec_dsql,-20002 );

	-- ��������� ������������ �� ������
	user_not_found exception;
	user_not_found_err integer := -20003;
	pragma exception_init (user_not_found,-20003 );

	-- ��������� ���� �� �������
	role_not_found exception;
	role_not_found_err integer := -20004;
	pragma exception_init (role_not_found,-20004 );

	-- ����������� ������� ��� ����������
	profile_already_exists exception;
	profile_already_exists_err integer := -20005;
	pragma exception_init (profile_already_exists,-20005 );


   ---------------------------------------------------------------------------------------------------------------------
   -- Public constants
   ---------------------------------------------------------------------------------------------------------------------
	-- ����� �������� ������� ������ ������������ SYS.USER$.ASTATUS
	ast_open     constant pls_integer := 0;
	ast_passwexp constant pls_integer := 1;
	ast_locked   constant pls_integer := 8;

	rp_nocollect constant pls_integer := 0;
	rp_collect   constant pls_integer := 1;
	rp_logging   constant pls_integer := 2;

   ---------------------------------------------------------------------------------------------------------------------
   -- Public variables
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- Public functions declarations
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   --
   -- PURPOSE:
   -- ������������� ������. �� ����������� � ������ �������� ������.
   --
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --
   -------------------------------------------------------------------------------
	procedure initialize;

   -------------------------------------------------------------------------------
   -- PROCEDURE: GET_VERSION
   --
   -- PURPOSE:
   -- ������������� ������. �� ����������� � ������ �������� ������.
   --
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --
   -------------------------------------------------------------------------------
	function get_version return varchar2;

   -------------------------------------------------------------------------------
   -- PROCEDURE: GET_MNAME
   --
   -- PURPOSE:
   -- ������������� ������. �� ����������� � ������ �������� ������.
   --
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --
   -------------------------------------------------------------------------------
	function get_mname return varchar2;


   -------------------------------------------------------------------------------
   -- PROCEDURE: SET_ASTATUS
   --
   -- PURPOSE:
   --   "ALTER USER <USER_NAME> ACCOUNT LOCK/UNLOCK" �����������/�������������� ������������
   --   "ALTER USER <USER_NAME> PASSWORD EXPIRED"    �������� ������ ��� ������������
   -- PARAMETERS:
   --   P_STATUS
   --        1. AST_OPEN     : �������������� ��. ������ ������������
   --        2. AST_PASSWEXP : �������� ������ ��� ������������.
   --        3. AST_LOCKED   : ������������� ��. ������
   --        ��� �� �������� ����������:
   --        4. AST_OPEN + AST_PASSWEXP
   --        5. AST_LOCKED + AST_PASSWEXP
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --   !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
   -------------------------------------------------------------------------------
	procedure set_astatus (p_uname  in varchar2
                          ,p_status in pls_integer);

   -------------------------------------------------------------------------------
   -- PROCEDURE: SET_PASSVALUE
   --
   -- PURPOSE:
   --  ��������� ��� ������
   --  "ALTER USER <USER_NAME> IDENTIFIED BY VALUES <PWD_HASH>"
   --  ������������� �������� ���� ������
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --   !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
   -------------------------------------------------------------------------------
	procedure set_passvalue (p_uname	 in varchar2
	                        ,p_passvalue in varchar2
	                        ,p_isexpire	 in boolean default false);

   -------------------------------------------------------------------------------
   -- PROCEDURE: SET_PASSWORD
   --
   -- PURPOSE:
   --  ��������� ��� ������
   --  "ALTER USER <USER_NAME> IDENTIFIED BY <PWD_HASH>"
   --  �������������  ������
   -- PARAMETERS:
   --   P_STATUS
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --   !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
   -------------------------------------------------------------------------------
	procedure set_password (p_uname	   in varchar2
	                       ,p_password in varchar2);


   -------------------------------------------------------------------------------
   -- PROCEDURE: RESET_PTIME
   --
   -- PURPOSE:
   -- ���������� ���� ����� ������ ��� ������������ �� ������� ����
   -- �������� �� ���������� ��������
   -- 1) ������� ��������� ������� Oracle Profile �� ���������� ��������
   --     CREATE PROFILE "P_TMP_RPT<SESSIONID>_<N>" LIMIT
   --     SESSIONS_PER_USER UNLIMITED
   --     CPU_PER_SESSION UNLIMITED
   --     CPU_PER_CALL UNLIMITED
   --     CONNECT_TIME UNLIMITED
   --     IDLE_TIME UNLIMITED
   --     LOGICAL_READS_PER_SESSION UNLIMITED
   --     LOGICAL_READS_PER_CALL UNLIMITED
   --     COMPOSITE_LIMIT UNLIMITED
   --     PRIVATE_SGA UNLIMITED
   --     FAILED_LOGIN_ATTEMPTS UNLIMITED
   --     PASSWORD_LIFE_TIME UNLIMITED
   --     PASSWORD_REUSE_TIME UNLIMITED  -- !!! ��������� �������� ������ ��� ������ ���������
   --     PASSWORD_REUSE_MAX UNLIMITED   -- !!! ��������� �������� ������ ��� ������ ���������
   --     PASSWORD_LOCK_TIME UNLIMITED
   --     PASSWORD_GRACE_TIME UNLIMITED
   --     PASSWORD_VERIFY_FUNCTION NULL
   --  2) ������ �������������� ������������ ������� �� ����� ���������
   --  3) ��������� ALTER USER <USERNAME> IDENTIFIED BY VALUES <CURRENT_PASSWORD>
   --  4) ���� SYS.USER$.PTIME ������������� ������������ �� ������� ����� ���� (3)
   --  5) ������ ������������ ������� ��� �������
   --  6) ������� ��������� �������
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --   !!!DDL SQL ����������� � ���������� ���������� ���� ������� � �������
   -------------------------------------------------------------------------------
	procedure reset_ptime (uname   in varchar2
	                      ,pname   in varchar2 default null
	                      ,opsmode in pls_integer default null);

	procedure reset_ptime (unamelist in out nocopy usrnametbl
	                      ,opsmode	 in            pls_integer default null);

	procedure reset_ptime (uprofile in varchar2
	                      ,opsmode  in pls_integer default null);
--------------------------------------------------------------------------------


END EX$SEC_AGENT_DRV_ORA;