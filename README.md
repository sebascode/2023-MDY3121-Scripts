# 2023-MDY3121-Scripts Ejercicios Unidad 2

Scripts ejecutados en clases para el ramo de Programación en Base de Datos (MDY3121) DUOC UC - San Joaquín.
Se debe Utilizar la Base de datos recomendada en este repositorio [link](https://github.com/sebascode/2023-MDY3121-Scripts/blob/main/2%20-%20Bloques%20Complejos/2.0%20DDL)

## Ejercicios a realizar

1. Crear un bloque anónimo que sume N veces un número cualquiera (aleatorio).
Imprima en pantalla los números aleatorios generados y la suma total de cada uno.
Las iteraciones y su cantidad deberán generarse de manera aleatoria,
considerando los valores del 2 al 20. Los números aleatorios generados en
cada iteración deberán ser del 20 al 200.
> P.S: FLOOR(DBMS_RANDOM.value(n,m)) te entrega un número RANDOM entre N y M.

2. Crear un bloque que imprima la cantidad de números múltiplos de 3
que existen del 1 al 200.
>P.S: MOD es una función que entrega el restante entre una división.
> 2%2 = 1, MOD = 0, 3%2= 1 MOD = 1;

3. Crear un bloque anónimo que nos imprima la tabla de multiplicar del 1 al 10.

OUTPUT:
```
1x1 = 1
1x2 = 2
1x3 = 3
(..)
9x9 = 81
9x10 = 90
10x1 = 10
(..)
10x9 = 90
10x10 = 100
```

4. Desarrollar un bloque anónimo que usando cursor explícito de lista de vendedores 
(id, nombres, apellidos, fecha nacimiento y sueldo) muestre quien tiene un sueldo menor o
igual $ 354,000.
Mostrar el resultado por cada registro.
>P.S.: Usar variables ESCALAR (%TYPE)

OUTPUT:
```plaintext
--------------------------------------------------
INFORME DE EMPLEADOS
--------------------------------------------------
[1] Empleado N° 5 - María Rivera tiene un sueldo de $350,000
[2] Empleado N° 10 - Jeremías Lorca tiene un sueldo de $345,000
[3] Empleado N° 30 - Olga Cajas tiene un sueldo de $346,372
(...)
```

5.  Elaborar un bloque anónimo PL/SQL que devuelva un reporte de los vendedores
que tienen un salario menor e igual a $ 400,000. El reporte debe mostrarse
agrupado por Categoría. Los valores de la columna deben ser por ancho fijo.

OUTPUT:
```plaintext
--------------------------------------------------
INFORME DE EMPLEADOS POR DEPARTAMENTO
--------------------------------------------------
CATEGORÍA A: 
35	    HUMBERTO ORREGO         $354,000
55	    ELIZABETH MIRANDA       $348,232
50	    DOMITILA PAREDES        $338,432
(...)
```

6. De una lista de Vendedores, Clientes y Empleado, Seleccionar su Nombre Completo,
Rut, Nombre Equipo, Nombre Categoría, Sueldo, ID y Tipo (vendedor, empleado o cliente)
Dejando en Blanco o en 0 (según corresponda) los datos que no posea y listar
unificadamente.

P.S.: Usar Record para unificar

OUTPUT:
```plaintext
----------------------------------------------------------------------------------------
                    INFORME DE EMPLEADOS, CLIENTES Y VENDEDORES
----------------------------------------------------------------------------------------
TIPO        ID  NOMBRE COMPLETO         RUT         EQUIPO      CATEGORIA       SUELDO
----------------------------------------------------------------------------------------
Cliente	    9   SEVILLANO MORENO LUISA                                          $0
Cliente     10  CHÁVEZ CARDENAS TERRY                                           $0
Empleado    6   NORA BROMSLER           33333334    Equipo A    Categoria A     $367,400
Empleado    14	HANS ORLON              77777778    Equipo B    Categoria A     $354,000
Empleado    16	CHARLES BEATTY          88888889    Equipo C    Categoria A     $353,504
Empleado    20	DONNA PETRI             101111112   Equipo C    Categoria A     $338,432
Empleado    22	ELIZABETH YARROW        111111113   Equipo B    Categoria A     $348,232
Vendedor    60	ROLANDO GUERRA          121111114               Categoria B     $356,734
Vendedor    65	HERNALDO CACERES        131111115               Categoria B     $364,832
```

7. Desarrollar un bloque anónimo que nos permita:
- Identificar y almacenar una persona en un VARRAY (del ejercicio anterior)
- Buscar su incidencia en cada sección de la base de datos
- Listar movimientos de cada uno en formato "LOG" ordenado por fecha donde
corresponda.

P.S: Usar a Iteradores, cursores explícitos, VARRAY y bloques anónimos anidados.
Tablas: son 4.

OUTPUT:
```plaintext
----------------------------------------------------------------------------------------
                        LOG DE MOVIMIENTOS POR USUARIO
----------------------------------------------------------------------------------------
[Descuento] El empleado MARY CULVERT el mes de ABRIL se le ha descontado $12,987
[Boleta] El empleado MARY CULVERT Realizó una Boleta #8 el 28/04/2021 para el cliente ZAMORA MOLINA TOMÁS por $64,350
(...)
```
