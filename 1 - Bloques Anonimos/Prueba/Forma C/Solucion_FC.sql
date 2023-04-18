VARIABLE b_fecha_proceso VARCHAR2(7);
EXEC :b_fecha_proceso:='05/2021';
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
v_minid NUMBER(3);
v_maxid NUMBER(3);
v_pctafp number;
v_pctsalud number;
v_rutvend NUMBER(10);
v_sueldo NUMBER(8);
v_nom VARCHAR2(50);
v_feccont DATE;
v_antig NUMBER;
v_idcateg vendedor.id_categoria%TYPE;
v_numcargas NUMBER;
v_asig_antig NUMBER(8):=0;
v_asig_categ NUMBER(8):=0;
v_asig_cargas NUMBER(8):=0;
v_com_ventas  NUMBER(8);
v_neto_ventas NUMBER(8) := 0;
v_pctcat NUMBER := 0;
v_idgrupo vendedor.id_grupo%TYPE;
v_asig_grupo NUMBER(8):= 0;
v_descuentos NUMBER;
v_total_haberes NUMBER(10) := 0;
v_monto_afp NUMBER(10) := 0;
v_monto_salud NUMBER(10) := 0;
BEGIN
   -- Truncamos las tablas para facilitar la ejecución del bloque
   EXECUTE IMMEDIATE('TRUNCATE TABLE HABER_MES_VENDEDOR');
   EXECUTE IMMEDIATE('TRUNCATE TABLE DESCUENTO_MES_VENDEDOR');

   -- Se obtienen las id mínima y máxima para recorrer la tabla vendedor
   SELECT MIN(id_vendedor), MAX(id_vendedor) INTO v_minid, v_maxid FROM vendedor;

   WHILE  v_minid <= v_maxid
   LOOP

      SELECT v.rut_vendedor, apellidos || ' ' || nombres, v.feccontrato, v.sueldo, v.id_categoria, 
             v.id_grupo, a.porc_descto_afp / 100, s.porc_descto_salud / 100
      INTO v_rutvend, v_nom, v_feccont, v_sueldo, v_idcateg, v_idgrupo, v_pctafp, v_pctsalud
      FROM vendedor v join afp a using (id_afp)
      join salud s using (id_salud)
      WHERE v.id_vendedor = v_minid;
      
      -- Obtiene bonificación por antiguedad
      v_antig :=  EXTRACT(YEAR FROM SYSDATE) - EXTRACT(year from v_feccont);
      IF v_antig > 0 THEN
           SELECT ROUND(v_sueldo * (porc_bonif/100))
             INTO v_asig_antig
             FROM bonificacion_antig
            WHERE v_antig BETWEEN antig_inf AND antig_sup;
      END IF;

     -- Obtiene el numero de cargas y calcula la asignacion por cargas
     SELECT COUNT(*)
     INTO v_numcargas
     FROM carga_familiar
     WHERE id_vendedor = v_minid;
     v_asig_cargas := ROUND(6300 * v_numcargas);

     -- recupera el monto de comisiones y el total neto de las ventas de cada vendedor en el mes respectivo   
     SELECT NVL(SUM(monto_comision),0), NVL(SUM(total_ventas),0) 
     INTO v_com_ventas, v_neto_ventas
     FROM comision_venta
     WHERE anno = substr(:b_fecha_proceso,4)
     AND mes = substr(:b_fecha_proceso,1,2)
     AND id_vendedor = v_minid;
    
     -- recupera el % necesario para calcular la asignacion especial por ventas
     select NVL(porcentaje / 100,0)
     into v_pctcat
     from categoria
     where id_categoria = v_idcateg;
     IF v_idcateg IN ('A', 'B', 'C') THEN
        v_asig_categ := ROUND(v_neto_ventas * v_pctcat);
     ELSE
        v_asig_categ := ROUND(v_neto_ventas * 0.03);
     END IF;
      
     -- calcula asignacion especial por pertenencia a grupo de ventas
     -- siempre que el monto neto de ventas supere $5.500.000
     IF v_neto_ventas > 5500000 then
        v_asig_grupo := ROUND(CASE v_idgrupo
                           WHEN 'A' THEN v_sueldo * :b_pct1
                           WHEN 'B' THEN v_sueldo * :b_pct2
                           WHEN 'C' THEN v_sueldo * :b_pct3
                           WHEN 'D' THEN v_sueldo * :b_pct4
                           ELSE v_sueldo * :b_pct5
                         END);   
     ELSE           
        v_asig_grupo := 0;
     END IF;

     -- Se recuperan los descuentos del mes anterior
     SELECT monto
     INTO v_descuentos
     FROM anticipo
     WHERE id_vendedor = v_minid
     AND mes = SUBSTR(:b_fecha_proceso,1,2) -1;      
     
     -- calculamos el total de los haberes
     v_total_haberes := v_sueldo + v_asig_antig + v_asig_cargas + v_com_ventas + v_asig_categ +
                        v_asig_grupo - v_descuentos;

     -- determinamos los descuentos
     v_monto_afp := ROUND(v_total_haberes * v_pctafp);
     v_monto_salud := ROUND(v_total_haberes * v_pctsalud);

    -- insertamos en las tablas    
    INSERT INTO haber_mes_vendedor
    VALUES(v_minid, v_rutvend, SUBSTR(:b_fecha_proceso,1,2), SUBSTR(:b_fecha_proceso,4), v_sueldo,
           v_asig_antig,v_asig_cargas, v_com_ventas, v_asig_categ, v_asig_grupo, v_descuentos,v_total_haberes);

    INSERT INTO descuento_mes_vendedor
    VALUES(v_minid, v_rutvend, SUBSTR(:b_fecha_proceso,1,2), SUBSTR(:b_fecha_proceso,4), v_monto_salud, v_monto_afp);
    COMMIT;

    v_minid := v_minid + 10;      
   END LOOP;
END;
/

