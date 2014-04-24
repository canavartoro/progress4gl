
DEF TEMP-TABLE Vardiyalar
      FIELD  VardiyaId  AS INTEGER 
      FIELD  VardiyaKod  AS CHARACTER  
      FIELD  Aciklama  AS CHARACTER   
      FIELD  TakvimKod  AS CHARACTER         
      FIELD  Baslangic  AS INTEGER 
      FIELD  Bitis  AS INTEGER   
      FIELD  NetSure  AS INTEGER 
      FIELD  Baslangic2  AS CHARACTER  
      FIELD  Bitis2  AS CHARACTER  
      FIELD  BrutSure  AS INTEGER.

DEFINE OUTPUT PARAMETER TABLE FOR Vardiyalar.

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

 FOR EACH uvardiya WHERE uvardiya.firma_kod = Firma AND 
     ( uvardiya.vardiya_kod MATCHES "*" + xKod + "*" OR xKod EQ "" ) AND 
     ( uvardiya.vardiya_ad MATCHES "*" + xAciklama + "*" OR xAciklama EQ "" ) NO-LOCK:
     CREATE Vardiyalar.
     ASSIGN
         Vardiyalar.VardiyaId = RECID(uvardiya)
         Vardiyalar.VardiyaKod = uvardiya.vardiya_kod
         Vardiyalar.Aciklama = uvardiya.vardiya_ad
         Vardiyalar.TakvimKod = uvardiya.takvim_kod
         Vardiyalar.Baslangic = uvardiya.bas_zaman
         Vardiyalar.Bitis = uvardiya.bitis_zaman
         Vardiyalar.NetSure = uvardiya.net_sure
         Vardiyalar.Baslangic2 = uvardiya.bas_zaman2
         Vardiyalar.Bitis2 = uvardiya.bitis_zaman2
         Vardiyalar.BrutSure = uvardiya.brut_sure.
     RELEASE Vardiyalar.

     Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.
 END.

