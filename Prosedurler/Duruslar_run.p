

/**********************
***********************/

   DEF TEMP-TABLE Duruslar
      FIELD DurusId AS INTEGER
      FIELD DurusKod AS CHARACTER /*FORMAT "X(32)":U*/ 
      FIELD DurusAd AS CHARACTER /*FORMAT "X(127)":U */
      FIELD IsEmriBaglanti AS LOGICAL
      FIELD DurusTip AS CHARACTER /*FORMAT "X(32)":U*/.
      
DEFINE OUTPUT PARAMETER TABLE FOR Duruslar.

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAd AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH erp_durustip WHERE erp_durustip.firma_kod = Firma AND
    ( erp_durustip.durus_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND
    ( erp_durustip.durus_ad MATCHES "*" + xAd + "*" OR xAd EQ "" ) NO-LOCK:    

    CREATE Duruslar.
    ASSIGN 
        Duruslar.DurusId = RECID(erp_durustip)
        Duruslar.DurusKod = erp_durustip.durus_kod
        Duruslar.DurusAd = erp_durustip.durus_ad
        Duruslar.IsEmriBaglanti = erp_durustip.isemri_baglanti
        Duruslar.DurusTip = erp_durustip.durus_statu.
    RELEASE Duruslar.

    Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.
END.



