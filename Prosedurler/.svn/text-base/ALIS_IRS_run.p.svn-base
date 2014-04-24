
ON FIND OF irsaliye_master  OVERRIDE DO: END.
ON FIND OF irsaliye_detay  OVERRIDE DO: END.
ON FIND OF siparis_sevk  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}


DEF TEMP-TABLE xdetay_table         
            FIELD stok_kod AS CHARACTER FORMAT "X(32)":U        
            FIELD hareket_miktar AS DECIMAL
            FIELD Birim AS CHARACTER FORMAT "X(32)":U        
            FIELD sip_detayno AS INTEGER
            FIELD smaster AS INTEGER
            FIELD PartiNo  AS CHARACTER FORMAT "X(32)":U        
            FIELD SonKul  AS CHARACTER FORMAT "X(32)":U
            FIELD OzKod1  AS CHARACTER FORMAT "X(32)":U
            FIELD Acikla1 AS CHARACTER FORMAT "X(32)":U         
            FIELD Acikla2 AS CHARACTER FORMAT "X(32)":U         
            FIELD Acikla3 AS CHARACTER FORMAT "X(32)":U
            FIELD sira AS INT FORMAT "->>>".
/*INDEX kod412 IS UNIQUE PRIMARY alis_satis belge_tarih)":U
            FIELD acikla1 LIKE irsaliye_master.acikla belge_no cari_kod stok_kod sip_detayno.*/

/***************   local variable   ************************/
DEF VAR trecid AS RECID.
DEF VAR hrecid AS RECID.
DEF VAR xrowid AS ROWID.
DEF VAR xlog-file AS CHAR.
DEF VAR xfile-line AS CHAR.
DEF VAR xkur LIKE dovkur.kur.
DEF VAR xtarih AS DATE.
DEF VAR har-kod2 LIKE entegre.stok_hareket.hareket_kod.

DEF VAR xhareket-tutar LIKE fatura_master.fatura_tutar.
DEF VAR xiskonto-tutar1 LIKE fatura_master.fatura_tutar.
DEF VAR xiskonto-tutar2 LIKE fatura_master.fatura_tutar.
DEF VAR xiskonto-tutar3 LIKE fatura_master.fatura_tutar.
DEF VAR xiskonto-tutar5 LIKE fatura_master.fatura_tutar.
DEF VAR xiskonto-tutar6 LIKE fatura_master.fatura_tutar.
DEF VAR x-xbrc LIKE fatura_master.fatura_tutar.
DEF VAR xkdv-tutar LIKE fatura_master.fatura_tutar.
DEF VAR xdoviz_hareket-tutar LIKE fatura_master.fatura_tutar.

/***************   GIRIS PARAMETRELERI   ************************/


DEFINE INPUT PARAMETER fkod LIKE entegre.firma.firma_kod.
DEFINE INPUT PARAMETER ukod LIKE entegre.uyum_user.user_kod.

DEFINE INPUT PARAMETER bno LIKE irsaliye_master.belge_no.
DEFINE INPUT PARAMETER btarih AS CHARACTER. /*LIKE irsaliye_master.belge_tarih*/
DEFINE INPUT PARAMETER fiilitestlimtarih AS CHARACTER.
DEFINE INPUT PARAMETER alis_satis AS CHARACTER.
DEFINE INPUT PARAMETER cari LIKE irsaliye_master.cari_kod.       
DEFINE INPUT PARAMETER hkod LIKE irsaliye_master.hareket_kod.
DEFINE INPUT PARAMETER Aciklama1 AS CHARACTER FORMAT "X(32)":U.         
DEFINE INPUT PARAMETER Aciklama2 AS CHARACTER FORMAT "X(32)":U.  
DEFINE INPUT PARAMETER TABLE FOR xdetay_table. 

DEFINE OUTPUT PARAMETER master_no AS INTEGER.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER FORMAT "X(128)":U.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + bno + ".txt").

