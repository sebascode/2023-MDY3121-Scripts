DECLARE
  v_max NUMBER(3);
  v_min NUMBER(3);
BEGIN
  /*
   * 1. Usando como índice, desde 1 hasta 10.
   */
  FOR i IN 1..10
  LOOP
    dbms_output.put_line(i);
  END LOOP;
  
  -- Usando como índice con variables
  SELECT MAX(id)
  INTO v_max
  FROM employees;
  
  SELECT MIN(id)
  INTO v_min
  FROM employees;
  
  -- imprime todos los IDs que hay entremedio del mínimo y máximo.
  FOR ids IN v_min..v_max
  LOOP
    dbms_output.put_line(ids);
  END LOOP;
  
  /*
   * 2. Usando como FOREACH, permitiendo iterar entre elementos.
   */
   -- volcamos un SELECT en una variable contenedora que se llamará "obj", y podemos usar sus datos.
   FOR obj IN (SELECT id_employee, fullname, status FROM employee)
   LOOP
      dbms_output.put_line('Empleado id: '|| obj.id_employee);
      dbms_output.put_line('Empleado nombre: '|| obj.fullname);
      dbms_output.put_line('Empleado estado: '|| obj.status);
   END LOOP;
END;
