
ON FIND OF kon_master  OVERRIDE DO: END.
ON FIND OF kon_detay  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}



DEF TEMP-TABLE xdetay_table
            FIELD belge_tarih AS CHAR FORMAT "X(10)"
            FIELD belge_no AS CHAR FORMAT "X(15)"
            FIELD depo_kod AS CHAR FORMAT "X(32)"
            FIELD diger_depo AS CHAR FORMAT "X(32)"
            FIELD cari_kod AS CHAR FORMAT "X(32)"
            FIELD stok_kod AS CHARACTER FORMAT "X(32)":U        
            FIELD hareket_miktar AS DECIMAL
            FIELD Birim AS CHARACTER FORMAT "X(32)":U            
            FIELD sira AS INT FORMAT "->>>".

/***************   local variable   ************************/
DEF VAR trecid AS RECID.
DEF VAR hrecid AS RECID.
DEF VAR xrowid AS ROWID.
DEF VAR xlog-file AS CHAR.
DEF VAR xfile-line AS CHAR.
DEF VAR xkur LIKE dovkur.kur.
DEF VAR xtarih AS DATE.
DEF VAR har-kod2 LIKE entegre.stok_hareket.hareket_kod.
DEF VAR barset-log-dir AS CHAR FORMAT "X(50)".

/***************   GIRIS PARAMETRELERI   ************************/


DEFINE INPUT PARAMETER FirmaKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KullaniciKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER BelgeNo      AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER TABLE FOR xdetay_table. 

DEFINE OUTPUT PARAMETER MasterNo    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir  AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = FirmaKod.
ASSIGN user-kod = KullaniciKod.

DEFINE BUFFER bufdetay FOR xdetay_table.

OUTPUT TO VALUE(barset-log-dir + BelgeNo + ".txt").

ISLEM-BLOK:
REPEAT:

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FOR EACH xdetay_table BREAK BY xdetay_table.depo_kod ON ERROR UNDO, RETURN ERROR:                

        MESSAGE xdetay_table.stok_kod xdetay_table.depo_kod 
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
        

        IF FIRST-OF(xdetay_table.depo_kod) THEN DO:

             CREATE kon_master.
             ASSIGN kon_master.firma_kod            = firma-kod 
                    kon_master.bas_tarih            = DATE(xdetay_table.belge_tarih) 
                    kon_master.belge_no             = xdetay_table.belge_no 
                    kon_master.hareket_kod1         = "KON.CIKIS"
                    kon_master.hareket_kod2         = "KON.GIRIS"
                    kon_master.depo_kod             = xdetay_table.depo_kod
                    kon_master.diger_depo           = xdetay_table.diger_depo
                    kon_master.aciklama             = "Mikrobar tarafindan olusturulmustur".             
                 trecid = RECID(kon_master).
                 MESSAGE trecid xdetay_table.depo_kod xdetay_table.diger_depo xdetay_table.stok_kod xdetay_table.sira
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                 FIND kon_master WHERE RECID(kon_master) = trecid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

                 IF NOT AVAILABLE kon_master THEN DO:
                     MESSAGE "Konsinye kaydinin ust bilgilerinde hata olustu! "
                         VIEW-AS ALERT-BOX INFO BUTTONS OK.
                     RETURN ERROR.
                 END.

                 FOR EACH bufdetay WHERE bufdetay.depo_kod = xdetay_table.depo_kod ON ERROR UNDO, RETURN ERROR:

                     FIND stok_kart WHERE stok_kart.firma_kod = firma-kod
                          AND stok_kart.stok_kod  = bufdetay.stok_kod NO-LOCK NO-ERROR.

                     IF NOT AVAILABLE stok_kart THEN DO:
                         MESSAGE "Stok karti bulunamadi " bufdetay.stok_kod
                             VIEW-AS ALERT-BOX INFO BUTTONS OK.
                         RETURN ERROR.
                     END.
            
                     CREATE kon_detay.
                     ASSIGN kon_detay.firma_kod     = firma-kod  
                            kon_detay.kon_masterno  = kon_master.kon_masterno
                            kon_detay.belge_no      = kon_master.belge_no
                            kon_detay.belge_tarih   = kon_master.bas_tarih
                            kon_detay.stok_kod      = xdetay_table.stok_kod
                            kon_detay.stok_ad       = stok_kart.stok_ad
                            kon_detay.dbirim        = bufdetay.Birim
                            kon_detay.depo_kod      = kon_master.depo_kod
                            kon_detay.diger_depo    = kon_master.diger_depo
                            kon_detay.dmiktar       = bufdetay.hareket_miktar
                            kon_detay.hareket_miktar= bufdetay.hareket_miktar.         
                                 
                     hrecid = RECID(kon_detay).
                     RELEASE kon_detay.
                     DetaySatir = DetaySatir + 1.

                 END.
                 

        END.

    END. /*FOR EACH xdetay_table*/

    kon_master.entegre_yap = TRUE.
    MasterNo = kon_master.kon_masterno.
    trecid = RECID(kon_master).
    RELEASE kon_master.
END.  /*END TRAN */


IF trecid > 0 THEN DO:
    DISPLAY " kayýt-no =" STRING(trecid) ",detay =" STRING(DetaySatir).
END.

LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */

/*IF ERROR-STATUS:ERROR THEN DO:
    FOR EACH irsaliye_master WHERE irsaliye_master.belge_no EQ bno NO-LOCK:
        DISPLAY "Ýç Hata " SKIP(1)
            "firma:" irsaliye_master.firma_kod 
            "cari:" irsaliye_master.cari_kod 
            "belge:" irsaliye_master.belge_no 
            "hareket:" irsaliye_master.hareket_kod.
    END.
END.*/

OUTPUT CLOSE.  /* CIKIS DOSYASINI KAPAT */

ON FIND OF kon_master  REVERT.
ON FIND OF kon_detay  REVERT.

/************<<<<<<LOG KAYDINI ISTEMCIYE EKTARMAK ICIN OKU>>>>>>*********/
INPUT FROM VALUE(SEARCH(barset-log-dir + BelgeNo + ".txt") ) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
  SET IslemSonucu = IslemSonucu + xfile-line.  
  END.
INPUT CLOSE.

/************<<<<<<LOG DOSYASI SILINEBILIR>>>>>>*********/
/*OS-DELETE VALUE(xlog-file + bno + ".txt") NO-ERROR.*/