ISLEM-BLOK:
REPEAT:

   /*IF MONTH(NOW)<7 OR MONTH(NOW)>10 THEN DO: 
      MESSAGE "Güvenlik Dolayýsýyla Ýþlem Yapýlamýyor..".
      LEAVE ISLEM-BLOK.
   END.*/



/* Satýþ hareket kodunu kontrol et. 
IF alis_satis = 'A' THEN DO:
    ASSIGN har-kod2 = hkod alis_satis = 'Alýþ'.
    /* Alýþ hareket kodunu kontrol et. */
    FIND hareket_tip WHERE hareket_tip.firma_kod   = firma-kod AND
                           hareket_tip.kaynak_prog = 'Ýrsaliye' AND
                           hareket_tip.hareket_kod = hkod NO-LOCK NO-ERROR.
    IF NOT AVAILABLE hareket_tip THEN DO:
        MESSAGE "Alýþ Ýrsaliye Hareket Kodu Tanýmsýz..." alis_satis " " hkod VIEW-AS ALERT-BOX TITLE "H a t a...".
        LEAVE ISLEM-BLOK.
    END.
END.

IF alis_satis = 'S' THEN DO:
    ASSIGN har-kod2 = hkod alis_satis = 'Satýþ'.
    /* Satýþ hareket kodunu kontrol et. */
    FIND hareket_tip WHERE hareket_tip.firma_kod   = firma-kod AND
                           hareket_tip.kaynak_prog = 'Ýrsaliye' AND
                           hareket_tip.hareket_kod = hkod NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE hareket_tip THEN DO:
        MESSAGE "Satýþ Ýrsaliye Hareket Kodu Tanýmsýz..." alis_satis " " hkod VIEW-AS ALERT-BOX TITLE "H a t a...".
        LEAVE ISLEM-BLOK.
    END.
