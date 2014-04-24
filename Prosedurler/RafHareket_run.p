ON FIND OF stok_hareket  OVERRIDE DO: END.
ON FIND OF stok_master  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE RafHareket
    FIELD GirenDepoKod AS CHARACTER FORMAT "X(8)" 
    FIELD CikanDepoKod AS CHARACTER FORMAT "X(8)"
    FIELD GirenRafKod AS CHARACTER FORMAT "X(10)"
    FIELD CikanRafKod AS CHARACTER FORMAT "X(10)"
    FIELD StokKod AS CHARACTER FORMAT "X(25)"
    FIELD RenkKod AS CHARACTER FORMAT "X(20)"
    FIELD Birim AS CHARACTER FORMAT "X(8)"
    FIELD Miktar AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99<<<"
    FIELD PartiKod AS CHARACTER FORMAT "X(20)"
    FIELD Aciklama AS CHARACTER FORMAT "X(20)".    

DEF TEMP-TABLE xhareket_table         
            FIELD stok_kod AS CHAR
            FIELD giren_depo AS CHAR
            FIELD cikan_depo AS CHAR
            FIELD miktar AS DECIMAL
            FIELD gelir_gider AS CHAR
            FIELD masraf_ad AS CHAR
            FIELD masraf_merkez AS CHAR
            FIELD analiz_kod  AS CHAR
            FIELD parti_kod  AS CHAR
            FIELD cari  AS CHAR.

/***************   local variable   ************************/
DEFINE VARIABLE master-no AS RECID.
DEFINE VARIABLE StokHarketVar AS LOGICAL INITIAL FALSE.
DEFINE VARIABLE RafGirisHareketKod AS CHARACTER INITIAL "F-RGIRIS".
DEFINE VARIABLE RafCikisHareketKod AS CHARACTER INITIAL "F-RCIKIS".
DEFINE VARIABLE StokHareketKod AS CHARACTER INITIAL "ST-501".
/***************   giriþ parametreleri   ************************/

DEFINE INPUT PARAMETER FirmaKod AS CHARACTER FORMAT "X(8)".
DEFINE INPUT PARAMETER Kullanici AS CHARACTER FORMAT "X(12)".

DEFINE INPUT PARAMETER GirenDepoKod AS CHARACTER FORMAT "X(8)".
DEFINE INPUT PARAMETER CikanDepoKod AS CHARACTER FORMAT "X(8)".

DEFINE INPUT PARAMETER BelgeNo AS CHARACTER FORMAT "X(12)".    
DEFINE INPUT PARAMETER BelgeTarih AS CHARACTER FORMAT "X(10)".
DEFINE INPUT PARAMETER TABLE FOR RafHareket. 

DEFINE OUTPUT PARAMETER MasterNo AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER INITIAL "".

ASSIGN firma-kod = FirmaKod.
ASSIGN user-kod = Kullanici.


OUTPUT TO VALUE(barset-log-dir + BelgeNo + ".txt").

