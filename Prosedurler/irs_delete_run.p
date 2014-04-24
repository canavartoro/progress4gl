/*********************************************************************************
Siparissiz irsaliye silmek için yazýlmýþtýr
                          < Canavar.Toro >
 10 Ocak 2011 Pazartesi   14:46
                    Hamidiye

*********************************************************************************/

ON FIND OF irsaliye_master  OVERRIDE DO: END.
ON FIND OF irsaliye_detay  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

/***************   local variable   ************************/

DEF VAR xlog-file AS CHARACTER.
DEF VAR xfile-line AS CHARACTER.

/***************   giriþ parametreleri   ************************/
DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER bno  AS CHARACTER.
DEFINE OUTPUT PARAMETER barset_belge AS CHARACTER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.
DEFINE OUTPUT PARAMETER rmaster_no AS INT FORMAT ">>>,>>>,>>>,>>9".
DEFINE INPUT PARAMETER master_no AS INT.

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + bno + "del.txt").

ISLEM-BLOK:
REPEAT:

DO TRANSACTION ON ERROR UNDO , RETURN ERROR :

FOR EACH entegre.irsaliye_master 
        WHERE irsaliye_master.firma_kod EQ firma-kod 
                AND irsaliye_master.fatura_durum = FALSE 
                AND irsaliye_master.irsaliye_masterno = master_no
                /*AND recid(entegre.irsaliye_master) EQ master_no*/  EXCLUSIVE-LOCK ON ERROR UNDO , RETURN ERROR:    
    rmaster_no = recid(entegre.irsaliye_master).
        DELETE irsaliye_master.
END.

FOR EACH stok_master WHERE stok_master.firma_kod = firma-kod AND stok_master.belge_no = bno EXCLUSIVE-LOCK ON ERROR UNDO , RETURN ERROR:
        
DELETE stok_master.
    
END.
    
END.  /*END TRAN */

DISPLAY "Silinen kayýt:" STRING(bno).
  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */

OUTPUT CLOSE.  /* çýkýþ dosyasýný kapat */

INPUT FROM VALUE(SEARCH(barset-log-dir + bno + "del.txt")) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
  SET islem_sonucu = islem_sonucu + xfile-line.
  END.
INPUT CLOSE.


ON FIND OF irsaliye_master REVERT.
ON FIND OF irsaliye_detay REVERT.



