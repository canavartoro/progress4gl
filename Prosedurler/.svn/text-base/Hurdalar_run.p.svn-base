
/**********************
***********************/

   DEF TEMP-TABLE Hurdalar
      FIELD HurdaId AS INTEGER
      FIELD HurdaKod AS CHARACTER FORMAT "X(32)":U 
      FIELD HurdaAd AS CHARACTER FORMAT "X(127)":U 
      FIELD HurdaAciklama AS CHARACTER FORMAT "X(127)":U
      FIELD HammaddeTuket AS LOGICAL
      FIELD BilesenHurda AS LOGICAL
      FIELD TransferYap AS LOGICAL
      FIELD HareketId AS INTEGER
      FIELD HareketKod AS CHARACTER FORMAT "X(31)":U.
      
   
DEFINE OUTPUT PARAMETER TABLE FOR Hurdalar.

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAd AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER  xBilesen AS LOGICAL INITIAL FALSE.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0 NO-UNDO.

DEFINE VARIABLE hareket_id AS INTEGER INITIAL 0.    

ON FIND OF hurda_tip  OVERRIDE DO: END.
ON FIND OF hareket_tip  OVERRIDE DO: END.
    
FOR EACH hurda_tip WHERE hurda_tip.firma_kod = Firma AND
    ( hurda_tip.hurda_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND
    ( hurda_tip.hurda_ad MATCHES "*" + xAd + "*" OR xAd EQ "" ) AND
    ( hurda_tip.grub_kod MATCHES "*" + xAciklama + "*" OR xAciklama EQ "") /*AND
    ( hurda_tip.bilesen_hurda EQ xBilesen )*/ NO-LOCK:
    IF hurda_tip.hareket_kod NE "" THEN DO:
        FIND FIRST hareket_tip WHERE hareket_tip.firma_kod = hurda_tip.firma_kod AND hareket_tip.hareket_kod = hurda_tip.hareket_kod NO-LOCK NO-ERROR.
            IF AVAILABLE hareket_tip THEN hareket_id = RECID(hareket_tip). ELSE hareket_id = 0.
    END.

    CREATE Hurdalar.
    ASSIGN 
        Hurdalar.HurdaId = RECID(hurda_tip)
        Hurdalar.HurdaKod = hurda_tip.hurda_kod
        Hurdalar.HurdaAd = hurda_tip.hurda_ad
        Hurdalar.HurdaAciklama = hurda_tip.grub_kod
        Hurdalar.HammaddeTuket = hurda_tip.hammadde_tuket
        Hurdalar.BilesenHurda = hurda_tip.bilesen_hurda
        Hurdalar.TransferYap = hurda_tip.transfer_yap
        Hurdalar.HareketId = hareket_id
        Hurdalar.HareketKod = hurda_tip.hareket_kod.
    RELEASE Hurdalar.
    
    Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.
END.

ON FIND OF hurda_tip  REVERT.
ON FIND OF hareket_tip  REVERT.


