/**********************
***********************/
ON FIND OF sevk_emir OVERRIDE DO: END.
ON FIND OF sevk_emirdet OVERRIDE DO: END. 
ON FIND OF stok_kart OVERRIDE DO: END. 
ON FIND OF depo OVERRIDE DO: END. 
ON FIND OF birim OVERRIDE DO: END.
ON FIND OF cari_stokkodu OVERRIDE DO: END.
ON FIND OF cari_kart OVERRIDE DO: END.
ON FIND OF yetki_cari_kart OVERRIDE DO: END.

   DEF TEMP-TABLE SevkEmriDetaylari
      FIELD SevkEmirNo AS CHARACTER FORMAT "X(32)":U  
      FIELD CariKod AS CHARACTER FORMAT "X(32)":U  
      FIELD CariAd AS CHARACTER FORMAT "X(128)":U   
      FIELD MalzemeKod AS CHARACTER FORMAT "X(32)":U  
      FIELD MalzemeAd AS CHARACTER FORMAT "X(32)":U
      FIELD CariMalzemeKod AS CHARACTER FORMAT "X(32)":U  
      FIELD Birim AS CHARACTER FORMAT "X(32)":U  
      FIELD Miktar AS DECIMAL
      FIELD Okunan AS DECIMAL  
      FIELD Kalan AS DECIMAL
      FIELD StokMiktar AS DECIMAL
      FIELD OzelKod AS CHARACTER FORMAT "X(32)":U  
      FIELD DepoKod AS CHARACTER FORMAT "X(32)":U
      FIELD SiparisNo AS CHARACTER FORMAT "X(32)":U
      FIELD SevkEmriId AS INTEGER
      FIELD SevkEmriDetayId AS INTEGER
      FIELD CariId AS INTEGER
      FIELD MalzemeId AS INTEGER
      FIELD BirimId AS INTEGER
      FIELD SiraNo AS INTEGER
      FIELD DepoId AS INTEGER
      FIELD HizmetKartId AS INTEGER
      FIELD TeslimTarih AS CHARACTER FORMAT "X(10)":U
      FIELD Aciklama AS CHARACTER FORMAT "X(64)":U.
        
DEFINE OUTPUT PARAMETER TABLE FOR SevkEmriDetaylari. 

DEFINE INPUT PARAMETER xSevkEmriId AS INTEGER INITIAL 0.
DEFINE INPUT PARAMETER  xSevkEmriNo AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  xDepoStok AS LOGICAL INITIAL FALSE.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.


FIND sevk_emir WHERE sevk_emir.firma_kod = Firma AND sevk_emir.emir_durum EQ TRUE AND sevk_emir.emir_no EQ xSevkEmriNo NO-LOCK NO-ERROR.

IF NOT AVAILABLE sevk_emir THEN DO:     
    MESSAGE "Sevk emri bulunamadi." VIEW-AS ALERT-BOX TITLE "Hata!".     
    RETURN ERROR.
END.

FIND FIRST cari_kart WHERE cari_kart.firma_kod = sevk_emir.firma_kod AND cari_kart.cari_kod = sevk_emir.cari_kod NO-LOCK NO-ERROR.


