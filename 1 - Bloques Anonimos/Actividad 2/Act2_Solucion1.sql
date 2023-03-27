VAR NUMRUT_CONSULTA NUMBER;
VAR DVRUT_CONSULTA CHAR;

--EXEC :NUMRUT_CONSULTA := '11846972';
--EXEC :DVRUT_CONSULTA := '5';
EXEC :NUMRUT_CONSULTA := '12113369';
EXEC :DVRUT_CONSULTA := '4';

DECLARE
    V_ANIO              NUMBER(4);
    V_NUMRUN            NUMBER(8);
    V_DVRUN             CHAR(1);
    V_NOMBRECOMPLETO    VARCHAR2(200);
    V_SUELDO            EMPLEADO.SUELDO_BASE%TYPE;
    V_PORC_MOVIL        NUMBER(3);
    V_VALOR_MOVIL       EMPLEADO.SUELDO_BASE%TYPE;
    V_VALOR_ADIC        EMPLEADO.SUELDO_BASE%TYPE;
    V_TOTAL             EMPLEADO.SUELDO_BASE%TYPE;
BEGIN
    SELECT
        EXTRACT(YEAR FROM SYSDATE) AS "ANIO_PROCESO",
        E.NUMRUN_EMP,
        E.DVRUN_EMP,
        E.PNOMBRE_EMP || ' ' || E.SNOMBRE_EMP || ' '
            || E.APPATERNO_EMP || ' '|| E.APMATERNO_EMP AS "NOMBRE_COMPLETO",
        E.SUELDO_BASE,
        TRUNC(E.SUELDO_BASE / 100000) AS "PORC_MOVIL_NORMAL",
        CASE C.NOMBRE_COMUNA
            WHEN 'María Pinto' THEN 20000
            WHEN 'Curacaví' THEN 25000
            WHEN 'Talagante' THEN 30000
            WHEN 'El Monte' THEN 35000
            WHEN 'Buin' THEN 40000
            ELSE 0
        END AS "VALOR_MOVIL_ADIC"
    INTO
        V_ANIO, V_NUMRUN, V_DVRUN, V_NOMBRECOMPLETO, V_SUELDO,
        V_PORC_MOVIL, V_VALOR_ADIC
    FROM EMPLEADO E, COMUNA C
    WHERE
        E.ID_COMUNA = C.ID_COMUNA
        AND NUMRUN_EMP = :NUMRUT_CONSULTA
        AND DVRUN_EMP = :DVRUT_CONSULTA;
        
    V_VALOR_MOVIL := V_PORC_MOVIL * (V_SUELDO / 100);
    V_TOTAL := V_VALOR_MOVIL + V_VALOR_ADIC;
    
    /*
    100%           SUELDO_BASE
    -------------------
    V_PORC_MOVIL   X
    */
    
    dbms_output.put_line('resultados:::');
    dbms_output.put_line('valor sueldo: '|| V_SUELDO);
    dbms_output.put_line('porcentaje movilizacion:'|| V_PORC_MOVIL);
    dbms_output.put_line('valor movilizacion: '|| v_valor_movil);
    dbms_output.put_line('valor adicional: '|| V_VALOR_ADIC);
    dbms_output.put_line('valor total: '|| V_TOTAL);
    
    INSERT INTO PROY_MOVILIZACION
    VALUES(
        V_ANIO,
        V_NUMRUN,
        V_DVRUN,
        V_NOMBRECOMPLETO,
        V_SUELDO,
        V_PORC_MOVIL,
        V_VALOR_MOVIL,
        V_VALOR_ADIC,
        V_TOTAL
    );
    dbms_output.put_line('COMPLETÓ EL PROCESO.');
    COMMIT;
END;

--select * FROM PROY_MOVILIZACION;
