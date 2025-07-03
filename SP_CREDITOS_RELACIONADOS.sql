  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_CREDITOS_RELACIONADOS" (
    V_NOMBRE In Varchar2 Default Null ,
    V_Expediente IN VARCHAR2 DEFAULT NULL ,
    v_Cliente IN VARCHAR2 DEFAULT NULL ,
    V_Bandera In Number Default Null ,
    Cv_1 In Out Sys_Refcursor)
AS
    v_grupo VARCHAR(10);
    V_CREDITO VARCHAR(26);
    cliente varchar(26);
Begin
    IF V_BANDERA=0 THEN --Creditos Relacionados
        select pr_mc_grupo into v_grupo from pr_mc_gral where pr_mc_expediente =
 V_Expediente;

            OPEN CV_1 FOR
            select pr_mc_expediente "Expediente", pr_mc_credito "Cr�dito", pr_mc
_grupo "Grupo" ,
            PR_CL_NOMBRE "Nombre", pr_mc_cliente "Cliente", PR_CL_ORIGINACION "E
mpresa", PR_CL_MONTO_VENCIDO "Saldo Vencido", 
            TO_CHAR(PR_CL_CURRENT_BALANCE) "Saldo total", pr_mc_dteasigna "Fecha
 Asignaci�n", pr_mc_estatus "Estatus", 
            PR_CL_PHONE1 "Tel�fono Casa / Celular", PR_CL_PHONE3 "Tel�fono Emple
o"
            FROM pr_cliente JOIN pr_mc_gral ON pr_mc_expediente  = PR_CL_EXPEDIE
NTE_MC
            where PR_MC_CLIENTE = v_Cliente
            AND pr_mc_expediente != V_Expediente
            ;

    ELSIF V_BANDERA = 1 THEN
    BEGIN
        SELECT PR_MC_CREDITO into V_CREDITO FROM PR_MC_GRAL WHERE PR_MC_EXPEDIEN
TE=V_EXPEDIENTE;
        OPEN CV_1 FOR
        SELECT
            pr_mc_expediente EXPEDIENTE,
            HIST_RG_CUENTA CR�DITO,
            HIST_RG_GRUPO GRUPO,
            HIST_RG_NUMERO_RELACION "NO. RELACI�N",
            HIST_RG_NOMBRE_RELACION NOMBRE,
            HIST_RG_NOMBRE_ADICIONAL "NOMBRE ADICIONAL",
            HIST_RG_DIRECCION1 DIRECCI�N,
            HIST_RG_DIRECCION2 DIRECCI�N2,
            HIST_RG_CIUDAD CIUDAD,
            HIST_RG_ESTADO ESTADO,
            HIST_RG_CP CP,
            HIST_RG_CURP_RFC CURP,
            HIST_RG_DESCRIPCION DESCRIPCI�N,
            HIST_RG_TELCASA "TEL CASA",
            HIST_RG_TELOFICINA "TEL OFICINA"
        FROM HIST_RELACIONADOS JOIN
            PR_MC_GRAL ON HIST_RG_CUENTA=PR_MC_CREDITO AND HIST_RG_GRUPO=PR_MC_G
RUPO
            WHERE HIST_RG_CUENTA=V_CREDITO;
    END;

    ELSIF V_BANDERA = 2 THEN
    BEGIN
         SELECT PR_MC_CREDITO,pr_mc_cliente 
           into V_CREDITO,cliente 
           FROM PR_MC_GRAL WHERE PR_MC_EXPEDIENTE=V_EXPEDIENTE;

          OPEN CV_1 FOR 'SELECT EXPEDIENTE "Expediente", concat(concat(''Credito
: '',CREDITO),concat('' Grupo: '',GRUPO)) "Cr�dito", NOMBRE "Nombre", CLIENTE "C
liente"
            FROM HIST_BUSQUEDA
            WHERE CLIENTE = '''|| cliente ||''' AND CREDITO != '''|| V_CREDITO |
|''' ';

    END;
    End If;
End;