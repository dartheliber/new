--Para comparar dentro de un DECODE con parte de un texto del contenido de un campo, es decir, para poder utilizar un like u otras funciones en lugar de la igualdad que toma por defecto el DECODE se puede hacer lo siguiente:

SELECT DECODE(CAMPO, 
              (select CAMPO from dual where CAMPO like 'A%'), 
              'Campo comienza por A', 
              (select name from dual where name like 'B%'), 
              'Campo comienza por B', 
              'Campo no comienza ni por A ni por B') 
FROM TABLA;

--Cuando un tablespace se queda sin espacio se puede ampliar creando un nuevo fichero de datos, 
--o ampliando uno de los existentes.
--Para consultar el espacio ocupado por cada datafile se puede utilizar la consulta de la lista anterior:

--Consulta Oracle SQL para el DBA de Oracle que muestra los tablespaces, el espacio utilizado, el espacio libre y los ficheros de datos de los mismos:
SELECT t.tablespace_name "Tablespace", t.status "Estado",
ROUND(MAX(d.bytes)/1024/1024,2) "MB Tamaño",
ROUND((MAX(d.bytes)/1024/1024) -
(SUM(decode(f.bytes, NULL,0, f.bytes))/1024/1024),2) "MB Usados",
ROUND(SUM(decode(f.bytes, NULL,0, f.bytes))/1024/1024,2) "MB Libres",
t.pct_increase "% incremento",
SUBSTR(d.file_name,1,80) "Fichero de datos"
FROM DBA_FREE_SPACE f, DBA_DATA_FILES d, DBA_TABLESPACES t
WHERE t.tablespace_name = d.tablespace_name AND
f.tablespace_name(+) = d.tablespace_name
AND f.file_id(+) = d.file_id GROUP BY t.tablespace_name,
d.file_name, t.pct_increase, t.status ORDER BY 1,3 DESC

--Una vez que localizamos el datafile que podríamos ampliar ejecutaremos la siguiente sentencia para hacerlo:
ALTER DATABASE
DATAFILE '/db/oradata/datafiles/datafile_n.dbf' AUTOEXTEND
ON NEXT 1M MAXSIZE 4000M

/*Con esta sentencia, el datafile continuaría ampliándose hasta llegar a un máximo de 4Gb.
* Si preferimos crear un nuevo datafile porque los que tenemos ya son demasido grandes, 
* una sentencia que podríamos utilizar es la siguiente:
*/

ALTER TABLESPACE "MiTablespace"
ADD
DATAFILE '/db/oradata/datafiles/datafile_m.dbf' SIZE
100M AUTOEXTEND
ON NEXT 1M MAXSIZE 1000M

/*Crearíamos un nuevo fichero de datos de 100 Mb, y en modo autoextensible hasta 1000 Mb.
* Por supuesto, el path especificado debe ser el específico de cada base de datos, 
* y se debe utilizar para todo el proceso un usuario con privilegios de DBA.
* Para matar una sesión de Oracle hay que utilizar, con un usuario con permisos de DBA, el comando
*/

ALTER SYSTEM KILL SESSION 'SID,SERIAL#';

--Para obtener el SID y el SERIAL# que necesitamos se puede utilizar la consulta:

SELECT p.*, s.*
FROM v$session s, v$process p
WHERE p.addr(+)=s.paddr
ORDER BY SID

/*Esta consulta devolvería los datos de todas las sesiones abiertas, 
se pueden restringir los resultados a las sesiones que interesen añadiendo condiciones en el where.
Si el número de sesiones que hay que eliminar es elevado, 
se puede utilizar esta misma consulta para crear las sentencias necesarias dinámicamente:
*/

SELECT 'alter system kill session '''||s.sid||','||p.serial#||''';'
FROM v$session s, v$process p
WHERE p.addr(+)=s.paddr
AND s.username='USER'; (por ejemplo)

/*
Sobretodo cuidado con la condición que se incluye en el where, 
ya que si no se especificara nada, por ejemplo, se matarían todas las sesiones de la base de datos.

Para crear un script con estas sentencias consultar

Gente, capas que hay gente que ya sabia de estas funciones 
pero bueno simplemente para dejarlo plasmado en alguna pagina y 
le pueda llegar a ser de gran utilidad a todo el mundo. 
Lo que voy a postear me llevo un tiempo encontrarlo y la idea 
con esto es lograr que sea mas facil encontrarlo y ademas que 
funcione porque hay mucha basura dando vueltas en la internet.

una funcion muy util que recien encontre hoy dia es: SYS_CONTEXT.

NOTA: USERENV es un nombre que describe la sesion actual y con ella y la funcion sys_context se puede conseguir:
*/

--identificador del cliente
  SELECT sys_context('USERENV', 'CLIENT_IDENTIFIER') FROM dual;

--nombre del esquema donde uno esta conectado
     SELECT sys_context('userenv', 'CURRENT_SCHEMA') FROM dual;

--ID del esquema donde uno se encuentra conectado
     SELECT sys_context('USERENV', 'CURRENT_SCHEMAID') FROM dual;

•• nombre de la base de datos.
     SELECT sys_context('USERENV', 'DB_NAME') FROM dual;

•• nombre del host
     SELECT sys_context('USERENV', 'HOST') FROM dual;

•• nombre de la instancia
     SELECT sys_context('USERENV', 'INSTANCE_NAME') FROM dual;

••los formatos de moneda, fechas.
    SELECT sys_context('USERENV', 'NLS_CURRENCY') FROM dual;   
	SELECT sys_context('USERENV', 'NLS_DATE_FORMAT') FROM dual;

•• nombre del territorio. ejemplo : 'AMERICA';
    SELECT sys_context('USERENV', 'NLS_TERRITORY') FROM dual;

