/*
Canavar.toro
26 Temmuz 2012 15:50 Arma filtre
*/

ON FIND OF erp_master  OVERRIDE DO: END.
ON FIND OF erp_detay  OVERRIDE DO: END.
ON FIND OF isemri_tip  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEFINE TEMP-TABLE FasonGelis
    FIELD IsEmriNo AS CHARACTER FORMAT "X(60)":U
    FIELD OperasyonKod AS CHARACTER FORMAT "X(60)":U
    FIELD MalzemeKod AS CHARACTER FORMAT "X(60)":U
    FIELD PartiKod AS CHARACTER FORMAT "X(60)":U
    FIELD Miktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD Tamamlandi AS LOGICAL.

DEFINE INPUT PARAMETER xFirmaKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xUserKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xDepoKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xIstasyonKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeTarih AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xHareketKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeNo AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xKayitId AS INTEGER NO-UNDO.

DEFINE INPUT PARAMETER TABLE FOR FasonGelis. 

DEFINE OUTPUT PARAMETER MasterNo AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

DEFINE VARIABLE i AS INTEGER INITIAL 10.
DEFINE VARIABLE operasyon-sirano AS INTEGER.
DEFINE VARIABLE x6recid AS RECID.
DEFINE VARIABLE mstok-kod AS CHARACTER.

ASSIGN firma-kod = xFirmaKod.
ASSIGN user-kod = xUserKod.

OUTPUT TO VALUE(barset-log-dir + "fasond_" + xBelgeNo + ".txt").

