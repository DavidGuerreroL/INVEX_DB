  CREATE OR REPLACE EDITIONABLE PROCEDURE "SP_ALERTAS_GESTION" (
  V_USUARIO  NVARCHAR2 DEFAULT NULL
, V_MENSAJE  NVARCHAR2 DEFAULT NULL
, V_ID  Number DEFAULT NULL
, V_TIPO  NVARCHAR2 DEFAULT NULL
, V_BANDERA  Number DEFAULT NULL
, V_VIGENCIA  NVARCHAR2 DEFAULT NULl,
  CV_1 OUT SYS_REFCURSOR)
 AS
 v_Exists number(10):=0;
 v_cat_lo_usuario varchar2(99):='';v_horas number(10):=0;
 V_USUARIO2 varchar(50):=null;
BEGIN

 IF V_BANDERA = 1
  Then /*CREAR ALERTA */

	select count(*) into v_Exists from cat_logins where ltrim(rtrim(CAT_LO_NOMBRE))  = ltrim(rtrim(V_USUARIO));
	if (v_Exists=1)then 

		select cat_lo_usuario into V_USUARIO2 from cat_logins where ltrim(rtrim(CAT_LO_NOMBRE)) = ltrim(rtrim(V_USUARIO));
	end if; 

		INSERT INTO HIST_ALERTAS_GESTION(  
    HIST_AL_DTECREADA,
    HIST_AL_DTEVIGENCIA,
    HIST_AL_ID,
    HIST_AL_MENSAJE,
    HIST_AL_TIPO,
    HIST_AL_USUARIO) VALUES(
    Systimestamp,
    CASE WHEN NVL(V_VIGENCIA,'') ='' THEN sysdate+5 ELSE cast(to_char(V_VIGENCIA, 'dd/mm/yyyy' )as date) END,
    NVL((SELECT MAX(HIST_AL_ID)+1 FROM HIST_ALERTAS_GESTION WHERE HIST_AL_USUARIO=V_USUARIO),0),
    V_MENSAJE,
    V_TIPO,
    V_USUARIO2
    );


     open CV_1 for SELECT 'OK' msg FROM dual ;   -- si se agregan columans de salida se debe validar en add hist gest y add hist promesas la parte de alertas
ELSIF V_BANDERA = 2 THEN /*ACTUALIZAR FECHA VISTO ALERTA */
    UPDATE HIST_ALERTAS_GESTION SET HIST_AL_DTEVISTO = SYSDATE WHERE HIST_AL_DTEVISTO is null AND HIST_AL_USUARIO = V_USUARIO;
    COMMIT;
    OPEN CV_1 FOR SELECT 'OK' msg from dual;
  ELSIF V_BANDERA = 3 THEN /*TRAER TODAS LAS ALERTAS VIGENTES DE UN USUARIO*/
    OPEN CV_1 FOR SELECT
    HIST_AL_ID "ID",
    HIST_AL_MENSAJE "Mensaje",
    HIST_AL_TIPO "Tipo",
    TO_CHAR(HIST_AL_DTECREADA,'dd/mm/rrrr') "Fecha de creacion",
    TO_CHAR(HIST_AL_DTEVIGENCIA,'dd/mm/rrrr') "Fecha de vigencia",
    CASE WHEN HIST_AL_DTEVISTO IS NULL THEN '0' ELSE '1' END "Visto"
    FROM HIST_ALERTAS_GESTION WHERE HIST_AL_USUARIO = V_USUARIO and  trunc(HIST_AL_DTEVIGENCIA) >= trunc(sysdate);
  ELSIF V_BANDERA = 4 THEN
    OPEN CV_1 FOR SELECT COUNT(*) FROM HIST_ALERTAS_GESTION WHERE HIST_AL_USUARIO = V_USUARIO AND HIST_AL_DTEVISTO IS NULL;
  elsif v_bandera=5 then
    open cv_1 for select HIST_AL_DTECREADA FECHACREACION, HIST_AL_DTEVISTO FECHALECTURA, HIST_AL_MENSAJE ALERTA, HIST_AL_DTEVIGENCIA FECHAVIGENCIA from HIST_ALERTAS_GESTION
    WHERE HIST_AL_USUARIO=V_USUARIO and case when V_TIPO='0' then trunc(HIST_AL_DTECREADA) when V_TIPO='1' then trunc(HIST_AL_DTEVISTO) when V_TIPO='2' then trunc(HIST_AL_DTEVIGENCIA) end
    between to_date(V_MENSAJE,'rrrr-mm-dd-hh24-mi-ss') and to_date(V_VIGENCIA,'rrrr-mm-dd-hh24-mi-ss'); --2019-08-26-00-00-00
  elsif v_bandera=6 then
    update HIST_ALERTAS_GESTION set HIST_AL_DTEVISTO=sysdate where HIST_AL_USUARIO=V_USUARIO and case when V_TIPO=0 then HIST_AL_DTECREADA when V_TIPO=1 then HIST_AL_DTEVISTO when V_TIPO=2 then HIST_AL_DTEVIGENCIA end between to_date(V_MENSAJE,'dd/mm/rr')
    and to_date(V_VIGENCIA,'dd/mm/rr') and HIST_AL_DTEVISTO is null;
    commit;
    open cv_1 for select 'Ok' MSJ from dual;
  elsif v_bandera=7 then
    open cv_1 for select distinct HIST_AL_TIPO tipo from HIST_ALERTAS_GESTION where HIST_AL_USUARIO=V_USUARIO;
  end if;

end;