conn extdba/&PWDINSTALL@developer


SET SERVEROUTPUT ON
SET APPINFO  EXTDBA_SCHEME_DROP
SET ECHO OFF
SET FEED ON
SET SQLBLANKLINES ON
SET TERMOUT ON
SET VERIFY  OFF
SET LINESIZE 120

WHENEVER SQLERROR CONTINUE

SPOOL drop_scheme.log

PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_ACCOUNT (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_ACCOUNT DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_ACCOUNT CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_ACCOUNT_ID_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_ACCOUNT_USER (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_ACCOUNT_USER CASCADE CONSTRAINTS;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_ATTRIBUTE (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_ATTRIBUTE_MAP DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_ATTRIBUTE_MAP CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_ATTRIBUTE_VALUE (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_ATTRIBUTE_VALUE CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_CATALOG (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_CATALOG DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_CATALOG CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_CATALOG_SFMAP (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_CATALOG_SFMAP CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_CATALOG_TYPE (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_CATALOG_TYPE CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_CHANGEGL_DATA (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_CHANGEGL_DATA DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_CHANGEGL_DATA CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_CHANGEGL_HEAD (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_CHANGEGL_HEAD DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_CHANGEGL_HEAD CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_CHANGEGL_HEAD_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DIAG_LOG (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_DIAG_LOG CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_DIAG_LOG_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DISPATCHER (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_DISPATCHER DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_DISPATCHER CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DISPATCHER_SLOG (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_DISPATCHER_SLOG DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_DISPATCHER_SLOG CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_DISPATCHER_SLOG_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_GROUP (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_GROUP DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_GROUP CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_GROUP_ID_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_GROUP_MEMBER (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_GROUP_MEMBER CASCADE CONSTRAINTS;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_POLICY (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_POLICY DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_POLICY CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_POLICY_ID_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_POLICY_NAME (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_POLICY_NAME DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_POLICY_NAME CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_POLICY_RES_MAP (TABLE)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_POLICY_RES_MAP CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_USER DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_USER CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_USER_ID_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER_DESCR (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_USER_DESCR DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_USER_DESCR CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER_OPS_LOG (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_USER_OPS_LOG DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_USER_OPS_LOG CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE EX$SEC_USER_OPS_LOG_S;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER_REPL (TABLE)
PROMPT  --------------------------------------------------------------------#
ALTER TABLE EX$SEC_USER_REPL DROP PRIMARY KEY CASCADE;
DROP TABLE EX$SEC_USER_REPL CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER_SFMAP (TABLE IOT)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_USER_SFMAP CASCADE CONSTRAINTS PURGE;
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_USER_REPL_SFMAP (TABLE IOT)
PROMPT  --------------------------------------------------------------------#
DROP TABLE EX$SEC_USER_REPL_SFMAP CASCADE CONSTRAINTS PURGE;


PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DISPATCHER_QQ (ORACLE ADVANCED QUEUE)
PROMPT  --------------------------------------------------------------------#
BEGIN
  SYS.DBMS_AQADM.STOP_QUEUE ( QUEUE_NAME => 'AQ$EX$SEC_DISPATCHER_QQ');
  SYS.DBMS_AQADM.DROP_QUEUE ( QUEUE_NAME => 'AQ$EX$SEC_DISPATCHER_QQ');
END;
/
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DISPATCHER_QTAB (ORACLE ADVANCED QUEUE TABLE)
PROMPT  --------------------------------------------------------------------#
BEGIN
  SYS.DBMS_AQADM.DROP_QUEUE_TABLE
    (QUEUE_TABLE          =>        'AQ$EX$SEC_DISPATCHER_QT');
END;
/
PROMPT  --------------------------------------------------------------------#
PROMPT  -- DROP EX$SEC_DISPMSG_TYPE (ORACLE OBJECT TYPE)
PROMPT  --------------------------------------------------------------------#
DROP TYPE EX$SEC_DISPMSG_TYPE;

SPOOL OFF;
EXIT;