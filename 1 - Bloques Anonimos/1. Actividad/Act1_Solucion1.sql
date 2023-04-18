/*
EJERCICIO N° 1
*/
ALTER SESSION SET NLS_TERRITORY = 'Chile';

-- declaramos variable y le asignamos un valor simulando ingreso de un usuario
VAR V_PORC NUMBER;
VAR V_RUTMARIA NCHAR(10);
VAR V_RUTMARCO NCHAR(10);
EXEC :V_PORC := 40;
EXEC :V_RUTMARCO := '11846972';
EXEC :V_RUTMARIA := '18560875';

-- declaramos variables de nuestro bloque anónimo
DECLARE
    v_nombre VARCHAR(200);
    v_run VARCHAR(10);
    v_sueldo EMPLEADO.SUELDO_EMP%TYPE;
BEGIN
    
    -- primer select para Marco Ogaz Varas.
    SELECT 
        NUMRUT_EMP || '-' || DVRUT_EMP AS "RUT"
        , NOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP AS "NOMBRE"
        , SUELDO_EMP AS "SUELDO"
    INTO v_run, v_nombre, v_sueldo
    FROM EMPLEADO
    WHERE
        NUMRUT_EMP = :V_RUTMARCO;
    
    -- ESCRIBIENDO SALIDA
    dbms_output.put_line('DATOS CALCULO BONIFICACIÓN EXTRA DEL '||:V_PORC||'% DEL SUELDO');
    dbms_output.put_line('NOMBRE: '||v_nombre);
    dbms_output.put_line('RUN: '||v_run);
    dbms_output.put_line('SUELDO:'||TO_CHAR(v_sueldo,'fmL999G999'));
    dbms_output.put_line('Bonificación extra:'||TO_CHAR(v_sueldo*:V_PORC/100, 'fmL999G999'));
    dbms_output.new_line();
    -- segundo select para MARIA BARRERA ONETO.
    SELECT 
        NUMRUT_EMP || '-' || DVRUT_EMP AS "RUT"
        , NOMBRE_EMP || ' ' || APPATERNO_EMP || ' ' || APMATERNO_EMP AS "NOMBRE"
        , SUELDO_EMP AS "SUELDO"
    INTO
        v_run, v_nombre, v_sueldo
    FROM EMPLEADO
    WHERE
        NUMRUT_EMP = :V_RUTMARIA;
    
    -- ESCRIBIENDO SALIDA
    dbms_output.put_line('DATOS CALCULO BONIFICACIÓN EXTRA DEL '||:V_PORC||'% DEL SUELDO');
    dbms_output.put_line('NOMBRE: '||v_nombre);
    dbms_output.put_line('RUN: '||v_run);
    dbms_output.put_line('SUELDO:'||TO_CHAR(v_sueldo,'fmL999G999'));
    dbms_output.put_line('Bonificación extra:'||TO_CHAR(v_sueldo*:V_PORC/100, 'fmL999G999'));
    
    /*
    Se aplica regla de 3 para obtener porcentaje: el 100% del sueldo es v_sueldo, si necesitamos el 40% se obtiene:
    100 = v_sueldo
    40 = X
    
    x = v_sueldo * 40 / 100
    
    o bien:
    x = v_sueldo * 0.40
    */
END;
