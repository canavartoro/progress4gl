/**********************
***********************/
ON FIND OF siparis_master OVERRIDE DO: END. 
ON FIND OF cari_kart OVERRIDE DO: END. 
ON FIND OF depo OVERRIDE DO: END. 

   DEF TEMP-TABLE V_Siparisler
      FIELD  SiparisNo  AS CHARACTER FORMAT "X(32)":U  
      FIELD  CariKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  CariAd  AS CHARACTER FORMAT "X(32)":U  
      FIELD  Aciklama  AS CHARACTER FORMAT "X(32)":U  
      FIELD  AlisSatis  AS CHARACTER FORMAT "X(8)":U  
      FIELD  DepoKodu  AS CHARACTER FORMAT "X(32)":U  
      FIELD  SiparisTarihi AS CHARACTER FORMAT "99/99/9999":U
      FIELD  SevkTarihi  AS CHARACTER FORMAT "99/99/9999":U
      FIELD  TeslimTarihi  AS CHARACTER FORMAT "99/99/9999":U
      FIELD  SiparisId  AS INTEGER
      FIELD  CariId  AS INTEGER
      FIELD  DepoId  AS INTEGER.
      
DEFINE OUTPUT PARAMETER TABLE FOR V_Siparisler.

DEFINE INPUT PARAMETER xId AS INTEGER.
DEFINE INPUT PARAMETER xId2 AS INTEGER.
DEFINE INPUT PARAMETER xCariKod AS CHARACTER.
DEFINE INPUT PARAMETER xCariAd AS CHARACTER.
DEFINE INPUT PARAMETER xSipNo AS CHARACTER.
DEFINE INPUT PARAMETER xAlisSatis AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH siparis_master WHERE siparis_master.firma_kod = Firma 
        AND siparis_master.siparis_durumu = TRUE 
        AND siparis_master.Alis_Satis = xAlisSatis
        AND siparis_master.sip_no    BEGINS xSipNo   
        AND siparis_master.cari_kod  BEGINS xCariKod,               
    EACH cari_kart OF siparis_master 
    WHERE  cari_kart.cari_ad  BEGINS xCariAd  NO-LOCK
    ON ERROR UNDO, RETURN ERROR:         

    

    CREATE V_Siparisler.
       ASSIGN  
          V_Siparisler.SiparisNo = sip_no
          V_Siparisler.CariKod  = siparis_master.cari_kod
          V_Siparisler.CariAd  = cari_kart.cari_ad
          V_Siparisler.Aciklama  = aciklama1
          V_Siparisler.AlisSatis  = alis_satis
          V_Siparisler.DepoKodu  = siparis_master.depo_kod
          V_Siparisler.SiparisTarihi = STRING(siparis_master.sip_tarih, "99/99/9999")
          V_Siparisler.SevkTarihi  = STRING(siparis_master.yukleme_tarih, "99/99/9999")
          V_Siparisler.TeslimTarihi  = STRING(siparis_master.teslim_tarih, "99/99/9999")
          V_Siparisler.SiparisId  = siparis_master.sip_masterno
          V_Siparisler.CariId  = RECID(cari_kart)
          V_Siparisler.DepoId  = 0.
         RELEASE V_Siparisler.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    
    END.


OUTPUT CLOSE.

ON FIND OF siparis_master REVERT. 
ON FIND OF cari_kart REVERT. 
ON FIND OF depo REVERT. 
