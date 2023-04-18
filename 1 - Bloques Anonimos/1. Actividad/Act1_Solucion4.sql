/*
EJERCICIO N° 4
*/
ALTER SESSION SET NLS_TERRITORY = 'Chile';

DECLARE
    v_cant number;
    v_total number;
BEGIN
    FOR tipo IN (SELECT id_tipo_propiedad, desc_tipo_propiedad FROM tipo_propiedad)
    LOOP
        dbms_output.new_line();
        
        SELECT
            COUNT(id_tipo_propiedad) as "Cantidad",
            NULLIF(SUM(VALOR_ARRIENDO), 0) as "Total Arriendo"
        INTO v_cant, v_total
        FROM propiedad
        WHERE
            id_tipo_propiedad = tipo.id_tipo_propiedad;
            
        DBMS_OUTPUT.PUT_LINE('RESUMEN DE: '|| tipo.desc_tipo_propiedad);
        DBMS_OUTPUT.PUT_LINE('Total de Propiedades: '|| v_cant);
        DBMS_OUTPUT.PUT_LINE('Valor Total Arriendo: '|| TO_CHAR(v_total, 'fmL999G999G999'));
    END LOOP;
END;