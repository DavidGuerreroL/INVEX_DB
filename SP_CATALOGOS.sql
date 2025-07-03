  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_CATALOGOS" (
    V_PRODUCTO IN NUMBER DEFAULT NULL,
    V_BANDERA IN NUMBER DEFAULT NULL,
    V_VALOR IN VARCHAR2 DEFAULT NULL,
    V_VALOR2 IN VARCHAR2 DEFAULT NULL,
    CV_1 IN OUT SYS_REFCURSOR
) 
AS 
 v_IdCodigo number;
 v_qry varchar2(4000); 

BEGIN 

IF V_BANDERA = 1 THEN -- CATALOGO DE VARIABLES
OPEN CV_1 FOR
SELECT
    CAT_VA_DESCRIPCION,
    CAT_VA_VALOR
FROM
    CAT_VARIABLES;

ELSIF V_BANDERA = 2 THEN OPEN CV_1 FOR
SELECT
    CAT_CA_CODIGO "Codigo",
    CAT_CA_DESCRIPCION "Descripcion"
FROM
    CAT_COD_ACCION
ORDER BY
    1;

ELSIF V_BANDERA = 3 THEN OPEN CV_1 FOR
SELECT
    CAT_CR_CODIGO "Codigo",
    CAT_CR_DESCRIPCION "Descripcion"
FROM
    CAT_COD_RESULTADO
ORDER BY
    1;

ELSIF V_BANDERA = 4 THEN OPEN CV_1 FOR
SELECT
    CAT_NP_CODIGO "Codigo",
    CAT_NP_DESCRIPCION "Descripcion"
FROM
    CAT_COD_NOPAGO
ORDER BY
    1;

ELSIF V_BANDERA = 5 THEN OPEN CV_1 FOR
SELECT
    CAT_CO_RESULTADO "Codigo",
    CAT_CO_RDESCRIPCION "Descripcion"
FROM
    CAT_CODIGOS
WHERE
    CAT_CO_ACCION = V_VALOR
ORDER BY
    1;

ELSIF V_BANDERA = 6 THEN OPEN CV_1 FOR
SELECT
    CAT_CA_ID "ID",
    CAT_CA_CODIGO "Codigo",
    CAT_CA_DESCRIPCION "Descripcion"
FROM
    CAT_COD_ACCION
WHERE
    CAT_CA_CODIGO NOT IN (
        SELECT
            CAT_CODIGOS.CAT_CO_ACCION
        FROM
            CAT_CODIGOS
    )
ORDER BY
    1;

ELSIF V_BANDERA = 7 THEN OPEN CV_1 FOR
SELECT
    CAT_CR_ID "ID",
    CAT_CR_CODIGO "C�digo",
    CAT_CR_DESCRIPCION "Descripci�n"
FROM
    CAT_COD_RESULTADO
ORDER BY
    1;

ELSIF V_BANDERA = 8 THEN OPEN CV_1 FOR
SELECT
    CAT_PE_ID ID,
    CAT_PE_PERFIL "Perfiles"
FROM
    CAT_PERFILES
ORDER BY
    CAT_PE_ID;

ELSIF V_BANDERA = 9 THEN OPEN CV_1 FOR
SELECT
    CAT_PR_ID ID,
    CAT_PR_PRODUCTO "Productos"
FROM
    CAT_PRODUCTOS;

ELSIF V_BANDERA = 10 THEN OPEN CV_1 FOR
SELECT
    CAT_CR_CODIGO "Codigo",
    CAT_CR_DESCRIPCION "Descripcion"
FROM
    CAT_COD_RESULTADO
WHERE
    CAT_CR_CODIGO NOT IN (
        SELECT
            CAT_CO_RESULTADO
        FROM
            CAT_CODIGOS
        WHERE
            CAT_CO_ACCION = V_VALOR
    )
ORDER BY
    1;

