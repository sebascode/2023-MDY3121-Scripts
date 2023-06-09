# Ejercicios 3ra Unidad

En una empresa de consultorías informáticas que comenzó como startup en el mercado, debe realizar gestiones y dimensiones sobre tareas cotidianas para la empresa sobre excel. Aprovechando la motivación y ganas, y que tienen un dev junior bastante bueno en lógica (usted), le han planteado el desafío de automatizar las funciones más cotidianas que realizan.
Le entregaron un DDL con las tablas base a utilizar, las cuales son:
- `ej_empleado`: Tabla donde se almacena un listado completo de los empleados y sus datos más básicos.
- `ej_rol`: Se almacenan los roles actuales donde son contratados.
- `ej_departamento`: Se almacenan los departamentos que posee actualmente la empresa.
- `ej_managers`: tabla transaccional que almacena el `id de departamento` y el `id de empleado` para saber quién administra qué departamento, ya que pueden haber varios administradores del mismo departamento.

Según estos datos le indican que el sistema debe tener las siguientes características:
- Se debe poder crear un `empleado` y asignarle automáticamente al manager de su departamento, esto por motivos de **regla de empresa**.
- Se debe poder reasignar un `manager` y ésto debe actualizar a todos los empleados bajo el mismo manager.
- Se debe poder crear `roles` solo indicando el nombre.
- Se debe poder crear `departamentos` sólo indicando el nombre.
- Se debe poder reasignar un `empleado` indicando sólo el `id` y el `departamento` nuevo.
- Se debe poder re rolear un `empleado` indicando sólo el `id` y el `rol` nuevo.
- Al desvincular un `empleado` éste debe pasar automáticamente a una tabla que lo represente (creada por usted) agregándole un `comentario`.
- Se puede recontratar un empleado, así que cada vez que se agrege un empleado éste debe ser verificado si ya estuvo previamente trabajando.

Según el DDL de la unidad [DDL](%2F3%20-%20Bloques%20Persistentes%2F3.0%20DDL.sql), realizar la siguiente solicitud:

- [ ]  1. Crear un paquete de elementos que permita Generar las funciones de Empleados.
- [ ]  2. Crear un paquete de elementos que permita Generar las funciones de Departamentos.
- [ ]  3. Crear Eventos automáticos para gestionar la tabla de managers.
- [ ]  4. Crear triggers necesarios para realizar los movimientos necesarios.
- [ ]  5. Crear vistas de reportes de sueldo por departamentos, por roles, por departamentos + roles.
