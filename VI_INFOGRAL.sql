CREATE OR REPLACE FORCE EDITIONABLE VIEW "VI_INFOGRAL" ("PR_MC_COMENT
ARIO", "PR_MC_GRUPO", "PR_MC_EXPEDIENTE", "PR_MC_CLIENTE", "PR_MC_CREDITO", "PR_
MC_PRODUCTO", "PR_MC_SUBPRODUCTO", "PR_MC_ESTATUS", "PR_MC_CODIGO", "PR_MC_RESUL
TADO", "PR_MC_ACCION", "PR_MC_UNIVERSO_CC", "PR_MC_MUESTRA_CC", "PR_MC_ACUERDOS_
ROTOS", "PR_MC_CAUSANOPAGO", "PR_MC_DESPACHOASIGNADO", "PR_MC_DTEFILAPREV", "PR_
MC_ESTATUS_PROMESA", "PR_MC_ETIQUETA", "PR_MC_EXCLUSION", "PR_MC_IDREGLAASIG", "
PR_MC_INSTANCIA", "PR_MC_INSTANCIAPREV", "PR_MC_LATITUD", "PR_MC_LONGITUD", "PR_
MC_MTOPAGOFALTANTENEG", "PR_MC_MTOPAGOFALTANTEPAR", "PR_MC_MTOPAGONEG", "PR_MC_M
TOPAGONEGCUMP", "PR_MC_MTOPAGOPAR", "PR_MC_MTOPAGOPARCUMP", "PR_MC_NOMBREFILA", 
"PR_MC_NOPROMNEGCUMP", "PR_MC_NOPROMNEGINC", "PR_MC_NOPROMNEGOCIACION", "PR_MC_N
OPROMPARCIALES", "PR_MC_NOPROMPARCUMP", "PR_MC_NOPROMPARINC", "PR_MC_DTE_VIGENCI
A", "PR_MC_FECHA_CC", "PR_MC_TIPO_CC", "PR_MC_DTEGESTION", "PR_MC_UASIGNADO", "P
R_MC_UASIGNADO_ANT", "PR_MC_USUARIO", "PR_MC_DTEPCONTACTO", "PR_MC_NOGESTIONES",
 "PR_MC_CODRELEV", "PR_MC_RESULTADORELEV", "PR_MC_DTERESULTADORELEV", "PR_MC_COD
IGOVISITA", "PR_MC_RESULTADOV", "PR_MC_DTEVISITA", "PR_MC_NOVISITAS", "PR_MC_VIS
ITADOR", "PR_MC_FILA", "PR_MC_DTEFILA", "PR_MC_MODAL", "PR_MC_SECFILA", "PR_MC_M
ONTOPP", "PR_MC_DTEPP", "PR_MC_MTOUP", "PR_MC_DTEUP", "PR_MC_DTECARGAINI", "PR_M
C_DTECARGA", "PR_MC_DTERETIRO", "PR_MC_AGENCIA", "PR_MC_DTEASIGNA", "PR_MC_DTEAS
IGNAV", "PR_MC_DTEASIGNAV_ANT", "PR_MC_DTEASIGNA_ANT", "PR_MC_CREDITOCONTACTADO"
, "PR_MC_DTECREDITOCONTACTADO", "PR_MC_PRIMERAGESTION", "PR_MC_DTEPRIMERAGESTION
", "PR_MC_UASIGNADOV", "PR_MC_UASIGNADOV_ANT", "PR_MC_DTEREACTIVA", "VI_SEMAFORO
_GESTION", "VI_DIAS_SEMAFORO_GESTION") AS 
  SELECT
        NVL(PR_MC_COMENTARIO, ' ') PR_MC_COMENTARIO,
        NVL(PR_MC_GRUPO, 0) PR_MC_GRUPO,
        NVL(PR_MC_EXPEDIENTE, ' ') PR_MC_EXPEDIENTE,
        NVL(PR_MC_CLIENTE, ' ') PR_MC_CLIENTE,
        NVL(PR_MC_CREDITO, ' ') PR_MC_CREDITO,
        NVL(PR_MC_PRODUCTO, ' ') PR_MC_PRODUCTO,
        NVL(PR_MC_SUBPRODUCTO, ' ') PR_MC_SUBPRODUCTO,
        NVL(PR_MC_ESTATUS, ' ') PR_MC_ESTATUS,
        NVL(PR_MC_CODIGO, ' ') PR_MC_CODIGO,
        NVL(PR_MC_RESULTADO, ' ') PR_MC_RESULTADO,
        NVL(PR_MC_ACCION, ' ') PR_MC_ACCION,
        NVL(PR_MC_UNIVERSO_CC,' ') PR_MC_UNIVERSO_CC,
        NVL(PR_MC_MUESTRA_CC,' ') PR_MC_MUESTRA_CC,
        NVL(PR_MC_ACUERDOS_ROTOS,0) PR_MC_ACUERDOS_ROTOS,
        NVL(PR_MC_CAUSANOPAGO, ' ') PR_MC_CAUSANOPAGO,
        NVL(PR_MC_DESPACHOASIGNADO,' ') PR_MC_DESPACHOASIGNADO,
        NVL(TO_CHAR(PR_MC_DTEFILAPREV,'DD/MM/YYYY'),' ') PR_MC_DTEFILAPREV,
        NVL(PR_MC_ESTATUS_PROMESA,' ') PR_MC_ESTATUS_PROMESA,
        NVL(PR_MC_ETIQUETA, ' ') PR_MC_ETIQUETA,
        NVL(TO_CHAR(PR_MC_EXCLUSION), ' ') PR_MC_EXCLUSION,
        NVL(PR_MC_IDREGLAASIG ,0 )PR_MC_IDREGLAASIG,
        NVL(PR_MC_INSTANCIA,' ' )PR_MC_INSTANCIA,
        NVL(PR_MC_INSTANCIAPREV,' ' )PR_MC_INSTANCIAPREV,
        NVL(PR_MC_LATITUD,' ' ) PR_MC_LATITUD,
        NVL(PR_MC_LONGITUD,' ' ) PR_MC_LONGITUD,
        NVL(PR_MC_MTOPAGOFALTANTENEG,0 ) PR_MC_MTOPAGOFALTANTENEG,
        NVL(PR_MC_MTOPAGOFALTANTEPAR,0 ) PR_MC_MTOPAGOFALTANTEPAR,
        NVL(PR_MC_MTOPAGONEG,0 )  PR_MC_MTOPAGONEG,
        NVL(PR_MC_MTOPAGONEGCUMP,0 ) PR_MC_MTOPAGONEGCUMP,
        NVL(PR_MC_MTOPAGOPAR,0 ) PR_MC_MTOPAGOPAR,
        NVL(PR_MC_MTOPAGOPARCUMP,0 ) PR_MC_MTOPAGOPARCUMP,
        NVL(PR_MC_NOMBREFILA,' ' ) PR_MC_NOMBREFILA,
        NVL(PR_MC_NOPROMNEGCUMP,0 ) PR_MC_NOPROMNEGCUMP,
        NVL(PR_MC_NOPROMNEGINC,0 ) PR_MC_NOPROMNEGINC,
        NVL(PR_MC_NOPROMNEGOCIACION,0 ) PR_MC_NOPROMNEGOCIACION,
        NVL(PR_MC_NOPROMPARCIALES,0 ) PR_MC_NOPROMPARCIALES,
        NVL(PR_MC_NOPROMPARCUMP,0 ) PR_MC_NOPROMPARCUMP,
        NVL(PR_MC_NOPROMPARINC,0 )  PR_MC_NOPROMPARINC,
        CASE
            WHEN PR_MC_DTE_VIGENCIA IS NULL
                 OR TO_CHAR(PR_MC_DTE_VIGENCIA, 'DD/MM/YYYY') = '01/01/1900' THE
N
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTE_VIGENCIA)
        END AS PR_MC_DTE_VIGENCIA     ,
	CASE 
            WHEN PR_MC_FECHA_CC IS NULL
                 OR TO_CHAR(PR_MC_FECHA_CC, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_FECHA_CC)
        END AS PR_MC_FECHA_CC,
        NVL(PR_MC_TIPO_CC,' ') PR_MC_TIPO_CC,
        CASE
            WHEN PR_MC_DTEGESTION IS NULL
                 OR TO_CHAR(PR_MC_DTEGESTION, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEGESTION)
        END AS PR_MC_DTEGESTION,
        NVL(PR_MC_UASIGNADO, ' ') PR_MC_UASIGNADO,
        NVL(PR_MC_UASIGNADO_ANT, ' ') PR_MC_UASIGNADO_ANT,
        NVL(PR_MC_USUARIO, ' ') PR_MC_USUARIO,
        CASE
            WHEN PR_MC_DTEPCONTACTO IS NULL
                 OR TO_CHAR(PR_MC_DTEPCONTACTO, 'DD/MM/YYYY') = '01/01/1900' THE
