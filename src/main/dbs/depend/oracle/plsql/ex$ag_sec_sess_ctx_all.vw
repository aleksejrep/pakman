Prompt drop View EX$AG_SEC_SESS_CTX_ALL;
DROP VIEW EX$AG_SEC_SESS_CTX_ALL
/

PROMPT View EX$AG_SEC_SESS_CTX_ALL;
--
-- EX$AG_SEC_SESS_CTX_ALL  (View)
--

CREATE OR REPLACE FORCE VIEW EX$AG_SEC_SESS_CTX_ALL
(
	LOGON_TIME
  ,USER_NAME
  ,USER_CODE
  ,OSUSER
  ,CLIENT_HOST
  ,CLIENT_IP
  ,TERMINAL
  ,PROGRAM_SNAME
  ,MODULE_SNAME
  ,ACTION
  ,CLIENT_INFO
  ,CLIENT_IDENTIFIER
  ,SERVER_HOST
  ,SESS_ID
  ,SESS_SERIAL#
  ,SESS_AUDSID
  ,SESS_SPID
  ,SERVICE_NAME
  ,DB_UNIQUE_NAME
  ,SQL_TRACE
  ,SQL_TRACE_WAITS
  ,SQL_TRACE_BINDS
  ,PROXY_USER
  ,PROXY_USERID
  ,ISDBA
  ,DB_NAME
  ,DB_DOMAIN
  ,INSTANCE_NAME
  ,JOB_OWNER
  ,JOB_NAME
  ,JOB_SUBNAME
  ,SESS_TYPE
)
AS
	SELECT S.LOGON_TIME AS LOGON_TIME
			,UPPER ( S.USERNAME ) AS USER_NAME
			,S.USER# AS USER_CODE
			,UPPER ( S.OSUSER ) AS OSUSER
			,S.MACHINE AS CLIENT_HOST
			,CASE
				 WHEN SYS_CONTEXT (
										  'USERENV'
										 ,'SESSIONID'
						) = S.AUDSID
				 THEN
					 UPPER (
								SYS_CONTEXT (
												  'USERENV'
												 ,'IP_ADDRESS'
								)
					 )
				 ELSE
					 NULL
			 END
				 AS CLIENT_IP
			,UPPER ( S.TERMINAL ) AS TERMINAL
			,UPPER ( S.PROGRAM ) AS PROGRAM_SNAME
			,UPPER ( S.MODULE ) AS MODULE_SNAME
			,UPPER ( S.ACTION ) AS ACTION
			,UPPER ( S.CLIENT_INFO ) AS CLIENT_INFO
			,UPPER ( S.CLIENT_IDENTIFIER ) AS CLIENT_IDENTIFIER
			,(
				 SELECT MAX ( UPPER ( HOST_NAME ) )
					FROM V$INSTANCE
			 )
				 AS SERVER_HOST
			,S.SID AS SESS_ID
			,S.SERIAL# AS SESS_SERIAL#
			,S.AUDSID AS SESS_AUDSID
			,P.SPID AS SESS_SPID
			,S.SERVICE_NAME AS SERVICE_NAME
			,SYS_CONTEXT (
								'USERENV'
							  ,'DB_UNIQUE_NAME'
			 )
				 AS DB_UNIQUE_NAME
			,CASE S.SQL_TRACE WHEN 'DISABLED' THEN 'N' ELSE 'Y' END AS SQL_TRACE
			,CASE S.SQL_TRACE_WAITS WHEN 'FALSE' THEN 'N' ELSE 'Y' END
				 AS SQL_TRACE_WAITS
			,CASE S.SQL_TRACE_BINDS WHEN 'FALSE' THEN 'N' ELSE 'Y' END
				 AS SQL_TRACE_BINDS
			,CASE
				 WHEN SYS_CONTEXT (
										  'USERENV'
										 ,'SESSIONID'
						) = S.AUDSID
				 THEN
					 UPPER (
								SYS_CONTEXT (
												  'USERENV'
												 ,'PROXY_USER'
								)
					 )
				 ELSE
					 NULL
			 END
				 AS PROXY_USER
			,CASE
				 WHEN SYS_CONTEXT (
										  'USERENV'
										 ,'SESSIONID'
						) = S.AUDSID
				 THEN
					 UPPER (
								SYS_CONTEXT (
												  'USERENV'
												 ,'PROXY_USERID'
								)
					 )
				 ELSE
					 NULL
			 END
				 AS PROXY_USERID
			,CASE
				 WHEN SYS_CONTEXT (
										  'USERENV'
										 ,'SESSIONID'
						) = S.AUDSID
				 THEN
					 CASE (
								SELECT TO_CHAR (
													  SYS_CONTEXT (
																		 'USERENV'
																		,'ISDBA'
													  )
										 )
								  FROM DUAL
							)
						 WHEN 'FALSE' THEN 'N'
						 ELSE 'Y'
					 END
				 ELSE
					 (
						 SELECT DECODE ( COUNT ( * ), 0, 'N', 'Y' ) AS ISDBA
							FROM DBA_ROLE_PRIVS
						  WHERE GRANTED_ROLE = 'DBA' AND GRANTEE = S.USERNAME
					 )
			 END
				 AS ISDBA
			,UPPER (
						SYS_CONTEXT (
										  'USERENV'
										 ,'DB_NAME'
						)
			 )
				 AS DB_NAME
			,UPPER (
						SYS_CONTEXT (
										  'USERENV'
										 ,'DB_DOMAIN'
						)
			 )
				 AS DB_DOMAIN
			,UPPER (
						SYS_CONTEXT (
										  'USERENV'
										 ,'INSTANCE_NAME'
						)
			 )
				 AS INSTANCE_NAME
			,J.OWNER AS JOB_OWNER
			,J.JOB_NAME AS JOB_NAME
			,J.JOB_SUBNAME AS JOB_SUBNAME
			,S.TYPE AS SESS_TYPE
	  FROM V$SESSION S
			,V$PROCESS P
			,DBA_SCHEDULER_RUNNING_JOBS J
	 WHERE S.PADDR = P.ADDR AND S.SID = J.SESSION_ID(+)
/