END.
*/
/* Hareket kodlarýnýn kontrolünün sonu. */

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    /*FIND irsaliye_master WHERE irsaliye_master.firma_kod = firma-kod AND irsaliye_master.irsaliye_aciklama[5] = bno NO-LOCK NO-ERROR.

    IF AVAILABLE irsaliye_master THEN DO:
        MESSAGE "Bu kayýt daha önce aktarýlmýþtýr (" bno ") " VIEW-AS ALERT-BOX TITLE "H a t a !!!".
        RETURN ERROR.
    END.*/

    FOR EACH xdetay_table BREAK BY xdetay_table.sira ON ERROR UNDO, RETURN ERROR:                

        IF FIRST(xdetay_table.sira) THEN DO:

            FIND siparis_master WHERE siparis_master.firma_kod    = firma-kod AND
                                  siparis_master.sip_masterno = xdetay_table.smaster NO-LOCK NO-ERROR.
            IF NOT AVAILABLE siparis_master THEN DO:
                MESSAGE "sipariþ ust bilgisi bulunamadý...." xdetay_table.smaster.
                RETURN ERROR.
            END.

             CREATE irsaliye_master.
             BUFFER-COPY siparis_master TO irsaliye_master
             ASSIGN irsaliye_master.firma_kod            = firma-kod 
                    irsaliye_master.isyeri_kod           = siparis_master.isyeri_kod
                    irsaliye_master.cari_kod             = siparis_master.cari_kod 
                    irsaliye_master.belge_tarih          = DATE(btarih) 
                    irsaliye_master.belge_no             = bno 
                    irsaliye_master.hareket_kod          = hkod
                    irsaliye_master.sevk_tarih           = DATE(fiilitestlimtarih) 
                    irsaliye_master.aciklama             = Aciklama1
                    irsaliye_master.aciklama1            = Aciklama2
                    irsaliye_master.irsaliye_aciklama[1] = siparis_master.siparis_aciklama[1]
                    irsaliye_master.irsaliye_aciklama[2] = siparis_master.siparis_aciklama[2]
                    irsaliye_master.irsaliye_aciklama[3] = siparis_master.siparis_aciklama[3]
                    irsaliye_master.irsaliye_aciklama[4] = "Barset tarafýndan oluþturulmuþtur." /*siparis_master.siparis_aciklama[4]*/
                    irsaliye_master.irsaliye_aciklama[5] = bno /*siparis_master.siparis_aciklama[5]*/
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
                    irsaliye_master.kaynak_masterno      = siparis_master.sip_masterno
                    irsaliye_master.nakliye_firma        = siparis_master.nakliye_firma
                    irsaliye_master.nakliye_tip          = siparis_master.nakliye_tip.
             IF irsaliye_master.plan_kod EQ "" AND siparis_master.vade_gun NE 0 THEN irsaliye_master.vade_tarih = DATE(btarih) + siparis_master.vade_gun.
                 IF siparis_master.vade_tarih NE ? THEN irsaliye_master.vade_tarih = siparis_master.vade_tarih.
                 IF siparis_master.vade_kod NE ""  THEN irsaliye_master.vade_kod   = siparis_master.vade_kod.
                   IF siparis_master.doviz_kod NE "" THEN DO:
                        ASSIGN irsaliye_master.doviz_kod = siparis_master.doviz_kod irsaliye_master.doviz_kur = siparis_master.doviz_kur.
                        xkur = siparis_master.doviz_kur.
                     END.     
                 trecid = RECID(irsaliye_master).

        END. /*IF FIRST(xdetay_table.sira) THEN DO:*/

        MESSAGE "alis irsaliyesi" VIEW-AS ALERT-BOX INFO TITLE "Bilgi".

         FIND irsaliye_master WHERE RECID(irsaliye_master) = trecid NO-ERROR.
         xtarih = irsaliye_master.belge_tarih.
             
         FIND siparis_master WHERE siparis_master.firma_kod = firma-kod AND siparis_master.sip_masterno = xdetay_table.smaster NO-LOCK NO-ERROR .
         
         IF NOT AVAILABLE siparis_master THEN DO:
             MESSAGE "Alýþ/Satýþ Sipariþi Bulunamadý..." STRING(xdetay_table.smaster) " " firma-kod VIEW-AS ALERT-BOX TITLE "H a t a...".
             RETURN ERROR.
         END.
         FIND siparis_detay WHERE siparis_detay.firma_kod    = firma-kod AND
                                         siparis_detay.sip_masterno = xdetay_table.smaster AND
                                         siparis_detay.sip_detayno  = xdetay_table.sip_detayno NO-LOCK NO-ERROR.
         /**/
         IF siparis_detay.iskonto_tutar4 NE 0 THEN DO:
             MESSAGE "Sipariþ Altýnda Ýskonto Yapýlan Sipariþler" SKIP(1)
                 "Bu Menüden Sevk Edilemez..." SKIP(1) VIEW-AS ALERT-BOX TITLE "H a t a...".
                 RETURN ERROR.
         END.

         /* DISPLAY xdetay_table.PartiNo. */

         CREATE irsaliye_detay.
         BUFFER-COPY siparis_detay EXCEPT siparis_detay.dbirim2 siparis_detay.dmiktar2 TO irsaliye_detay.
         ASSIGN irsaliye_detay.firma_kod=firma-kod  
                irsaliye_detay.irsaliye_masterno = irsaliye_master.irsaliye_masterno
                irsaliye_detay.belge_tarih       = irsaliye_master.belge_tarih
                irsaliye_detay.belge_no          = irsaliye_master.belge_no
                irsaliye_detay.cari_kod          = irsaliye_master.cari_kod
                irsaliye_detay.hareket_kod       = irsaliye_master.hareket_kod
                irsaliye_detay.satici_kod        = irsaliye_master.satici_kod
                irsaliye_detay.aciklama          = xdetay_table.Acikla1
                irsaliye_detay.aciklama2         = xdetay_table.Acikla2
                irsaliye_detay.aciklama3         = xdetay_table.Acikla3
                irsaliye_detay.parti_kod         = xdetay_table.PartiNo
                irsaliye_detay.son_kullanma_tarih = date(xdetay_table.SonKul)
                irsaliye_detay.ozellik_kod1     = xdetay_table.OzKod1
                irsaliye_detay.kaynak_prog       = 'Sipariþ'
                irsaliye_detay.kaynak_prog3      = 'Sipariþ'
                irsaliye_detay.fason             = siparis_detay.fason
                irsaliye_detay.isemri_no         = siparis_detay.isemri_no
                irsaliye_detay.operasyon_kod     = siparis_detay.operasyon_kod
                irsaliye_detay.istasyon_kod      = siparis_detay.istasyon_kod
                irsaliye_detay.coklu_parti       = siparis_detay.coklu_parti
                irsaliye_detay.depo_kod          = siparis_detay.depo_kod
                irsaliye_detay.kaynak_masterno   = xdetay_table.smaster
                irsaliye_detay.kaynak_detayno    = xdetay_table.sip_detayno                
                irsaliye_detay.kaynak_detayno2   = xdetay_table.smaster.
         IF irsaliye_master.doviz_kod NE "" THEN DO:
              ASSIGN irsaliye_detay.doviz_kod = irsaliye_master.doviz_kod
                     irsaliye_detay.doviz_kur = irsaliye_master.doviz_kur
                     xkur = irsaliye_master.doviz_kur.
          END.
          /*hesaplayýver ....!*/
          ASSIGN xhareket-tutar = 0 xiskonto-tutar1 = 0 xiskonto-tutar2 = 0 xiskonto-tutar3 = 0 xiskonto-tutar5 = 0 xiskonto-tutar6 = 0 x-xbrc = 0 xkdv-tutar = 0.
          xhareket-tutar = xdetay_table.hareket_miktar * siparis_detay.dfiyat.
          IF siparis_detay.isk_yuzde1 NE 0 THEN xiskonto-tutar1 = siparis_detay.isk_yuzde1 * xhareket-tutar / 100.
            ELSE IF siparis_detay.iskonto_tutar1 NE 0 THEN xiskonto-tutar1 = (siparis_detay.iskonto_tutar1 / siparis_detay.dmiktar) * xdetay_table.hareket_miktar. /* HY ek 13.03.2007 */
            
            IF siparis_detay.isk_yuzde2 NE 0 THEN xiskonto-tutar2 = siparis_detay.isk_yuzde2 * (xhareket-tutar - xiskonto-tutar1) / 100.
            ELSE IF siparis_detay.iskonto_tutar2 NE 0 THEN xiskonto-tutar2 = (siparis_detay.iskonto_tutar2 / siparis_detay.dmiktar) * xdetay_table.hareket_miktar. /* HY ek 13.03.2007 */
            
            IF siparis_detay.isk_yuzde3 NE 0 THEN xiskonto-tutar3 = siparis_detay.isk_yuzde3 * (xhareket-tutar - xiskonto-tutar1 - xiskonto-tutar2) / 100.
            ELSE IF siparis_detay.iskonto_tutar3 NE 0 THEN xiskonto-tutar3 = (siparis_detay.iskonto_tutar3 / siparis_detay.dmiktar) * xdetay_table.hareket_miktar. /* HY ek 13.03.2007 */
            
            IF siparis_detay.isk_yuzde5 NE 0 THEN xiskonto-tutar5 = siparis_detay.isk_yuzde5 * (xhareket-tutar - xiskonto-tutar1 - xiskonto-tutar2
                                                                                                 - xiskonto-tutar3) / 100.    
            IF siparis_detay.isk_yuzde6 NE 0 THEN xiskonto-tutar6 = siparis_detay.isk_yuzde6 * (xhareket-tutar - xiskonto-tutar1 - xiskonto-tutar2
                                                                                                 - xiskonto-tutar3 - xiskonto-tutar5) / 100.    
            
            IF siparis_detay.kdv_yuzde > 0 THEN DO:
                x-xbrc = ROUND(siparis_detay.kdv_yuzde * (xhareket-tutar - xiskonto-tutar1 - xiskonto-tutar2 - xiskonto-tutar3 -
                                                          xiskonto-tutar5 - xiskonto-tutar6) / 100,firma-decimal).
                IF x-xbrc - xkdv-tutar > 3 OR x-xbrc - xkdv-tutar < -3 THEN 
                    xkdv-tutar = ROUND(siparis_detay.kdv_yuzde * ( xhareket-tutar - xiskonto-tutar1 - xiskonto-tutar2 - xiskonto-tutar3
                                                                   - xiskonto-tutar5 - xiskonto-tutar6) / 100,firma-decimal).
            END.
          /*hesaplayýver ....!*/

            
            /*
            FIND stok_birim 
                    WHERE stok_birim.firma_kod EQ fkod 
                            AND stok_birim.stok_kod EQ siparis_detay.stok_kod 
                            AND stok_birim.birim EQ siparis_detay.dbirim.
            
           sip_br_oran = stok_birim.oran / stok_birim.oran2.

           FIND stok_birim 
                    WHERE stok_birim.firma_kod EQ fkod 
                            AND stok_birim.stok_kod EQ siparis_detay.stok_kod 
                            AND stok_birim.birim EQ xdetay_table.birim.
           
           hedef_br_oran = stok_birim.oran / stok_birim.oran2.   

           
           sip_hmiktar = (xdetay_table.hareket_miktar / hedef_br_oran) * sip_br_oran.
           */

            ASSIGN       
              irsaliye_detay.stok_kod            = siparis_detay.stok_kod         
              irsaliye_detay.hesap_ad            = siparis_detay.stok_ad         
              irsaliye_detay.isk_yuzde1          = siparis_detay.isk_yuzde1
              irsaliye_detay.isk_yuzde2          = siparis_detay.isk_yuzde2              
              irsaliye_detay.isk_yuzde3          = siparis_detay.isk_yuzde3 
              irsaliye_detay.isk_yuzde5          = irsaliye_master.isk_yuzde5
              irsaliye_detay.isk_yuzde6          = irsaliye_master.isk_yuzde6
              irsaliye_detay.kdv_yuzde           = siparis_detay.kdv_yuzde
              irsaliye_detay.fiyat_sekli         = siparis_detay.fiyat_sekli
              irsaliye_detay.dfiyat              = siparis_detay.dfiyat
              irsaliye_detay.iskonto_tutar1      = xiskonto-tutar1
              irsaliye_detay.iskonto_tutar2      = xiskonto-tutar2
              irsaliye_detay.iskonto_tutar3      = xiskonto-tutar3
              irsaliye_detay.iskonto_tutar5      = xiskonto-tutar5
              irsaliye_detay.iskonto_tutar6      = xiskonto-tutar6
              irsaliye_detay.kdv_tutar           = xkdv-tutar
              irsaliye_detay.hareket_tutar       = xhareket-tutar
              irsaliye_detay.doviz_kur           = xkur
              irsaliye_detay.doviz_hareket_tutar = xdoviz_hareket-tutar
              irsaliye_detay.doviz_dfiyat        = siparis_detay.doviz_dfiyat
              irsaliye_detay.doviz_kod           = siparis_detay.doviz_kod                          
              irsaliye_detay.dbirim              = siparis_detay.dbirim   
              irsaliye_detay.dmiktar             = xdetay_table.hareket_miktar
              /* irsaliye_detay.dbirim2              = xdetay_table.birim
              irsaliye_detay.dmiktar2             = xdetay_table.hareket_miktar  */
              irsaliye_detay.fason               = siparis_detay.fason
              irsaliye_detay.isemri_no           = siparis_detay.isemri_no
              irsaliye_detay.operasyon_kod       = siparis_detay.operasyon_kod
              irsaliye_detay.istasyon_kod        = siparis_detay.istasyon_kod  
              irsaliye_detay.plan_kod            = siparis_detay.plan_kod
              /* irsaliye_detay.parti_kod           = siparis_detay.parti_no */
              irsaliye_detay.coklu_parti         = siparis_detay.coklu_parti
              irsaliye_detay.kalite_kod          = siparis_detay.kalite_kod
              irsaliye_detay.recete_kod          = siparis_detay.recete_kod
              irsaliye_detay.renk_no             = siparis_detay.renk_no
             /* irsaliye_detay.aciklama            = siparis_detay.aciklama
              irsaliye_detay.aciklama2           = siparis_detay.aciklama2
              irsaliye_detay.aciklama3           = siparis_detay.aciklama3 */
              irsaliye_detay.ambalaj_kod         = siparis_detay.ambalaj_kod
              /* irsaliye_detay.ozellik_kod1        = siparis_detay.ozellik_kod1 */
              /* irsaliye_detay.ozellik_kod2        = siparis_detay.ozellik_kod2
              irsaliye_detay.ozellik_kod3        = siparis_detay.ozellik_kod3 */
              /*irsaliye_detay.seri_no             = xsiparis_detay.seri_no*/
              irsaliye_detay.vade_tarih          = irsaliye_master.vade_tarih.


              IF irsaliye_master.vade_tarih EQ ? AND siparis_detay.vade_gun NE 0 AND
                 irsaliye_master.vade_kod EQ "" THEN irsaliye_detay.vade_tarih = irsaliye_master.belge_tarih + siparis_detay.vade_gun.
              irsaliye_detay.kdv_durumu = siparis_detay.kdv_durumu.
            CREATE siparis_sevk.
            ASSIGN siparis_sevk.firma_kod          = firma-kod
                siparis_sevk.alis_satis         = "Alýþ"
                siparis_sevk.depo_kod           = siparis_master.depo_kod
                siparis_sevk.sevk_miktar        = xdetay_table.hareket_miktar
                siparis_sevk.sipmaster_kayit_no = xdetay_table.smaster               
                siparis_sevk.sipdetay_kayit_no  = xdetay_table.sip_detayno
                siparis_sevk.sipdetay2_kayit_no = xdetay_table.smaster
                siparis_sevk.stok_kod           = siparis_detay.stok_kod
                siparis_sevk.kaynak_prog        = "Ýrsaliye"
                siparis_sevk.kaynak_masterno    = irsaliye_master.irsaliye_masterno
                siparis_sevk.teslim_tarih       = irsaliye_master.belge_tarih.                
                xrowid = ROWID(siparis_sevk).
                FIND siparis_sevk WHERE ROWID(siparis_sevk) = xrowid NO-LOCK NO-ERROR.
             irsaliye_detay.kaynak_detayno3 = siparis_sevk.sipsevk_kayit_no.
             hrecid = RECID(irsaliye_detay).
             RELEASE irsaliye_detay.
             detay_satir = detay_satir + 1.

    END. /*FOR EACH xdetay_table*/

    irsaliye_master.entegre_yap = TRUE.
    master_no = irsaliye_master.irsaliye_masterno.
    trecid = RECID(irsaliye_master).    
