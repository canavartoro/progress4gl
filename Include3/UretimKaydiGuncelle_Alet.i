
FOR EACH erp_kalip WHERE erp_kalip.firma_kod = erp_detay2.firma_kod AND erp_kalip.erp_masterno = erp_detay2.erp_masterno AND
               erp_kalip.erp_detayno = erp_detay2.erp_detayno AND erp_kalip.erp_detayno2 = erp_detay2.erp_detayno2 ON ERROR UNDO, RETURN ERROR:

	FIND FIRST xalet_table WHERE xalet_table.platform_kod = erp_kalip.platform_kod NO-ERROR.
	IF NOT AVAILABLE xalet_table THEN DO:
		DELETE erp_kalip.
	END.
	ELSE DO:
		ASSIGN 
			erp_kalip.platform_kod = xalet_table.platform_kod
			erp_kalip.platform_ad = xalet_table.platform_ad.
			DELETE xalet_table.
	END.
END.

FOR EACH xalet_table ON ERROR UNDO, RETURN ERROR:

	CREATE erp_kalip.
	ASSIGN 
		erp_kalip.firma_kod = erp_detay2.firma_kod
        erp_kalip.erp_masterno = erp_detay2.erp_masterno
        erp_kalip.erp_detayno = erp_detay2.erp_detayno
        erp_kalip.erp_detayno2 = erp_detay2.erp_detayno2
        erp_kalip.platform_kod = xalet_table.platform_kod
        erp_kalip.platform_ad = xalet_table.platform_ad.
		RELEASE erp_kalip.
END.
