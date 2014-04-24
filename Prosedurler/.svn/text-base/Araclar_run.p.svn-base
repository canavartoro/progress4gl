/**********************
***********************/

   DEF TEMP-TABLE Nakliyeciler
      FIELD NakliyeciId AS INTEGER
      FIELD NakliyeciKod AS CHARACTER FORMAT "X(32)":U 
      FIELD AracKod AS CHARACTER FORMAT "X(32)":U 
      FIELD PlakaNo AS CHARACTER FORMAT "X(32)":U 
      FIELD Surucu AS CHARACTER FORMAT "X(32)":U
      FIELD AgirilikKapasite AS DECIMAL 
      FIELD HacimKapasite AS DECIMAL
      FIELD AracTel AS CHARACTER FORMAT "X(20)":U 
      FIELD CepTel AS CHARACTER FORMAT "X(20)":U
      FIELD Acikalama AS CHARACTER FORMAT "X(32)":U.
      
   
DEFINE OUTPUT PARAMETER TABLE FOR Nakliyeciler.

DEFINE INPUT PARAMETER  xId AS INTEGER.
DEFINE INPUT PARAMETER  xNakliyeciKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAracKod AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

ON FIND OF nakliye_arac OVERRIDE DO: END.

FOR EACH nakliye_arac WHERE nakliye_arac.firma_kod = Firma AND 
    (nakliye_arac.nakliyeci_kod BEGINS xNakliyeciKod OR xNakliyeciKod EQ "") AND
    (nakliye_arac.arac_kod BEGINS xAracKod OR  xAracKod EQ "") NO-LOCK ON ERROR UNDO, RETURN ERROR:
    CREATE Nakliyeciler.
    ASSIGN
        Nakliyeciler.NakliyeciId = RECID(nakliye_arac)
        Nakliyeciler.NakliyeciKod = nakliye_arac.nakliyeci_kod
        Nakliyeciler.AracKod = nakliye_arac.arac_kod
        Nakliyeciler.PlakaNo = nakliye_arac.plaka_no
        Nakliyeciler.Surucu = nakliye_arac.surucu
        Nakliyeciler.AgirilikKapasite = nakliye_arac.taskap_kg
        Nakliyeciler.HacimKapasite = nakliye_arac.taskap_hac
        Nakliyeciler.AracTel = nakliye_arac.arac_tel
        Nakliyeciler.CepTel = nakliye_arac.cep_Tel.
    RELEASE Nakliyeciler.

    Row_Limit = Row_Limit + 1.
        
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.

END.

ON FIND OF nakliye_arac REVERT.
