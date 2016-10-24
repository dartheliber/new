CREATE OR REPLACE PACKAGE BODY ISMA.PATIMES 
AS

   PROCEDURE SP_TIME2ANNVRSARY
   IS
    daysWTrunc NUMBER;
    daysWOTrunc NUMBER;
    BEGIN
       SELECT TO_DATE('25/10/2016', 'DD/MM/YYYY') - TRUNC(SYSDATE)
       INTO daysWTrunc
       FROM DUAL;
       
       DBMS_OUTPUT.PUT_LINE('Remaining days 2 ours: ' || daysWTrunc);
      
       SELECT TO_DATE('25/10/2016', 'DD/MM/YYYY') - SYSDATE
       INTO daysWOTrunc
       FROM DUAL;  
       DBMS_OUTPUT.PUT_LINE('Remaining days 2 ours: ' || daysWOTrunc);
  END SP_TIME2ANNVRSARY;
  
    PROCEDURE SP_ELAPSEDDAYS
    IS
    daysElapsedWTrunc NUMBER;
    daysElapsedWOTrunc NUMBER;
    ourMonths NUMBER;
     BEGIN
       SELECT TRUNC(SYSDATE) - TO_DATE('25/01/2016', 'DD/MM/YYYY') 
       INTO daysElapsedWTrunc
       FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('Elapsed days from our 1stday: ' || daysElapsedWTrunc);
       
       SELECT SYSDATE - TO_DATE('25/01/2016', 'DD/MM/YYYY')
       INTO daysElapsedWOTrunc
       FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('Elapsed daysfrom our 1stday: ' ||daysElapsedWOTrunc);
       
       SELECT MONTHS_BETWEEN( SYSDATE, TO_DATE('25/01/2016', 'DD/MM/YYYY') )
      INTO ourMonths
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE('Elapsed months with THE ONE : ' || ourMonths);
    END SP_ELAPSEDDAYS;
    
   PROCEDURE WORKHR
   IS
    daysHrWTrunc NUMBER;
    daysHrWOTrunc2 NUMBER;
    months_hr NUMBER;
    
    BEGIN
      SELECT TRUNC(SYSDATE) - TO_DATE('05/05/2016', 'DD/MM/YYYY')
      INTO daysHrWTrunc
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE('Elapsed days here: ' || daysHrWTrunc);

      SELECT SYSDATE  - TO_DATE('05/05/2016', 'DD/MM/YYYY') 
      INTO daysHrWOTrunc2
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE('Elapsed days here: ' || daysHrWOTrunc2);

      SELECT MONTHS_BETWEEN( SYSDATE, TO_DATE('05/05/2016', 'DD/MM/YYYY') ) 
      INTO months_hr
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE('Elapsed months here: ' || months_hr);
    END WORKHR;

   PROCEDURE TRAVELS
   IS
   days2Travl NUMBER;
   BEGIN
      SELECT TO_DATE('29/10/2016','DD/MM/YYYY') - SYSDATE  
      INTO days2Travl
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE('Days to travel: ' || days2Travl);
    END TRAVELS;
END;
/
