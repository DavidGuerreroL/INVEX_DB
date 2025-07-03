CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_BATCH" 
AS
err_msg VARCHAR2(1000);
TYPE TIPOCURSOR IS REF CURSOR;
CURSORD  TIPOCURSOR;
CURSORA  TIPOCURSOR;
v_expediente varchar(25);
cancela number;
v_Acuerdo varchar2(100);
v_dias_pinicial number;
v_existe number;
v_monto_pagado number(18,2);
v_monto_nego number(18,2);
v_sobrante number(18,2);
v_pago_total number(18,2);
v_cuantos_incump number;
v_posbibles_incump number;
BEGIN
    -- Cambiar el esquema actual
    EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = SC_SGC';
  insert into hist_auditoria_global  (HIST_AUG_FECHA, HIST_AUG_QUIEN, HIST_AUG_DONDE, HIST_AUG_EVENTO) values(sysdate,'Automatico','Asignacion Global','Batch');


    --Calcula el score total
    /*for x in(select distinct CAT_RE_NOMBRE,CAT_RE_SCORE from cat_reglas where 
nvl(CAT_RE_SCORE,0)!=0)
    loop
        OPEN CURSORD for FN_ARMAR_QUERY_SCORE_BATCH(x.CAT_RE_NOMBRE);
        LOOP
            FETCH CURSORD INTO v_expediente;
                update PR_MC_GRAL set PR_MC_SCORETOTAL=nvl(PR_MC_SCORETOTAL,0)+x
.CAT_RE_SCORE where pr_mc_expediente=v_expediente;
                v_expediente:='';
                commit;
            EXIT WHEN CURSORD%NOTFOUND;
        END LOOP;
        CLOSE CURSORD;
    end loop;
        */

    -----------------------------/* pendiente ver si le pega la evaluacion de acuerdos
    update HIST_PROMESAS set Hist_pr_Estatus='Incumplida',HIST_pr_DTEINCUMPLIDA=sysdate WHERE nvl(Hist_pr_Estatus,' ')
    not in ('Cumplida','Cancelada','Parcial','Incumplida','Aplazada') and
    trunc(Hist_pr_Dtepromesa + (SELECT CAT_VA_VALOR FROM CAT_VARIABLES WHERE  CAT_VA_DESCRIPCION='Holgura Fecha'
    )) <= trunc(sysdate);
    Commit;
   ---------------------------------------------------------------

   --Expira o cancela usuarios
    for x in (select Cat_Lo_Dteultimoingreso,CAT_LO_DTEEXPIRA,cat_lo_usuario from cat_logins where Cat_Lo_Estatus!='Cancelado')
    loop
        SELECT CAT_VALOR into cancela FROM Cat_Politica_Contrasena WHERE CAT_DESC = 'Cancelar Por Inactividad';
        If floor(sysdate-X.Cat_Lo_Dteultimoingreso) > cancela THEN
            UPDATE cat_logins SET cat_lo_estatus='Cancelado',Cat_Lo_Dteaccion=SYSDATE WHERE cat_lo_usuario=X.cat_lo_usuario;
            null;
        ELSE
          IF TRUNC(X.CAT_LO_DTEEXPIRA)=TRUNC(SYSDATE) THEN
            UPDATE cat_logins SET cat_lo_estatus='Expirado',CAT_LO_DTEEXPIRA=SYSDATE +(SELECT CAT_VALOR FROM Cat_Politica_Contrasena WHERE CAT_DESC = 'Vigencia'
)
            WHERE cat_lo_usuario=X.cat_lo_usuario AND cat_lo_estatus<>'Cancelado';
          END IF;
        END IF;
    end loop;
    commit;

    --Reiniciar el contador de gestiones cada d�a para todos los usuarios
    UPDATE CAT_LOGINS SET CAT_LO_NUMGESTIONES = 0;
    COMMIT;

    --Estadisticas de la base
    begin
  	  	DBMS_STATS.GATHER_SCHEMA_STATS (  
  	  	  ownname => 'COBMC22',  
          estimate_percent => 100);
    end;

    --Reconstruye los indices
    FOR X IN (select 'alter index '|| owner ||'.'||OBJECT_NAME ||' rebuild' INDICE FROM ALL_OBJECTS WHERE OWNER=USER AND OBJECT_TYPE='INDEX')
    LOOP
        EXECUTE IMMEDIATE(X.INDICE);
    END LOOP;

    --Rehace los planes para ver las que estan activas y ejecutar el proceso que incerta los creditos en la tabla para ver en gestion


    DELETE CAT_PLAN_CREDITO;

    FOR CN IN (SELECT cat_pl_codigo FROM cat_planes where cat_pl_estatus = 'Activo')
    LOOP
        SP_PLANES ('13',CN.cat_pl_codigo,0,'','','','','','','','','','','',0,0,0,0,CURSORA);
        COMMIT;
    END LOOP;

    --Evaluacion de acuerdos
    for Acuerdos in(select distinct hist_aa_id_acuerdo from hist_autorizacion_acuerdos where hist_aa_estatus='Autorizado')
    loop
        SELECT HIST_EN_NOMBRE_ACUERDO,HIST_EN_EXPEDIENTE into v_Acuerdo,v_expediente
            FROM HIST_ESTATUS_ACUERDOS
                WHERE HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                DBMS_OUTPUT.PUT_LINE('Acuerdo '||Acuerdos.hist_aa_id_acuerdo||' '||v_Acuerdo);
        /*SELECT CAT_NE_DIA_INICIAL INTO v_dias_pinicial
            FROM CAT_NEGO
                WHERE CAT_NE_nombre=v_Acuerdo and rownum=1;
            */
        SELECT COUNT(*) into v_existe
            from hist_promesas
                where hist_pr_expediente=v_expediente and trunc(hist_pr_dtepromesa)=trunc(sysdate) AND HIST_PR_CONSECUTIVO=1 AND HIST_PR_ESTATUS='Pendiente';
                DBMS_OUTPUT.PUT_LINE('existe '||v_existe);
        IF v_existe >= 1 THEN
            SELECT SUM(HIST_PA_MONTO_TRANS) into v_monto_pagado
                FROM HIST_PAGOS JOIN PR_MC_GRAL ON PR_MC_CREDITO=HIST_PA_CUENTA AND PR_MC_GRUPO=HIST_PA_GRUPO
                    WHERE PR_MC_EXPEDIENTE=v_expediente AND HIST_PA_VALUADO=0 AND TRUNC(HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE);
                    DBMS_OUTPUT.PUT_LINE('v_monto_pagado '||v_monto_pagado);
             UPDATE
                (SELECT hp.HIST_PA_VALUADO
                    FROM HIST_PAGOS hp JOIN PR_MC_GRAL gr ON gr.PR_MC_CREDITO=hp.HIST_PA_CUENTA AND gr.PR_MC_GRUPO=hp.HIST_PA_GRUPO
                   WHERE gr.PR_MC_EXPEDIENTE=v_expediente AND NVL(hp.HIST_PA_VALUADO,0)=0 AND TRUNC(hp.HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE)) act
                SET act.HIST_PA_VALUADO = '1';

            SELECT HIST_PR_MONTOPP into v_monto_nego
                from hist_promesas
                    where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa)=trunc(sysdate) AND HIST_PR_CONSECUTIVO=1 AND HIST_PR_ESTATUS='Pendiente';
                    DBMS_OUTPUT.PUT_LINE('v_monto_nego '||v_monto_nego);
            v_sobrante := v_monto_pagado - v_monto_nego;
            DBMS_OUTPUT.PUT_LINE('v_sobrante '||v_sobrante);
            IF v_sobrante >= 0 THEN
                SELECT SUM(HIST_PR_MONTOPP) INTO v_pago_total
                    FROM HIST_PROMESAS
                         WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                       DBMS_OUTPUT.PUT_LINE('v_pago_total '||v_pago_total);
                IF v_pago_total <= v_monto_pagado THEN
                    v_sobrante := v_monto_pagado - v_pago_total;
                    DBMS_OUTPUT.PUT_LINE('v_sobrante pago total '||v_sobrante);
                    UPDATE HIST_PROMESAS
                        SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Cumplida'
                            WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                    UPDATE HIST_ESTATUS_ACUERDOS
                            SET HIST_EN_ESTATUS='Cumplida', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                    UPDATE PR_MC_GRAL
                        SET PR_MC_NOPROMNEGCUMP = NVL(PR_MC_NOPROMNEGCUMP,0)+1
                            WHERE PR_MC_EXPEDIENTE=v_expediente;
                ELSE
                DBMS_OUTPUT.PUT_LINE('sin pago tptal ');
                    UPDATE HIST_PROMESAS
                        SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Cumplida'
                            WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa)=trunc(sysdate);
                END IF;
            ELSE
            DBMS_OUTPUT.PUT_LINE('cancelada ');
                UPDATE HIST_PROMESAS
                    SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Incumplida',Hist_Pr_Motivo='Proceso BATCH'
                        WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                UPDATE HIST_ESTATUS_ACUERDOS
                    SET HIST_EN_ESTATUS='Rota', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                        where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                UPDATE HIST_AUTORIZACION_ACUERDOS
                    SET HIST_AA_ESTATUS= 'Rota', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                        WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                UPDATE PR_MC_GRAL
                    SET PR_MC_ACUERDOS_ROTOS = NVL(PR_MC_ACUERDOS_ROTOS,0)+1
                        WHERE PR_MC_EXPEDIENTE=v_expediente;
            END IF;
        ELSE
            SELECT COUNT(*) into v_existe
                from hist_promesas
                    where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo AND HIST_PR_CONSECUTIVO > 1 AND HIST_PR_ESTATUS='Pendiente';
                    DBMS_OUTPUT.PUT_LINE('Existe '|| v_existe);
            IF v_existe = 1 THEN

            DBMS_OUTPUT.PUT_LINE('ES EL ULTIMO PAGO ');
                SELECT COUNT(*) into v_existe
                    from hist_promesas
                        where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate);

                IF v_existe = 1 THEN
                    SELECT HIST_PR_MONTOPP ,NVL(HIST_PR_SOBRANTE,0) INTO v_monto_nego,V_SOBRANTE
                        FROM HIST_PROMESAS
                            WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate);

                    IF V_MONTO_NEGO = V_SOBRANTE THEN
                    DBMS_OUTPUT.PUT_LINE('ya se pago el ultimo pago con sobrantes');
                        UPDATE HIST_PROMESAS
                            SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Cumplida'
                                WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa+ hist_pr_dias_g)=trunc(sysdate);

                        UPDATE HIST_ESTATUS_ACUERDOS
                            SET HIST_EN_ESTATUS='Cumplida', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                    ELSE
                               DBMS_OUTPUT.PUT_LINE('no se pago el ultimo con sobrantes ');
                        SELECT NVL(HIST_PR_MONTOPP,0) - V_SOBRANTE into v_monto_nego
                            from hist_promesas
                                where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa+ hist_pr_dias_g)=trunc(sysdate);

                        SELECT SUM(nvl(HIST_PA_MONTO_TRANS,0)) into v_monto_pagado
                            FROM HIST_PAGOS JOIN PR_MC_GRAL ON PR_MC_CREDITO=HIST_PA_CUENTA AND PR_MC_GRUPO=HIST_PA_GRUPO
                                WHERE PR_MC_EXPEDIENTE=v_expediente AND HIST_PA_VALUADO=0 AND TRUNC(HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE);


                        UPDATE
                            (SELECT hp.HIST_PA_VALUADO
                                FROM HIST_PAGOS hp JOIN PR_MC_GRAL gr ON gr.PR_MC_CREDITO=hp.HIST_PA_CUENTA AND gr.PR_MC_GRUPO=hp.HIST_PA_GRUPO
                                    WHERE gr.PR_MC_EXPEDIENTE=v_expediente AND NVL(hp.HIST_PA_VALUADO,0)=0 AND TRUNC(hp.HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE)) act
                            SET act.HIST_PA_VALUADO = '1';

                        v_sobrante := v_monto_pagado - v_monto_nego;

                        IF v_sobrante >= 0 THEN
                        DBMS_OUTPUT.PUT_LINE('sobrante mayor  '||v_sobrante);
                            UPDATE HIST_PROMESAS
                                SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Cumplida'
                                    WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa+ hist_pr_dias_g)=trunc(sysdate);

                            UPDATE HIST_ESTATUS_ACUERDOS
                                SET HIST_EN_ESTATUS='Cumplida', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                    where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                            UPDATE HIST_AUTORIZACION_ACUERDOS
                                    SET HIST_AA_ESTATUS= 'Cumplida', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                        WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                            UPDATE PR_MC_GRAL
                                SET PR_MC_NOPROMNEGCUMP = NVL(PR_MC_NOPROMNEGCUMP,0)+1
                                    WHERE PR_MC_EXPEDIENTE=v_expediente;
                        ELSE
                        DBMS_OUTPUT.PUT_LINE('sobrante menor  '||v_sobrante);
                            UPDATE HIST_PROMESAS
                                SET HIST_PR_PAGO_REAL=v_monto_pagado, HIST_PR_SOBRANTE= v_sobrante,HIST_PR_ESTATUS='Incumplida'
                                    WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa+ hist_pr_dias_g)=trunc(sysdate) ;


                            UPDATE HIST_ESTATUS_ACUERDOS
                                SET HIST_EN_PAG_INCUMPLIDOS=NVL(HIST_EN_PAG_INCUMPLIDOS,0)+1
                                    WHERE HIST_EN_EXPEDIENTE=v_expediente;
                            --EVALUACION DE PROMESAS ROTAS

                            SELECT NVL(HIST_EN_PAG_INCUMPLIDOS,0) INTO v_cuantos_incump
                                FROM HIST_ESTATUS_ACUERDOS
                                    WHERE HIST_EN_EXPEDIENTE=v_expediente;

                            SELECT HIST_PR_P_INCUMPLIDOS into v_posbibles_incump
                            from hist_promesas
                                where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate);
                            DBMS_OUTPUT.PUT_LINE(v_monto_pagado ||'monto pagado'
);
                            IF v_monto_pagado > 0 THEN
                                IF v_cuantos_incump > v_posbibles_incump THEN
                                DBMS_OUTPUT.PUT_LINE('cancekada por incumplidas  '||v_sobrante);
                                    UPDATE HIST_ESTATUS_ACUERDOS
                                        SET HIST_EN_ESTATUS='Rota', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                            where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    UPDATE HIST_AUTORIZACION_ACUERDOS
                                        SET HIST_AA_ESTATUS= 'Rota', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                            WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    UPDATE PR_MC_GRAL
                                        SET PR_MC_ACUERDOS_ROTOS = NVL(PR_MC_ACUERDOS_ROTOS,0)+1
                                            WHERE PR_MC_EXPEDIENTE=v_expediente;

                                ELSE
                                    select sum(hist_pr_montopp) into v_monto_nego
                                        from hist_promesas
                                            WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    SELECT SUM(HIST_PA_MONTO_TRANS) into v_monto_pagado
                                        FROM HIST_PAGOS JOIN PR_MC_GRAL ON PR_MC_CREDITO=HIST_PA_CUENTA AND PR_MC_GRUPO=HIST_PA_GRUPO
                                            WHERE PR_MC_EXPEDIENTE=v_expediente AND HIST_PA_VALUADO=1;

                                    IF v_monto_pagado < v_monto_nego THEN
                                    DBMS_OUTPUT.PUT_LINE('v_monto_pagado < v_monto_nego total ');
                                        UPDATE HIST_ESTATUS_ACUERDOS
                                            SET HIST_EN_ESTATUS='Terminado en plazo, con saldo menor', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                        UPDATE HIST_AUTORIZACION_ACUERDOS
                                            SET HIST_AA_ESTATUS= 'Terminado en plazo, con saldo menor', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                                WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                                    ELSE
                                    DBMS_OUTPUT.PUT_LINE('todo chido');
                                         UPDATE HIST_ESTATUS_ACUERDOS
                                            SET HIST_EN_ESTATUS='Cumplida', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                        UPDATE HIST_AUTORIZACION_ACUERDOS
                                            SET HIST_AA_ESTATUS= 'Cumplida', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                                WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                                    END IF;
                                END IF;
                            ELSE
                                IF v_cuantos_incump > v_posbibles_incump THEN
                                DBMS_OUTPUT.PUT_LINE('cancekada por incumplidas  '||v_sobrante);
                                    UPDATE HIST_ESTATUS_ACUERDOS
                                        SET HIST_EN_ESTATUS='Cancelada', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                            where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    UPDATE HIST_AUTORIZACION_ACUERDOS
                                        SET HIST_AA_ESTATUS= 'Cancelada', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                            WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    UPDATE PR_MC_GRAL
                                        SET PR_MC_ACUERDOS_ROTOS = NVL(PR_MC_ACUERDOS_ROTOS,0)+1
                                            WHERE PR_MC_EXPEDIENTE=v_expediente;

                                ELSE
                                    select sum(hist_pr_montopp) into v_monto_nego
                                        from hist_promesas
                                            WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                    SELECT SUM(HIST_PA_MONTO_TRANS) into v_monto_pagado
                                        FROM HIST_PAGOS JOIN PR_MC_GRAL ON PR_MC_CREDITO=HIST_PA_CUENTA AND PR_MC_GRUPO=HIST_PA_GRUPO
                                            WHERE PR_MC_EXPEDIENTE=v_expediente AND HIST_PA_VALUADO=1;

                                    IF v_monto_pagado < v_monto_nego THEN
                                    DBMS_OUTPUT.PUT_LINE('v_monto_pagado < v_monto_nego total ');
                                        UPDATE HIST_ESTATUS_ACUERDOS
                                            SET HIST_EN_ESTATUS='Terminado en plazo, con saldo menor', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                        UPDATE HIST_AUTORIZACION_ACUERDOS
                                            SET HIST_AA_ESTATUS= 'Terminado en plazo, con saldo menor', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                                WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                                    ELSE
                                    DBMS_OUTPUT.PUT_LINE('todo chido');
                                         UPDATE HIST_ESTATUS_ACUERDOS
                                            SET HIST_EN_ESTATUS='Cumplida', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                                where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                                        UPDATE HIST_AUTORIZACION_ACUERDOS
                                            SET HIST_AA_ESTATUS= 'Cumplida', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                                WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;


                END IF;
             ELSIF V_EXISTE > 1 THEN
             DBMS_OUTPUT.PUT_LINE('no es ultimo pago ');
                SELECT COUNT(*) into v_existe
                    from hist_promesas
                        where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate) AND HIST_PR_ESTATUS='
