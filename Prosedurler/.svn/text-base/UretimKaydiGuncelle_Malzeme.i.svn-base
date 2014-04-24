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
    FIELD KMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD FMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)"
    FIELD MiktarSekli AS INTEGER.


DEFINE INPUT PARAMETER MasterNo  AS RECID.
DEFINE INPUT PARAMETER TABLE FOR Malzemeler.
DEFINE VARIABLE satir-sayi AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE is-debug AS LOGICAL NO-UNDO INITIAL FALSE.

DEFINE VARIABLE kXMiktar AS DECIMAL FORMAT "->>>>9.99999" NO-UNDO INITIAL 0.
DEFINE VARIABLE dBMiktar AS DECIMAL FORMAT "->>>>9.99999" NO-UNDO INITIAL 0.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    /*FOR EACH Malzemeler:
        PUT UNFORMATTED Malzemeler.Alternatif Malzemeler.MalzemeKod Malzemeler.MalzemeKod2 Malzemeler.PartiNo Malzemeler.DepoKod Malzemeler.Birim Malzemeler.KMiktar SKIP.
    END.*/

    FIND erp_detay2 WHERE RECID(erp_detay2) = MasterNo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    IF NOT AVAILABLE erp_detay2 THEN DO:
        MESSAGE "Uretim kaydi bulunamadi " MasterNo VIEW-AS ALERT-BOX.
        RETURN ERROR.
    END.

    FIND ham_master WHERE ham_master.firma_kod = erp_detay2.firma_kod AND ham_master.ham_masterno = erp_detay2.ham_masterno NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ham_master THEN DO:
        MESSAGE "Is emri recete kaydi bulunamadi " MasterNo VIEW-AS ALERT-BOX.
        RETURN ERROR.
    END.

    /*silinenleri cikartmak icin*/
    FOR EACH ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND ham_detay.ham_masterno = ham_master.ham_masterno ON ERROR UNDO, RETURN ERROR:
        /*alternatif kullanimlar icin*/
        IF ham_detay.alter1 THEN DO:

            FOR EACH Malzemeler WHERE Malzemeler.Alternatif = TRUE AND Malzemeler.MalzemeKod2 = ham_detay.kimin_yerine AND
                Malzemeler.MalzemeKod = ham_detay.stok_kod AND Malzemeler.PartiNo = ham_detay.parti_kod AND Malzemeler.Birim = ham_detay.birim:
                
                ASSIGN
                    ham_detay.alter1 = TRUE
                    ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Otomatik"
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                    RELEASE ham_detay.
                    DELETE Malzemeler.
                    satir-sayi = satir-sayi + 1.
            END.
            IF satir-sayi = 0 THEN DO:
                /*DISPLAY "ham_silinecek:" Malzemeler.Alternatif Malzemeler.MalzemeKod Malzemeler.MalzemeKod2 Malzemeler.PartiNo Malzemeler.DepoKod Malzemeler.Birim Malzemeler.KMiktar SKIP.*/
                ON DELETE OF ham_detay OVERRIDE DO: END.
                DELETE ham_detay.
                ON DELETE OF ham_detay REVERT.
            END.

        END. /*IF ham_detay.alter1*/
        ELSE DO:
            satir-sayi = 0.
            FOR EACH Malzemeler WHERE Malzemeler.Alternatif = FALSE AND 
                Malzemeler.MalzemeKod = ham_detay.stok_kod AND Malzemeler.PartiNo = ham_detay.parti_kod AND 
                Malzemeler.Birim = ham_detay.birim:
                /*DISPLAY "tmp2_silinecek:" Malzemeler.Alternatif Malzemeler.MalzemeKod Malzemeler.MalzemeKod2 Malzemeler.PartiNo Malzemeler.DepoKod Malzemeler.Birim Malzemeler.KMiktar SKIP.*/
                ASSIGN
                    ham_detay.alter1 = FALSE
                    ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Otomatik"
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                    DELETE Malzemeler.
                    RELEASE ham_detay.
                    satir-sayi = satir-sayi + 1.
            END.

            IF satir-sayi = 0 THEN DO:
                /*DISPLAY "ham2_silinecek:" ham_detay.alter1 ham_detay.stok_kod ham_detay.kimin_yerine ham_detay.parti_kod ham_detay.depo_kod ham_detay.birim ham_detay.kullanilan_miktar SKIP.*/
                ON DELETE OF ham_detay OVERRIDE DO: END.
                DELETE ham_detay.
                ON DELETE OF ham_detay REVERT.
            END.            

        END. /*ELSE DO:*/

    END.

    /*Alternatif stok eklemek icin*/
    FOR EACH Malzemeler WHERE Malzemeler.Alternatif = TRUE:
        FIND recete_master WHERE recete_master.firma_kod = erp_detay2.firma_kod AND recete_master.stok_kod = Malzemeler.MalzemeKod AND 
            recete_master.aktif_pasif = "Aktif" NO-LOCK NO-ERROR.

        FIND FIRST ham_detay WHERE ham_detay.firma_kod = ham_master.firma_kod AND 
            ham_detay.ham_masterno = ham_master.ham_masterno AND ham_detay.stok_kod = Malzemeler.MalzemeKod2 AND 
            ham_detay.parti_kod = Malzemeler.PartiNo AND Malzemeler.Birim = ham_detay.birim NO-ERROR.

        IF AVAILABLE ham_detay THEN DO:
             ASSIGN
                 ham_detay.alter1 = TRUE
                 ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                 ham_detay.stok_kod = Malzemeler.MalzemeKod
                 ham_detay.depo_kod = Malzemeler.DepoKod
                 ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                 ham_detay.fire_miktar = Malzemeler.FMiktar
                 ham_detay.birim = Malzemeler.Birim
                 ham_detay.recete_kod   = IF AVAILABLE recete_master THEN recete_master.recete_kod ELSE ""
                 ham_detay.giris_sekli  = "Otomatik"
                 ham_detay.kaynak_prog = 'Ür-Giriþ'
                 ham_detay.kaynak_prog3  = 'Üretim-2'
                 ham_detay.parti_kod = Malzemeler.PartiNo.
             RELEASE ham_detay.
         END.
         ELSE DO:

             FIND stok_kart WHERE stok_kart.firma_kod = erp_detay2.firma_kod AND stok_kart.stok_kod = Malzemeler.MalzemeKod NO-LOCK.
             IF NOT AVAILABLE stok_kart THEN DO:
                 DISPLAY "Malzeme tanimi buluanamadi " Malzemeler.MalzemeKod.
                 RETURN ERROR.
             END.
             CREATE ham_detay.
                ASSIGN
                    ham_detay.alter1 = TRUE
                    ham_detay.firma_kod = erp_detay2.firma_kod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.stok_ad = stok_kart.stok_ad
                    ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                    ham_detay.ham_masterno = erp_detay2.ham_masterno
                    ham_detay.ham_detayno   = NEXT-VALUE(detay-kayit-no)
                    ham_detay.erp_detayno  = erp_detay2.erp_detayno2
                    ham_detay.belge_tarih  = erp_detay2.bitis_tarih
                    ham_detay.erp_masterno = ham_master.erp_masterno
                    ham_detay.recete_kod   = IF AVAILABLE recete_master THEN recete_master.recete_kod ELSE ""
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Otomatik" /*"Otomatik"*/
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                RELEASE ham_detay.
                RELEASE stok_kart.
         END.       

    END. /* DO Alternatif True */


    /*Farklý stok eklemek icin*/
    FOR EACH Malzemeler WHERE Malzemeler.Alternatif = FALSE:               

        FIND recete_master WHERE recete_master.firma_kod = erp_detay2.firma_kod AND recete_master.stok_kod = Malzemeler.MalzemeKod AND 
            recete_master.aktif_pasif = "Aktif" NO-LOCK NO-ERROR.

        /*FIND erp_recete WHERE erp_recete.firma_kod = erp_detay2.firma_kod AND erp_recete.erp_masterno = ham_master.erp_masterno AND erp_recete.stok_kod = Malzemeler.MalzemeKod NO-ERROR.
        IF AVAILABLE erp_recete THEN DO:
            MESSAGE "Farkli stok olarak ayni malzeme eklenemez! Farkli malzeme eklemelisizin. " + Malzemeler.MalzemeKod VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.*/

         FIND ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND 
            ham_detay.stok_kod = Malzemeler.MalzemeKod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND 
            ham_detay.erp_masterno = ham_master.erp_masterno AND (ham_detay.parti_kod EQ "" OR ham_detay.parti_kod EQ Malzemeler.PartiNo) NO-ERROR.

         IF AVAILABLE ham_detay THEN DO:
             ASSIGN
                 ham_detay.birim = Malzemeler.Birim
                 ham_detay.giris_sekli  = "Otomatik"
                 ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                 ham_detay.parti_kod = PartiNo.
             RELEASE ham_detay.
         END.
         ELSE DO:

             FIND stok_kart WHERE stok_kart.firma_kod = erp_detay2.firma_kod AND stok_kart.stok_kod = Malzemeler.MalzemeKod NO-LOCK.
             IF NOT AVAILABLE stok_kart THEN DO:
                 DISPLAY "Malzeme tanimi buluanamadi " Malzemeler.MalzemeKod.
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
                    ham_detay.erp_masterno = ham_master.erp_masterno
                    ham_detay.recete_kod   = IF AVAILABLE recete_master THEN recete_master.recete_kod ELSE ""
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Otomatik" /*"Otomatik/Manuel"*/
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                RELEASE ham_detay.
                RELEASE stok_kart.
         END.        
    END. /* DO Alternatif False */

    FOR EACH erp_recete WHERE erp_recete.firma_kod = erp_detay2.firma_kod AND erp_recete.erp_masterno = ham_master.erp_masterno NO-LOCK:

            ASSIGN dBMiktar = erp_recete.miktar * erp_detay2.burut_miktar kXMiktar = 0.

            FOR EACH ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND 
                ham_detay.stok_kod = erp_recete.stok_kod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND 
                ham_detay.erp_masterno = ham_master.erp_masterno NO-LOCK:
                kXMiktar = kXMiktar + ham_detay.kullanilan_miktar.
            END.

            IF kXMiktar < dBMiktar THEN DO:
                MESSAGE "Kullanim miktari recete tuketiminden az olamaz. " + erp_recete.stok_kod + 
                    " Gereken Miktar:" + STRING(dBMiktar) + ", Kullanilan Miktar:" + STRING(kXMiktar) VIEW-AS ALERT-BOX ERROR.
                RETURN ERROR.
            END.
    END.
        /*end recete*/
   

    ASSIGN erp_detay2.entegre_yap = TRUE.
    RELEASE ham_master.
    RELEASE erp_detay2.
END. /*DO END*/



