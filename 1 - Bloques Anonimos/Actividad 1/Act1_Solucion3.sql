/*
    EJERCICIO N° 3
    Simulación 1: El salario se aumentará para todos los empleados en un 8,5%.
    Simulación 2: El salario de aumentará en un 20 para los empleados con sueldo mayor o igual
        a $200.000 y menor o igual a $400.000.
*/
ALTER SESSION SET NLS_TERRITORY = 'Chile';
VAR INPUT_RUT NUMBER;

VAR PORC_1 NUMBER;
VAR PORC_2 NUMBER;
VAR RANGO_MIN NUMBER;
VAR RANGO_MAX NUMBER;

--EXEC :INPUT_RUT := 12260812;
EXEC :INPUT_RUT := 11999100;

EXEC :PORC_1 := 8.5;

EXEC :PORC_2 := 20;
EXEC :RANGO_MIN := 200000;
EXEC :RANGO_MAX := 400000;

DECLARE
    v_nombre varchar(100);
    v_rut varchar(10);
    v_sueldo empleado.sueldo_emp%type;
    v_ajuste_1 empleado.sueldo_emp%type := 0;
    v_ajuste_2 empleado.sueldo_emp%type := 0;
BEGIN
    SELECT
        nombre_emp || ' ' || appaterno_emp || ' ' || apmaterno_emp as "Nombre Completo"
        , numrut_emp || '-' || dvrut_emp as "RUN"
        , sueldo_emp
    INTO v_nombre, v_rut, v_sueldo
    FROM empleado
    WHERE
        numrut_emp = :INPUT_RUT;
    
    v_ajuste_1 := v_sueldo * (:PORC_1 / 100);
    
    dbms_output.put_line('SIMULACIONES');
    dbms_output.put_line('-----------------');
    dbms_output.put_line('NOMBRE DEL EMPLEADO: '||v_nombre);
    dbms_output.put_line('RUN: '||v_rut);
    dbms_output.put_line('SIMULACIÓN 1: Aumentar en '||:PORC_1||'% el salario de todos los empleados');
    dbms_output.put_line('Sueldo Actual: '|| TO_CHAR(v_sueldo,'fmL999G999G999'));
    dbms_output.put_line('Sueldo Reajustado: '|| TO_CHAR(v_ajuste_1 + v_sueldo,'fmL999G999G999'));
    dbms_output.put_line('Reajuste: '|| TO_CHAR(v_ajuste_1,'fmL999G999G999'));
    
    -- SIMULACIÓN 2
    dbms_output.new_line();
    dbms_output.put_line('SIMULACIÓN 2: Aumentar en '||:PORC_2||'% el salario de todos los empleados
        entre '||TO_CHAR(:RANGO_MIN_2,'fmL999G999G999') ||' y '|| TO_CHAR(:RANGO_MAX_2,'fmL999G999'));
    dbms_output.put_line('Sueldo Actual: '|| TO_CHAR(v_sueldo,'fmL999G999')||'.');
    IF :RANGO_MIN < v_sueldo AND :RANGO_MAX > v_sueldo THEN
        v_ajuste_2 := v_sueldo * (:PORC_2 / 100);
        dbms_output.put_line('Sueldo Reajustado: '|| TO_CHAR(v_ajuste_2 + v_sueldo,'fmL999G999G999'));
    ELSE
        dbms_output.put_line('Sueldo Reajustado: '|| TO_CHAR(0,'fmL999G999G999'));
    END IF;
    dbms_output.put_line('Reajuste: '|| TO_CHAR(v_ajuste_2,'fmL999G999G999'));
END;