  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_INFORMACION_GENERAL_V2" 
(
 V_EXPEDIENTE in varchar2 default NULL
,V_GRUPO in varchar2 default NULL
,cv_1 in out sys_refcursor)
AS

BEGIN
     open cv_1 for Select * From Vi_Informacion_g1 Where pr_mc_expediente= V_EXPEDIENTE;
END;