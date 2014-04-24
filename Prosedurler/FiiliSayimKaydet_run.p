r

ON FIND OF firma OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE xsay_table
            FIELD stok_kod        AS CHARACTER 
            FIELD miktar          AS DECIMAL
            FIELD parti_kod       AS CHARACTER 
            FIELD renk_no         AS CHARACTER 
            FIELD kalite_kod      AS CHARACTER
            FIELD ozellik_kod1    AS CHARACTER
            FIELD ozellik_kod2    AS CHARACTER
            FIELD ozellik_kod3    AS CHARACTER
            FIELD raf_kod         AS CHARACTER.
    /*INDEX kod1 IS UNIQUE PRIMARY stok_kod parti_kod.*/

DEF TEMP-TABLE Sayilmayacaklar
            FIELD stok_kod        AS CHARACTER 
            FIELD depo_kod        AS CHARACTER
     INDEX idx stok_kod ASCENDING depo_kod ASCENDING.

DEFINE INPUT PARAMETER TABLE FOR xsay_table.

DEFINE INPUT PARAMETER fkod  AS CHARACTER.
DEFINE INPUT PARAMETER ukod  AS CHARACTER.
DEFINE INPUT PARAMETER bno AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER.
DEFINE INPUT PARAMETER depokod AS CHARACTER.

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

DEFINE VARIABLE xRecId AS RECID.

ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + "sayim_kaydet" + ukod + ".txt").

