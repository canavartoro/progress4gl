/*
12.07.2012 ArmaFiltre
Is emrinde kullanilan malzemeleri degistirmek icin
*/

ON FIND OF erp_detay2  OVERRIDE DO: END.
ON FIND OF erp_master  OVERRIDE DO: END.
ON FIND OF erp_recete  OVERRIDE DO: END.
ON WRITE OF erp_durus  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER IsEmriNo AS CHARACTER.
DEFINE INPUT PARAMETER MalzemeKod AS CHARACTER.
DEFINE INPUT PARAMETER MalzemeKod2 AS CHARACTER.
DEFINE INPUT PARAMETER ReceteKod AS CHARACTER.
DEFINE INPUT PARAMETER Tip AS LOGICAL.
DEFINE INPUT PARAMETER Birim AS CHARACTER.
DEFINE INPUT PARAMETER Miktar AS DECIMAL.
DEFINE INPUT PARAMETER Aciklama AS CHARACTER.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER.

DEFINE VARIABLE xlog-file AS CHARACTER.
DEFINE VARIABLE recete-tip AS LOGICAL.
DEFINE VARIABLE recete-kod AS CHARACTER.
DEFINE VARIABLE recete-birim AS CHARACTER FORMAT "X(10)".

ASSIGN xlog-file = barset-log-dir + "malzeme_" + IsEmriNo + ".txt". 
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(xlog-file).

DISPLAY firma-kod + "," + IsEmriNo + "," + Malzemekod + "," + Birim.
 
DEF BUFFER cmaster FOR recete_master.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:  

    IF MalzemeKod EQ MalzemeKod2 THEN DO:
        ASSIGN IslemSonucu = "Alternatif olarak ayni malzeme eklenemez! Farkli malzeme eklemelisiniz. " + MalzemeKod.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX.
        RETURN ERROR. /*LEAVE.*/
    END.

    FIND erp_master WHERE erp_master.firma_kod = firma-kod AND erp_master.isemri_no = IsEmriNo NO-LOCK.

    IF NOT AVAILABLE erp_master THEN DO:
        ASSIGN IslemSonucu = "Erp Master kaydi bulunamadi " + IsEmriNo.
        RETURN ERROR. /*LEAVE.*/
    END.

    /*kullanilan malzeme sorgulaniyor birim icin*/
    FIND stok_kart WHERE stok_kart.firma_kod = erp_master.firma_kod AND stok_kart.stok_kod = MalzemeKod2 NO-LOCK NO-ERROR.

    IF NOT AVAILABLE stok_kart THEN DO:
         ASSIGN IslemSonucu = "Stok kart bilgisi tanimli degil.." + MalzemeKod2.
         RETURN ERROR.
    END.

    recete-birim = IF stok_kart.recete_birim NE "" THEN stok_kart.recete_birim ELSE stok_kart.birim.
    DISPLAY recete-birim + "?" NO-LABEL.                                                                                        
    RELEASE stok_kart.

    FIND stok_kart WHERE stok_kart.firma_kod = erp_master.firma_kod AND stok_kart.stok_kod = erp_master.stok_kod NO-LOCK NO-ERROR.

    IF NOT AVAILABLE stok_kart THEN DO:
         ASSIGN IslemSonucu = "Stok kart bilgisi tanimli degil.." + erp_master.stok_kod.
         RETURN ERROR.
    END.

    FIND FIRST recete_master WHERE recete_master.firma_kod = erp_master.firma_kod AND recete_master.stok_kod = erp_master.stok_kod AND recete_master.recete_kod = erp_master.recete_kod NO-LOCK NO-ERROR.
    IF AVAILABLE recete_master AND NOT recete_master.isemrinde_degisiklik THEN DO:
    	ASSIGN IslemSonucu = "Ýþ Emri Üzerinde Malzeme Bilgisi Deðiþikliðe Ýzin Verilmemiþtir.." + recete_master.aciklama.
        RETURN NO-APPLY.
    END.

    FIND erp_recete WHERE erp_recete.firma_kod = firma-kod AND erp_recete.erp_masterno = erp_master.erp_masterno AND erp_recete.stok_kod = Malzemekod EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE erp_recete THEN DO:
        ASSIGN IslemSonucu = "Erp recete kaydi bulunamadi " + Malzemekod.
        RETURN ERROR. /*LEAVE.*/
    END.

    IF stok_kart.tip_kod NE "Hammadde"  THEN DO: 
    	ASSIGN recete-tip = FALSE.
    	FIND LAST cmaster WHERE cmaster.firma_kod = stok_kart.firma_kod AND cmaster.stok_kod = MalzemeKod2 AND cmaster.aktif_pasif = "Aktif" NO-LOCK NO-ERROR.
    	IF AVAILABLE cmaster THEN DO: 
    		ASSIGN recete-kod = cmaster.recete_kod.
    	END.
        ELSE DO:
    		ASSIGN recete-tip = TRUE recete-kod = "".
        END.
    END.

    DISPLAY "Recete Kod:" + recete-kod + ", Tip:" + STRING(recete-tip).

    ASSIGN
        erp_recete.tip = recete-tip
        erp_recete.stok_kod = MalzemeKod2
        erp_recete.recete_kod = recete-kod
        erp_recete.dbirim = recete-birim
        /*erp_recete.dbirim = Birim*/
        erp_recete.miktar = Miktar
        erp_recete.aciklama = Aciklama.
    RELEASE erp_recete. 

END. /*DO END*/

ASSIGN IslemSonucu = "ok".
DISPLAY "Erp recete kaydi degistirildi " + Malzemekod.

OUTPUT CLOSE.

ON FIND OF erp_detay2 REVERT.
ON FIND OF erp_master REVERT.
ON FIND OF erp_recete REVERT.
ON WRITE OF erp_durus REVERT.
