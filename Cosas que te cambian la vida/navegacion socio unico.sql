
--busca el canal 216 que es tv azteca
SELECT * 
FROM CECO.TACCUN002_CANAL_UNICO
WHERE FICANALID =216;

--la clasificacion del SIE
SELECT * 
FROM CECO.TACCCA011_CLASIFICACION_SIE;

--Canal TV Azteca..
SELECT * 
FROM CECO.TAHIUN002_CANAL_UNICO
WHERE FICANALID =216;

--Consultamos entidades
SELECT *
FROM CECO.TACCUN001_ENTIDAD;

--consultamos Entidad TV Azteca
SELECT *
FROM CECO.TACCUN001_ENTIDAD
WHERE FCNOMBRE LIKE 'TV AZ%';  

--Consultamos la estructura de entidades y buscamos la 53 (TV Azteca)
--Su entidadid_raiz es 53, fientidadid es 53 y su tipo_estructuraid es 1
SELECT *
FROM CECO.TACCES002_ESTRUCTURA_ENTIDAD
WHERE FIENTIDADID LIKE 53;

--Estructuras
SELECT * 
FROM  CECO.TACCES003_ESTRUCTURA
;             

--Tipos de estructuras
SELECT * 
FROM  CECO.TACCES001_TIPO_ESTRUCTURA
;      

--Tipos de estructuras buscamos tv azteca
--result: fitipo_estructuraid 126- operativa tvazteca
--                                      127-consejo
SELECT * 
FROM  CECO.TACCES001_TIPO_ESTRUCTURA
WHERE FCTIPO_ESTRUCTURA LIKE '%AZTECA';      

--ahora buscamos en las Estructuras a tv azteca sabiendo su tipo
--resulta que nos da la estructura padre:53 que ya sabiamos 
SELECT * 
FROM  CECO.TACCES003_ESTRUCTURA
WHERE FITIPO_ESTRUCTURAID = 126;    

--y buscaremos ese campo en que otras tablas esta
SELECT OWNER, TABLE_NAME, COLUMN_NAME
FROM ALL_TAB_COLUMNS
WHERE COLUMN_NAME='FITIPO_ESTRUCTURAID';

--TOTAL PLAY 
SELECT * 
FROM CECO.TACCES001_TIPO_ESTRUCTURA
WHERE FITIPO_ESTRUCTURAID = 129;

--TOTAL SEC 
SELECT * 
FROM CECO.TACCES001_TIPO_ESTRUCTURA
WHERE FITIPO_ESTRUCTURAID = 131; 

--SAGO (BTC)
SELECT * 
FROM CECO.TACCES001_TIPO_ESTRUCTURA
WHERE FITIPO_ESTRUCTURAID = 130;

--SUCURSALES BAZ MEXICO
