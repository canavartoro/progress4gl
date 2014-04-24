
{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

    /***************   local variable   ************************/

DEF VAR xlog-file AS CHARACTER.
DEF VAR xfile-line AS CHARACTER.

/***************   giris parametreleri   ************************/

DEFINE INPUT PARAMETER fkod  AS CHARACTER.
DEFINE INPUT PARAMETER ukod  AS CHARACTER.
DEFINE INPUT PARAMETER logfile AS CHARACTER.
DEFINE INPUT PARAMETER master_no AS RECID.
DEFINE INPUT PARAMETER kayitid AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + logfile + ".txt").

ISLEM-BLOK:
REPEAT:
        
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

        FOR EACH erp_detay2 WHERE erp_detay2.firma_kod = firma-kod AND erp_detay2.kayit_id = STRING(kayitid) ON ERROR UNDO, RETURN ERROR:

            IF  NOT AVAILABLE erp_detay2 THEN DO:        
                islem_sonucu = "Uretim bilgilerinde hata var! " + STRING(kayitid).
                MESSAGE islem_sonucu SKIP "(erp_detay2)" VIEW-AS ALERT-BOX TITLE "Hata!".
                RETURN ERROR.
            END.

            FOR EACH stok_master WHERE stok_master.firma_kod = firma-kod AND stok_master.belge_no = erp_detay2.isemri_no AND
                stok_master.kaynak_masterno = INT(erp_detay2.erp_detayno2) AND stok_master.kaynak_prog2 = "Hurda" AND 
                stok_master.kaynak_prog3 = "Stok" ON ERROR UNDO, RETURN ERROR:
                DELETE stok_master.
            END.

             DELETE erp_detay2.

        END.

        /*FIND erp_detay2 WHERE RECID(erp_detay2) = master_no OR erp_detay2.kayit_id = STRING(kayitid) EXCLUSIVE-LOCK NO-ERROR NO-WAIT. 
        
        IF  NOT AVAILABLE erp_detay2 THEN DO:        
            islem_sonucu = "Uretim bilgilerinde hata var! " + STRING(kayitid).
            MESSAGE islem_sonucu SKIP "(erp_detay2)" VIEW-AS ALERT-BOX TITLE "Hata!".
            RETURN ERROR.
        END.

        FOR EACH stok_master WHERE stok_master.firma_kod = firma-kod AND stok_master.belge_no = erp_detay2.isemri_no AND
            stok_master.kaynak_masterno = INT(erp_detay2.erp_detayno2) AND stok_master.kaynak_prog2 = "Hurda" AND 
            stok_master.kaynak_prog3 = "Stok" ON ERROR UNDO, RETURN ERROR:
            DELETE stok_master.
        END.


        DELETE erp_detay2.*/
     
    END.  /*END TRAN */

  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */


OUTPUT CLOSE.  


/*
INPUT FROM VALUE(SEARCH(xlog-file)) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
  SET islem_sonucu = islem_sonucu + xfile-line.
  END.
INPUT CLOSE.*/


/*OS-DELETE VALUE("C:\webo" + belgeno + ".txt") NO-ERROR.*/