FOR EACH sevk_emirdet WHERE sevk_emirdet.firma_kod = Firma 
        AND sevk_emirdet.emir_durum EQ TRUE  
        AND sevk_emirdet.emir_no = xSevkEmriNo NO-LOCK,           
    EACH  stok_kart OF sevk_emirdet    
    NO-LOCK ON ERROR UNDO, RETURN ERROR:         

    FIND FIRST birim WHERE birim.firma_kod = sevk_emirdet.firma_kod AND birim.birim = sevk_emirdet.dbirim NO-ERROR.

    IF NOT AVAILABLE birim THEN DO:
        FIND FIRST birim WHERE birim.firma_kod = sevk_emirdet.firma_kod AND birim.birim = stok_kart.birim NO-ERROR.
    END.

    FIND FIRST depo WHERE depo.firma_kod EQ sevk_emirdet.firma_kod AND depo.depo_kod = sevk_emirdet.depo_kod NO-ERROR.

    FIND FIRST siparis_master WHERE siparis_master.firma_kod = sevk_emirdet.firma_kod AND siparis_master.sip_masterno = sevk_emirdet.sip_masterno NO-LOCK NO-ERROR.

    FIND FIRST cari_stokkodu WHERE cari_stokkodu.firma_kod = sevk_emirdet.firma_kod AND cari_stokkodu.cari_kod = sevk_emirdet.cari_kod AND cari_stokkodu.stok_kod = sevk_emirdet.stok_kod NO-LOCK NO-ERROR.

    IF xDepoStok THEN DO:
        FIND FIRST depo_stok WHERE depo_stok.firma_kod = sevk_emirdet.firma_kod AND depo_stok.depo_kod = depo.depo_kod AND depo_stok.stok_kod = sevk_emirdet.stok_kod NO-LOCK NO-ERROR.
    END.

    CREATE SevkEmriDetaylari.
       ASSIGN  
          SevkEmriDetaylari.SevkEmirNo=sevk_emirdet.emir_no
          SevkEmriDetaylari.CariKod=sevk_emirdet.cari_kod
          SevkEmriDetaylari.CariAd=cari_kart.cari_ad
          SevkEmriDetaylari.MalzemeAd = sevk_emirdet.stok_ad
          SevkEmriDetaylari.MalzemeKod = sevk_emirdet.stok_kod
          SevkEmriDetaylari.CariMalzemeKod = IF AVAILABLE cari_stokkodu THEN cari_stokkodu.mstok_kod ELSE ""         
          SevkEmriDetaylari.Birim = IF AVAILABLE birim THEN birim.birim ELSE stok_kart.birim
          SevkEmriDetaylari.SiparisNo = IF AVAILABLE siparis_master THEN siparis_master.sip_no ELSE ""
          SevkEmriDetaylari.Miktar = sevk_emirdet.sevk_miktar - sevk_emirdet.teslim_miktar
          SevkEmriDetaylari.Okunan = 0
          SevkEmriDetaylari.Kalan =  0
          SevkEmriDetaylari.StokMiktar = IF AVAILABLE depo_stok THEN depo_stok.stok_miktar ELSE 0
          SevkEmriDetaylari.OzelKod = sevk_emirdet.ozellik_kod1
          SevkEmriDetaylari.SevkEmriId = sevk_emirdet.semir_masterno
          SevkEmriDetaylari.SevkEmriDetayId = sevk_emirdet.semir_detayno
          SevkEmriDetaylari.CariId = RECID(cari_kart)
          SevkEmriDetaylari.BirimId = IF AVAILABLE birim THEN INT(RECID(birim)) ELSE -1
          SevkEmriDetaylari.MalzemeId = RECID(stok_kart)
          SevkEmriDetaylari.SiraNo = sevk_emirdet.sira_no
          SevkEmriDetaylari.DepoId = INT(RECID(depo))
          SevkEmriDetaylari.HizmetKartId = RECID(stok_kart)         
          SevkEmriDetaylari.TeslimTarih = string(sevk_emirdet.emir_tarih)
          SevkEmriDetaylari.DepoKod = sevk_emirdet.depo_kod
          SevkEmriDetaylari.Aciklama = sevk_emir.aciklama.

        RELEASE SevkEmriDetaylari.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    

    END.

ON FIND OF sevk_emir REVERT.
ON FIND OF sevk_emirdet REVERT. 
ON FIND OF stok_kart REVERT. 
ON FIND OF depo REVERT. 
ON FIND OF birim REVERT.
ON FIND OF cari_stokkodu REVERT.
ON FIND OF cari_kart REVERT.
ON FIND OF yetki_cari_kart REVERT.

