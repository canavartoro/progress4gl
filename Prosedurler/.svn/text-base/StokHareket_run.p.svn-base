ON FIND OF stok_hareket  OVERRIDE DO: END.
ON FIND OF stok_master  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEFINE TEMP-TABLE xStokHareket
    FIELD StokKod       AS CHARACTER    LABEL "stok_kod"
    FIELD Birim         AS CHARACTER    LABEL "dbirim"
    FIELD Miktar        AS DECIMAL      LABEL "dmiktar"
    FIELD GelirGider    AS CHARACTER    LABEL "gelirgider_kod"
    FIELD MasrafAd      AS CHARACTER    LABEL "masraf_ad"
    FIELD MasrafMerkez  AS CHARACTER    LABEL "masraf_merkez"
    FIELD AnalizKod     AS CHARACTER    LABEL "analiz_kod"
    FIELD PartiKod      AS CHARACTER    LABEL "parti_kod"
    FIELD Aciklama      AS CHARACTER    LABEL "aciklama"
    FIELD Aciklama2     AS CHARACTER    LABEL "aciklama2"
    FIELD Aciklama3     AS CHARACTER    LABEL "aciklama3"
    FIELD IslemNedeni   AS CHARACTER    LABEL "cikis_neden"
    FIELD IslemNedenAd  AS CHARACTER    LABEL "neden_ad".

DEFINE INPUT PARAMETER FirmaKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KullaniciKod AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER BelgeNo      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER BelgeTarih   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER HareketKod   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER DepoKod      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER DigerDepo    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER CariKod      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Aciklama     AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER TABLE FOR xStokHareket. 

DEFINE OUTPUT PARAMETER MasterNo    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir  AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

DEFINE VARIABLE stok_master_id AS RECID NO-UNDO.

ASSIGN firma-kod = FirmaKod.
ASSIGN user-kod = KullaniciKod.