ISLEM-BLOK:
REPEAT:

    /*TRANSFER ISE DEPO KOD CIKAN DEPO */
    /*GIRIS ISE DEPO KOD GIREN DEPO */
    /*CIKIS ISE DEPO KOD CIKAN DEPO */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

        /*Raf cikis hareket kaydi*/

        FIND hareket_tip WHERE hareket_tip.firma_kod = FirmaKod AND hareket_tip.hareket_kod = RafCikisHareketKod NO-LOCK NO-ERROR.

        IF NOT AVAILABLE hareket_tip THEN DO:            
            ASSIGN IslemSonucu = "Hareket turu bulunamadi " + RafCikisHareketKod.
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
            RETURN ERROR.
        END.

        

        CREATE raf_master.
        ASSIGN 
            raf_master.firma_kod = FirmaKod
            raf_master.user_kod = Kullanici
            raf_master.diger_depo = ""
            raf_master.depo_kod = CikanDepoKod
            raf_master.raf_masterno = NEXT-VALUE(master-kayit-no)
            raf_master.belge_no = BelgeNo
            raf_master.belge_tarih = DATE(BelgeTarih)
            raf_master.hareket_kod = RafCikisHareketKod
            raf_master.aciklama = "Barset tarafindan otomatik olusturulmustur."
            raf_master.giris_cikis = hareket_tip.giris_cikis
            raf_master.entegre_yap   = FALSE.
        master-no = RECID(raf_master).

        FOR EACH RafHareket ON ERROR UNDO, RETURN ERROR:

            FIND stok_kart WHERE stok_kart.firma_kod = FirmaKod AND stok_kart.stok_kod = RafHareket.StokKod NO-LOCK NO-ERROR.

            IF NOT AVAILABLE stok_kart THEN DO:                
                ASSIGN IslemSonucu = "Stok karti bulunamadi " + RafHareket.StokKod.
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
                RETURN ERROR.
            END.

            FIND depo WHERE depo.firma_kod = FirmaKod AND depo.depo_kod = RafHareket.GirenDepoKod NO-LOCK NO-ERROR.

            IF NOT AVAILABLE depo THEN DO:                
                ASSIGN IslemSonucu = "Depo karti bulunamadi " + RafHareket.GirenDepoKod.
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
                RETURN ERROR.
            END.

            FIND depo WHERE depo.firma_kod = FirmaKod AND depo.depo_kod = RafHareket.CikanDepoKod NO-LOCK NO-ERROR.

            IF NOT AVAILABLE depo THEN DO:
                ASSIGN IslemSonucu = "Depo karti bulunamadi " + RafHareket.CikanDepoKod.
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".                
                RETURN ERROR.
            END.

            IF AVAIL depo THEN DO:
                IF AVAIL stok_kart THEN DO:
                    FIND depo_stok WHERE depo_stok.firma_kod = FirmaKod AND depo_stok.depo_kod  = RafHareket.GirenDepoKod AND depo_stok.stok_kod  = RafHareket.StokKod NO-LOCK NO-ERROR .
                    IF NOT AVAILABLE depo_stok THEN DO:
                        MESSAGE "Depo Stok Kaydý Bulunamadý(*):" + RafHareket.GirenDepoKod + ", Stok:" + RafHareket.StokKod VIEW-AS ALERT-BOX TITLE "Hata!".
                        ASSIGN IslemSonucu = "Depo Stok Kaydý Bulunamadý(*):" + RafHareket.GirenDepoKod + ", Stok:" + RafHareket.StokKod.
                        RETURN ERROR.
                    END.
                END.
            END.

            IF AVAIL depo THEN DO:
                IF AVAIL stok_kart THEN DO:
                    FIND depo_stok WHERE depo_stok.firma_kod = FirmaKod AND depo_stok.depo_kod  = RafHareket.CikanDepoKod AND depo_stok.stok_kod  = RafHareket.StokKod NO-LOCK NO-ERROR .
                    IF NOT AVAILABLE depo_stok THEN DO:
                        MESSAGE "Depo Stok Kaydý Bulunamadý(*):" + RafHareket.CikanDepoKod + ", Stok:" + RafHareket.StokKod VIEW-AS ALERT-BOX TITLE "Hata!".
                        ASSIGN IslemSonucu = "Depo Stok Kaydý Bulunamadý(*):" + RafHareket.CikanDepoKod + ", Stok:" + RafHareket.StokKod.
                        RETURN ERROR.
                    END.
                END.
            END.

            IF  RafHareket.CikanDepoKod NE RafHareket.GirenDepoKod THEN DO:
                CREATE xhareket_table.   
                ASSIGN
                    xhareket_table.stok_kod = stok_kart.stok_kod
                    xhareket_table.giren_depo = RafHareket.GirenDepoKod
                    xhareket_table.cikan_depo = RafHareket.CikanDepoKod
                    xhareket_table.miktar = RafHareket.Miktar
                    xhareket_table.gelir_gider = "" 
                    xhareket_table.masraf_ad = ""    
                    xhareket_table.masraf_merkez = "" 
                    xhareket_table.analiz_kod  = ""    
                    xhareket_table.parti_kod = RafHareket.PartiKod  
                    xhareket_table.cari = "".
                RELEASE  xhareket_table.      
                StokHarketVar = TRUE.
            END.

            CREATE raf_detay.
            ASSIGN 
                raf_detay.firma_kod = FirmaKod
                raf_detay.raf_masterno = raf_master.raf_masterno
                raf_detay.raf_detayno  = NEXT-VALUE(detay-kayit-no)
                raf_detay.belge_tarih  = raf_master.belge_tarih
                raf_detay.user_kod     = raf_master.user_kod
                raf_detay.depo_kod     = raf_master.depo_kod
                raf_detay.diger_depo   = raf_master.diger_depo
                raf_detay.giris_cikis  = hareket_tip.giris_cikis
                raf_detay.hareket_kod  = raf_master.hareket_kod
                raf_detay.belge_no     = raf_master.belge_no
                raf_detay.stok_kod     = stok_kart.stok_kod
                raf_detay.stok_ad      = stok_kart.stok_ad
                raf_detay.raf_kod      = RafHareket.CikanRafKod
                raf_detay.parti_kod    = RafHareket.PartiKod
                raf_detay.renk_no      = RafHareket.RenkKod
                raf_detay.aciklama     = RafHareket.Aciklama
                raf_detay.dbirim       = RafHareket.Birim
                raf_detay.dmiktar      = RafHareket.Miktar.
            RELEASE raf_detay.
            DetaySatir = DetaySatir + 1.

        END. /* END FOR EACH */

        MasterNo = raf_master.raf_masterno.
        raf_master.entegre_yap = TRUE.
        RELEASE raf_master.

        /*Raf giris hareket kaydi*/

        FIND hareket_tip WHERE hareket_tip.firma_kod = FirmaKod AND hareket_tip.hareket_kod = RafGirisHareketKod  NO-LOCK NO-ERROR.

        IF NOT AVAILABLE hareket_tip THEN DO:            
            ASSIGN IslemSonucu = "Hareket turu bulunamadi " + RafGirisHareketKod .
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
            RETURN ERROR.
        END.

        

        CREATE raf_master.
        ASSIGN 
            raf_master.firma_kod = FirmaKod
            raf_master.user_kod = Kullanici
            raf_master.diger_depo = ""
            raf_master.depo_kod = GirenDepoKod
            raf_master.raf_masterno = NEXT-VALUE(master-kayit-no)
            raf_master.belge_no = "G_" + BelgeNo
            raf_master.belge_tarih = date(BelgeTarih)
            raf_master.hareket_kod = RafGirisHareketKod
            raf_master.aciklama = "Barset tarafindan otomatik olusturulmustur."
            raf_master.giris_cikis = hareket_tip.giris_cikis
            raf_master.entegre_yap   = FALSE.
        master-no = RECID(raf_master).

        FOR EACH RafHareket ON ERROR UNDO, RETURN ERROR:

            FIND stok_kart WHERE stok_kart.firma_kod = FirmaKod AND stok_kart.stok_kod = RafHareket.StokKod NO-LOCK NO-ERROR.

            IF NOT AVAILABLE stok_kart THEN DO:                
                ASSIGN IslemSonucu = "Stok karti bulunamadi " + RafHareket.StokKod.
                MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata!".
                RETURN ERROR.
            END.

            CREATE raf_detay.
            ASSIGN 
                raf_detay.firma_kod = FirmaKod
                raf_detay.raf_masterno = raf_master.raf_masterno
                raf_detay.raf_detayno  = NEXT-VALUE(detay-kayit-no)
                raf_detay.belge_tarih  = raf_master.belge_tarih
                raf_detay.user_kod     = raf_master.user_kod
                raf_detay.depo_kod     = raf_master.depo_kod
                raf_detay.diger_depo   = raf_master.diger_depo
                raf_detay.giris_cikis  = hareket_tip.giris_cikis
                raf_detay.hareket_kod  = raf_master.hareket_kod
                raf_detay.belge_no     = raf_master.belge_no
                raf_detay.stok_kod     = stok_kart.stok_kod
                raf_detay.stok_ad      = stok_kart.stok_ad
                raf_detay.raf_kod      = RafHareket.GirenRafKod
                raf_detay.parti_kod    = RafHareket.PartiKod
                raf_detay.renk_no      = RafHareket.RenkKod
                raf_detay.aciklama     = RafHareket.Aciklama
                raf_detay.dbirim       = RafHareket.Birim
                raf_detay.dmiktar      = RafHareket.Miktar.
            RELEASE raf_detay.
            DetaySatir = DetaySatir + 1.

        END. /* END FOR EACH */

        MasterNo = raf_master.raf_masterno.
        raf_master.entegre_yap = TRUE.
        RELEASE raf_master.
            
         

        IF StokHarketVar EQ TRUE  THEN DO:            
            RUN hareket_stok_run (
                INPUT FirmaKod, 
                INPUT Kullanici, 
                INPUT "raf" + BelgeNo, 
                INPUT BelgeTarih, 
                INPUT StokHareketKod, 
                INPUT TABLE xhareket_table, 
                OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).            
        END.

    END.
              
LEAVE ISLEM-BLOK.
END.

OUTPUT CLOSE.

ON FIND OF stok_hareket REVERT.
ON FIND OF stok_master REVERT.
