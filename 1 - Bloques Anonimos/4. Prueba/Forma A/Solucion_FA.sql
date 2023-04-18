VARIABLE b_fecha VARCHAR2(6);
EXEC :b_fecha := '202106';
VARIABLE b_pct1 NUMBER;
EXEC :b_pct1 := 0.35;
VARIABLE b_pct2 NUMBER;
EXEC :b_pct2 := 0.3;
VARIABLE b_pct3 NUMBER;
EXEC :b_pct3 := 0.25;
VARIABLE b_pct4 NUMBER;
EXEC :b_pct4 := 0.2;
VARIABLE b_pct5 NUMBER;
EXEC :b_pct5 := 0.15;
DECLARE
    v_runemp empleado.rut_empleado%TYPE;
    v_nom varchar2(50);  
    v_idemp NUMBER;
    v_nro_ventas NUMBER;
    v_ventas_netas_mes NUMBER;
    v_minid NUMBER;
    v_maxid NUMBER;
    v_asignacion_vtas NUMBER;
    v_pctcat NUMBER;
    v_categorizacion empleado.id_categorizacion%TYPE;
    v_incentivo_categorizacion NUMBER;    
    v_idequipo empleado.id_equipo%TYPE;
    v_nomequipo VARCHAR2(10);
    v_pctequipo NUMBER;
    v_bono_equipo NUMBER;
    v_anti NUMBER;
    v_asignacion_antig NUMBER;
    v_descuentos NUMBER;
    v_totales_mes NUMBER;  
    v_comision_ventas NUMBER;  
    v_pctcom NUMBER;
BEGIN
   -- Truncamos las tablas para facilitar la ejecución del bloque
   EXECUTE IMMEDIATE('TRUNCATE TABLE DETALLE_VENTA_EMPLEADO');
   EXECUTE IMMEDIATE('TRUNCATE TABLE COMISION_VENTA_EMPLEADO');
    
    -- Se extrae el mínimo y máximo id de vendedor para recorrer la tabla empleado
    SELECT MIN(id_empleado), MAX(id_empleado) INTO v_minid, v_maxid FROM empleado;
         
    -- Se inicia el bucle
   WHILE  v_minid <= v_maxid
   LOOP
    
        -- Se extraen los datos del empleado o vendedor
        SELECT id_empleado, rut_empleado, apellidos || ' ' || nombres, id_categorizacion, id_equipo
        INTO v_idemp, v_runemp, v_nom, v_categorizacion, v_idequipo
        FROM empleado
        WHERE id_empleado = v_minid;
        
        -- recuperamos número de ventas y monto neto de las ventas de los empleados
        SELECT COUNT(*), nvl(SUM(db.cantidad*P.precio),0)
        INTO v_nro_ventas, v_ventas_netas_mes
        FROM boleta b JOIN detalleboleta db
        ON b.id_boleta = db.id_boleta
        JOIN producto P 
        ON P.id_producto = db.id_producto
        WHERE to_char(b.fecha_boleta, 'YYYYMM') = :b_fecha
        AND b.id_empleado = v_minid 
        GROUP BY b.id_empleado;

            -- calculamos la asignación por ventas                
        IF (v_nro_ventas > 10) THEN
            v_asignacion_vtas := v_ventas_netas_mes * :b_pct1;
        ELSIF(v_nro_ventas BETWEEN 9 AND 10)THEN
            v_asignacion_vtas := v_ventas_netas_mes * :b_pct2;
        ELSIF(v_nro_ventas BETWEEN 6 AND 8 ) THEN
            v_asignacion_vtas := v_ventas_netas_mes * :b_pct3;
        ELSIF(v_nro_ventas BETWEEN 3 AND 5 ) THEN
            v_asignacion_vtas := v_ventas_netas_mes * :b_pct4;
        ELSIF(v_nro_ventas BETWEEN 1 AND 2 ) THEN
            v_asignacion_vtas := v_ventas_netas_mes * :b_pct5;
        END IF;            
        v_asignacion_vtas := round(v_asignacion_vtas);          

        -- Incentivo por categoría
        SELECT porcentaje / 100
        INTO v_pctcat
        FROM categorizacion
        WHERE id_categorizacion = v_categorizacion;
        v_incentivo_categorizacion := round(v_ventas_netas_mes * v_pctcat);

      
        -- Incentivo por Grupo
        SELECT porc / 100, nom_equipo        
        INTO v_pctequipo, v_nomequipo
        FROM equipo
        WHERE id_equipo = v_idequipo;                 
        v_bono_equipo := round(v_ventas_netas_mes * v_pctequipo);

        -- Asignacion especial por antiguedad
        SELECT EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM feccontrato)
        INTO v_anti
        FROM empleado
        WHERE id_empleado = v_minid;
        v_asignacion_antig := round(CASE
                                       WHEN v_anti > 15 THEN v_ventas_netas_mes * 0.27 
                                       WHEN v_anti BETWEEN 6 AND 15 THEN v_ventas_netas_mes * 0.14             
                                       WHEN v_anti BETWEEN 3 AND 7 THEN v_ventas_netas_mes * 0.04
                                       ELSE 0
                                    END);
                                                                  
        -- Se recuperan los cargos o descuentos del mes anterior
        SELECT monto
        INTO v_descuentos
        FROM descuento
        WHERE id_empleado = v_minid
        AND mes = SUBSTR(:b_fecha,-2) -1;           
      
        -- Se calcula el total de las ventas mensuales
       v_totales_mes := (v_ventas_netas_mes + v_asignacion_vtas + v_asignacion_antig + v_incentivo_categorizacion + v_bono_equipo - v_descuentos);
   
        -- Se asigna la comision de acuerdo con el total de ventas mensuales
        SELECT comision / 100
        INTO v_pctcom
        FROM comisionempleado
        WHERE v_totales_mes BETWEEN ventaminima AND ventamaxima;
        v_comision_ventas := round(v_totales_mes * v_pctcom);
        
        -- Se insertan los datos        
        INSERT INTO detalle_venta_empleado
        VALUES (SUBSTR(:b_fecha,1,4), substr(:b_fecha, -2), v_idemp, v_nom, v_nomequipo,
                v_nro_ventas, v_ventas_netas_mes, v_bono_equipo, v_incentivo_categorizacion,
                v_asignacion_vtas, v_asignacion_antig, v_descuentos, v_totales_mes);
               
        INSERT INTO comision_venta_empleado
        VALUES (SUBSTR(:b_fecha,1,4), substr(:b_fecha, -2), v_idemp, v_totales_mes, v_comision_ventas);
      
       v_minid := v_minid + 2;       

    END LOOP;
END;
/

