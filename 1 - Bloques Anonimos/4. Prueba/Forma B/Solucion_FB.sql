VARIABLE b_fecha VARCHAR2(6);
EXEC :b_fecha := '202105';
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
    v_runven vendedor.rut_vendedor%TYPE;
    v_nom varchar2(50);  
    v_idven NUMBER;
    v_nro_ventas NUMBER;
    v_ventas_netas_mes NUMBER;
    v_minid NUMBER;
    v_maxid NUMBER;
    v_asignacion_vtas NUMBER;
    v_pctcat NUMBER;
    v_categ vendedor.id_categoria%TYPE;
    v_incentivo_categ NUMBER;    
    v_idgrupo vendedor.id_grupo%TYPE;
    v_nomgrupo VARCHAR2(10);
    v_pctgrupo NUMBER;
    v_bono_grupo NUMBER;
    v_anti NUMBER;
    v_asignacion_antig NUMBER;
    v_descuentos NUMBER;
    v_totales_mes NUMBER;  
    v_comision_ventas NUMBER;  
    v_pctcom NUMBER;
BEGIN
    -- borrado de tablas
    EXECUTE IMMEDIATE 'TRUNCATE TABLE infoventa_vendedor';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE comision_venta_vendedor';
    
    -- Se extrae el mínimo y máximo id de vendedor para recorrer la tabla empleado
    SELECT MIN(id_vendedor), MAX(id_vendedor) INTO v_minid, v_maxid FROM vendedor;
         
    -- Se inicia el bucle
   WHILE  v_minid <= v_maxid
   LOOP  
        -- Se recuperan los datos del empleado o vendedor
        SELECT id_vendedor, rut_vendedor, apellidos || ' ' || nombres, id_categoria, id_grupo
        INTO v_idven, v_runven, v_nom, v_categ, v_idgrupo
        FROM vendedor
        WHERE id_vendedor = v_minid;
        
        -- recuperamos número de ventas y monto neto de las ventas de los empleados

        SELECT COUNT(*), nvl(SUM(dv.cantidad * ar.precio),0)
        INTO v_nro_ventas, v_ventas_netas_mes
        FROM venta v JOIN detalleventa dv
        ON v.id_venta = dv.id_venta
        JOIN articulo ar 
        ON ar.id_articulo = dv.id_articulo
        WHERE to_char(v.fecha_venta, 'YYYYMM') = :b_fecha
        AND v.id_vendedor = v_minid 
        GROUP BY v.id_vendedor;

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
        FROM categoria
        WHERE id_categoria = v_categ;
        v_incentivo_categ := round(v_ventas_netas_mes * v_pctcat);

      
        -- Incentivo por Grupo
        SELECT porc / 100, nom_grupo        
        INTO v_pctgrupo, v_nomgrupo
        FROM grupo
        WHERE id_grupo = v_idgrupo;                 
        v_bono_grupo := round(v_ventas_netas_mes * v_pctgrupo);


        -- Asignacion especial por antiguedad
        SELECT EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM feccontrato)
        INTO v_anti
        FROM vendedor
        WHERE id_vendedor = v_minid;
        v_asignacion_antig := round(CASE
                                       WHEN v_anti > 15 THEN v_ventas_netas_mes * 0.27 
                                       WHEN v_anti BETWEEN 6 AND 15 THEN v_ventas_netas_mes * 0.14             
                                       WHEN v_anti BETWEEN 3 AND 7 THEN v_ventas_netas_mes * 0.04
                                       ELSE 0
                                    END);

                                                                  
        -- Se recuperan los descuentos del mes anterior
        SELECT monto
        INTO v_descuentos
        FROM anticipo
        WHERE id_vendedor = v_minid
        AND mes = SUBSTR(:b_fecha,-2) -1;
            
      
        -- Se calcula el total de las ventas mensuales
       v_totales_mes := (v_ventas_netas_mes + v_asignacion_vtas + v_asignacion_antig + v_incentivo_categ + v_bono_grupo - v_descuentos);
   
        -- Se asigna la comision de acuerdo con el total de ventas mensuales
        SELECT comision / 100
        INTO v_pctcom
        FROM comisionvendedor
        WHERE v_totales_mes BETWEEN ventaminima AND ventamaxima;
        v_comision_ventas := round(v_totales_mes * v_pctcom);
        
        -- Se insertan los datos        
        INSERT INTO infoventa_vendedor
        VALUES (SUBSTR(:b_fecha,1,4), substr(:b_fecha, -2), v_idven, v_nom, v_nomgrupo,
                v_nro_ventas, v_ventas_netas_mes, v_bono_grupo, v_incentivo_categ,
                v_asignacion_vtas, v_asignacion_antig, v_descuentos, v_totales_mes);
               
        INSERT INTO comision_venta_vendedor
        VALUES (SUBSTR(:b_fecha,1,4), substr(:b_fecha, -2), v_idven, v_totales_mes, v_comision_ventas);
      
        -- Se imprime la segunda parte del informe
        dbms_output.put_line(to_char(v_minid,'000')
        ||' '||rpad(v_nom,16,' ')
        ||' '||to_char(v_nro_ventas,'0000')
        ||' '||to_char(v_ventas_netas_mes,'$9g999g999')
        ||' '||to_char(v_asignacion_vtas ,'$9g999g999')
        ||' '||to_char(v_incentivo_categ, '$999g999')
        ||' '||to_char(v_bono_grupo, '$999g999')
        ||' '||to_char(v_asignacion_antig, '$9g999g999')
        ||' '||to_char(v_descuentos , '$999g999')
        ||' '||to_char(v_totales_mes,'$9g999g999')
        );

       v_minid := v_minid + 5;      
       
    END LOOP;
    dbms_output.put_line('==========================================================================================================');
END;
/


