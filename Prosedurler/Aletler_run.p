
 
 
DEF TEMP-TABLE Aletler
      FIELD  AletId  AS INTEGER 
      FIELD  AletKod  AS CHARACTER  
      FIELD  AletAd  AS CHARACTER
      FIELD  Aciklama  AS CHARACTER   
      FIELD  GrupKod  AS CHARACTER         
      FIELD  DepoKod  AS CHARACTER 
      FIELD  RafKod  AS CHARACTER
      FIELD  DemirBasKod  AS CHARACTER.

DEFINE OUTPUT PARAMETER TABLE FOR Aletler.
DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

 FOR EACH platform_master WHERE platform_master.firma_kod = Firma AND 
     ( platform_master.platform_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND 
     ( platform_master.platform_ad MATCHES "*" + xAciklama + "*" OR xAciklama EQ "" ) NO-LOCK:
     CREATE Aletler.
     ASSIGN
         Aletler.AletId = platform_master.platform_masterno
         Aletler.AletKod = platform_master.platform_kod
         Aletler.AletAd = platform_master.platform_ad
         Aletler.Aciklama = platform_master.aciklama
         Aletler.GrupKod = platform_master.grup_kod
         Aletler.DepoKod = platform_master.depo_kod
         Aletler.RafKod = platform_master.raf_kod
         Aletler.DemirBasKod = platform_master.dem_kod.
     RELEASE Aletler.

     Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.
 END.
