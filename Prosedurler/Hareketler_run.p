DEF TEMP-TABLE Hareketler
      FIELD  HareketKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HareketAd  AS CHARACTER FORMAT "X(128)":U  
      FIELD  Aciklama  AS CHARACTER FORMAT "X(128)":U  
      FIELD  HareketTur  AS CHARACTER FORMAT "X(32)":U        
      FIELD  OzelKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HedefRaf  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HedefDepo  AS CHARACTER FORMAT "X(32)":U  
      FIELD  KaynakRaf  AS CHARACTER FORMAT "X(32)":U  
      FIELD  KaynakDepo  AS CHARACTER FORMAT "X(32)":U  
      FIELD  GirisCikis  AS CHARACTER FORMAT "X(8)":U
      FIELD  CariZorunlu  AS CHARACTER FORMAT "X(8)":U
      FIELD  IrsaliyeZorunlu  AS LOGICAL
      FIELD  IsemriZorunlu AS CHARACTER FORMAT "X(8)":U
      FIELD  AlisSatis AS CHARACTER FORMAT "X(8)":U
      FIELD  Iade  AS CHARACTER FORMAT "X(8)":U
      FIELD  Fason  AS CHARACTER FORMAT "X(8)":U
      FIELD  HareketTanimId  AS INTEGER
      FIELD  HareketTurId  AS INTEGER
      FIELD  HedefRafId  AS INTEGER
      FIELD  KaynakRafId  AS INTEGER
      FIELD  HedefDepoId  AS INTEGER
      FIELD  KaynakDepoId  AS INTEGER. 
          
DEFINE OUTPUT PARAMETER TABLE FOR Hareketler.

DEFINE INPUT PARAMETER  xHareketKod AS CHARACTER.
DEFINE INPUT PARAMETER  xHareketAd AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER  xAlisSatis AS CHARACTER.
DEFINE INPUT PARAMETER  xKaynakProgram AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

ON FIND OF hareket_tip OVERRIDE DO: END. 
ON FIND OF depo OVERRIDE DO: END. 

FOR EACH hareket_tip
            WHERE hareket_tip.firma_kod EQ Firma  AND  
                  hareket_tip.aktif_pasif EQ "Aktif" AND
                  hareket_tip.alis_satis BEGINS xAlisSatis AND  
                  hareket_tip.kaynak_prog EQ xKaynakProgram AND
                  hareket_tip.hareket_kod BEGINS xHareketKod  AND
                  hareket_tip.hareket_ad  BEGINS  xHareketAd  AND
                  hareket_tip.aciklama    BEGINS  xAciklama
              NO-LOCK ON ERROR UNDO, RETURN ERROR:

        FIND FIRST depo WHERE depo.firma_kod = hareket_tip.firma_kod AND 
        depo.depo_kod = hareket_tip.depo_kod    NO-ERROR.
         
    CREATE Hareketler.
       ASSIGN               
               HareketKod = hareket_tip.hareket_kod
               HareketAd = hareket_tip.hareket_ad 
               Hareketler.Aciklama = hareket_tip.aciklama 
               HareketTur = ""
               OzelKod = hareket_tip.okod1
               HedefRaf = hareket_tip.depo_kod
               HedefDepo = hareket_tip.depo_kod
               KaynakRaf = hareket_tip.depo_kod
               KaynakDepo = hareket_tip.depo_kod
               GirisCikis = hareket_tip.giris_cikis
               CariZorunlu = hareket_tip.cari_baglan
               IrsaliyeZorunlu = hareket_tip.faturalanmasin
               IsemriZorunlu = hareket_tip.uretim_baglan
               AlisSatis = hareket_tip.alis_satis
               Hareketler.Iade = hareket_tip.iade_durum
               Hareketler.Fason = hareket_tip.fason
               HareketTanimId = RECID(hareket_tip) 
               HareketTurId = 0
               HedefRafId = IF AVAILABLE depo THEN INT(RECID(depo)) ELSE 0
               KaynakRafId =IF AVAILABLE depo THEN INT(RECID(depo)) ELSE 0
               HedefDepoId =IF AVAILABLE depo THEN INT(RECID(depo)) ELSE 0
               KaynakDepoId = IF AVAILABLE depo THEN INT(RECID(depo)) ELSE 0.
     RELEASE hareket_tip.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    

    END.

ON FIND OF hareket_tip REVERT. 
ON FIND OF depo REVERT.