ELSIF V_BANDERA = 11 THEN OPEN CV_1 FOR
SELECT
    CAT_CR_CODIGO "Codigo",
    CAT_CR_DESCRIPCION "Descripcion"
FROM
    CAT_COD_RESULTADO
WHERE
    CAT_CR_CODIGO NOT IN (
        SELECT
            CAT_CODIGOS.CAT_CO_RESULTADO
        FROM
            CAT_CODIGOS
    )
ORDER BY
    1;

ELSIF V_BANDERA = 12 THEN OPEN CV_1 FOR
SELECT
    "Codigo",
    "Descripcion",
    CAT_CO_PONDERACION
FROM
    (
        SELECT
            DISTINCT CAT_CO_RESULTADO "Codigo",
            CAT_CO_RDESCRIPCION "Descripcion",
            SUBSTR(
                CAT_CO_PONDERACION,
                INSTR(
                    CAT_CO_PONDERACION,
                    '|',
                    1,
                    SUBSTR(V_VALOR, 3, 1)
                ) + 1,
                INSTR(
                    CAT_CO_PONDERACION,
                    '|',
                    1,
                    SUBSTR(V_VALOR, 3, 1) + 1
                ) - INSTR(
                    CAT_CO_PONDERACION,
                    '|',
                    1,
                    SUBSTR(V_VALOR, 3, 1)
                ) - 1
            ) CAT_CO_PONDERACION
        FROM
            CAT_CODIGOS
        WHERE
            CAT_CO_ACCION = SUBSTR(V_VALOR, 0, 2)
    )
ORDER BY
    TO_NUMBER(CAT_CO_PONDERACION);

ELSIF V_BANDERA = 13 THEN OPEN CV_1 FOR
SELECT
    DISTINCT CAT_CO_ACCION "Valor",
    CAT_CO_ADESCRIPCION "Descripcion"
FROM
    CAT_CODIGOS
WHERE
    SUBSTR(CAT_CO_PRODUCTO, V_VALOR, 1) = 1;

ELSIF V_BANDERA = 14 THEN ---producto para ponderacion
OPEN CV_1 FOR
SELECT
    CAT_PR_PRODUCTO "Descripcion",
    CAT_PR_ID "Valor"
FROM
    CAT_PRODUCTOS;

ELSIF V_BANDERA = 15 THEN OPEN CV_1 FOR
SELECT
    CAT_CA_CODIGO "Codigo",
    CAT_CA_DESCRIPCION "Descripcion"
FROM
    CAT_COD_ACCION;

ELSIF V_BANDERA = 16 THEN OPEN CV_1 FOR
SELECT
    CAT_CA_DESCRIPCION CAT_CA_ID,
    CAT_CA_DESCRIPCION
FROM
    CAT_CATALOGOS
WHERE
    UPPER(CAT_CA_CATALOGO) = UPPER('CAT_DELIMITADOR')
ORDER BY
    1;

ELSIF V_BANDERA = 17 THEN OPEN CV_1 FOR
SELECT 
    CAT_BL_GRUPO "Grupo" 
FROM 
    CAT_GRUPO_REPORTES;

--AND Cat_Ca_Producto=V_Producto 
ELSIF V_BANDERA = 19 THEN ---Catalogo causas de no pago
OPEN CV_1 FOR
SELECT
    CAT_NP_ID "ID",
    CAT_NP_CODIGO "C�digo",
    CAT_NP_DESCRIPCION "Descripci�n"
FROM
    CAT_COD_NOPAGO
ORDER BY
    CAT_NP_ID;

ELSIF V_BANDERA=20 THEN ---Catalogo causas de no pago
  IF SUBSTR(V_VALOR,0,INSTR(V_VALOR,',') - 1)= 'ZZ' THEN
  OPEN CV_1 FOR SELECT FN_NOPAGO(CAT_CO_NOPAGO) "Descripcion" ,'' "Codigo" FROM 