•• server host nome
     SELECT sys_context('USERENV', 'SERVER_HOST') FROM dual;

•• ID de la session del usuario
     SELECT sys_context('USERENV', 'SESSION_USERID') FROM dual;

•• SID (session number) util para matar sesiones luego con el numero.
     SELECT sys_context('USERENV', 'SID') FROM dual;

•• LISTA DE PAQUETES UTL (utilidades de oracle, envio de mails mediante SMTP entre otros)

     SELECT * FROM ALL_OBJECTS
     WHERE OBJECT_NAME LIKE '%UTL_%'
         AND OBJECT_TYPE = 'PACKAGE'

•• LISTA DE PAQUETES DBMS (otras utilidades del Data Base Manager System)

     SELECT * FROM ALL_OBJECTS
      WHERE OBJECT_NAME LIKE '%DBMS_%'
          AND OBJECT_TYPE = 'PACKAGE'

--estas dos listas digamos son utiles como para ver las que hay y 
--luego investigar un poco mas como se utilizan en internet.

/*
•• Envio de e-mail a multiples usuarios mediante la utilidad UTL_SMTP.

Otra cosa que me costo mucho encontrar y en definitiva me lo 
termino contando un amigo del trabajo es como utilizar el paquete UTL_SMPT 
para mandar un mail a multiples recipientes. (a varias personas)

Mi idea es unicamente explicar este problema, como usarlo se los dejo para que lo investiguen que no es muy dificil.

si se tiene los mails en un VARCHAR de la siguiente manera

alguien@xxx.com;alguien1@xxx.com;alguien2@xxx.com;alguien3@xxx.com;alguien4@xxx.com

una vez hecho los pasos :
*/

   g_mail_conn := utl_smtp.open_connection (p_mailhost,p_mailport);   -- <-- apertura de conexion.
   utl_smtp.helo(g_mail_conn,p_mailhost);
   utl_smtp.mail(g_mail_conn,p_sender);
   
--hay que definir el recipiente con la funcion utl_smtp.rcpt(); 
--tener en cuenta que este recipiente se va a instanciar en nuestro caso 5 veces 
--(una vez por cada e-mail y no todos en uno solo OJO!)

--osea :
 utl_smtp.rcpt( p_mail_conn , alguien@xxx.com );
          utl_smtp.rcpt( p_mail_conn , alguien@xxx.com1 );
          utl_smtp.rcpt( p_mail_conn , alguien@xxx.com 2);
          utl_smtp.rcpt( p_mail_conn , alguien@xxx.com 3);
          utl_smtp.rcpt( p_mail_conn , alguien@xxx.com4 );
para cortar los mails concatenados en un VARCHAR y cumplir el proposito anterior pueden usar este procesos que me toco hacer que hace lo anteriormente descrito.

PROCEDURE Pi_Prepare_Recip_Mail ( p_mail_conn IN OUT utl_smtp.connection,
                                                      p_rec_mails IN VARCHAR2)
  IS 
       MAILS      VARCHAR2(1000)  := p_rec_mails;
       SingleMail VARCHAR2(255);
       --
       NO_MORE_MAILS BOOLEAN := FALSE;
       EOM           NUMBER;          -- end of mail.
       BOM           NUMBER := 1;     -- begin of mail.
       COC           NUMBER ;         -- number of characters.
       MAIL_NUMBER   NUMBER := 1;       
 BEGIN        
       LOOP
           EOM := INSTR(MAILS,';',1,MAIL_NUMBER);   
           IF EOM = 0 THEN   
               EOM := LENGTH(MAILS) + 1;
               NO_MORE_MAILS := TRUE;
           END IF;
           COC := (EOM) - BOM;
           SingleMail := SUBSTR(MAILS,BOM,COC);
           utl_smtp.rcpt( p_mail_conn , SingleMail );   -- <-- recipiente de salida.        
           EXIT WHEN NO_MORE_MAILS;
           MAIL_NUMBER := MAIL_NUMBER + 1 ;
           BOM := EOM + 1;
         END LOOP;
 END Pi_Prepare_Recip_Mail;
se instancia este procesos pasandole la conexion de mail y la lista de mails osea:

p_rec_mail VARCHAR2(300) := alguien@xxx.com;alguien1@xxx.com;alguien2@xxx.com;alguien3@xxx.com;alguien4@xxx.com;

instancia –>   Pi_Prepare_Recip_Mail( g_mail_conn , p_rec_mail );

En si es dificil de entender y mas de explicar, trate de ser lo mas claro posible. Cualquier duda sobre este tema escriban.

•• cambiar el lenguaje de la fecha.
select to_char(sysdate,'day', 'NLS_DATE_LANGUAGE=Spanish') from dual
select to_char(sysdate,'month', 'NLS_DATE_LANGUAGE=Spanish') from dual

•• correr las estadisticas para una determinada tabla (esto aumenta la velocidad de respuesta de las tablas en 
   aquellos casos donde el volumen de registros es considerablemente grande)
     ANALIZE TABLE <nombre de la tabla> COMPUTE STATISTICS;
     -- realizarlo en un porcentaje (en un 25 %)
     ANALIZE TABLE <nombre de la tabla> COMPUTE STATISTICS SAMPLE 25 percent;
     -- realizarlo solo para una determinada cantidad de registros)
     ANALIZE TABLE <nombre de la tabla> COMPUTE STATISTICS SAMPLE 1000 rows;

•• ponerle comentarios a las tablas y a sus columnas para que el significado de cada campo tenga mayor
   comprencion.
     COMMENT ON TABLE <table_name> IS 'comentario a escribir';
     COMMENT ON COLUMN <table_name>.<column_name> IS 'comentario a escribir aca';