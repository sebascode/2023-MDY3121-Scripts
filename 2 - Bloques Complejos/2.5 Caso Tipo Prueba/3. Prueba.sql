VARIABLE b_fecha VARCHAR2(6);
EXEC :b_fecha := '202106';
VARIABLE b_totalasilimite NUMBER;
EXEC :b_totalasilimite := 410000;
DECLARE
   -- cursor que recupera datos de las profesiones
   CURSOR c_profesion IS 
   SELECT nombre_profesion, asignacion
   FROM profesion
   ORDER BY nombre_profesion;

   -- cursor que recupera datos de los profesionales de una profesi�n determinada
   -- que posean un promedio de honorarios superior al promedio de honorarios en el mes procesado
   CURSOR c_profesional (p_profesion VARCHAR2) IS
   SELECT numrun_prof RUN, P.nombre || ' ' || P.appaterno nombre, pr.nombre_profesion, p.cod_tpcontrato,
          p.cod_comuna, p.puntaje, p.sueldo,
          COUNT(*) asesorias, SUM(A.honorario) honorarios
   FROM profesional P JOIN profesion pr USING (cod_profesion)
   JOIN asesoria A USING (numrun_prof)
   WHERE to_char(A.inicio_asesoria, 'YYYYMM') = :b_fecha
   AND pr.nombre_profesion = p_profesion
   GROUP BY numrun_prof, P.nombre,P.appaterno,pr.nombre_profesion,p.cod_tpcontrato,p.cod_comuna,p.puntaje,p.sueldo
   ORDER BY pr.nombre_profesion, p.appaterno, p.nombre;

   -- variables escalares 
   v_msg VARCHAR2(300);
   v_msgusr VARCHAR2(300);
   v_codemp NUMBER(2);
   v_comuna comuna.nom_comuna%TYPE;
   v_asigmov NUMBER(8) := 0;
   v_pcteva NUMBER(4,2) := 0;
   v_asigeva NUMBER(8) := 0;
   v_asigtipoc NUMBER(8) := 0;
   v_pcttipoc NUMBER(8) := 0;
   v_asigprof NUMBER(8) := 0;
   v_asignaciones_profesional NUMBER(8) := 0;
  
   -- variables escalares acumuladoras
   v_tot_asesorias NUMBER(8) := 0;
   v_tot_honorarios NUMBER(8) := 0;
   v_tot_asigmov NUMBER(8) := 0;
   v_tot_asigeva NUMBER(8) := 0;
   v_tot_asigprof NUMBER(8) := 0;
   v_tot_asigtipoc NUMBER(8) := 0;
   v_tot_asigprofesion NUMBER(8) := 0;
   
   -- varray
   TYPE t_descuentos IS VARRAY(6) OF NUMBER;
   v_desctos t_descuentos := t_descuentos(0.02,0.04,0.05,0.07,0.09,25000);
  
   -- excepcion para el error de usuario
   e_asignacion_limite EXCEPTION;
