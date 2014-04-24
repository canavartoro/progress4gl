
FOR EACH hurda_detay WHERE hurda_detay.firma_kod = erp_detay2.firma_kod AND hurda_detay.erp_masterno = erp_detay2.erp_masterno AND 
		hurda_detay.erp_detayno = erp_detay2.erp_detayno AND hurda_detay.erp_detayno2 = erp_detay2.erp_detayno2 ON ERROR UNDO, RETURN ERROR:

	FIND FIRST xhur_table WHERE xhur_table.hurda_kod = hurda_detay.hurda_kod AND xhur_table.hurda_skod = hurda_detay.stok_kod NO-ERROR.

	IF AVAILABLE xhur_table THEN DO:
		ASSIGN                                       
			hurda_detay.dbirim        = xhur_table.hurda_sbirim
            hurda_detay.dmiktar       = xhur_table.miktar
            hurda_detay.aciklama      = xhur_table.aciklama
            hurda_detay.parti_kod     = xhur_table.parti_kod
            hurda_detay.diger_depo    = xhur_table.diger_depo.
                                     
		FIND ydetay WHERE ydetay.firma_kod = erp_detay2.firma_kod AND 
			ydetay.erp_masterno = erp_detay2.erp_masterno AND 
			ydetay.erp_detayno = erp_detay2.erp_detayno AND 
			ydetay.erp_detayno2 = erp_detay2.erp_detayno2 NO-ERROR.
                                     
		FIND ham_detay WHERE ham_detay.firma_kod = firma-kod AND 
			ham_detay.ham_masterno = erp_detay2.ham_masterno AND 
			ham_detay.ham_detayno = hurda_detay.hurda_detayno AND 
			ham_detay.stok_kod = hurda_detay.stok_kod NO-ERROR.
                                     
		IF AVAILABLE ham_detay THEN DO:
			ON DELETE OF ham_detay OVERRIDE DO: END.    
			DELETE ham_detay.
            ON DELETE OF ham_detay REVERT.
			hurda_detay.artirma = FALSE.
		END.

		ASSIGN 
			ydetay.hurda_miktar  = 0
			ydetay.hurda_miktar2 = 0
			ydetay.entegre_yap   = FALSE.
                                     
		IF AVAILABLE ydetay THEN ydetay.entegre_yap = TRUE.
		RELEASE ydetay.
		DELETE xhur_table.
	END. /*IF AVAILABLE xhur_table*/
	ELSE DO:
                                 
		FOR EACH stok_master WHERE stok_master.firma_kod = firma-kod AND stok_master.belge_no = erp_detay2.isemri_no AND
			stok_master.kaynak_masterno = INT(erp_detay2.erp_detayno2) AND stok_master.kaynak_prog2 = "Hurda" AND 
			stok_master.kaynak_prog3 = "Stok" ON ERROR UNDO, RETURN ERROR:
			DELETE stok_master.
		END.
		DELETE hurda_detay.
	END.
END. /*FOR EACH hurda_detay*/

FOR EACH  xhur_table ON ERROR UNDO, RETURN ERROR:  

	IF xhur_table.hurda_kod EQ "" THEN DO:
		MESSAGE "Hurda Nedeni Boþ Geçilemez." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
		RETURN ERROR.
	END.

	FIND hurda_tip WHERE hurda_tip.firma_kod = firma-kod AND hurda_tip.hurda_kod = xhur_table.hurda_kod NO-LOCK NO-ERROR.
	IF NOT AVAILABLE hurda_tip THEN DO:
		MESSAGE "Hurda Nedeni Tanýmlý Deðildir." xhur_table.hurda_kod SKIP VIEW-AS ALERT-BOX TITLE "H a t a...".
		RETURN ERROR.
	END.  

	IF AVAIL erp_detay2 THEN DO:
		CREATE hurda_detay.
		ASSIGN                   
			hurda_detay.firma_kod     = erp_detay2.firma_kod          
            hurda_detay.erp_masterno  = erp_detay2.erp_masterno   
            hurda_detay.erp_detayno   = erp_detay2.erp_detayno    
            hurda_detay.erp_detayno2  = erp_detay2.erp_detayno2   
            hurda_detay.istasyon_kod  = erp_detay2.istasyon_kod2  
            hurda_detay.isemri_no     = erp_detay2.isemri_no      
            hurda_detay.operasyon_kod = erp_detay2.operasyon_kod
            hurda_detay.stok_kod      = xhur_table.hurda_skod
            hurda_detay.dbirim        = xhur_table.hurda_sbirim
            hurda_detay.depo_kod      = erp_detay2.depo_kod
            hurda_detay.dmiktar       = xhur_table.miktar
            hurda_detay.hurda_kod     = xhur_table.hurda_kod
            hurda_detay.aciklama      = xhur_table.aciklama
            hurda_detay.parti_kod     = xhur_table.parti_kod
            hurda_detay.diger_depo    = xhur_table.diger_depo.
	END.

	FIND ydetay WHERE ydetay.firma_kod = erp_detay2.firma_kod AND ydetay.erp_masterno = erp_detay2.erp_masterno AND ydetay.erp_detayno = erp_detay2.erp_detayno AND ydetay.erp_detayno2 = erp_detay2.erp_detayno2 NO-ERROR.
	FIND ham_detay WHERE ham_detay.firma_kod = firma-kod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND ham_detay.ham_detayno = hurda_detay.hurda_detayno AND ham_detay.stok_kod = hurda_detay.stok_kod NO-ERROR.

	IF AVAILABLE ham_detay THEN DO:
		ON DELETE OF ham_detay OVERRIDE DO: END.
		DELETE ham_detay.
        ON DELETE OF ham_detay REVERT.
		hurda_detay.artirma = FALSE.
	END.

	ASSIGN 
		ydetay.hurda_miktar  = 0
		ydetay.hurda_miktar2 = 0
		ydetay.entegre_yap   = FALSE.
		IF AVAILABLE ydetay THEN ydetay.entegre_yap = TRUE.
		RELEASE ydetay.                                                    
END.
