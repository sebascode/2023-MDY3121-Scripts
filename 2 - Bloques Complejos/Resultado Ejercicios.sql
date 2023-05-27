-- 1
DECLARE
    v_iteraciones NUMBER := FLOOR(DBMS_RANDOM.value(2, 20));
    v_numRandom NUMBER := 0;
    v_total NUMBER := 0;
BEGIN
    FOR i IN 1..v_iteraciones
    LOOP
        v_numRandom := FLOOR(DBMS_RANDOM.value(20,200));
        dbms_output.put_line('Número random: '||v_numRandom);
        v_total := v_numRandom + v_total;
    END LOOP;
    dbms_output.put_line('TOTAL: '||v_numRandom);
END;

-- 2
BEGIN
    FOR i IN 1..200
    LOOP
        IF MOD(i,3) = 0 THEN
            dbms_output.put_line(i||' es múltiplo de 3');
        END IF;
    END LOOP;
END;

-- 3
BEGIN
    FOR i IN 1..10
    LOOP
        FOR c IN 1..10
        LOOP
            dbms_output.put_line(i||'x'||c||'='||(i*c));
        END LOOP;
    END LOOP;
END;


-- 4
DECLARE
    CURSOR vendedor_cursor IS 
        SELECT id_vendedor, nombres, apellidos, fecnac, sueldo FROM VENDEDOR WHERE sueldo < 354000;
    TYPE vendedor_type IS RECORD (
        id vendedor.id_vendedor%TYPE,
        nombres vendedor.nombres%TYPE,
        apellidos vendedor.apellidos%TYPE,
        fechanacimiento vendedor.fecnac%TYPE,
        sueldo vendedor.sueldo%TYPE
    );
    v_vendedor vendedor_type;
BEGIN
    OPEN vendedor_cursor;
    LOOP
        FETCH vendedor_cursor INTO v_vendedor;
        
        IF(vendedor_cursor%NOTFOUND) THEN
            EXIT;
        END IF;
        
        dbms_output.put_line('====================');
        dbms_output.put_line('ID: '|| v_vendedor.id);
        dbms_output.put_line('Nombre Completo: '|| v_vendedor.nombres || ' ' || v_vendedor.apellidos);
        dbms_output.put_line('NACIMIENTO: '|| TO_CHAR(v_vendedor.fechanacimiento, 'DD-MM-YYYY'));
        dbms_output.put_line('SUELDO: '|| v_vendedor.sueldo);
    END LOOP;
    CLOSE vendedor_cursor;
END;