BEGIN
   -- truncamos las tablas
   EXECUTE IMMEDIATE 'TRUNCATE TABLE errores_p';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE detalle_asignacion_mes';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_mes_profesion';
   EXECUTE IMMEDIATE 'DROP SEQUENCE sq_error';
   EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_error';

   -- cursor que recorre las profesiones
   FOR r_profesion IN c_profesion LOOP
 
       -- reiniciamos las variables acumuladoras  
       v_tot_asesorias := 0;
       v_tot_honorarios := 0;
       v_tot_asigmov := 0;
       v_tot_asigeva := 0;
       v_tot_asigtipoc := 0;
       v_tot_asigprof := 0;
       v_tot_asigprofesion := 0;
    
       FOR r_profesional IN c_profesional (r_profesion.nombre_profesion) LOOP
           
           -- determinamos la asignaci�n por traslados
           SELECT nom_comuna, codemp_comuna
           INTO v_comuna, v_codemp
           FROM comuna
           WHERE cod_comuna = r_profesional.cod_comuna;
           IF v_comuna != 'Providencia' THEN
               v_asigmov := CASE v_codemp
                                 WHEN 10 THEN ROUND(r_profesional.honorarios * v_desctos(1))
                                 WHEN 20 THEN ROUND(r_profesional.honorarios * v_desctos(2))
                                 WHEN 30 THEN ROUND(r_profesional.honorarios * v_desctos(3))
                                 WHEN 40 THEN ROUND(r_profesional.honorarios * v_desctos(4))
                                 ELSE ROUND(r_profesional.honorarios * v_desctos(5))
                            END;
           END IF;

           -- determinamos la asignaci�n por evaluaci�n del profesional
           BEGIN
               SELECT porcentaje / 100
               INTO v_pcteva
               FROM evaluacion
               WHERE r_profesional.puntaje BETWEEN eva_punt_min AND eva_punt_max;        
           EXCEPTION    
             WHEN no_data_found THEN
                v_msg := SQLERRM;
                v_pcteva := 0; 
                   v_msgusr := 'No se encontr� porcentaje de evaluaci�n para el run Nro. ' || TO_CHAR(r_profesional.run,'09G999G999');
                INSERT INTO errores_p
                VALUES (sq_error.NEXTVAL, v_msg, v_msgusr);
             WHEN too_many_rows THEN
                v_msg := SQLERRM;
                v_pcteva := 0; 
                   v_msgusr := 'Se encontr� m�s de un porcentaje de evaluaci�n para el run Nro. ' || TO_CHAR(r_profesional.run,'09G999G999');
                INSERT INTO errores_p
                VALUES (sq_error.NEXTVAL, v_msg, v_msgusr);
           END;
           v_asigeva := ROUND(r_profesional.honorarios * v_pcteva);

          -- recuperamos porcentaje y determinamos el monto de la asignaci�n por tipo de contrato
          SELECT incentivo
          into v_pcttipoc  
          from tipo_contrato
          where cod_tpcontrato = r_profesional.cod_tpcontrato;
          v_asigtipoc := ROUND(r_profesional.honorarios * v_pcttipoc / 100);

          -- determinamos el monto de la asignaci�n pprofesional
          v_asigprof := ROUND(r_profesional.sueldo * r_profesion.asignacion / 100);
                            
          -- calculamos el total de las asignaciones
          v_asignaciones_profesional  :=  v_asigmov+v_asigtipoc+v_asigprof;

          -- preparamos el escenario para levantar la excepcion de usuario
          BEGIN
              IF v_asignaciones_profesional > :b_totalasilimite THEN
                  RAISE e_asignacion_limite;  
              END IF;
          EXCEPTION
              WHEN e_asignacion_limite THEN
                 v_msg := 'ORA-20001 Monto total de asignaciones para el run Nro. ' || TO_CHAR(r_profesional.run,'09G999G999') || ' sobrepas� el limite permitido';
                    INSERT INTO errores_p
                    VALUES (sq_error.NEXTVAL, v_msg,
                           'Se reemplaz� el monto total de las asignaciones calculadas de '
                           || TO_CHAR(v_asignaciones_profesional, '$999G999') || ' por el monto l�mite de $'
                           || TO_CHAR(:b_totalasilimite, '$999G999'));
                 v_asignaciones_profesional := :b_totalasilimite;
          END;

          -- insertamos en la tabla de detalle
          INSERT INTO detalle_asignacion_mes
          VALUES (SUBSTR(:b_fecha,-2),SUBSTR(:b_fecha,1,4),r_profesional.RUN,r_profesional.nombre,r_profesional.nombre_profesion,
                  r_profesional.asesorias,r_profesional.honorarios,v_asigmov,v_asigeva,v_asigtipoc,
                  v_asigprof,v_asignaciones_profesional);
                     
          -- acumulamos en las variables sumadoras
          v_tot_asesorias := v_tot_asesorias + r_profesional.asesorias;
          v_tot_honorarios := v_tot_honorarios + r_profesional.honorarios;
          v_tot_asigmov := v_tot_asigmov + v_asigmov;
          v_tot_asigeva := v_tot_asigeva + v_asigeva;
          v_tot_asigtipoc := v_tot_asigtipoc + v_asigtipoc;
          v_tot_asigprof := v_tot_asigprof + v_asigprof;
          v_tot_asigprofesion := v_tot_asigprofesion + v_asignaciones_profesional;
          
       END LOOP;
       
       -- INSERTAMOS EN LA TABLA DE RESUMEN
       INSERT INTO resumen_mes_profesion
       VALUES (:b_fecha, r_profesion.nombre_profesion,v_tot_asesorias,v_tot_honorarios,v_tot_asigmov,v_tot_asigeva,
               v_tot_asigtipoc,v_tot_asigprof,v_tot_asigprofesion);
   END LOOP;
   -- salvamos los datos
   COMMIT;
END;  
/  
