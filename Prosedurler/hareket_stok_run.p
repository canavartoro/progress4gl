/*********************************************************************************
Stok hareket kaydý oluþturmak için yazýlmýþtýr
                          < Canavar.Toro >
05 Ocak 2011 Perþembe   01:00
                    Hamidiye

*********************************************************************************/

ON FIND OF stok_hareket  OVERRIDE DO: END.
ON FIND OF stok_master  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE xhareket_table         
            FIELD stok_kod LIKE stok_kart.stok_kod
            FIELD giren_depo LIKE stok_master.diger_depo
            FIELD cikan_depo LIKE stok_hareket.depo_kod
            FIELD miktar LIKE stok_hareket.hareket_miktar
            FIELD gelir_gider   LIKE stok_hareket.gelirgider_kod
            FIELD masraf_ad   LIKE stok_hareket.masraf_ad
            FIELD masraf_merkez   LIKE stok_hareket.masraf_merkez
            FIELD analiz_kod   LIKE stok_hareket.analiz_kod
            FIELD parti_kod   LIKE stok_hareket.parti_kod
            FIELD cari   LIKE stok_hareket.cari_kod.
            /*INDEX kod412 IS UNIQUE PRIMARY alis_satis belge_tarih belge_no cari_kod stok_kod sip_detayno.*/

/***************   local variable   ************************/
                         
DEF VAR x5recid AS RECID.
DEF VAR xrowid AS ROWID.

DEF TEMP-TABLE xstok_master4
  FIELD belge_tarih LIKE stok_master.belge_tarih 
  FIELD hareket_kod LIKE stok_master.hareket_kod
  FIELD depo_kod    LIKE stok_hareket.depo_kod 
  FIELD diger_depo  LIKE stok_master.diger_depo 
  FIELD belge_no    LIKE stok_master.belge_no
  FIELD carikod   LIKE stok_hareket.cari_kod
INDEX stk IS UNIQUE PRIMARY  belge_tarih hareket_kod depo_kod diger_depo belge_no.

DEF TEMP-TABLE xstok_detay4
FIELD belge_tarih LIKE stok_master.belge_tarih
FIELD hareket_kod LIKE stok_master.hareket_kod
FIELD depo_kod    LIKE stok_hareket.depo_kod 
FIELD diger_depo  LIKE stok_master.diger_depo 
FIELD belge_no    LIKE stok_master.belge_no
FIELD stok_kod    LIKE stok_hareket.stok_kod
FIELD miktar      LIKE stok_hareket.dmiktar
FIELD parti_kod   LIKE stok_hareket.parti_kod
FIELD gelir_gider   LIKE stok_hareket.gelirgider_kod
FIELD masraf_ad   LIKE stok_hareket.masraf_ad
FIELD masraf_merkez   LIKE stok_hareket.masraf_merkez
FIELD analiz_kod   LIKE stok_hareket.analiz_kod
INDEX stk1 IS UNIQUE PRIMARY  belge_tarih hareket_kod depo_kod diger_depo belge_no stok_kod parti_kod.


/***************   giriþ parametreleri   ************************/

DEFINE INPUT PARAMETER fkod LIKE entegre.firma.firma_kod.
DEFINE INPUT PARAMETER ukod LIKE entegre.uyum_user.user_kod.

DEFINE INPUT PARAMETER bno LIKE stok_master.belge_no.     
DEFINE INPUT PARAMETER btarih AS CHARACTER. /*LIKE irsaliye_master.belge_tarih*/
DEFINE INPUT PARAMETER hkod LIKE stok_master.hareket_kod.
DEFINE INPUT PARAMETER aciklama LIKE stok_master.aciklama2.
DEFINE INPUT PARAMETER TABLE FOR xhareket_table. 

DEFINE OUTPUT PARAMETER master_no LIKE stok_master.stok_masterno.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + bno + ".txt").

