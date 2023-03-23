/*
EJERCICIO N° 2
*/
ALTER SESSION SET NLS_TERRITORY = 'Chile';
VAR INPUT_RUT NUMBER;
EXEC :INPUT_RUT := 12487147;

DECLARE
    v_nombre varchar(100);
    v_rut varchar(10);
    v_renta cliente.renta_cli%type;
    v_estadocivil estado_civil.desc_estcivil%type;
BEGIN
    SELECT
        cli.nombre_cli || ' ' || cli.appaterno_cli || ' ' || cli.apmaterno_cli as "Nombre Completo"
        , cli.numrut_cli || '-' || cli.dvrut_cli as "RUN"
        , ec.desc_estcivil as "Estado Civil"
        , cli.renta_cli as "Renta"
    INTO v_nombre, v_rut, v_estadocivil, v_renta
    FROM cliente cli
    INNER JOIN estado_civil EC ON ec.id_estcivil = cli.id_estcivil
    WHERE
        cli.numrut_cli = :INPUT_RUT;
        
    dbms_output.put_line('DATOS DEL CLIENTE');
    dbms_output.put_line('-----------------');
    dbms_output.put_line('Nombre: '||v_nombre);
    dbms_output.put_line('RUN: '||v_rut);
    dbms_output.put_line('Estado civil: '||v_estadocivil);
    dbms_output.put_line('Renta: '|| TO_CHAR(v_renta,'fmL999G999G999'));
END;