CAT_CODIGOS
  WHERE CAT_CO_RESULTADO=SUBSTR(V_VALOR,4,2);
  ELSE
  OPEN CV_1 FOR SELECT FN_NOPAGO(CAT_CO_NOPAGO) "Descripcion" ,'' "Codigo" FROM 
CAT_CODIGOS
  WHERE CAT_CO_RESULTADO= SUBSTR(V_VALOR,INSTR(V_VALOR,',') + 1 ,LENGTH(V_VALOR)
)
  AND CAT_CO_ACCION=SUBSTR(V_VALOR,0,INSTR(V_VALOR,',') - 1);
  END IF;

ELSIF V_BANDERA = 21 THEN OPEN CV_1 FOR
SELECT
    DISTINCT CAT_CO_RESULTADO "Codigo",
    CAT_CO_RDESCRIPCION "Descripcion"
FROM
    CAT_CODIGOS;

ELSIF V_BANDERA = 22 THEN OPEN CV_1 FOR
SELECT
    *
FROM
    (
        SELECT
            DISTINCT CAT_CO_RESULTADO "Codigo",
            CAT_CO_RDESCRIPCION "Descripcion",
            SUBSTR(
                CAT_CO_PONDERACION,
                INSTR(
                    CAT_CO_PONDERACION,
                    '|',
                    1,
                    V_VALOR
                ) + 1,
                INSTR (CAT_CO_PONDERACION, '|', 1, V_VALOR + 1) - INSTR (CAT_CO_PONDERACION, '|', 1, V_VALOR) - 1
            ) CAT_CO_PONDERACION
        FROM
            CAT_CODIGOS
        WHERE
            SUBSTR(CAT_CO_PRODUCTO, V_VALOR, 1) = 1
    )
ORDER BY
    TO_NUMBER(CAT_CO_PONDERACION) ASC;

ELSIF V_BANDERA = 23 THEN OPEN CV_1 FOR
SELECT
    CAT_CA_ID "Id",
    CAT_CA_CODIGO "Codigo",
    CAT_CA_DESCRIPCION "Descripcion",
    NVL(CAT_CA_PESO, 0) "Peso"
FROM
    CAT_COD_ACCION
ORDER BY
    CAT_CA_ID;

ELSIF V_BANDERA = 24 THEN OPEN CV_1 FOR
SELECT
    CAT_CR_ID "Id",
    CAT_CR_CODIGO "Codigo",
    CAT_CR_DESCRIPCION "Descripcion",
    NVL(CAT_CR_PESO, 0) "Peso"
FROM
    CAT_COD_RESULTADO
ORDER BY
    2;

ELSIF V_BANDERA = 25 THEN OPEN CV_1 FOR
SELECT
    CAT_NP_ID "Id",
    CAT_NP_CODIGO "Codigo",
    CAT_NP_DESCRIPCION "Descripcion",
    NVL(CAT_NP_PESO, 0) "Peso"
FROM
    CAT_COD_NOPAGO
ORDER BY
    2;
ELSIF V_BANDERA=27 THEN--CATALOGO DE ETIQUETAS CORREO
  OPEN CV_1 FOR SELECT CAT_EC_DESCRIPCION, CAT_EC_CAMPOREAL FROM CAT_ETIQUETAS_CORREO;
ELSIF V_BANDERA = 29 THEN OPEN CV_1 FOR
SELECT
    CAT_CRES_DESCRIPCION RESTRICCION
FROM
    CAT_COD_RESTRICCION
WHERE
    CAT_CRES_NIVEL = '1';

ELSIF V_BANDERA = 31 THEN OPEN CV_1 FOR
    SELECT CAT_CRES_DESCRIPCION RESTRICCION FROM CAT_COD_RESTRICCION WHERE CAT_CRES_NIVEL = '3';

