/*********************************************************************************
Sevk emrinden irsaliye oluþturmak için yazýlmýþtýr
                          < Canavar.Toro >
30 Mayýs 2011 Pazartesi   20:39
*********************************************************************************/

ON FIND OF irsaliye_master  OVERRIDE DO: END.
ON FIND OF irsaliye_detay  OVERRIDE DO: END.
ON FIND OF siparis_sevk  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}


DEF TEMP-TABLE xsevk_table 
            FIELD semir_masterno LIKE sevk_emirdet.semir_masterno
            FIELD semir_detayno LIKE sevk_emirdet.semir_detayno
            FIELD dmiktar LIKE siparis_detay.dmiktar
            FIELD partino AS CHARACTER.
            /*INDEX kod412 IS UNIQUE PRIMARY alis_satis belge_tarih belge_no cari_kod stok_kod sip_detayno.*/

/***************   local variable   ************************/

DEFINE VARIABLE xrowid AS ROWID.
DEFINE VARIABLE xfile-line AS CHARACTER.

/***************************alt toplamlar aqoim*****************************/
DEFINE VARIABLE maltutar LIKE irsaliye_master.mal_tutar.
DEFINE VARIABLE irstutar LIKE irsaliye_master.irsaliye_tutar.
DEFINE VARIABLE kdvtutar LIKE irsaliye_master.kdv_tutar.
DEFINE VARIABLE mal-tutar LIKE irsaliye_master.mal_tutar.
DEFINE VARIABLE irs-tutar LIKE irsaliye_master.irsaliye_tutar.
DEFINE VARIABLE kdv-tutar LIKE irsaliye_master.kdv_tutar.
/***************   giriþ parametreleri   ************************/

DEFINE INPUT PARAMETER fkod LIKE entegre.firma.firma_kod.
DEFINE INPUT PARAMETER ukod LIKE entegre.uyum_user.user_kod.

DEFINE INPUT PARAMETER bno LIKE irsaliye_master.belge_no.
DEFINE INPUT PARAMETER btarih AS CHARACTER. /*LIKE irsaliye_master.belge_tarih*/
DEFINE INPUT PARAMETER fiilitestlimtarih AS CHARACTER.
DEFINE INPUT PARAMETER hkod LIKE irsaliye_master.hareket_kod.
DEFINE INPUT PARAMETER nakliyetip LIKE irsaliye_master.nakliye_tip.
DEFINE INPUT PARAMETER nakliyecikod LIKE irsaliye_master.nakliyeci_kod.
DEFINE INPUT PARAMETER arackod LIKE irsaliye_master.arac_kod.
DEFINE INPUT PARAMETER aciklama AS CHARACTER.
DEFINE INPUT PARAMETER s_adres1 LIKE irsaliye_master.sevk_adres1 INITIAL "".
DEFINE INPUT PARAMETER s_adres2 LIKE irsaliye_master.sevk_adres2 INITIAL "".
DEFINE INPUT PARAMETER s_adres3 LIKE irsaliye_master.sevk_adres3 INITIAL "".    
DEFINE INPUT PARAMETER TABLE FOR xsevk_table. 

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + bno + ".txt").

ISLEM-BLOK:
REPEAT:


DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND irsaliye_master WHERE irsaliye_master.firma_kod = firma-kod AND irsaliye_master.irsaliye_aciklama[1] = bno NO-LOCK NO-ERROR.

        IF AVAILABLE irsaliye_master THEN DO:
            MESSAGE "Bu kayýt daha önce aktarýlmýþtýr (" bno ") " VIEW-AS ALERT-BOX ERROR TITLE "H a t a !!!".
            RETURN ERROR.
        END. 
        
