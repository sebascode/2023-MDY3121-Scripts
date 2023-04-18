DECLARE
  v_contador NUMBER(3) := 0;
  v_stop NUMBER(3) := 10;
  v_step NUMBER(3) := 2;
BEGIN
  /*
   * WHILE, funcionalidad exactamente igual al de programación regular.
   * Nos permite generar un ciclo manual, controlando todo lo que necesitamos dando sólo una condición de salida
   * o término del proceso. Se puede complejizar a nuestro gusto la condición y la operación interna
   */
  dbms_output.put_line('Contando en saltos de '|| v_step || ' hasta que lleguemos al '||v_stop || ' desde el '|| v_contador);
  WHILE (v_contador < v_stop)
  LOOP
    v_contador := v_contador + v_step;
    dbms_output.put_line(v_contador);
  END LOOP;
END;