N
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEPCONTACTO)
        END AS PR_MC_DTEPCONTACTO,
        NVL(PR_MC_NOGESTIONES, 0) PR_MC_NOGESTIONES,
        NVL(PR_MC_CODRELEV, ' ') PR_MC_CODRELEV,
        NVL(PR_MC_RESULTADORELEV, ' ') PR_MC_RESULTADORELEV,
        CASE
            WHEN PR_MC_DTERESULTADORELEV IS NULL
                 OR TO_CHAR(PR_MC_DTERESULTADORELEV, 'DD/MM/YYYY') = '01/01/1900
' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTERESULTADORELEV)
        END AS PR_MC_DTERESULTADORELEV,
        NVL(PR_MC_CODIGOVISITA, ' ') PR_MC_CODIGOVISITA,
        NVL(PR_MC_RESULTADOV, ' ') PR_MC_RESULTADOV,
        CASE
            WHEN PR_MC_DTEVISITA IS NULL
                 OR TO_CHAR(PR_MC_DTEVISITA, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEVISITA)
        END AS PR_MC_DTEVISITA,
        NVL(PR_MC_NOVISITAS, 0) PR_MC_NOVISITAS,
        NVL(PR_MC_VISITADOR, ' ') PR_MC_VISITADOR,
        NVL(PR_MC_FILA, ' ') PR_MC_FILA,
        CASE
            WHEN PR_MC_DTEFILA IS NULL
                 OR TO_CHAR(PR_MC_DTEFILA, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEFILA)
        END AS PR_MC_DTEFILA,
        NVL(PR_MC_MODAL, 0) PR_MC_MODAL,
        NVL(PR_MC_SECFILA, 0) PR_MC_SECFILA,
        NVL(PR_MC_MONTOPP, 0) PR_MC_MONTOPP,
        CASE
            WHEN PR_MC_DTEPP IS NULL
                 OR TO_CHAR(PR_MC_DTEPP, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEPP)
        END AS PR_MC_DTEPP,
        NVL(PR_MC_MTOUP, 0) PR_MC_MTOUP,
        CASE
            WHEN PR_MC_DTEUP IS NULL
                 OR TO_CHAR(PR_MC_DTEUP, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEUP)
        END AS PR_MC_DTEUP,
        CASE
            WHEN PR_MC_DTECARGAINI IS NULL
                 OR TO_CHAR(PR_MC_DTECARGAINI, 'DD/MM/YYYY') = '01/01/1900' THEN

                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTECARGAINI)
        END AS PR_MC_DTECARGAINI,
        CASE
            WHEN PR_MC_DTECARGA IS NULL
                 OR TO_CHAR(PR_MC_DTECARGA, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTECARGA)
        END AS PR_MC_DTECARGA,
        CASE
            WHEN PR_MC_DTERETIRO IS NULL
                 OR TO_CHAR(PR_MC_DTERETIRO, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTERETIRO)
        END AS PR_MC_DTERETIRO,
        NVL(PR_MC_AGENCIA, 0) PR_MC_AGENCIA,
        CASE
            WHEN PR_MC_DTEASIGNA IS NULL
                 OR TO_CHAR(PR_MC_DTEASIGNA, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEASIGNA)
        END AS PR_MC_DTEASIGNA,
        CASE
            WHEN PR_MC_DTEASIGNAV IS NULL
                 OR TO_CHAR(PR_MC_DTEASIGNAV, 'DD/MM/YYYY') = '01/01/1900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEASIGNAV)
        END AS PR_MC_DTEASIGNAV,
        CASE
            WHEN PR_MC_DTEASIGNAV_ANT IS NULL
                 OR TO_CHAR(PR_MC_DTEASIGNAV_ANT, 'DD/MM/YYYY') = '01/01/1900' T
HEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEASIGNAV_ANT)
        END AS PR_MC_DTEASIGNAV_ANT,
        CASE
            WHEN PR_MC_DTEASIGNA_ANT IS NULL
                 OR TO_CHAR(PR_MC_DTEASIGNA_ANT, 'DD/MM/YYYY') = '01/01/1900' TH
EN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEASIGNA_ANT)
        END AS PR_MC_DTEASIGNA_ANT,
        NVL(PR_MC_CREDITOCONTACTADO, 0) PR_MC_CREDITOCONTACTADO,
        CASE
            WHEN PR_MC_DTECREDITOCONTACTADO IS NULL
                 OR TO_CHAR(PR_MC_DTECREDITOCONTACTADO, 'DD/MM/YYYY') = '01/01/1
900' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTECREDITOCONTACTADO)
        END AS PR_MC_DTECREDITOCONTACTADO,
        NVL(PR_MC_PRIMERAGESTION, ' ') PR_MC_PRIMERAGESTION,
        CASE
            WHEN PR_MC_DTEPRIMERAGESTION IS NULL
                 OR TO_CHAR(PR_MC_DTEPRIMERAGESTION, 'DD/MM/YYYY') = '01/01/1900
' THEN
                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEPRIMERAGESTION)
        END AS PR_MC_DTEPRIMERAGESTION,
        NVL(PR_MC_UASIGNADOV, ' ') PR_MC_UASIGNADOV,
        NVL(PR_MC_UASIGNADOV_ANT, ' ') PR_MC_UASIGNADOV_ANT,
        CASE
            WHEN PR_MC_DTEREACTIVA IS NULL
                 OR TO_CHAR(PR_MC_DTEREACTIVA, 'DD/MM/YYYY') = '01/01/1900' THEN

                TO_DATE('01/01/1900')
            ELSE
                TO_DATE(PR_MC_DTEREACTIVA)
        END AS PR_MC_DTEREACTIVA,
        (
            CASE
                WHEN ROUND(SYSDATE - PR_MC_DTEGESTION) <= (
                    SELECT
                        CAT_CO_VERDE
                    FROM
                        CAT_CODIGOS
                    WHERE
                        NVL(CAT_CO_ACCION, '')
                        || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')
                ) THEN
                    'VERDE'
                WHEN ROUND(SYSDATE - PR_MC_DTEGESTION) < (
                    SELECT
                        CAT_CO_AMARILLO
                    FROM
                        CAT_CODIGOS
                    WHERE
                        NVL(CAT_CO_ACCION, '')
                        || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')
                ) THEN
                    'AMARILLO'
                ELSE
                    'ROJO'
            END
        ) AS VI_SEMAFORO_GESTION,
        (
            CASE
                WHEN ROUND(SYSDATE - PR_MC_DTEGESTION) <= (
                    SELECT
                        CAT_CO_VERDE
                    FROM
                        CAT_CODIGOS
                    WHERE
                        NVL(CAT_CO_ACCION, '')
                        || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')
                ) THEN
                    ( ABS(ROUND((SYSDATE - PR_MC_DTEGESTION) -(
                        SELECT
                            CAT_CO_AMARILLO
                        FROM
                            CAT_CODIGOS
                        WHERE
                            NVL(CAT_CO_ACCION, '')
                            || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')

                    ))) )
                    || ' Dias Para Cambiar A Semaforo Amarillo'
                WHEN ROUND(SYSDATE - PR_MC_DTEGESTION) > (
                    SELECT
                        CAT_CO_VERDE
                    FROM
                        CAT_CODIGOS
                    WHERE
                        NVL(CAT_CO_ACCION, '')
                        || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')
                )
                     AND ROUND(SYSDATE - PR_MC_DTEGESTION) < (
                    SELECT
                        CAT_CO_AMARILLO
                    FROM
                        CAT_CODIGOS
                    WHERE
                        NVL(CAT_CO_ACCION, '')
                        || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')
                ) THEN
                    ( ABS(ROUND((SYSDATE - PR_MC_DTEGESTION) -(
                        SELECT
                            CAT_CO_AMARILLO
                        FROM
                            CAT_CODIGOS
                        WHERE
                            NVL(CAT_CO_ACCION, '')
                            || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')

                    ))) )
                    || ' Dias Para Cambiar A Semaforo Rojo'
                ELSE
                    'Credito Sin Gestion o Gestionado Hace Mas De '
                    || NVL((
                        SELECT
                            CAT_CO_AMARILLO
                        FROM
                            CAT_CODIGOS
                        WHERE
                            NVL(CAT_CO_ACCION, '')
                            || NVL(CAT_CO_RESULTADO, '') = NVL(PR_MC_CODIGO, '')

                    ), ABS(TRUNC(PR_MC_DTEASIGNA) - TRUNC(SYSDATE)))
                    || ' Dias'
            END
        ) AS VI_DIAS_SEMAFORO_GESTION
        from pr_mc_gral
