--mas consultas utiles buscar columna, tabla y esquema 
SELECT OWNER, TABLE_NAME, COLUMN_NAME
FROM ALL_TAB_COLUMNS
WHERE COLUMN_NAME='FITIPO_ESTRUCTURAID';

--Este script te permite ver el crecimiento de la instancia en Mb desde el último reinicio de la BD
set pagesize 50000
select to_char(creation_time, 'RRRR Month') "Mes",
sum(bytes)/1024/1024 "Crecimiento en MB"
from sys.v_$datafile
where creation_time > SYSDATE-365
group by to_char(creation_time, 'RRRR Month')