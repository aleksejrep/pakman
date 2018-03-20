declare
l_user_name    varchar2(64) default 'A_REPIN';
l_profile_name varchar2(64) default 'P_UNLIM001';
l_date date;
begin
ex$sec_agent_drv_ora.set_unlim_profile(profile_name => l_profile_name);
ex$sec_agent_drv_ora.reset_pass_date(user_name =>  l_user_name);
end;

/

select * 
from dba_users
where username = 'A_REPIN'

/

alter user A_REPIN identified by values 'C211868096ACE714';


/
alter user A_REPIN account unlock;

/
alter user A_REPIN password expire;


/
ORA-04063: package body "EXTDBA.EX$SEC_AGENT_DRV_ORA" has errors
ORA-06508: PL/SQL: could not find program unit being called: "EXTDBA.EX$SEC_AGENT_DRV_ORA"
ORA-06512: at line 6
/

/

declare
l_usr_name varchar2(64) default 'A_REPIN';
begin
ex$sec_tinfosys_drv_ag_ora.set_astatus@wabc_dvlp(p_uname => l_usr_name,p_status => sys.ex$sec_tinfosys_drv_ag_ora.ast_locked);
end;

/

grant execute on ex$sec_tinfosys_drv_ag_ora to extdba

/



select * 
from dba_users
where username = 'A_REPIN'
/

alter user A_REPIN identified by values 'C211868096ACE714';


/
alter user A_REPIN account unlock;

/
alter user A_REPIN password expire;
/

create database link "WABC_DVLP"
using 'DEVELOPER'
/
select * from dba_db_links
/
create synonym EX$SEC_TINFOSYS_DRV_AG_ORA for  sys.EX$SEC_TINFOSYS_DRV_AG_ORA
/
select * from v$instance