/*Generar el script que crea cada una de las tablas que conforman la base de
datos propuesta por el Comité Olímpico*/

/*Creacion de tabla profesion*/
CREATE TABLE PROFESION (
    cod_prof INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

/*Creacion de tabla profesion*/
CREATE TABLE PAIS (
    cod_pais INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT cu_nombre_pais UNIQUE (nombre)
);

/*Creacion de tabla profesion*/
CREATE TABLE PUESTO (
    cod_puesto INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

/*Creacion de tabla profesion*/
CREATE TABLE DEPARTAMENTO (
    cod_depto INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT cu_nombre_dep UNIQUE(nombre)
);

/*Creacion de tabla miembro*/
CREATE TABLE MIEMBRO (
    cod_miembro INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    edad INTEGER NOT NULL,
    telefono INTEGER NULL,
    residencia VARCHAR(100) NULL,
    PAIS_cod_pais INTEGER NOT NULL,
    PROFESION_cod_prof INTEGER NOT NULL,
    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais),
    FOREIGN KEY (PROFESION_cod_prof) REFERENCES PROFESION (cod_prof)
);
/*Creacion de tabla  puesto miembro*/
CREATE TABLE PUESTO_MIEMBRO (
    MIEMBRO_cod_miembro INTEGER NOT NULL,
    PUESTO_cod_puesto INTEGER NOT NULL,
    DEPARTAMENTO_cod_depto INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
    FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES MIEMBRO (cod_miembro),
    FOREIGN KEY (PUESTO_cod_puesto) REFERENCES PUESTO (cod_puesto),
    FOREIGN KEY (departamento_cod_depto) REFERENCES DEPARTAMENTO (cod_depto)
);

/*Creacion de tabla tipo medalla*/
CREATE TABLE TIPO_MEDALLA(
    cod_tipo INTEGER PRIMARY KEY NOT NULL,
    medalla VARCHAR(50) NOT NULL,
    CONSTRAINT cu_medalla UNIQUE(medalla)
);

/*Creacion de tabla medallero*/
CREATE TABLE MEDALLERO(
    PAIS_cod_pais INTEGER NOT NULL,
    cantidad_medallas INTEGER NOT NULL,
    TIPO_MEDALLA_cod_tipo INTEGER NOT NULL,
    PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais),
    FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA (cod_tipo)
);

/*Creacion de tabla disciplina*/
CREATE TABLE DISCIPLINA (
    cod_disciplina INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NULL
);

/*Creacion de tabla atleta*/
CREATE TABLE ATLETA(
    cod_atleta INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    participaciones VARCHAR(100),
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PAIS_cod_pais INTEGER NOT NULL,
    FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais)
);

/*Creacion de tabla categoria*/
CREATE TABLE CATEGORIA(
    cod_categoria INTEGER PRIMARY KEY NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

/*Creacion de tabla tipo participacion*/
CREATE TABLE TIPO_PARTICIPACION(
    cod_participacion INTEGER PRIMARY KEY NOT NULL,
    tipo_participacion VARCHAR(100) NOT NULL
);


/*Creacion de tabla evento*/
CREATE TABLE EVENTO(
    cod_evento INTEGER PRIMARY KEY NOT NULL,
    fecha DATE NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    TIPO_PARTICIPACION_cod_participacion INTEGER NOT NULL,
    CATEGORIA_cod_categoria INTEGER NOT NULL,
    FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
    FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion) REFERENCES TIPO_PARTICIPACION (cod_participacion),
    FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES CATEGORIA (cod_categoria)
);

/*Creacion de tabla evento atleta*/
CREATE TABLE EVENTO_ATLETA(
    ATLETA_cod_atleta INTEGER NOT NULL,
    EVENTO_cod_evento INTEGER NOT NULL,
    PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
    FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA (cod_atleta),
    FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento)
);

/*Creacion de tabla televisora*/
CREATE TABLE TELEVISORA(
    cod_televisora INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL
);

/*Creacion de tabla costo evento*/
CREATE TABLE COSTO_EVENTO(
    EVENTO_cod_evento INTEGER NOT NULL,
    TELEVISORA_cod_televisora INTEGER NOT NULL,
    Tarifa INTEGER NOT NULL,
    PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento),
    FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES TELEVISORA (cod_televisora)
);

/* En la tabla “Evento” se decidió que la fecha y hora se trabajaría en una sola
columna.*/
ALTER TABLE EVENTO 
DROP fecha;
ALTER TABLE EVENTO 
DROP hora;
ALTER TABLE EVENTO 
ADD fecha_hora timestamp NOT NULL;

/*3. Todos los eventos de las olimpiadas deben ser programados del 24 de julio
de 2020 a partir de las 9:00:00 hasta el 09 de agosto de 2020 hasta las
20:00:00.*/
ALTER TABLE EVENTO
ADD CONSTRAINT ck_fecha_hora CHECK (fecha_hora BETWEEN '2020-07-24 09:00:00'::timestamp AND '2020-08-09 20:00:00'::timestamp);