Pendiente';
                    DBMS_OUTPUT.PUT_LINE('existe '||v_existe||Acuerdos.hist_aa_id_acuerdo||' '||v_expediente);
                IF V_EXISTE = 1 THEN
                    SELECT SUM(HIST_PA_MONTO_TRANS) into v_monto_pagado
                            FROM HIST_PAGOS JOIN PR_MC_GRAL ON PR_MC_CREDITO=HIST_PA_CUENTA AND PR_MC_GRUPO=HIST_PA_GRUPO
                                WHERE PR_MC_EXPEDIENTE=v_expediente AND HIST_PA_VALUADO=0 AND TRUNC(HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE);

                    UPDATE
                        (SELECT hp.HIST_PA_VALUADO
                            FROM HIST_PAGOS hp JOIN PR_MC_GRAL gr ON gr.PR_MC_CREDITO=hp.HIST_PA_CUENTA AND gr.PR_MC_GRUPO=hp.HIST_PA_GRUPO
                                WHERE gr.PR_MC_EXPEDIENTE=v_expediente AND NVL(hp.HIST_PA_VALUADO,0)=0 AND TRUNC(hp.HIST_PA_DTE_TRANS) <= TRUNC(SYSDATE)) act
                        SET act.HIST_PA_VALUADO = '1';

                      DBMS_OUTPUT.PUT_LINE(v_monto_pagado);
                     SELECT NVL(HIST_PR_MONTOPP,0),HIST_PR_P_INCUMPLIDOS into v_monto_nego,v_posbibles_incump
                            from hist_promesas
                                where HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate);
                                       DBMS_OUTPUT.PUT_LINE(v_monto_nego||' '||v_posbibles_incump);
                    v_sobrante := v_monto_pagado - v_monto_nego;

                    IF v_sobrante >= 0 THEN
                    DBMS_OUTPUT.PUT_LINE('sobrante mayor  '||v_sobrante);
                        UPDATE HIST_PROMESAS
                            SET HIST_PR_PAGO_REAL=v_monto_pagado,HIST_PR_ESTATUS='Cumplida'
                                WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate);
                        SP_SOBRANTE_ACUERDO(Acuerdos.hist_aa_id_acuerdo,v_sobrante);

                    ELSE
                    DBMS_OUTPUT.PUT_LINE('sobrante menor  '||v_sobrante);
                        UPDATE HIST_PROMESAS
                            SET HIST_PR_PAGO_REAL=v_monto_pagado,HIST_PR_ESTATUS='Incumplida'
                                WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and trunc(hist_pr_dtepromesa + hist_pr_dias_g)=trunc(sysdate) ;

                        UPDATE HIST_ESTATUS_ACUERDOS
                            SET HIST_EN_PAG_INCUMPLIDOS=NVL(HIST_EN_PAG_INCUMPLIDOS,0)+1
                                WHERE HIST_EN_EXPEDIENTE=v_expediente;
                        --EVALUACION DE PROMESAS ROTAS

                        SELECT NVL(HIST_EN_PAG_INCUMPLIDOS,0) INTO v_cuantos_incump
                            FROM HIST_ESTATUS_ACUERDOS
                                WHERE HIST_EN_EXPEDIENTE=v_expediente;

                        IF v_cuantos_incump > v_posbibles_incump THEN
                        DBMS_OUTPUT.PUT_LINE('cancekada por incumplidas  '||v_sobrante);
                            UPDATE HIST_ESTATUS_ACUERDOS
                                SET HIST_EN_ESTATUS='Cancelada', HIST_EN_DTEACT=SYSDATE, HIST_EN_USRACT='Proceso BATCH'
                                    where HIST_EN_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                            UPDATE HIST_AUTORIZACION_ACUERDOS
                                SET HIST_AA_ESTATUS= 'Cancelada', HIST_AA_USR_MOD = 'Proceso BATCH', HIST_AA_DTE_MOD = SYSDATE
                                    WHERE HIST_AA_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo;

                            UPDATE HIST_PROMESAS
                                SET HIST_PR_ESTATUS='Incumplida'
                                    WHERE HIST_PR_ID_ACUERDO=Acuerdos.hist_aa_id_acuerdo and hist_pr_estatus='Pendiente';

                            UPDATE PR_MC_GRAL
                                SET PR_MC_ACUERDOS_ROTOS = NVL(PR_MC_ACUERDOS_ROTOS,0)+1
                                    WHERE PR_MC_EXPEDIENTE=v_expediente;
                        END IF;
                    END IF;
                END IF;
             END IF;

        END IF;



    end loop;


    insert into HIST_AUDITORIA
    (HIST_AU_USUARIO,
    HIST_AU_MODULO,
    HIST_AU_DTE,
    HIST_AU_VALOR)
    VALUES
    ('INVEX',
	'SP_BATCH', 
    SYSDATE,
    'Ejecuci�n Correcta de Proceso BATCH');
    commit;

EXCEPTION   WHEN OTHERS THEN
    err_msg := SQLERRM;

	insert into HIST_AUDITORIA 
    (HIST_AU_USUARIO,
    HIST_AU_MODULO,
    HIST_AU_DTE,
    HIST_AU_VALOR)
    VALUES
    ('INVEX',
	'SP_BATCH', 
    SYSDATE,
    err_msg);
    commit;
END;