DO  TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND FIRST irsaliye_master WHERE irsaliye_master.firma_kod = firma-kod AND irsaliye_master.kayit_no = xKayitId NO-LOCK NO-ERROR.
    IF AVAILABLE irsaliye_master THEN DO:
        IslemSonucu = "Fason gelis belgesi aktarilmis tekrar aktarilamaz! " + STRING(xKayitId).                   
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "U y a r ý...".                    
        RETURN ERROR.
    END.

    FOR EACH FasonGelis:
        FIND erp_master WHERE erp_master.firma_kod = firma-kod AND erp_master.isemri_no = FasonGelis.IsEmriNo NO-ERROR.            
        
        IF NOT AVAILABLE erp_master THEN DO:
            IslemSonucu = "Is Emri bulunamadi..." + FasonGelis.IsEmriNo.                   
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "U y a r ý...".                    
            RETURN ERROR.               
        END.

        IF NOT erp_master.isemri_durum THEN DO:
            IslemSonucu = "Is Emri kapali kontrol edin..." + FasonGelis.IsEmriNo.                   
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "U y a r ý...".                    
            RETURN ERROR.
        END.
    END.

    FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = xDepoKod NO-LOCK NO-ERROR.

    IF NOT AVAILABLE depo THEN DO:
         IslemSonucu = "Depo Kodu Tanýmsýz..." + xDepoKod.
         MESSAGE IslemSonucu 
               VIEW-AS ALERT-BOX TITLE "U y a r ý...".
               RETURN ERROR.
    END.

    /*FIND firma WHERE firma.firma_kod = firma-kod NO-LOCK.

    FIND dovkur WHERE dovkur.firma_kod = firma-kod AND 
                      dovkur.doviz_kod = firma.doviz_kod AND
                      dovkur.tarih = DATE(xBelgeTarih)   NO-LOCK.

     IF NOT AVAIL dovkur THEN DO:
        MESSAGE "Doviz kodu Bulunamadý... Fason Geliþ : " xIstasyonKod 
            VIEW-AS ALERT-BOX TITLE "H a t a ...".
        RETURN NO-APPLY.
    END.*/

    FIND is_istasyon WHERE is_istasyon.firma_kod = firma-kod AND
                            is_istasyon.istasyon_kod = xIstasyonKod NO-LOCK NO-ERROR.

    IF NOT AVAILABLE is_istasyon THEN DO:
         IslemSonucu = "Girilen Ýþ Ýstasyonu Tanýmsýz...".
         MESSAGE IslemSonucu 
               VIEW-AS ALERT-BOX TITLE "U y a r ý...".
               RETURN ERROR.
     END.

     IF NOT is_istasyon.fason THEN DO:
         IslemSonucu = "Fason Olmayan Bir Ýþ Ýstasyonu Seçemezsiniz...".
         MESSAGE IslemSonucu SKIP
             VIEW-AS ALERT-BOX TITLE "U y a r ý...".
             RETURN ERROR.
     END.
         
     FIND cari_kart OF is_istasyon NO-LOCK NO-ERROR.        
     IF NOT AVAILABLE cari_kart THEN DO:
         MESSAGE "Ýþ Ýstasyondaki Cari Kart Bulunamadý..." SKIP(1)
                "Fason Geliþ : " xIstasyonKod SKIP(1)
                "Cari Kod    : " is_istasyon.cari_kod SKIP(1)
            VIEW-AS ALERT-BOX TITLE "H a t a ...".
         RETURN ERROR.
    END.
    IF NOT AVAILABLE cari_kart THEN NEXT.    

    CREATE irsaliye_master.       
    ASSIGN irsaliye_master.firma_kod         = firma-kod 
        irsaliye_master.cari_kod             = cari_kart.cari_kod 
        irsaliye_master.belge_tarih          = DATE(xBelgeTarih)
        irsaliye_master.belge_no             = xBelgeNo 
        irsaliye_master.hareket_kod          = xHareketKod
        irsaliye_master.aciklama             = "Fason Geliþ Olarak Barset Oto.Atmýþtýr..."
        irsaliye_master.irsaliye_aciklama[1] = "Barset Tarafýndan Oto.Üretilmiþtir..." 
        irsaliye_master.fatura_adres1        = cari_kart.fat_adres1
        irsaliye_master.fatura_adres2        = cari_kart.fat_adres2
        irsaliye_master.fatura_adres3        = cari_kart.fat_adres3
        irsaliye_master.kaynak_prog          = 'Ýrsaliye' /*'Fason'*/
        irsaliye_master.kaynak_prog3         = 'Ýrsaliye'
        irsaliye_master.kayit_no             = xKayitId
        irsaliye_master.plan_kod             = cari_kart.plan_kod.
        x6recid = RECID(irsaliye_master). 
        RELEASE irsaliye_master.

        FIND irsaliye_master WHERE RECID(irsaliye_master) = x6recid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

        FOR EACH FasonGelis NO-LOCK ON ERROR UNDO, RETURN ERROR:           
            FIND erp_master WHERE erp_master.firma_kod = firma-kod AND erp_master.isemri_no = FasonGelis.IsEmriNo NO-ERROR.
  
            IF NOT AVAILABLE erp_master THEN DO:
                IslemSonucu = "Is Emri bulunamadi..." + FasonGelis.IsEmriNo.                   
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "U y a r ý...".                    
                RETURN ERROR.
            END.

            IF NOT erp_master.isemri_durum THEN DO:
                IslemSonucu = "Is Emri kapali kontrol edin..." + FasonGelis.IsEmriNo.                   
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "U y a r ý...".                    
                RETURN ERROR.
            END.
                
            FIND FIRST erp_detay WHERE erp_detay.firma_kod = firma-kod AND erp_detay.isemri_no = FasonGelis.IsEmriNo AND erp_detay.operasyon_kod = FasonGelis.OperasyonKod NO-LOCK NO-ERROR.                
            IF AVAILABLE erp_detay THEN operasyon-sirano = erp_detay.sira_no.
            FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND stok_kart.stok_kod = erp_master.stok_kod NO-LOCK NO-ERROR. 
            FIND FIRST cari_stokkodu WHERE cari_stokkodu.firma_kod = firma-kod AND cari_stokkodu.stok_kod = erp_master.stok_kod NO-LOCK NO-ERROR.
            IF AVAILABLE cari_stokkodu THEN mstok-kod = cari_stokkodu.mstok_kod. ELSE mstok-kod = "".

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
                irsaliye_detay.sira_no           = i 
                irsaliye_detay.depo_kod          = depo.depo_kod
                irsaliye_detay.diger_depo        = is_istasyon.depo_kod3
                /*irsaliye_detay.depo_kod          = is_istasyon.depo_kod3*/
                /*irsaliye_detay.diger_depo        = depo.depo_kod*/
                irsaliye_detay.stok_kod          = erp_master.stok_kod
                irsaliye_detay.mstok_kod         = mstok-kod
                irsaliye_detay.dmiktar           = FasonGelis.Miktar
                irsaliye_detay.dbirim            = erp_master.birim
                irsaliye_detay.fason             = TRUE
                irsaliye_detay.isemri_no         = erp_master.isemri_no
                irsaliye_detay.istasyon_kod      = xIstasyonKod
                irsaliye_detay.operasyon_kod     = FasonGelis.OperasyonKod
                irsaliye_detay.operasyon_sira_no = operasyon-sirano
                irsaliye_detay.parti_kod          = FasonGelis.PartiKod.
            /*IF stok_kart.urun_tip = "Y.Mamul" THEN  irsaliye_detay.depo_kod = is_istasyon.fdepo_kod2.*/
            RELEASE irsaliye_detay.
            i = i + 10.

            IF FasonGelis.Tamamlandi EQ TRUE THEN erp_master.isemri_durum = FALSE.        
            RELEASE erp_master.

        END.
                                 
        irsaliye_master.entegre_yap = TRUE.
        RELEASE irsaliye_master.

        ASSIGN MasterNo = DEC(x6recid) DetaySatir = 1 IslemSonucu = "ok".        

END. /*END TRAN*/

OUTPUT CLOSE.

ON FIND OF erp_master  REVERT.
ON FIND OF erp_detay  REVERT.
ON FIND OF isemri_tip  REVERT.
