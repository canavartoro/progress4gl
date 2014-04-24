

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}


DEF TEMP-TABLE v_isemirleri
    FIELD erp_masterno AS DECIMAL FORMAT ">>>,>>>,>>>,>>9":U
    FIELD erp_detayno AS DECIMAL FORMAT ">>>,>>>>>>,>>9":U
    FIELD isemri_no AS CHARACTER FORMAT "X(15)":U
    FIELD stok_id AS INTEGER
    FIELD stok_kod AS CHARACTER FORMAT "X(25)":U
    FIELD stok_ad AS CHARACTER FORMAT "X(50)":U
    FIELD birim_id AS INTEGER
    FIELD birim AS CHARACTER FORMAT "X(8)":U
    FIELD pmiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99<<<":U    
    FIELD istasyon_id AS INTEGER
    FIELD istasyon_kod AS CHARACTER FORMAT "X(10)":U
    FIELD istasyon_ad AS CHARACTER FORMAT "X(50)":U
    FIELD operasyon_id AS INTEGER
    FIELD operasyon_kod AS CHARACTER FORMAT "X(10)":U
    FIELD operasyon_ad AS CHARACTER FORMAT "X(50)":U
    FIELD ismerkezi_id AS INTEGER
    FIELD ismer_kod AS CHARACTER FORMAT "X(10)":U
    FIELD ismer_ad AS CHARACTER FORMAT "X(40)":U
    FIELD bas_tarih AS CHARACTER FORMAT "99/99/9999":U
    FIELD bas_saat AS CHARACTER FORMAT "99:99":U
    FIELD bitis_tarih AS CHARACTER FORMAT "99/99/9999":U
    FIELD bitis_saat AS CHARACTER FORMAT "99:99":U.

DEFINE OUTPUT PARAMETER TABLE FOR v_isemirleri.

DEFINE INPUT PARAMETER Kod AS CHARACTER.
DEFINE INPUT PARAMETER Ad AS CHARACTER.
DEFINE INPUT PARAMETER Aciklama AS CHARACTER.
DEFINE INPUT PARAMETER Kod1 AS CHARACTER.
DEFINE INPUT PARAMETER Kod2 AS CHARACTER.
DEFINE INPUT PARAMETER Kod3 AS CHARACTER.
    
DEFINE INPUT PARAMETER Firma AS CHARACTER.
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.    

FOR EACH erp_master WHERE erp_master.firma_kod = Firma 
        AND erp_master.isemri_durum = TRUE 
        AND erp_master.isemri_no BEGINS Kod   
        AND erp_master.stok_kod BEGINS Ad
        AND erp_master.stok_ad BEGINS Aciklama
        USE-INDEX ters-isemri-ndx NO-LOCK , 
    /*EACH erp_detay OF erp_master NO-LOCK,*/ EACH stok_kart OF erp_master NO-LOCK 
    /*EACH stok_birim OF erp_master NO-LOCK , EACH is_istasyon OF erp_detay NO-LOCK,
    EACH operasyon_kart OF erp_detay NO-LOCK*/
    ON ERROR UNDO, RETURN ERROR:

    CREATE v_isemirleri.
    ASSIGN
        v_isemirleri.erp_masterno = erp_master.erp_masterno
        /*v_isemirleri.erp_detayno = erp_detay.erp_detayno*/
        v_isemirleri.isemri_no = erp_master.isemri_no
        v_isemirleri.stok_id = RECID(stok_kart)
        v_isemirleri.stok_kod = erp_master.stok_kod
        v_isemirleri.stok_ad = erp_master.stok_ad
        /*v_isemirleri.birim_id = RECID(stok_birim)*/
        v_isemirleri.birim = erp_master.birim
        /*v_isemirleri.pmiktar = erp_detay.pmiktar
        v_isemirleri.istasyon_id = RECID(is_istasyon)
        v_isemirleri.istasyon_kod = is_istasyon.istasyon_kod
        v_isemirleri.istasyon_ad = is_istasyon.istasyon_ad
        v_isemirleri.operasyon_id = RECID(operasyon_kart)
        v_isemirleri.operasyon_kod = erp_detay.operasyon_kod
        v_isemirleri.operasyon_ad = operasyon_kart.operasyon_ad
        v_isemirleri.ismerkezi_id = 0
        v_isemirleri.ismer_kod = erp_detay.ismer_kod
        v_isemirleri.ismer_ad = erp_detay.ismer_kod*/
        v_isemirleri.bas_tarih = STRING(erp_master.bas_tarih, "99/99/9999")
        v_isemirleri.bas_saat = erp_master.bas_saat
        v_isemirleri.bitis_tarih = STRING(erp_master.bitis_tarih, "99/99/9999")
        v_isemirleri.bitis_saat = erp_master.bitis_saat.
    RELEASE v_isemirleri.


    Row_Limit = Row_Limit + 1.

    IF Row_Limit GE Limit THEN DO:
        LEAVE.
    END.

END.


/*FOR EACH erp_master WHERE erp_master.firma_kod = "ARMA2011" AND erp_master.isemri_durum = TRUE NO-LOCK, 
    EACH stok_kart OF erp_master NO-LOCK, EACH stok_birim OF erp_master NO-LOCK, 
    EACH erp_detay OF erp_master NO-LOCK, EACH is_istasyon OF erp_detay NO-LOCK, 
    EACH operasyon_kart OF erp_detay NO-LOCK, EACH is_merkezi OF stok_kart NO-LOCK ON ERROR UNDO, RETURN ERROR:

    DISPLAY erp_master.isemri_no " " erp_master.erp_masterno " "
        erp_master.stok_kod " " STRING(erp_master.pmiktar) " "
        erp_master.birim " " erp_master.recete_kod NO-LABELS SKIP.

    Limit = Limit + 1.

    IF Limit GE 100 THEN DO:
        LEAVE.
    END.


END.*/

/*FOR EACH erp_master WHERE erp_master.firma_kod = "ARMA2011" AND erp_master.isemri_durum = TRUE 
    USE-INDEX ters-isemri-ndx NO-LOCK ON ERROR UNDO, RETURN ERROR:

    DISPLAY erp_master.isemri_no " " erp_master.erp_masterno " "
        erp_master.stok_kod " " STRING(erp_master.pmiktar) " "
        erp_master.birim " " erp_master.recete_kod NO-LABELS SKIP.

    Limit = Limit + 1.

    IF Limit GE 100 THEN DO:
        LEAVE.
    END.

END.*/
