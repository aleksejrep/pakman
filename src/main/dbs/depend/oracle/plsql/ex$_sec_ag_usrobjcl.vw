Prompt drop View EX$_SEC_AG_USROBJCL;
DROP VIEW EX$_SEC_AG_USROBJCL
/

PROMPT View EX$_SEC_AG_USROBJCL;
--
-- EX$_SEC_AG_USROBJCL  (View)
--

CREATE OR REPLACE FORCE VIEW EX$_SEC_AG_USROBJCL
(
	OWNER
  ,OBJECT_CLASS
)
AS
	SELECT													 /* UNAME(EX$SEC V_1.2.0.0) */
			DISTINCT
			 OWNER
			,CASE
				 WHEN NVL ( OBJECT_TYPE, 'UNDEFINED' ) IN ( 'JOB'
																		 ,'PROGRAM'
																		 ,'JOB CLASS'
																		 ,'WINDOW'
																		 ,'WINDOW GROUP'
																		 ,'SCHEDULE'
																		 ,'CHAIN' )
				 THEN
					 'JOB'
				 ELSE
					 'PERSISTENT'
			 END
				 AS OBJECT_CLASS
	  FROM DBA_OBJECTS
/
