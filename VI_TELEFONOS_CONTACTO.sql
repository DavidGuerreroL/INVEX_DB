  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VI_TELEFONOS_CONTACTO" ("NO
MBRE", "CREDITO", "TELEFONO", "CALPOS", "DTECALPOS", "CALNE", "DTECALNE", "TIPO"
, "CLASE", "FUENTE", "CAMPOPOS", "CAMPONES", "CAMPODTEPOS", "CAMPODTENES", "TABL
A", "EXPEDIENTE", "CONTACTO", "IsUltimo") AS 
  SELECT  /*+ LEADING(pr_mc_gral hist_telefonos) USE_NL(hist_telefonos)*/
        nvl(hist_te_nombre,' ')        nombre,
        nvl(pr_mc_credito,' ')         credito,
        nvl(hist_te_numerotel,' ')     telefono,
        nvl(hist_te_calpotel, 0) calpos,
         CASE
            WHEN hist_te_caldtepotel IS NULL
                 OR to_char(hist_te_caldtepotel, 'DD/MM/YYYY') = '01/01/1900' TH
EN
                to_date('01/01/1900')
            ELSE
                to_date(hist_te_caldtepotel)
        END AS dtecalpos,
        nvl(hist_te_calnetel,0)      calne,
        CASE
            WHEN hist_te_caldtenetel IS NULL
                 OR to_char(hist_te_caldtenetel, 'DD/MM/YYYY') = '01/01/1900' TH
EN
                to_date('01/01/1900')
            ELSE
                to_date(hist_te_caldtenetel)
        END AS dtecalne,
        nvl(hist_te_parentesco,' ')    tipo,
        ' ' clase,
        nvl(hist_te_fuente,' ')        fuente,
        'HIST_TE_CALPOTEL' campopos,
        'HIST_TE_CALNETEL' campones,
        'HIST_TE_CALDTEPOTEL' campodtepos,
        'HIST_TE_CALDTENETEL' campodtenes,
        'HIST_TELEFONOS' tabla,
        PR_MC_EXPEDIENTE EXPEDIENTE,
        case HIST_TE_CONTACTO when 1 then 'Activo' when 0 then 'Inactivo' else '
Inactivo' end as Contacto,
        nvl(HIST_TE_ULTIMO,0) "IsUltimo"
    FROM
        hist_telefonos
        JOIN pr_mc_gral ON hist_te_expediente = pr_mc_expediente