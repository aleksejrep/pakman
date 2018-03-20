PROMPT  --------------------------------------------------------------------#
PROMPT  -- file ex$sec_dispmsg_type.tps
PROMPT  -- EX$SEC_DISPMSG_TYPE (ORACLE OBJECT TYPE)
PROMPT  -- NOTE: Used in Oracle Advanced Queue 
PROMPT  --------------------------------------------------------------------#

CREATE OR REPLACE TYPE EX$SEC_DISPMSG_TYPE AS OBJECT 
 (DISPATCHER  CHAR(12),
  AQ_MSGID    RAW(16),
  DISP_PARAMS VARCHAR2(64)
  );
/