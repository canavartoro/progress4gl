
{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

    /***************   local variable   ************************/

DEFINE VARIABLE xlog-file AS CHARACTER NO-UNDO.
DEFINE VARIABLE xfile-line AS CHARACTER NO-UNDO.

/***************   giris parametreleri   ************************/

DEFINE INPUT PARAMETER xFirmaKod AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xUserKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xLogFile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xKayitId AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = xFirmaKod.
ASSIGN user-kod = xUserKod.

OUTPUT TO VALUE(barset-log-dir + xLogFile + ".txt").

ISLEM-BLOK:
REPEAT:
        
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

        FIND FIRST erp_detay3 WHERE erp_detay3.firma_kod = firma-kod AND erp_detay3.toplam_sure = xKayitId NO-ERROR.

        IF  NOT AVAILABLE erp_detay3 THEN DO:
            IslemSonucu = "Fason cikis bilgilerinde hata var! " + STRING(xKayitId).
            MESSAGE IslemSonucu SKIP "(erp_detay3)" VIEW-AS ALERT-BOX TITLE "Hata!".
            RETURN ERROR.
        END.

        DELETE erp_detay3.     
     
    END.  /*END TRAN */

    ASSIGN IslemSonucu = "ok".
  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */


OUTPUT CLOSE.  






