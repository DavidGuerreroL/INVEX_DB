  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_OTROSCREDITOS" (
    V_BANDERA NUMBER DEFAULT NULL,
    V_Credito VARCHAR2 DEFAULT NULL,
    V_Expediente VARCHAR2 DEFAULT NULL,
    V_Grupo VARCHAR2 DEFAULT NULL,
    V_Cliente VARCHAR2 DEFAULT NULL,
    CV_1 IN OUT SYS_REFCURSOR
)
AS
BEGIN
    if V_BANDERA = 1 THEN
        --if V_Grupo = 1 then
            OPEN CV_1 FOR SELECT PR_MC_CLIENTE "Cliente",PR_CL_NOMBRE "Nombre",PR_CL_ADDRESS_LINE_1 "Direcci�n",PR_CL_PHONE1 "Tel�fono 1",PR_CL_PHONE2 "Tel�fono 2",PR_CL_PHONE3 "Tel�fono 3"
                            FROM PR_CLIENTE JOIN pr_mc_gral ON pr_mc_credito = PR_CL_ACCOUNT_ID 
                            WHERE PR_MC_EXPEDIENTE = V_Expediente;

    elsif V_BANDERA = 2 THEN
         OPEN CV_1 FOR  SELECT MAX("�ltima fecha en que la cuenta fue contactada") "�ltimo Contacto", FN_TO_CHAR_NUMBER(SUM("Monto vencido")) "Saldo vencido", FN_TO_MONEY(SUM("Saldo deudor")) "Total Deudor",
         FN_TO_MONEY(SUM("Total por vencer")) "Pagos efectuar",MAX("Fecha en que la cuenta cayo en mora") "Ciclo", FN_TO_CHAR_NUMBER(SUM("Numero de dias en mora")) "Meses antig�edad"
            FROM ( SELECT PR_MC_CLIENTE CLIENTE,PR_MC_DTEGESTION "�ltima fecha en que la cuenta fue contactada",PR_CL_TOTAL_SALDO_VENCIDO "Monto vencido",PR_CL_TOTAL_SALDO_ACTUAL
 "Saldo deudor",PR_CL_TOTAL_PAGOS_EFECTUAR "Total por vencer",PR_CL_CYCLE_NUMBER "Fecha en que la cuenta cayo en mora",PR_CL_NUMERO_MESES_ANTIGUEDAD "Numero de dias en mora" 
 FROM PR_CLIENTE JOIN pr_mc_gral ON PR_MC_CREDITO = PR_CL_ACCOUNT_ID
  WHERE PR_MC_CLIENTE = V_Cliente

 ) A
 GROUP BY CLIENTE;

    elsif V_BANDERA = 3 THEN
        OPEN CV_1 FOR  SELECT
        PR_GRUPO "Producto",
        A.PR_MC_CREDITO "Cuenta",
       -- A.PR_MC_CLIENTE "Cuenta",
        A.PR_PRODUCTO "Producto",
        A."Monto vencido" "Montov",
        A."Numero de dias en mora" "DiasM",
        A.PR_MC_ESTATUS "Estatus",
        A.PR_MC_ESTATUS "EstatusC",
        B.PR_MC_NOMBREFILA "Cola",
       (SELECT CAT_AG_NOMBRE FROM CAT_AGENCIAS WHERE CAT_AG_ID = B.PR_MC_AGENCIA ) "Agencia"
        FROM (
            SELECT PR_MC_CREDITO,PR_MC_CLIENTE ,PR_MC_PRODUCTO PR_PRODUCTO,PR_CL_MINIMUM_PAYMENT "Monto vencido",'' "Numero de dias en mora",PR_MC_ESTATUS,PR_MC_GRUPO PR_GRUPO
              FROM PR_CLIENTE JOIN pr_mc_gral ON PR_MC_EXPEDIENTE = PR_CL_EXPEDIENTE_MC 
             WHERE PR_MC_CLIENTE = V_Cliente

        ) A JOIN PR_MC_GRAL B ON A.PR_MC_CREDITO =B.PR_MC_CREDITO ;


    elsif V_BANDERA = 4 THEN
        OPEN CV_1 FOR SELECT PR_MC_EXPEDIENTE,PR_MC_PRODUCTO from PR_MC_GRAL where PR_MC_CREDITO = V_Credito;
    elsif V_BANDERA = 5 THEN
        OPEN CV_1 FOR SELECT COUNT(*) CANTIDAD FROM PR_MC_GRAL WHERE PR_MC_CLIENTE = V_Credito;
    END IF;
END;