OUTPUT TO VALUE(barset-log-dir + "stok_" + BelgeNo + ".txt"). /* APPEND.*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND depo WHERE depo.firma_kod = firma-kod AND depo_kod = DepoKod NO-LOCK NO-ERROR.

    IF NOT AVAILABLE depo THEN DO:
        IslemSonucu = "Depo Kodu Bulunamadý:" + DepoKod.
        MESSAGE "Depo Kodu Bulunamadý:" DepoKod VIEW-AS ALERT-BOX TITLE "U y a r ý...".            
        RETURN ERROR.  
    END.

    IF DigerDepo NE "" THEN DO:        
        FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = DigerDepo NO-LOCK NO-ERROR.
        IF NOT AVAILABLE depo THEN DO:
            IslemSonucu = "Depo Kodu Bulunamadý:" + DigerDepo.
            MESSAGE "Depo Kodu Bulunamadý:" DigerDepo VIEW-AS ALERT-BOX TITLE "U y a r ý...".
            RETURN ERROR.
        END.
    END.   

    FIND FIRST stok_master WHERE stok_master.firma_kod = firma-kod AND stok_master.belge_no = BelgeNo AND stok_master.belge_tarih = DATE(BelgeTarih) NO-LOCK NO-ERROR.
    IF AVAILABLE stok_master THEN DO:
        IslemSonucu = "Stok hareketi daha once erpye aktarilmis tekrar aktaramazsiniz:" + stok_master.belge_no.
        MESSAGE "Stok hareketi daha once erpye aktarilmis tekrar aktaramazsiniz:" + stok_master.belge_no VIEW-AS ALERT-BOX TITLE "U y a r ý...".
        RETURN ERROR.
    END.

    /*Stok Master*/
    CREATE stok_master.
        ASSIGN
            stok_master.belge_tarih   = DATE(BelgeTarih)
            stok_master.hareket_kod   = HareketKod 
            stok_master.depo_kod      = DepoKod
            stok_master.diger_depo    = DigerDepo
            stok_master.belge_no      = BelgeNo
            stok_master.firma_kod     = firma-kod 
            stok_master.cari_kod      = CariKod
            stok_master.stok_masterno = NEXT-VALUE(master-kayit-no)
            stok_master.user_kod      = user-kod
            stok_master.aciklama      = "Mikrobar'dan Uyum'a Oto.Atýlmýþtýr..." 
            stok_master.aciklama2     = Aciklama
            stok_master.kaynak_prog   = 'Stok'.
        stok_master_id = RECID(stok_master).
        RELEASE stok_master.
        FIND stok_master WHERE RECID(stok_master) = stok_master_id EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    /*Stok Master End*/
    IF  NOT AVAILABLE stok_master THEN DO:
        IslemSonucu = "Belge bilgilerinde hata var! (stok_master)".
        MESSAGE "Belge bilgilerinde hata var! (stok_master)" VIEW-AS ALERT-BOX TITLE "Hata!".        
        RETURN ERROR.
    END.

    DEFINE VARIABLE lineNo AS INTEGER INITIAL 10.
    FOR EACH xStokHareket ON ERROR UNDO, RETURN ERROR:
        FIND stok_kart WHERE firma_kod = firma-kod AND stok_kart.stok_kod = xStokHareket.StokKod NO-LOCK NO-ERROR.

        IF NOT AVAILABLE stok_kart THEN DO:
            IslemSonucu = "Stok Kodu Bulunamadý:" + xStokHareket.StokKod.
            MESSAGE "Stok Kodu Bulunamadý:" xStokHareket.StokKod VIEW-AS ALERT-BOX TITLE "U y a r ý...".
            RETURN ERROR.  
        END.  

        FIND depo WHERE depo.firma_kod = firma-kod AND depo.depo_kod = DepoKod NO-LOCK NO-ERROR.

        IF NOT AVAILABLE depo THEN DO:
            IslemSonucu = "Depo Kodu Bulunamadý:" + DepoKod.
            MESSAGE "Depo Kodu Bulunamadý:" DepoKod VIEW-AS ALERT-BOX TITLE "U y a r ý...".            
            RETURN ERROR.  
        END.

        IF AVAIL depo THEN DO:
            IF AVAIL stok_kart THEN DO:
                FIND depo_stok WHERE depo_stok.firma_kod = firma-kod AND depo_stok.depo_kod  = DepoKod AND depo_stok.stok_kod  = xStokHareket.StokKod NO-LOCK NO-ERROR.
                IF NOT AVAILABLE depo_stok THEN DO:
                    IslemSonucu = "Depo Stok Kaydý Bulunamadý(*):" + DepoKod  + " Stok: " + xStokHareket.StokKod.
                    MESSAGE "Depo Stok Kaydý Bulunamadý(*):" DepoKod ", Stok:" xStokHareket.StokKod VIEW-AS ALERT-BOX TITLE "B i l g i...".
                    RETURN ERROR.                    
                END.
            END.
        END.

        FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND stok_kart.stok_kod  = xStokHareket.StokKod NO-LOCK NO-ERROR.

        DISPLAY stok_kart.gelirgider_kod NO-LABEL.
        MESSAGE stok_master.belge_tarih VIEW-AS ALERT-BOX INFO TITLE "OK".

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
			stok_hareket.aciklama      = xStokHareket.Aciklama
            stok_hareket.aciklama2     = xStokHareket.Aciklama2
            stok_hareket.aciklama3     = xStokHareket.Aciklama3
			stok_hareket.user_kod      = user-kod
			stok_hareket.kaynak_prog   = 'Stok'
            stok_hareket.hareket_miktar= xStokHareket.Miktar
			stok_hareket.dmiktar       = xStokHareket.Miktar
			stok_hareket.parti_kod     = xStokHareket.PartiKod
			stok_hareket.gelirgider_kod= IF xStokHareket.GelirGider EQ "" THEN stok_kart.gelirgider_kod ELSE xStokHareket.GelirGider
			stok_hareket.masraf_ad     = xStokHareket.MasrafAd
			stok_hareket.masraf_merkez = xStokHareket.MasrafMerkez
			stok_hareket.analiz_kod    = xStokHareket.AnalizKod
			stok_hareket.cari_kod	   = CariKod
            stok_hareket.cikis_neden   = xStokHareket.IslemNedeni
            stok_hareket.neden_ad	   = xStokHareket.IslemNedenAd
            stok_hareket.sira_no       = lineNo
			stok_hareket.dbirim        = IF xStokHareket.Birim EQ "" THEN stok_kart.birim ELSE xStokHareket.Birim.
            DetaySatir = DetaySatir + 1.
            lineNo = lineNo + 10.
            RELEASE stok_hareket.

    END. /*END xStokHareket*/

    stok_master.entegre_yap = TRUE.
    RELEASE stok_master.
END. /*END TRANSACTION*/

MasterNo = stok_master_id.

OUTPUT CLOSE.

/*IF NOT SEARCH(barset-log-dir + "stok_" + BelgeNo + ".txt") = ? THEN DO:
    DEFINE VARIABLE xfile-line AS CHARACTER INITIAL "".
    INPUT FROM VALUE(SEARCH(barset-log-dir + "stok_" + BelgeNo + ".txt") ) NO-ECHO.
      REPEAT:
      IMPORT UNFORMATTED xfile-line.
        SET IslemSonucu = IslemSonucu + xfile-line.
      END.
    INPUT CLOSE.
END.*/

ON FIND OF stok_hareket REVERT.
ON FIND OF stok_master REVERT.