ELSIF V_BANDERA = 32 THEN 

    IF V_VALOR = 0 THEN
        OPEN CV_1 FOR SELECT CAT_RG_ID V_VALOR, CAT_RG_NOMBRERESPONSABLE T_VALOR
 FROM CAT_RESPONSABLES_GESTION WHERE CAT_RG_ID<=2;
    ELSIF V_VALOR = 1 THEN
        OPEN CV_1 FOR SELECT CAT_RG_ID V_VALOR, CAT_RG_NOMBRERESPONSABLE T_VALOR
 FROM CAT_RESPONSABLES_GESTION WHERE CAT_RG_ID=3;
    ELSIF V_VALOR = 2 THEN
        OPEN CV_1 FOR SELECT CAT_RG_ID V_VALOR, CAT_RG_NOMBRERESPONSABLE T_VALOR
 FROM CAT_RESPONSABLES_GESTION WHERE CAT_RG_ID=4;
    ELSIF V_VALOR = 3 THEN
        OPEN CV_1 FOR SELECT CAT_RG_ID V_VALOR, CAT_RG_NOMBRERESPONSABLE T_VALOR
 FROM CAT_RESPONSABLES_GESTION WHERE CAT_RG_ID=5;
    END IF;
ELSIF V_BANDERA = 35 THEN
    OPEN CV_1 FOR  SELECT CAT_IN_ID V_VALOR, CAT_IN_NOMBRE T_VALOR FROM CAT_INSTANCIAS ORDER BY CAT_IN_ID;
ELSIF V_BANDERA = 36 THEN 
OPEN CV_1 FOR 'select CAT_LO_USUARIO V_VALOR, ''[''||CAT_LO_USUARIO||''] ''|| in
itcap(CAT_LO_NOMBRE) T_VALOR from cat_logins  
             where cat_lo_estatus!=''Cancelado'' ' || V_VALOR;
ELSIF V_BANDERA = 38 THEN 
OPEN CV_1 FOR SELECT CAT_LO_USUARIO VVIS, CAT_LO_NOMBRE TVIS
FROM CAT_LOGINS JOIN CAT_PERFILES ON CAT_PE_ID = CAT_LO_PERFIL WHERE TO_NUMBER(CAT_PE_P_MOVIL) > 0 ORDER BY 2;

ELSIF V_BANDERA = 39 THEN 
   OPEN CV_1 FOR SELECT CAT_CO_NOPAGO FROM CAT_CODIGOS WHERE CAT_CO_ACCION =V_VALOR AND CAT_CO_RESULTADO = V_VALOR2;

ELSIF V_BANDERA = 40 THEN 
    OPEN CV_1 FOR SELECT CAT_NP_CODIGO VVAL, CONCAT(CONCAT(CONCAT('(',CAT_NP_CODIGO),') '),CAT_NP_DESCRIPCION) TVAL FROM CAT_COD_NOPAGO WHERE SUBSTR(V_VALOR,CAT_NP_ID,1)='1';

ELSIF V_BANDERA = 41 THEN 
    OPEN CV_1 FOR SELECT CAT_LO_USUARIO TEXTO, CAT_LO_EMAIL VALOR FROM CAT_LOGINS  WHERE CAT_LO_EMAIL IS NOT NULL  ORDER BY 1;
ELSIF V_BANDERA = 42 THEN 
    OPEN CV_1 FOR SELECT CAT_PR_ID ID,
CAT_PR_PRODUCTO  PRODUCTO FROM CAT_PRODUCTOS ORDER BY CAT_PR_ID;

