

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
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER INITIAL 0 NO-UNDO.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = xFirmaKod.
ASSIGN user-kod = xUserKod.

OUTPUT TO VALUE(barset-log-dir + xLogFile + ".txt").

ISLEM-BLOK:
REPEAT:
        
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

        FOR EACH stok_master WHERE RECID(stok_master) = xKayitId ON ERROR UNDO, RETURN ERROR:
            DELETE stok_master.
            DetaySatir = DetaySatir + 1.
        END.

        IF  DetaySatir < 1 THEN DO:
            IslemSonucu = "Belge bilgilerinde hata var! (stok_master) Belge erpde bulunamadi! " + STRING(xKayitId).
            MESSAGE IslemSonucu VIEW-AS ALERT-BOX TITLE "Hata!".
            RETURN ERROR.
        END.   
     
    END.  /*END TRAN */

    ASSIGN IslemSonucu = "ok".
  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */


OUTPUT CLOSE.  







