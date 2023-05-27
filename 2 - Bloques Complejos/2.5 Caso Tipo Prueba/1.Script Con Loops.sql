DECLARE
   -- cursor que recupera las profesiones
   CURSOR c1 IS
   SELECT *
   FROM profesion
   where cod_profesion in (select cod_profesion
                          from profesional);
   -- cursor que recupera productos de cada viñatero
   -- recibe como parámetro la id del productor
   CURSOR c2 (n NUMBER) IS
   SELECT *
   FROM profesional
   WHERE cod_profesion = n;
   counter number := 0;
   
   r1 profesion%ROWTYPE;
   r2 profesional%ROWTYPE;
BEGIN
   OPEN c1;
   LOOP
      FETCH c1 INTO r1;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line('####### LISTA DE CONSULTORES DE PROFESION ' || '"' || UPPER(r1.nombre || '"'));
      dbms_output.put_line(CHR(13));   
      dbms_output.put_line(lpad('-',65,'-'));
      dbms_output.put_line('  RUN  NOMBRE CONSULTOR      PUNTAJE  SUELDO ACTUAL   NUEVO SUELDO');
      dbms_output.put_line(lpad('-',65,'-'));
      counter := 0;
      
      OPEN c2(r1.codigo);
      LOOP
        FETCH c2 INTO r2;
        EXIT WHEN c2%NOTFOUND;
         counter := counter + 1;       
             dbms_output.put_line(rpad(r2.numrun_prof,10,' ')
                || ' ' || RPAD(r2.appaterno || ' ' || r2.nombre, 20,' ')
                || ' ' || TO_CHAR(r2.puntaje,'999')
                || ' ' || rpad(TO_CHAR(r2.sueldo, '$9G999G999'),15, ' ')
                || ' ' || TO_CHAR(r2.sueldo * 1.1, '$9G999G999'));
      END LOOP;  
      CLOSE c2;
      dbms_output.put_line(lpad('-',65,'-'));      
      dbms_output.put_line('Total de consultores : ' || counter);      
      dbms_output.put_line(CHR(12));
   END LOOP;
 END;
/
