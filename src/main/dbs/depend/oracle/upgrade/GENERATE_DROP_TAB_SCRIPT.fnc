SELECT  
           'PROMPT  --------------------------------------------------------------------#' || CHR(10)
        || 'PROMPT  -- DROP '|| Z.TABLE_NAME ||' (TABLE)'                                         || CHR(10)
        || 'PROMPT  --------------------------------------------------------------------#' || CHR(10)
        ||
        CASE Z.IS_PK_EXISTS 
        WHEN 'YES'
        THEN 'ALTER TABLE ' || Z.TABLE_NAME || ' DROP PRIMARY KEY CASCADE;' || CHR(10)
        ELSE ''
        END
        || 'DROP TABLE ' || Z.TABLE_NAME || ' CASCADE CONSTRAINTS;' AS DROP_COMMAND
FROM
(SELECT T.OWNER
      ,T.TABLE_NAME
      ,NVL((SELECT 'YES'
       FROM  DBA_CONSTRAINTS C
       WHERE T.OWNER      = C.OWNER
         AND T.TABLE_NAME = C.TABLE_NAME
         AND NVL(T.IOT_TYPE,'NORMAL') <> 'IOT'
         AND C.CONSTRAINT_TYPE = 'P'
        ),'NO') AS IS_PK_EXISTS
FROM DBA_TABLES T
WHERE T.OWNER      = 'EXTDBA'
  AND T.TABLE_NAME LIKE 'EX$SEC%' ) Z
  ORDER BY Z.TABLE_NAME ASC 