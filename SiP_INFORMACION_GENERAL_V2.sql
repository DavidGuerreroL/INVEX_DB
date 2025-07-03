  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_INFORMACION_GENERAL_V2" 
(
 V_EXPEDIENTE in varchar2 default NULL
,V_GRUPO in varchar2 default NULL
,cv_1 in out sys_refcursor)
AS

BEGIN

--IF V_GRUPO = '1' THEN
      open cv_1 for Select * From Vi_Informacion_g1 Where pr_mc_expediente= V_EXPEDIENTE;
/* ELSIF V_GRUPO = '2' THEN
      open cv_1 for Select * From Vi_Informacion_g2 Where pr_mc_expediente= V_EX
PEDIENTE;
ELSIF V_GRUPO = '3' THEN
      open cv_1 for Select * From Vi_Informacion_g3 Where pr_mc_expediente= V_EX
PEDIENTE;
ELSIF V_GRUPO = '4' THEN
      open cv_1 for Select * From Vi_Informacion_g4 Where pr_mc_expediente= V_EX
PEDIENTE;
ELSIF V_GRUPO = '5' THEN
      open cv_1 for Select * From Vi_Informacion_g5 Where pr_mc_expediente= V_EX
PEDIENTE;
ELSIF V_GRUPO = '6' THEN
      open cv_1 for Select * From Vi_Informacion_g6 Where pr_mc_expediente= V_EX
PEDIENTE;
ELSIF V_GRUPO = '8' THEN
      open cv_1 for Select * From Vi_Informacion_g8 Where pr_mc_expediente= V_EX
PEDIENTE;
END IF;*/


END;