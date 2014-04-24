      
FOR EACH erp_iscilik WHERE erp_iscilik.firma_kod = erp_detay2.firma_kod AND 
    erp_iscilik.erp_masterno = erp_detay2.erp_masterno AND erp_iscilik.erp_detayno = erp_detay2.erp_detayno AND
    erp_iscilik.erp_detayno2  = erp_detay2.erp_detayno2 ON ERROR UNDO, RETURN ERROR:
    
    FIND FIRST xis_table WHERE xis_table.personel_kod = erp_iscilik.personel_kod NO-ERROR.
        
    IF NOT AVAILABLE xis_table THEN DO:
        DELETE erp_iscilik. /* iscilik uyumda var bizde yoksa silinecek! varsa guncellenecek.*/
        
    END.
    ELSE DO:
        ASSIGN
            erp_iscilik.firma_kod     = erp_detay2.firma_kod 
            erp_iscilik.erp_detayno   = erp_detay2.erp_detayno
            erp_iscilik.erp_detayno2  = erp_detay2.erp_detayno2
            erp_iscilik.erp_masterno  = erp_detay2.erp_masterno
            erp_iscilik.bas_zaman     = REPLACE(xis_table.bas_saati, ":", "")  
            erp_iscilik.bitis_zaman   = REPLACE(xis_table.bit_saati, ":", "")
            erp_iscilik.bas_tarih     = erp_detay2.bas_tarih
            erp_iscilik.calisma_tarih = erp_detay2.bitis_tarih
            erp_iscilik.personel_kod  = xis_table.personel_kod
            erp_iscilik.aciklama      = xis_table.aciklama.
            DELETE xis_table.
    END.
END.

FOR EACH xis_table ON ERROR UNDO, RETURN ERROR:
	CREATE erp_iscilik.
	ASSIGN 
		erp_iscilik.firma_kod     = erp_detay2.firma_kod 
        erp_iscilik.erp_masterno  = erp_detay2.erp_masterno
        erp_iscilik.erp_detayno   = erp_detay2.erp_detayno
        erp_iscilik.erp_detayno2  = erp_detay2.erp_detayno2
        erp_iscilik.bas_zaman     = REPLACE(xis_table.bas_saati, ":", "")  
        erp_iscilik.bitis_zaman   = REPLACE(xis_table.bit_saati, ":", "")
        erp_iscilik.bas_tarih     = erp_detay2.bas_tarih
        erp_iscilik.calisma_tarih = erp_detay2.bitis_tarih
        erp_iscilik.personel_kod  = xis_table.personel_kod
        erp_iscilik.aciklama      = xis_table.aciklama.
		RELEASE erp_iscilik.
END.

