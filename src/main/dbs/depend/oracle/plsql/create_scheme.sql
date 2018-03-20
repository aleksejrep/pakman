conn extdba/&PWDINSTALL@developer


SET SERVEROUTPUT ON
SET APPINFO  EXTDBA_SCHEME_INSTALL
-- SET ECHO ON
SET FEED ON
SET SQLBLANKLINES ON
SET TERMOUT ON
SET VERIFY  OFF

WHENEVER SQLERROR EXIT

SPOOL create_scheme.log

BEGIN
--EXECUTE IMMEDIATE 'ALTER TABLE ex$sec_ACCOUNT DROP PRIMARY KEY CASCADE';
--EXECUTE IMMEDIATE 'DROP  TABLE ex$sec_ACCOUNT CASCADE CONSTRAINTS PURGE';
NULL;
EXCEPTION
WHEN OTHERS
THEN NULL;
END;
/
ACCEPT TBSDATNAME DEFAULT 'EXTDBA_DAT' PROMPT 'TABLE TABLESPACE: '
ACCEPT TBSIDXNAME DEFAULT 'EXTDBA_IDX' PROMPT 'INDEX TABLESPACE: '
ACCEPT TBSLOBNAME DEFAULT 'EXTDBA_DAT' PROMPT 'LOB TABLESPACE: '

PROMPT TABLE TABLESPACE: &TBSDATNAME
PROMPT INDEX TABLESPACE: &TBSIDXNAME 
PROMPT LOB TABLESPACE:   &TBSLOBNAME 


PROMPT  --------------------------------------------------------------------#
PROMPT  -- file create_scheme.sql
PROMPT  -- Start all create table scripts
PROMPT  --------------------------------------------------------------------#
@@ex$sec_account.tbl
@@ex$sec_account_user.tbl
@@ex$sec_attribute_map.tbl
@@ex$sec_attribute_value.tbl
@@ex$sec_catalog.tbl
@@ex$sec_catalog_sfmap.tbl
@@ex$sec_catalog_type.tbl
@@ex$sec_diag_log.tbl
@@ex$sec_dispatcher.tbl
@@ex$sec_dispatcher_slog.tbl
@@ex$sec_group.tbl
@@ex$sec_group_member.tbl
@@ex$sec_policy.tbl
@@ex$sec_policy_name.tbl
@@ex$sec_policy_res_map.tbl
@@ex$sec_user.tbl
@@ex$sec_user_sfmap.tbl
@@ex$sec_user_descr.tbl
@@ex$sec_user_ops_log.tbl
@@ex$sec_user_repl.tbl
@@ex$sec_user_repl_sfmap.tbl
@@ex$sec_changegl_head.tbl
@@ex$sec_changegl_data.tbl
@@foreign_relations.cfk
@@ex$sec_dispmsg_type.tps
@@aq$ex$sec_dispatcher_qt.qtb
@@aq$ex$sec_dispatcher_qq.qqu

PROMPT  --------------------------------------------------------------------#
PROMPT  -- LOAD DISTIONARY'S DATA
PROMPT  --------------------------------------------------------------------#
SET DEFINE OFF
@@ex$sec_catalog_sfmap.ldt
@@ex$sec_catalog_type.ldt
@@ex$sec_policy_res_map.ldt
@@ex$sec_user_sfmap.ldt
@@ex$sec_user_repl_sfmap.ldt
SET DEFINE ON

PROMPT  --------------------------------------------------------------------#
PROMPT  -- file create_scheme.sql
PROMPT  -- Table scheme install successful
PROMPT  --------------------------------------------------------------------#

SPOOL OFF
EXIT;