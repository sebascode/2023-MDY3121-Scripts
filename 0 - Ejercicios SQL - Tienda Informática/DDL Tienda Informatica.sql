DROP TABLE fabricante CASCADE CONSTRAINTS;
DROP TABLE producto CASCADE CONSTRAINTS;
DROP SEQUENCE sq_fabricante;
DROP SEQUENCE sq_producto;

CREATE SEQUENCE sq_fabricante START WITH 1000;
CREATE SEQUENCE sq_producto START WITH 80;

CREATE TABLE fabricante (
    codigo NUMBER(4) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_fabricante PRIMARY KEY (codigo)
);

CREATE TABLE producto (
    codigo NUMBER(4) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(12,5) NOT NULL,
    codigo_fabricante NUMBER(4) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (codigo)
);

ALTER TABLE producto
   ADD CONSTRAINT fk_producto_fabricante FOREIGN KEY (codigo_fabricante)
   REFERENCES fabricante (codigo);

INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Asus');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Lenovo');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Samsung');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Seagate');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Crucial');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Gigabyte');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Huawei');
INSERT INTO fabricante VALUES(sq_fabricante.NEXTVAL, 'Xiaomi');

INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Disco duro SATA3 1TB', 86.99, 1005);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Memoria RAM DDR4 8GB', 120, 1006);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Disco SSD 1 TB', 150.99, 1004);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'GeForce GTX 1050Ti', 185, 1007);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'GeForce GTX 1080 Xtreme', 755, 1006);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Monitor 24 LED Full HD', 202, 1001);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Monitor 27 LED Full HD', 245.99, 1001);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Portátil Yoga 520', 559, 1002);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Portátil Ideapd 320', 444, 1002);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Impresora HP Deskjet 3720', 59.99, 1003);
INSERT INTO producto VALUES(sq_producto.NEXTVAL, 'Impresora HP Laserjet Pro M26nw', 180, 1003);

SELECT * FROM producto;
SELECT * FROM fabricante;
