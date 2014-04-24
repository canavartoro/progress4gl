
/**********************
***********************/

   DEF TEMP-TABLE Depolar
      FIELD DepoId AS INTEGER
      FIELD DepoKod AS CHARACTER FORMAT "X(32)":U 
      FIELD DepoAd AS CHARACTER FORMAT "X(32)":U 
      FIELD Aciklama AS CHARACTER FORMAT "X(127)":U 
      FIELD Barkod AS CHARACTER FORMAT "X(127)":U
      FIELD Hurda AS LOGICAL
      FIELD Fason AS LOGICAL
      FIELD EksiStok AS LOGICAL
      FIELD HaricDepo AS LOGICAL.      
         
DEFINE OUTPUT PARAMETER TABLE FOR Depolar.

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAd AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER  xHurda AS LOGICAL INITIAL FALSE.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

DEFINE VARIABLE hareket_id AS INTEGER INITIAL 0.    
    
ON FIND OF depo OVERRIDE DO: END. 
    
FOR EACH depo WHERE depo.firma_kod = Firma AND
    ( depo.depo_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND
    ( depo.depo_ad MATCHES "*" + xAd + "*" OR xAd EQ "" ) AND
    ( depo.aciklama MATCHES "*" + xAciklama + "*" OR xAciklama EQ "") AND
    ( depo.hurda_depo EQ xHurda ) NO-LOCK:
    
    CREATE Depolar.
    ASSIGN 
        Depolar.DepoId = RECID(depo)
        Depolar.DepoKod = depo.depo_kod
        Depolar.DepoAd = depo.depo_ad
        Depolar.Aciklama = depo.aciklama
        Depolar.Barkod = depo.depo_kod
        Depolar.Hurda = depo.hurda_depo
        Depolar.Fason = IF depo.fason EQ "Hayýr" THEN TRUE ELSE FALSE
        Depolar.EksiStok = IF depo.eksi_stok EQ "Hayýr" THEN TRUE ELSE FALSE.           
    RELEASE Depolar.
    
    Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.
END.

ON FIND OF depo REVERT. 
