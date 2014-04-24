/**********************
***********************/

ON FIND OF depo OVERRIDE DO: END.
ON FIND OF cari_kart OVERRIDE DO: END.

   DEF TEMP-TABLE Istasyonlar
      FIELD IstasyonId AS INTEGER
      FIELD IstasyonKod AS CHARACTER FORMAT "X(32)":U 
      FIELD IstasyonAd AS CHARACTER FORMAT "X(127)":U 
      FIELD Aciklama AS CHARACTER FORMAT "X(127)":U 
      FIELD FasonIstasyon AS LOGICAL        
      FIELD IsIstasyonTipId AS CHARACTER FORMAT "X(255)":U 
      FIELD CokluUretim AS LOGICAL 
      FIELD ArayaIsSokma AS LOGICAL
      FIELD IsMerkeziId AS INTEGER
      FIELD IsMerkeziKod AS CHARACTER FORMAT "X(255)":U
      FIELD IsMerkeziAd AS CHARACTER FORMAT "X(255)":U
      FIELD DepoId AS INTEGER
      FIELD DepoKod AS CHARACTER 
      FIELD DepoId2 AS INTEGER
      FIELD DepoKod2 AS CHARACTER
      FIELD DepoId3 AS INTEGER
      FIELD DepoKod3 AS CHARACTER
      FIELD CariId AS INTEGER
      FIELD CariKod AS CHARACTER
      FIELD CariAd AS CHARACTER.
      
   
DEFINE OUTPUT PARAMETER TABLE FOR Istasyonlar.

DEFINE INPUT PARAMETER  xKod AS CHARACTER FORMAT "X(40)".
DEFINE INPUT PARAMETER  xAd AS CHARACTER FORMAT "X(80)".
DEFINE INPUT PARAMETER  xFason AS LOGICAL.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.


DEFINE VARIABLE depoId AS INTEGER.
DEFINE VARIABLE depoKod AS CHARACTER.
DEFINE VARIABLE depoId2 AS INTEGER.
DEFINE VARIABLE depoKod2 AS CHARACTER.
DEFINE VARIABLE depoId3 AS INTEGER.
DEFINE VARIABLE depoKod3 AS CHARACTER.

/*malzeme_cikis_depo:depo_kod
ymamul_giris_depo:mdepo_kod
mamul_giris_depo:mdepo_kod2*/

FOR EACH is_istasyon
            WHERE is_istasyon.firma_kod = Firma AND is_istasyon.fason = xFason AND
    ( is_istasyon.istasyon_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND
    ( is_istasyon.istasyon_ad MATCHES "*" + xAd + "*" OR xAd EQ "" )  NO-LOCK,
    EACH is_merkezi OF is_istasyon NO-LOCK /*, EACH cari_kart OF is_istasyon NO-LOCK */
    ON ERROR UNDO, RETURN ERROR:

    /*IF xFason = TRUE THEN IF is_istasyon.fason = FALSE THEN NEXT.*/

    FIND FIRST cari_kart WHERE cari_kart.firma_kod = Firma AND cari_kart.cari_kod = is_istasyon.cari_kod NO-LOCK NO-ERROR.

    FIND FIRST depo WHERE depo.firma_kod = Firma AND depo.depo_kod = is_istasyon.depo_kod NO-LOCK NO-ERROR.
    IF AVAILABLE depo THEN DO:
        depoId = RECID(depo).
        depoKod = depo.depo_kod.
    END.
    ELSE DO:
        depoId = 0.
        depoKod = "".
    END.
    FIND FIRST depo WHERE depo.firma_kod = Firma AND depo.depo_kod = is_istasyon.mdepo_kod NO-LOCK NO-ERROR.
    IF AVAILABLE depo THEN DO:
        depoId2 = RECID(depo).
        depoKod2 = depo.depo_kod.
    END.
    ELSE DO:
        depoId2 = 0.
        depoKod2 = "".
    END.
    FIND FIRST depo WHERE depo.firma_kod = Firma AND depo.depo_kod = is_istasyon.mdepo_kod2 NO-LOCK NO-ERROR.
    IF AVAILABLE depo THEN DO:
        depoId3 = RECID(depo).
        depoKod3 = depo.depo_kod.
    END.
    ELSE DO:
        depoId3 = 0.
        depoKod3 = "".
    END.
    
    CREATE Istasyonlar.
    ASSIGN 
        Istasyonlar.IstasyonId = RECID(is_istasyon)
        Istasyonlar.IstasyonKod = is_istasyon.istasyon_kod
        Istasyonlar.IstasyonAd = is_istasyon.istasyon_ad
        Istasyonlar.FasonIstasyon = is_istasyon.fason
        Istasyonlar.IsMerkeziId = RECID(is_merkezi)
        Istasyonlar.IsMerkeziKod = is_merkezi.ismer_kod
        Istasyonlar.IsMerkeziAd = is_merkezi.ismer_ad
        Istasyonlar.DepoId = depoId
        Istasyonlar.DepoKod = depoKod
        Istasyonlar.DepoId2 = depoId2
        Istasyonlar.DepoKod2 = depoKod2
        Istasyonlar.DepoId3 = depoId3
        Istasyonlar.DepoKod3 = depoKod3
        Istasyonlar.CariId = IF AVAILABLE cari_kart THEN INT(RECID(cari_kart)) ELSE 0
        Istasyonlar.CariKod = IF AVAILABLE cari_kart THEN cari_kart.cari_kod ELSE ""
        Istasyonlar.CariAd = IF AVAILABLE cari_kart THEN cari_kart.cari_ad ELSE "".
    
    Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN LEAVE.            

END.


ON FIND OF depo REVERT.
ON FIND OF cari_kart REVERT.
