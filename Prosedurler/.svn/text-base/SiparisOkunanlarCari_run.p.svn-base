/**********************
***********************/
ON FIND OF siparis_detay OVERRIDE DO: END. 
ON FIND OF stok_kart OVERRIDE DO: END. 
ON FIND OF depo OVERRIDE DO: END.
ON FIND OF birim OVERRIDE DO: END.

   DEF TEMP-TABLE V_SiparisOkunanlar     
      FIELD  MalzemeAd  AS CHARACTER FORMAT "X(128)":U  
      FIELD  MalzemeKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  CariMalzemeKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  BirimKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  Miktar  AS DECIMAL
      FIELD  Okunan  AS DECIMAL
      FIELD  Kalan  AS DECIMAL
      FIELD  OzelKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  SiparisId  AS INTEGER
      FIELD  SiparisDetayId  AS INTEGER
      FIELD  CariId  AS INTEGER
      FIELD  BirimId  AS DECIMAL
      FIELD  MalzemeId  AS INTEGER
      FIELD  SiraNo  AS INTEGER
      FIELD  DepoId  AS INTEGER
      FIELD  HizmetKartId  AS INTEGER
      FIELD  SatirTipi  AS INTEGER
      FIELD  TeslimTarihi AS CHARACTER FORMAT "X(12)":U
      FIELD  DepoKod  AS CHARACTER FORMAT "X(32)":U
      FIELD  SiparisNo  AS CHARACTER FORMAT "X(32)":U
      FIELD  FazlaSipMiktar  AS DECIMAL.
   

DEFINE OUTPUT PARAMETER TABLE FOR V_SiparisOkunanlar.

DEFINE INPUT PARAMETER xCariKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xStokKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xStokAd AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xCStokKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xSipNo AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xAlisSatis AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER xDepogoster AS LOGICAL.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH siparis_detay WHERE siparis_detay.firma_kod = Firma 
        AND siparis_detay.siparis_durum = TRUE  
        AND siparis_detay.cari_kod=xCariKod 
        AND siparis_detay.stok_kod BEGINS xStokKod ,          
    EACH  stok_kart OF siparis_detay WHERE alis_satis EQ xAlisSatis AND stok_kart.stok_kod MATCHES  "*" + xStokAd + "*",
    EACH  cari_stokkodu OF stok_kart WHERE cari_stokkodu.cari_kod=xCariKod  AND cari_stokkodu.mstok_kod MATCHES "*" + xCStokKod + "*"
    NO-LOCK ON ERROR UNDO, RETURN ERROR:         

    FIND FIRST birim WHERE birim.firma_kod = siparis_detay.firma_kod AND 
        birim.birim = siparis_detay.dbirim NO-ERROR.


    FIND FIRST depo WHERE depo.firma_kod EQ depo.firma_kod AND 
        depo.depo_kod = siparis_detay.depo_kod NO-ERROR.

   /* DISP siparis_detay.depo_kod.  */

    CREATE V_SiparisOkunanlar.
       ASSIGN  
          MalzemeAd = stok_kart.stok_ad 
          MalzemeKod = siparis_detay.stok_kod
          CariMalzemeKod=cari_stokkodu.mstok_kod          
          BirimKod = siparis_detay.dbirim
          Miktar = siparis_detay.dmiktar - (siparis_detay.sevk_miktar - siparis_detay.red_miktar)
          Okunan = 0
          Kalan =  0
          OzelKod = siparis_detay.ozellik_kod1
          SiparisId = siparis_detay.sip_masterno
          SiparisDetayId = siparis_detay.sip_detayno
          CariId = 0
          BirimId = IF AVAILABLE birim THEN INT(RECID(birim)) ELSE -1
          MalzemeId = RECID(stok_kart)
          SiraNo = siparis_detay.sira_no
          DepoId = IF xDepogoster EQ TRUE THEN INT(RECID(depo)) ELSE 0
          HizmetKartId = 0
          SatirTipi = 0
          SiparisNo=siparis_detay.sip_no
          TeslimTarihi = string(siparis_detay.yukleme_tarih)
          DepoKod = IF xDepogoster EQ TRUE THEN  siparis_detay.depo_kod ELSE ""
          FazlaSipMiktar = stok_kart.fazla_sipyuzde.

        RELEASE V_SiparisOkunanlar.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    

    END.


ON FIND OF siparis_detay REVERT. 
ON FIND OF stok_kart REVERT. 
ON FIND OF depo REVERT.
ON FIND OF birim REVERT.

