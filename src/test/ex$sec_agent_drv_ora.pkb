PROMPT  --------------------------------------------------------------------#
PROMPT  -- file ex$sec_agent_drv_ora.pkb
PROMPT  -- EX$SEC_AGENT_DRV_ORA (ORACLE PACKAGE BODY)
PROMPT  -- NOTE:  
PROMPT  --------------------------------------------------------------------#

CREATE OR REPLACE PACKAGE BODY EX$SEC_AGENT_DRV_ORA
AS

   /*
   **  $Header EX$SEC_AGENT_DRV_ORA:HEADER version[0.4] $
   **  $Documentation View developer manual 
   **  Пакет реализующий инерфейс к DDL командам:
   **  "CREATE USER..."
   **  "ALTER USER..."
   **  "DROP USER..." $
   */

   -------------------------------------------------------------------------------
   -- Private types
   -------------------------------------------------------------------------------


   ---------------------------------------------------------------------------------------------------------------------
   -- Private exceptions
   ---------------------------------------------------------------------------------------------------------------------

   ---------------------------------------------------------------------------------------------------------------------
   -- Private constants
   ---------------------------------------------------------------------------------------------------------------------
	gc_module_version constant varchar2 ( 16 ) := '1.2.1.0';
	gc_module_name    constant varchar2 ( 64 ) := 'EX$SEC_AGENT_DRV_ORA';

   ---------------------------------------------------------------------------------------------------------------------
   -- Private variables
   -------------------------------------------------------------------------------
	gc_resptime_profile varchar2 ( 128 );

   -------------------------------------------------------------------------------
   -- Public functions declarations
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- FUNCTION: USER_IS_EXISTS
   --
   -- PURPOSE:
   -- Проверяет существование пользователя с заданым именем.
   --
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   -------------------------------------------------------------------------------
    function user_is_exists ( p_uname in varchar2 ) return boolean
    as
        l_usr_cnt		integer := 0;
        l_ret 			boolean := false;
    begin
        select count ( 1 )
          into l_usr_cnt
          from dba_users
         where username = p_uname;

        if l_usr_cnt > 0
        then
            l_ret 		:= true;
        end if;

        return l_ret;
    end;

   -------------------------------------------------------------------------------
   -- FUNCTION: DSQL_EXECUTE
   --
   -- PURPOSE:
   -- Выполняет динамический SQL переданный в параметрах.
   --
   -- PARAMETERS:
   --
   -- EXCEPTIONS:
   --
   -- NOTE:
   -- !!!НИКОГДА НЕ ДЕЛАЙТЕ ЭТУ ФУНКЦИЮ public НЕ ДОБАВЛЯЙТЕ ЕЁ В ЗАГОЛОВОК ПАКЕТА
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   -------------------------------------------------------------------------------
	procedure dsql_execute ( p_sql_txt in varchar2 )
	as
		PRAGMA AUTONOMOUS_TRANSACTION;
		l_sql_cursor	integer;
		l_sql_ret		integer;
		--
		l_errcode		number;
		l_errmsg 		varchar2 ( 2000 );
		l_errexmsg		varchar2 ( 512 );
	begin
		l_sql_cursor := dbms_sql.open_cursor;
		dbms_sql.parse (l_sql_cursor,p_sql_txt,dbms_sql.native);
		l_sql_ret	:= dbms_sql.execute ( l_sql_cursor );
		dbms_sql.close_cursor ( l_sql_cursor );
	exception
		when others
		then
			if dbms_sql.is_open ( l_sql_cursor )
			then
				dbms_sql.close_cursor ( l_sql_cursor );
			end if;

			l_errcode	:= sqlcode;
			l_errmsg 	:= substr (sqlerrm,1,1024);
			l_errexmsg	:= 'Unable execute dynamic sql.';
			RAISE_APPLICATION_ERROR (-20002
								    ,l_errexmsg
									|| chr ( 10 )
									|| 'SQL_TXT:'
									|| p_sql_txt
									|| chr ( 10 )
									|| 'CODE:'
									|| to_char ( l_errcode )
									|| chr ( 10 )
									|| 'MSG:'
									|| l_errmsg);
	end;

   -------------------------------------------------------------------------------
   -- Public functions definitions $
   -------------------------------------------------------------------------------

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	procedure initialize
	as
	begin
		null;
	end;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: GET_VERSION
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	function get_version return varchar2
	as
	begin
		return gc_module_version;
	end;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: GET_MNAME
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	function get_mname return varchar2
	as
	begin
		return gc_module_name;
	end;


   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	procedure set_astatus (p_uname  in varchar2 
	                      ,p_status in pls_integer)
	as
    -- Возможные команды для процедуры
    l_sql_open varchar2 ( 4000 ) := 'ALTER USER "<USERNAME>" ACCOUNT UNLOCK';
	l_sql_pexp varchar2 ( 4000 ) := 'ALTER USER "<USERNAME>" PASSWORD EXPIRE';
    l_sql_lock varchar2 ( 4000 ) := 'ALTER USER "<USERNAME>" ACCOUNT LOCK'; 
    l_sql_txt  varchar2 ( 4000 ) := ' ';
    -- комбинациями комманд
    type l_sql_tt is table of varchar2 ( 2000 ) index by pls_integer;
    l_sql_list l_sql_tt;
	-- Переменные для обработки ошибок
	l_errcode		number;
	l_errmsg 		varchar2 ( 2000 );
	l_errexmsg		varchar2 ( 2000 );
	begin
		-- Заполянем таблицу возможных комбинаций команд
		l_sql_list(ast_open)     := l_sql_open;
		l_sql_list(ast_passwexp) := l_sql_pexp;
		l_sql_list(ast_locked)   := l_sql_lock;
		-- Проверяем входной параметр ФЛАГ СТАТУСА P_STATUS
		if not l_sql_list.exists ( p_status )
		then
			l_errexmsg	:= 'Invalid argument P_STATUS:' || p_status;
			raise invalid_argument;
		end if;
		-- Проверяем существует ли пользователь указанный в парамтерах
		if not user_is_exists ( p_uname )
		then
			l_errexmsg	:= 'User does not exist P_UMANE:' || p_uname;
			raise user_not_found;
		end if;
		-- Формируем строку для выполнения подставляя имя пользователя в команду
		l_sql_txt := replace (l_sql_list ( p_status )
						     ,'<USERNAME>'
						     ,upper ( p_uname ));
		-- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
		-- При ошибке процедура генерирует unable_exec_dsql,-20002
		dsql_execute ( p_sql_txt => l_sql_txt );
	exception
		when unable_exec_dsql or invalid_argument or user_not_found
		then
			l_errexmsg	:= 'Error execute dynamic SQL';
			RAISE_APPLICATION_ERROR (-20000
									,'EX$SEC-0001: Unable set status for user.'
									|| l_errexmsg
									,false);
		when others
		then
			l_errexmsg	:='Unhandled:CODE='
			            || sqlcode 
			            || 'MSG:'
				        || substr (sqlerrm,1,1024);
			RAISE_APPLICATION_ERROR (-20000
								    ,'EX$SEC-0001: Unable set status for user.'
									|| l_errexmsg
									,true);
	end;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: SET_PASSVALUE
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	PROCEDURE SET_PASSVALUE (
		P_UNAME			IN VARCHAR2
	  ,P_PASSVALUE 	IN VARCHAR2
	  ,P_ISEXPIRE		IN BOOLEAN DEFAULT FALSE
	)
	AS
		l_sql_ident 	VARCHAR2 ( 4000 )
			:= 'ALTER USER "<USERNAME>" IDENTIFIED BY VALUES ''<PASSWORD>''';
		l_sql_txt		VARCHAR2 ( 4000 ) := ' ';
		--
		l_errcode		NUMBER;
		l_errmsg 		VARCHAR2 ( 2000 );
		l_errexmsg		VARCHAR2 ( 2000 );
	BEGIN
		-- Проверяем существует ли пользователь указанный в параметрах
		IF NOT USER_IS_EXISTS ( P_UNAME )
		THEN
			l_errexmsg	:= 'User does not exist P_UMANE:' || P_UNAME;
			RAISE user_not_found;
		END IF;

		-- Формируем строку для выполнения подставляя имя пользователя в командуb и хеш значние пароля
		l_sql_txt	:=
			REPLACE (
						 REPLACE (
									  l_sql_ident
									 ,'<USERNAME>'
									 ,UPPER ( P_UNAME )
						 )
						,'<PASSWORD>'
						,P_PASSVALUE
			);

		IF P_PASSVALUE != 'GLOBAL'
		THEN
			-- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
			-- При ошибке процедура генерирует unable_exec_dsql,-20002
			DSQL_EXECUTE ( P_SQL_TXT => l_sql_txt );

			-- Ставим флаг смены пароля "PASSWORD EXPIRED"
			IF P_ISEXPIRE
			THEN
				SET_ASTATUS (
								  P_UNAME	  => P_UNAME
								 ,P_STATUS	  => AST_PASSWEXP
				);
			END IF;
		END IF;
	EXCEPTION
		WHEN unable_exec_dsql OR invalid_argument OR user_not_found
		THEN
			IF l_errexmsg IS NULL
			THEN
				l_errexmsg	:=
						'Unhandled:CODE='
					|| SQLCODE
					|| 'MSG:'
					|| SUBSTR (
									SQLERRM
								  ,1
								  ,1024
						);
			END IF;

			RAISE_APPLICATION_ERROR (
											  -20000
											 ,   'EX$SEC-0001: Unable set password value for user.'
											  || l_errexmsg
											 ,TRUE
			);
		WHEN OTHERS
		THEN
			l_errexmsg	:=
					'Unhandled:CODE='
				|| SQLCODE
				|| 'MSG:'
				|| SUBSTR (
								SQLERRM
							  ,1
							  ,1024
					);
			RAISE_APPLICATION_ERROR (
											  -20000
											 ,   'EX$SEC-0001: Unable set password value for user.'
											  || l_errexmsg
											 ,TRUE
			);
	END SET_PASSVALUE;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: SET_PASSWORD
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	PROCEDURE SET_PASSWORD (
		P_UNAME			IN VARCHAR2
	  ,P_PASSWORD		IN VARCHAR2
	)
	AS
		l_sql_ident 	VARCHAR2 ( 4000 )
								:= 'ALTER USER "<USERNAME>" IDENTIFIED BY <PASSWORD>';
		l_sql_txt		VARCHAR2 ( 4000 ) := ' ';
		--
		l_errcode		NUMBER;
		l_errmsg 		VARCHAR2 ( 2000 );
		l_errexmsg		VARCHAR2 ( 2000 );
	BEGIN
		-- Проверяем существует ли пользователь указанный в параметрах
		IF NOT USER_IS_EXISTS ( P_UNAME )
		THEN
			l_errexmsg	:= 'User does not exist P_UMANE:' || P_UNAME;
			RAISE user_not_found;
		END IF;

		-- Формируем строку для выполнения подставляя имя пользователя в командуb и хеш значние пароля
		l_sql_txt	:=
			REPLACE (
						 REPLACE (
									  l_sql_ident
									 ,'<USERNAME>'
									 ,UPPER ( P_UNAME )
						 )
						,'<PASSWORD>'
						,P_PASSWORD
			);

		IF P_PASSWORD != 'GLOBAL'
		THEN
			-- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
			-- При ошибке процедура генерирует unable_exec_dsql,-20002
			DSQL_EXECUTE ( P_SQL_TXT => l_sql_txt );
		END IF;
	EXCEPTION
		WHEN unable_exec_dsql OR invalid_argument OR user_not_found
		THEN
			IF l_errexmsg IS NULL
			THEN
				l_errexmsg	:=
						'Unhandled:CODE='
					|| SQLCODE
					|| 'MSG:'
					|| SUBSTR (
									SQLERRM
								  ,1
								  ,1024
						);
			END IF;

			RAISE_APPLICATION_ERROR (
											  -20000
											 ,   'EX$SEC-0001: Unable set password value for user.'
											  || l_errexmsg
											 ,TRUE
			);
		WHEN OTHERS
		THEN
			l_errexmsg	:=
					'Unhandled:CODE='
				|| SQLCODE
				|| 'MSG:'
				|| SUBSTR (
								SQLERRM
							  ,1
							  ,1024
					);
			RAISE_APPLICATION_ERROR (
											  -20000
											 ,   'EX$SEC-0001: Unable set password value for user.'
											  || l_errexmsg
											 ,TRUE
			);
	END;


	PROCEDURE CreateUnlimProfile ( pname IN VARCHAR2 )
	AS
		l_sql_cprl		VARCHAR2 ( 4000 )
								:= '
   CREATE PROFILE "<PROFILE_NAME>" LIMIT
   SESSIONS_PER_USER UNLIMITED
   CPU_PER_SESSION UNLIMITED
   CPU_PER_CALL UNLIMITED
   CONNECT_TIME UNLIMITED
   IDLE_TIME UNLIMITED
   LOGICAL_READS_PER_SESSION UNLIMITED
   LOGICAL_READS_PER_CALL UNLIMITED
   COMPOSITE_LIMIT UNLIMITED
   PRIVATE_SGA UNLIMITED
   FAILED_LOGIN_ATTEMPTS UNLIMITED
   PASSWORD_LIFE_TIME UNLIMITED
   PASSWORD_REUSE_TIME UNLIMITED  
   PASSWORD_REUSE_MAX UNLIMITED   
   PASSWORD_LOCK_TIME UNLIMITED
   PASSWORD_GRACE_TIME UNLIMITED
   PASSWORD_VERIFY_FUNCTION NULL';
		l_sql_txt		VARCHAR2 ( 4000 ) := ' ';
		l_profile_exists INTEGER := 0;
	BEGIN
		SELECT COUNT ( PROFILE# )
		  INTO l_profile_exists
		  FROM sys.profname$ p
		 WHERE name = UPPER ( pname );

		IF l_profile_exists > 0
		THEN
			NULL;
		-- TODO[Вставить проверку того что парольные лимиты UNLIM yна существующем профиле]
		 /*
       SELECT PROFILE
             ,RESOURCE_TYPE
             ,RESOURCE_NAME
             ,CASE LIMIT
              WHEN 'DEFAULT'
              THEN ( SELECT DP.LIMIT FROM DBA_PROFILES DP WHERE DP.PROFILE = 'DEFAULT' AND P.RESOURCE_NAME = DP.RESOURCE_NAME )
              ELSE LIMIT
              END AS LIMIT
FROM DBA_PROFILES P
WHERE P.PROFILE = 'P_2SES'
AND P.RESOURCE_TYPE = 'PASSWORD'
AND P.RESOURCE_NAME IN  ('PASSWORD_REUSE_TIME', 'PASSWORD_REUSE_MAX','PASSWORD_LIFE_TIME')

       */
		--raise_application_error(profile_already_exists_err,'Resource already exists:'||UPPER(pname),true );
		ELSE
			-- Формируем строку для выполнения подставляя имя пользователя в команду и хеш значние пароля
			l_sql_txt	:=
				REPLACE (
							 l_sql_cprl
							,'<PROFILE_NAME>'
							,UPPER ( pname )
				);

			-- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
			-- При ошибке процедура генерирует unable_exec_dsql,-20002
			DSQL_EXECUTE ( P_SQL_TXT => l_sql_txt );
		END IF;
	END;

	PROCEDURE DropUnlimProfile ( pname IN VARCHAR2 )
	AS
		l_sql_cprl		VARCHAR2 ( 4000 ) := '
   DROP PROFILE "<PROFILE_NAME>"';
		l_sql_txt		VARCHAR2 ( 4000 ) := ' ';
		l_profile_exists INTEGER := 0;
	BEGIN
		SELECT COUNT ( PROFILE# )
		  INTO l_profile_exists
		  FROM sys.profname$ p
		 WHERE name = UPPER ( pname );

		IF l_profile_exists = 0
		THEN
			NULL;
		--raise_application_error(profile_already_exists_err,'Resource already exists:'||UPPER(pname),true );
		ELSE
			-- Формируем строку для выполнения подставляя имя пользователя в командуb и хеш значние пароля
			l_sql_txt	:=
				REPLACE (
							 l_sql_cprl
							,'<PROFILE_NAME>'
							,UPPER ( pname )
				);

			-- Выполняем команду при помощи DBMS_SQL (PRIVATE PROCEDURE)
			-- При ошибке процедура генерирует unable_exec_dsql,-20002
			DSQL_EXECUTE ( P_SQL_TXT => l_sql_txt );
		END IF;
	END;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: RESET_PTIME
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	PROCEDURE RESET_PTIME (
		UNAME 			IN VARCHAR2
	  ,PNAME 			IN VARCHAR2 DEFAULT NULL
	  ,OPSMODE			IN PLS_INTEGER DEFAULT NULL
	)
	AS
		l_pname_new 	VARCHAR2 ( 128 );
		l_pname_old 	VARCHAR2 ( 128 );
		l_pwdhash		VARCHAR2 ( 128 );
	BEGIN
		-- Проверяем существует ли пользователь указанный в параметрах
		IF NOT USER_IS_EXISTS ( UNAME )
		THEN
			RAISE_APPLICATION_ERROR (
											  user_not_found_err
											 ,'User does not exist P_UMANE:' || UNAME
											 ,TRUE
			);
		END IF;

		-- Сохраняем название профайла пользователя и хеш пароля
		SELECT p.name AS lprofile
				,password AS pwdhash
		  INTO l_pname_old
				,l_pwdhash
		  FROM sys.user$ u
				,sys.profname$ p
		 WHERE	  type# = 1
				 AND u.resource$ = p.profile#
				 AND u.name = UPPER ( UNAME );


		IF pname IS NULL
		THEN
			-- Генерируем имя нового безлимтного профайла -- P_TMP_RPT<SESSIONID>_<SERIAL#>
			SELECT UPPER (
									'P_TMP'
								|| SYS_CONTEXT (
													  'USERENV'
													 ,'SESSIONID'
									)
								|| '_'
								|| SYS_CONTEXT (
													  'USERENV'
													 ,'SID'
									)
					 )
			  INTO l_pname_new
			  FROM DUAL;

			-- Создаем новый "безлимитный" профайл если его нет
			CreateUnlimProfile ( pname => l_pname_new );
		ELSE
			l_pname_new := pname;
		END IF;

		GC_RESPTIME_PROFILE := l_pname_new;
		-- Меняем профиль для пользователя
		DSQL_EXECUTE (
							P_SQL_TXT	=> 	'ALTER USER '
												|| '"'
												|| UNAME
												|| '"'
												|| ' PROFILE '
												|| '"'
												|| l_pname_new
												|| '"'
		);
		-- Сбрасываем время изм.-я пароля, используя фиктивнй сброс пароля
		SET_PASSVALUE (
							 P_UNAME 	 => UNAME
							,P_PASSVALUE => l_pwdhash
							,P_ISEXPIRE  => FALSE
		);
		-- Возвращаем пользователю его "старый" профайл
		DSQL_EXECUTE (
							P_SQL_TXT	=> 	'ALTER USER '
												|| '"'
												|| UNAME
												|| '"'
												|| ' PROFILE '
												|| '"'
												|| l_pname_old
												|| '"'
		);

		-- Удаляем временный профайл
		IF PNAME IS NULL
		THEN
			DropUnlimProfile ( pname => l_pname_new );
		END IF;

		GC_RESPTIME_PROFILE := NULL;
	END;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	PROCEDURE RESET_PTIME (
		UNAMELIST		IN OUT NOCOPY UsrNameTbl
	  ,OPSMODE			IN 			  PLS_INTEGER DEFAULT NULL
	)
	AS
		l_pname_new 	VARCHAR2 ( 128 );
	BEGIN
		-- Генерируем имя нового безлимтного профайла -- P_TMP_RPT<SESSIONID>_<SERIAL#>
		SELECT UPPER (
								'P_TMP'
							|| SYS_CONTEXT (
												  'USERENV'
												 ,'SESSIONID'
								)
							|| '_'
							|| SYS_CONTEXT (
												  'USERENV'
												 ,'SID'
								)
				 )
		  INTO l_pname_new
		  FROM DUAL;

		-- Создаем временный профайл, для пакетной обработки пользователей
		CreateUnlimProfile ( pname => l_pname_new );

		FOR i IN UNAMELISt.FIRST .. UNAMELISt.LAST
		LOOP
			RESET_PTIME (
							  UNAME		  => UNAMELISt ( i )
							 ,PNAME		  => l_pname_new
			);
		END LOOP;

		DropUnlimProfile ( pname => l_pname_new );
	END;

   ---------------------------------------------------------------------------------------------------------------------
   -- PROCEDURE: INITIALIZE
   --
   -- NOTE:
   --
   -- CHANGE_HISTORY
   -- AUTHOR        (DD/MM/YYYY)                   DESCRIPTION
   -- airepin        07/12/2015                    created
   --
   ---------------------------------------------------------------------------------------------------------------------
	PROCEDURE RESET_PTIME (
		UPROFILE 		IN VARCHAR2
	  ,OPSMODE			IN PLS_INTEGER DEFAULT NULL
	)
	AS
		l_pname_new 	VARCHAR2 ( 128 );
	BEGIN
		-- Генерируем имя нового безлимтного профайла -- P_TMP_RPT<SESSIONID>_<SERIAL#>
		SELECT UPPER (
								'P_TMP'
							|| SYS_CONTEXT (
												  'USERENV'
												 ,'SESSIONID'
								)
							|| '_'
							|| SYS_CONTEXT (
												  'USERENV'
												 ,'SID'
								)
				 )
		  INTO l_pname_new
		  FROM DUAL;

		-- Создаем временный профайл, для пакетной обработки пользователей
		CreateUnlimProfile ( pname => l_pname_new );

		-- Получаем список пользователей с броса даты пароля.
		FOR usr_c IN (
							 SELECT			  username
											FROM dba_users
										  WHERE		profile = UPPER ( UPROFILE )
												  AND username NOT IN ( 'XS$NULL'
																			  ,'SYS' )
						 )
		LOOP
			BEGIN
				RESET_PTIME (
								  UNAME		  => usr_c.username
								 ,PNAME		  => l_pname_new
				);
			EXCEPTION
				WHEN OTHERS
				THEN
					NULL;
			END;
		END LOOP;

		DropUnlimProfile ( pname => l_pname_new );
	END;
BEGIN
	INITIALIZE;
END EX$SEC_AGENT_DRV_ORA;
/
