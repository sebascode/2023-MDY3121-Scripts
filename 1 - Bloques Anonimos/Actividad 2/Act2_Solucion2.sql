VAR rut NUMBER;
EXEC :rut := '12648200';
VAR dvrut CHAR;
EXEC :dvrut := '3';

DECLARE
   v_mesanio number(6);
   v_rut empleado.numrun_emp%type;
   v_dv empleado.dvrun_emp%type;
   v_nombrecompleto VARCHAR2(150);
   v_pnombre empleado.pnombre_emp%type;
   v_appaterno empleado.appaterno_emp%type;
   v_sueldobase empleado.sueldo_base%type;
   v_antiguedad number(2);
   v_nacimiento number(4);
   v_estadocivil estado_civil.nombre_estado_civil%type;
   v_comuna comuna.nombre_comuna%type;
   
   v_usuario usuario_clave.nombre_usuario%type;
   v_pass usuario_clave.clave_usuario%type;
   
   v_auxAp varchar2(20);
BEGIN
    SELECT
        TO_CHAR(sysdate, 'MMyyyy') as MES_ANIO
        , numrun_emp
        , dvrun_emp
        , pnombre_emp || ' ' || snombre_emp || ' ' ||
            appaterno_emp || ' ' || apmaterno_emp as nombre_completo
        , pnombre_emp
        , appaterno_emp
        , sueldo_base
        , TRUNC((sysdate - fecha_contrato) / 365) as Antiguedad
        , EXTRACT(YEAR FROM fecha_nac) +2 AS anio_nacimiento
        , ec.nombre_estado_civil
        , c.nombre_comuna
    INTO
       v_mesanio
       , v_rut
       , v_dv
       , v_nombrecompleto
       , v_pnombre
       , v_appaterno
       , v_sueldobase
       , v_antiguedad
       , v_nacimiento
       , v_estadocivil
       , v_comuna
    FROM empleado e, estado_civil ec, comuna c
    WHERE
        e.id_estado_civil = ec.id_estado_civil
        AND e.id_comuna = c.id_comuna
        
        AND numrun_emp = :rut
        AND dvrun_emp = :dvrut;
    
    DBMS_OUTPUT.PUT_LINE('EJECUTADO SELECT');
/*
•	Nombre de Usuario será la unión de:
√	Las tres primeras letras del primer nombre del empleado
√	El largo de su primer nombre
√	Un ASTERISCO
√	El último dígito de su sueldo base
√	El dígito verificador del run del empleado
√	Los años que lleva trabajando en la empresa.
o	Si (lleva menos de 10)
        se agrega además una X. 
*/
    v_usuario := SUBSTR(v_pnombre,0,3) ||
                LENGTH(v_pnombre) ||
                '*' ||
                SUBSTR(v_sueldobase, -1, 1) ||
                v_dv ||
                v_antiguedad;
    IF v_antiguedad < 10
    THEN
        v_usuario := v_usuario || 'x';
    END IF;
    DBMS_OUTPUT.PUT_LINE('CREADO NOMBRE DE USUARIO');
/*
•	Clave del Usuario será la unión de: 
√	El tercer dígito del run del empleado
√	El año de nacimiento del empleado aumentado en dos
o	Los tres últimos dígitos del sueldo base disminuido en uno
o	Dos letras de su apellido paterno, en minúscula, de acuerdo a lo siguiente:
	Si es casado o con acuerdo de unión de civil, las dos primeras letras.
	Si es divorciado o soltero, la primera y última letra.
	Si es viudo, la antepenúltima y penúltima letra.
	Si es separado las dos últimas letras
√	El mes y año de la base de datos (en formato numérico).
o	La primera letra del nombre de la comuna en la que viva.

*/
    v_pass := SUBSTR(v_rut, 3, 1) ||
                v_nacimiento ||
                SUBSTR(v_sueldobase -1, -3, 3);
    /*
    -- FORMA EMPÍRICA
    v_auxAp := '';
    CASE
        WHEN v_estadocivil = 'CASADO' OR v_estadocivil = 'UNION CIVIL'
        THEN
            v_auxAp := SUBSTR(v_appaterno, 0, 2);
        WHEN v_estadocivil = 'DIVORCIADO' OR v_estadocivil = 'SOLTERO'
        THEN
            v_auxAp := SUBSTR(v_appaterno, 0) || SUBSTR(v_appaterno, -1);
        WHEN v_estadocivil = 'VIUDO'
        THEN
            v_auxAp := SUBSTR(v_appaterno, -3, 2);
        ELSE
        THEN
            v_auxAp := SUBSTR(v_appaterno, -2, 2);
    END CASE;
    */
    -- FORMA DECLARATIVA
    v_auxAp := (
        CASE v_estadocivil
            WHEN 'CASADO'
            THEN
                SUBSTR(v_appaterno, 0, 2)
            WHEN 'UNION CIVIL'
            THEN 
                SUBSTR(v_appaterno, 0, 2)
            WHEN 'DIVORCIADO'
            THEN
                SUBSTR(v_appaterno, 0, 1) || SUBSTR(v_appaterno, -1, 1)
            WHEN 'SOLTERO'
            THEN
                SUBSTR(v_appaterno, 0, 1) || SUBSTR(v_appaterno, -1, 1)
            WHEN 'VIUDO'
            THEN
                SUBSTR(v_appaterno, -3, 2)
            ELSE
                SUBSTR(v_appaterno, -2, 2)
        END);
    dbms_output.put_line('aux: '||v_auxAp);
    dbms_output.put_line('estado: '||v_estadocivil);
    v_pass := v_pass
                || v_auxAp
                || v_mesanio
                || SUBSTR(v_comuna, 1, 1);
    DBMS_OUTPUT.PUT_LINE('CREADO CLAVE DE USUARIO');
                
    -- insert into table;
    DELETE FROM USUARIO_CLAVE WHERE numrun_emp = :rut AND dvrun_emp = :dvrut;
    DBMS_OUTPUT.PUT_LINE('BORRANDO DATOS ANTERIORES');
    
    INSERT INTO USUARIO_CLAVE
    VALUES(
        v_mesanio, v_rut, v_dv, v_nombrecompleto, v_usuario, v_pass
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('PROCESO COMPLETADO');
END;
