DECLARE 
    i NUMBER(3) := 1;
BEGIN 
  /*
  Iterador manual: símil al ´DO´ en programación.
  */
  -- llamamos un iterador común y manualmente indicamos cuando debe salirse
  LOOP 
    dbms_output.put_line(i);
    i:=i+1;
    IF(i>10) THEN 
      EXIT;
    END IF;
  END LOOP;
  
  -- Otra forma de usar es dictar la condición de salida.
  i:=1;
  LOOP 
    dbms_output.put_line(i);
    i:=i+1;
    EXIT WHEN (i>10);
  END LOOP;
  
END;