END.  /*END TRAN */


IF trecid > 0 THEN DO:
    DISPLAY " kayýt-no =" STRING(trecid) ",detay =" STRING(detay_satir).
END.

LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */

/*IF ERROR-STATUS:ERROR THEN DO:
    FOR EACH irsaliye_master WHERE irsaliye_master.belge_no EQ bno NO-LOCK:
        DISPLAY "Ýç Hata " SKIP(1)
            "firma:" irsaliye_master.firma_kod 
            "cari:" irsaliye_master.cari_kod 
            "belge:" irsaliye_master.belge_no 
            "hareket:" irsaliye_master.hareket_kod.
    END.
END.*/

OUTPUT CLOSE.  /* CIKIS DOSYASINI KAPAT */

ON FIND OF irsaliye_master  REVERT.
ON FIND OF irsaliye_detay  REVERT.
ON FIND OF siparis_sevk  REVERT.

/************<<<<<<LOG KAYDINI ISTEMCIYE EKTARMAK ICIN OKU>>>>>>*********/
INPUT FROM VALUE(SEARCH(barset-log-dir + bno + ".txt") ) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
  SET islem_sonucu = islem_sonucu + xfile-line.  
  END.
INPUT CLOSE.

/************<<<<<<LOG DOSYASI SILINEBILIR>>>>>>*********/
/*OS-DELETE VALUE(xlog-file + bno + ".txt") NO-ERROR.*/




