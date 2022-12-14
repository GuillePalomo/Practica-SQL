DROP TABLE TIEMPO_D CASCADE CONSTRAINT;
DROP TABLE GEOGRAFIA_D CASCADE CONSTRAINT;
DROP TABLE PRODUCTO_D CASCADE CONSTRAINT;
DROP TABLE VENTAS_H CASCADE CONSTRAINT;
DROP TABLE MACROGEO_D CASCADE CONSTRAINT;

CREATE TABLE MACROGEO_D (REGION VARCHAR2(30), PAIS VARCHAR2(30), CONTINENTE VARCHAR2(30),
CONSTRAINT PK_MACROGEO PRIMARY KEY (REGION));

CREATE TABLE GEOGRAFIA_D(TIENDA VARCHAR2(30), ZONA VARCHAR2(30), REGION VARCHAR2(30),
CONSTRAINT PK_GEO PRIMARY KEY (TIENDA),
CONSTRAINT FK_GEO FOREIGN KEY (REGION) REFERENCES MACROGEO_D(REGION) ON DELETE CASCADE);

CREATE TABLE TIEMPO_D (DIA VARCHAR2(8) PRIMARY KEY, FECHA DATE, DIA_SEMANA VARCHAR2(10), SEMANA NUMBER(1,0), MES NUMBER(2,0), N_MES VARCHAR2(10), TRIMESTRE NUMBER(1,0), TRIM VARCHAR2(2),ANYO NUMBER(4,0));

CREATE TABLE PRODUCTO_D  (PRODUCTO VARCHAR2(30) PRIMARY KEY, SUBSECCION VARCHAR2(30), SECCION VARCHAR2(30), MARCA VARCHAR2(30), FABRICANTE VARCHAR2(30));

CREATE TABLE VENTAS_H  (TIENDA VARCHAR2(30 ), PRODUCTO VARCHAR2(30), VENTAS NUMBER(6,0), DIA VARCHAR2(8),
CONSTRAINT PK_VENTAS_H PRIMARY KEY (TIENDA, PRODUCTO, DIA), 
CONSTRAINT FK_VENTAS1 FOREIGN KEY (TIENDA) REFERENCES GEOGRAFIA_D (TIENDA) ON DELETE CASCADE, 
CONSTRAINT FK_VENTAS2 FOREIGN KEY (PRODUCTO) REFERENCES PRODUCTO_D (PRODUCTO) ON DELETE CASCADE,  
CONSTRAINT FK3 FOREIGN KEY (DIA) REFERENCES TIEMPO_D (DIA));

