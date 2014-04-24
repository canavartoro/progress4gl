

ON FIND OF irsaliye_master  OVERRIDE DO: END.
ON FIND OF irsaliye_detay  OVERRIDE DO: END.
ON FIND OF hareket_tip  OVERRIDE DO: END.
ON FIND OF firma  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE xIrsaliyeDetay         
            FIELD StokKodu AS CHARACTER
            FIELD PartiNo AS CHARACTER
            FIELD Birim AS CHARACTER FORMAT "X(10)"
            FIELD Miktar AS DECIMAL
            FIELD DepoKod AS CHARACTER.


DEFINE INPUT PARAMETER FirmaKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KullaniciKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KayitId      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER BelgeNo      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER BelgeTarih   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER HareketKod   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER DigerDepo    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER CariKod      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Aciklama     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER AdresKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER OzelKod1     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER OzelKod2     AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER TABLE FOR xIrsaliyeDetay. 

DEFINE OUTPUT PARAMETER MasterNo AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.



DEFINE VARIABLE irsaliye_master_id AS RECID.

ASSIGN firma-kod = FirmaKod.
ASSIGN user-kod = KullaniciKod.

OUTPUT TO VALUE(barset-log-dir + "irs_" + BelgeNo + ".txt"). 

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND FIRST irsaliye_master WHERE irsaliye_master.firma_kod = FirmaKod AND irsaliye_master.kayit_no = KayitId NO-LOCK NO-ERROR.
    IF AVAILABLE irsaliye_master THEN DO:
        ASSIGN IslemSonucu = IslemSonucu + "Irsaliye kaydi daha once erpye aktarilmis tekrar aktarilamaz!..." + STRING(KayitId).
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".
        RETURN ERROR.
    END.

    FIND FIRST firma WHERE firma.firma_kod EQ FirmaKod NO-LOCK NO-ERROR.
    IF NOT AVAILABLE firma THEN DO:
        ASSIGN IslemSonucu = IslemSonucu + "Firma tanýmý bulunamadý..." + firma-kod.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".
        RETURN ERROR.
    END.

    IF DigerDepo NE "" THEN DO:
        FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = DigerDepo NO-LOCK NO-ERROR.
        IF NOT AVAILABLE depo THEN DO:
            ASSIGN IslemSonucu = IslemSonucu + "Depo kodu tanimsiz (Diger Depo)..." + DigerDepo.
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".
            RETURN ERROR.
        END.
    END.    

    FIND hareket_tip WHERE hareket_tip.firma_kod   = firma-kod AND
                           hareket_tip.kaynak_prog = 'Ýrsaliye' AND
                           hareket_tip.hareket_kod = HareketKod NO-LOCK NO-ERROR.
    IF NOT AVAILABLE hareket_tip THEN DO:
        ASSIGN IslemSonucu = IslemSonucu + "Satýþ Ýrsaliye Hareket Kodu Tanýmsýz..." + HareketKod.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".
        RETURN ERROR.
    END.

    FIND cari_kart WHERE cari_kart.firma_kod = firma-kod AND cari_kart.cari_kod = CariKod NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cari_kart THEN DO:  
        ASSIGN IslemSonucu = IslemSonucu + "Cari Kodu Tanýmsýz..." + CariKod.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".    
        RETURN ERROR.
    END.

    IF AdresKod NE "" THEN DO:
        FIND cari_adres WHERE cari_adres.firma_kod = firma-kod AND cari_adres.cari_kod = cari_kart.cari_kod AND cari_adres.adres_tip = AdresKod NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cari_adres THEN DO:
            ASSIGN IslemSonucu = IslemSonucu + "Cari Adres Kodu Tanýmsýz..." + AdresKod.
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "H a t a...".    
            RETURN ERROR.
        END.
    END.

    CREATE irsaliye_master.
    ASSIGN
        irsaliye_master.firma_kod            = firma-kod
        /*irsaliye_master.isyeri_kod           = cari_kart.isyeri_kod*/
		irsaliye_master.cari_kod             = cari_kart.cari_kod              
		irsaliye_master.scari_kod            = cari_kart.cari_kod              
		irsaliye_master.belge_tarih          = DATE(BelgeTarih)             
		irsaliye_master.belge_no             = BelgeNo              
		irsaliye_master.stok_baglan          = hareket_tip.stok_baglan             
		irsaliye_master.hareket_kod          = HareketKod             
		irsaliye_master.aciklama             = Aciklama                          
		irsaliye_master.irsaliye_aciklama[6] = 'Mikrobar Tarafýndan Oto.Üretilmiþtir..'  
		irsaliye_master.fatura_adres1        = cari_kart.fat_adres1             
		irsaliye_master.fatura_adres2        = cari_kart.fat_adres2             
		irsaliye_master.fatura_adres3        = cari_kart.fat_adres3
        /*irsaliye_master.isk_yuzde5           = cari_kart.isk_yuzde5
        irsaliye_master.isk_yuzde6           = cari_kart.isk_yuzde6*/
		irsaliye_master.kaynak_prog          = 'Ýrsaliye'             
		irsaliye_master.kaynak_prog3         = 'Ýrsaliye'
        irsaliye_master.kayit_no             = KayitId
        irsaliye_master.okod1                = OzelKod1
        irsaliye_master.okod2                = OzelKod2
        irsaliye_master.plan_kod             = ""
        irsaliye_master.kaynak_masterno      = 0
        irsaliye_master.nakliye_firma        = ""
        irsaliye_master.nakliye_tip          = ""
		irsaliye_master.vade_tarih           = DATE(BelgeTarih) + cari_kart.vade.
        IF AVAILABLE cari_adres THEN DO:
            irsaliye_master.adres_tip            = cari_adres.adres_tip.             
		    irsaliye_master.sevk_adres1          = cari_adres.adres1.             
		    irsaliye_master.sevk_adres2          = cari_adres.adres2.             
		    irsaliye_master.sevk_adres3          = cari_adres.adres3.  
        END.
        irsaliye_master_id = RECID(irsaliye_master).
        RELEASE irsaliye_master.
        /*Irsaliye Master End*/
        FIND irsaliye_master WHERE RECID(irsaliye_master) = irsaliye_master_id EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF  NOT AVAILABLE irsaliye_master THEN DO:
            IslemSonucu = "Belge bilgilerinde hata var! (irsaliye_master)".
            MESSAGE "Belge bilgilerinde hata var! (irsaliye_master)" VIEW-AS ALERT-BOX TITLE "Hata!".        
            RETURN ERROR.
        END.

        FOR EACH xIrsaliyeDetay ON ERROR UNDO, RETURN ERROR:

            FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND stok_kart.stok_kod = xIrsaliyeDetay.StokKodu NO-LOCK NO-ERROR.
            IF NOT AVAIL stok_kart THEN DO :
                ASSIGN IslemSonucu = IslemSonucu + "Satýþ Ýrsaliye Hareket Kodu Tanýmsýz..." + xIrsaliyeDetay.StokKodu.
                MESSAGE IslemSonucu  VIEW-AS ALERT-BOX TITLE "H a t a...".                   
                RETURN ERROR.
            END.

            FIND FIRST cari_stokkodu WHERE cari_stokkodu.firma_kod = firma-kod AND cari_stokkodu.cari_kod = irsaliye_master.cari_kod AND cari_stokkodu.stok_kod = xIrsaliyeDetay.StokKodu NO-LOCK NO-ERROR.

            FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = xIrsaliyeDetay.DepoKod NO-LOCK NO-ERROR.

            IF NOT AVAILABLE depo THEN DO:
                IslemSonucu = "Depo Kodu Bulunamadý:" + xIrsaliyeDetay.DepoKod.
                MESSAGE "Depo Kodu Bulunamadý:" xIrsaliyeDetay.DepoKod VIEW-AS ALERT-BOX TITLE "U y a r ý...".            
                RETURN ERROR.  
            END.

            IF AVAIL depo THEN DO:
                IF AVAIL stok_kart THEN DO:
                    FIND depo_stok WHERE depo_stok.firma_kod = firma-kod AND depo_stok.depo_kod  = xIrsaliyeDetay.DepoKod AND depo_stok.stok_kod  = xIrsaliyeDetay.StokKodu NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE depo_stok THEN DO:
                        IslemSonucu = "Depo Stok Kaydý Bulunamadý(*):" + xIrsaliyeDetay.DepoKod  + " Stok: " + xIrsaliyeDetay.StokKodu.
                        MESSAGE "Depo Stok Kaydý Bulunamadý(*):" xIrsaliyeDetay.DepoKod ", Stok:" xIrsaliyeDetay.StokKodu VIEW-AS ALERT-BOX TITLE "B i l g i...".
                        RETURN ERROR.                    
                    END.
                END.
            END.

            CREATE irsaliye_detay.
            ASSIGN
    			irsaliye_detay.firma_kod         = firma-kod                         
    			irsaliye_detay.irsaliye_masterno = irsaliye_master.irsaliye_masterno                       
    			irsaliye_detay.belge_tarih       = irsaliye_master.belge_tarih                       
    			irsaliye_detay.belge_no          = irsaliye_master.belge_no                       
    			irsaliye_detay.cari_kod          = irsaliye_master.cari_kod                       
    			irsaliye_detay.hareket_kod       = irsaliye_master.hareket_kod                       
    			irsaliye_detay.satici_kod        = irsaliye_master.satici_kod                       
    			irsaliye_detay.aciklama          = irsaliye_master.aciklama                       
    			irsaliye_detay.kaynak_prog       = 'Ýrsaliye'                       
    			irsaliye_detay.kaynak_prog3      = 'Ýrsaliye'                       
    			irsaliye_detay.depo_kod          = xIrsaliyeDetay.DepoKod
                irsaliye_detay.diger_depo        = DigerDepo
                irsaliye_detay.parti_no          = xIrsaliyeDetay.PartiNo
    			/*irsaliye_detay.fiyat_sekli       = TRUE*/                       
    			irsaliye_detay.stok_kod          = stok_kart.stok_kod
                irsaliye_detay.mstok_kod         = IF AVAILABLE cari_stokkodu THEN cari_stokkodu.mstok_kod ELSE ""
    			irsaliye_detay.kdv_yuzde         = stok_kart.kdv_oran                                                   
    			irsaliye_detay.dmiktar           = xIrsaliyeDetay.Miktar                            
    			irsaliye_detay.dbirim            = IF xIrsaliyeDetay.Birim NE "" THEN xIrsaliyeDetay.Birim ELSE stok_kart.birim                     
    			irsaliye_detay.vade_tarih        = irsaliye_master.vade_tarih.
            RELEASE irsaliye_detay.                                        
            DetaySatir = DetaySatir + 1.
        END. /* END xIrsaliyeDetay */
        MasterNo = irsaliye_master.irsaliye_masterno.
        irsaliye_master.entegre_yap = TRUE.            
        RELEASE irsaliye_master.

END. /* END TRANSACTION */

ON FIND OF irsaliye_master  REVERT.
ON FIND OF irsaliye_detay  REVERT.
ON FIND OF hareket_tip  REVERT.
ON FIND OF firma  REVERT.

OUTPUT CLOSE.

IF NOT SEARCH(barset-log-dir + "irs_" + BelgeNo + ".txt") = ? THEN DO:
    DEFINE VARIABLE xfile-line AS CHARACTER INITIAL "".
    INPUT FROM VALUE(SEARCH(barset-log-dir + "irs_" + BelgeNo + ".txt") ) NO-ECHO.
      REPEAT:
      IMPORT UNFORMATTED xfile-line.
        SET IslemSonucu = IslemSonucu + xfile-line.
      END.
    INPUT CLOSE.
END.
