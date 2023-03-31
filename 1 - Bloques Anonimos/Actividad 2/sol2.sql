VAR RUT NUMBER;
VAR DV CHAR;
EXEC :RUT := 12648200;
EXEC :DV := '3';

DECLARE
    v_mesanio number(6);
    v_run EMPLEADO.NUMRUN_EMP%TYPE;
    v_dv EMPLEADO.DVRUN_EMP%TYPE;
    v_nombreempleado VARCHAR2(200);
    v_pnombre EMPLEADO.PNOMBRE_EMP%TYPE;
    v_appaterno EMPLEADO.APPATERNO_EMP%TYPE;
    v_sueldobase EMPLEADO.SUELDO_BASE%TYPE;
    v_fechanac NUMBER(4);
    v_antiguedad NUMBER(2);
    v_estadocivil ESTADO_CIVIL.NOMBRE_ESTADO_CIVIL%TYPE;
    v_comuna COMUNA.NOMBRE_COMUNA%TYPE;
    
    v_usuario USUARIO_CLAVE.NOMBRE_USUARIO%TYPE;
    v_pass USUARIO_CLAVE.CLAVE_USUARIO%TYPE;
    v_auxEC VARCHAR2(2);
BEGIN
    SELECT
        TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY')) AS mes_anio
        , NUMRUN_EMP
        , DVRUN_EMP
        , PNOMBRE_EMP || ' ' || SNOMBRE_EMP || ' ' ||
            APPATERNO_EMP || ' ' || APMATERNO_EMP AS NOMBRE_EMPLEADO
        , PNOMBRE_EMP
        , APPATERNO_EMP
        , SUELDO_BASE
        , EXTRACT(YEAR FROM FECHA_NAC) AS NACIMIENTO
        , TRUNC((SYSDATE - FECHA_CONTRATO) / 365) AS ANTIGUEDAD
        , ec.NOMBRE_ESTADO_CIVIL
        , c.NOMBRE_COMUNA
    INTO
        v_mesanio
        , v_run
        , v_dv
        , v_nombreempleado
        , v_pnombre
        , v_appaterno
        , v_sueldobase
        , v_fechanac
        , v_antiguedad
        , v_estadocivil
        , v_comuna
    FROM empleado e, estado_civil ec, comuna c
    WHERE e.id_estado_civil = ec.id_estado_civil
        AND e.id_comuna = c.id_comuna
        AND e.NUMRUN_EMP = :RUT
        AND e.DVRUN_EMP = :DV;
    
    dbms_output.put_line('select listo');
    
/*
Nombre de Usuario será la unión de:
√	Las tres primeras letras del primer nombre del empleado
√	El largo de su primer nombre
√	Un ASTERISCO
√	El último dígito de su sueldo base
√	El dígito verificador del run del empleado
√	Los años que lleva trabajando en la empresa.
√	Si el empleado lleva menos de 10 años trabajando en TRUCK RENTAL, se agrega además una X. 
*/
    v_usuario := SUBSTR(v_pnombre, 0, 3)
                || LENGTH(v_pnombre)
                || '*'
                || SUBSTR(v_sueldobase, -1, 1)
                || v_dv
                || v_antiguedad;
    
    IF v_antiguedad <= 10
    THEN
        v_usuario := v_usuario || 'X';
    END IF;
    
    dbms_output.put_line('select listo');
    
/* 
Clave del Usuario será la unión de: 
√	El tercer dígito del run del empleado
√	El año de nacimiento del empleado aumentado en dos
√	Los tres últimos dígitos del sueldo base disminuido en uno
-	Dos letras de su apellido paterno, en minúscula, de acuerdo a lo siguiente:
√	Si es casado o con acuerdo de unión de civil, las dos primeras letras.
√	Si es divorciado o soltero, la primera y última letra.
√	Si es viudo, la antepenúltima y penúltima letra.
√	Si es separado las dos últimas letras

√	El mes y año de la base de datos (en formato numérico).
√	La primera letra del nombre de la comuna en la que viva.
*/
    v_pass := SUBSTR(v_run, 3, 1)
                || (v_fechanac+2)
                || substr(v_sueldobase -1, -3, 3);
                
    v_auxEC := (
    CASE v_estadocivil
        WHEN 'CASADO' THEN
            SUBSTR(v_appaterno, 0, 2)
        WHEN 'ACUERDO DE UNION CIVIL' THEN
            SUBSTR(v_appaterno, 0, 2)
        WHEN 'DIVORCIADO' THEN
            SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1, 1)
        WHEN 'SOLTERO' THEN
            SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1, 1)
        WHEN 'VIUDO' THEN
            SUBSTR(v_appaterno, -3, 2)
        WHEN 'SEPARADO' THEN
            SUBSTR(v_appaterno, -2, 2)
        ELSE
            ''
    END);
    
    v_pass := v_pass || v_auxEC || v_mesanio || SUBSTR(v_comuna, 1, 1);
    
    DELETE FROM usuario_clave WHERE numrun_emp = :rut AND dvrun_emp = :dv;
    
    dbms_output.put_line('INSERTANDO:::');
    dbms_output.put_line(v_mesanio);
    dbms_output.put_line(v_run);
    dbms_output.put_line(v_dv);
    dbms_output.put_line(v_nombreempleado);
    dbms_output.put_line(v_usuario);
    dbms_output.put_line(v_pass);
    
    INSERT INTO usuario_clave (mes_anno, numrun_emp, dvrun_emp, nombre_empleado, nombre_usuario, clave_usuario)
    VALUES(
        v_mesanio, v_run, v_dv, v_nombreempleado, v_usuario, v_pass
    );
    
END;
