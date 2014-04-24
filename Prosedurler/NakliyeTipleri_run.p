/**********************
***********************/
ON FIND OF nakliye_tip OVERRIDE DO: END.

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

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH nakliye_tip WHERE nakliye_tip.firma_kod = Firma AND nakliye_tip.aktif_pasif = "Aktif" NO-LOCK ON ERROR UNDO, RETURN ERROR:
    CREATE Nakliyeciler.
    ASSIGN
        Nakliyeciler.NakliyeciId = RECID(nakliye_tip)
        Nakliyeciler.NakliyeciKod = nakliye_tip.nakliye_tip
        Nakliyeciler.Acikalama = nakliye_tip.aciklama
        Nakliyeciler.PlakaNo = nakliye_tip.plaka
        Nakliyeciler.Surucu = nakliye_tip.sofor.
    RELEASE Nakliyeciler.

    Row_Limit = Row_Limit + 1.
        
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.

END.


ON FIND OF nakliye_tip REVERT.