ELSIF V_BANDERA = 43 THEN -- CATALOGO DE VARIABLES
OPEN CV_1 FOR
SELECT
     CASE WHEN CAT_VA_DESCRIPCION IN ('LDAP_Contrasena','LDAP_Dominio','LDAP_Rut
a','LDAP_Usuario') THEN DECRYPTFMC(CAT_VA_VALOR)
          ELSE CAT_VA_VALOR END AS VALOR
FROM
    CAT_VARIABLES
WHERE CAT_VA_DESCRIPCION = V_VALOR ;

ELSIF V_BANDERA = 44 THEN -- CATALOGO DE Buckets para bonificaciones
OPEN CV_1 FOR select distinct PR_CL_BUCKET VALOR, PR_CL_BUCKET TEXTO  from pr_cliente order by 1;

ELSIF V_BANDERA = 45 THEN -- CATALOGO DE RootFile para bonificaciones
OPEN CV_1 FOR select distinct PR_CL_ROOT_FILE VALOR, PR_CL_ROOT_FILE TEXTO  from
 pr_cliente order by 1;    
ELSIF V_BANDERA = 46 THEN -- CATALOGO DE cuestionarios codigos
OPEN CV_1 FOR select  CAT_CU_ID_CUEST VALOR, CAT_CU_NOMBRE ||':'|| CAT_CU_DESCRIPCION TEXTO  from cat_cuestionarios where cat_cu_estatus = 1 order by 2 ;    
ELSIF V_BANDERA = 47 THEN -- CATALOGO DE preguntas para un codigo (Pantalla Gestion)

select cat_co_id into v_IdCodigo from cat_codigos where CAT_CO_ACCION = v_valor 
and  CAT_CO_RESULTADO = v_valor2;

OPEN CV_1 FOR  

    select CAT_CU_ID_CUEST CUESTIONARIO, CAT_P_ID_PREG IDPREGUNTA,CAT_P_PREGUNTA
 PREGUNTA,CAT_PC_RESPUESTA RESPUESTA_AUX, CAT_PC_TIPO TIPO_RESPUESTA,NVL(CAT_PC_SUBTIPO,' ') SUBTIPO, nvl(CAT_PC_CLASE,' ') CLASE
   from cat_cuestionarios  
   join CAT_CUESTIONARIO_PREG on CAT_CU_ID_CUEST = CAT_CP_ID_CUEST
   join CAT_PREGUNTAS on CAT_PC_ID_PREG = CAT_P_ID_PREG
   join CAT_PREG_RESP on  CAT_P_ID_PREG = CAT_PR_ID_PREG
   join CAT_RESPUESTAS on CAT_PR_ID_RESP = CAT_PC_ID_RESP
    join REL_CODIGO_CUESTIONARIO on  REL_CC_IDCUESTIONARIO = CAT_CU_ID_CUEST
   where REL_CC_IDCODIGO = v_IdCodigo   
   order by CAT_P_ID_PREG;
 ELSIF V_BANDERA = 48 THEN -- NOp ago
OPEN CV_1 FOR 
select  'AAAAA' VALOR, 'Seleccione' TEXTO from dual
union all
select  CAT_NP_CODIGO VALOR, CAT_NP_DESCRIPCION TEXTO  from CAT_COD_NOPAGO order
 by 1;


 ELSIF V_BANDERA = 49 THEN -- Ejecucuion de reglas y "En duro" para cuestionarios


     select replace(cat_rd_consulta,'SUSTITUTO',V_VALOR2) into v_qry from cat_respuestas_duro where cat_rd_id = V_VALOR;


    OPEN CV_1 FOR v_qry;

 ELSIF V_BANDERA = 50 THEN -- Ejecucuion de reglas y "En duro" para cuestionarios cunado se ocupe el usuario


     select replace(replace(cat_rd_consulta,'SUSTITUTO',FN_SPLIT(V_VALOR2,'-',1)
),'USUARIO',FN_SPLIT(V_VALOR2,'-',2)) into v_qry from cat_respuestas_duro where 
cat_rd_id = V_VALOR;


    OPEN CV_1 FOR  v_qry ;


 ELSIF V_BANDERA = 51 THEN
    OPEN CV_1 FOR SELECT CAT_CR_SCRIPT FROM CAT_COD_RESULTADO WHERE CAT_CR_CODIGO = V_VALOR;

 ELSIF V_BANDERA = 52 THEN
    SELECT replace(CAT_PS_CONFIGURACION,'SUSTITUTO',V_VALOR2) as AA into v_qry FROM CAT_PLANTILLAS_SCRIPTS WHERE CAT_PS_NOMBRE= V_VALOR;
    OPEN CV_1 FOR   v_qry ;
 ELSIF V_BANDERA = 53 THEN

    OPEN CV_1 FOR 
    select case when V_VALOR2 = 'MV' then PR_CL_MONTO_VENCIDO when V_VALOR2 = 'PM' then PR_CL_MINIMUM_PAYMENT else 
        case when PR_CL_MONTO_VENCIDO = 0 then  PR_CL_MINIMUM_PAYMENT else PR_CL_MONTO_VENCIDO end
    end from pr_cliente where pr_CL_expediente_MC = V_VALOR;

ELSIF V_BANDERA = 54 THEN


     OPEN CV_1 FOR 
    select 
    count(*)
    from CAT_BUCKET_ROOT_PLANES 
    where CAT_BRP_BUCKET = upper(V_VALOR) 
    and  CAT_BRP_ROOT_FILE = upper(V_VALOR2);

ELSIF V_BANDERA = 55 THEN


     OPEN CV_1 FOR 
    select 
    count(*)
    from CAT_BUCKET_ROOT_QUITAS 
    where CAT_BRQ_BUCKET = upper(V_VALOR) 
    and  CAT_BRQ_ROOT_FILE = upper(V_VALOR2);

ELSIF V_BANDERA = 56 THEN


     OPEN CV_1 FOR 
    select 
    pr_mc_expediente
    from pr_mc_gral where pr_mc_credito =   upper(V_VALOR) ;

ELSIF V_BANDERA = 57 THEN 

 select
    'SELECT ' ||
        CASE WHEN V_VALOR2 ='OT' THEN 
            'CASE WHEN ' || Cat_cp_referencia || ' > 0 THEN ' || Cat_cp_referencia 
                        || ' WHEN ' || Cat_cp_referencia || ' = 0 AND ' || Cat_cp_referencia2 || ' > 0 THEN ' || Cat_cp_referencia2 
                        || ' WHEN ' || Cat_cp_referencia3 || ' IS NULL THEN ' || '0' 
                        || ' ELSE ' || Cat_cp_referencia3 || ' END'        
        ELSE
            V_VALOR2 
        END
        || ' VAL FROM VI_INFORMACION_CLIENTE WHERE PR_CL_EXPEDIENTE_MC = ''' || V_VALOR || ''''

        INTO v_qry from cat_config_promesas WHERE CAT_CP_FILA = 'Global'; 

        INSERT INTO AAA VALUES('57-'|| V_QRY,SYSDATE);            

OPEN CV_1 FOR  v_qry ;


elsif V_BANDERA = 58 THEN -- CATALOGO DE VARIABLES
OPEN CV_1 FOR


select * from (
SELECT
    CAT_VA_DESCRIPCION,
    CAT_VA_VALOR
FROM
    CAT_VARIABLES
    where CAT_VA_DESCRIPCION not in ('LDAP_Dominio','LDAP_Ruta','LDAP_Usuario','LDAP_Contrasena') 
)
pivot 
(
   max(CAT_VA_VALOR)
   for CAT_VA_DESCRIPCION in (
   'Consecutivo Promesas' "Consecutivo Promesas"
   ,'Capacidad Maxima Usuario' "Capacidad Maxima Usuario"
   ,'Capacidad Maxima Agencia' "Capacidad Maxima Agencia"
   ,'Codigo Causa No Pago' NOPAGO
   ,'Holgura Monto' "Holgura Monto"
   ,'Holgura Fecha' "Holgura Fecha"
   ,'Codigo Accion' ACCION
   ,'LDAP_SSL' "LDAP_SSL"
   ,'LDAP_Puerto' "LDAP_Puerto"
   ,'LDAP' "LDAP"
   ,'Consecutivo Acuerdos'  "Consecutivo Acuerdos"
   )
);



END IF;

END;