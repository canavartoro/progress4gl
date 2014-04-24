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
    FIELD PartiNo AS CHARACTER FORMAT "X(30)".


DEFINE INPUT PARAMETER MasterNo  AS RECID.
DEFINE INPUT PARAMETER TABLE FOR Malzemeler.


DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND erp_detay2 WHERE RECID(erp_detay2) = MasterNo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    IF NOT AVAILABLE erp_detay2 THEN DO:
        MESSAGE "Uretim kaydi bulunamadi " MasterNo VIEW-AS ALERT-BOX.
        RETURN ERROR. /*LEAVE.*/
    END.

    FIND ham_master WHERE ham_master.firma_kod = erp_detay2.firma_kod AND ham_master.ham_masterno = erp_detay2.ham_masterno NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ham_master THEN LEAVE.

    /*silinenleri cikartmak icin*/
    FOR EACH ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND ham_detay.ham_masterno = ham_master.ham_masterno ON ERROR UNDO, RETURN ERROR:

        IF ham_detay.alter1 THEN DO:

            DISPLAY "1-alternatif kontrolu " ham_detay.stok_kod NO-LABEL.

            FIND FIRST Malzemeler WHERE Malzemeler.Alternatif = TRUE AND Malzemeler.MalzemeKod2 = ham_detay.kimin_yerine AND
                Malzemeler.MalzemeKod = ham_detay.stok_kod AND Malzemeler.PartiNo = ham_detay.parti_kod NO-ERROR.
            IF AVAILABLE Malzemeler THEN DO:
                ASSIGN
                    ham_detay.alter1 = TRUE
                    ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Manuel"
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = Malzemeler.PartiNo.
                    RELEASE ham_detay.                    
                    DISPLAY "1-tempten siliniyor " Malzemeler.MalzemeKod NO-LABEL.
                    DELETE Malzemeler.
            END.
            ELSE DO:
                DISPLAY "1-erpden siliniyor " ham_detay.stok_kod NO-LABEL.
                ON DELETE OF ham_detay OVERRIDE DO: END.
                DELETE ham_detay.
                ON DELETE OF ham_detay REVERT.
            END.

        END. /*IF ham_detay.alter1*/
        ELSE DO:

            DISPLAY "2-normal kontrolu " ham_detay.stok_kod NO-LABEL.

            FIND FIRST Malzemeler WHERE Malzemeler.Alternatif = FALSE AND Malzemeler.MalzemeKod = ham_detay.stok_kod AND 
                Malzemeler.PartiNo = ham_detay.parti_kod NO-ERROR.
            IF AVAILABLE Malzemeler THEN DO:

                ASSIGN
                    ham_detay.alter1 = FALSE
                    ham_detay.kimin_yerine = Malzemeler.MalzemeKod2
                    ham_detay.stok_kod = Malzemeler.MalzemeKod
                    ham_detay.depo_kod = Malzemeler.DepoKod
                    ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                    ham_detay.fire_miktar = Malzemeler.FMiktar
                    ham_detay.birim = Malzemeler.Birim
                    ham_detay.giris_sekli  = "Manuel"
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = PartiNo.
                    RELEASE ham_detay.
                    DISPLAY "2-tempten siliniyor " Malzemeler.MalzemeKod NO-LABEL.
                    DELETE Malzemeler.
            END. 
            ELSE DO:
                DISPLAY "2-erpden siliniyor " ham_detay.stok_kod NO-LABEL.
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

        FOR EACH ham_detay WHERE ham_detay.firma_kod = ham_master.firma_kod AND 
            ham_detay.ham_masterno = ham_master.ham_masterno AND ham_detay.stok_kod = Malzemeler.MalzemeKod2:

            DISPLAY "2-alternatif " Malzemeler.MalzemeKod2 "," Malzemeler.MalzemeKod "," PartiNo NO-LABEL.

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

         FIND ham_detay WHERE ham_detay.firma_kod = erp_detay2.firma_kod AND 
            ham_detay.stok_kod = Malzemeler.MalzemeKod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND 
            ham_detay.erp_masterno = ham_master.erp_masterno AND (ham_detay.parti_kod EQ "" OR ham_detay.parti_kod EQ PartiNo) NO-ERROR.

         IF AVAILABLE ham_detay THEN DO:
             DISPLAY "3-erp guncellendi " ham_detay.stok_kod NO-LABEL.
             ASSIGN
                 ham_detay.birim = Malzemeler.Birim
                 ham_detay.giris_sekli  = "Manuel"
                 ham_detay.kullanilan_miktar = Malzemeler.KMiktar
                 ham_detay.parti_kod = PartiNo.
             RELEASE ham_detay.
         END.
         ELSE DO:

             FIND stok_kart WHERE stok_kart.firma_kod = erp_detay2.firma_kod AND stok_kart.stok_kod = Malzemeler.MalzemeKod NO-LOCK.
             IF NOT AVAILABLE stok_kart THEN DO:
                 DISPLAY "Malzeme tanimi buluanamadi " Malzemeler.MalzemeKod.
                 NEXT.
             END.

             DISPLAY "3-erp yeni " Malzemeler.MalzemeKod NO-LABEL.

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
                    ham_detay.giris_sekli  = "Manuel" /*"Otomatik"*/
                    ham_detay.kaynak_prog = 'Ür-Giriþ'
                    ham_detay.kaynak_prog3  = 'Üretim-2'
                    ham_detay.parti_kod = PartiNo.
                RELEASE ham_detay.
                RELEASE stok_kart.
         END.        
    END. /* DO Alternatif False */
   

    ASSIGN erp_detay2.entegre_yap = TRUE.
    RELEASE ham_master.
    RELEASE erp_detay2.
END. /*DO END*/