/*4 Se decidió que las ubicación de los eventos se registrarán previamente en
una tabla y que en la tabla “Evento”*/
CREATE TABLE SEDE(
    codigo INTEGER PRIMARY KEY NOT NULL,
    sede VARCHAR(50) NOT NULL
);

ALTER TABLE EVENTO
ALTER COLUMN ubicacion TYPE INTEGER USING ubicacion::INTEGER,
ALTER COLUMN ubicacion SET NOT NULL;
ALTER TABLE evento
ADD FOREIGN KEY (ubicacion) REFERENCES SEDE (codigo);

/*5. Se revisó la información de los miembros que se tienen actualmente y antes
de que se ingresen a la base de datos el Comité desea que a los miembros
que no tengan número telefónico se le ingrese el número por Default 0 al
momento de ser cargados a la base de datos*/
ALTER TABLE MIEMBRO
ALTER COLUMN telefono TYPE INTEGER,
ALTER COLUMN telefono SET DEFAULT 0;

/*6. Insersion de datos*/
INSERT INTO PAIS (cod_pais, nombre) VALUES (1, 'Guatemala');
INSERT INTO PAIS (cod_pais, nombre) VALUES (2, 'Francia');
INSERT INTO PAIS (cod_pais, nombre) VALUES (3, 'Argentina');
INSERT INTO PAIS (cod_pais, nombre) VALUES (4, 'Alemania');
INSERT INTO PAIS (cod_pais, nombre) VALUES (5, 'Italia');
INSERT INTO PAIS (cod_pais, nombre) VALUES (6, 'Brasil');
INSERT INTO PAIS (cod_pais, nombre) VALUES (7, 'Estados Unidos');

SELECT * FROM PAIS

INSERT INTO PROFESION (cod_prof, nombre) VALUES (1, 'Médico');
INSERT INTO PROFESION (cod_prof, nombre) VALUES (2, 'Arquitecto');
INSERT INTO PROFESION (cod_prof, nombre) VALUES (3, 'Ingeniero');
INSERT INTO PROFESION (cod_prof, nombre) VALUES (4, 'Secretaria');
INSERT INTO PROFESION (cod_prof, nombre) VALUES (5, 'Auditor');

SELECT * FROM PROFESION

INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (1,'Scott','Mitchell',32,'1092 Highland Drive Manitowoc, Wl 54220',7,3);
INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (2,'Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (3,'Laura','Cunha Silva',55,'Rua Onze, 86 Uberaba-MG',6,5);
INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (4,'Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2);
INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,telefono,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (5,'Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
INSERT INTO MIEMBRO (cod_miembro,nombre,apellido,edad,residencia,pais_cod_pais,profesion_cod_prof)
VALUES (6,'Jeuel','Villalpando',31,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);

SELECT * FROM MIEMBRO

INSERT INTO DISCIPLINA (cod_disciplina,nombre,descripcion)
VALUES (1,'Atletismo','Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (2,'Bádminton');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (3,'Ciclismo');
INSERT INTO DISCIPLINA (cod_disciplina,nombre,descripcion)
VALUES (4,'Judo','Es un arte marcial que se originó en Japón alrededor de 1880');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (5,'Lucha');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (6,'Tenis de Mesa');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (7,'Boxeo');
INSERT INTO DISCIPLINA (cod_disciplina,nombre,descripcion)
VALUES (8,'Natación','Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (9,'Esgrima');
INSERT INTO DISCIPLINA (cod_disciplina,nombre) VALUES (10,'Vela');

SELECT * FROM DISCIPLINA

INSERT INTO TIPO_MEDALLA (cod_tipo, medalla) VALUES (1, 'Oro');
INSERT INTO TIPO_MEDALLA (cod_tipo, medalla) VALUES (2, 'Plata');
INSERT INTO TIPO_MEDALLA (cod_tipo, medalla) VALUES (3, 'Bronce');
INSERT INTO TIPO_MEDALLA (cod_tipo, medalla) VALUES (4, 'Platino');

SELECT * FROM TIPO_MEDALLA

INSERT INTO CATEGORIA (cod_categoria, categoria) VALUES (1, 'Clasificatorio');
INSERT INTO CATEGORIA (cod_categoria, categoria) VALUES (2, 'Eliminatorio');
INSERT INTO CATEGORIA (cod_categoria, categoria) VALUES (3, 'Final');

SELECT * FROM CATEGORIA

INSERT INTO TIPO_PARTICIPACION (cod_participacion, tipo_participacion) VALUES (1, 'Individual');
INSERT INTO TIPO_PARTICIPACION (cod_participacion, tipo_participacion) VALUES (2, 'Parejas');
INSERT INTO TIPO_PARTICIPACION (cod_participacion, tipo_participacion) VALUES (3, 'Equipos');

SELECT * FROM TIPO_PARTICIPACION

INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (5,1,3);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (2,1,5);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (6,3,4);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (4,4,3);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (7,3,10);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (3,2,8);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (1,1,2);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (1,4,5);
INSERT INTO MEDALLERO (pais_cod_pais,tipo_medalla_cod_tipo,cantidad_medallas) VALUES (5,2,7);

SELECT * FROM MEDALLERO

INSERT INTO SEDE (codigo, sede) VALUES (1,'Gimnasio Metropolitano de Tokio');
INSERT INTO SEDE (codigo, sede) VALUES (2,'Jardín del Palacio Imperial de Tokio');
INSERT INTO SEDE (codigo, sede) VALUES (3,'Gimnasio Nacional Yoyogi');
INSERT INTO SEDE (codigo, sede) VALUES (4,'Nippon Budokan');
INSERT INTO SEDE (codigo, sede) VALUES (5,'Estadio Olímpico');

SELECT * FROM SEDE

INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,CATEGORIA_cod_categoria)
VALUES (1,'2020-07-24 11:00:00', 3, 2, 2, 1);
INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES (2,'2020-07-26 10:30:00', 1, 6, 1, 3);
INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES (3,'2020-07-30 18:45:00', 5, 7, 1, 2);
INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES (4,'2020-08-01 12:15:00', 2, 1, 1, 1);
INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES (5,'2020-08-08 19:35:00', 4, 10, 3, 1);

SELECT * FROM EVENTO
/*7. Después de que se implementó el script el cuál creó todas las tablas de las
bases de datos, el Comité Olímpico Internacional tomó la decisión de
eliminar la restricción “UNIQUE” de las siguientes tablas*/
ALTER TABLE PAIS
DROP CONSTRAINT cu_nombre_pais;	

ALTER TABLE TIPO_MEDALLA
DROP CONSTRAINT cu_medalla;

ALTER TABLE DEPARTAMENTO
DROP CONSTRAINT cu_nombre_dep;

/*8. Después de un análisis más profundo se decidió que los Atletas pueden
participar en varias disciplinas y no sólo en una como está reflejado
actualmente en las tablas, por lo que se pide que realice lo siguiente.*/
ALTER TABLE atleta
DROP DISCIPLINA_cod_disciplina;

CREATE TABLE Disciplina_Atleta(
    Cod_atleta INTEGER NOT NULL,
    Cod_disciplina INTEGER NOT NULL,
    PRIMARY KEY (Cod_atleta, Cod_disciplina),
    FOREIGN KEY (cod_atleta) REFERENCES ATLETA (cod_atleta),
    FOREIGN KEY (cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina)
);

/*9. En la tabla “Costo_Evento” se determinó que la columna “tarifa” no debe
ser entero sino un decimal con 2 cifras de precisión.*/
ALTER TABLE COSTO_EVENTO
ALTER COLUMN tarifa TYPE NUMERIC(20, 2);

/*10. Generar el Script que borre de la tabla “Tipo_Medalla”, el registro siguiente:*/

SELECT * FROM TIPO_MEDALLA

DELETE FROM MEDALLERO
WHERE TIPO_MEDALLA_cod_tipo = 4

DELETE FROM TIPO_MEDALLA
WHERE cod_tipo = 4;

SELECT * FROM TIPO_MEDALLA


/*11. La fecha de las olimpiadas está cerca y los preparativos siguen, pero de
último momento se dieron problemas con las televisoras encargadas de
transmitir los eventos, ya que no hay tiempo de solucionar los problemas
que se dieron, se decidió no transmitir el evento a través de las televisoras
por lo que el Comité Olímpico pide generar el script que elimine la tabla
“TELEVISORAS” y “COSTO_EVENTO”.*/


DROP TABLE COSTO_EVENTO;
DROP TABLE TELEVISORA;

/*12. El comité olímpico quiere replantear las disciplinas que van a llevarse a cabo,
por lo cual pide generar el script que elimine todos los registros contenidos
en la tabla “DISCIPLINA”*/
SELECT * FROM DISCIPLINA;

DELETE FROM ATLETA;
DELETE FROM EVENTO;

DELETE FROM DISCIPLINA;

SELECT * FROM DISCIPLINA;

/*13. Los miembros que no tenían registrado su número de teléfono en sus
perfiles fueron notificados, por lo que se acercaron a las instalaciones de
Comité para actualizar sus datos*/

SELECT * FROM MIEMBRO;

UPDATE MIEMBRO
SET telefono = 55464601
WHERE nombre = 'Laura' AND apellido = 'Cunha Silva';

UPDATE MIEMBRO
SET telefono = 91514243
WHERE nombre = 'Jeuel' AND apellido = 'Villalpando';

UPDATE MIEMBRO
SET telefono = 920686670
WHERE nombre = 'Scott' AND apellido = 'Mitchell';


SELECT * FROM MIEMBRO;
/*14. El Comité decidió que necesita la fotografía en la información de los atletas
para su perfil, por lo que se debe agregar la columna “Fotografía” a la tabla
Atleta, debido a que es un cambio de última hora este campo deberá ser
opcional.*/
ALTER TABLE ATLETA
ADD fotografia bytea NULL;

/*15. Todos los atletas que se registren deben cumplir con ser menores a 25 años.
De lo contrario no se debe poder registrar a un atleta en la base de datos.*/
ALTER TABLE ATLETA
ADD CHECK (edad < 25);

