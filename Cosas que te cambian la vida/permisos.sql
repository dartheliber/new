CREATE USER USRSMUEMPR IDENTIFIED BY M489HS392T;
GRANT CONNECT TO USRSMUEMPR;   --PERMISOS DE CONEXION  A LA DB AL USUARIO USRINFMICNEG
GRANT SELECT ON CECO.SPPS2005_CONSULTA_SCP TO USRSMUEMPR;   --PERMISOS DE SELECT SOBRE EL OBJETO AL USUARIO USRINFMICNEG

DROP USER USRINFMICNEG CASCADE;   --BORRAR COMPLETAMENTE UN USR
DROP USER USRINFMICNEG;  --BORRAR UN USUARIO


---------------------------------------
--Nuevos usuarios para desarrollos
--AUDITORÍA 	
/*      USUARIO DE INFORMATICA  
      
  REQUERIMIENTO: 
    RESPONSABLE: EDITH AGUILAR URBAN?    
NUMERO EMPLEADO: 
          AREA : AUDITORÍA
         MOTIVO: CREAR UN USUARIO PARA EL AREA DE AUDITORÍA QUE EJECUTE UN SP 
        QUE CONSULTE LAS ESTRUCTURAS: OPERATIVA, GUN_CORP, TVA, BOF Y TOTAL PLAY PARA 
IP´S DESDE DONDE SE ESTARA CONECTANDO:
      10.56.33.13
      10.56.33.12
      10.56.33.47
      10.56.33.66
      10.82.20.69
      10.82.20.70
      10.82.20.65
      10.82.20.66      
*/
CREATE USER USRINFAUD 
IDENTIFIED BY P15GBK71F30;
GRANT CREATE SESSION TO USRINFAUD;   
GRANT EXECUTE ON CECO.SP_AUDIT TO USRINFAUD; 
GRANT SELECT, INSERT, UPDATE, DELETE ON CECO.TACCNE24_AUD TO USRINFAUD; 

--DSI 	
/*      USUARIO DE INFORMATICA  
      
  REQUERIMIENTO: 72975
    RESPONSABLE: RODOLFO AGUILERA MARTÍNEZ
NUMERO EMPLEADO: 60045046
          AREA : DESPACHO DE SEGURIDAD DE LA INFORMACIÓN/IDENTITY MANAGER
         MOTIVO: CREAR UN USUARIO PARA EL AREA DE DESPACHO DE SEGURIDAD DE LA INFORMACIÓN/IDENTITY MANAGER 
		         QUE EJECUTE UN SP QUE CONSULTE LA ESTRUCTURA OPERATIVA DE  Y LE MUESTRE 
IP´S DESDE DONDE SE ESTARA CONECTANDO:
Productivo
	- 10.63.24.45
	- 10.63.24.46
	- 10.50.158.27 
*/
CREATE USER USRINFDSI 
IDENTIFIED BY G41UD82F49Z;
GRANT CREATE SESSION TO USRINFDSI;   
GRANT EXECUTE ON CECO.SPDSICONS_EST_OP TO USRINFDSI; 
