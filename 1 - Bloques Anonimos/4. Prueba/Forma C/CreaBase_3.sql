DROP TABLE detalleventa CASCADE CONSTRAINTS;
DROP TABLE afp CASCADE CONSTRAINTS;
DROP TABLE salud CASCADE CONSTRAINTS;
DROP TABLE venta CASCADE CONSTRAINTS;
DROP TABLE articulo CASCADE CONSTRAINTS;
DROP TABLE anticipo CASCADE CONSTRAINTS;
DROP TABLE vendedor CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE categoria CASCADE CONSTRAINTS;
DROP TABLE comision_venta CASCADE CONSTRAINTS;
DROP TABLE carga_familiar CASCADE CONSTRAINTS;
DROP TABLE bonificacion_antig CASCADE CONSTRAINTS;
DROP TABLE haber_mes_vendedor CASCADE CONSTRAINTS;
DROP TABLE descuento_mes_vendedor CASCADE CONSTRAINTS;

--------------------------------------------------------
--  DDL for Table categoria
--------------------------------------------------------
CREATE TABLE categoria (
  id_categoria CHAR(1) NOT NULL, 
  nom_categoria VARCHAR2(15) NOT NULL , 
  porcentaje NUMBER,
  CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

--------------------------------------------------------
--  DDL for Table CLIENTE
--------------------------------------------------------

  CREATE TABLE cliente (
    id_cliente NUMBER NOT NULL, 
    nombre_cliente VARCHAR2(35) NOT NULL, 
    direccion VARCHAR2(50) NOT NULL, 
    comuna VARCHAR2(25) NOT NULL, 
    telefono VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
) ;
--------------------------------------------------------
--  DDL for Table articulo
--------------------------------------------------------

  CREATE TABLE articulo (
    id_articulo NUMBER NOT NULL, 
    nom_articulo VARCHAR2(25) NOT NULL, 
    fab_articulo VARCHAR2(20) NOT NULL, 
    des_articulo VARCHAR2(68), 
    precio NUMBER NOT NULL, 
    stock NUMBER NOT NULL,
    CONSTRAINT pk_articulo PRIMARY KEY (id_articulo)
) ;
--------------------------------------------------------
--  DDL for Table vendedor
--------------------------------------------------------

CREATE TABLE vendedor (
  id_vendedor NUMBER(6) NOT NULL, 
  rut_vendedor VARCHAR2(10) NOT NULL, 
  nombres VARCHAR2(25) NOT NULL, 
  apellidos VARCHAR2(25) NOT NULL, 
  fecnac DATE NOT NULL, 
  feccontrato DATE NOT NULL, 
  id_grupo VARCHAR2(1) , 
  id_categoria CHAR(1) , 
  sueldo NUMBER NOT NULL, 
  id_afp NUMBER NOT NULL,
  id_salud NUMBER NOT NULL,
  CONSTRAINT pk_vendedor PRIMARY KEY (id_vendedor),
  CONSTRAINT ak_vendedor UNIQUE (rut_vendedor)
);

--------------------------------------------------------
--  DDL for Table anticipo
--------------------------------------------------------

CREATE TABLE anticipo (
  id_vendedor NUMBER(6) NOT NULL, 
  mes NUMBER(2),
  monto NUMBER(8),
  CONSTRAINT pk_anticipo PRIMARY KEY (id_vendedor, mes)
);  
  
--------------------------------------------------------
--  DDL for Table venta
--------------------------------------------------------
  CREATE TABLE venta (
    id_venta NUMBER NOT NULL, 
    id_cliente NUMBER NOT NULL, 
    id_vendedor NUMBER, 
    fecha_venta DATE NOT NULL,
    CONSTRAINT pk_venta PRIMARY KEY (id_venta)
) ;

--------------------------------------------------------
--  DDL for Table detalleventa
--------------------------------------------------------
  CREATE TABLE detalleventa (
    id_venta NUMBER NOT NULL,
    id_articulo NUMBER NOT NULL, 
    cantidad NUMBER NOT NULL,
    CONSTRAINT pk_detalleventa PRIMARY KEY (id_venta, id_articulo)
) ;


--------------------------------------------------------
--  DDL for Table carga_familiar
--------------------------------------------------------
CREATE TABLE carga_familiar (
 numrut_carga  NUMBER(10) NOT NULL CONSTRAINT PK_CARGA_FAMILIAR PRIMARY KEY,
 dvrut_carga  VARCHAR2(1) NOT NULL,
 appaterno_carga VARCHAR2(15) NOT NULL,
 apmaterno_carga VARCHAR2(15) NOT NULL,
 nombre_carga VARCHAR2(25) NOT NULL,
 id_vendedor NUMBER(10) NOT NULL,
 CONSTRAINT FK_carga_familiar_vendedor FOREIGN KEY (id_vendedor) REFERENCES vendedor (id_vendedor)); 

--------------------------------------------------------
--  DDL for Table comis_vtas
--------------------------------------------------------
CREATE TABLE comision_venta (
  anno NUMBER(4) NOT NULL,
  mes NUMBER(2) NOT NULL,   
  id_vendedor VARCHAR2(10), 
  total_ventas NUMBER(8), 
  monto_comision NUMBER(8),
  CONSTRAINT pk_comisvtas PRIMARY KEY (anno, mes, id_vendedor)
);

--------------------------------------------------------
--  DDL for Table afp
--------------------------------------------------------
CREATE TABLE afp (
 id_afp NUMBER(2) CONSTRAINT pk_afp PRIMARY KEY,
 nombre_afp  VARCHAR2(30) NOT NULL,
 porc_descto_afp NUMBER(2) NOT NULL
);

--------------------------------------------------------
--  DDL for Table salud
--------------------------------------------------------
CREATE TABLE salud (
 id_salud NUMBER(2) CONSTRAINT pk_salud PRIMARY KEY,
 nombre_salud  VARCHAR2(30) NOT NULL,
 porc_descto_salud NUMBER(2) NOT NULL
);

--------------------------------------------------------
--  DDL for Table bonificacion_antig
--------------------------------------------------------
CREATE TABLE bonificacion_antig (
 id_bonif NUMBER(2) CONSTRAINT pk_annos_trabajados PRIMARY KEY,
 antig_inf     NUMBER(2) NOT NULL,
 antig_sup     NUMBER(2) NOT NULL,
 porc_bonif    NUMBER(2) NOT NULL
);

--------------------------------------------------------
--  DDL for Table haber_mes_vendedor
--------------------------------------------------------
CREATE TABLE haber_mes_vendedor (
 id_vendedor NUMBER(8) NOT NULL, 
 numrut_vendedor NUMBER(10) NOT NULL,
 mes_proceso NUMBER(2) NOT NULL,
 anno_proceso NUMBER(4) NOT NULL,
 sueldo_base NUMBER(8) NOT NULL,
 asig_antiguedad NUMBER(8) NOT NULL,
 asig_cargas NUMBER(8) NOT NULL,
 comisiones NUMBER(8) NOT NULL,
 bono_categ NUMBER(8) NOT NULL,
 bono_grupos NUMBER(8) NOT NULL,
 descuentos NUMBER(8) NOT NULL,
 total_haberes NUMBER(8) NOT NULL,
 CONSTRAINT pk_haber_calc_mes PRIMARY KEY (id_vendedor,mes_proceso,anno_proceso),
 CONSTRAINT fk_haber_calc_vendedor FOREIGN KEY(id_vendedor) REFERENCES vendedor (id_vendedor)
);

--------------------------------------------------------
--  DDL for Table descuento_mes_vendedor
--------------------------------------------------------
CREATE TABLE descuento_mes_vendedor (
 id_vendedor NUMBER(8) NOT NULL, 
 numrut_vendedor NUMBER(10) NOT NULL,
 mes_proceso NUMBER(2) NOT NULL,
 anno_proceso NUMBER(4) NOT NULL,
 valor_salud NUMBER(8) NOT NULL,
 valor_afp NUMBER(8) NOT NULL,
 CONSTRAINT pk_descto_calc_mes PRIMARY KEY (id_vendedor,mes_proceso,anno_proceso),
 CONSTRAINT fk_descto_calc_vendedor FOREIGN KEY (id_vendedor) REFERENCES vendedor (id_vendedor)
);


ALTER TABLE venta 
	 ADD CONSTRAINT fk_cliente FOREIGN KEY (id_cliente)
	  REFERENCES cliente (id_cliente);

ALTER TABLE venta 
	 ADD CONSTRAINT fk_vendedor FOREIGN KEY (id_vendedor)
	  REFERENCES vendedor(id_vendedor);
  
ALTER TABLE vendedor 
  ADD CONSTRAINT fk_vendedor_categoria FOREIGN KEY (id_categoria) 
   REFERENCES categoria (id_categoria);

ALTER TABLE detalleventa 
	ADD CONSTRAINT fk_detventa_venta FOREIGN KEY (id_venta)
	  REFERENCES venta (id_venta);

ALTER TABLE detalleventa 
	ADD CONSTRAINT fk_detventa_articulo FOREIGN KEY (id_articulo)
	  REFERENCES articulo (id_articulo);

ALTER TABLE anticipo 
  ADD CONSTRAINT fk_anticipo_vendedor FOREIGN KEY (id_vendedor)
  REFERENCES vendedor (id_vendedor);

ALTER TABLE vendedor
  ADD CONSTRAINT fk_vendedor_afp FOREIGN KEY (id_afp) 
  REFERENCES afp (id_afp);

ALTER TABLE vendedor
  ADD CONSTRAINT fk_vendedor_salud FOREIGN KEY (id_salud) 
  REFERENCES salud (id_salud);

-- insercion de datos  
INSERT INTO afp VALUES(1,'CAPITAL',10);
INSERT INTO afp VALUES(2,'CUPRUM',12);
INSERT INTO afp VALUES(3,'HABITAT',14);
INSERT INTO afp VALUES(4,'MODELO',8);
INSERT INTO afp VALUES(5,'PLANVITAL',15);
INSERT INTO afp VALUES(6,'PROVIDA',13);

INSERT INTO salud VALUES(1,'FONASA',7);
INSERT INTO salud VALUES(2,'BAN MEDICA',10);
INSERT INTO salud VALUES(3,'COLMENA',9);
INSERT INTO salud VALUES(4,'CONSALUD',12);
INSERT INTO salud VALUES(5,'CRUZ BLANCA',15);
INSERT INTO salud VALUES(6,'MASVIDA',9);
INSERT INTO salud VALUES(7,'VIDA TRES',11);

INSERT INTO categoria VALUES ('A','Categoria A', 15.4);
INSERT INTO categoria VALUES ('B','Categoria B', 12.3);
INSERT INTO categoria VALUES ('C','Categoria C', 11.5);


INSERT INTO cliente VALUES (1,'ALCARAZ NOVOA MONTSERRAT','RUBEN BARRALES 1630','LO BARNECHEA','564522114');
INSERT INTO cliente VALUES (2,'JIMÉNEZ LORCA ELENA','AV. BUSTAMANTE 529 DPTO K','PROVIDENCIA','566665443');
INSERT INTO cliente VALUES (3,'TORRES ROCA MARÍA','DONATELLO 7421','LAS CONDES','565626134');
INSERT INTO cliente VALUES (4,'LOPEZ ROJAS THOMAS','JOSE MANUEL INFANTE 2007','PROVIDENCIA','562989233');
INSERT INTO cliente VALUES (5,'ZAMORA MOLINA TOMÁS','HUERFANOS 1294 OF.45','SANTIAGO','564343456');
INSERT INTO cliente VALUES (6,'GALLO LÓPEZ GONZALO','ESCRIBA DE BALAGUER 5584','VITACURA','562334533');
INSERT INTO cliente VALUES (7,'VIVEROS MIRANDA ELIZABETH','MATEO TORO Y ZAMBRANO 1395 D12','LA REINA','567019232');
INSERT INTO cliente VALUES (8,'LAMONT ORTEGA OLIVIA','LAS MALVAS 517','LAS CONDES','564197043');
INSERT INTO cliente VALUES (9,'SEVILLANO MORENO LUISA','EL NOGAL 11','LO BARNECHEA','566675321');
INSERT INTO cliente VALUES (10,'CHÁVEZ CARDENAS TERRY','SANTANDER 33','CONCHALI','566485222');

INSERT INTO articulo VALUES (1,'JABON','FAMILAND',NULL,1250,150);
INSERT INTO articulo VALUES (2,'SHAMPOO','DOVE',NULL,2325,50);
INSERT INTO articulo VALUES (3,'ACONDICIONADOR','DOVE',NULL,2100,200);
INSERT INTO articulo VALUES (4,'CREMA DE AFEITAR','GILLETE',NULL,3475,50);
INSERT INTO articulo VALUES (5,'TOALLAS HUMEDAS','PLENITUD',NULL,2400,80);
INSERT INTO articulo VALUES (6,'DESODORANTE','NIVEA',NULL,2510,200);
INSERT INTO articulo VALUES (7,'CREMA DENTAL','COLGATE',NULL,950,60);
INSERT INTO articulo VALUES (8,'HILO DENTAL','COLGATE',NULL,1410,35);
INSERT INTO articulo VALUES (9,'ENJUAGUE BUCAL','VITIS',NULL,2750,300);
INSERT INTO articulo VALUES (10,'CAFE','MONTERREY',NULL,3500,80);
INSERT INTO articulo VALUES (11,'CERVEZA','CORONA',NULL,1850,200);
INSERT INTO articulo VALUES (12,'JUGO DE FRUTAS','ANDINA',NULL,1610,200);
INSERT INTO articulo VALUES (13,'TE','LIPTON',NULL,2850,250);
INSERT INTO articulo VALUES (14,'VINO','CONCHA Y TORO',NULL,2493,240);
INSERT INTO articulo VALUES (15,'PESCADO CONGELADO','MARES DEL SUR',NULL,3500,10);

INSERT INTO vendedor VALUES (10,'11111112','MARIA','RIVERA','22051963','16041985','A','A',350000,1,1);
INSERT INTO vendedor VALUES (20,'22222223','JEREMIAS','LORCA','07081978','02072000','B','B',345000,2,1);
INSERT INTO vendedor VALUES (30,'33333334','NORMA','BAÑADOS','09101979','03092001','A','A',367400,3,1);
INSERT INTO vendedor VALUES (40,'44444445','FEDERICO','CASTAÑEDA','08121977','03111999','B','C',373620,4,3);
INSERT INTO vendedor VALUES (50,'55555556','ADRIANA','LAGOS','08051990','02042008','B','C',359000,4,5);
INSERT INTO vendedor VALUES (60,'66666667','OLGA','CAJAS','07121985','02112007','B','C',346372,5,6);
INSERT INTO vendedor VALUES (70,'77777778','HUMBERTO','ORREGO','05101975','30081997','B','A',354000,1,7);
INSERT INTO vendedor VALUES (80,'88888889','CARLOS','ORTEGA','12031980','05022002','C','A',353504,6,2);
INSERT INTO vendedor VALUES (90,'99999991','DAVID','ARAYA','04031976','28011998','C','C',338934,2,3);
INSERT INTO vendedor VALUES (100,'101111112','DOMITILA','PAREDES','11101977','06091999','C','A',338432,4,5);
INSERT INTO vendedor VALUES (110,'111111113','ELIZABETH','MIRANDA','12021974','08011996','C','A',348232,3,1);
INSERT INTO vendedor VALUES (120,'121111114','ROLANDO','GUERRA','22011978','18121999','D','B',356734,2,6);
INSERT INTO vendedor VALUES (130,'131111115','HERNALDO','CACERES','18111981','14102003','D','B',364832,5,2);
INSERT INTO vendedor VALUES (140,'141111116','ROBERTO','SALAS','21081984','17072006','D','A',378484,1,1);
INSERT INTO vendedor VALUES (150,'151111117','PAZ','GUERRA','21071983','17062005','A','B',478584,2,7);

INSERT INTO anticipo VALUES(10,1,12987);
INSERT INTO anticipo VALUES(10,2,15817);
INSERT INTO anticipo VALUES(10,3,26594);
INSERT INTO anticipo VALUES(10,4,18768);
INSERT INTO anticipo VALUES(20,3,18144);
INSERT INTO anticipo VALUES(20,4,15776);
INSERT INTO anticipo VALUES(20,5,26487);
INSERT INTO anticipo VALUES(30,4,29120);
INSERT INTO anticipo VALUES(30,5,10144);
INSERT INTO anticipo VALUES(30,2,10218);
INSERT INTO anticipo VALUES(30,1,22652);
INSERT INTO anticipo VALUES(40,3,12763);
INSERT INTO anticipo VALUES(40,4,21889);
INSERT INTO anticipo VALUES(40,5,20840);
INSERT INTO anticipo VALUES(50,2,14188);
INSERT INTO anticipo VALUES(50,3,13293);
INSERT INTO anticipo VALUES(50,4,15675);
INSERT INTO anticipo VALUES(60,3,17024);
INSERT INTO anticipo VALUES(60,4,24602);
INSERT INTO anticipo VALUES(70,2,25751);
INSERT INTO anticipo VALUES(70,3,22452);
INSERT INTO anticipo VALUES(70,4,17357);
INSERT INTO anticipo VALUES(80,4,28057);
INSERT INTO anticipo VALUES(90,4,14080);
INSERT INTO anticipo VALUES(100,4,28295);
INSERT INTO anticipo VALUES(110,2,17301);
INSERT INTO anticipo VALUES(110,3,18434);
INSERT INTO anticipo VALUES(110,4,15867);
INSERT INTO anticipo VALUES(120,2,28169);
INSERT INTO anticipo VALUES(120,3,15308);
INSERT INTO anticipo VALUES(120,4,29625);
INSERT INTO anticipo VALUES(130,2,16431);
INSERT INTO anticipo VALUES(130,3,25139);
INSERT INTO anticipo VALUES(130,4,16291);
INSERT INTO anticipo VALUES(130,5,11611);
INSERT INTO anticipo VALUES(140,4,27999);
INSERT INTO anticipo VALUES(150,3,29132);
INSERT INTO anticipo VALUES(150,4,27191);

INSERT INTO bonificacion_antig VALUES(1,1,9,4);
INSERT INTO bonificacion_antig VALUES(2,10,12,6);
INSERT INTO bonificacion_antig VALUES(3,13,16,7);
INSERT INTO bonificacion_antig VALUES(4,17,30,10);
INSERT INTO bonificacion_antig VALUES(5,31,40,15);
INSERT INTO bonificacion_antig VALUES(6,41,50,18);

INSERT INTO venta VALUES (1,3,70,'26/04/2021');
INSERT INTO venta VALUES (2,7,130,'27/04/2021');
INSERT INTO venta VALUES (3,8,30,'27/04/2021');
INSERT INTO venta VALUES (4,2,110,'27/04/2021');
INSERT INTO venta VALUES (5,2,130,'27/04/2021');
INSERT INTO venta VALUES (6,9,70,'28/04/2021');
INSERT INTO venta VALUES (7,9,110,'28/04/2021');
INSERT INTO venta VALUES (8,5,10,'28/04/2021');
INSERT INTO venta VALUES (9,4,70,'28/04/2021');
INSERT INTO venta VALUES (10,4,70,'29/04/2021');
INSERT INTO venta VALUES (11,5,30,'29/04/2021');
INSERT INTO venta VALUES (12,4,110,'29/04/2021');
INSERT INTO venta VALUES (13,5,30,'29/04/2021');
INSERT INTO venta VALUES (14,3,30,'29/04/2021');
INSERT INTO venta VALUES (15,2,30,'29/04/2021');
INSERT INTO venta VALUES (16,3,40,'30/04/2021');
INSERT INTO venta VALUES (17,6,80,'30/04/2021');
INSERT INTO venta VALUES (18,6,20,'30/04/2021');
INSERT INTO venta VALUES (19,9,60,'01/05/2021');
INSERT INTO venta VALUES (20,2,70,'01/05/2021');
INSERT INTO venta VALUES (21,6,60,'01/05/2021');
INSERT INTO venta VALUES (22,3,30,'02/05/2021');
INSERT INTO venta VALUES (23,8,30,'02/05/2021');
INSERT INTO venta VALUES (24,1,30,'02/05/2021');
INSERT INTO venta VALUES (25,4,40,'03/05/2021');
INSERT INTO venta VALUES (26,9,60,'03/05/2021');
INSERT INTO venta VALUES (27,8,110,'04/05/2021');
INSERT INTO venta VALUES (28,9,110,'04/05/2021');
INSERT INTO venta VALUES (29,1,60,'05/05/2021');
INSERT INTO venta VALUES (30,7,60,'05/05/2021');
INSERT INTO venta VALUES (31,6,100,'06/05/2021');
INSERT INTO venta VALUES (32,5,100,'06/05/2021');
INSERT INTO venta VALUES (33,2,100,'06/05/2021');
INSERT INTO venta VALUES (34,5,110,'07/05/2021');
INSERT INTO venta VALUES (35,8,110,'07/05/2021');
INSERT INTO venta VALUES (36,1,110,'07/05/2021');
INSERT INTO venta VALUES (37,3,80,'08/05/2021');
INSERT INTO venta VALUES (38,6,80,'08/05/2021');
INSERT INTO venta VALUES (39,2,80,'08/05/2021');
INSERT INTO venta VALUES (40,4,20,'08/05/2021');
INSERT INTO venta VALUES (41,6,130,'09/05/2021');
INSERT INTO venta VALUES (42,1,20,'09/05/2021');
INSERT INTO venta VALUES (43,3,40,'09/05/2021');
INSERT INTO venta VALUES (44,1,130,'10/05/2021');
INSERT INTO venta VALUES (45,4,110,'10/05/2021');
INSERT INTO venta VALUES (46,6,110,'12/05/2021');
INSERT INTO venta VALUES (47,2,60,'13/05/2021');
INSERT INTO venta VALUES (48,7,60,'13/05/2021');
INSERT INTO venta VALUES (49,9,60,'13/05/2021');
INSERT INTO venta VALUES (50,6,60,'14/05/2021');
INSERT INTO venta VALUES (51,7,10,'14/05/2021');
INSERT INTO venta VALUES (52,8,10,'15/05/2021');
INSERT INTO venta VALUES (53,1,130,'16/05/2021');
INSERT INTO venta VALUES (54,4,30,'16/05/2021');
INSERT INTO venta VALUES (55,3,100,'16/05/2021');
INSERT INTO venta VALUES (56,6,20,'17/05/2021');
INSERT INTO venta VALUES (57,9,20,'17/05/2021');
INSERT INTO venta VALUES (58,6,20,'17/05/2021');
INSERT INTO venta VALUES (59,4,50,'18/05/2021');
INSERT INTO venta VALUES (60,9,50,'18/05/2021');
INSERT INTO venta VALUES (61,9,50,'18/05/2021');
INSERT INTO venta VALUES (62,9,50,'18/05/2021');
INSERT INTO venta VALUES (63,8,10,'19/05/2021');
INSERT INTO venta VALUES (64,6,130,'19/05/2021');
INSERT INTO venta VALUES (65,5,130,'19/05/2021');
INSERT INTO venta VALUES (66,7,130,'19/05/2021');
INSERT INTO venta VALUES (67,4,80,'19/05/2021');
INSERT INTO venta VALUES (68,2,20,'20/05/2021');
INSERT INTO venta VALUES (69,8,20,'20/05/2021');
INSERT INTO venta VALUES (70,4,20,'20/05/2021');
INSERT INTO venta VALUES (71,8,20,'20/05/2021');
INSERT INTO venta VALUES (72,9,80,'20/05/2021');
INSERT INTO venta VALUES (73,8,10,'21/05/2021');
INSERT INTO venta VALUES (74,1,90,'22/05/2021');
INSERT INTO venta VALUES (75,7,80,'22/05/2021');
INSERT INTO venta VALUES (76,6,80,'22/05/2021');
INSERT INTO venta VALUES (77,8,80,'22/05/2021');
INSERT INTO venta VALUES (78,6,70,'23/05/2021');
INSERT INTO venta VALUES (79,3,90,'23/05/2021');
INSERT INTO venta VALUES (80,2,20,'23/05/2021');
INSERT INTO venta VALUES (81,9,80,'24/05/2021');
INSERT INTO venta VALUES (82,8,90,'24/05/2021');
INSERT INTO venta VALUES (83,6,50,'24/05/2021');
INSERT INTO venta VALUES (84,8,40,'25/05/2021');
INSERT INTO venta VALUES (85,3,10,'25/05/2021');
INSERT INTO venta VALUES (86,1,80,'25/05/2021');
INSERT INTO venta VALUES (87,1,110,'26/05/2021');
INSERT INTO venta VALUES (88,2,100,'26/05/2021');
INSERT INTO venta VALUES (89,1,50,'26/05/2021');
INSERT INTO venta VALUES (90,1,20,'26/05/2021');
INSERT INTO venta VALUES (91,1,90,'26/05/2021');
INSERT INTO venta VALUES (92,1,70,'26/05/2021');
INSERT INTO venta VALUES (93,7,110,'27/05/2021');
INSERT INTO venta VALUES (94,2,120,'27/05/2021');
INSERT INTO venta VALUES (95,6,110,'27/05/2021');
INSERT INTO venta VALUES (96,2,40,'27/05/2021');
INSERT INTO venta VALUES (97,4,90,'27/05/2021');
INSERT INTO venta VALUES (98,7,50,'27/05/2021');
INSERT INTO venta VALUES (99,9,40,'28/05/2021');
INSERT INTO venta VALUES (100,7,50,'28/05/2021');
INSERT INTO venta VALUES (101,3,120,'28/05/2021');
INSERT INTO venta VALUES (102,4,90,'28/05/2021');
INSERT INTO venta VALUES (103,2,130,'29/05/2021');
INSERT INTO venta VALUES (104,7,60,'29/05/2021');
INSERT INTO venta VALUES (105,3,40,'30/05/2021');
INSERT INTO venta VALUES (106,1,20,'30/05/2021');
INSERT INTO venta VALUES (107,9,30,'31/05/2021');
INSERT INTO venta VALUES (108,7,20,'01/06/2021');
INSERT INTO venta VALUES (109,4,80,'01/06/2021');
INSERT INTO venta VALUES (110,9,70,'01/06/2021');
INSERT INTO venta VALUES (111,9,130,'01/06/2021');
INSERT INTO venta VALUES (112,6,30,'01/06/2021');
INSERT INTO venta VALUES (113,5,30,'02/06/2021');
INSERT INTO venta VALUES (114,9,30,'02/06/2021');
INSERT INTO venta VALUES (115,3,120,'02/06/2021');
INSERT INTO venta VALUES (116,9,100,'02/06/2021');
INSERT INTO venta VALUES (117,9,40,'04/06/2021');
INSERT INTO venta VALUES (118,3,90,'05/06/2021');
INSERT INTO venta VALUES (119,5,60,'05/06/2021');
INSERT INTO venta VALUES (120,5,60,'06/06/2021');

INSERT INTO detalleventa VALUES (1,1,10);
INSERT INTO detalleventa VALUES (1,5,33);
INSERT INTO detalleventa VALUES (1,13,88);
INSERT INTO detalleventa VALUES (2,3,33);
INSERT INTO detalleventa VALUES (2,10,90);
INSERT INTO detalleventa VALUES (3,4,200);
INSERT INTO detalleventa VALUES (3,11,500);
INSERT INTO detalleventa VALUES (4,5,500);
INSERT INTO detalleventa VALUES (4,6,250);
INSERT INTO detalleventa VALUES (4,7,300);
INSERT INTO detalleventa VALUES (5,1,196);
INSERT INTO detalleventa VALUES (5,6,128);
INSERT INTO detalleventa VALUES (5,12,181);
INSERT INTO detalleventa VALUES (6,10,283);
INSERT INTO detalleventa VALUES (6,11,41);
INSERT INTO detalleventa VALUES (7,12,84);
INSERT INTO detalleventa VALUES (8,2,198);
INSERT INTO detalleventa VALUES (9,9,79);
INSERT INTO detalleventa VALUES (10,13,200);
INSERT INTO detalleventa VALUES (11,8,183);
INSERT INTO detalleventa VALUES (12,10,239);
INSERT INTO detalleventa VALUES (12,15,52);
INSERT INTO detalleventa VALUES (12,4,248);
INSERT INTO detalleventa VALUES (13,9,152);
INSERT INTO detalleventa VALUES (14,14,283);
INSERT INTO detalleventa VALUES (14,13,285);
INSERT INTO detalleventa VALUES (15,1,170);
INSERT INTO detalleventa VALUES (15,9,63);
INSERT INTO detalleventa VALUES (15,2,137);
INSERT INTO detalleventa VALUES (15,3,151);
INSERT INTO detalleventa VALUES (17,6,117);
INSERT INTO detalleventa VALUES (17,4,203);
INSERT INTO detalleventa VALUES (18,8,283);
INSERT INTO detalleventa VALUES (19,7,255);
INSERT INTO detalleventa VALUES (20,15,272);
INSERT INTO detalleventa VALUES (20,9,242);
INSERT INTO detalleventa VALUES (20,12,67);
INSERT INTO detalleventa VALUES (20,8,157);
INSERT INTO detalleventa VALUES (20,13,37);
INSERT INTO detalleventa VALUES (20,14,29);
INSERT INTO detalleventa VALUES (20,2,26);
INSERT INTO detalleventa VALUES (21,7,94);
INSERT INTO detalleventa VALUES (21,4,24);
INSERT INTO detalleventa VALUES (21,1,247);
INSERT INTO detalleventa VALUES (21,8,226);
INSERT INTO detalleventa VALUES (22,8,116);
INSERT INTO detalleventa VALUES (22,11,250);
INSERT INTO detalleventa VALUES (22,13,98);
INSERT INTO detalleventa VALUES (22,7,194);
INSERT INTO detalleventa VALUES (23,10,205);
INSERT INTO detalleventa VALUES (23,8,101);
INSERT INTO detalleventa VALUES (24,3,40);
INSERT INTO detalleventa VALUES (24,15,282);
INSERT INTO detalleventa VALUES (24,7,206);
INSERT INTO detalleventa VALUES (24,2,95);
INSERT INTO detalleventa VALUES (25,2,271);
INSERT INTO detalleventa VALUES (25,5,34);
INSERT INTO detalleventa VALUES (25,6,47);
INSERT INTO detalleventa VALUES (25,7,206);
INSERT INTO detalleventa VALUES (25,8,184);
INSERT INTO detalleventa VALUES (25,3,92);
INSERT INTO detalleventa VALUES (25,15,122);
INSERT INTO detalleventa VALUES (26,3,32);
INSERT INTO detalleventa VALUES (26,5,20);
INSERT INTO detalleventa VALUES (27,7,105);
INSERT INTO detalleventa VALUES (27,9,105);
INSERT INTO detalleventa VALUES (27,8,115);
INSERT INTO detalleventa VALUES (27,15,128);
INSERT INTO detalleventa VALUES (27,12,134);
INSERT INTO detalleventa VALUES (28,1,284);
INSERT INTO detalleventa VALUES (29,9,29);
INSERT INTO detalleventa VALUES (29,10,27);
INSERT INTO detalleventa VALUES (29,15,139);
INSERT INTO detalleventa VALUES (29,8,109);
INSERT INTO detalleventa VALUES (30,2,228);
INSERT INTO detalleventa VALUES (30,7,133);
INSERT INTO detalleventa VALUES (30,9,289);
INSERT INTO detalleventa VALUES (30,14,75);
INSERT INTO detalleventa VALUES (31,4,221);
INSERT INTO detalleventa VALUES (31,11,189);
INSERT INTO detalleventa VALUES (32,8,231);
INSERT INTO detalleventa VALUES (32,6,120);
INSERT INTO detalleventa VALUES (33,1,78);
INSERT INTO detalleventa VALUES (33,15,160);
INSERT INTO detalleventa VALUES (34,13,230);
INSERT INTO detalleventa VALUES (35,7,253);
INSERT INTO detalleventa VALUES (35,8,192);
INSERT INTO detalleventa VALUES (36,7,32);
INSERT INTO detalleventa VALUES (36,10,138);
INSERT INTO detalleventa VALUES (36,1,97);
INSERT INTO detalleventa VALUES (37,1,73);
INSERT INTO detalleventa VALUES (38,1,279);
INSERT INTO detalleventa VALUES (38,5,198);
INSERT INTO detalleventa VALUES (38,9,173);
INSERT INTO detalleventa VALUES (38,10,86);
INSERT INTO detalleventa VALUES (39,12,165);
INSERT INTO detalleventa VALUES (40,12,100);
INSERT INTO detalleventa VALUES (40,6,265);
INSERT INTO detalleventa VALUES (40,7,257);
INSERT INTO detalleventa VALUES (41,2,100);
INSERT INTO detalleventa VALUES (41,8,154);
INSERT INTO detalleventa VALUES (41,14,250);
INSERT INTO detalleventa VALUES (41,1,77);
INSERT INTO detalleventa VALUES (42,1,51);
INSERT INTO detalleventa VALUES (42,14,75);
INSERT INTO detalleventa VALUES (42,10,81);
INSERT INTO detalleventa VALUES (42,13,64);
INSERT INTO detalleventa VALUES (43,15,52);
INSERT INTO detalleventa VALUES (43,9,27);
INSERT INTO detalleventa VALUES (43,12,298);
INSERT INTO detalleventa VALUES (43,1,198);
INSERT INTO detalleventa VALUES (43,11,45);
INSERT INTO detalleventa VALUES (44,6,126);
INSERT INTO detalleventa VALUES (44,7,206);
INSERT INTO detalleventa VALUES (44,8,117);
INSERT INTO detalleventa VALUES (44,15,146);
INSERT INTO detalleventa VALUES (44,13,260);
INSERT INTO detalleventa VALUES (44,14,244);
INSERT INTO detalleventa VALUES (45,1,242);
INSERT INTO detalleventa VALUES (45,7,258);
INSERT INTO detalleventa VALUES (45,4,274);
INSERT INTO detalleventa VALUES (45,9,105);
INSERT INTO detalleventa VALUES (45,10,188);
INSERT INTO detalleventa VALUES (46,9,138);
INSERT INTO detalleventa VALUES (46,3,64);
INSERT INTO detalleventa VALUES (47,12,28);
INSERT INTO detalleventa VALUES (47,5,146);
INSERT INTO detalleventa VALUES (47,13,245);
INSERT INTO detalleventa VALUES (48,6,236);
INSERT INTO detalleventa VALUES (49,14,206);
INSERT INTO detalleventa VALUES (49,7,167);
INSERT INTO detalleventa VALUES (49,6,154);
INSERT INTO detalleventa VALUES (49,8,282);
INSERT INTO detalleventa VALUES (50,1,210);
INSERT INTO detalleventa VALUES (50,2,223);
INSERT INTO detalleventa VALUES (50,3,147);
INSERT INTO detalleventa VALUES (50,5,25);
INSERT INTO detalleventa VALUES (50,8,53);
INSERT INTO detalleventa VALUES (50,10,157);
INSERT INTO detalleventa VALUES (51,12,170);
INSERT INTO detalleventa VALUES (51,13,52);
INSERT INTO detalleventa VALUES (51,1,164);
INSERT INTO detalleventa VALUES (52,10,130);
INSERT INTO detalleventa VALUES (52,1,95);
INSERT INTO detalleventa VALUES (52,2,264);
INSERT INTO detalleventa VALUES (52,8,115);
INSERT INTO detalleventa VALUES (53,11,46);
INSERT INTO detalleventa VALUES (53,4,281);
INSERT INTO detalleventa VALUES (54,1,167);
INSERT INTO detalleventa VALUES (54,2,263);
INSERT INTO detalleventa VALUES (54,3,62);
INSERT INTO detalleventa VALUES (54,4,267);
INSERT INTO detalleventa VALUES (54,12,78);
INSERT INTO detalleventa VALUES (55,8,256);
INSERT INTO detalleventa VALUES (56,12,191);
INSERT INTO detalleventa VALUES (56,6,230);
INSERT INTO detalleventa VALUES (56,1,89);
INSERT INTO detalleventa VALUES (56,8,140);
INSERT INTO detalleventa VALUES (57,12,164);
INSERT INTO detalleventa VALUES (57,10,70);
INSERT INTO detalleventa VALUES (57,8,20);
INSERT INTO detalleventa VALUES (58,11,144);
INSERT INTO detalleventa VALUES (58,3,157);
INSERT INTO detalleventa VALUES (58,7,226);
INSERT INTO detalleventa VALUES (58,4,228);
INSERT INTO detalleventa VALUES (58,5,148);
INSERT INTO detalleventa VALUES (58,1,284);
INSERT INTO detalleventa VALUES (59,10,256);
INSERT INTO detalleventa VALUES (59,11,255);
INSERT INTO detalleventa VALUES (59,15,59);
INSERT INTO detalleventa VALUES (59,8,260);
INSERT INTO detalleventa VALUES (59,4,126);
INSERT INTO detalleventa VALUES (59,5,173);
INSERT INTO detalleventa VALUES (59,2,90);
INSERT INTO detalleventa VALUES (59,1,170);
INSERT INTO detalleventa VALUES (60,4,214);
INSERT INTO detalleventa VALUES (60,10,104);
INSERT INTO detalleventa VALUES (60,6,163);
INSERT INTO detalleventa VALUES (60,2,172);
INSERT INTO detalleventa VALUES (61,2,51);
INSERT INTO detalleventa VALUES (61,4,274);
INSERT INTO detalleventa VALUES (61,12,174);
INSERT INTO detalleventa VALUES (61,7,145);
INSERT INTO detalleventa VALUES (61,10,278);
INSERT INTO detalleventa VALUES (61,5,126);
INSERT INTO detalleventa VALUES (61,8,57);
INSERT INTO detalleventa VALUES (62,7,46);
INSERT INTO detalleventa VALUES (62,5,175);
INSERT INTO detalleventa VALUES (62,13,203);
INSERT INTO detalleventa VALUES (63,11,275);
INSERT INTO detalleventa VALUES (63,15,212);
INSERT INTO detalleventa VALUES (64,6,83);
INSERT INTO detalleventa VALUES (64,2,29);
INSERT INTO detalleventa VALUES (64,8,252);
INSERT INTO detalleventa VALUES (64,1,253);
INSERT INTO detalleventa VALUES (65,6,206);
INSERT INTO detalleventa VALUES (65,3,102);
INSERT INTO detalleventa VALUES (65,15,201);
INSERT INTO detalleventa VALUES (66,7,59);
INSERT INTO detalleventa VALUES (66,15,294);
INSERT INTO detalleventa VALUES (66,3,267);
INSERT INTO detalleventa VALUES (66,9,295);
INSERT INTO detalleventa VALUES (66,4,173);
INSERT INTO detalleventa VALUES (67,7,217);
INSERT INTO detalleventa VALUES (67,1,29);
INSERT INTO detalleventa VALUES (67,14,124);
INSERT INTO detalleventa VALUES (67,2,278);
INSERT INTO detalleventa VALUES (67,3,272);
INSERT INTO detalleventa VALUES (68,11,159);
INSERT INTO detalleventa VALUES (68,9,286);
INSERT INTO detalleventa VALUES (68,15,135);
INSERT INTO detalleventa VALUES (69,4,173);
INSERT INTO detalleventa VALUES (69,15,128);
INSERT INTO detalleventa VALUES (69,9,63);
INSERT INTO detalleventa VALUES (69,7,243);
INSERT INTO detalleventa VALUES (70,6,108);
INSERT INTO detalleventa VALUES (70,5,291);
INSERT INTO detalleventa VALUES (71,14,110);
INSERT INTO detalleventa VALUES (71,10,180);
INSERT INTO detalleventa VALUES (72,14,104);
INSERT INTO detalleventa VALUES (72,3,59);
INSERT INTO detalleventa VALUES (72,13,106);
INSERT INTO detalleventa VALUES (73,4,174);
INSERT INTO detalleventa VALUES (73,10,20);
INSERT INTO detalleventa VALUES (74,13,229);
INSERT INTO detalleventa VALUES (74,11,233);
INSERT INTO detalleventa VALUES (75,10,211);
INSERT INTO detalleventa VALUES (75,7,202);
INSERT INTO detalleventa VALUES (75,1,202);
INSERT INTO detalleventa VALUES (75,12,72);
INSERT INTO detalleventa VALUES (75,8,287);
INSERT INTO detalleventa VALUES (76,1,185);
INSERT INTO detalleventa VALUES (77,2,272);
INSERT INTO detalleventa VALUES (77,6,111);
INSERT INTO detalleventa VALUES (77,12,81);
INSERT INTO detalleventa VALUES (77,13,183);
INSERT INTO detalleventa VALUES (77,10,168);
INSERT INTO detalleventa VALUES (78,1,244);
INSERT INTO detalleventa VALUES (78,8,108);
INSERT INTO detalleventa VALUES (78,11,252);
INSERT INTO detalleventa VALUES (79,1,167);
INSERT INTO detalleventa VALUES (79,13,124);
INSERT INTO detalleventa VALUES (79,12,149);
INSERT INTO detalleventa VALUES (79,15,280);
INSERT INTO detalleventa VALUES (79,8,209);
INSERT INTO detalleventa VALUES (80,10,203);
INSERT INTO detalleventa VALUES (80,6,20);
INSERT INTO detalleventa VALUES (80,4,120);
INSERT INTO detalleventa VALUES (80,7,62);
INSERT INTO detalleventa VALUES (80,9,214);
INSERT INTO detalleventa VALUES (81,12,78);
INSERT INTO detalleventa VALUES (81,5,48);
INSERT INTO detalleventa VALUES (81,6,268);
INSERT INTO detalleventa VALUES (81,1,287);
INSERT INTO detalleventa VALUES (81,9,36);
INSERT INTO detalleventa VALUES (82,10,202);
INSERT INTO detalleventa VALUES (82,12,231);
INSERT INTO detalleventa VALUES (82,9,161);
INSERT INTO detalleventa VALUES (82,13,38);
INSERT INTO detalleventa VALUES (83,12,21);
INSERT INTO detalleventa VALUES (83,10,69);
INSERT INTO detalleventa VALUES (84,14,65);
INSERT INTO detalleventa VALUES (84,3,272);
INSERT INTO detalleventa VALUES (84,12,148);
INSERT INTO detalleventa VALUES (84,13,160);
INSERT INTO detalleventa VALUES (84,11,250);
INSERT INTO detalleventa VALUES (84,1,260);
INSERT INTO detalleventa VALUES (85,8,107);
INSERT INTO detalleventa VALUES (85,1,192);
INSERT INTO detalleventa VALUES (86,6,293);
INSERT INTO detalleventa VALUES (86,10,215);
INSERT INTO detalleventa VALUES (87,14,297);
INSERT INTO detalleventa VALUES (87,13,62);
INSERT INTO detalleventa VALUES (88,10,147);
INSERT INTO detalleventa VALUES (88,11,187);
INSERT INTO detalleventa VALUES (88,12,215);
INSERT INTO detalleventa VALUES (88,13,280);
INSERT INTO detalleventa VALUES (89,2,51);
INSERT INTO detalleventa VALUES (90,10,61);
INSERT INTO detalleventa VALUES (90,1,178);
INSERT INTO detalleventa VALUES (90,2,239);
INSERT INTO detalleventa VALUES (91,9,30);
INSERT INTO detalleventa VALUES (92,8,205);
INSERT INTO detalleventa VALUES (92,12,256);
INSERT INTO detalleventa VALUES (93,4,42);
INSERT INTO detalleventa VALUES (94,1,26);
INSERT INTO detalleventa VALUES (94,3,264);
INSERT INTO detalleventa VALUES (94,10,295);
INSERT INTO detalleventa VALUES (94,4,102);
INSERT INTO detalleventa VALUES (95,1,70);
INSERT INTO detalleventa VALUES (95,9,106);
INSERT INTO detalleventa VALUES (95,6,99);
INSERT INTO detalleventa VALUES (95,14,263);
INSERT INTO detalleventa VALUES (96,15,127);
INSERT INTO detalleventa VALUES (96,10,243);
INSERT INTO detalleventa VALUES (96,7,197);
INSERT INTO detalleventa VALUES (96,11,215);
INSERT INTO detalleventa VALUES (97,15,298);
INSERT INTO detalleventa VALUES (97,9,25);
INSERT INTO detalleventa VALUES (97,4,89);
INSERT INTO detalleventa VALUES (97,7,101);
INSERT INTO detalleventa VALUES (97,11,107);
INSERT INTO detalleventa VALUES (97,3,253);
INSERT INTO detalleventa VALUES (98,2,283);
INSERT INTO detalleventa VALUES (98,8,225);
INSERT INTO detalleventa VALUES (98,13,260);
INSERT INTO detalleventa VALUES (98,14,130);
INSERT INTO detalleventa VALUES (99,9,77);
INSERT INTO detalleventa VALUES (99,10,297);
INSERT INTO detalleventa VALUES (99,1,255);
INSERT INTO detalleventa VALUES (100,15,49);
INSERT INTO detalleventa VALUES (101,12,99);
INSERT INTO detalleventa VALUES (101,7,43);
INSERT INTO detalleventa VALUES (102,3,56);
INSERT INTO detalleventa VALUES (102,11,166);
INSERT INTO detalleventa VALUES (102,5,190);
INSERT INTO detalleventa VALUES (102,7,296);
INSERT INTO detalleventa VALUES (102,13,233);
INSERT INTO detalleventa VALUES (102,2,115);
INSERT INTO detalleventa VALUES (102,14,279);
INSERT INTO detalleventa VALUES (102,6,85);
INSERT INTO detalleventa VALUES (103,15,176);
INSERT INTO detalleventa VALUES (103,11,250);
INSERT INTO detalleventa VALUES (103,12,131);
INSERT INTO detalleventa VALUES (103,8,151);
INSERT INTO detalleventa VALUES (103,5,111);
INSERT INTO detalleventa VALUES (104,12,114);
INSERT INTO detalleventa VALUES (104,14,102);
INSERT INTO detalleventa VALUES (104,3,122);
INSERT INTO detalleventa VALUES (105,11,258);
INSERT INTO detalleventa VALUES (105,15,237);
INSERT INTO detalleventa VALUES (105,6,173);
INSERT INTO detalleventa VALUES (105,9,155);
INSERT INTO detalleventa VALUES (105,12,261);
INSERT INTO detalleventa VALUES (105,2,217);
INSERT INTO detalleventa VALUES (105,10,206);
INSERT INTO detalleventa VALUES (105,3,60);
INSERT INTO detalleventa VALUES (106,4,223);
INSERT INTO detalleventa VALUES (106,14,154);
INSERT INTO detalleventa VALUES (107,12,136);
INSERT INTO detalleventa VALUES (107,1,186);
INSERT INTO detalleventa VALUES (107,4,278);
INSERT INTO detalleventa VALUES (107,5,143);
INSERT INTO detalleventa VALUES (107,6,253);
INSERT INTO detalleventa VALUES (107,2,147);
INSERT INTO detalleventa VALUES (108,15,245);
INSERT INTO detalleventa VALUES (108,3,56);
INSERT INTO detalleventa VALUES (108,2,280);
INSERT INTO detalleventa VALUES (109,2,298);
INSERT INTO detalleventa VALUES (109,1,286);
INSERT INTO detalleventa VALUES (109,5,65);
INSERT INTO detalleventa VALUES (109,10,227);
INSERT INTO detalleventa VALUES (109,13,213);
INSERT INTO detalleventa VALUES (109,4,186);
INSERT INTO detalleventa VALUES (110,9,84);
INSERT INTO detalleventa VALUES (110,12,120);
INSERT INTO detalleventa VALUES (110,10,231);
INSERT INTO detalleventa VALUES (111,2,253);
INSERT INTO detalleventa VALUES (111,12,208);
INSERT INTO detalleventa VALUES (111,1,100);
INSERT INTO detalleventa VALUES (111,14,133);
INSERT INTO detalleventa VALUES (111,10,28);
INSERT INTO detalleventa VALUES (112,15,294);
INSERT INTO detalleventa VALUES (112,3,227);
INSERT INTO detalleventa VALUES (113,4,148);
INSERT INTO detalleventa VALUES (113,2,256);
INSERT INTO detalleventa VALUES (113,6,177);
INSERT INTO detalleventa VALUES (114,3,209);
INSERT INTO detalleventa VALUES (114,5,154);
INSERT INTO detalleventa VALUES (114,12,250);
INSERT INTO detalleventa VALUES (114,1,27);
INSERT INTO detalleventa VALUES (114,14,192);
INSERT INTO detalleventa VALUES (115,9,30);
INSERT INTO detalleventa VALUES (115,4,60);
INSERT INTO detalleventa VALUES (115,11,277);
INSERT INTO detalleventa VALUES (115,3,259);
INSERT INTO detalleventa VALUES (115,2,189);
INSERT INTO detalleventa VALUES (115,1,249);
INSERT INTO detalleventa VALUES (115,6,199);
INSERT INTO detalleventa VALUES (115,7,255);
INSERT INTO detalleventa VALUES (116,8,79);
INSERT INTO detalleventa VALUES (116,10,138);
INSERT INTO detalleventa VALUES (116,14,151);
INSERT INTO detalleventa VALUES (116,2,95);
INSERT INTO detalleventa VALUES (117,10,256);
INSERT INTO detalleventa VALUES (118,3,298);
INSERT INTO detalleventa VALUES (118,12,149);
INSERT INTO detalleventa VALUES (118,4,195);
INSERT INTO detalleventa VALUES (118,5,276);
INSERT INTO detalleventa VALUES (118,6,260);
INSERT INTO detalleventa VALUES (118,8,169);
INSERT INTO detalleventa VALUES (118,7,106);
INSERT INTO detalleventa VALUES (118,15,267);
INSERT INTO detalleventa VALUES (118,1,214);
INSERT INTO detalleventa VALUES (118,11,187);
INSERT INTO detalleventa VALUES (119,7,30);
INSERT INTO detalleventa VALUES (119,1,122);
INSERT INTO detalleventa VALUES (119,14,199);
INSERT INTO detalleventa VALUES (119,6,81);
INSERT INTO detalleventa VALUES (119,8,241);
INSERT INTO detalleventa VALUES (119,13,216);
INSERT INTO detalleventa VALUES (119,15,223);
INSERT INTO detalleventa VALUES (120,7,147);
INSERT INTO detalleventa VALUES (120,5,104);
INSERT INTO detalleventa VALUES (120,12,225);
INSERT INTO detalleventa VALUES (120,13,228);
INSERT INTO detalleventa VALUES (120,15,239);

INSERT INTO carga_familiar VALUES(20639521,'0','ARAVENA','RIVERA','MIGUEL',10);
INSERT INTO carga_familiar VALUES(19074837,'1','ARAVENA','RIVERA','CESAR',10);
INSERT INTO carga_familiar VALUES(22251882,'2','LORCA','DONOSO','CLAUDIO',20);
INSERT INTO carga_familiar VALUES(17238830,'3','LORCA','DONOSO','JUAN',20);
INSERT INTO carga_familiar VALUES(18777063,'4','CASTAÑEDA','TRONCOSO','PABLO',40);
INSERT INTO carga_familiar VALUES(22467572,'5','TRONCOSO','ROMERO','CLAUDIA',40);
INSERT INTO carga_familiar VALUES(20487147,'9','CASTAÑEDA','TRONCOSO','MARINA',50);

INSERT INTO comision_venta
SELECT to_char(V.fecha_venta, 'yyyy'), to_char(V.fecha_venta, 'mm'), V.id_vendedor, 
       SUM(ar.precio * DV.cantidad), round(SUM(ar.precio * DV.cantidad) * 0.02)
FROM venta V JOIN detalleventa DV
ON V.id_venta = DV.id_venta
JOIN articulo ar ON ar.id_articulo = DV.id_articulo
GROUP BY to_char(V.fecha_venta, 'yyyy'), to_char(V.fecha_venta, 'mm'),v.id_vendedor
order by 1,2;
COMMIT;