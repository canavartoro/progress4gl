
{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEFINE TEMP-TABLE irs_master
                  FIELD belge_no         LIKE irsaliye_master.belge_no  
                  FIELD belge_tarih      AS CHARACTER
                  FIELD hareket_kod      LIKE irsaliye_master.hareket_kod
                  FIELD aciklama         LIKE irsaliye_master.aciklama
                  FIELD mal_tutar        LIKE irsaliye_master.mal_tutar
                  FIELD kdv_tutar        LIKE irsaliye_master.kdv_tutar
                  FIELD irsaliye_tutar   LIKE irsaliye_master.irsaliye_tutar
                  FIELD irsaliye_master  LIKE irsaliye_master.irsaliye_master
                  FIELD xbelge_no  AS CHARACTER.

DEFINE VARIABLE xlog-line AS CHARACTER.

/***************   giriþ parametreleri   ************************/

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER.

DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.
DEFINE OUTPUT PARAMETER TABLE FOR irs_master.

ON FIND OF irsaliye_master OVERRIDE DO: END.    

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.


ISLEM-BLOK:
REPEAT:

FOR EACH irsaliye_master FIELDS(belge_no belge_tarih hareket_kod aciklama mal_tutar kdv_tutar irsaliye_tutar irsaliye_master irsaliye_aciklama) 
    WHERE   irsaliye_master.firma_kod = firma-kod 
            AND irsaliye_master.fatura_durum = FALSE 
            AND irsaliye_master.create_user = ukod   
            AND irsaliye_master.belge_tarih >= date(btarih) /*DATE(NOW)*/
        NO-LOCK:

    CREATE  irs_master.
    ASSIGN 
        irs_master.belge_no = irsaliye_master.belge_no
        irs_master.belge_tarih = STRING(irsaliye_master.belge_tarih)
        irs_master.hareket_kod = irsaliye_master.hareket_kod
        irs_master.aciklama = irsaliye_master.aciklama        
        irs_master.mal_tutar = irsaliye_master.mal_tutar
        irs_master.kdv_tutar = irsaliye_master.kdv_tutar
        irs_master.irsaliye_tutar = irsaliye_master.irsaliye_tutar
        irs_master.irsaliye_master = irsaliye_master.irsaliye_masterno /*recid(irsaliye_master)*/
        irs_master.xbelge_no = irsaliye_master.irsaliye_aciklama[5].
    RELEASE irs_master.
END.
  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */


ON FIND OF irsaliye_master REVERT.    



