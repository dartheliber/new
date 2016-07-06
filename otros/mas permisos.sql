--Ejecución SP's
GRANT EXECUTE ON CECO.SP_REPFINBANXICO TO USRWEB;
GRANT EXECUTE ON CECO.SP_REPFINBANXICO TO USRINF_BAZ;

GRANT EXECUTE ON CECO.SP_REPFINCNBV TO USRWEB;
GRANT EXECUTE ON CECO.SP_REPFINCNBV TO USRINF_BAZ;

--Ejecución paquetes
GRANT EXECUTE ON CECO.PA_MANBAN TO USRWEB;
GRANT EXECUTE ON CECO.PA_MANCNBV TO USRWEB;

GRANT EXECUTE ON CECO.PA_MANBAN TO USRINF_BAZ;
GRANT EXECUTE ON CECO.PA_MANCNBV TO USRINF_BAZ;

-------------------------------------------------------------------------------

GRANT SELECT,INSERT, UPDATE, DELETE ON CECO.TACCNE17_BANXICO TO USRINF_BAZ;
GRANT SELECT,INSERT, UPDATE, DELETE ON CECO.TACCNE18_CNBV TO USRINF_BAZ;
GRANT SELECT,INSERT, UPDATE, DELETE ON CECO.TACCNE19_COORD TO USRINF_BAZ;
GRANT SELECT,INSERT, UPDATE, DELETE ON CECO.TACCNE16_EXCEPCIONES TO USRINF_BAZ;

CREATE USER USRINFBANXICO IDENTIFIED BY JB20CJ029H;
GRANT CONNECT TO USRINFBANXICO;   
GRANT EXECUTE ON CECO.SP_REPFINCNBV TO USRINFBANXICO;
GRANT EXECUTE ON CECO.SP_REPFINBANXICO TO USRINFBANXICO;

CREATE USER USRINFCNBV IDENTIFIED BY MB20A7B14;
GRANT CONNECT TO USRINFCNBV;   
GRANT EXECUTE ON CECO.SP_REPFINBANXICO TO USRINFCNBV;
GRANT EXECUTE ON CECO.SP_REPFINCNBV TO USRINFCNBV;