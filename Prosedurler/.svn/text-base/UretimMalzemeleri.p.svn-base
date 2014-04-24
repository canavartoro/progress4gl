/*
Canavar.Toro
02 Mayýs 2012 02:30 Arma Filitre 
*/

DEFINE TEMP-TABLE Malzemeler
    FIELD Alternatif AS LOGICAL FORMAT "True/False"
    FIELD DepoKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod2 AS CHARACTER FORMAT "X(30)"
    FIELD Birim AS CHARACTER FORMAT "X(10)"
    FIELD KMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99999" DECIMALS 2
    FIELD FMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)"
    FIELD MiktarSekli AS INTEGER.


DEFINE INPUT PARAMETER MasterNo  AS RECID.
DEFINE INPUT PARAMETER TABLE FOR Malzemeler.

DEFINE VARIABLE kXMiktar AS DECIMAL FORMAT "->>>>9.99999" NO-UNDO INITIAL 0.
DEFINE VARIABLE dBMiktar AS DECIMAL FORMAT "->>>>9.99999" NO-UNDO INITIAL 0.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND erp_detay2 WHERE RECID(erp_detay2) = MasterNo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE erp_detay2 THEN DO:
        MESSAGE "Uretim kaydi bulunamadi " MasterNo VIEW-AS ALERT-BOX.
        RETURN ERROR. /*LEAVE.*/
    END.

    DISPLAY erp_detay2.isemri_no erp_detay2.dmiktar.

    FIND ham_master WHERE ham_master.firma_kod = erp_detay2.firma_kod AND ham_master.ham_masterno = erp_detay2.ham_masterno NO-ERROR.

    IF NOT AVAILABLE ham_master THEN DO:
        DISPLAY "Uretime ait ham master kaydi yok".
    END.

    /*Alternatif stok eklemek icin*/
    FOR EACH Malzemeler WHERE Malzemeler.Alternatif = TRUE:

        FIND recete_master WHERE recete_master.firma_kod = erp_detay2.firma_kod AND recete_master.stok_kod = Malzemeler.MalzemeKod AND 
            recete_master.aktif_pasif = "Aktif" NO-LOCK NO-ERROR.

        FOR EACH ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND 
                ham_detay.ham_masterno = erp_detay2.ham_masterno AND ham_detay.stok_kod = Malzemeler.MalzemeKod2:
    
                DISPLAY Malzemeler.MalzemeKod2 "," Malzemeler.MalzemeKod "," PartiNo.
    
             ASSIGN
                 ham_detay.alter1 = TRUE
                 ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                 ham_detay.stok_kod = Malzemeler.MalzemeKod
                 ham_detay.depo_kod = Malzemeler.DepoKod
                 ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                 ham_detay.fire_miktar = Malzemeler.FMiktar
                 ham_detay.birim = Malzemeler.Birim
                 ham_detay.recete_kod   = IF AVAILABLE recete_master THEN recete_master.recete_kod ELSE ""
                 ham_detay.giris_sekli  = "Manuel"
                 ham_detay.kaynak_prog = 'Ür-Giriþ'
                 ham_detay.kaynak_prog3  = 'Üretim-2'
                 ham_detay.parti_kod = PartiNo.
                RELEASE ham_detay.
      
         END.

    END. /* DO Alternatif True */

    /*Farklý stok eklemek icin*/
    FOR EACH Malzemeler WHERE Malzemeler.Alternatif = FALSE:        

        FIND recete_master WHERE recete_master.firma_kod = erp_detay2.firma_kod AND recete_master.stok_kod = Malzemeler.MalzemeKod AND 
            recete_master.aktif_pasif = "Aktif" NO-LOCK NO-ERROR.

         FIND FIRST ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND 
            ham_detay.stok_kod = Malzemeler.MalzemeKod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND 
            ham_detay.erp_masterno = erp_detay2.erp_masterno AND 
             (ham_detay.parti_kod EQ "" /*OR ham_detay.parti_kod EQ Malzemeler.PartiNo*/) NO-ERROR.

         IF AVAILABLE ham_detay THEN DO:
             DISPLAY "guncelleme ".
             ASSIGN
                 ham_detay.birim = Malzemeler.Birim
                 ham_detay.giris_sekli  = "Manuel"
                 ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                 ham_detay.parti_kod = Malzemeler.PartiNo.
             RELEASE ham_detay.
         END.
         ELSE DO:
             DISPLAY "yeni ".
             FIND stok_kart WHERE stok_kart.firma_kod = erp_detay2.firma_kod AND stok_kart.stok_kod = Malzemeler.MalzemeKod NO-LOCK.
             IF NOT AVAILABLE stok_kart THEN DO:
                 MESSAGE "Malzeme tanimi buluanamadi " Malzemeler.MalzemeKod
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 RETURN ERROR.
             END.

             CREATE ham_detay.
                ASSIGN
                    ham_detay.alter1 = FALSE
                    ham_detay.firma_kod = erp_detay2.firma_kod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.stok_ad = stok_kart.stok_ad
                    ham_detay.kimin_yerine = ""
                    ham_detay.ham_masterno = erp_detay2.ham_masterno
                    ham_detay.ham_detayno   = NEXT-VALUE(detay-kayit-no)
                    ham_detay.erp_detayno  = erp_detay2.erp_detayno2
                    ham_detay.belge_tarih  = erp_detay2.bitis_tarih
                    ham_detay.erp_masterno = erp_detay2.erp_masterno 
                    ham_detay.isemri_no    = erp_detay2.isemri_no
                    ham_detay.recete_kod   = IF AVAILABLE recete_master THEN recete_master.recete_kod ELSE ""
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Manuel" /*"Otomatik-Manuel"*/
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                RELEASE ham_detay.
                RELEASE stok_kart.

                DISPLAY "olusturuldu.". 
         END.        
    END. /* DO Alternatif False */

    ASSIGN erp_detay2.entegre_yap = TRUE.
    RELEASE ham_master.

    RELEASE erp_detay2.

END. /*DO END TRAN*/