FOR EACH xsevk_table BREAK BY xsevk_table.semir_masterno /*BY xsevk_table.semir_masterno*/ ON ERROR UNDO, RETURN ERROR:                     
            
        FIND sevk_emirdet WHERE sevk_emirdet.firma_kod      = firma-kod AND
                                sevk_emirdet.semir_masterno = xsevk_table.semir_masterno AND
                                sevk_emirdet.semir_detayno  = xsevk_table.semir_detayno EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE sevk_emirdet THEN DO:
            FIND siparis_detay WHERE siparis_detay.firma_kod    = firma-kod AND
                                 siparis_detay.sip_masterno = sevk_emirdet.sip_masterno AND
                                 siparis_detay.sip_detayno  = sevk_emirdet.sip_detayno NO-LOCK NO-ERROR.
            IF NOT AVAILABLE siparis_detay THEN DO:
                MESSAGE "Siparis Bilgisi Bulunamadý..." sevk_emirdet.sip_masterno VIEW-AS ALERT-BOX ERROR TITLE "H a t a...".
                RETURN ERROR.
            END.
        END.
            
        IF FIRST(xsevk_table.semir_masterno) THEN DO:

                /*DISPLAY firma-kod  xsevk_table.sip_masterno xsevk_table.sip_detayno  SKIP.*/
                
                FIND FIRST siparis_master WHERE siparis_master.firma_kod = firma-kod AND
                                     siparis_master.sip_masterno = sevk_emirdet.sip_masterno NO-LOCK NO-ERROR.

                IF NOT AVAILABLE siparis_master THEN DO:                
                    MESSAGE "Siparis Bilgisi Bulunamadý..." sevk_emirdet.sip_masterno VIEW-AS ALERT-BOX ERROR TITLE "H a t a...".
                    RETURN ERROR.
                END.
                    
                CREATE irsaliye_master.
                BUFFER-COPY siparis_master TO irsaliye_master.
                ASSIGN 
                           irsaliye_master.firma_kod            = firma-kod 
                           irsaliye_master.cari_kod             = siparis_master.cari_kod 
                           irsaliye_master.belge_tarih          = DATE(btarih)
                           irsaliye_master.belge_no             = bno 
                           irsaliye_master.hareket_kod          = hkod
                           irsaliye_master.sevk_tarih           = DATE(fiilitestlimtarih)
                           irsaliye_master.aciklama             = aciklama
                           irsaliye_master.aciklama1            = siparis_master.aciklama
                           irsaliye_master.irsaliye_aciklama[1] = bno
                           irsaliye_master.irsaliye_aciklama[2] = siparis_master.siparis_aciklama[2]
                           irsaliye_master.irsaliye_aciklama[3] = siparis_master.siparis_aciklama[3]
                           irsaliye_master.irsaliye_aciklama[4] = siparis_master.siparis_aciklama[4]
                           irsaliye_master.irsaliye_aciklama[5] = siparis_master.siparis_aciklama[5]
                           irsaliye_master.irsaliye_aciklama[6] = siparis_master.siparis_aciklama[6]
                           irsaliye_master.fatura_adres1        = siparis_master.fatura_adres1
                           irsaliye_master.fatura_adres2        = siparis_master.fatura_adres2
                           irsaliye_master.fatura_adres3        = siparis_master.fatura_adres3
                           irsaliye_master.sevk_adres1          = siparis_master.sevk_adres1
                           irsaliye_master.sevk_adres2          = siparis_master.sevk_adres2
                           irsaliye_master.sevk_adres3          = siparis_master.sevk_adres3
                           irsaliye_master.isk_yuzde5           = siparis_master.isk_yuzde5
                           irsaliye_master.isk_yuzde6           = siparis_master.isk_yuzde6
                           irsaliye_master.okod1                = siparis_master.okod1
                           irsaliye_master.okod2                = siparis_master.okod2
                           irsaliye_master.satici_kod           = siparis_master.satici_kod
                           irsaliye_master.kaynak_prog          = "Sipariþ"
                           irsaliye_master.kaynak_prog3         = "Sipariþ"
                           irsaliye_master.plan_kod             = siparis_master.plan_kod
                           irsaliye_master.nakliye_tip          = nakliyetip   
                           irsaliye_master.nakliyeci_kod        = nakliyecikod 
                           irsaliye_master.arac_kod             = arackod   
                           irsaliye_master.doviz_kod            = siparis_master.doviz_kod
                           irsaliye_master.doviz_kur            = siparis_master.doviz_kur
                           irsaliye_master.sozlesme_kod         = siparis_master.sozlesme_kod
                           irsaliye_master.entegre_yap          = FALSE.
                    IF irsaliye_master.plan_kod EQ "" THEN irsaliye_master.vade_tarih = DATE(btarih) + siparis_master.vade_gun.
                    IF siparis_master.vade_tarih NE ? THEN irsaliye_master.vade_tarih = siparis_master.vade_tarih.
                    IF siparis_master.vade_kod NE "" THEN irsaliye_master.vade_kod = siparis_master.vade_kod.
                        
                    IF s_adres1 NE "" THEN DO:
                        ASSIGN irsaliye_master.sevk_adres1   = s_adres1
                          irsaliye_master.sevk_adres2        = s_adres2
                          irsaliye_master.sevk_adres3        = s_adres3
                          irsaliye_master.firma_kod          = firma-kod.
                    END.
                        
                     IF s_adres1 EQ "" THEN DO:   
                        FIND sevk_emir WHERE sevk_emir.firma_kod EQ sevk_emirdet.firma_kod AND
                                          sevk_emir.semir_masterno EQ sevk_emirdet.semir_masterno NO-LOCK NO-ERROR.
                        IF AVAIL sevk_emir AND (sevk_emir.scari_kod NE "" OR sevk_emir.adres_tip NE "" OR sevk_emir.sevk_adres1 NE "" 
                                              OR sevk_emir.sevk_adres2 NE "" OR sevk_emir.sevk_adres3 NE "" ) THEN DO:

                            ASSIGN irsaliye_master.scari_kod          = sevk_emir.scari_kod
                                   irsaliye_master.adres_tip          = sevk_emir.adres_tip
                                   irsaliye_master.sevk_adres1        = sevk_emir.sevk_adres1
                                   irsaliye_master.sevk_adres2        = sevk_emir.sevk_adres2
                                   irsaliye_master.sevk_adres3        = sevk_emir.sevk_adres3.
                        END. /* sevk emirden gelecek */
                        ELSE IF ( NOT (AVAIL sevk_emir AND (sevk_emir.scari_kod NE "" OR sevk_emir.adres_tip NE "" OR sevk_emir.sevk_adres1 NE "" 
                                              OR sevk_emir.sevk_adres2 NE "" OR sevk_emir.sevk_adres3 NE "" ))) AND AVAIL siparis_master THEN  DO:
                            ASSIGN irsaliye_master.scari_kod       = siparis_master.scari_kod
                                irsaliye_master.adres_tip          = siparis_master.adres_tip
                                irsaliye_master.sevk_adres1        = siparis_master.sevk_adres1
                                irsaliye_master.sevk_adres2        = siparis_master.sevk_adres2
                                irsaliye_master.sevk_adres3        = siparis_master.sevk_adres3.
                        END.  /* siparisten gelecek */
                    END.  /*IF s_adres1 EQ ""*/  
                        
                    xrecid = RECID(irsaliye_master).
                    /*ASSIGN master_no = DEC(xrecid).*/
                    RELEASE irsaliye_master.                    
        END. /*IF FIRST*/

        FIND irsaliye_master WHERE RECID(irsaliye_master) = xrecid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE irsaliye_master THEN DO:
            MESSAGE "Irsaliye bilgilerinde hata var SevkEmriSevk_run RECID(irsaliye_master) = xrecid" VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
            RETURN ERROR.
        END.

        FIND FIRST siparis_master WHERE siparis_master.firma_kod = firma-kod AND
                                     siparis_master.sip_masterno = sevk_emirdet.sip_masterno NO-LOCK NO-ERROR.

         IF NOT AVAILABLE siparis_master THEN DO:                
                    MESSAGE "Siparis Bilgisi Bulunamadý..." sevk_emirdet.sip_masterno VIEW-AS ALERT-BOX ERROR TITLE "H a t a...".
                    RETURN ERROR.
         END.        

        FIND FIRST cari_stokkodu WHERE cari_stokkodu.firma_kod = firma-kod AND cari_stokkodu.cari_kod = irsaliye_master.cari_kod AND cari_stokkodu.stok_kod = siparis_detay.stok_kod NO-LOCK NO-ERROR.

        CREATE irsaliye_detay.
        ASSIGN irsaliye_detay.firma_kod=firma-kod  
               irsaliye_detay.irsaliye_masterno = irsaliye_master.irsaliye_masterno
               irsaliye_detay.belge_tarih       = irsaliye_master.belge_tarih
               irsaliye_detay.belge_no          = irsaliye_master.belge_no
               irsaliye_detay.cari_kod          = irsaliye_master.cari_kod
               irsaliye_detay.hareket_kod       = irsaliye_master.hareket_kod
               irsaliye_detay.satici_kod        = irsaliye_master.satici_kod
               irsaliye_detay.aciklama          = irsaliye_master.aciklama
               irsaliye_detay.kaynak_prog       = "Sipariþ"
               irsaliye_detay.kaynak_prog3      = "Sipariþ"
               irsaliye_detay.depo_kod          = siparis_detay.depo_kod
               irsaliye_detay.kaynak_masterno   = sevk_emirdet.sip_masterno
               irsaliye_detay.kaynak_detayno    = sevk_emirdet.sip_detayno
               irsaliye_detay.fiyat_sekli       = siparis_detay.fiyat_sekli
               irsaliye_detay.ozellik_kod1      = siparis_detay.ozellik_kod1
               irsaliye_detay.ozellik_kod2      = siparis_detay.ozellik_kod2
               irsaliye_detay.ozellik_kod3      = siparis_detay.ozellik_kod3
               irsaliye_detay.okod1             = siparis_detay.okod1
               irsaliye_detay.okod2             = siparis_detay.okod2
               irsaliye_detay.sozlesme_kod      = irsaliye_master.sozlesme_kod            
               irsaliye_detay.stok_kod   = siparis_detay.stok_kod
               irsaliye_detay.mstok_kod  = IF AVAILABLE cari_stokkodu THEN cari_stokkodu.mstok_kod ELSE ""
               irsaliye_detay.isk_yuzde1 = siparis_detay.isk_yuzde1
               irsaliye_detay.isk_yuzde2 = siparis_detay.isk_yuzde2              
               irsaliye_detay.isk_yuzde3 = siparis_detay.isk_yuzde3 
               irsaliye_detay.isk_yuzde5 = siparis_detay.isk_yuzde5              
               irsaliye_detay.isk_yuzde6 = siparis_detay.isk_yuzde6
               irsaliye_detay.kdv_yuzde  = siparis_detay.kdv_yuzde
               irsaliye_detay.dfiyat     = siparis_detay.dfiyat
               irsaliye_detay.dmiktar    = xsevk_table.dmiktar
               irsaliye_detay.dbirim     = siparis_detay.dbirim
               irsaliye_detay.plan_kod   = siparis_detay.plan_kod
               irsaliye_detay.parti_kod  = xsevk_table.partino
               irsaliye_detay.vade_tarih = irsaliye_master.vade_tarih
               irsaliye_detay.aciklama   = siparis_detay.aciklama.           
            
         IF irsaliye_master.vade_tarih NE ? AND siparis_detay.vade_gun NE 0 THEN 
              irsaliye_detay.vade_tarih = irsaliye_master.belge_tarih + siparis_detay.vade_gun.
              irsaliye_detay.kdv_durumu = siparis_detay.kdv_durumu.
        /*******************alt toplam hesaplaam*******************/
         IF siparis_detay.fiyat_sekli = TRUE THEN DO:
             maltutar = xsevk_table.dmiktar * siparis_detay.dfiyat.
            kdvtutar = siparis_detay.kdv_yuzde * maltutar / 100.
            irstutar = maltutar + kdvtutar.
    
            mal-tutar = mal-tutar + maltutar.
            kdv-tutar = kdv-tutar + kdvtutar.
            irs-tutar = irs-tutar + irstutar.
         END.
                
         CREATE siparis_sevk.
         ASSIGN siparis_sevk.firma_kod          = firma-kod
               siparis_sevk.alis_satis         = "Satýþ"
               siparis_sevk.depo_kod           = siparis_master.depo_kod
               siparis_sevk.sevk_miktar        = xsevk_table.dmiktar
               siparis_sevk.sipmaster_kayit_no = sevk_emirdet.sip_masterno               
               siparis_sevk.sipdetay_kayit_no  = sevk_emirdet.sip_detayno
               siparis_sevk.stok_kod           = siparis_detay.stok_kod
               siparis_sevk.kaynak_prog        = "Ýrsaliye"
               siparis_sevk.kaynak_masterno    = irsaliye_master.irsaliye_masterno
               siparis_sevk.teslim_tarih       = irsaliye_master.belge_tarih
               siparis_sevk.sevk_emir          = TRUE
               siparis_sevk.semir_masterno     = xsevk_table.semir_masterno
               siparis_sevk.semir_detayno      = xsevk_table.semir_detayno
               siparis_sevk.sozlesme_kod = siparis_master.sozlesme_kod.
            
          xrowid = rowid(siparis_sevk).
            
          sevk_emirdet.teslim_miktar = sevk_emirdet.teslim_miktar + xsevk_table.dmiktar. 
            
          FIND siparis_sevk WHERE ROWID(siparis_sevk) = xrowid NO-LOCK  NO-ERROR.
          irsaliye_detay.kaynak_detayno3 = siparis_sevk.sipsevk_kayit_no.
          RELEASE irsaliye_detay.
          detay_satir = detay_satir + 1.
END.

irsaliye_master.mal_tutar            = mal-tutar.
irsaliye_master.kdv_tutar            = kdv-tutar.
irsaliye_master.irsaliye_tutar       = irs-tutar.
master_no = irsaliye_master.irsaliye_masterno.
irsaliye_master.entegre_yap = TRUE.

    /*irsaliye_master.entegre_yap = TRUE.*/
END.  /*END TRAN */
    
IF xrecid > 0 THEN DO:
  /*  DISPLAY " kayýt-no =" STRING(xrecid) ",detay =" STRING(detay_satir).  */
   DISPLAY " kayýt-no : " STRING(xrecid) " kayit:" STRING(master_no) bno.   
END.

DISPLAY " detaylar : " STRING(detay_satir).
  
SET islem_sonucu =   STRING(xrecid).

LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */

OUTPUT CLOSE.  /* çýkýþ dosyasýný kapat */

ON FIND OF irsaliye_master REVERT.
ON FIND OF irsaliye_detay REVERT.
ON FIND OF siparis_sevk REVERT.