ISLEM-BLOK:
REPEAT:

    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

        /*RUN SayilmayacakStoklariAl (INPUT depokod, OUTPUT TABLE Sayilmayacaklar).*/

        FIND FIRST depo WHERE depo.firma_kod EQ fkod AND depo.depo_kod EQ depokod NO-LOCK NO-ERROR.
        IF NOT AVAILABLE depo THEN DO:
             MESSAGE "DEPO BELGESI BULUNAMADI! " depokod VIEW-AS ALERT-BOX TITLE "HATA!".
             RETURN ERROR.
        END.

        FIND FIRST dsayim_master WHERE dsayim_master.firma_kod EQ fkod AND dsayim_master.depo_kod EQ depokod AND dsayim_master.belge_no EQ bno NO-LOCK NO-ERROR.
        IF NOT AVAILABLE dsayim_master THEN DO:
            CREATE dsayim_master.
            ASSIGN
                dsayim_master.firma_kod = fkod
                dsayim_master.depo_kod = depo.depo_kod
                dsayim_master.belge_no = bno
                dsayim_master.tarih = DATE(btarih)
                dsayim_master.dsayim_master = NEXT-VALUE(master-kayit-no)
                dsayim_master.user_kod = ukod
                dsayim_master.aciklama = "Barset tarafindan olusturulmustur."
                dsayim_master.create_time = REPLACE(STRING(TIME,"HH:MM"), ":", "")
                dsayim_master.create_user = ukod.
            xRecId = RECID(dsayim_master).
            RELEASE dsayim_master.
            FIND dsayim_master WHERE RECID(dsayim_master) = xRecId  EXCLUSIVE-LOCK NO-PREFETCH NO-ERROR.
        END.
        IF NOT AVAILABLE dsayim_master THEN DO:
            MESSAGE "SAYIM BELGESI BULUNAMADI!" VIEW-AS ALERT-BOX TITLE "HATA!".
            RETURN ERROR.
        END.

        FOR EACH xsay_table ON ERROR UNDO, RETURN ERROR:

            FIND stok_kart WHERE firma_kod EQ dsayim_master.firma_kod AND stok_kart.stok_kod EQ TRIM(xsay_table.stok_kod) NO-LOCK NO-ERROR.
            IF NOT AVAILABLE stok_kart THEN DO:
                MESSAGE "STOK KARTI BULUNAMADI! " xsay_table.stok_kod VIEW-AS ALERT-BOX TITLE "HATA!".
                RETURN ERROR.
            END.                      

            CREATE dsayim_detay.
            ASSIGN
                dsayim_detay.firma_kod = dsayim_master.firma_kod
                dsayim_detay.depo_kod = depo.depo_kod
                dsayim_detay.belge_no = bno
                dsayim_detay.stok_kod = stok_kart.stok_kod
                dsayim_detay.stok_ad = stok_kart.stok_ad
                dsayim_detay.tarih = dsayim_master.tarih
                dsayim_detay.miktar = xsay_table.miktar
                dsayim_detay.user_kod = ukod
                dsayim_detay.dsayim_master = dsayim_master.dsayim_master
                /*dsayim_detay.dsayim_detayno = NEXT-VALUE(detay-kayit-no)*/
                dsayim_detay.parti_kod = xsay_table.parti_kod
                dsayim_detay.raf_kod = xsay_table.raf_kod
                dsayim_detay.renk_no = xsay_table.renk_no
                dsayim_detay.kalite_kod = xsay_table.kalite_kod
                dsayim_detay.ozellik_kod1 = xsay_table.ozellik_kod1
                dsayim_detay.ozellik_kod2 = xsay_table.ozellik_kod2
                dsayim_detay.ozellik_kod3 = xsay_table.ozellik_kod3
                dsayim_detay.create_time = REPLACE(STRING(TIME,"HH:MM"), ":", "")
                dsayim_detay.create_user = ukod.
            RELEASE stok_kart.
            RELEASE dsayim_detay.            
            detay_satir = detay_satir + 1.

        END. /*END EACH xsay_table*/

        /*Depo stokta olupta sayilmayan stoklar sifir olarak sayilmis gibi atiliyor!*/
        FOR EACH depo_stok WHERE depo_stok.firma_kod = dsayim_master.firma_kod AND depo_stok.depo_kod = depo.depo_kod NO-LOCK:

            IF NOT CAN-FIND(FIRST xsay_table WHERE xsay_table.stok_kod = depo_stok.stok_kod) THEN DO:
                /*Bazi stoklar istisna olacak*/
                IF NOT CAN-FIND(FIRST Sayilmayacaklar WHERE Sayilmayacaklar.depo_kod = depo.depo_kod AND Sayilmayacaklar.stok_kod = depo_stok.stok_kod) THEN DO:

                    FIND stok_kart WHERE stok_kart.firma_kod = dsayim_master.firma_kod AND stok_kart.stok_kod = depo_stok.stok_kod NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE stok_kart THEN DO:
                        MESSAGE "STOK KARTI BULUNAMADI! (2) " depo_stok.stok_kod VIEW-AS ALERT-BOX TITLE "HATA!".
                        RETURN ERROR.
                    END.

                    IF stok_kart.aktif_pasif = "Aktif" THEN DO:

                        CREATE dsayim_detay.
                        ASSIGN
                            dsayim_detay.firma_kod = dsayim_master.firma_kod
                            dsayim_detay.depo_kod = depo.depo_kod
                            dsayim_detay.belge_no = bno
                            dsayim_detay.stok_kod = stok_kart.stok_kod
                            dsayim_detay.stok_ad = stok_kart.stok_ad
                            dsayim_detay.tarih = dsayim_master.tarih
                            dsayim_detay.miktar = 0
                            dsayim_detay.user_kod = ukod
                            dsayim_detay.dsayim_master = dsayim_master.dsayim_master
                            /*dsayim_detay.dsayim_detayno = NEXT-VALUE(detay-kayit-no)*/
                            dsayim_detay.parti_kod = ""
                            dsayim_detay.raf_kod = ""
                            dsayim_detay.renk_no = ""
                            dsayim_detay.kalite_kod = ""
                            dsayim_detay.ozellik_kod1 = ""
                            dsayim_detay.ozellik_kod2 = ""
                            dsayim_detay.ozellik_kod3 = ""
                            dsayim_detay.create_time = REPLACE(STRING(TIME,"HH:MM"), ":", "")
                            dsayim_detay.create_user = ukod.
                        RELEASE stok_kart.
                        RELEASE dsayim_detay.            
                        detay_satir = detay_satir + 1.
                        
                    END.  

                END. /*END Sayilmayacaklar*/

            END. /* END xsay_table */

      

        END. /* END depo_stok */

        ASSIGN master_no = DEC(xRecId).
        RELEASE dsayim_master.

    END. /*END TRANSACTION*/

    islem_sonucu = "ok".
LEAVE ISLEM-BLOK.
END. /*END REPEAT*/

OUTPUT CLOSE.

ON FIND OF firma REVERT.
