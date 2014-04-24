
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

        FIND FIRST irsaliye_master WHERE irsaliye_master.firma_kod = firma-kod AND irsaliye_master.kayit_no = xKayitId NO-ERROR.

        IF  NOT AVAILABLE irsaliye_master THEN DO:
            IslemSonucu = "Fason donus bilgilerinde hata var! " + STRING(xKayitId).
            MESSAGE IslemSonucu SKIP "(irsaliye_master)" VIEW-AS ALERT-BOX TITLE "Hata!".
            RETURN ERROR.
        END.

        DELETE irsaliye_master.     
     
    END.  /*END TRAN */

    ASSIGN IslemSonucu = "ok".
  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */


OUTPUT CLOSE.  