DEFINE VARIABLE xMasterKayit AS LOGICAL INITIAL FALSE.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR: 

    /* barset hareket tablosu uzerinde donuluyor.. kayýtlarý kontrol etmek için.*/
    FOR EACH xhareket_table ON ERROR UNDO, RETURN ERROR :
        
        FIND stok_kart WHERE firma_kod = firma-kod AND stok_kart.stok_kod = xhareket_table.stok_kod NO-LOCK NO-ERROR.

        IF NOT AVAILABLE stok_kart THEN DO:
            islem_sonucu = "Stok Kodu Bulunamadý:" + xhareket_table.stok_kod.
            MESSAGE "Stok Kodu Bulunamadý:" xhareket_table.stok_kod VIEW-AS ALERT-BOX TITLE "U y a r ý...".
            RETURN ERROR.  
        END.  

        FIND depo WHERE depo.firma_kod = firma-kod AND depo_kod = xhareket_table.cikan_depo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE depo THEN DO:
            islem_sonucu = "Depo Kodu Bulunamadý:" + xhareket_table.cikan_depo.
            MESSAGE "Depo Kodu Bulunamadý:" xhareket_table.cikan_depo VIEW-AS ALERT-BOX TITLE "U y a r ý...".            
            RETURN ERROR.  
        END.

        IF AVAIL depo THEN DO:
            IF AVAIL stok_kart THEN DO:
                FIND depo_stok WHERE depo_stok.firma_kod = firma-kod AND depo_stok.depo_kod  = xhareket_table.cikan_depo AND depo_stok.stok_kod  = xhareket_table.stok_kod NO-LOCK NO-ERROR .
                IF NOT AVAILABLE depo_stok THEN DO:
                    islem_sonucu = "Depo Stok Kaydý Bulunamadý(*):" + xhareket_table.cikan_depo  + " Stok: " + xhareket_table.stok_kod.
                    MESSAGE "Depo Stok Kaydý Bulunamadý(*):" xhareket_table.cikan_depo ", Stok:" xhareket_table.stok_kod VIEW-AS ALERT-BOX TITLE "B i l g i...".
                    RETURN ERROR.                    
                END.
            END.
        END.

        FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = xhareket_table.giren_depo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE depo THEN DO:
            islem_sonucu = "Depo Kodu Bulunamadý:" + xhareket_table.giren_depo.
            MESSAGE "Depo Kodu Bulunamadý:" xhareket_table.giren_depo VIEW-AS ALERT-BOX TITLE "U y a r ý...".
            RETURN ERROR.
        END.

        FIND xstok_master4 WHERE xstok_master4.belge_tarih = DATE(btarih)
                             AND xstok_master4.hareket_kod = hkod
                             AND xstok_master4.depo_kod    = xhareket_table.cikan_depo
                             AND xstok_master4.diger_depo  = xhareket_table.giren_depo
                             AND xstok_master4.belge_no    = bno NO-ERROR.

        IF NOT AVAILABLE xstok_master4 THEN DO:

            IF xMasterKayit THEN DO:
                MESSAGE "Belge de hata var ust bilgileri kontrol edin! " SKIP
                    "Hareket Kod:" hkod ", Depo Kod:" xhareket_table.cikan_depo SKIP
                    "Diger Depo:" xhareket_table.giren_depo ", Belge No:" bno VIEW-AS ALERT-BOX ERROR.
                RETURN ERROR.
            END.
    
            CREATE xstok_master4.
                   xstok_master4.belge_tarih = DATE(btarih). 
                   xstok_master4.hareket_kod = hkod.
                   xstok_master4.depo_kod    = xhareket_table.cikan_depo. 
                   xstok_master4.diger_depo  = xhareket_table.giren_depo.
                   xstok_master4.carikod     = xhareket_table.cari.
                   xstok_master4.belge_no    = bno.
                   xMasterKayit = TRUE.
        END.

        FIND xstok_detay4 WHERE xstok_detay4.belge_tarih = DATE(btarih)
                            AND xstok_detay4.hareket_kod = hkod
                            AND xstok_detay4.depo_kod    = xhareket_table.cikan_depo
                            AND xstok_detay4.diger_depo  = xhareket_table.giren_depo
                            AND xstok_detay4.belge_no    = bno
                            AND xstok_detay4.stok_kod    = xhareket_table.stok_kod 
                            AND xstok_detay4.parti_kod    = xhareket_table.parti_kod NO-ERROR.

        IF NOT AVAILABLE xstok_detay4 THEN DO:
    
              CREATE xstok_detay4.
                     xstok_detay4.belge_tarih = DATE(btarih).
                     xstok_detay4.hareket_kod = hkod.
                     xstok_detay4.depo_kod    = xhareket_table.cikan_depo .
                     xstok_detay4.diger_depo  = xhareket_table.giren_depo .
                     xstok_detay4.belge_no    = bno.
                     xstok_detay4.stok_kod    = xhareket_table.stok_kod.
                     xstok_detay4.parti_kod   = xhareket_table.parti_kod.
                     xstok_detay4.gelir_gider   = xhareket_table.gelir_gider.
                     xstok_detay4.masraf_ad   = xhareket_table.masraf_ad.
                     xstok_detay4.masraf_merkez   = xhareket_table.masraf_merkez.
                     xstok_detay4.analiz_kod   = xhareket_table.analiz_kod.
        END.

        xstok_detay4.miktar   = xstok_detay4.miktar  + xhareket_table.miktar.

    END. /*FOR EACH xhareket_table*/

    FIND FIRST xstok_master4 NO-LOCK NO-ERROR.

    IF NOT AVAILABLE xstok_master4 THEN DO:
        MESSAGE " 2- Belge de hata var ust bilgileri kontrol edin! " SKIP
            "Hareket Kod:" hkod ", Depo Kod:" xhareket_table.cikan_depo SKIP
            "Diger Depo:" xhareket_table.giren_depo ", Belge No:" bno VIEW-AS ALERT-BOX ERROR.            
        RETURN ERROR.
    END.

    CREATE stok_master.
        ASSIGN
            stok_master.belge_tarih   = xstok_master4.belge_tarih
            stok_master.hareket_kod   = xstok_master4.hareket_kod 
            stok_master.depo_kod      = xstok_master4.depo_kod
            stok_master.diger_depo    = xstok_master4.diger_depo
            stok_master.belge_no      = xstok_master4.belge_no
            stok_master.firma_kod     = firma-kod 
            stok_master.cari_kod      = xstok_master4.carikod
            stok_master.stok_masterno = NEXT-VALUE(master-kayit-no)
            stok_master.user_kod      = user-kod
            stok_master.aciklama      = "Mikrobar'dan Uyum'a Oto.Atýlmýþtýr..." 
            stok_master.aciklama2     = aciklama
            stok_master.kaynak_prog   = 'Stok'.
        x5recid = RECID(stok_master).
        RELEASE stok_master.

        FIND stok_master WHERE RECID(stok_master) = x5recid NO-ERROR.

        FOR EACH xstok_detay4 WHERE  xstok_detay4.belge_tarih = stok_master.belge_tarih AND
                                   xstok_detay4.hareket_kod = stok_master.hareket_kod AND
                                   xstok_detay4.depo_kod    = stok_master.depo_kod AND
                                   xstok_detay4.diger_depo  = stok_master.diger_depo AND
                                   xstok_detay4.belge_no    = stok_master.belge_no ON ERROR UNDO, RETURN ERROR:
            
            master_no = stok_master.stok_masterno.

            FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND
                               stok_kart.stok_kod  = xstok_detay4.stok_kod NO-LOCK NO-ERROR.

            CREATE stok_hareket.
            ASSIGN
                stok_hareket.firma_kod     = firma-kod
                stok_hareket.stok_masterno = stok_master.stok_masterno 
                stok_hareket.stok_detayno  = NEXT-VALUE(detay-kayit-no)
                stok_hareket.depo_kod      = stok_master.depo_kod
                stok_hareket.diger_depo    = stok_master.diger_depo
                stok_hareket.hareket_kod   = stok_master.hareket_kod
                stok_hareket.stok_kod      = stok_kart.stok_kod
                stok_hareket.stok_ad       = stok_kart.stok_ad
                stok_hareket.belge_tarih   = stok_master.belge_tarih
                stok_hareket.belge_no      = stok_master.belge_no
                stok_hareket.aciklama      = stok_master.aciklama
                stok_hareket.user_kod      = user-kod
                stok_hareket.kaynak_prog   = 'Stok'
                stok_hareket.dmiktar       = xstok_detay4.miktar
                stok_hareket.parti_kod     = xstok_detay4.parti_kod
                stok_hareket.gelirgider_kod = xstok_detay4.gelir_gider
                stok_hareket.masraf_ad = xstok_detay4.masraf_ad
                stok_hareket.masraf_merkez = xstok_detay4.masraf_merkez
                stok_hareket.analiz_kod = xstok_detay4.analiz_kod
				stok_hareket.cari_kod	   = xstok_master4.carikod
                stok_hareket.dbirim        = stok_kart.birim.
            detay_satir = detay_satir + 1.
                                              
        END. /*FOR EACH xstok_detay4*/
        
        

    

END. /*DO TRANSACTION*/


IF master_no > 0 THEN DO:
    DISPLAY " kayýt-no =" STRING(master_no) ",detay =" STRING(detay_satir).
END.

OUTPUT CLOSE.  /* çýkýþ dosyasýný kapat */

DEFINE VARIABLE xfile-line AS CHARACTER INITIAL "".

INPUT FROM VALUE(SEARCH(barset-log-dir + bno + ".txt") ) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
    SET islem_sonucu = islem_sonucu + xfile-line.
  END.
INPUT CLOSE.

ON FIND OF stok_hareket REVERT.
ON FIND OF stok_master REVERT.