INSERT INTO MACROGEO_D VALUES ('MADRID','ESPANA','EUROPA');
INSERT INTO MACROGEO_D VALUES ('VALENCIA','ESPANA','EUROPA');
INSERT INTO GEOGRAFIA_D (TIENDA, ZONA, REGION) VALUES ('LEGANES', 'SUR', 'MADRID');
INSERT INTO GEOGRAFIA_D  (TIENDA, ZONA, REGION) VALUES ('PATERNA','ESTE', 'VALENCIA');
INSERT INTO GEOGRAFIA_D (TIENDA, ZONA, REGION)  VALUES ('MAJADAHONDA', 'NORTE', 'MADRID');
INSERT INTO GEOGRAFIA_D  (TIENDA, ZONA, REGION) VALUES ('TORRELODONES' ,'NORTE' ,'MADRID');
INSERT INTO PRODUCTO_D  (PRODUCTO, SUBSECCION, SECCION, MARCA, FABRICANTE) VALUES ('KIT HUERTO VINTAGE ECO','PLANTAS
JARDIN','JARDIN','TODO JARDIN','VERDEVERDE');
INSERT INTO PRODUCTO_D (PRODUCTO, SUBSECCION, SECCION, MARCA, FABRICANTE) VALUES ('BARBACOA CARBON CHAR-BROIL','EQUIPAMIENTO
JARDIN','COCINA','XALIS','EQUIPAMIENTOS MARTINEZ');




DECLARE
f DATE;
BEGIN
FOR i IN 1..500 LOOP
f:=SYSDATE-i;
INSERT INTO TIEMPO_D VALUES
(
(TO_CHAR(SYSDATE-i,'YYYY')||TO_CHAR(SYSDATE-i,'MM')||TO_CHAR(SYSDATE-i,'DD')),
TRUNC(f),
TO_CHAR(f,'DAY'),
TO_NUMBER(TO_CHAR(f,'W')),
TO_NUMBER(TO_CHAR(f,'MM')),
TO_CHAR(f,'MONTH'),
TO_NUMBER(TO_CHAR(f,'Q')),
'Q'||TO_CHAR(f,'Q'),
TO_NUMBER(TO_CHAR(f,'YYYY'))
);
END LOOP;
COMMIT;
END;



DECLARE
f DATE;
c VARCHAR(8);
BEGIN
FOR i IN 2..500 LOOP
f:=SYSDATE-i;
c:=TO_CHAR(f,'YYYY')||TO_CHAR(f,'MM')||TO_CHAR(f,'DD');
INSERT INTO VENTAS_H VALUES ('PATERNA', 'KIT HUERTO VINTAGE ECO',
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('PATERNA', 'BARBACOA CARBON CHAR-BROIL',
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('TORRELODONES', 'KIT HUERTO VINTAGE ECO',
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('TORRELODONES','BARBACOA CARBON CHAR-BROIL', 
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('MAJADAHONDA', 'KIT HUERTO VINTAGE ECO',
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('MAJADAHONDA', 'BARBACOA CARBON CHAR-BROIL', 
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('LEGANES', 'KIT HUERTO VINTAGE ECO',
dbms_random.value(0,200),c);
INSERT INTO VENTAS_H VALUES ('LEGANES', 'BARBACOA CARBON CHAR-BROIL',
dbms_random.value(0,200),c);
END LOOP;
COMMIT;
END;



#1



#2

SELECT TIENDA, PRODUCTO, SUM(VENTAS) FROM VENTAS_H GROUP BY CUBE(TIENDA, PRODUCTO); 

SELECT TIENDA, PRODUCTO, SUM (VENTAS) FROM VENTAS_H GROUP BY GROUPING SETS((TIENDA, PRODUCTO),(TIENDA),(PRODUCTO),());

SELECT TIENDA, PRODUCTO, SUM(VENTAS) FROM VENTAS_H GROUP BY TIENDA, PRODUCTO UNION 
SELECT TIENDA, NULL, SUM(VENTAS) FROM VENTAS_H GROUP BY TIENDA, NULL UNION
SELECT NULL, PRODUCTO, SUM(VENTAS) FROM VENTAS_H GROUP BY NULL, PRODUCTO UNION
SELECT NULL, NULL, SUM(VENTAS) FROM VENTAS_H GROUP BY NULL, NULL ;


#3

#4

SELECT TIENDA, PRODUCTO, SUM(VENTAS) FROM VENTAS_H GROUP BY TIENDA, PRODUCTO UNION 
SELECT TIENDA, NULL, SUM(VENTAS) FROM VENTAS_H GROUP BY TIENDA, NULL UNION
SELECT NULL, NULL, SUM(VENTAS) FROM VENTAS_H GROUP BY NULL, NULL ;

SELECT TIENDA, PRODUCTO, SUM (VENTAS) FROM VENTAS_H GROUP BY GROUPING SETS((TIENDA, PRODUCTO),(TIENDA),());

SELECT PRODUCTO, TIENDA, SUM(VENTAS) FROM VENTAS_H WHERE PRODUCTO ='KIT HUERTO VINTAGE ECO' OR PRODUCTO = 'BARBACOA CARBON CHARBROIL' GROUP BY ROLLUP (PRODUCTO,TIENDA);


#5

SELECT M.PAIS, H.PRODUCTO, SUM(H.VENTAS) FROM MACROGEO_D M, VENTAS_H H WHERE G.TIENDA = H.TIENDA  GROUP BY ROLLUP(G.PAIS,H.PRODUCTO);

SELECT G.REGION, H.PRODUCTO, SUM(H.VENTAS) FROM GEOGRAFIA_D G, VENTAS_H H WHERE G.TIENDA = H.TIENDA  GROUP BY ROLLUP(G.REGION,H.PRODUCTO);

########7

SELECT * FROM (SELECT TIENDA, PRODUCTO, VENTAS FROM VENTAS_H)
PIVOT(SUM(VENTAS) FOR PRODUCTO IN ('KIT HUERTO VINTAGE ECO','BARBACOA CARBON CHARBROIL'));



