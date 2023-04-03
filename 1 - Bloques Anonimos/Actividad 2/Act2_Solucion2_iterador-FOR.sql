DECLARE
   v_mesanio number(6) := TO_CHAR(sysdate, 'MMyyyy');
   
   v_usuario usuario_clave.nombre_usuario%type;
   v_pass usuario_clave.clave_usuario%type;
   
   v_auxAp varchar2(20);
BEGIN
    FOR fila IN (
        SELECT
            numrun_emp as rut
            , dvrun_emp as rutdv
            , pnombre_emp || ' ' || snombre_emp || ' ' ||
                appaterno_emp || ' ' || apmaterno_emp as nombre_completo
            , pnombre_emp
            , appaterno_emp
            , sueldo_base
            , TRUNC((sysdate - fecha_contrato) / 365) as antiguedad
            , EXTRACT(YEAR FROM fecha_nac) +2 AS nacimiento
            , ec.nombre_estado_civil as estado_civil
            , c.nombre_comuna as comuna
        FROM empleado e, estado_civil ec, comuna c
        WHERE
            e.id_estado_civil = ec.id_estado_civil
            AND e.id_comuna = c.id_comuna
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('ENTRANDO AL LOOP');
        v_usuario := SUBSTR(fila.pnombre_emp,0,3) ||
                    LENGTH(fila.pnombre_emp) ||
                    '*' ||
                    SUBSTR(fila.sueldo_base, -1, 1) ||
                    fila.rutdv ||
                    fila.antiguedad;
        IF fila.antiguedad < 10
        THEN
            v_usuario := v_usuario || 'x';
        END IF;
        DBMS_OUTPUT.PUT_LINE('CREADO NOMBRE DE USUARIO');
        
        v_pass := SUBSTR(fila.rut, 3, 1) ||
                    fila.nacimiento ||
                    SUBSTR(fila.sueldo_base -1, -3, 3);
        v_auxAp := (
            CASE fila.estado_civil
                WHEN 'CASADO'
                THEN
                    SUBSTR(fila.appaterno_emp, 0, 2)
                WHEN 'UNION CIVIL'
                THEN 
                    SUBSTR(fila.appaterno_emp, 0, 2)
                WHEN 'DIVORCIADO'
                THEN
                    SUBSTR(fila.appaterno_emp, 0, 1) || SUBSTR(fila.appaterno_emp, -1, 1)
                WHEN 'SOLTERO'
                THEN
                    SUBSTR(fila.appaterno_emp, 0, 1) || SUBSTR(fila.appaterno_emp, -1, 1)
                WHEN 'VIUDO'
                THEN
                    SUBSTR(fila.appaterno_emp, -3, 2)
                ELSE
                    SUBSTR(fila.appaterno_emp, -2, 2)
            END);
        v_pass := v_pass
                    || v_auxAp
                    || v_mesanio
                    || SUBSTR(fila.comuna, 1, 1);
        DBMS_OUTPUT.PUT_LINE('CREADO CLAVE DE USUARIO');
                    
        DELETE FROM USUARIO_CLAVE WHERE numrun_emp = fila.rut AND dvrun_emp = fila.rutdv;
        DBMS_OUTPUT.PUT_LINE('BORRANDO DATOS ANTERIORES');
        
        INSERT INTO USUARIO_CLAVE
        VALUES(
            v_mesanio, fila.rut, fila.rutdv, fila.nombre_completo, v_usuario, v_pass
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('PROCESO COMPLETADO');
    END LOOP;
END;
